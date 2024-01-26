#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Combines performance metrics from all threads into one JSON file.

This script takes the performance metrics from multiple cores or DMA
engines, in JSON format as dumped by the [`events.py`][events] or
[`gen_trace.py`][gen_trace] scripts, and merges them into a single
JSON file for global inspection and further processing.
"""

import sys
import argparse
import re
import json


FILENAME_REGEX = r'([a-z]+)_([0-9a-f]+)_perf.json'


def main():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-i',
        '--inputs',
        metavar='<inputs>',
        nargs='+',
        help='Input performance metric dumps')
    parser.add_argument(
        '-o',
        '--output',
        metavar='<output>',
        nargs='?',
        default='perf.json',
        help='Output JSON file')
    args = parser.parse_args()

    # Populate a list (one entry per hart) of dictionaries
    # enumerating all the performance metrics for each hart
    data = {}
    for filename in sorted(args.inputs):

        # Get thread ID and type (DMA or hart) from filename
        match = re.search(FILENAME_REGEX, filename)
        typ = match.group(1)
        idx = int(match.group(2), base=16)

        # Populate dictionary of metrics for the current hart
        with open(filename, 'r') as f:
            data[f'{typ}_{idx}'] = json.load(f)

    # Export data
    with open(args.output, 'w') as f:
        json.dump(data, f, indent=4)


if __name__ == '__main__':
    sys.exit(main())
