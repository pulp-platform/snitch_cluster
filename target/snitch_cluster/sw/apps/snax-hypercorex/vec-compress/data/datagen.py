#!/usr/bin/env python3

# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

import sys
import numpy as np
import os
import subprocess

# Set seed
np.random.seed(42)

# -----------------------
# Add data utility path
# -----------------------
sys.path.append(
    os.path.join(os.path.dirname(__file__), "../../../../../../../util/sim/")
)
from data_utils import format_vector_definition  # noqa: E402

# -----------------------
# Add hypercorex utility paths
# -----------------------
bender_command = subprocess.run(
    ["bender", "path", "hypercorex"], capture_output=True, text=True
)
hypercorex_path = bender_command.stdout.strip()

sys.path.append(hypercorex_path + "/hdc_exp/")
sys.path.append(hypercorex_path + "/sw/")

from hdc_util import (  # noqa: E402
    reshape_hv_list,
    binarize_hv,
)

# Paths for the hypercorex "asm"
current_directory = os.path.dirname(os.path.abspath(__file__))
am_search_asm_path = current_directory + "/am_search.txt"

# -----------------------
# Some useful functions
# -----------------------


# Convert from list to binary value
def hvlist2num(hv_list):
    # Bring back into an integer itself!
    # Sad workaround is to convert to str
    # The convert to integer
    hv_num = "".join(hv_list.astype(str))
    hv_num = int(hv_num, 2)

    return hv_num


def reorder_list(input_list, reorder_chunk_size, num_iterations):
    new_list = []
    for i in range(num_iterations):
        sub_list = \
            input_list[i * reorder_chunk_size:(i + 1) * reorder_chunk_size]
        # Reverse the sublist
        sub_list_reversed = sub_list[::-1]
        # Append the reversed sublist to the new list
        new_list.extend(sub_list_reversed)
    return new_list


# Main function to generate data
def main():

    HV_DIM = 512
    VEC_ROWS = 10
    CUT_WIDTH = 32

    vec_list = []
    binarized_vec_list = []

    # Generate data
    for i in range(VEC_ROWS):
        # Generate a random vector of size HV_DIM
        vec = np.random.randint(-128, 128, size=HV_DIM, dtype=np.int8)
        binarized_vec = binarize_hv(vec, 0)
        vec_list.append(vec)
        binarized_vec_list.append(binarized_vec)

    # print(vec_list[0])
    # print(binarized_vec_list[0])

    vec_reshape_list = []
    # Convert the int8 vector array into one long list
    for i in range(VEC_ROWS):
        for j in range(HV_DIM):
            vec_reshape_list.append(vec_list[i][j])

    # Fix the 512b vector alignments
    binarized_vec_reshape = reshape_hv_list(binarized_vec_list, CUT_WIDTH)

    binarized_vec_list = []
    for i in range(len(binarized_vec_reshape)):
        binarized_vec_list.append(
            hvlist2num(np.array(binarized_vec_reshape[i])))

    binarized_vec_list = reorder_list(binarized_vec_list, 16, VEC_ROWS)

    # Generating strings to print
    vec_list_str = format_vector_definition(
        "uint64_t", "vec_list", vec_reshape_list
    )
    # Generate string for ortho_im_reshape
    binarized_vec_list_str = format_vector_definition(
        "uint32_t", "binarized_vec_list", binarized_vec_list
    )
    # Preparing string to load
    f_str = "\n\n".join(
        [
            vec_list_str,
            binarized_vec_list_str,
        ]
    )
    f_str += "\n"

    # Write to stdout
    print(f_str)


if __name__ == "__main__":
    sys.exit(main())
