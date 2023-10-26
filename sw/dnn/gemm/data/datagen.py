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
import hjson
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

PRECISION_T = {
    '64': 'FP64',
    '32': 'FP32',
    '16': 'FP16',
    '8': 'FP8'
}


def rand_data_generator(shape, prec, alt=False):
    if prec == '64':
        return torch.randn(shape, requires_grad=False, dtype=torch.float64), {}
    elif prec == '32':
        return torch.randn(shape, requires_grad=False, dtype=torch.float32), {}
    elif prec == '16':
        if alt:
            return torch.randn(shape, requires_grad=False, dtype=torch.bfloat16), {}
        else:
            return torch.randn(shape, requires_grad=False, dtype=torch.float16), {}
    elif prec == '8':
        sign = torch.randint(0, 2, shape,
                             requires_grad=False, dtype=torch.uint8)  # -1 or 1
        exponent = torch.randint(0, 16, shape,
                                 requires_grad=False, dtype=torch.uint8)  # < 0b01111
        mantissa = torch.randint(0, 4, shape,
                                 requires_grad=False, dtype=torch.uint8)  # can be arbitrary
        bits = {'sign': sign, 'exponent': exponent, 'mantissa': mantissa}
        # TODO: not actually correct
        sign_val = (-1.0)**sign.double()
        exp_val = (2.0**(exponent.double()-15.0))
        man_val = (1.0 + mantissa.double() / (2**2))
        val = sign_val*exp_val*man_val
        return val, bits


def golden_model(alpha, A, B, C):
    return alpha * C + torch.matmul(A, B)


def emit_header(**kwargs):

    M = kwargs['M']
    N = kwargs['N']
    K = kwargs['K']
    alpha = kwargs['alpha']
    expand = kwargs['expand']
    transpose_A = kwargs['transpose_A']
    transpose_B = kwargs['transpose_B']
    prec = str(kwargs['prec'])

    mat_A, bits_A = rand_data_generator((M, K), prec)
    mat_B, bits_B = rand_data_generator((K, N), prec)
    mat_C, bits_C = rand_data_generator((M, N), prec)

    result = golden_model(alpha, mat_A, mat_B, mat_C)

    if transpose_A:
        mat_A = mat_A.T
    if transpose_B:
        mat_B = mat_B.T

    ctype = data_utils.floating_point_ctype(prec)

    A_uid = 'A'
    B_uid = 'B'
    C_uid = 'C'

    layer_cfg = {
        'M': M,
        'N': N,
        'K': K,
        'TA': int(transpose_A),
        'TB': int(transpose_B),
        'ALPHA': alpha,
        'expand': expand,
        'dtype': PRECISION_T[prec],
        'A': A_uid,
        'B': B_uid,
        'C': C_uid
    }

    data_str = [emit_license()]
    # Array forward declarations
    data_str += [format_array_declaration(ctype, A_uid, mat_A.shape)]
    data_str += [format_array_declaration(ctype, B_uid, mat_B.shape)]
    data_str += [format_array_declaration(ctype, C_uid, mat_C.shape)]
    # Layer struct
    data_str += [format_struct_definition('gemm_layer_t', 'layer', layer_cfg)]
    # Array definitions
    if prec == 'FP8':
        data_str += [format_array_definition(ctype, A_uid, bits_A)]
        data_str += [format_array_definition(ctype, B_uid, bits_B)]
        data_str += [format_array_definition(ctype, C_uid, bits_C)]
    else:
        data_str += [format_array_definition(ctype, A_uid, mat_A)]
        data_str += [format_array_definition(ctype, B_uid, mat_B)]
        data_str += [format_array_definition(ctype, C_uid, mat_C)]
    # Golden results for BIST
    result_def = format_array_definition(ctype, 'checksum', torch.sum(result, dim=-1))
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
        param = hjson.loads(f.read())
    param['section'] = args.section

    # Emit header file
    with open(args.output, 'w') as f:
        f.write(emit_header(**param))


if __name__ == '__main__':
    main()
