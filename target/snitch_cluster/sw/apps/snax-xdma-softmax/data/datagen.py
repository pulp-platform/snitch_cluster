#!/usr/bin/env python3

# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Jonas Crols <jonas.crols@student.kuleuven.be>

import argparse
import math
import os
import pathlib
import sys

import hjson
import numpy as np

# Add data utility path
sys.path.append(
    os.path.join(
        os.path.dirname(__file__),
        "../../../../../../util/sim/",
    )
)
from data_utils import format_scalar_definition, format_vector_definition  # noqa E402
from snax_utils import postprocessing_simd_golden_model_V3, integer_softmax  # noqa E402


np.random.seed(320)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = ["#include <stdint.h>"]
    emit_str += emit_softmax_data(**kwargs)
    return "\n\n".join(emit_str)


def emit_softmax_data(**kwargs):

    data_in_type = "int32_t"
    data_out_type = "uint32_t"

    emit_str = []
    M = kwargs["M"]
    channel_count = kwargs["channels"]

    # First input matrix for elementwise add
    matrix_data = np.random.randint(
        low=-4 * kwargs["inverse_scaling_factor"],
        high=4 * kwargs["inverse_scaling_factor"],
        size=(M, channel_count),
        dtype=np.int32,
    )
    input_matrix = matrix_data
    input_matrix = input_matrix.flatten()

    # Emit input matrix
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "matrix_size",
            matrix_data.size,
        )
    ]
    emit_str += [
        format_vector_definition(
            data_in_type,
            "input_matrix",
            input_matrix,
        )
    ]

    # Emit output matrix
    output_matrix = np.empty_like(matrix_data, dtype=np.int32)
    for i in range(channel_count):
        output_matrix[:, i] = integer_softmax(
            matrix_data[:, i], kwargs["inverse_scaling_factor"]
        )

    output_matrix = output_matrix.flatten()

    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "output_matrix_size",
            output_matrix.size,
        )
    ]

    emit_str += [
        format_vector_definition(
            data_out_type,
            "golden_output_matrix",
            output_matrix,
        )
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
    temporal_bounds_src = [M, 3, channel_count // 16, 1, 1]
    temporal_strides_src = [4 * channel_count, 0, 64, 0, 0]

    # Output Side (Writer)

    spatial_stride_dst = 8
    temporal_bounds_dst = [M, channel_count // 16]
    temporal_strides_dst = [4 * channel_count, 64]

    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "spatial_stride_src",
            spatial_stride_src,
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "spatial_stride_dst",
            spatial_stride_dst,
        )
    ]
    emit_str += [
        format_vector_definition(
            "uint32_t",
            "temporal_bounds_src",
            temporal_bounds_src,
        )
    ]
    emit_str += [
        format_vector_definition(
            "uint32_t",
            "temporal_bounds_dst",
            temporal_bounds_dst,
        )
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

    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "scaled_ln2",
            int(math.log(2) * kwargs["inverse_scaling_factor"]),
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "scaled_A",
            int(0.3585 * kwargs["inverse_scaling_factor"]),
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "scaled_B",
            int(1.353 * kwargs["inverse_scaling_factor"]),
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "scaled_C",
            int(0.344 * (kwargs["inverse_scaling_factor"] ** 3))
            >> math.floor(math.log2(kwargs["inverse_scaling_factor"]) * 2),
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "shift",
            math.floor(math.log2(kwargs["inverse_scaling_factor"]) * 2),
        )
    ]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "softmax_cycles",
            M,
        )
    ]

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
