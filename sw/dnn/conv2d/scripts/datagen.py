#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import argparse
import numpy as np
import pathlib
import hjson
import sys
import os
import torch

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
import data_utils  # noqa: E402
from data_utils import emit_license, \
                       format_struct_definition, format_array_definition, \
                       format_array_declaration  # noqa: E402

torch.manual_seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


# Conv2D
def golden_model(inputs, filters, **kwargs):
    return torch.nn.functional.conv2d(inputs, filters, **kwargs)


def emit_header(**kwargs):
    in_channels = kwargs['channels']['in']
    out_channels = kwargs['channels']['out']
    input_dim = kwargs['input_dim']  # [mini_batch, height, width]
    filter = kwargs['filter']  # [height, width, padding, stride]
    prec = kwargs['prec']

    torch_type = data_utils.torch_type_from_precision_t(prec)

    inputs = [torch.rand(in_channels, input_dim['height'], input_dim['width'],
                         requires_grad=False, dtype=torch_type)][0]

    filters = [torch.rand(out_channels, in_channels, filter['height'],
                          filter['width'], requires_grad=False, dtype=torch_type)]

    conv2d_output = golden_model(inputs, filters[0],
                                 padding=filter['padding'], stride=filter['stride'])
    output_dim = conv2d_output.shape

    # compute checksum row-wise
    conv2d_checksum = np.sum(conv2d_output.numpy(), axis=1)

    ctype = data_utils.ctype_from_precision_t(prec)

    inputs = data_utils.flatten(inputs.numpy())
    filters = data_utils.flatten(filters[0].numpy())
    conv2d_output = data_utils.flatten(conv2d_output.numpy())

    layer_cfg = {
        'CO': out_channels,
        'CI': in_channels,
        'IH': input_dim['height'],
        'IW': input_dim['width'],
        'OH': output_dim[1],
        'OW': output_dim[2],
        'FH': filter['height'],
        'FW': filter['width'],
        'ifmap': 'conv2d_ifmap_dram',
        'weights': 'conv2d_weights_dram',
        'ofmap': 'conv2d_ofmap_dram',
        'dtype': prec
    }

    data_str = [emit_license()]
    data_str += [format_array_declaration(ctype, 'conv2d_ifmap_dram',
                                          inputs.shape, BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, 'conv2d_weights_dram',
                                          filters.shape, BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, 'conv2d_ofmap_dram',
                                          conv2d_output.shape, BURST_ALIGNMENT)]
    data_str += [format_struct_definition('conv_layer', 'layer', layer_cfg)]
    data_str += [format_array_definition(ctype, 'conv2d_ifmap_dram',
                                         inputs, BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'conv2d_weights_dram',
                                         filters, BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'conv2d_ofmap_dram',
                                         conv2d_output, BURST_ALIGNMENT)]
    data_str += [format_array_definition(ctype, 'conv2d_checksum',
                                         conv2d_checksum, BURST_ALIGNMENT)]

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
        param = hjson.loads(f.read())
    param['section'] = args.section

    # Emit header file
    with open(args.output, 'w') as f:
        f.write(emit_header(**param))


if __name__ == '__main__':
    main()
