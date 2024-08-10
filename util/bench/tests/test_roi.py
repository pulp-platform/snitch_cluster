#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import json
from pathlib import Path
import pytest
from bench.roi import get_roi, format_roi, load_json_inputs, filter_and_label_rois

TEST_DATA_DIR = Path(__file__).resolve().parent / 'test_data'
INPUT_JSON = TEST_DATA_DIR / 'data.json'
SPEC_JSON = TEST_DATA_DIR / 'spec.json'
OUTPUT_JSON = TEST_DATA_DIR / 'roi.json'


def test_format_roi():
    label = "compute"
    roi = {
        "tstart": 1759.0,
        "tend": 6802.0,
        "fpss_fpu_occupancy": 0.006345429307951616,
        "total_ipc": 0.04501288915328178
    }
    formatted_roi = {
        "label": "compute",
        "tstart": 1759.0,
        "tend": 6802.0,
        "attrs": {
            "fpss_fpu_occupancy": 0.006345429307951616,
            "total_ipc": 0.04501288915328178
        },
    }
    assert format_roi(roi, label) == formatted_roi


@pytest.mark.parametrize("thread, idx, roi", [
    ('hart_0', 0, {
        "tstart": 1759.0,
        "tend": 6802.0,
        "fpss_fpu_occupancy": 0.006345429307951616,
        "total_ipc": 0.04501288915328178
    }),
    ('dma_9', 1, {
        "tstart": 3564,
        "tend": 3578,
        "bw": 1.1428571428571428
    })
])
def test_get_roi(thread, idx, roi):
    with open(INPUT_JSON, 'r') as f:
        data = json.load(f)
    assert get_roi(data, thread, idx) == roi


def test_filter_and_label_rois():
    data, spec = load_json_inputs(INPUT_JSON, SPEC_JSON, num_clusters=2)
    with open(OUTPUT_JSON, 'r') as f:
        output = json.load(f)
    assert filter_and_label_rois(data, spec) == output
