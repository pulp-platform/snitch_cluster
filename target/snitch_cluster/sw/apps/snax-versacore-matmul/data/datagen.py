#!/usr/bin/env python3

# Copyright 2025 KU Leuven.
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
import math

# Add data utility path
sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../../../util/sim/"))
from data_utils import format_scalar_definition, format_vector_definition  # noqa E402

# Add golden model path
from snax_utils import (  # noqa E402
    block_gemm_golden_model,
    align_wide_addr,
)  # noqa E402

np.random.seed(42)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = "#include <stdint.h>\n\n"
    emit_str += emit_matmul_data(**kwargs)
    return emit_str


def signed_int_range(bits):
    min_val = -(2 ** (bits - 1))
    max_val = 2 ** (bits - 1) - 1
    return min_val, max_val


def signed_to_unsigned(val, bit_width):
    """
    Convert signed N-bit integer to its unsigned two's complement representation.

    Args:
        val (int): Signed integer to convert.
        bit_width (int): Number of bits of the signed integer.

    Returns:
        int: Unsigned two's complement representation.
    """
    min_val = -(1 << (bit_width - 1))
    max_val = (1 << (bit_width - 1)) - 1

    if val < min_val or val > max_val:
        raise ValueError(f"Value {val} out of range for signed {bit_width}-bit integer")

    return val & ((1 << bit_width) - 1)


def pack_signed_nbit(B, bit_width, pack_per_byte=2):
    """
    Pack a list of signed N-bit integers into 8-bit signed integers.

    Args:
        B (list[int]): List of signed integers.
        bit_width (int): Bit width of each input value.
        pack_per_byte (int): How many values to pack per 8-bit byte.

    Returns:
        list[int]: List of packed signed 8-bit integers.
    """
    if len(B) % pack_per_byte != 0:
        raise ValueError(
            f"Length of B must be a multiple of {pack_per_byte} to pack into 8-bit integers"
        )

    packed = []
    for i in range(0, len(B), pack_per_byte):
        byte = 0
        for j in range(pack_per_byte):
            val = signed_to_unsigned(B[i + j], bit_width)
            byte |= val << (j * bit_width)
        # Convert to signed 8-bit representation if needed
        if byte >= 128:
            byte -= 256
        packed.append(byte)
    return packed


def gen_channel_enable_CSR(channel_en_CSR, channel_en_bits):
    for i in range(channel_en_bits):
        element_index = i // 32  # Determine which element to modify
        bit_position = i % 32  # Position within the element
        if element_index < len(channel_en_CSR):
            channel_en_CSR[element_index] |= 1 << (bit_position)

    channel_en_CSR = [int(x) for x in channel_en_CSR][::-1]
    return channel_en_CSR


def emit_matmul_data(**kwargs):

    # -------------------------------------------------------------
    # matmul workload settings
    # -------------------------------------------------------------
    data_str = []

    M = kwargs["M"]
    K = kwargs["K"]
    N = kwargs["N"]

    data_str += [format_scalar_definition("uint32_t", "M", M)]
    data_str += [format_scalar_definition("uint32_t", "K", K)]
    data_str += [format_scalar_definition("uint32_t", "N", N)]

    array_shape = kwargs["array_shape"]
    data_str += [format_scalar_definition("uint32_t", "array_shape", array_shape)]
    data_type = kwargs["data_type"]
    data_str += [format_scalar_definition("uint32_t", "data_type", data_type)]

    # -------------------------------------------------------------
    # -----------------------hardware parameters--------------------
    # --------------------------------------------------------------

    snax_acc_cfg = kwargs["snax_versacore_core_template"]["snax_acc_cfg"][0]
    meshRow = snax_acc_cfg["snax_versacore_spatial_unrolling"][data_type][array_shape][
        0
    ]
    tileSize = snax_acc_cfg["snax_versacore_spatial_unrolling"][data_type][array_shape][
        1
    ]
    meshCol = snax_acc_cfg["snax_versacore_spatial_unrolling"][data_type][array_shape][
        2
    ]

    a_len = snax_acc_cfg["snax_versacore_input_a_element_width"][data_type]
    A_MIN, A_MAX = signed_int_range(a_len)
    b_len = snax_acc_cfg["snax_versacore_input_b_element_width"][data_type]
    B_MIN, B_MAX = signed_int_range(b_len)
    c_len = snax_acc_cfg["snax_versacore_output_element_width"][data_type]
    C_MIN, C_MAX = signed_int_range(c_len)

    a_array_width = snax_acc_cfg["snax_versacore_array_input_a_width"]
    b_array_width = snax_acc_cfg["snax_versacore_array_input_b_width"]
    c_array_width = snax_acc_cfg["snax_versacore_array_input_c_width"]
    d_array_width = snax_acc_cfg["snax_versacore_array_output_width"]
    assert c_array_width == d_array_width, "C and D array width must be the same"
    snax_versacore_serial_c_d_width = snax_acc_cfg["snax_versacore_serial_c_d_width"]

    bankWidth = 64

    data_str += [format_scalar_definition("uint32_t", "meshRow", meshRow)]
    data_str += [format_scalar_definition("uint32_t", "tileSize", tileSize)]
    data_str += [format_scalar_definition("uint32_t", "meshCol", meshCol)]

    stationary = kwargs["stationary"]
    data_str += [format_scalar_definition("uint32_t", "stationary", stationary)]
    assert (
        stationary == 0 or stationary == 1 or stationary == 2
    ), "Invalid stationary setting"
    output_stationary = 0
    weight_stationary = 1
    input_stationary = 2
    # -------------------------------------------------------------
    # -----------------------A streamer setting-------------------------------
    # --------------------------------------------------------------
    data_str += [format_scalar_definition("int32_t", "Aslstride0", bankWidth / 8)]

    if stationary == output_stationary:
        data_str += [format_scalar_definition("int32_t", "Atlbound0", K)]
        data_str += [
            format_scalar_definition(
                "int32_t", "Atlstride0", a_len * tileSize * meshRow / 8
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Atlbound1", N)]
        data_str += [format_scalar_definition("int32_t", "Atlstride1", 0)]
        data_str += [format_scalar_definition("int32_t", "Atlbound2", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Atlstride2",
                K * a_len * tileSize * meshRow / 8,
            )
        ]
    elif stationary == weight_stationary:
        data_str += [format_scalar_definition("int32_t", "Atlbound0", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Atlstride0",
                K * a_len * tileSize * meshRow / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Atlbound1", K)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Atlstride1",
                a_len * tileSize * meshRow / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Atlbound2", N)]
        data_str += [format_scalar_definition("int32_t", "Atlstride2", 0)]
    elif stationary == input_stationary:
        data_str += [format_scalar_definition("int32_t", "Atlbound0", N)]
        data_str += [format_scalar_definition("int32_t", "Atlstride0", 0)]
        data_str += [format_scalar_definition("int32_t", "Atlbound1", K)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Atlstride1",
                a_len * tileSize * meshRow / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Atlbound2", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Atlstride2",
                K * a_len * tileSize * meshRow / 8,
            )
        ]

    data_str += [format_scalar_definition("int32_t", "Atlbound3", 1)]
    data_str += [format_scalar_definition("int32_t", "Atlstride3", 0)]
    data_str += [format_scalar_definition("int32_t", "Atlbound4", 1)]
    data_str += [format_scalar_definition("int32_t", "Atlstride4", 0)]
    data_str += [format_scalar_definition("int32_t", "Atlbound5", 1)]
    data_str += [format_scalar_definition("int32_t", "Atlstride5", 0)]

    A_enabled_channel_CSR_num = int(math.ceil(a_array_width / bankWidth / 32))
    channel_en_A = [0] * A_enabled_channel_CSR_num
    # related to if this is a wide channel or not
    # if wide, must be divisible by 8
    # if narrow, must be divisible by 1
    channel_en_A_bits = max(
        8, int((meshRow * tileSize * a_len / bankWidth + 7) // 8 * 8)
    )
    channel_en_A = gen_channel_enable_CSR(
        channel_en_A,
        channel_en_A_bits,
    )
    data_str += [
        "int32_t channel_en_A[] = { " + ", ".join(map(str, channel_en_A)) + " };"
    ]

    a_data_length = M * K * meshRow * tileSize * a_len / 8  # in bytes
    data_str += [format_scalar_definition("int32_t", "a_data_length", a_data_length)]

    # -------------------------------------------------------------
    # -----------------------B setting-------------------------------
    # --------------------------------------------------------------

    data_str += [format_scalar_definition("int32_t", "Bslstride0", bankWidth / 8)]

    if stationary == output_stationary:
        data_str += [format_scalar_definition("int32_t", "Btlbound0", K)]
        data_str += [
            format_scalar_definition(
                "int32_t", "Btlstride0", b_len * tileSize * meshCol / 8
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Btlbound1", N)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Btlstride1",
                K * b_len * tileSize * meshCol / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Btlbound2", M)]
        data_str += [format_scalar_definition("int32_t", "Btlstride2", 0)]
    elif stationary == weight_stationary:
        data_str += [format_scalar_definition("int32_t", "Btlbound0", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Btlstride0",
                0,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Btlbound1", K)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Btlstride1",
                b_len * tileSize * meshCol / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Btlbound2", N)]
        data_str += [
            format_scalar_definition(
                "int32_t", "Btlstride2", K * b_len * tileSize * meshCol / 8
            )
        ]
    elif stationary == input_stationary:
        data_str += [format_scalar_definition("int32_t", "Btlbound0", N)]
        data_str += [
            format_scalar_definition(
                "int32_t", "Btlstride0", K * b_len * tileSize * meshCol / 8
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Btlbound1", K)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Btlstride1",
                b_len * tileSize * meshCol / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Btlbound2", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Btlstride2",
                0,
            )
        ]

    B_enabled_channel_CSR_num = int(math.ceil(b_array_width / bankWidth / 32))
    channel_en_B = [0] * B_enabled_channel_CSR_num
    channel_en_B_bits = max(
        8, int((meshCol * tileSize * b_len / bankWidth + 7) // 8 * 8)
    )
    channel_en_B = gen_channel_enable_CSR(
        channel_en_B,
        channel_en_B_bits,
    )
    data_str += [
        "int32_t channel_en_B[] = { " + ", ".join(map(str, channel_en_B)) + " };"
    ]

    b_data_length = K * N * tileSize * meshCol * b_len / 8  # in bytes
    data_str += [format_scalar_definition("int32_t", "b_data_length", b_data_length)]

    # -----------------------------------------------------------
    # ---------------------streamer C settings---------------------
    # -----------------------------------------------------------
    # spatial settings
    data_str += [format_scalar_definition("int32_t", "Cslstride0", bankWidth / 8)]
    if meshCol * meshRow * c_len >= snax_versacore_serial_c_d_width:
        c_spatial_bound_0 = snax_versacore_serial_c_d_width / bankWidth
    else:
        c_spatial_bound_0 = meshCol * meshRow * c_len / bankWidth
    # temporal settings
    # serial input for C
    data_str += [
        format_scalar_definition(
            "int32_t",
            "Ctlbound0",
            max(
                1,
                meshCol * meshRow * c_len / snax_versacore_serial_c_d_width,
            ),
        )
    ]
    # assert(meshCol * meshRow * output_data_width >= snax_versacore_serial_c_d_width)
    data_str += [
        format_scalar_definition(
            "int32_t", "Ctlstride0", c_spatial_bound_0 * (bankWidth / 8)
        )
    ]

    if stationary == output_stationary:
        data_str += [format_scalar_definition("int32_t", "Ctlbound1", N)]
        data_str += [
            format_scalar_definition(
                "int32_t", "Ctlstride1", c_len * meshRow * meshCol / 8
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Ctlbound2", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Ctlstride2",
                N * c_len * meshRow * meshCol / 8,
            )
        ]

        # C is not used in this case
        data_str += [format_scalar_definition("int32_t", "Ctlbound3", 1)]
        data_str += [format_scalar_definition("int32_t", "Ctlstride3", 0)]

    elif stationary == weight_stationary:
        data_str += [format_scalar_definition("int32_t", "Ctlbound1", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Ctlstride1",
                N * c_len * meshRow * meshCol / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Ctlbound2", K)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Ctlstride2",
                0,
            )
        ]
        #
        data_str += [format_scalar_definition("int32_t", "Ctlbound3", N)]
        data_str += [
            format_scalar_definition(
                "int32_t", "Ctlstride3", c_len * meshRow * meshCol / 8
            )
        ]
    elif stationary == input_stationary:
        data_str += [format_scalar_definition("int32_t", "Ctlbound1", N)]
        data_str += [
            format_scalar_definition(
                "int32_t", "Ctlstride1", c_len * meshRow * meshCol / 8
            )
        ]
        data_str += [format_scalar_definition("int32_t", "Ctlbound2", K)]
        data_str += [format_scalar_definition("int32_t", "Ctlstride2", 0)]
        data_str += [format_scalar_definition("int32_t", "Ctlbound3", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "Ctlstride3",
                N * c_len * meshRow * meshCol / 8,
            )
        ]

    disable_C = kwargs["channel_en_C"] == 0
    enable_full_C = kwargs["channel_en_C"] == 1

    assert disable_C or enable_full_C, "Invalid C settings"

    C_enabled_channel_CSR_num = int(
        math.ceil(snax_versacore_serial_c_d_width / bankWidth / 32)
    )
    channel_en_C = [0] * C_enabled_channel_CSR_num

    if enable_full_C == 1:
        channel_en_C_bits = int((meshRow * meshCol * c_len / bankWidth + 7) // 8 * 8)
    else:
        channel_en_C_bits = 0

    channel_en_C = gen_channel_enable_CSR(
        channel_en_C,
        channel_en_C_bits,
    )
    data_str += [
        "int32_t channel_en_C[] = { " + ", ".join(map(str, channel_en_C)) + " };"
    ]

    c_data_length = M * N * meshRow * meshCol * c_len / 8
    data_str += [format_scalar_definition("int32_t", "c_data_length", c_data_length)]

    # -----------------------------------------------------------
    # streamer D settings
    # -----------------------------------------------------------
    # spatial settings
    data_str += [format_scalar_definition("int32_t", "D32slstride0", bankWidth / 8)]
    if meshCol * meshRow * c_len >= snax_versacore_serial_c_d_width:
        d_spatial_bound_0 = snax_versacore_serial_c_d_width / bankWidth
    else:
        d_spatial_bound_0 = meshCol * meshRow * c_len / bankWidth
    # temporal settings
    data_str += [
        format_scalar_definition(
            "int32_t",
            "D32tlbound0",
            max(
                1,
                meshCol * meshRow * c_len / snax_versacore_serial_c_d_width,
            ),
        )
    ]
    # assert(meshCol * meshRow * c_len >= snax_versacore_serial_c_d_width)
    data_str += [
        format_scalar_definition(
            "int32_t", "D32tlstride0", d_spatial_bound_0 * (bankWidth / 8)
        )
    ]

    if stationary == output_stationary:

        data_str += [format_scalar_definition("int32_t", "D32tlbound1", N)]
        data_str += [
            format_scalar_definition(
                "int32_t", "D32tlstride1", c_len * meshRow * meshCol / 8
            )
        ]
        data_str += [format_scalar_definition("int32_t", "D32tlbound2", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "D32tlstride2",
                N * c_len * meshRow * meshCol / 8,
            )
        ]

        # D is not used in this case
        data_str += [format_scalar_definition("int32_t", "D32tlbound3", 1)]
        data_str += [format_scalar_definition("int32_t", "D32tlstride3", 0)]

    elif stationary == weight_stationary:
        data_str += [format_scalar_definition("int32_t", "D32tlbound1", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "D32tlstride1",
                N * c_len * meshRow * meshCol / 8,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "D32tlbound2", K)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "D32tlstride2",
                0,
            )
        ]
        data_str += [format_scalar_definition("int32_t", "D32tlbound3", N)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "D32tlstride3",
                c_len * meshRow * meshCol / 8,
            )
        ]

    elif stationary == input_stationary:
        data_str += [format_scalar_definition("int32_t", "D32tlbound1", N)]
        data_str += [
            format_scalar_definition(
                "int32_t", "D32tlstride1", c_len * meshRow * meshCol / 8
            )
        ]
        data_str += [format_scalar_definition("int32_t", "D32tlbound2", K)]
        data_str += [format_scalar_definition("int32_t", "D32tlstride2", 0)]
        data_str += [format_scalar_definition("int32_t", "D32tlbound3", M)]
        data_str += [
            format_scalar_definition(
                "int32_t",
                "D32tlstride3",
                N * c_len * meshRow * meshCol / 8,
            )
        ]

    D_enabled_channel_CSR_num = int(
        math.ceil(snax_versacore_serial_c_d_width / bankWidth / 32)
    )

    channel_en_D = [0] * D_enabled_channel_CSR_num
    channel_en_D_bits = int((meshRow * meshCol * c_len / bankWidth + 7) // 8 * 8)
    channel_en_D = gen_channel_enable_CSR(
        channel_en_D,
        channel_en_D_bits,
    )
    data_str += [
        "int32_t channel_en_D[] = { " + ", ".join(map(str, channel_en_D)) + " };"
    ]

    d_data_length = M * N * meshRow * meshCol
    data_str += [
        format_scalar_definition("int32_t", "d_data_length", d_data_length * c_len / 8)
    ]

    # -----------------------------------------------------------
    # -------------------------base address----------------------
    # -----------------------------------------------------------

    delta_local_a = 0
    delta_local_b = K * M * (meshRow * tileSize * a_len / 8)
    delta_local_b = align_wide_addr(delta_local_b)
    delta_local_c = delta_local_b + K * N * (meshCol * tileSize * b_len / 8)
    delta_local_c = align_wide_addr(delta_local_c)

    if stationary == output_stationary:
        delta_local_d = delta_local_c
        delta_local_d = align_wide_addr(delta_local_d)
    elif stationary == weight_stationary:
        delta_local_d = delta_local_c
    elif stationary == input_stationary:
        delta_local_d = delta_local_c
        delta_local_d = align_wide_addr(delta_local_d)

    data_str += [format_scalar_definition("int32_t", "delta_local_a", delta_local_a)]
    data_str += [format_scalar_definition("int32_t", "delta_local_b", delta_local_b)]
    data_str += [format_scalar_definition("int32_t", "delta_local_c", delta_local_c)]
    data_str += [format_scalar_definition("int32_t", "delta_local_d", delta_local_d)]

    # -----------------------------------------------------------
    # Test Data generation
    # -----------------------------------------------------------

    # Generating random 8 integer a and b for subtraction
    # subtraction_a = np.random.randint(MIN, MAX)
    # subtraction_b = np.random.randint(MIN, MAX)
    subtraction_a = 0
    subtraction_b = 0

    # Writing the subtraction value to data.h
    data_str += [format_scalar_definition("int8_t", "subtraction_a", subtraction_a)]
    data_str += [format_scalar_definition("int8_t", "subtraction_b", subtraction_b)]

    A = np.random.randint(A_MIN, A_MAX, size=(M, K, meshRow, tileSize)).reshape(-1)
    if a_len == 8:
        data_str += [format_vector_definition("int8_t", "A", A)]
    elif a_len == 16:
        data_str += [format_vector_definition("int16_t", "A", A)]
    else:
        raise ValueError("Invalid A data type")

    B = np.random.randint(B_MIN, B_MAX, size=(K, N, tileSize, meshCol)).reshape(-1)
    if b_len == 4:
        data_str += [format_vector_definition("int8_t", "B_orginal_4bits", B)]
        B_packed = pack_signed_nbit(B, bit_width=4, pack_per_byte=2)
        data_str += [format_vector_definition("int8_t", "B", B_packed)]
    elif b_len == 8:
        data_str += [format_vector_definition("int8_t", "B", B)]
    else:
        raise ValueError("Invalid B data type")

    if enable_full_C == 1:
        C = np.random.randint(C_MIN, C_MAX, size=(M, N, meshRow, meshCol)).reshape(-1)
    else:
        C = np.random.randint(0, 1, size=(M, N, meshRow, meshCol)).reshape(-1)

    assert c_len == 32, "C data type must be 32 bits for now"
    data_str += [format_vector_definition("int32_t", "C", C)]

    if kwargs["transposed_A"] == 1:
        A = A.reshape(M, K, meshRow, tileSize)
        A = A.transpose(0, 1, 3, 2).reshape(-1)
    if kwargs["transposed_B"] == 1:
        B = B.reshape(K, N, tileSize, meshCol)
        B = B.transpose(0, 1, 3, 2).reshape(-1)

    data_str += [
        format_scalar_definition("int32_t", "transposed_A", kwargs["transposed_A"])
    ]
    data_str += [
        format_scalar_definition("int32_t", "transposed_B", kwargs["transposed_B"])
    ]

    D = block_gemm_golden_model(
        M,
        K,
        N,
        meshRow,
        tileSize,
        meshCol,
        A,
        B,
        subtraction_a,
        subtraction_b,
        C,
    )

    data_str += [format_vector_definition("int32_t", "D", D)]

    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_A", 0)]
    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_B", 0)]
    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_C", 0)]
    data_str += [format_scalar_definition("int32_t", "set_addr_remap_index_D32", 0)]

    data_str = "\n\n".join(data_str)

    return data_str


def main():
    # Parsing cmd args
    parser = argparse.ArgumentParser(description="Generate data for kernels")
    parser.add_argument(
        "--swcfg",
        type=pathlib.Path,
        required=True,
        help="Select param config file kernel",
    )
    parser.add_argument(
        "--hwcfg",
        type=pathlib.Path,
        required=True,
        help="Select hardware config file kernel",
    )
    args = parser.parse_args()

    # Load param config file
    with args.swcfg.open() as f:
        param = hjson.loads(f.read())

    # Load hardware config file
    with args.hwcfg.open() as f:
        hw = hjson.loads(f.read())

    # Merge dictionaries (hw overrides param in case of conflicts)
    merged_config = {**param, **hw}

    # Emit header file
    print(emit_header_file(**merged_config))


if __name__ == "__main__":

    main()
