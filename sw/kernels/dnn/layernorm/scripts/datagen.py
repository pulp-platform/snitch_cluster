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
import torch
import numpy as np

import pyflexfloat as ff

from snitch.util.sim import data_utils
from snitch.util.sim.data_utils import format_array_declaration, \
    format_struct_definition, format_array_definition, format_ifdef_wrapper, \
    emit_license

torch.manual_seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


def golden_model(ifmap, eps):
    # Compute the mean and variance considering the last dimension (embeddings)
    # The dimensions for mean and variance calculations are (-1,), meaning the last dimension.
    # Keep the dimensions for broadcasting in normalization.
    mean = np.mean(ifmap, axis=(-1,), keepdims=True)
    diff = ifmap - mean
    var = np.mean(diff*diff, axis=(-1,), keepdims=True)

    # Normalize the input tensor
    ofmap = (ifmap - mean) / np.sqrt(var + eps)

    return ofmap


def golden_model_torch(ifmap, eps, shape):
    ln = torch.nn.LayerNorm(shape, eps=eps)
    return ln(ifmap)


def validate(**kwargs):
    # Aliases
    batch_size = kwargs['input_dim']['batch_size']
    seq_len = kwargs['input_dim']['seq_len']
    embeddings = kwargs['input_dim']['embeddings']

    # Calculate total TCDM occupation
    prec = data_utils.size_from_precision_t(kwargs['prec'])
    tiled_seq_len = seq_len / kwargs['n_tiles']
    total_size = batch_size * tiled_seq_len * embeddings * prec
    data_utils.validate_tcdm_footprint(total_size)

    assert kwargs['input_dim']['seq_len'] % kwargs['n_tiles'] == 0, 'Input dimension is not' \
                                                                    ' an integer multiple of' \
                                                                    ' tile size'
    assert kwargs['prec'] != "FP64", 'FP64 not supported'
    assert not (kwargs['implementation'] == "BASELINE"), 'No baseline implementations' \
                                                         ' (switch to NAIVE)'
    assert not (kwargs['implementation'] == "OPT_EX"), 'Expanding layernorm kernels not supported'
    assert not (kwargs['prec'] == "FP8" and kwargs['implementation'] == "NAIVE"), 'FP8 not ' \
                                                                                  'supported in' \
                                                                                  'naive ' \
                                                                                  'implementation'


def emit_header(**kwargs):

    # Validate parameters
    validate(**kwargs)

    batch_size = kwargs['input_dim']['batch_size']
    seq_len = kwargs['input_dim']['seq_len']
    embeddings = kwargs['input_dim']['embeddings']
    eps = kwargs['eps']
    prec = kwargs['prec']
    n_tiles = kwargs['n_tiles']
    implementation = kwargs['implementation']

    ff_desc = data_utils.ff_desc_from_precision_t(prec)
    ctype = data_utils.ctype_from_precision_t(prec)

    # Generate random input
    ifmap = ff.array(np.random.rand(batch_size, seq_len, embeddings), ff_desc)
    ofmap = golden_model(ifmap, eps)

    ifmap_uid = 'ifmap'
    ofmap_uid = 'ofmap'

    layer_cfg = {
        **kwargs['input_dim'],
        'n_tiles': n_tiles,
        'implementation': implementation,
        'ifmap': ifmap_uid,
        'ofmap': ofmap_uid,
        'eps': eps,
        'dtype': prec
    }

    data_str = [emit_license()]
    data_str += [format_array_declaration(f'extern {ctype}', ifmap_uid, ifmap.shape,
                 alignment=BURST_ALIGNMENT)]
    data_str += [format_array_declaration(ctype, ofmap_uid, ofmap.shape,
                 alignment=BURST_ALIGNMENT)]
    data_str += [format_struct_definition('layernorm_layer_t', 'layer', layer_cfg)]
    data_str += [format_array_definition(ctype, ifmap_uid, ifmap,
                 alignment=BURST_ALIGNMENT)]
    result_def = format_array_definition(ctype, 'golden', ofmap, alignment=BURST_ALIGNMENT)
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
