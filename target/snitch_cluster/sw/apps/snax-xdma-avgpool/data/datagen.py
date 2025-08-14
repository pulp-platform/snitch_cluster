#!/usr/bin/env python3

# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Jonas Crols <jonas.crols@student.kuleuven.be>

import argparse
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
from snax_utils import postprocessing_simd_golden_model_V3, sumpool_golden  # noqa E402


np.random.seed(320)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = ["#include <stdint.h>"]
    emit_str += emit_avgpool_data(**kwargs)
    return "\n\n".join(emit_str)


def emit_avgpool_data(**kwargs):

    data_in_type = "int8_t"
    data_out_type = "int8_t"

    emit_str = []
    padded_M = kwargs["M"]
    padded_N = kwargs["N"]
    channel_count = kwargs["channels"]
    m_kernel = kwargs["m_kernel"]
    n_kernel = kwargs["n_kernel"]
    m_stride = kwargs["m_stride"]
    n_stride = kwargs["n_stride"]

    # First input matrix for elementwise add
    matrix_data = np.random.randint(
        low=-128,
        high=127,
        size=(kwargs["M"], kwargs["N"], channel_count),
        dtype=np.int8,
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
    output_matrix = sumpool_golden(
        a_vals=matrix_data,
        m=padded_M,
        n=padded_N,
        channels=channel_count,
        m_kernel=m_kernel,
        n_kernel=n_kernel,
        m_stride=m_stride,
        n_stride=n_stride,
    )

    output_matrix = output_matrix.flatten()

    shift = 25
    multiplier = (2**25) // (m_kernel * n_kernel)

    for i in range(len(output_matrix)):
        output_matrix[i] = postprocessing_simd_golden_model_V3(
            output_matrix[i], 0, 0, shift, 127, -128, True, multiplier
        )

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
    temporal_bounds_src = [3, 3, 13, 13, 1]
    temporal_strides_src = [64, 1792, 128, 3584, 0]

    # Output Side (Writer)

    spatial_stride_dst = 8
    temporal_bounds_dst = [169]
    temporal_strides_dst = [
        64,
    ]

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

    emit_str += [format_scalar_definition("uint32_t", "shift_i", shift)]

    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "multiplier_i",
            multiplier,
        )
    ]

    emit_str += [format_scalar_definition("uint32_t", "input_zp_i", 0)]

    emit_str += [format_scalar_definition("uint32_t", "output_zp_i", 0)]

    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "kernel_size",
            m_kernel * n_kernel,
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
