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


def golden_model(ifmap, eps, shape, prec):
    ln = torch.nn.LayerNorm(shape, eps=eps)
    return ln(ifmap)


def emit_header(**kwargs):
    batch_size = kwargs['input_dim']['batch_size']
    seq_len = kwargs['input_dim']['seq_len']
    embeddings = kwargs['input_dim']['embeddings']
    eps = kwargs['eps']
    prec = kwargs['prec']
    n_tiles = kwargs['n_tiles']
    baseline = kwargs['baseline']

    assert (seq_len % n_tiles) == 0, 'Input dimension is not an integer multiple of tile size'
    
    torch_type = data_utils.torch_type_from_precision_t(prec)
    # FIXME: 16-bit precision is not supported by torch.nn.LayerNorm
    if torch_type == torch.float16:
        torch_type = torch.float32
    ifmap = torch.randn(batch_size, seq_len, embeddings, requires_grad=False, dtype=torch_type)

    ofmap = golden_model(ifmap, eps, embeddings, prec)
    ofmap = ofmap.detach().numpy()

    ctype = data_utils.ctype_from_precision_t(prec)

    ifmap_uid = 'ifmap'
    ofmap_uid = 'ofmap'

    layer_cfg = {
        **kwargs['input_dim'],
        'n_tiles': n_tiles,
        'baseline': baseline,
        'ifmap': ifmap_uid,
        'ofmap': ofmap_uid,
        'eps': eps,
        'dtype': prec
    }

    data_str = [emit_license()]
    data_str += [format_array_declaration(ctype, ifmap_uid, ifmap.shape,
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
