#!/usr/bin/env python3

# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Ryan Antonio <ryan.antonio@esat.kuleuven.be>

import sys
import numpy as np
import argparse
import os
import subprocess

# -----------------------
# Add data utility path
# -----------------------
sys.path.append(
    os.path.join(os.path.dirname(__file__), "../../../../../../../util/sim/")
)

from data_utils import (  # noqa: E402
    format_vector_definition,
    format_scalar_definition,
)

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
    load_am_model,
    load_dataset,
    pack_ld_to_hd,
    reshape_hv_list,
)

from hypercorex_compiler import compile_hypercorex_asm  # noqa: E402

# Paths for the hypercorex "asm"
current_directory = os.path.dirname(os.path.abspath(__file__))
asm_path = current_directory + "/digit_recog.txt"

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

# Number of classes in the DIGIT dataset
NUM_CLASSES = 10

# Specifics from cluster
WIDE_DATA_WIDTH = 28*28

# Tailored parameters
# This one is due to C code limitation
# Can only take int 32-bits conversion for python
CUT_WIDTH = 32


# Main function to generate data
def main():
    # Extraction of some parameters
    parser = argparse.ArgumentParser(description="Generate data for kernels")
    parser.add_argument(
        "--input_mul",
        type=int,
        default=1,
        help="Set input multiplier",
    )

    input_mul = parser.parse_args().input_mul

    # This is because the total data for isolet
    # should be in multiples of 4 so that it aligns
    # very well with the bank numbers
    # note about max_num_input_mul = 13
    base_num_pred = 8
    base_num_rows = 49
    num_predictions = base_num_pred * input_mul
    num_rows = base_num_rows * input_mul

    # Flags for multi-bank process
    max_num_predictions = 80
    max_num_rows = 490

    # Get number of banks needed
    if num_predictions <= max_num_predictions:
        bank_num = 0
        final_predictions = num_predictions
        final_rows = num_rows
    else:
        bank_num = num_predictions // max_num_predictions
        final_predictions = num_predictions % max_num_predictions
        final_rows = num_rows % max_num_rows

    # Top-level parameters
    num_features = 28*28
    num_classes = 10

    # Extract instructions for training and testing
    code_list, control_code_list = compile_hypercorex_asm(asm_path)

    # Convert each instruction to integers for input
    for i in range(len(code_list)):
        code_list[i] = hvlist2num(np.array(code_list[i]))

    # Loading data first
    assoc_mem_fp = hypercorex_path + "/hemaia/trained_am/hypx_digit_am.txt"
    assoc_mem = load_am_model(assoc_mem_fp)

    # Reshape the associative memory
    assoc_mem_reshape = reshape_hv_list(assoc_mem, CUT_WIDTH)

    # Save into AM list
    am_list = []
    for i in range(len(assoc_mem_reshape)):
        am_list.append(hvlist2num(np.array(assoc_mem_reshape[i])))

    # Reorder associative memory
    am_list = reorder_list(am_list, 16, NUM_CLASSES)

    # Loading test samples
    test_samples_fp = \
        hypercorex_path + "/hemaia/test_samples/hypx_digit_test.txt"
    test_samples = load_dataset(test_samples_fp)

    # Pack samples into 32 bits
    # Note that the values are binary but we use 4-bits for these
    test_samples_compressed = []
    for i in range(len(test_samples)):
        compressed_sample = pack_ld_to_hd(test_samples[i], 4, CUT_WIDTH)
        test_samples_compressed.append(compressed_sample)

    test_long_samples = (
        test_samples_compressed
        + test_samples_compressed
        + test_samples_compressed
        + test_samples_compressed
        + test_samples_compressed
        + test_samples_compressed
        + test_samples_compressed
        + test_samples_compressed
    )

    test_samples_list = []
    for i in range(len(test_long_samples)):
        for j in range(len(test_long_samples[i])):
            test_samples_list.append(test_long_samples[i][j])

    # Golden list of data
    golden_list_data = list(range(NUM_CLASSES))

    golden_long_list_data = (
        golden_list_data
        + golden_list_data
        + golden_list_data
        + golden_list_data
        + golden_list_data
        + golden_list_data
        + golden_list_data
        + golden_list_data
    )

    code_str = format_vector_definition("uint32_t", "code", code_list)
    am_list_str = format_vector_definition("uint32_t", "am_list", am_list)
    test_samples_str = format_vector_definition(
        "uint32_t", "test_samples_list", test_samples_list
    )
    # Generate golden list
    golden_list_data_str = format_vector_definition(
        "uint32_t", "golden_list_data", golden_long_list_data
    )

    # Scalar data
    num_classes_str = format_scalar_definition(
        "uint32_t", "num_classes", num_classes
    )
    num_features_str = format_scalar_definition(
        "uint32_t", "num_features", num_features
    )

    max_num_predictions_str = format_scalar_definition(
        "uint32_t", "max_num_predictions", max_num_predictions
    )

    final_predictions_str = format_scalar_definition(
        "uint32_t", "final_predictions", final_predictions
    )

    max_num_rows_str = format_scalar_definition(
        "uint32_t", "max_num_rows", max_num_rows
    )

    final_rows_str = format_scalar_definition(
        "uint32_t", "final_rows", final_rows
    )

    bank_num_str = format_scalar_definition("uint32_t", "bank_num", bank_num)

    # Preparing string to load
    f_str = "\n\n".join(
        [
            num_classes_str,
            num_features_str,
            max_num_predictions_str,
            final_predictions_str,
            max_num_rows_str,
            final_rows_str,
            bank_num_str,
            code_str,
            am_list_str,
            test_samples_str,
            golden_list_data_str,
        ]
    )
    f_str += "\n"

    # Write to stdout
    print(f_str)


if __name__ == "__main__":
    sys.exit(main())
