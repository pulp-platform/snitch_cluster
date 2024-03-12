#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Tim Fischer <fischeti@iis.ee.ethz.ch>
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import argparse
import pathlib
import json5
import sys
import os
import torch

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
import data_utils  # noqa: E402
from data_utils import emit_license, \
                       format_struct_definition, format_array_definition, \
                       format_array_declaration, format_ifdef_wrapper  # noqa: E402

torch.manual_seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


def golden_model(ifmap, kernel):
    max_pool = torch.nn.MaxPool2d(kernel_size=kernel)
    return max_pool(ifmap)


def emit_header(**kwargs):

    in_channels = kwargs['channels']['in']
    in_height = kwargs['input_dim']['height']
    in_width = kwargs['input_dim']['width']
    kernel_size = kwargs['kernel_size']
    tile_ci = kwargs['tile_ci']
    prec = kwargs['prec']

    torch_type = data_utils.torch_type_from_precision_t(prec)
    ctype = data_utils.ctype_from_precision_t(prec)

    ifmap = torch.randn(1, in_channels, in_height, in_width, requires_grad=False, dtype=torch_type)
    ofmap = golden_model(ifmap, kernel_size)

    # convert from CHW to HWC format
    ifmap = ifmap.permute(0, 2, 3, 1)
    ofmap = ofmap.permute(0, 2, 3, 1)

    n, ih, iw, ci = ifmap.shape
    _, oh, ow, co = ofmap.shape

    ifmap = data_utils.flatten(ifmap)
    ofmap = data_utils.flatten(ofmap)

    ifmap_uid = 'ifmap'
    ofmap_uid = 'ofmap'

    layer_cfg = {
        'CO': co,
        'CI': ci,
        'IH': ih,
        'IW': iw,
        'OH': oh,
        'OW': ow,
        'FH': kernel_size,
        'FW': kernel_size,
        'tile_ci': tile_ci,
        'ifmap': ifmap_uid,
        'ofmap': ofmap_uid
    }

    data_str = [emit_license()]
    # Array forward declarations
    data_str += [format_array_declaration(ctype, ifmap_uid, ifmap.shape)]
    data_str += [format_array_declaration(ctype, ofmap_uid, ofmap.shape)]
    # Layer struct
    data_str += [format_struct_definition('maxpool_layer_t', 'layer', layer_cfg)]
    # Array definitions
    data_str += [format_array_definition(ctype, ifmap_uid, ifmap)]
    # Golden results for BIST
    result_def = format_array_definition(ctype, 'golden', ofmap)
    data_str += [format_ifdef_wrapper('BIST', result_def)]
    data_str = '\n\n'.join(data_str)

    return data_str


def main():

    parser = argparse.ArgumentParser(description='Generate data for layernorm kernel')
    parser.add_argument(
        "-c", "--cfg",
        type=pathlib.Path,
        required=True,
        help='Select param config file kernel'
    )
    parser.add_argument(
        '--section',
        type=str,
        help='Section to store matrices in')
    parser.add_argument(
        'output',
        type=pathlib.Path,
        help='Path of the output header file')
    args = parser.parse_args()

    # Load param config file
    with args.cfg.open() as f:
        param = json5.loads(f.read())
    param['section'] = args.section

    # Emit header file
    with open(args.output, 'w') as f:
        f.write(emit_header(**param))


if __name__ == '__main__':
    main()
