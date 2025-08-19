#!/usr/bin/env python3

# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

from math import ceil
import math

import numpy as np


# Function to perform 2D convolution on the input data using the specified
# kernel, stride, and padding. It returns the output feature map.
def conv2d(
    input_data,
    kernel,
    stride=(1, 1),
    padding=(0, 0),
    mode="NHWC",
    hw_sizes=None,
):
    if mode == "NHWC":
        batch_size, in_height, in_width, in_channels = input_data.shape
        out_channels, kernel_height, kernel_width, _ = kernel.shape
        stride_h, stride_w = stride
        pad_h, pad_w = padding

        # Calculate the output feature map dimensions
        out_height = (in_height - kernel_height + 2 * pad_h) // stride_h + 1
        out_width = (in_width - kernel_width + 2 * pad_w) // stride_w + 1

        # Add padding
        input_data_padded = np.pad(
            input_data,
            ((0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)),
            mode="constant",
        )

        # Initialize the output feature map
        output_data = np.zeros(
            (batch_size, out_height, out_width, out_channels), np.int32
        )

        # Perform the convolution operation
        for b in range(batch_size):
            for oc in range(out_channels):
                for oh in range(out_height):
                    for ow in range(out_width):
                        # Calculate the input region
                        ih_start = oh * stride_h
                        ih_end = ih_start + kernel_height
                        iw_start = ow * stride_w
                        iw_end = iw_start + kernel_width

                        # Slice to extract the input region
                        input_region = input_data_padded[
                            b, ih_start:ih_end, iw_start:iw_end, :
                        ]

                        # Slice to extract the corresponding convolution kernel
                        conv_kernel = kernel[oc, :, :, :]

                        # Perform the convolution calculation
                        output_data[b, oh, ow, oc] = np.sum(
                            input_region * conv_kernel
                        )
    else:
        batch_size, _, in_height, in_width, _ = input_data.shape
        CoutTemp, _, kernel_height, kernel_width, meshCol, _ = kernel.shape
        stride_h, stride_w = stride
        pad_h, pad_w = padding
        meshRow = hw_sizes["meshRow"]
        meshCol = hw_sizes["meshCol"]
        # Calculate the output feature map dimensions
        out_width = (in_width - kernel_width + 2 * pad_w) // stride_w + 1
        out_height = (in_height - kernel_height + 2 * pad_h) // stride_h + 1
        assert out_width % meshRow == 0

        # Add padding
        input_data_padded = np.pad(
            input_data,
            ((0, 0), (0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)),
            mode="constant",
        )

        # Initialize the output feature map
        output_data = np.zeros(
            (
                batch_size,
                CoutTemp,
                out_height,
                out_width // meshRow,
                meshRow,
                meshCol,
            ),
            np.int32,
        )

        # Perform the convolution operation
        for b in range(batch_size):
            for oc in range(CoutTemp):
                for oc8 in range(meshCol):
                    for oh in range(out_height):
                        for ow in range(out_width // meshRow):
                            for ow8 in range(meshRow):
                                # Calculate the input region
                                iw_start = (ow * meshRow + ow8) * stride_w
                                iw_end = iw_start + kernel_width

                                ih_start = oh * stride_h
                                ih_end = ih_start + kernel_height

                                # Slice to extract the input region
                                input_region = input_data_padded[
                                    b, :, ih_start:ih_end, iw_start:iw_end, :
                                ]

                                # Slice to extract the corresponding
                                # convolution kernel
                                conv_kernel = kernel[oc, :, :, :, oc8, :]

                                # Perform the convolution calculation
                                output_data[b, oc, oh, ow, ow8, oc8] = np.sum(
                                    input_region * conv_kernel
                                )

    return output_data


# Function to transform input data into columns for efficient
# convolution operations.
# It returns the transformed input data and reshaped kernel.
def im2col(input_data, kernel, stride=(1, 1), padding=(0, 0), mode="NC8HW8"):
    assert mode == "NC8HW8"
    batch_size, in_channels_8, in_height, in_width, _ = input_data.shape
    _, out_channels, kernel_height, kernel_width, _, _ = kernel.shape
    stride_h, stride_w = stride
    pad_h, pad_w = padding

    # Calculate the size of the output feature map
    out_height = (in_height + 2 * pad_h - kernel_height) // stride_h + 1
    out_width = (in_width + 2 * pad_w - kernel_width) // stride_w + 1

    # Apply zero padding to the input data
    input_data_padded = np.pad(
        input_data,
        ((0, 0), (0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)),
        mode="constant",
    )

    # Initialize the im2col matrix
    im2col_matrix = np.zeros(
        (
            batch_size,
            out_height,
            out_width // 8,
            in_channels_8,
            kernel_height,
            kernel_width,
            # ow in 8
            8,
            # cin in 8
            8,
        )
    )

    # Perform the im2col transformation on the input data
    for b in range(batch_size):
        for oh in range(out_height):
            for ow in range(out_width // 8):
                for ow8 in range(8):
                    for ic in range(in_channels_8):
                        for ic8 in range(8):
                            # Calculate the input region
                            iw_start = (ow * 8 + ow8) * stride_w
                            iw_end = iw_start + kernel_width

                            ih_start = oh * stride_h
                            ih_end = ih_start + kernel_height

                            # Slice to extract the input region
                            input_region = input_data_padded[
                                b, ic, ih_start:ih_end, iw_start:iw_end, ic8
                            ]

                            im2col_matrix[
                                b, oh, ow, ic, :, :, ow8, ic8
                            ] = input_region

    im2col_kernel = kernel.reshape(out_channels, -1).T

    return im2col_matrix, im2col_kernel


# Golden model function to perform block matrix multiplication with
# specific parameters. It returns the resulting matrix after the computation.
def block_gemm_golden_model(
    m, k, n, row, size, col, a, b, subtraction_a, subtraction_b, c
):
    # Reshape and subtract
    a = a.astype(np.int32)
    b = b.astype(np.int32)
    a_subtracted = (
        a.reshape(m, k, row, size) - subtraction_a
    )  # Shape: (m, k, row, size)
    b_subtracted = (
        b.reshape(n, k, col, size) - subtraction_b
    )  # Shape: (n, k, col, size)

    # Initialize output array
    d = np.zeros((m, n, row, col), dtype=np.int32)

    # Compute
    for mm in range(m):
        for nn in range(n):
            # Perform tensordot over axes k and size
            # (axes 0 and 3 in original arrays)
            # But after reshaping, axes are (k, row, size) and (k, col, size)
            # So axes to sum over are 0 (k) and 2 (size)
            d[mm, nn] = np.tensordot(
                a_subtracted[mm], b_subtracted[nn], axes=([0, 2], [0, 2])
            )
    # Flatten d and add c
    d = d.reshape(m * n * row * col) + c

    return d


# This function Performs a tiled block
# General Matrix Multiply (GEMM) operation.
#
# This function breaks down large matrix multiplication into smaller
# submatrices (tiles) and performs GEMM on these submatrices.
# The results are then accumulated into a final result matrix.
#
# Parameters:
# m2, k2, n2: int
#     The number of tiles in each dimension.
# m, k, n: int
#     The dimensions of the submatrices for block matrix multiplication.
# row, size, col: int
#     Size parameters for the submatrices in the hardware gemm accelerator.
# a, b, c: numpy.ndarray
#     The input matrices.
# subtraction_a, subtraction_b: bool
#     Flags indicating whether to perform subtraction in the GEMM computation.
#
# Returns:
# numpy.ndarray
#     The result of the tiled GEMM operation as a flattened array.
def tiled_block_gemm_golden_model(
    m2, k2, n2, m, k, n, row, size, col, a, b, subtraction_a, subtraction_b, c
):
    # Create an empty array for the result with the appropriate size
    result = np.zeros((m2 * m * row * n2 * n * col), dtype=np.int32)

    # Loop over the tiles
    for mm2 in range(m2):
        for nn2 in range(n2):
            for kk2 in range(k2):
                # Create submatrices for this tile
                sub_a = a[
                    (mm2 * k2 + kk2)
                    * m
                    * k
                    * row
                    * size: (mm2 * k2 + kk2 + 1)
                    * m
                    * k
                    * row
                    * size
                ]
                sub_b = b[
                    (nn2 * k2 + kk2)
                    * n
                    * k
                    * size
                    * col: (nn2 * k2 + kk2 + 1)
                    * n
                    * k
                    * size
                    * col
                ]
                sub_c = c[
                    (mm2 * n2 + nn2)
                    * m
                    * row
                    * n
                    * col: (mm2 * n2 + nn2 + 1)
                    * m
                    * row
                    * n
                    * col
                ]

                # Perform block GEMM on the submatrices
                sub_d = block_gemm_golden_model(
                    m,
                    k,
                    n,
                    row,
                    size,
                    col,
                    sub_a,
                    sub_b,
                    subtraction_a,
                    subtraction_b,
                    sub_c,
                )
                # Accumulate the result into the final result matrix at the
                # correct position
                result[
                    (mm2 * n2 + nn2)
                    * m
                    * row
                    * n
                    * col: (mm2 * n2 + nn2 + 1)
                    * m
                    * row
                    * n
                    * col
                ] += sub_d

    return result


# Golden model function for reshuffling data with specified parameters.
# It applies strided layout mapping to the input data and returns
# the reshuffled data array.
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
    int32=False,
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

    if int32:
        result_array = np.zeros(
            (matrix_size["M"] * matrix_size["K"]), np.int32)
    else:
        result_array = np.zeros(
            (matrix_size["M"] * matrix_size["K"]), np.int8)

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


# Golden model function for SIMD postprocessing of data. It performs
# operations such as zero point subtraction, multiplication,
# right shift, double rounding, and clipping.
def postprocessing_simd_golden_model(
    data_in,
    input_zp_i,
    output_zp_i,
    shift_i,
    max_int_i,
    min_int_i,
    double_round_i,
    multiplier_i,
):

    # Step 1: Subtract input zero point
    var = data_in - input_zp_i

    # Step 2: Multiply with the multiplier avoiding overflow
    var = np.int64(var) * np.int64(multiplier_i)

    # Step 3: Right shift
    var = np.int32(var >> (shift_i - 1))

    # Step 4: Apply double rounding if necessary
    if double_round_i:
        var = np.where(var >= 0, var + 1, var - 1)

    # Step 5: Final right shift
    var = var >> 1

    # Step 6: Add output zero point
    var = var + output_zp_i

    # Step 7: Clip the values to be within min and max integer range
    var = np.clip(var, min_int_i, max_int_i)

    return var


def golden_model_rescale_up(
    data_in: int,
    input_zp_i: int,
    output_zp_i: int,
    shift_i: int,
    max_int_i: int,
    min_int_i: int,
    multiplier_i: int,
) -> int:
    """
    This function performs rescaling of data given
    exact algorithm of TOSA.rescale,
    """
    # Step 1: Subtract input zero point
    var_1 = data_in - input_zp_i

    # Step 2: Multiply with the multiplier avoiding overflow
    var_2 = np.int64(var_1) * np.int64(multiplier_i)

    # Step 3: Left shift one
    shifted_one = np.int64(
        1 << (shift_i - 1)
    )  # TODO: check if the minus one is actually correct

    # Step 4: Add shifted one
    var_3 = np.int64(var_2 + shifted_one)

    # Step 6: Shift right
    var_6 = np.int32(var_3 >> shift_i)

    # Step 7: Add output zero point
    var_7 = var_6 + np.int32(output_zp_i)

    # Step 8: Clip the values to be within min and max integer range
    var_8 = np.clip(var_7, min_int_i, max_int_i)

    return int(var_8)


def postprocessing_simd_golden_model_V2(
    data_in,
    input_zp_i,
    output_zp_i,
    shift_i,
    max_int_i,
    min_int_i,
    double_round_i,
    multiplier_i,
):
    """
    This function performs SIMD postprocessing of data given the exact
    algorithm of TOSA.rescale.
    """
    # Step 1: Subtract input zero point
    var_1 = data_in - input_zp_i

    # Step 2: Multiply with the multiplier avoiding overflow
    var_2 = np.int64(var_1) * np.int64(multiplier_i)

    # Step 3: Left shift one
    shifted_one = np.int64(1 << (shift_i - 1))

    # Step 4: Add shifted one
    var_3 = var_2 + shifted_one

    # Step 5: Double rounding if necessary
    if double_round_i:
        if var_1 > 0:
            var_4 = var_3 + np.int64(1 << 30)
        else:
            var_4 = var_3 - np.int64(1 << 30)
    else:
        var_4 = var_3

    if shift_i > 31:
        var_5 = var_4
    else:
        var_5 = var_3

    # Step 6: Shift right
    var_6 = np.int32(var_5 >> shift_i)

    # Step 7: Add output zero point
    var_7 = var_6 + output_zp_i

    # Step 8: Clip the values to be within min and max integer range
    var_8 = np.clip(var_7, min_int_i, max_int_i)

    return var_8


def postprocessing_simd_golden_model_V3(
    data_in,
    input_zp_i,
    output_zp_i,
    shift_i,
    max_int_i,
    min_int_i,
    double_round_i,
    multiplier_i,
):
    """
    This function performs SIMD postprocessing of data given approximate
    algorithm of TOSA.rescale, with dynamically scaled shifts.
    """
    # Step 1: Subtract input zero point
    var_1 = data_in - input_zp_i

    # Additional Step 1:
    bits_to_shift_input = max(
        0, 9 + shift_i - ceil(np.log2(multiplier_i)) - 16
    )
    # 8 can be adapted to be higher. higher will add more support for
    # overflows, but will also reduce accuracy of the output.
    bits_to_shift_multiplier = max(0, ceil(np.log2(multiplier_i)) - 16)

    var_1 = var_1 >> bits_to_shift_input
    multiplier_i = multiplier_i >> bits_to_shift_multiplier
    shift_i = shift_i - bits_to_shift_input - bits_to_shift_multiplier

    # Step 2: Multiply with the multiplier avoiding overflow
    var_2 = np.int32(var_1) * np.int32(multiplier_i)

    # Step 3: Left shift one
    shifted_one = np.int32(1 << (shift_i - 1))

    # Step 4: Add shifted one
    var_3 = var_2 + shifted_one

    # Step 5: Double rounding
    if double_round_i:
        if var_1 > 0:
            var_4 = var_3 + np.int32(
                1 << (30 - bits_to_shift_multiplier - bits_to_shift_input)
            )
        else:
            var_4 = var_3 - np.int32(
                1 << (30 - bits_to_shift_multiplier - bits_to_shift_input)
            )

    if shift_i > 31 - bits_to_shift_multiplier - bits_to_shift_input:
        var_5 = var_4
    else:
        var_5 = var_3

    # Step 6: Shift right
    var_6 = np.int32(var_5 >> shift_i)

    # Step 7: Add output zero point
    var_7 = var_6 + output_zp_i

    # Step 8: Clip the values to be within min and max integer range
    var_8 = np.clip(var_7, min_int_i, max_int_i)

    return var_8


def max_pooling(
    input_tensor,
    pool_size_w,
    pool_size_h,
    stride_w,
    stride_h,
    padding_w,
    padding_h,
    mode="HWC",
):

    # if mode == "HWC", C8 is 1, C = realCin
    # if mode != "HWC", C8 is realCin/8, C = 8
    C8, H, W, C = input_tensor.shape
    if mode != "HWC":
        assert input_tensor.shape[3] == 8 and C == 8
    elif mode == "HWC":
        assert input_tensor.shape[0] == 1 and C8 == 1

    out_width = (W + 2 * padding_w - pool_size_w) // stride_w + 1
    out_height = (H + 2 * padding_h - pool_size_h) // stride_h + 1

    input_padded = np.pad(
        input_tensor,
        ((0, 0), (padding_h, padding_h), (padding_w, padding_w), (0, 0)),
        mode="constant",
        constant_values=0,
    )

    pooled_tensor = np.zeros((C8, out_height, out_width, C), dtype=np.int8)

    for c in range(C8):
        for i in range(out_height):
            for j in range(out_width):
                for k in range(C):
                    h_start = i * stride_h
                    h_end = h_start + pool_size_h
                    w_start = j * stride_w
                    w_end = w_start + pool_size_w
                    pooled_tensor[c, i, j, k] = np.max(
                        input_padded[c, h_start:h_end, w_start:w_end, k]
                    )

    return pooled_tensor


def align_wide_addr(addr, alignment=64):
    if addr % alignment:
        addr = ((addr // alignment) + 1) * alignment
    return addr


def sumpool_golden(
    a_vals: np.ndarray,
    m: int,
    n: int,
    channels: int,
    m_kernel: int,
    n_kernel: int,
    m_stride: int,
    n_stride: int,
) -> np.ndarray:
    """
    Compute the golden output for maxpool operation.
    This function simulates the maxpool operation on the input tensor.
    a should be a 3D array with shape (m, n, channels).
    """
    output = np.empty(
        (
            ((m - m_kernel) // m_stride + 1),
            ((n - n_kernel) // n_stride + 1),
            channels,
        ),
        dtype=np.int32,
    )
    # Iterate over each channel and apply max pooling
    for i in range(0, ((m - m_kernel) // m_stride + 1) * m_stride, m_stride):
        for j in range(0, ((n - n_kernel) // n_stride + 1) * n_stride,
                       n_stride):
            for c in range(channels):
                # Extract the kernel region
                kernel_region = a_vals[i: i + m_kernel, j: j + n_kernel, c]
                # Compute the maximum value in the kernel region
                sum_value = int(np.sum(kernel_region))
                output[i // m_stride, j // n_stride, c] = sum_value
    return output

def find_max(array: np.ndarray):
    """Find the maximum value in an array."""
    max_value = array[0]
    for value in array:
        if value > max_value:
            max_value = value
    return max_value


def subtract_max(array: np.ndarray, max_value: np.int32):
    """Subtract the maximum value from each element in the array."""
    new_array = np.empty_like(array, dtype=np.int32)
    for i in range(len(array)):
        if (int(array[i]) - int(max_value)) < np.iinfo(np.int32).min:
            new_array[i] = np.iinfo(np.int32).min
        else:
            new_array[i] = array[i] - max_value
    return new_array

def integer_poly(x: np.int32, inverse_scaling_factor: int, a: float, b: float, c: float):
    a_scaled = int(a * inverse_scaling_factor)
    b_scaled = int(b * inverse_scaling_factor)
    c_scaled = int(c * (inverse_scaling_factor ** 3)) >> math.floor(math.log2(inverse_scaling_factor) * 2)

    output = np.int32(((a_scaled * (int(x) + b_scaled) ** 2) >>  math.floor(math.log2(inverse_scaling_factor)  * 2)) + c_scaled)

    scaling_factor_out = (inverse_scaling_factor ** 3) >> math.floor(math.log2(inverse_scaling_factor) * 2)

    return output, scaling_factor_out


def integer_exp(array: np.ndarray, inverse_scaling_factor: int):
    """Calculate the exponential of each element in the array."""
    exp_array = np.empty_like(array, dtype=np.int32)
    a = 0.3585
    b = 1.353
    c = 0.344
    q_ln2 = int(math.log(2) * inverse_scaling_factor)
    for i in range(len(array)):
        z = math.floor(-array[i] / q_ln2) #TODO: make this a multiplication
        q_p = array[i] + z * q_ln2
        q_l, scaling_factor_exp = integer_poly(q_p, inverse_scaling_factor, a, b, c)
        if z < 16:
            exp_array[i] = int(int(q_l) >> z)
        else:
            exp_array[i] = 0
    return exp_array, scaling_factor_exp

def integer_softmax(array: np.ndarray, scaling_factor_exp: int):
    max = find_max(array)
    array = subtract_max(array, max)
    array, scaling_factor_exp = integer_exp(array, scaling_factor_exp)
    sum_exp = np.sum(array)
    divider = (2**32 - 1) // sum_exp
    array_out = array * divider
    return array_out
