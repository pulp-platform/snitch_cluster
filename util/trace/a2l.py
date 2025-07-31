#!/usr/bin/env python3

# Copyright 2021 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
#
# Utilities for common tasks involving addr2line

import os
from pathlib import Path
from functools import lru_cache
from operator import itemgetter
import traceback
import sys
import re


def unzip(ls):
    return zip(*ls)


class Addr2LineOutput:

    indent_unit = '  '

    def __init__(self, raw, toolchain='llvm'):
        self.raw = raw
        self.toolchain = toolchain

    # Returns the function stack of the current line.
    # If there was no function inlining, then the function stack
    # includes only the function the line belongs to.
    # If there was inlining, it includes all functions the line
    # belonged to after inlining the previous, up to (and including)
    # the last function which was not inlined.
    def function_stack(self):
        if self.toolchain == 'llvm':
            # Define a regex pattern to capture relevant data. The function start filename
            # and start line are optional, so they are enclosed in ()?.
            pattern = re.compile(
                r'^(?P<func>.+?)\s*'
                r'Filename:\s*(?P<file>[^\n]+)\s*'
                r'(Function start filename:\s*(?P<func_start_filename>[^\n]+)\s*'
                r'Function start line:\s*(?P<func_start_line>\d+)\s*)?'
                r'Line:\s*(?P<line>\d+)\s*'
                r'Column:\s*(?P<col>\d+)',
                re.MULTILINE)
        else:
            # Define a regex pattern to match function names, file paths and line numbers
            pattern = re.compile(
                r"^(?P<func>.+)\n(?P<file>.+):(?P<line>\d+)(?: \(discriminator \d+\))?$",
                re.MULTILINE)

        # Find all matches and organize them into a list of dictionaries
        stack = [match.groupdict() for match in pattern.finditer(self.raw)]

        # Format stack entries
        def format_stack_entry(entry):
            func, line, col = [entry.get(key, None) for key in ['func', 'line', 'col']]
            # Rename unknown functions
            if func == '??':
                entry['func'] = 'unknown function'
            else:
                # Strip anything contained in parentheses to remove the arguments
                # in the function signature, which are a result of demangling
                entry['func'] = re.sub(r'\(.*\)', '', func).strip()
            # Add column key if missing and convert 0 line and cols to None
            for key, val in zip(['line', 'col'], [line, col]):
                if val is not None:
                    val = int(val)
                    if val == 0:
                        entry[key] = None
                    else:
                        entry[key] = val
                else:
                    entry[key] = val
            return entry
        stack = list(map(format_stack_entry, stack))
        # Do not create stack if compiler was unable to associate a line number to the address
        return stack if stack[0]['line'] is not None else None

    # Converts the function stack data structure into a string representation.
    def function_stack_string(self, short=True):
        s = ''
        indent = ''
        stack = self.function_stack()
        if stack is not None:
            stack = reversed(self.function_stack())
            for i, level in enumerate(stack):
                func, file, line, col = [level.get(key) for key in ["func", "file", "line", "col"]]
                if short:
                    file = Path(file).name
                indent = self.indent_unit * i
                s += f'{indent}{func} ({file}:{line}'
                if col is not None:
                    s += f':{col}'
                s += ')\n'
            # Remove final newline
            s = s[:-1]
        return s

    def line(self):
        if self.function_stack():
            file, line = itemgetter('file', 'line')(self.function_stack()[0])

            # Open source file
            src = []
            try:
                with open(file, 'r') as f:
                    src = [x for x in f.readlines()]
            except OSError:
                src = []

            # Extract line
            if src and line is not None:
                try:
                    return src[line-1]
                except IndexError as e:
                    print(traceback.format_exc(), file=sys.stderr)
                    print(f'Cannot find line {line} in file {file}', file=sys.stderr)
                    raise e

    def __str__(self):
        s = ''
        stack = self.function_stack()
        if stack:
            col = stack[0]['col']
            s = self.function_stack_string()
            line = self.line()
            if line is not None:
                # Calculate indentation of original source line
                stripped_line = line.lstrip()
                orig_indent = len(line) - len(stripped_line)
                stripped_line = stripped_line.rstrip()
                # Calculate indentation to prepend to source line from the function stack string
                indent = self.indent_unit * len(s.strip().split('\n'))
                # Append source line to function stack string
                s += f'\n{indent}{stripped_line}'
                # Append a column indicator line
                if col is not None:
                    new_col = col - orig_indent + len(indent)
                    s += '\n' + ' ' * (new_col - 1) + '^'
        return s


class Elf:

    def __init__(self, elf, a2l_binary='addr2line'):
        self.elf = Path(elf)
        self.a2l = a2l_binary

        # We must distinguish between LLVM and GCC toolchains as the latter
        # does not support the `--verbose` flag
        if 'riscv64-unknown-elf-addr2line' in a2l_binary:
            self.toolchain = 'gcc'
        elif 'llvm-addr2line' in a2l_binary:
            self.toolchain = 'llvm'
        else:
            raise ValueError('addr2line binary expected to be either riscv64-unknown-elf-addr2line'
                             ' or llvm-addr2line')

        assert self.elf.exists(), f'File not found {self.elf}'

    @lru_cache(maxsize=1024)
    def addr2line(self, addr):
        if isinstance(addr, str):
            addr = int(addr, 16)
        cmd = f'{self.a2l} --exe {self.elf} --demangle --functions --inlines {addr:x}'
        if self.toolchain == 'llvm':
            cmd += ' --verbose'
        return Addr2LineOutput(os.popen(cmd).read(), toolchain=self.toolchain)
