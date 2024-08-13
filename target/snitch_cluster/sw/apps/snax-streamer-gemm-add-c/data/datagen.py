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
sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../../../util/sim/"))
from data_utils import format_scalar_definition, format_vector_definition  # noqa E402

# Add golden model path
from snax_utils import tiled_block_gemm_golden_model  # noqa E402

np.random.seed(42)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = "#include <stdint.h>\n\n"
    emit_str += emit_gemm_data(**kwargs)
    return emit_str


MIN = -128
MAX = 127


def emit_gemm_data(**kwargs):
    data_str = []

    # Generating matrix size settings
    data_str += [format_scalar_definition("int8_t", "Batch", kwargs["Batch"])]
    data_str += [format_scalar_definition("int", "M", kwargs["M"])]
    data_str += [format_scalar_definition("int", "K", kwargs["K"])]
    data_str += [format_scalar_definition("int", "N", kwargs["N"])]
    data_str += [format_scalar_definition("int", "M2", kwargs["M2"])]
    data_str += [format_scalar_definition("int", "K2", kwargs["K2"])]
    data_str += [format_scalar_definition("int", "N2", kwargs["N2"])]

    # Generating strides settings

    data_str += [
        format_scalar_definition(
            "int32_t", "strideInnermostA", kwargs["strideInnermostA"]
        )
    ]
    data_str += [
        format_scalar_definition(
            "int32_t", "strideInnermostB", kwargs["strideInnermostB"]
        )
    ]
    data_str += [
        format_scalar_definition(
            "int32_t", "strideInnermostC", kwargs["strideInnermostC"]
        )
    ]
    data_str += [
        format_scalar_definition("int32_t", "strideHalfC", kwargs["strideHalfC"])
    ]

    data_str += [format_scalar_definition("int32_t", "ldA", kwargs["ldA"])]
    data_str += [format_scalar_definition("int32_t", "ldB", kwargs["ldB"])]
    data_str += [format_scalar_definition("int32_t", "ldC", kwargs["ldC"])]

    data_str += [format_scalar_definition("int32_t", "spatialA", kwargs["spatialA"])]
    data_str += [format_scalar_definition("int32_t", "spatialB", kwargs["spatialB"])]
    data_str += [format_scalar_definition("int32_t", "spatialC", kwargs["spatialC"])]

    data_str += [format_scalar_definition("int32_t", "strideA", kwargs["strideA"])]
    data_str += [format_scalar_definition("int32_t", "strideB", kwargs["strideB"])]
    data_str += [format_scalar_definition("int32_t", "strideC", kwargs["strideC"])]

    data_str += [
        format_scalar_definition("int32_t", "delta_local_a", kwargs["delta_local_a"])
    ]
    data_str += [
        format_scalar_definition("int32_t", "delta_local_b", kwargs["delta_local_b"])
    ]
    data_str += [
        format_scalar_definition("int32_t", "delta_local_c", kwargs["delta_local_c"])
    ]
    data_str += [
        format_scalar_definition("int32_t", "delta_local_d", kwargs["delta_local_d"])
    ]

    # Generating random 8 integer a and b for subtraction
    subtraction_a = np.random.randint(MIN, MAX)
    subtraction_b = np.random.randint(MIN, MAX)

    # Writing the subtraction value to data.h
    data_str += [format_scalar_definition("int8_t", "subtraction_a", subtraction_a)]
    data_str += [format_scalar_definition("int8_t", "subtraction_b", subtraction_b)]

    # Generate random input matrices
    length_a = (
        kwargs["M2"]
        * kwargs["K2"]
        * kwargs["M"]
        * kwargs["K"]
        * kwargs["meshRow"]
        * kwargs["tileSize"]
    )
    length_b = (
        kwargs["N2"]
        * kwargs["K2"]
        * kwargs["N"]
        * kwargs["K"]
        * kwargs["meshCol"]
        * kwargs["tileSize"]
    )
    length_c = (
        kwargs["M2"]
        * kwargs["N2"]
        * kwargs["M"]
        * kwargs["N"]
        * kwargs["meshRow"]
        * kwargs["meshCol"]
    )

    a = np.random.randint(MIN, MAX, length_a)
    b = np.random.randint(MIN, MAX, length_b)

    # c = np.random.randint(MIN, MAX, length_c)
    c = np.zeros(length_c, np.int32)

    # Generating golden data
    d_golden = tiled_block_gemm_golden_model(
        kwargs["M2"],
        kwargs["K2"],
        kwargs["N2"],
        kwargs["M"],
        kwargs["K"],
        kwargs["N"],
        kwargs["meshRow"],
        kwargs["tileSize"],
        kwargs["meshCol"],
        a,
        b,
        subtraction_a,
        subtraction_b,
        c,
    )

    d_init = np.zeros(d_golden.shape, np.int32)

    # Writing testing data and golden data into data.h
    data_str += [format_vector_definition("int8_t", "A", a)]
    data_str += [format_vector_definition("int8_t", "B", b)]
    data_str += [format_vector_definition("int32_t", "C", c)]
    data_str += [format_vector_definition("int32_t", "D_golden", d_golden)]
    data_str += [format_vector_definition("int32_t", "D", d_init)]

    data_str = "\n\n".join(data_str)

    return data_str


def main():
    # Parsing cmd args
    parser = argparse.ArgumentParser(description="Generate data for kernels")
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
