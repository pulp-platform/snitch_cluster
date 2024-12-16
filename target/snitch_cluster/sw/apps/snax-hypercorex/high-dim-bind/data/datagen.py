#!/usr/bin/env python3

# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

import sys
import numpy as np
import os
import subprocess

# -----------------------
# Add data utility path
# -----------------------
sys.path.append(os.path.join(os.path.dirname(__file__),
                "../../../../../../../util/sim/"))
from data_utils import format_scalar_definition, \
    format_vector_definition  # noqa: E402

# -----------------------
# Add hypercorex utility paths
# -----------------------
bender_command = subprocess.run(['bender', 'path', 'hypercorex'],
                                capture_output=True, text=True)
hypercorex_path = bender_command.stdout.strip()

char_recog_dataset_path = hypercorex_path + \
    "/hdc_exp/data_set/char_recog/characters.txt"

sys.path.append(hypercorex_path + "/hdc_exp/")
sys.path.append(hypercorex_path + "/sw/")

from hdc_util import (  # noqa: E402
    reshape_hv_list,
)

from system_regression import (  # noqa: E402
    data_autofetch_bind,
)

from hypercorex_compiler import compile_hypercorex_asm  # noqa: E402

# Paths for the hypercorex "asm"
current_directory = os.path.dirname(os.path.abspath(__file__))
high_dim_bind_asm_path = current_directory + "/high_dim_bind.txt"

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

# -----------------------
# Working fixed parameters
# -----------------------


snax_hypercorex_parameters = {
    "seed_size": 32,
    "hv_dim": 512,
    "num_total_im": 1024,
    "num_per_im_bank": 128,
    "base_seeds": [
        1103779247,
        2391206478,
        3074675908,
        2850820469,
        811160829,
        4032445525,
        2525737372,
        2535149661,
    ],
    "gen_seed": True,
    "ca90_mode": "ca90_hier",
}

# Loading data first
ortho_im, golden_list = data_autofetch_bind(
    seed_size=snax_hypercorex_parameters["seed_size"],
    hv_dim=snax_hypercorex_parameters["hv_dim"],
    num_total_im=snax_hypercorex_parameters["num_total_im"],
    num_per_im_bank=snax_hypercorex_parameters["num_per_im_bank"],
    base_seeds=snax_hypercorex_parameters["base_seeds"],
    gen_seed=snax_hypercorex_parameters["gen_seed"],
    ca90_mode=snax_hypercorex_parameters["ca90_mode"],
)

# Specifics from cluster
NARROW_DATA_WIDTH = 64
WIDE_DATA_WIDTH = 512

# Tailored parameters
# This one is due to C code limitation
# Can only take int 32-bits conversion for python
CUT_WIDTH = 32

# Number of elements per wide
NUM_CUT_IN_WIDE_ELEM = WIDE_DATA_WIDTH // CUT_WIDTH

# Number of targetted wide data
TARGET_NUM_DATA = 100

# Total number of data to check
TOTAL_NUM_DATA = TARGET_NUM_DATA * NUM_CUT_IN_WIDE_ELEM

# Data B is half of ortho im
HALF_START = len(ortho_im) // 2
OFFSET_START = HALF_START * NUM_CUT_IN_WIDE_ELEM

ortho_im_reshape = reshape_hv_list(ortho_im, CUT_WIDTH)
golden_list_reshape = reshape_hv_list(golden_list, CUT_WIDTH)


# Main function to generate data
def main():

    # Extract instructions for training and testing
    high_dim_bind_code_list, high_dim_bind_control_code_list = \
        compile_hypercorex_asm(high_dim_bind_asm_path)

    # Convert each instruction to integers for input
    for i in range(len(high_dim_bind_code_list)):
        high_dim_bind_code_list[i] = hvlist2num(
            np.array(high_dim_bind_code_list[i]))

    # Convert ortho im to reshape
    # Data a is the first TOTAL_NUM_DATA
    data_a_list = []
    for i in range(TOTAL_NUM_DATA):
        data_a_list.append(hvlist2num(np.array(ortho_im_reshape[i])))

    # Data b is the second TOTAL_NUM_DATA
    data_b_list = []
    for i in range(TOTAL_NUM_DATA):
        data_b_list.append(hvlist2num(
            np.array(ortho_im_reshape[i+OFFSET_START])))

    # Golden list of data
    golden_list_data = []
    for i in range(TOTAL_NUM_DATA):
        golden_list_data.append(hvlist2num(np.array(golden_list_reshape[i])))

    # Generating strings to print
    target_num_data_str = format_scalar_definition(
        'uint32_t', 'target_num_data', TARGET_NUM_DATA)
    num_cut_in_wide_elem_str = format_scalar_definition(
        'uint32_t', 'num_cut_in_wide_elem', NUM_CUT_IN_WIDE_ELEM)
    high_dim_bind_code_str = format_vector_definition(
        'uint32_t', 'high_dim_bind_code', high_dim_bind_code_list)
    # Generate string for ortho_im_reshape
    data_a_list_str = format_vector_definition(
        'uint32_t', 'data_a_list', data_a_list)
    data_b_list_str = format_vector_definition(
        'uint32_t', 'data_b_list', data_b_list)
    # Generate golden list
    golden_list_data_str = format_vector_definition(
        'uint32_t', 'golden_list_data', golden_list_data)
    # Preparing string to load
    f_str = '\n\n'.join([target_num_data_str,
                         num_cut_in_wide_elem_str,
                         high_dim_bind_code_str,
                         data_a_list_str,
                         data_b_list_str,
                         golden_list_data_str,])
    f_str += '\n'

    # Write to stdout
    print(f_str)


if __name__ == '__main__':
    sys.exit(main())
