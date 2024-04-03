#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
"""Filters and labels execution regions for visualization.

This script takes a JSON file of performance metrics, as output by
[`join.py`][join], and generates another JSON, where the execution
regions are filtered and labeled for visualization, according to an
auxiliary region-of-interest (ROI) specification file (JSON format).
The specification file can be a Mako template to parameterize
certain parameters, such as the number of clusters in the system.
The output JSON can be passed to the [`visualize.py`][visualize]
script for visualization.

Check out `test_data/data.json` and `test_data/spec.json` for an
example input and specification file which can be fed as input to the
tool respectively. The corresponding output is contained in
`test_data/roi.json`.
"""

import argparse
import json
import json5
from mako.template import Template
import sys


def format_roi(roi, label):
    return {
        "label": label,
        "tstart": roi["tstart"],
        "tend": roi["tend"],
        "attrs": {key: value for key, value in roi.items() if key not in ["tstart", "tend"]}
    }


def get_roi(data, thread, idx):
    thread_type, thread_idx = thread.split('_')
    thread_idx = int(thread_idx)
    try:
        thread_data = data[thread]
    except KeyError:
        raise KeyError(f"Nonexistent thread {thread}")
    if thread_type in ["hart", "dma"]:
        try:
            if thread_type == "hart":
                return thread_data[idx]
            elif thread_type == "dma":
                return thread_data["transfers"][idx]
        except IndexError:
            raise IndexError(f"Thread {thread} does not contain region {idx}")
    else:
        raise ValueError(f"Unsupported thread type {thread_type}")


def filter_and_label_rois(data, spec):
    output = {}
    # Iterate all threads in the rendered specification
    for thread_spec in spec:
        thread = thread_spec['thread']
        output_rois = []
        # Iterate all ROIs to keep for the current thread
        for roi in thread_spec['roi']:
            output_roi = format_roi(get_roi(data, thread, roi['idx']), roi['label'])
            output_rois.append(output_roi)
        # Add ROIs for current thread to output, if any
        if output_rois:
            output[thread] = output_rois
    return output


def load_json_inputs(input_path, spec_path, **kwargs):
    # Read input JSON
    with open(input_path, 'r') as f:
        data = json5.load(f)
    # Read and render specification template JSON
    with open(spec_path, 'r') as f:
        spec_template = Template(f.read())
        rendered_spec = spec_template.render(**kwargs)
        spec = json5.loads(rendered_spec)
    return data, spec


def main():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'input',
        help='Input JSON file')
    parser.add_argument(
        'spec',
        help='ROI specification file (JSON format)')
    parser.add_argument(
        '--cfg',
        help='Hardware configuration file used to render the specification file')
    parser.add_argument(
        '-o',
        '--output',
        nargs='?',
        default='roi.json',
        help='Output JSON file')
    args = parser.parse_args()

    # Load hardware configuration
    with open(args.cfg, 'r') as f:
        cfg = json5.load(f)

    # Read and render input files
    data, spec = load_json_inputs(args.input, args.spec, cfg=cfg)

    # Process inputs and generate output JSON
    output = filter_and_label_rois(data, spec)

    # Write output to file
    with open(args.output, 'w') as f:
        json.dump(output, f, indent=4)


if __name__ == '__main__':
    sys.exit(main())
