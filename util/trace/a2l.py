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


def unzip(ls):
    return zip(*ls)


def format_function_name(name):
    if name == '??':
        return 'unknown function'
    return name


def format_line(num):
    if num == '?':
        return -1
    return int(num)


class Addr2LineOutput:

    indent_unit = '  '

    def __init__(self, raw):
        self.raw = raw

    # Returns the function stack of the current line.
    # If there was no function inlining, then the function stack
    # includes only the function the line belongs to.
    # If there was inlining, it includes all functions the line
    # belonged to after inlining the previous, up to (and including)
    # the last function which was not inlined.
    def function_stack(self):
        output = self.raw.split('\n')

        functions = output[::2]
        filepaths, lines = unzip([o.split(':') for o in output[1::2]])

        functions = map(format_function_name, functions)
        lines = map(format_line, lines)

        stack = zip(functions, filepaths, lines)
        stack = [{'func': s[0], 'file': s[1], 'line': s[2]} for s in stack]
        return stack

    def function_stack_string(self, short=True):
        stack = reversed(self.function_stack())
        s = ''
        indent = ''
        for i, level in enumerate(stack):
            func, file, line = level.values()
            if short:
                file = Path(file).name
            indent = self.indent_unit * i
            s += f'{indent}{func} ({file}:{line})\n'
        return s

    def line(self):
        file, line = itemgetter('file', 'line')(self.function_stack()[0])

        # Open source file
        src = []
        try:
            with open(file, 'r') as f:
                src = [x.strip() for x in f.readlines()]
        except OSError:
            src = []

        # Extract line
        if src and line >= 0:
            return src[line-1]
        else:
            return ''

    def __str__(self):
        s = self.function_stack_string()
        if self.line():
            indent = self.indent_unit * len(s.strip().split('\n'))
            s += f'{indent}{self.line()}'
        return s


class Elf:

    def __init__(self, elf, a2l_binary='addr2line'):
        self.elf = Path(elf)
        self.a2l = a2l_binary

        assert self.elf.exists(), f'File not found {self.elf}'

    @lru_cache(maxsize=1024)
    def addr2line(self, addr):
        if type(addr) == str:
            addr = int(addr, 16)
        cmd = f'{self.a2l} -e {self.elf} -f -i {addr:x}'
        return Addr2LineOutput(os.popen(cmd).read())
