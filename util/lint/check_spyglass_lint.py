#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
import argparse
import sys
from pysynthutils import LintViolations


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('report', help='Path to moresimple.rpt')
    parser.add_argument('--threshold', type=int, default=0)
    args = parser.parse_args()

    lv = LintViolations(args.report)
    violations = lv.filter(exclude_files='.bender')
    n = len(violations)

    for _, v in violations.iterrows():
        print(f'[{v.severity}] {v.rule}  {v.file}:{v.line}  {v.message}')
    print(f'\n{n} violation(s) outside .bender/ (threshold: {args.threshold})')

    if n > args.threshold:
        print('FAIL: threshold exceeded')
        sys.exit(1)
    print('PASS')


if __name__ == '__main__':
    main()
