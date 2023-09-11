#!/usr/bin/env python3
# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Authors: Tim Fischer     <fischeti@iis.ee.ethz.ch>
#          Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>

import numpy as np
import argparse
import pathlib
import hjson
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
from data_utils import emit_license, format_scalar_definition, \
                       format_vector_definition, format_ifdef_wrapper  # noqa: E402


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


def golden_model(a, b, alpha, c):
    return np.matmul(a, b) + alpha * c


def emit_header(**kwargs):

    # Generate random input matrices
    dtype = NUMPY_TYPES[str(kwargs['prec'])]
    if (kwargs['prec']) == 8:
        # sign -1 or 1
        sign_a = np.random.randint(0, 2, (kwargs['M'], kwargs['K'])).astype(dtype)
        # esponent < 0b01111
        exponent_a = np.random.randint(0, 16, (kwargs['M'], kwargs['K'])).astype(dtype)
        # mantissa can be arbitrary
        mantissa_a = np.random.randint(0, 4, (kwargs['M'], kwargs['K'])).astype(dtype)
        # sign -1 or 1
        sign_b = np.random.randint(0, 2, (kwargs['K'], kwargs['N'])).astype(dtype)
        # esponent < 0b01111
        exponent_b = np.random.randint(0, 16, (kwargs['K'], kwargs['N'])).astype(dtype)
        # mantissa can be arbitrary
        mantissa_b = np.random.randint(0, 4, (kwargs['K'], kwargs['N'])).astype(dtype)
        # sign -1 or 1
        sign_c = np.random.randint(0, 2, (kwargs['M'], kwargs['N'])).astype(dtype)
        # esponent < 0b01111
        exponent_c = np.random.randint(0, 16, (kwargs['M'], kwargs['N'])).astype(dtype)
        # mantissa can be arbitrary
        mantissa_c = np.random.randint(0, 4, (kwargs['M'], kwargs['N'])).astype(dtype)
        _a = ((-1.0)**sign_a.astype(np.double))*(2.0**(exponent_a.astype(np.double)-15.0)) \
            * (1.0 + mantissa_a.astype(np.double) / (2**2))
        _b = ((-1.0)**sign_b.astype(np.double))*(2.0**(exponent_b.astype(np.double)-15.0)) \
            * (1.0 + mantissa_b.astype(np.double) / (2**2))
        _c = ((-1.0)**sign_c.astype(np.double))*(2.0**(exponent_c.astype(np.double)-15.0)) \
            * (1.0 + mantissa_c.astype(np.double) / (2**2))
        result = np.matmul(_a, _b) + kwargs['alpha'] * _c
        a = sign_a << 7 | exponent_a << FP8_FORMATS['fp8']['mant'] | mantissa_a
        b = sign_b << 7 | exponent_b << FP8_FORMATS['fp8']['mant'] | mantissa_b
        c = sign_c << 7 | exponent_c << FP8_FORMATS['fp8']['mant'] | mantissa_c
    else:
        a = np.random.rand(kwargs['M'], kwargs['K']).astype(dtype)
        b = np.random.rand(kwargs['K'], kwargs['N']).astype(dtype)
        c = np.random.rand(kwargs['M'], kwargs['N']).astype(dtype)
        result = golden_model(a, b, kwargs['alpha'], c)

    # Store matrices in transposed form if requested
    a = a.T if kwargs['ta'] else a
    b = b.T if kwargs['tb'] else b

    data_str = [emit_license()]
    data_str += [format_scalar_definition('uint32_t', 'M', kwargs['M'])]
    data_str += [format_scalar_definition('uint32_t', 'N', kwargs['N'])]
    data_str += [format_scalar_definition('uint32_t', 'K', kwargs['K'])]
    data_str += [format_scalar_definition('uint32_t', 'TA', int(kwargs['ta']))]
    data_str += [format_scalar_definition('uint32_t', 'TB', int(kwargs['tb']))]
    data_str += [format_scalar_definition('uint32_t', 'ALPHA', kwargs['alpha'])]
    data_str += [format_scalar_definition('uint32_t', 'dtype_size', kwargs['prec']//8)]
    data_str += [format_scalar_definition('uint32_t', 'expand', kwargs['expand'])]
    data_str += [format_vector_definition(C_TYPES[str(kwargs['prec'])], 'a', a.flatten())]
    data_str += [format_vector_definition(C_TYPES[str(kwargs['prec'])], 'b', b.flatten())]
    data_str += [format_vector_definition(C_TYPES[str(kwargs['prec'])], 'c', c.flatten())]
    if kwargs['prec'] == 8:
        result_def = format_vector_definition(C_TYPES['64'], 'result', result.flatten())
    else:
        result_def = format_vector_definition(C_TYPES[str(kwargs['prec'])],
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
    args = parser.parse_args()

    # Load param config file
    with args.cfg.open() as f:
        param = hjson.loads(f.read())

    # Emit header file
    print(emit_header(**param))


if __name__ == '__main__':
    main()
