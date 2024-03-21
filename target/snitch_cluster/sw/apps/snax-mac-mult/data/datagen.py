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

# Hard parameters
MIN = 0
MAX = 100


def golden_model(a, b, c, mode):
    if (mode):
        return np.dot(a, b) + c
    else:
        return a*b


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--length',
        type=int,
        help='Vector length. Do: python datagen.py --length <insert num>')
    parser.add_argument(
        '--mode',
        type=int,
        help='Mode. 1 is MAC mode and 0 is MUL mode')
    parser.add_argument(
        '--acc_num',
        type=int,
        help='Acc. Number of accelerators attached to a single Snitch.')
    parser.add_argument(
        '--csr_num',
        type=int,
        help='Number of CSRs per accelerator')
    args = parser.parse_args()
    length = args.length
    mode = args.mode
    acc_num = args.acc_num
    csr_num = args.csr_num

    # Randomly generate inputs
    a = np.random.randint(MIN, MAX, length)
    b = np.random.randint(MIN, MAX, length)
    c = np.random.randint(MIN, MAX, 1)
    out = golden_model(a, b, c, mode)

    # Format header file
    l_str = format_scalar_definition('uint32_t', 'VEC_LEN', length)
    a_str = format_vector_definition('uint32_t', 'A', a)
    b_str = format_vector_definition('uint32_t', 'B', b)
    acc_num_str = format_scalar_definition('uint32_t', 'ACC_NUM', acc_num)
    csr_num_str = format_scalar_definition('uint8_t', 'CSR_NUM', csr_num)

    if (mode):
        out_str = format_scalar_definition('uint32_t', 'OUT', out)
        c_str = format_scalar_definition('uint32_t', 'C', c)
        f_str = '\n\n'.join([l_str, a_str, b_str, c_str, out_str,
                            acc_num_str, csr_num_str])
    else:
        out_str = format_vector_definition('uint32_t', 'OUT', out)
        f_str = '\n\n'.join([l_str, a_str, b_str, out_str,
                            acc_num_str, csr_num_str])

    f_str += '\n'

    print(f_str)


if __name__ == '__main__':
    sys.exit(main())
