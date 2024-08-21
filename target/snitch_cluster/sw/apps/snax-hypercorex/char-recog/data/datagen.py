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

from hdc_util import gen_ca90_im_set  # noqa: E402
from char_recog import (  # noqa: E402
    convert_to_data_indices,
    char_recog_dataset,
)

from hypercorex_compiler import compile_hypercorex_asm  # noqa: E402

# Paths for the hypercorex "asm"
current_directory = os.path.dirname(os.path.abspath(__file__))
train_asm_path = current_directory + "/train_char_recog_asm.txt"
test_asm_path = current_directory + "/test_char_recog_asm.txt"

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

# Hard parameters
REG_DATA_WIDTH = 32

# Some parameters about the character recognition set
TOTAL_PIXEL_FEATURES = 35
THRESHOLD = TOTAL_PIXEL_FEATURES / 2
NUM_CLASSES = 26
NUM_ITEMS_TO_TRAIN = 5
NUM_ITEMS_TO_TEST = 5

SEED_DIM = 32
HV_DIM = 512
NUM_TOT_IM = 1024
NUM_PER_IM_BANK = 128


# Main function to generate data
def main():
    # Extract instructions for training and testing
    train_code_list, train_control_code_list = \
        compile_hypercorex_asm(train_asm_path)
    test_code_list, test_control_code_list = \
        compile_hypercorex_asm(test_asm_path)

    # Convert each instruction to integers for input
    for i in range(len(train_code_list)):
        train_code_list[i] = hvlist2num(np.array(train_code_list[i]))

    for i in range(len(test_code_list)):
        test_code_list[i] = hvlist2num(np.array(test_code_list[i]))

    # Get a CA90 seed that's working
    im_seed_list, ortho_im, conf_mat = gen_ca90_im_set(
        seed_size=SEED_DIM,
        hv_dim=HV_DIM,
        num_total_im=NUM_TOT_IM,
        num_per_im_bank=NUM_PER_IM_BANK,
    )

    # Extract data set
    dataset = char_recog_dataset(char_recog_dataset_path)
    # Convert data set to index-based encoding
    index_based_dataset = convert_to_data_indices(dataset)

    # Flatten data list
    flat_char_dataset = sum(index_based_dataset, [])

    # Generating strings to print
    num_classes_str = format_scalar_definition(
        'uint32_t', 'num_classes', NUM_CLASSES)
    num_test_items_str = format_scalar_definition(
        'uint32_t', 'num_test_items', NUM_ITEMS_TO_TEST)
    num_features_str = format_scalar_definition(
        'uint32_t', 'num_features', TOTAL_PIXEL_FEATURES)
    train_inst_str = format_vector_definition(
        'uint32_t', 'train_inst_code', train_code_list)
    test_inst_str = format_vector_definition(
        'uint32_t', 'test_inst_code', test_code_list)
    im_seed_list_str = format_vector_definition(
        'uint32_t', 'im_seed_list', im_seed_list)
    char_data_str = format_vector_definition(
        'uint64_t', 'char_data', flat_char_dataset)

    # Preparing string to load
    f_str = '\n\n'.join([num_classes_str, num_test_items_str,
                         num_features_str, train_inst_str,
                         test_inst_str, im_seed_list_str,
                         char_data_str])
    f_str += '\n'

    # Write to stdout
    print(f_str)


if __name__ == '__main__':
    sys.exit(main())
