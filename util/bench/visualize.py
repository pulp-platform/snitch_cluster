#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Translates a ROI JSON for visualization in Chrome.

This script translates a JSON file, in the format produced by
[`roi.py`][roi], to a JSON file adhering to the syntax required by
Chrome's
[Trace-Viewer](https://github.com/catapult-project/catapult/tree/master/tracing).

The output can be visualized in a Chrome browser: go to the
`about:tracing` URL and load the JSON file.

This script can be compared to `trace/tracevis.py`, but instead of
visualizing individual instructions, it represents entire execution
regions as a whole.
"""

import argparse
import json
from pathlib import Path
import sys

sys.path.append(str(Path(__file__).parent / '../trace'))
import tracevis  # noqa: E402


# Converts nanoseconds to microseconds
def us(ns):
    return ns / 1000


def main():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'input',
        metavar='<input>',
        help='Input JSON file')
    parser.add_argument(
        '--traces',
        metavar='<trace>',
        nargs='*',
        help='Simulation traces to process')
    parser.add_argument(
        '--elf',
        nargs='?',
        help='ELF from which the traces were generated')
    parser.add_argument(
        '-o',
        '--output',
        metavar='<json>',
        nargs='?',
        default='trace.json',
        help='Output JSON file')
    parser.add_argument(
        '--addr2line',
        metavar='<path>',
        nargs='?',
        default='addr2line',
        help='`addr2line` binary to use for parsing')
    args = parser.parse_args()

    # TraceViewer events
    events = []

    # Add a dummy instant event to mark time 0.
    # This is to avoid that the events are shifted from
    # their actual start times, as done to align the first event
    # to time 0.
    event = {'name': 'zero',
             'ph':   'I',  # Instant event type
             'ts':   0,
             's':    'g'  # Global scope
             }
    events.append(event)

    # Read JSON contents
    with open(args.input) as f:
        data = json.load(f)

    # Iterate threads
    for thread, regions in data.items():

        # Iterate execution regions for current thread
        for region in regions:

            # Create TraceViewer event
            ts = int(region['tstart'])
            dur = int(region['tend']) - ts
            event = {
                'name': region['label'],
                'ph': "X",  # Complete event type
                'ts': us(ts),
                'dur': us(dur),
                'pid': 0,
                'tid': thread,
                'args': region['attrs']
            }
            events.append(event)

    # Optionally extract also instruction-level events
    # from the simulation traces
    if args.traces and args.elf:
        events += tracevis.parse_traces(args.traces, start=0, end=-1, fmt='snitch',
                                        addr2line=args.addr2line, use_time=True, pid=1,
                                        cache=True, elf=args.elf, collapse_call_stack=True)

    # Create TraceViewer JSON object
    tvobj = {}
    tvobj['traceEvents'] = events
    tvobj['displayTimeUnit'] = "ns"

    # Dump TraceViewer events to JSON file
    with open(args.output, 'w') as f:
        json.dump(tvobj, f, indent=4)


if __name__ == '__main__':
    sys.exit(main())
