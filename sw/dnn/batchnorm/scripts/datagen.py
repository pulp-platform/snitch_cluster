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


def golden_model(ifmap):
    n, ci, ih, iw = ifmap.shape
    bn = torch.nn.BatchNorm2d(ci)
    bn.weight.requires_grad = False
    bn.bias.requires_grad = False
    running_mean = torch.randn_like(bn.running_mean, requires_grad=False)
    running_var = torch.rand_like(bn.running_var, requires_grad=False)
    gamma = bn.weight / torch.sqrt(running_var + bn.eps)
    beta = bn.bias - running_mean * bn.weight / torch.sqrt(running_var + bn.eps)
    ofmap = ifmap * gamma.unsqueeze(-1).unsqueeze(-1) + beta.unsqueeze(-1).unsqueeze(-1)
    return ofmap, gamma, beta


def emit_header(**kwargs):

    in_channels = kwargs['input_dim']['channels']
    in_height = kwargs['input_dim']['height']
    in_width = kwargs['input_dim']['width']
    tile_ci = kwargs['tile_ci']
    prec = str(kwargs['prec'])

    torch_type = data_utils.torch_type_from_precision_t(prec)
    ctype = data_utils.ctype_from_precision_t(prec)

    ifmap = torch.randn(1, in_channels, in_height, in_width, requires_grad=False, dtype=torch_type)
    ofmap, gamma, beta = golden_model(ifmap)

    # convert from CHW to HWC format
    ifmap = ifmap.permute(0, 2, 3, 1)
    ofmap = ofmap.permute(0, 2, 3, 1)

    n, ih, iw, ci = ifmap.shape
    ifmap = data_utils.flatten(ifmap)
    ofmap = data_utils.flatten(ofmap)

    ifmap_uid = 'ifmap'
    ofmap_uid = 'ofmap'
    beta_uid = 'beta'
    # Underscore is used to disambiguate between this and the gamma function from "math.h"
    gamma_uid = 'gamma_'

    layer_cfg = {
        'CI': ci,
        'IH': ih,
        'IW': iw,
        'TILE_CI': tile_ci,
        'ifmap': ifmap_uid,
        'ofmap': ofmap_uid,
        'beta': beta_uid,
        'gamma': gamma_uid
    }

    data_str = [emit_license()]
    # Array forward declarations
    data_str += [format_array_declaration(ctype, ifmap_uid, ifmap.shape)]
    data_str += [format_array_declaration(ctype, ofmap_uid, ofmap.shape)]
    data_str += [format_array_declaration(ctype, beta_uid, beta.shape)]
    data_str += [format_array_declaration(ctype, gamma_uid, gamma.shape)]
    # Layer struct
    data_str += [format_struct_definition('batchnorm_layer_t', 'layer', layer_cfg)]
    # Array definitions
    data_str += [format_array_definition(ctype, ifmap_uid, ifmap)]
    data_str += [format_array_definition(ctype, beta_uid, beta)]
    data_str += [format_array_definition(ctype, gamma_uid, gamma)]
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
