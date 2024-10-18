#!/usr/bin/env python3

# Copyright 2024 KU Leuven.
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
from snax_utils import (  # noqa E402
    conv2d,
    im2col,
    block_gemm_golden_model,
    data_reshuffler_golden_model,
    postprocessing_simd_golden_model,
    align_wide_addr,
)  # noqa E402

np.random.seed(42)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = "#include <stdint.h>\n\n"
    emit_str += emit_gemmx_data(**kwargs)
    return emit_str


MIN = -128
MAX = 127

bankWidth = 64
input_data_width = 8
output_data_width = 32
quantized_output_data_width = 8


def emit_matmul_data(**kwargs):

    meshRow = kwargs["meshRow"]
    tileSize = kwargs["tileSize"]
    meshCol = kwargs["meshCol"]

    # matmul settings
    data_str = []

    data_str += [format_scalar_definition("int", "Batch", 1)]
    data_str += [format_scalar_definition("int", "M", kwargs["M"])]
    data_str += [format_scalar_definition("int", "K", kwargs["K"])]
    data_str += [format_scalar_definition("int", "N", kwargs["N"])]

    data_str += [format_scalar_definition("int32_t", "Aslstride0", 1)]
    data_str += [format_scalar_definition("int32_t", "Aslstride1", bankWidth / 8)]
    data_str += [format_scalar_definition("int32_t", "Atlbound0", kwargs["K"])]
    data_str += [
        format_scalar_definition(
            "int32_t", "Atlstride0", input_data_width * tileSize * meshRow / 8
        )
    ]
    data_str += [format_scalar_definition("int32_t", "Atlbound1", kwargs["N"])]
    data_str += [format_scalar_definition("int32_t", "Atlstride1", 0)]
    data_str += [format_scalar_definition("int32_t", "Atlbound2", kwargs["M"])]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "Atlstride2",
            kwargs["K"] * input_data_width * tileSize * meshRow / 8,
        )
    ]
    data_str += [format_scalar_definition("int32_t", "Atlbound3", 1)]
    data_str += [format_scalar_definition("int32_t", "Atlstride3", 0)]
    data_str += [format_scalar_definition("int32_t", "Atlbound4", 1)]
    data_str += [format_scalar_definition("int32_t", "Atlstride4", 0)]
    data_str += [format_scalar_definition("int32_t", "Atlbound5", 1)]
    data_str += [format_scalar_definition("int32_t", "Atlstride5", 0)]

    data_str += [format_scalar_definition("int32_t", "Bslstride0", 1)]
    data_str += [format_scalar_definition("int32_t", "Bslstride1", bankWidth / 8)]
    data_str += [format_scalar_definition("int32_t", "Btlbound0", kwargs["K"])]
    data_str += [
        format_scalar_definition(
            "int32_t", "Btlstride0", input_data_width * tileSize * meshCol / 8
        )
    ]
    data_str += [format_scalar_definition("int32_t", "Btlbound1", kwargs["N"])]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "Btlstride1",
            kwargs["K"] * input_data_width * tileSize * meshCol / 8,
        )
    ]
    data_str += [format_scalar_definition("int32_t", "Btlbound2", kwargs["M"])]
    data_str += [format_scalar_definition("int32_t", "Btlstride2", 0)]

    data_str += [format_scalar_definition("int32_t", "Cslstride0", bankWidth / 8)]
    c32_spatial_bound_0 = 8
    data_str += [
        format_scalar_definition(
            "int32_t", "Cslstride1", c32_spatial_bound_0 * (bankWidth / 8)
        )
    ]
    data_str += [format_scalar_definition("int32_t", "Ctlbound0", kwargs["N"])]
    data_str += [
        format_scalar_definition(
            "int32_t", "Ctlstride0", output_data_width * meshRow * meshCol / 8
        )
    ]
    data_str += [format_scalar_definition("int32_t", "Ctlbound1", kwargs["M"])]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "Ctlstride1",
            kwargs["N"] * output_data_width * meshRow * meshCol / 8,
        )
    ]
    data_str += [format_scalar_definition("int32_t", "Ctlbound2", 1)]
    data_str += [format_scalar_definition("int32_t", "Ctlstride2", 0)]

    data_str += [format_scalar_definition("int32_t", "D32slstride0", bankWidth / 8)]
    d32_spatial_bound_0 = 8
    data_str += [
        format_scalar_definition(
            "int32_t", "D32slstride1", d32_spatial_bound_0 * (bankWidth / 8)
        )
    ]
    data_str += [format_scalar_definition("int32_t", "D32tlbound0", kwargs["N"])]
    data_str += [
        format_scalar_definition(
            "int32_t", "D32tlstride0", output_data_width * meshRow * meshCol / 8
        )
    ]
    data_str += [format_scalar_definition("int32_t", "D32tlbound1", kwargs["M"])]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "D32tlstride1",
            kwargs["N"] * output_data_width * meshRow * meshCol / 8,
        )
    ]
    data_str += [format_scalar_definition("int32_t", "D32tlbound2", 1)]
    data_str += [format_scalar_definition("int32_t", "D32tlstride2", 0)]

    data_str += [format_scalar_definition("int32_t", "D8slstride0", 1)]
    data_str += [format_scalar_definition("int32_t", "D8slstride1", bankWidth / 8)]
    data_str += [format_scalar_definition("int32_t", "D8tlbound0", kwargs["N"])]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "D8tlstride0",
            quantized_output_data_width * meshRow * meshCol / 8,
        )
    ]
    data_str += [format_scalar_definition("int32_t", "D8tlbound1", kwargs["M"])]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "D8tlstride1",
            kwargs["N"] * quantized_output_data_width * meshRow * meshCol / 8,
        )
    ]
    data_str += [format_scalar_definition("int32_t", "D8tlbound2", 1)]
    data_str += [format_scalar_definition("int32_t", "D8tlstride2", 0)]

    delta_local_a = 0
    delta_local_b = (
        kwargs["K"] * kwargs["M"] * (meshRow * tileSize * input_data_width / 8)
    )
    delta_local_c = delta_local_b + kwargs["K"] * kwargs["N"] * (
        meshCol * tileSize * input_data_width / 8
    )
    delta_local_d32 = delta_local_c + kwargs["M"] * kwargs["N"] * (
        meshRow * meshCol * output_data_width / 8
    )
    delta_local_d8 = delta_local_d32
    data_str += [format_scalar_definition("int32_t", "delta_local_a", delta_local_a)]
    data_str += [format_scalar_definition("int32_t", "delta_local_b", delta_local_b)]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "delta_local_c",
            delta_local_c,
        )
    ]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "delta_local_d32",
            delta_local_d32,
        )
    ]
    data_str += [
        format_scalar_definition(
            "int32_t",
            "delta_local_d8",
            delta_local_d8,
        )
    ]

    # Generating random 8 integer a and b for subtraction
    subtraction_a = np.random.randint(MIN, MAX)
    subtraction_b = np.random.randint(MIN, MAX)

    # Writing the subtraction value to data.h
    data_str += [format_scalar_definition("int8_t", "subtraction_a", subtraction_a)]
    data_str += [format_scalar_definition("int8_t", "subtraction_b", subtraction_b)]

    A = np.random.randint(
        MIN, MAX, size=(kwargs["M"], kwargs["K"], meshRow, tileSize)
    ).reshape(-1)
    data_str += [format_vector_definition("int8_t", "A", A)]

    B = np.random.randint(
        MIN, MAX, size=(kwargs["K"], kwargs["N"], tileSize, meshCol)
    ).reshape(-1)
    data_str += [format_vector_definition("int8_t", "B", B)]

    broadcast_C = kwargs["broadcast_C"] == 1 and kwargs["channel_en_C"] == 1
    disable_C = kwargs["broadcast_C"] == 0 and kwargs["channel_en_C"] == 0
    enable_full_C = kwargs["broadcast_C"] == 0 and kwargs["channel_en_C"] == 1

    assert broadcast_C or disable_C or enable_full_C, "Invalid C settings"

    if broadcast_C == 1:
        C = np.random.randint(MIN, MAX, size=(kwargs["M"], kwargs["N"], 1, meshCol))
        C = np.repeat(C, repeats=8, axis=1).reshape(-1)
    elif enable_full_C == 1:
        C = np.random.randint(
            MIN, MAX, size=(kwargs["M"], kwargs["N"], meshRow, meshCol)
        ).reshape(-1)
    else:
        C = np.random.randint(
            0, 1, size=(kwargs["M"], kwargs["N"], meshRow, meshCol)
        ).reshape(-1)

    if broadcast_C == 1:
        data_str += [format_scalar_definition("int32_t", "channel_en_C", 0b11111111)]
    elif enable_full_C == 1:
        data_str += [
            format_scalar_definition("int32_t", "channel_en_C", ((1 << 32) - 1))
        ]
    else:
        data_str += [format_scalar_definition("int32_t", "channel_en_C", 0)]

    data_str += [
        format_scalar_definition("int32_t", "broadcast_C", kwargs["broadcast_C"])
    ]
    data_str += [format_vector_definition("int32_t", "C", C)]

    if kwargs["transposed_A"] == 1:
        A = A.reshape(kwargs["M"], kwargs["K"], meshRow, tileSize)
        A = A.transpose(0, 1, 3, 2).reshape(-1)
    if kwargs["transposed_B"] == 1:
        B = B.reshape(kwargs["K"], kwargs["N"], tileSize, meshCol)
        B = B.transpose(0, 1, 3, 2).reshape(-1)

    data_str += [
        format_scalar_definition("int32_t", "transposed_A", kwargs["transposed_A"])
    ]
    data_str += [
        format_scalar_definition("int32_t", "transposed_B", kwargs["transposed_B"])
    ]

    D32 = block_gemm_golden_model(
        kwargs["M"],
        kwargs["K"],
        kwargs["N"],
        meshRow,
        tileSize,
        meshCol,
        A,
        B,
        subtraction_a,
        subtraction_b,
        C,
    )

    return data_str, D32


def emit_gemmx_data(**kwargs):
    data_str, D32 = emit_matmul_data(**kwargs)

    data_str += [format_vector_definition("int32_t", "D32", D32)]

    # -----------------------------------------------------------
    # Postprocessing
    # -----------------------------------------------------------

    bypassSIMD = kwargs["bypassSIMD"]
    data_str += [format_scalar_definition("int32_t", "bypassSIMD", bypassSIMD)]

    # Generating random constant values
    group_num = 8
    input_zp_i = np.random.randint(MIN, MAX)
    output_zp_i = np.random.randint(MIN, MAX)
    max_int_i = MAX
    min_int_i = MIN
    double_round_i = np.random.randint(0, 1)

    shift_i = np.random.randint(0, 63, size=group_num)  # values between 0-63
    multiplier_i = np.random.randint(-(2**31), 2**31 - 1, size=group_num)

    # Writing the constant values to data.h
    data_str += [
        format_scalar_definition("int8_t", "input_zp_i", input_zp_i),
        format_scalar_definition("int8_t", "output_zp_i", output_zp_i),
        format_scalar_definition("int8_t", "max_int_i", max_int_i),
        format_scalar_definition("int8_t", "min_int_i", min_int_i),
        format_scalar_definition("int8_t", "double_round_i", double_round_i),
    ]

    shared_bitpacked_shift0 = (
        (shift_i[3] << 24) | (shift_i[2] << 16) | (shift_i[1] << 8) | shift_i[0]
    )
    shared_bitpacked_shift1 = (
        (shift_i[7] << 24) | (shift_i[6] << 16) | (shift_i[5] << 8) | shift_i[4]
    )
    data_str += [
        format_scalar_definition(
            "int32_t", "shared_bitpacked_shift0", shared_bitpacked_shift0
        )
    ]
    data_str += [
        format_scalar_definition(
            "int32_t", "shared_bitpacked_shift1", shared_bitpacked_shift1
        )
    ]

    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier0", multiplier_i[0])
    ]
    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier1", multiplier_i[1])
    ]
    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier2", multiplier_i[2])
    ]
    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier3", multiplier_i[3])
    ]
    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier4", multiplier_i[4])
    ]
    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier5", multiplier_i[5])
    ]
    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier6", multiplier_i[6])
    ]
    data_str += [
        format_scalar_definition("int32_t", "shared_multiplier7", multiplier_i[7])
    ]

    D8 = np.zeros_like(D32, dtype=np.uint8)
    # output channel (innermost dim) has a different scale factor
    for i in range(group_num):
        D8[i::group_num] = postprocessing_simd_golden_model(
            D32[i::group_num],
            input_zp_i,
            output_zp_i,
            shift_i[i],
            max_int_i,
            min_int_i,
            double_round_i,
            multiplier_i[i],
        )

    data_str += [format_vector_definition("int8_t", "D8", D8)]

    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_A", 0)]
    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_B", 0)]
    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_C", 0)]
    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_D32", 0)]
    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_D8", 0)]

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
