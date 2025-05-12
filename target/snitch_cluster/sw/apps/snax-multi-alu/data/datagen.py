#!/usr/bin/env python3

# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

import sys
import argparse
import numpy as np
import os

# Add data utility path
sys.path.append(os.path.join(os.path.dirname(__file__),
                "../../../../../../util/sim/"))
from data_utils import format_scalar_definition, \
                       format_vector_definition  # noqa: E402

# Hard parameters so modify
# at your own risk

# Value range
MIN = 0
MAX = 100

# Design-time spatial parallelism
SPATIAL_PAR = 4


def golden_model(a, b, mode):
    if (mode == 1):
        return a - b
    elif (mode == 2):
        return a * b
    elif (mode == 3):
        return a ^ b
    else:
        return a + b


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--mode',
        type=int,
        help='Mode: 0 - add; 1 - sub; 2 - mul; 3 - XOR;')
    parser.add_argument(
        '--length',
        type=int,
        help='Number of elements. Do: python datagen.py --length <insert num>')

    args = parser.parse_args()
    mode = args.mode
    length = args.length

    # Randomly generate inputs
    a = np.random.randint(MIN, MAX, length)
    b = np.random.randint(MIN, MAX, length)

    out = golden_model(a, b, mode)

    # Number of iterations for accelerator
    # depend on the spatial parallelism
    loop_iter = length//SPATIAL_PAR

    # Format header file
    mode_str = format_scalar_definition('uint64_t', 'MODE', mode)
    dl_str = format_scalar_definition('uint64_t', 'DATA_LEN', length)
    li_str = format_scalar_definition('uint64_t', 'LOOP_ITER', loop_iter)
    a_str = format_vector_definition('uint64_t', 'A', a)
    b_str = format_vector_definition('uint64_t', 'B', b)

    out_str = format_vector_definition('uint64_t', 'OUT', out)
    f_str = '\n\n'.join([mode_str, dl_str, li_str, a_str, b_str, out_str])

    f_str += '\n'

    print(f_str)


if __name__ == '__main__':
    sys.exit(main())
