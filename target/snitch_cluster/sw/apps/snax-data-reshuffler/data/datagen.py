#!/usr/bin/env python3

# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

import numpy as np
import argparse
import pathlib
import hjson
import sys
import os

# Add data utility path
sys.path.append(
    os.path.join(os.path.dirname(__file__), "../../../../../../util/sim/"))
from data_utils import format_scalar_definition, format_vector_definition  # noqa E402

np.random.seed(42)


def data_reshuffler_golden_model(
    tempLoop0,
    tempLoop1,
    spatial_len_0,
    spatial_len_1,
    tempStride0,
    tempStride1,
    spatialStride0,
    spatialStride1,
    data,
):
    # abstract illusion: k innermost loop, m second innermost loop,
    # K third innermost loop, M outermost loop

    # total loop bounds = spatial loop bounds * temporal loop bounds
    K = tempLoop0 * spatial_len_0
    M = tempLoop1 * spatial_len_1

    # loop bounds settings
    matrix_size = {"K": K, "M": M, "k": spatial_len_0, "m": spatial_len_1}

    # stride settings
    strides = {
        "M": tempStride1,
        "K": tempStride0,
        "m": spatialStride1,
        "k": spatialStride0,
    }

    result_array = np.zeros((matrix_size["M"] * matrix_size["K"]), np.int8)

    # apply strided layout mapping for the golden model of data reshuffler
    for M in range(matrix_size["M"] // matrix_size["m"]):
        for K in range(matrix_size["K"] // matrix_size["k"]):
            for m in range(matrix_size["m"]):
                for k in range(matrix_size["k"]):
                    result_array[
                        # output address calculation with coutinued increment
                        matrix_size["K"]
                        // matrix_size["k"]
                        * matrix_size["k"]
                        * matrix_size["m"]
                        * M
                        + matrix_size["k"] * matrix_size["m"] * K
                        + m * matrix_size["k"]
                        + k
                    ] = data[
                        # input address calculation with
                        # strided layout mapping eqaution
                        strides["M"] * M
                        + strides["K"] * K
                        + strides["m"] * m
                        + strides["k"] * k
                    ]

    return result_array.ravel()


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = "#include <stdint.h>\n\n"
    emit_str += "#include <stdbool.h> \n\n"
    emit_str += emit_gemm_data(**kwargs)
    return emit_str


MIN = -128
MAX = 127


def emit_gemm_data(**kwargs):
    data_str = []

    # Generating loop bounds settings
    data_str += [
        format_scalar_definition("int8_t", "tempLoop0", kwargs["tempLoop0"]),
        format_scalar_definition("int8_t", "tempLoop1", kwargs["tempLoop1"]),
    ]

    # Generating temporal strides settings
    # DMA strides (from L3 to L1)
    data_str += [
        format_scalar_definition(
            "int32_t", "DMAtempStride0_in", kwargs["DMAtempStride0_in"]
        ),
        format_scalar_definition(
            "int32_t", "DMAtempStride1_in", kwargs["DMAtempStride1_in"]
        ),
        format_scalar_definition(
            "int32_t", "DMAspatialStride1_in", kwargs["DMAspatialStride1_in"]
        ),
        # data reshuffler input strides
        format_scalar_definition("int32_t", "tempStride0_in",
                                 kwargs["tempStride0_in"]),
        format_scalar_definition("int32_t", "tempStride1_in",
                                 kwargs["tempStride1_in"]),
        format_scalar_definition(
            "int32_t", "spatialStride1_in", kwargs["spatialStride1_in"]
        ),
        # data reshuffler output strides
        format_scalar_definition(
            "int32_t",
            "tempStride0_out",
            kwargs["tempStride0_out"],
        ),
        format_scalar_definition(
            "int32_t", "tempStride1_out", kwargs["tempStride1_out"]
        ),
        format_scalar_definition(
            "int32_t", "spatialStride1_out", kwargs["spatialStride1_out"]
        ),
        # Generating base address pointers
        format_scalar_definition("int32_t", "delta_local_in",
                                 kwargs["delta_local_in"]),
        format_scalar_definition("int32_t", "delta_local_out",
                                 kwargs["delta_local_out"]),
    ]

    # Generating random input data vector
    length_in = (
        kwargs["tempLoop0"]
        * kwargs["tempLoop1"]
        * kwargs["spatial_len_0"]
        * kwargs["spatial_len_1"]
    )

    data_in = np.random.randint(MIN, MAX, length_in)

    op = kwargs["op"]

    # Generating golden data
    # NOTE: using 4 loops to iterate through the
    # input data and reshuffle the data.
    # different from the hardware data reshuffler,
    # the golden model uses the pure strided layout mapping equation,
    # no 64 data granularity constraint, no need to transpose explicitly.
    if op == "rowmajor2tiledrowmajor":
        c_golden = data_reshuffler_golden_model(
            kwargs["tempLoop0"],
            kwargs["tempLoop1"],
            kwargs["spatial_len_0"],
            kwargs["spatial_len_1"],
            kwargs["tempStride0_in"],
            kwargs["tempStride1_in"],
            1,
            kwargs["spatialStride1_in"],
            data_in,
        )

    if op == "rowmajor2tiledcolmajor":
        c_golden = data_reshuffler_golden_model(
            kwargs["tempLoop0"],
            kwargs["tempLoop1"],
            kwargs["spatial_len_0"],
            kwargs["spatial_len_1"],
            kwargs["tempStride0_in"],
            kwargs["tempStride1_in"],
            kwargs["tempLoop0"] * 8,
            1,
            data_in,
        )

    if op == "tiledrowmajor2tiledcolmajor":
        c_golden = data_reshuffler_golden_model(
            kwargs["tempLoop0"],
            kwargs["tempLoop1"],
            kwargs["spatial_len_0"],
            kwargs["spatial_len_1"],
            kwargs["tempStride0_in"],
            kwargs["tempStride1_in"],
            8,
            1,
            data_in,
        )

    # Generating transpose flag for the data reshuffler hardware
    if op == "rowmajor2tiledrowmajor":
        transpose = 0
    elif op == "rowmajor2tiledcolmajor":
        transpose = 1
    elif op == "tiledrowmajor2tiledcolmajor":
        transpose = 1
    else:
        print("Invalid operation")

    # set transpose or not
    data_str += [format_scalar_definition("bool", "transpose", transpose)]

    # Writing testing data and golden data into data.h
    data_str += [format_vector_definition("int8_t", "DataIn", data_in)]
    data_str += [format_vector_definition("int8_t", "C_golden", c_golden)]

    data_str = "\n\n".join(data_str)

    return data_str


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
