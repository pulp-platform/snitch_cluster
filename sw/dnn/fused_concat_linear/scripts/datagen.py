#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import argparse
import numpy as np
import pathlib
import json5
import sys
import os
import pyflexfloat as ff

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
import data_utils  # noqa: E402
from data_utils import emit_license, \
                       format_struct_definition, format_array_definition, \
                       format_array_declaration, format_ifdef_wrapper, \
                       format_scalar_definition  # noqa: E402

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


def golden_model(inputs, weights):
    innermost_dim = len(inputs[0].shape) - 1
    concat_output = np.concatenate(inputs, axis=innermost_dim)
    linear_output = np.matmul(concat_output, weights)
    return linear_output, concat_output


def emit_header(section, params):
    num_inputs = params['num_inputs']
    input_shape = params['input_shape']
    output_shape = params['output_shape']
    prec = params['dtype']
    trans_weights = params['trans_weights']

    assert input_shape[0] == output_shape[0], 'Inconsistent input and output shapes'

    ff_desc = data_utils.ff_desc_from_precision_t(prec)
    ctype = data_utils.ctype_from_precision_t(prec)

    inputs = [ff.array(np.random.rand(*input_shape), ff_desc) for _ in range(num_inputs)]
    weights = ff.array(np.random.rand(input_shape[1]*num_inputs, output_shape[1]), ff_desc)
    linear_output, concat_output = golden_model(inputs, weights)

    ctype = data_utils.ctype_from_precision_t(prec)

    weights = weights.T if trans_weights else weights

    layer_cfg = {
        **params,
        'inputs': 'inputs',
        'weights': 'weights',
        'concat_output': 'concat_output',
        'linear_output': 'linear_output'
    }

    data_str = [emit_license()]
    data_str += [format_array_declaration(ctype, f'input_{i}', input_shape)
                 for i in range(num_inputs)]
    data_str += [format_array_declaration('void*', 'inputs', [num_inputs])]
    data_str += [format_array_declaration(ctype, 'concat_output', concat_output.shape)]
    data_str += [format_array_declaration(ctype, 'linear_output', linear_output.shape)]
    data_str += [format_array_declaration(ctype, 'weights', weights.shape)]
    data_str += [format_scalar_definition('uint32_t', 'trans_weights', int(trans_weights))]
    data_str += [format_struct_definition('fused_concat_linear_layer_t', 'layer', layer_cfg)]
    data_str += [format_array_definition(ctype, f'input_{i}', t)
                 for i, t in enumerate(inputs)]
    data_str += [format_array_definition('void*', 'inputs', np.array([f'input_{i}'
                 for i in range(num_inputs)]))]
    data_str += [format_array_definition(ctype, 'weights', weights)]
    result_def = format_array_definition(ctype, 'golden', linear_output)
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

    # Emit header file
    with open(args.output, 'w') as f:
        f.write(emit_header(args.section, param))


if __name__ == '__main__':
    main()
