#!/usr/bin/env python3

# Copyright 2025 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Yunhao Deng <yunhao.deng@kuleuven.be>

import numpy as np
import argparse
import pathlib
import hjson
import sys
import os
import re

# Add data utility path
sys.path.append(os.path.join(os.path.dirname(
    __file__), "../../../../../../util/sim/"))
from data_utils import format_scalar_definition, format_vector_definition  # noqa E402

# # Add golden model path
# from snax_utils import data_reshuffler_golden_model, max_pooling, im2col  # noqa E402

np.random.seed(320)

# Add stdint.h header


def emit_header_file(**kwargs):
    emit_str = ["#include <stdint.h>"]
    emit_str += emit_transposer_data(**kwargs)
    return "\n\n".join(emit_str)


def emit_transposer_data(**kwargs):
    emit_str = []
    matrix_data = np.random.randint(low=0, high=255, size=(
        kwargs["M"], kwargs["N"]), dtype=np.uint8)
    input_matrix = matrix_data
    if kwargs["input_layout"] == "MN":
        input_matrix = input_matrix.ravel()
    else:
        match = re.search(r'M(\d+)N(\d+)MN', kwargs["input_layout"])
        if match:
            m, n = match.groups()
            m, n = int(m), int(n)
            input_matrix = input_matrix.reshape(
                input_matrix.shape[0] // m,
                m,
                input_matrix.shape[1] // n,
                n).swapaxes(
                1,
                2).ravel()
        else:
            raise ValueError(f"Invalid input layout: {kwargs['input_layout']}")

    # Emit input matrix
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "matrix_size",
            matrix_data.size)]
    emit_str += [format_vector_definition("uint8_t",
                                          "input_matrix", input_matrix)]

    # Emit output matrix
    output_matrix = matrix_data
    if kwargs["enable_transpose"] is True:
        output_matrix = output_matrix.T
    if kwargs["output_layout"] == "MN":
        output_matrix = output_matrix.ravel()
    else:
        match = re.search(r'M(\d+)N(\d+)MN', kwargs["output_layout"])
        if match:
            m, n = match.groups()
            m, n = int(m), int(n)
            output_matrix = output_matrix.reshape(
                output_matrix.shape[0] // m,
                m,
                output_matrix.shape[1] // n,
                n).swapaxes(
                1,
                2).ravel()
        else:
            raise ValueError(
                f"Invalid output layout: {kwargs['output_layout']}")
    emit_str += [format_vector_definition("uint8_t",
                                          "golden_output_matrix",
                                          output_matrix)]

    # Emit the configuration for XDMA
    spatial_stride_src = None
    spatial_stride_dst = None
    temporal_strides_src = []
    temporal_strides_dst = []
    temporal_bounds_src = []
    temporal_bounds_dst = []

    if kwargs["input_layout"] == "MN":
        spatial_stride_src = matrix_data.shape[1]
        temporal_bounds_src = [matrix_data.shape[1] //
                               8, matrix_data.shape[0] // 8]
        temporal_strides_src = [8, matrix_data.shape[1] * 8]
    else:
        match = re.search(r'M(\d+)N(\d+)MN', kwargs["input_layout"])
        m, n = match.groups()
        m, n = int(m), int(n)
        spatial_stride_src = n
        temporal_bounds_src = [n // 8, matrix_data.shape[1] // n, m // 8,
                               matrix_data.shape[0] // m]
        temporal_strides_src = [8, m * n, n * 8, matrix_data.shape[1] * m]
    if kwargs["enable_transpose"] is True:
        if kwargs["output_layout"] == "MN":
            spatial_stride_dst = matrix_data.shape[0]
            temporal_bounds_dst = [
                matrix_data.shape[1] // 8, matrix_data.shape[0] // 8]
            temporal_strides_dst = [matrix_data.shape[0] * 8, 8]
        else:
            match = re.search(r'M(\d+)N(\d+)MN', kwargs["output_layout"])
            m, n = match.groups()
            m, n = int(m), int(n)
            spatial_stride_dst = n
            temporal_bounds_dst = [
                m // 8,
                matrix_data.shape[1] // m,
                n // 8,
                matrix_data.shape[0] // n]
            temporal_strides_dst = [n * 8, m * matrix_data.shape[0], 8, m * n]
    else:
        if kwargs["output_layout"] == "MN":
            spatial_stride_dst = matrix_data.shape[1]
            temporal_bounds_dst = [
                matrix_data.shape[1] // 8, matrix_data.shape[0] // 8]
            temporal_strides_dst = [8, matrix_data.shape[1] * 8]
        else:
            match = re.search(r'M(\d+)N(\d+)MN', kwargs["output_layout"])
            m, n = match.groups()
            m, n = int(m), int(n)
            spatial_stride_dst = n
            temporal_bounds_dst = [
                n // 8,
                matrix_data.shape[1] // n,
                m // 8,
                matrix_data.shape[0] // m]
            temporal_strides_dst = [8, m * n, n * 8, matrix_data.shape[1] * m]

    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "spatial_stride_src",
            spatial_stride_src)]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "spatial_stride_dst",
            spatial_stride_dst)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_bounds_src",
                                          temporal_bounds_src)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_bounds_dst",
                                          temporal_bounds_dst)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_strides_src",
                                          temporal_strides_src)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_strides_dst",
                                          temporal_strides_dst)]
    emit_str += [format_scalar_definition("uint32_t",
                                          "temporal_dimension_src",
                                          len(temporal_bounds_src))]
    emit_str += [format_scalar_definition("uint32_t",
                                          "temporal_dimension_dst",
                                          len(temporal_bounds_dst))]

    emit_str += [format_scalar_definition("uint8_t",
                                          "enable_transpose",
                                          1 if kwargs["enable_transpose"]
                                          else 0)]
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
