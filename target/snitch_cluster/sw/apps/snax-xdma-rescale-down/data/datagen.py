#!/usr/bin/env python3

# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Jonas Crols <jonas.crols@student.kuleuven.be>

import argparse
import os
import pathlib
import random
import sys

import hjson
import numpy as np

# Add data utility path
sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../../../util/sim/"))
from data_utils import format_scalar_definition, format_vector_definition  # noqa E402
from snax_utils import postprocessing_simd_golden_model_V3  # noqa E402

np.random.seed(320)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = ["#include <stdint.h>"]
    emit_str += emit_elementwise_add_data(**kwargs)
    return "\n\n".join(emit_str)


def emit_elementwise_add_data(**kwargs):
    tile_width = 8
    element_in_width = 32
    element_out_width = 8
    data_type = "int32_t"

    emit_str = []
    padded_M = None
    padded_N = None
    padded_M = (kwargs["M"] + tile_width - 1) // tile_width * tile_width
    padded_N = (kwargs["N"] + tile_width - 1) // tile_width * tile_width

    # Make random parameters for the TOSA.Rescale operation
    shift_i = random.randint(24, 48)
    multiplier = 1140768826 * 2 // (2 ** (48 - shift_i))
    max_in_range = 8388608
    input_zp_i = random.randint(-10000000, 10000000) // (2 ** (48 - shift_i))
    output_zp_i = random.randint(-3, 3)

    # First input matrix for elementwise add
    matrix1_data = np.zeros((padded_M, padded_N), dtype=np.int32)
    matrix1_data[: kwargs["M"], : kwargs["N"]] = np.random.randint(
        low=-kwargs["max_in_range"],
        high=kwargs["max_in_range"],
        size=(kwargs["M"], kwargs["N"]),
        dtype=np.int32,
    )
    input_matrix1 = matrix1_data
    input_matrix1 = input_matrix1.ravel()

    # Emit input matrix
    emit_str += [format_scalar_definition("uint32_t", "matrix_size", matrix1_data.size)]
    emit_str += [format_vector_definition(data_type, "input_matrix", input_matrix1)]

    # Emit output matrix
    output_matrix = []
    for data_element in input_matrix1:
        output_matrix.append(
            # V3 Holds the approximation of the TOSA.Rescale operation.
            # use V2 for the exact model
            postprocessing_simd_golden_model_V3(
                data_element,
                input_zp_i,
                output_zp_i,
                shift_i,
                max_in_range,
                -max_in_range,
                True,
                multiplier,
            )
        )
    output_matrix = np.array(output_matrix, dtype=np.int8)

    output_matrix = output_matrix.ravel()
    emit_str += [
        format_vector_definition("int8_t", "golden_output_matrix", output_matrix)
    ]

    # Emit the configuration for XDMA
    spatial_stride_src = None
    spatial_stride_dst = None
    temporal_strides_src = []
    temporal_strides_dst = []
    temporal_bounds_src = []
    temporal_bounds_dst = []

    # Input Side (Reader)
    spatial_stride_src = 8
    temporal_bounds_src = [
        input_matrix1.shape[0] // (512 // element_in_width),
    ]
    temporal_strides_src = [
        64,
    ]

    # Output Side (Writer)

    spatial_stride_dst = 8
    temporal_bounds_dst = [
        input_matrix1.shape[0] // (512 // element_out_width),
    ]
    temporal_strides_dst = [
        64,
    ]

    emit_str += [
        format_scalar_definition("uint32_t", "spatial_stride_src", spatial_stride_src)
    ]
    emit_str += [
        format_scalar_definition("uint32_t", "spatial_stride_dst", spatial_stride_dst)
    ]
    emit_str += [
        format_vector_definition("uint32_t", "temporal_bounds_src", temporal_bounds_src)
    ]
    emit_str += [
        format_vector_definition("uint32_t", "temporal_bounds_dst", temporal_bounds_dst)
    ]
    emit_str += [
        format_vector_definition(
            "uint32_t", "temporal_strides_src", temporal_strides_src
        )
    ]
    emit_str += [
        format_vector_definition(
            "uint32_t", "temporal_strides_dst", temporal_strides_dst
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t", "temporal_dimension_src", len(temporal_bounds_src)
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t", "temporal_dimension_dst", len(temporal_bounds_dst)
        )
    ]

    emit_str += [format_scalar_definition("uint32_t", "shift_i", shift_i)]
    emit_str += [format_scalar_definition("uint32_t", "multiplier_i", multiplier)]
    emit_str += [format_scalar_definition("int32_t", "input_zp_i", input_zp_i)]
    emit_str += [format_scalar_definition("int32_t", "output_zp_i", output_zp_i)]

    return emit_str


def main():
    # Parsing cmd args
    parser = argparse.ArgumentParser(description="Generating data for kernels")
    parser.add_argument(
        "-c",
        "--cfg",
        type=pathlib.Path,
        required=True,
        help="Select param config file kernel",
    )
    args = parser.parse_args()

    # Load param config file
    with args.cfg.open() as f:
        param = hjson.loads(f.read())

    # Emit header file
    print(emit_header_file(**param))


if __name__ == "__main__":
    main()
