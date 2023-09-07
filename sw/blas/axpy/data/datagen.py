#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
import argparse
import numpy as np
import os

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
from data_utils import format_scalar_definition, format_vector_definition, \
                       format_vector_declaration, format_ifdef_wrapper  # noqa: E402

MIN = -1000
MAX = +1000

# Aligns data to the size of a beat to avoid misaligned transfers
BEAT_ALIGNMENT = 64
# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


def golden_model(a, x, y):
    return a*x + y


def main():
    # Argument parsing
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'length',
        type=int,
        help='Vector length')
    parser.add_argument(
        '--section',
        type=str,
        help='Section to store vectors in')
    args = parser.parse_args()
    length = args.length
    section = args.section

    # Randomly generate inputs
    a = np.random.uniform(MIN, MAX, 1)
    x = np.random.uniform(MIN, MAX, length)
    y = np.random.uniform(MIN, MAX, length)
    z = np.zeros(length)
    g = golden_model(a, x, y)

    # Format header file
    l_str = format_scalar_definition('const uint32_t', 'l', length)
    a_str = format_scalar_definition('const double', 'a', a[0])
    x_str = format_vector_definition('double', 'x', x, alignment=BURST_ALIGNMENT, section=section)
    y_str = format_vector_definition('double', 'y', y, alignment=BURST_ALIGNMENT, section=section)
    z_str = format_vector_declaration('double', 'z', z, alignment=BURST_ALIGNMENT, section=section)
    g_str = format_vector_definition('double', 'g', g)
    g_str = format_ifdef_wrapper('BIST', g_str)
    f_str = '\n\n'.join([l_str, a_str, x_str, y_str, z_str, g_str])
    f_str += '\n'

    # Write to stdout
    print(f_str)


if __name__ == '__main__':
    sys.exit(main())
