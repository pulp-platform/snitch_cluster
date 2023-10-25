#!/usr/bin/env python3

# Copyright 2021 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# This script parses the traces generated by Snitch and creates an annotated
# trace that includes code sources
# Example output:
#     ; snrt_hartid (team.c:14)
#     ;  in snrt_cluster_core_idx (team.c:47)
#     ;  in main (event_unit.c:21)
#     ;  asm("csrr %0, mhartid" : "=r"(hartid));
#           80000048  x13=0000000a                            # csrr    a3, mhartid
#
# If the -d/--diff option is specified, it instead outputs a (fictitious) diff
# file which allows to visualize the trace-source correlation side-by-side
# instead of interleaved.
# For neater visualization, feed the diff file into a diff visualization tool e.g.:
# kompare -o <diff_file>

import sys
import os
import re
import argparse
import a2l

# Argument parsing
parser = argparse.ArgumentParser('annotate', allow_abbrev=True)
parser.add_argument(
    'elf',
    metavar='<elf>',
    help='The binary executed to generate the annotation',
)
parser.add_argument(
    'trace',
    metavar='<trace>',
    help='The trace file to annotate')
parser.add_argument(
    '-o',
    '--output',
    metavar='<annotated>',
    nargs='?',
    default='annotated.s',
    help='Output annotated trace')
parser.add_argument(
    '--addr2line',
    metavar='<path>',
    nargs='?',
    default='llvm-addr2line',
    help='`addr2line` binary to use for parsing')
parser.add_argument(
    '-d',
    '--diff',
    action='store_true',
    default=False,
    help='When true outputs a diff file instead of the annotated trace')
parser.add_argument(
    '-s',
    '--start',
    metavar='<line>',
    nargs='?',
    type=int,
    default=0,
    help='First line to parse, zero-based and inclusive')
parser.add_argument(
    '-e',
    '--end',
    metavar='<line>',
    nargs='?',
    type=int,
    default=-1,
    help='Last line to parse, zero-based and inclusive')
parser.add_argument(
    '--keep-time',
    action='store_true',
    help='Preserve simulation time in trace')
parser.add_argument(
    '-q',
    '--quiet',
    action='store_true',
    help='Quiet output')

args = parser.parse_args()

elf_file = args.elf
trace = args.trace
output = args.output
diff = args.diff
addr2line = args.addr2line
quiet = args.quiet
keep_time = args.keep_time

if not quiet:
    print('elf:', elf_file, file=sys.stderr)
    print('trace:', trace, file=sys.stderr)
    print('output:', output, file=sys.stderr)
    print('diff:', diff, file=sys.stderr)
    print('addr2line:', addr2line, file=sys.stderr)
    print('keep_time:', keep_time, file=sys.stderr)

of = open(output, 'w')

if not quiet:
    print(f' annotating: {output}    ', end='')

# buffer source files
src_files = {}
trace_start_col = -1


# helper functions to assemble diff output
def format_call(level, call):
    funcname = a2l.format_function_name(call[0])
    if level == 0:
        return f'{funcname} ({call[1]})\n'
    else:
        indentation = '  ' * (level - 1)
        return f'{indentation}{call[4]}: inlined call to {funcname} ({call[1]})\n'


def assemble_call_stack(funs, file_paths, file_lines):
    call_stack = list(zip(funs,                       # func name
                          file_paths,                 # func path
                          file_lines,                 # func line
                          [*(file_paths[1:]), '??'],  # caller path
                          [*(file_lines[1:]), 0]))    # call line
    call_stack.reverse()
    return call_stack


def matching_call_stack_levels(cstack1, cstack2):
    matching_levels = 0
    for i, call in enumerate(cstack1):
        # Compare each call: i.e. called function, caller file and call line
        if i < len(cstack2) and \
                call[0] == cstack2[i][0] and \
                call[1] == cstack2[i][1] and \
                call[3] == cstack2[i][3] and \
                call[4] == cstack2[i][4]:
            matching_levels += 1
        else:
            return matching_levels
    return matching_levels


def matching_source_line(cstack1, cstack2):
    # Two trace lines match the same source line evaluation
    # if the corresponding source line is the same *and* also
    # the call stack which led that source line
    try:
        matched_src_line = cstack1[-1][2] == cstack2[-1][2]
    except IndexError:
        matched_src_line = False
    matched_call_stack = matching_call_stack_levels(cstack1, cstack2) == len(next_call_stack)
    return matched_src_line and matched_call_stack


def dump_hunk(hunk_tstart, hunk_sstart, hunk_trace, hunk_source):
    hunk_tlen = len(hunk_trace.splitlines())
    hunk_slen = len(hunk_source.splitlines())
    hunk_header = f'@@ -{hunk_tstart},{hunk_tlen} +{hunk_sstart},{hunk_slen} @@\n'
    of.write(f'{hunk_header}{hunk_trace}{hunk_source}')


# Open ELF file for addr2line processing
elf = a2l.Elf(elf_file, addr2line)

# core functionality
with open(trace, 'r') as f:

    # get modified timestamp of trace to compare with source files
    trace_timestamp = os.path.getmtime(trace)

    last = ''
    if diff:
        of.write('--- trace\n+++ source\n')
        call_stack = []
        hunk_trace = ''
        hunk_source = ''
        hunk_tstart = 1
        hunk_sstart = 1

    # Filter lines before args.start
    trace_lines = f.readlines()[args.start:]
    # Filter lines after args.end (requires special care to make the bound inclusive)
    end = args.end + 1
    if end == 0:
        end = len(trace_lines)
    trace_lines = trace_lines[:end]

    tot_lines = len(trace_lines)
    last_prog = 0
    for lino, line in enumerate(trace_lines):

        # Split trace line in columns
        cols = re.split(r" +", line.strip())
        # Get simulation time from first column
        time = cols[0]
        # RTL traces might not contain a PC on each line
        try:
            # Get address from PC column
            addr = cols[3]
            # Find index of first character in PC
            if trace_start_col < 0:
                trace_start_col = line.find(addr)
            # Get addr2line information and format it as an assembly comment
            a2l_output = elf.addr2line(addr)
            annot = '\n'.join([f'#; {line}' for line in str(a2l_output).split('\n')])
        except (ValueError, IndexError):
            a2l_output = None
            annot = ''
            if keep_time:
                filtered_line = f'{time:>12}    {line[trace_start_col:]}'
            else:
                filtered_line = f'{line[trace_start_col:]}'
            if diff:
                hunk_trace += f'-{filtered_line}'
            else:
                of.write(f'      {filtered_line}')
            continue

        # Filter trace line for printing
        if keep_time:
            filtered_line = f'{time:>12}    {line[trace_start_col:]}'
        else:
            filtered_line = f'{line[trace_start_col:]}'

        # Print diff
        if diff:
            # Compare current and previous call stacks
            if a2l_output:
                funs, files, lines = zip(*[level.values() for level in a2l_output.function_stack()])
            else:
                funs = files = lines = []
            next_call_stack = assemble_call_stack(funs, files, lines)
            matching_cstack_levels = matching_call_stack_levels(next_call_stack, call_stack)
            matching_src_line = matching_source_line(next_call_stack, call_stack)

            # If this instruction does not map to the same evaluation of the source line
            # of the last instruction, we finalize and dump the previous hunk
            if hunk_trace and not matching_src_line:
                dump_hunk(hunk_tstart, hunk_sstart, hunk_trace, hunk_source)
                # Initialize next hunk
                hunk_tstart += len(hunk_trace.splitlines())
                hunk_sstart += len(hunk_source.splitlines())
                hunk_trace = ''
                hunk_source = ''

            # Update state for next iteration
            call_stack = next_call_stack

            # Assemble source part of hunk
            src_line = a2l_output.line()
            if len(funs) and src_line:
                for i, call in enumerate(call_stack):
                    if i >= matching_cstack_levels:
                        hunk_source += f'+{format_call(i, call)}'
                if not matching_src_line:
                    indentation = '  ' * (len(call_stack) - 1)
                    hunk_source += f'+{indentation}{lines[0]}: {src_line}\n'

            # Assemble trace part of hunk
            hunk_trace += f'-{filtered_line}'

        # Default: print trace interleaved with source annotations
        else:
            if len(annot) and annot != last:
                of.write(annot+'\n')
            of.write(f'      {filtered_line}')
            last = annot

        # very simple progress
        if not quiet:
            prog = int(100.0 / tot_lines * lino)
            if prog > last_prog:
                last_prog = prog
                sys.stdout.write(f'\b\b\b\b{prog:3d}%')
                sys.stdout.flush()

    # Dump last hunk
    if diff:
        dump_hunk(hunk_tstart, hunk_sstart, hunk_trace, hunk_source)

if not quiet:
    print(' done')
