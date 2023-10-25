#!/usr/bin/env python3
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


def golden_model(a, b):
    return a*b


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--length',
        type=int,
        help='Vector length of the input and output vectors')
    parser.add_argument(
        '--tile_size',
        type=int,
        help='Tile size length. vector_length/tile_size has to be an integer number!')
    args = parser.parse_args()
    tile_size = args.tile_size
    length = args.length
    assert length % tile_size == 0, "vector_length/tile_size has to be an integer number!"

    # Randomly generate inputs
    a = np.random.randint(MIN, MAX, length)
    b = np.random.randint(MIN, MAX, length)
    out = golden_model(a, b)
    out_test = np.zeros(length, dtype=int)

    # Format header file
    l_str = format_scalar_definition('uint32_t', 'VEC_LEN', length)
    t_str = format_scalar_definition('uint32_t', 'TILE_SIZE', tile_size)
    a_str = format_vector_definition('uint32_t', 'A', a)
    b_str = format_vector_definition('uint32_t', 'B', b)
    out_str = format_vector_definition('uint32_t', 'OUT', out)
    out_test_str = format_vector_definition('uint32_t', 'OUT_TEST', out_test)
    f_str = '\n\n'.join([l_str, t_str, a_str, b_str, out_str, out_test_str])
    f_str += '\n'

    # Write to stdout
    print(f_str)


if __name__ == '__main__':
    sys.exit(main())
