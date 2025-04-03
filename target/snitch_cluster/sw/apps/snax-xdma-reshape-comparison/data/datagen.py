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
from data_utils import format_scalar_definition, format_vector_definition, format_scalar_define, format_vector_define  # noqa E402

np.random.seed(320)

# Add stdint.h header


def emit_header_file(**kwargs):
    emit_str = ["#include <stdint.h>"]
    emit_str += emit_transposer_data(**kwargs)
    return "\n\n".join(emit_str)


def emit_transposer_data(**kwargs):
    emit_str = []
    padded_M = (kwargs["M"] + 7) // 8 * 8
    padded_N = (kwargs["N"] + 7) // 8 * 8
    matrix_data = np.zeros((padded_M, padded_N), dtype=np.uint8)
    matrix_data[:kwargs["M"], :kwargs["N"]] = np.random.randint(
        low=0, high=255, size=(kwargs["M"], kwargs["N"]), dtype=np.uint8)
    input_matrix = matrix_data
    if kwargs["input_layout"] == "MN":
        input_matrix = input_matrix.ravel()
    else:
        match = re.search(r'MNM(\d+)N(\d+)', kwargs["input_layout"])
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
    if kwargs["output_layout"] == "MN":
        output_matrix = output_matrix.ravel()
    else:
        match = re.search(r'MNM(\d+)N(\d+)', kwargs["output_layout"])
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
    spatial_stride_src_xdma = None
    spatial_stride_dst_xdma = None
    temporal_strides_src_xdma = []
    temporal_strides_dst_xdma = []
    temporal_bounds_src_xdma = []
    temporal_bounds_dst_xdma = []

    if kwargs["input_layout"] == "MN":
        spatial_stride_src_xdma = matrix_data.shape[1]
        temporal_bounds_src_xdma = [matrix_data.shape[1] //
                                    8, matrix_data.shape[0] // 8]
        temporal_strides_src_xdma = [8, matrix_data.shape[1] * 8]
    else:
        match = re.search(r'MNM(\d+)N(\d+)', kwargs["input_layout"])
        m, n = match.groups()
        m, n = int(m), int(n)
        spatial_stride_src_xdma = n
        temporal_bounds_src_xdma = [n // 8, matrix_data.shape[1] // n, m // 8,
                                    matrix_data.shape[0] // m]
        temporal_strides_src_xdma = [8, m * n, n * 8, matrix_data.shape[1] * m]

    if kwargs["output_layout"] == "MN":
        spatial_stride_dst_xdma = matrix_data.shape[1]
        temporal_bounds_dst_xdma = [
            matrix_data.shape[1] // 8, matrix_data.shape[0] // 8]
        temporal_strides_dst_xdma = [8, matrix_data.shape[1] * 8]
    else:
        match = re.search(r'MNM(\d+)N(\d+)', kwargs["output_layout"])
        m, n = match.groups()
        m, n = int(m), int(n)
        spatial_stride_dst_xdma = n
        temporal_bounds_dst_xdma = [
            n // 8,
            matrix_data.shape[1] // n,
            m // 8,
            matrix_data.shape[0] // m]
        temporal_strides_dst_xdma = [8, m * n, n * 8, matrix_data.shape[1] * m]

    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "spatial_stride_src_xdma",
            spatial_stride_src_xdma)]
    emit_str += [
        format_scalar_definition(
            "uint32_t",
            "spatial_stride_dst_xdma",
            spatial_stride_dst_xdma)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_bounds_src_xdma",
                                          temporal_bounds_src_xdma)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_bounds_dst_xdma",
                                          temporal_bounds_dst_xdma)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_strides_src_xdma",
                                          temporal_strides_src_xdma)]
    emit_str += [format_vector_definition("uint32_t",
                                          "temporal_strides_dst_xdma",
                                          temporal_strides_dst_xdma)]
    emit_str += [format_scalar_definition("uint32_t",
                                          "temporal_dimension_src_xdma",
                                          len(temporal_bounds_src_xdma))]
    emit_str += [format_scalar_definition("uint32_t",
                                          "temporal_dimension_dst_xdma",
                                          len(temporal_bounds_dst_xdma))]

    # Emit the configuration for IDMA
    input_layout_tile_m = None
    input_layout_tile_n = None
    output_layout_tile_m = None
    output_layout_tile_n = None
    if kwargs["input_layout"] == "MN":
        input_layout_tile_m = matrix_data.shape[0]
        input_layout_tile_n = matrix_data.shape[1]
    else:
        match = re.search(r'MNM(\d+)N(\d+)', kwargs["input_layout"])
        input_layout_tile_m, input_layout_tile_n = match.groups()
        input_layout_tile_m, input_layout_tile_n = int(
            input_layout_tile_m), int(input_layout_tile_n)
    if kwargs["output_layout"] == "MN":
        output_layout_tile_m = matrix_data.shape[0]
        output_layout_tile_n = matrix_data.shape[1]
    else:
        match = re.search(r'MNM(\d+)N(\d+)', kwargs["output_layout"])
        output_layout_tile_m, output_layout_tile_n = match.groups()
        output_layout_tile_m, output_layout_tile_n = int(
            output_layout_tile_m), int(output_layout_tile_n)

    min_layout_tile_m = min(input_layout_tile_m, output_layout_tile_m)
    min_layout_tile_n = min(input_layout_tile_n, output_layout_tile_n)

    emit_str += [format_scalar_definition("uint32_t",
                                          "size_idma",
                                          min_layout_tile_n)]
    emit_str += [format_scalar_definition("uint32_t",
                                          "src_stride_idma",
                                          input_layout_tile_n)]
    emit_str += [format_scalar_definition("uint32_t",
                                          "dst_stride_idma",
                                          output_layout_tile_n)]
    emit_str += [format_scalar_definition("uint32_t",
                                          "repeat_idma",
                                          min_layout_tile_m)]
    emit_str += [
        format_scalar_define(
            "total_iterations_idma",
            matrix_data.shape[0] *
            matrix_data.shape[1] //
            min_layout_tile_m //
            min_layout_tile_n)]
    emit_str += [format_vector_definition("uint32_t",
                                          "sw_src_bound_idma",
                                          [input_layout_tile_n // min_layout_tile_n,
                                           matrix_data.shape[1] // input_layout_tile_n,
                                           input_layout_tile_m // min_layout_tile_m,
                                           matrix_data.shape[0] // input_layout_tile_m])]
    emit_str += [format_vector_definition("uint32_t",
                                          "sw_dst_bound_idma",
                                          [output_layout_tile_n // min_layout_tile_n,
                                           matrix_data.shape[1] // output_layout_tile_n,
                                           output_layout_tile_m // min_layout_tile_m,
                                           matrix_data.shape[0] // output_layout_tile_m])]
    emit_str += [format_vector_definition("uint32_t",
                                          "sw_src_stride_idma",
                                          [min_layout_tile_n,
                                           input_layout_tile_m * input_layout_tile_n,
                                           min_layout_tile_m * input_layout_tile_n,
                                           input_layout_tile_m * matrix_data.shape[1]])]
    emit_str += [format_vector_definition("uint32_t",
                                          "sw_dst_stride_idma",
                                          [min_layout_tile_n,
                                           output_layout_tile_m * output_layout_tile_n,
                                           min_layout_tile_m * output_layout_tile_n,
                                           output_layout_tile_m * matrix_data.shape[1]])]

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
