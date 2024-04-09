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
import re


def unzip(ls):
    return zip(*ls)


def format_function_name(name):
    if name == '??':
        return 'unknown function'
    return name


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
        output = self.raw.split('\n')

        if self.toolchain == 'llvm':
            functions = output[::6]
            if functions[0] == '??':
                # If function is unknown, there will be no "Function start filename"
                # and "Function start line" fields
                filepaths = output[1:2]
                lines = output[2:3]
                cols = output[3:4]
            else:
                filepaths = output[1::6]
                lines = output[4::6]
                cols = output[5::6]
            filepaths = [re.search(r"Filename: (.+)$", filepath).group(1) for filepath in filepaths]
            lines = [re.search(r"Line: (\d+)", line).group(1) for line in lines]
            cols = [re.search(r"Column: (\d+)", col).group(1) for col in cols]
            cols = [int(col) if col != '0' else None for col in cols]
        else:
            functions = output[::2]
            filepaths, lines = unzip([o.split(':') for o in output[1::2]])
            cols = [None] * len(lines)
        functions = map(format_function_name, functions)
        lines = [int(line) if line != '0' else None for line in lines]

        stack = zip(functions, filepaths, lines, cols)
        stack = [{'func': s[0], 'file': s[1], 'line': s[2], 'col': s[3]} for s in stack]
        # Do not create stack if compiler was unable to associate a line number to the address
        return stack if stack[0]['line'] is not None else None

    def function_stack_string(self, short=True):
        s = ''
        indent = ''
        stack = self.function_stack()
        if stack is not None:
            stack = reversed(self.function_stack())
            for i, level in enumerate(stack):
                func, file, line, col = level.values()
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
                return src[line-1]

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
        cmd = f'{self.a2l} -e {self.elf} -f -i {addr:x}'
        if self.toolchain == 'llvm':
            cmd += ' --verbose'
        return Addr2LineOutput(os.popen(cmd).read(), toolchain=self.toolchain)
