#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
import argparse
import sys
from pysynthutils import LintViolations


WAIVERS = [
    # unsigned argument passed to $unsigned system function
    'WRN_1024',
    # flop enable pin is constant
    'FlopEConst',
    # operand width mismatch across arithmetic/comparison operators
    'W116',
    # input declared but not read
    'W240',
    # instance output port left unconnected
    'W287b',
    # operand width mismatch across relational operators
    'W362',
    # signal assigned multiple times in the same always block
    'W415a',
    # based number literal contains don't-care (?), sim/synth mismatch risk
    'W467',
    # shift result wider than LHS truncates bits
    'W486',
    # variable assigned but never read
    'W528'
]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('report', help='Path to moresimple.rpt')
    args = parser.parse_args()

    # Parse report for violations
    df = LintViolations(args.report).df
    print(f'Read {len(df)} violations.')

    # Ignore all info messages (Severity == Info)
    df = df[df.severity != 'Info']
    print(f'Ignore info messages. {len(df)} messages remaining.')

    # Ignore overlapping conditions in decoder's unique case statement
    # (ignore SYNTH_12604 in snitch.sv and snitch_sequencer.sv)
    # TODO(colluca): do not ignore sequencer error
    df = df[~((df.rule == 'SYNTH_12604') &
              (df.file.str.contains(r'snitch(?:_sequencer)?\.sv')))]
    print(f'Ignore SYNTH_12604 in snitch and snitch_sequencer. {len(df)} messages remaining.')

    # Waive safe to ignore rules
    df = df[~df.rule.isin(WAIVERS)]
    print(f'Waive {", ".join(WAIVERS)}. {len(df)} messages remaining.')

    # Fail on remaining messages
    if len(df) > 0:
        print(f'FAIL: {len(df)} violation(s) found')
        # Print remaining messages
        for _, v in df.iterrows():
            print(f'  [{v.severity}] {v.rule}  {v.file}:{v.line}  {v.message}')
        sys.exit(1)
    print('PASS')


if __name__ == '__main__':
    main()
