#!/usr/bin/env python3
# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Authors: Tim Fischer     <fischeti@iis.ee.ethz.ch>
#          Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>

import numpy as np
import argparse
import pathlib
import json5
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
from data_utils import emit_license, format_scalar_definition, \
                       format_array_definition, format_ifdef_wrapper  # noqa: E402


np.random.seed(42)

C_TYPES = {
  '64': 'double',
  '32': 'float',
  '16': '__fp16',
  '8': 'char'
}

NUMPY_TYPES = {
  '64': np.double,
  '32': np.single,
  '16': np.half,
  '8': np.ubyte
}

FP8_FORMATS = {
    'fp8': {'exp': 5, 'mant': 2},
    'fp8alt': {'exp': 4, 'mant': 3}
}

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


def golden_model(alpha, a, b, beta, c):
    return alpha * np.matmul(a, b) + beta * c


def validate_config(prec, parallelize_m, parallelize_k, m_tiles, n_tiles, k_tiles, ta, tb, M, N, K,
                    baseline, **kwargs):
    frac_m = M / m_tiles
    frac_n = N / n_tiles

    assert (M % m_tiles) == 0, 'M is not an integer multiple of tile size'
    assert (N % n_tiles) == 0, 'N is not an integer multiple of tile size'
    assert (K % k_tiles) == 0, 'K is not an integer multiple of tile size'
    assert (frac_m % 8) == 0, 'frac_m is not an integer multiple of the number of cores per' \
                              'cluster'
    assert not (parallelize_m and parallelize_k), 'Cannot parallelize K and M simultaneously'
    assert not ta, 'SIMD kernels don\'t support transposed A matrix'
    assert not ((prec != 64) and not baseline and not tb), 'Optimized SIMD kernels only support transposed B matrix'
    assert not tb or n_tiles == 1, 'Tiling in the N dimension supported only if B is' \
                                             ' not transposed'
    assert not tb or k_tiles == 1, 'Tiling in the K dimension supported only if B is' \
                                             ' not transposed'
    assert baseline or frac_n >= 8, 'N dimension of tile size must be greater or equal to' \
                                    ' the unrolling factor (8) when using optimized kernels'


def emit_header(**kwargs):

    # Validate parameters
    validate_config(**kwargs)

    # Generate random input matrices
    prec = kwargs['prec']
    dtype = NUMPY_TYPES[str(prec)]
    M, N, K = kwargs['M'], kwargs['N'], kwargs['K']
    m_tiles = kwargs['m_tiles']
    n_tiles = kwargs['n_tiles']
    k_tiles = kwargs['k_tiles']
    parallelize_m = kwargs['parallelize_m']
    parallelize_k = kwargs['parallelize_k']
    baseline = kwargs['baseline']

    if prec == 8:
        # sign -1 or 1
        sign_a = np.random.randint(0, 2, (M, K)).astype(dtype)
        # esponent < 0b01111
        exponent_a = np.random.randint(0, 16, (M, K)).astype(dtype)
        # mantissa can be arbitrary
        mantissa_a = np.random.randint(0, 4, (M, K)).astype(dtype)
        # sign -1 or 1
        sign_b = np.random.randint(0, 2, (K, N)).astype(dtype)
        # esponent < 0b01111
        exponent_b = np.random.randint(0, 16, (K, N)).astype(dtype)
        # mantissa can be arbitrary
        mantissa_b = np.random.randint(0, 4, (K, N)).astype(dtype)
        # sign -1 or 1
        sign_c = np.random.randint(0, 2, (M, N)).astype(dtype)
        # esponent < 0b01111
        exponent_c = np.random.randint(0, 16, (M, N)).astype(dtype)
        # mantissa can be arbitrary
        mantissa_c = np.random.randint(0, 4, (M, N)).astype(dtype)
        _a = ((-1.0)**sign_a.astype(np.double))*(2.0**(exponent_a.astype(np.double)-15.0)) \
            * (1.0 + mantissa_a.astype(np.double) / (2**2))
        _b = ((-1.0)**sign_b.astype(np.double))*(2.0**(exponent_b.astype(np.double)-15.0)) \
            * (1.0 + mantissa_b.astype(np.double) / (2**2))
        _c = ((-1.0)**sign_c.astype(np.double))*(2.0**(exponent_c.astype(np.double)-15.0)) \
            * (1.0 + mantissa_c.astype(np.double) / (2**2))
        result = golden_model(1, _a, _b, kwargs['beta'], _c)
        a = sign_a << 7 | exponent_a << FP8_FORMATS['fp8']['mant'] | mantissa_a
        b = sign_b << 7 | exponent_b << FP8_FORMATS['fp8']['mant'] | mantissa_b
        c = sign_c << 7 | exponent_c << FP8_FORMATS['fp8']['mant'] | mantissa_c
    else:
        a = np.random.rand(M, K).astype(dtype)
        b = np.random.rand(K, N).astype(dtype)
        c = np.random.rand(M, N).astype(dtype)
        result = golden_model(1, a, b, kwargs['beta'], c)

    # Store matrices in transposed form if requested
    a = a.T if kwargs['ta'] else a
    b = b.T if kwargs['tb'] else b

    data_str = [emit_license()]
    data_str += [format_scalar_definition('uint32_t', 'M', M)]
    data_str += [format_scalar_definition('uint32_t', 'N', N)]
    data_str += [format_scalar_definition('uint32_t', 'K', K)]
    data_str += [format_scalar_definition('uint32_t', 'TA', int(kwargs['ta']))]
    data_str += [format_scalar_definition('uint32_t', 'TB', int(kwargs['tb']))]
    data_str += [format_scalar_definition('uint32_t', 'BETA', kwargs['beta'])]
    data_str += [format_scalar_definition('uint32_t', 'dtype_size', kwargs['prec']//8)]
    data_str += [format_scalar_definition('uint32_t', 'expand', int(kwargs['expand']))]
    data_str += [format_scalar_definition('uint32_t', 'm_tiles', kwargs['m_tiles'])]
    data_str += [format_scalar_definition('uint32_t', 'n_tiles', kwargs['n_tiles'])]
    data_str += [format_scalar_definition('uint32_t', 'k_tiles', kwargs['k_tiles'])]
    data_str += [format_scalar_definition('uint32_t', 'parallelize_m', kwargs['parallelize_m'])]
    data_str += [format_scalar_definition('uint32_t', 'parallelize_k', kwargs['parallelize_k'])]
    data_str += [format_scalar_definition('uint32_t', 'baseline', int(baseline))]
    data_str += [format_array_definition(C_TYPES[str(kwargs['prec'])], 'a', a.flatten(),
                 alignment=BURST_ALIGNMENT, section=kwargs['section'])]
    data_str += [format_array_definition(C_TYPES[str(kwargs['prec'])], 'b', b.flatten(),
                 alignment=BURST_ALIGNMENT, section=kwargs['section'])]
    data_str += [format_array_definition(C_TYPES[str(kwargs['prec'])], 'c', c.flatten(),
                 alignment=BURST_ALIGNMENT, section=kwargs['section'])]
    if kwargs['prec'] == 8:
        result_def = format_array_definition(C_TYPES['64'], 'result', result.flatten())
    else:
        result_def = format_array_definition(C_TYPES[str(kwargs['prec'])],
                                             'result',
                                             result.flatten())
    data_str += [format_ifdef_wrapper('BIST', result_def)]
    data_str = '\n\n'.join(data_str)

    return data_str


def main():

    parser = argparse.ArgumentParser(description='Generate data for kernels')
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
    args = parser.parse_args()

    # Load param config file
    with args.cfg.open() as f:
        param = json5.loads(f.read())
    param['section'] = args.section

    # Emit header file
    print(emit_header(**param))


if __name__ == '__main__':
    main()
