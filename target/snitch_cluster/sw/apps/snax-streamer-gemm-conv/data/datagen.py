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

np.random.seed(42)


def conv2d(input_data, kernel, stride=(1, 1), padding=(0, 0)):
    batch_size, in_height, in_width, in_channels = input_data.shape
    out_channels, kernel_height, kernel_width, _ = kernel.shape
    stride_h, stride_w = stride
    pad_h, pad_w = padding

    # Calculate the output feature map dimensions
    out_height = (in_height - kernel_height + 2 * pad_h) // stride_h + 1
    out_width = (in_width - kernel_width + 2 * pad_w) // stride_w + 1

    # Add padding
    input_data_padded = np.pad(
        input_data, ((0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)), mode="constant"
    )

    # Initialize the output feature map
    output_data = np.zeros((batch_size, out_height, out_width, out_channels), np.int32)

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
                    output_data[b, oh, ow, oc] = np.sum(input_region * conv_kernel)

    return output_data


def im2col(input_data, kernel, stride=(1, 1), padding=(0, 0)):
    batch_size, in_height, in_width, in_channels = input_data.shape
    out_channels, kernel_height, kernel_width, _ = kernel.shape
    stride_h, stride_w = stride
    pad_h, pad_w = padding

    # Calculate the size of the output feature map
    out_height = (in_height + 2 * pad_h - kernel_height) // stride_h + 1
    out_width = (in_width + 2 * pad_w - kernel_width) // stride_w + 1

    # Apply zero padding to the input data
    input_data_padded = np.pad(
        input_data, ((0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)), mode="constant"
    )

    # Initialize the im2col matrix
    im2col_matrix = np.zeros(
        (batch_size, out_height * out_width, in_channels * kernel_height * kernel_width)
    )

    # Perform the im2col transformation on the input data
    for b in range(batch_size):
        for oh in range(out_height):
            for ow in range(out_width):
                # Calculate the input region
                ih_start = oh * stride_h
                ih_end = ih_start + kernel_height
                iw_start = ow * stride_w
                iw_end = iw_start + kernel_width

                # Slice and extract the input region
                input_region = input_data_padded[b, ih_start:ih_end, iw_start:iw_end, :]

                # Flatten the input region into a 1D vector and add it to the
                # corresponding position in the im2col matrix
                im2col_matrix[b, oh * out_width + ow, :] = input_region.reshape(-1)

    im2col_matrix = im2col_matrix.reshape(batch_size * out_height * out_width, -1)
    im2col_kernel = kernel.reshape(out_channels, -1).T

    return im2col_matrix, im2col_kernel


# Golden model in python
def block_gemm_golden_model(
    m, k, n, row, size, col, a, b, subtraction_a, subtraction_b
):
    c = np.zeros(m * row * n * col, dtype=(np.int32))
    for mm in range(m):
        for nn in range(n):
            for kk in range(k):
                for rr in range(row):
                    for cc in range(col):
                        for ss in range(size):
                            c_index = (
                                mm * n * row * col + nn * row * col + rr * col + cc
                            )
                            a_index = (
                                mm * k * row * size + kk * row * size + rr * size + ss
                            )
                            b_index = (
                                nn * k * size * col + kk * size * col + cc * size + ss
                            )
                            c[c_index] = c[c_index] + (a[a_index] - subtraction_a) * (
                                b[b_index] - subtraction_b
                            )
    return c


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
        result_array = np.zeros((matrix_size["M"] * matrix_size["K"]), np.int32)
    else:
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
    emit_str += emit_gemm_data(**kwargs)
    return emit_str


MIN = -128
MAX = 127


def emit_gemm_data(**kwargs):

    # conv2d settings
    Nbatch, H, W, Cin = (kwargs["Nbatch"], kwargs["H"], kwargs["W"], kwargs["Cin"])
    Cout, Kh, Kw, Cin = (kwargs["Cout"], kwargs["Kh"], kwargs["Kw"], kwargs["Cin"])

    pad_h, pad_w = (kwargs["stride_h"], kwargs["stride_w"])
    stride_h, stride_w = (kwargs["pad_h"], kwargs["pad_w"])

    # test data generation
    input_data = np.random.randint(-10, 10, size=(Nbatch, H, W, Cin))
    kernel = np.random.randint(-10, 10, size=(Cout, Kh, Kw, Cin))

    # inferred config from the input data and kernel
    padding = pad_h, pad_w
    stride = stride_h, stride_w

    input_padding = np.pad(
        input_data, ((0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)), mode="constant"
    )

    im2col_matrix, im2col_kernel = im2col(
        input_data, kernel, stride=stride, padding=padding
    )

    M = im2col_matrix.shape[0] // 8
    K = im2col_matrix.shape[1] // 8
    N = im2col_kernel.shape[1] // 8

    data_str = []

    # Generating conv2d settings
    data_str += [
        format_scalar_definition("int", "Nbatch", Nbatch),
        format_scalar_definition("int", "H", H),
        format_scalar_definition("int", "W", W),
        format_scalar_definition("int", "Cin", Cin),
        format_scalar_definition("int", "Cout", Cout),
        format_scalar_definition("int", "Kh", Kh),
        format_scalar_definition("int", "Kw", Kw),
        format_scalar_definition("int", "stride_h", stride_h),
        format_scalar_definition("int", "stride_w", stride_w),
        format_scalar_definition("int", "pad_h", pad_h),
        format_scalar_definition("int", "pad_w", pad_w),
    ]

    # Generating matrix size settings
    data_str += [
        format_scalar_definition("int", "Batch", Nbatch),
        format_scalar_definition("int", "M", M),
        format_scalar_definition("int", "K", K),
        format_scalar_definition("int", "N", N),
    ]

    # Generating base pointer settings
    delta_local_a = 0
    delta_local_b = input_padding.size
    delta_local_c = input_padding.size + kernel.size
    data_str += [
        format_scalar_definition("int32_t", "delta_local_a", delta_local_a),
        format_scalar_definition("int32_t", "delta_local_b", delta_local_b),
        format_scalar_definition("int32_t", "delta_local_c", delta_local_c),
    ]

    # for streamer cfg
    # streamer setting for data mover A
    Aslstride0 = 1
    Aslstride1 = Cin

    # K dim
    Atlbound0 = Cin // 8
    Atlstride0 = 8

    Atlbound1 = Kw
    Atlstride1 = Cin * stride_w

    Atlbound2 = Kh
    Atlstride2 = Cin * (W + 2 * pad_w)

    # N dim
    Atlbound3 = Cout // 8
    Atlstride3 = 0

    # M dim
    Atlbound4 = W // 8
    Atlstride4 = Cin * 8

    Atlbound5 = H
    Atlstride5 = Cin * (W + 2 * pad_w) * stride_h

    # Batch dim
    Atlbound6 = Nbatch
    Atlstride6 = Cin * (H + 2 * pad_h) * (W + 2 * pad_w)

    data_str += [
        format_scalar_definition("int32_t", "Aslstride0", Aslstride0),
        format_scalar_definition("int32_t", "Aslstride1", Aslstride1),
        format_scalar_definition("int32_t", "Atlbound0", Atlbound0),
        format_scalar_definition("int32_t", "Atlstride0", Atlstride0),
        format_scalar_definition("int32_t", "Atlbound1", Atlbound1),
        format_scalar_definition("int32_t", "Atlstride1", Atlstride1),
        format_scalar_definition("int32_t", "Atlbound2", Atlbound2),
        format_scalar_definition("int32_t", "Atlstride2", Atlstride2),
        format_scalar_definition("int32_t", "Atlbound3", Atlbound3),
        format_scalar_definition("int32_t", "Atlstride3", Atlstride3),
        format_scalar_definition("int32_t", "Atlbound4", Atlbound4),
        format_scalar_definition("int32_t", "Atlstride4", Atlstride4),
        format_scalar_definition("int32_t", "Atlbound5", Atlbound5),
        format_scalar_definition("int32_t", "Atlstride5", Atlstride5),
        format_scalar_definition("int32_t", "Atlbound6", Atlbound6),
        format_scalar_definition("int32_t", "Atlstride6", Atlstride6),
    ]

    # streamer setting for data mover B
    Bslstride0 = 1
    Bslstride1 = Cin * Kw * Kh

    # K dim
    Btlbound0 = Cin * Kw * Kh // 8
    Btlstride0 = 8

    # N dim
    Btlbound1 = Cout // 8
    Btlstride1 = Cin * Kw * Kh * 8

    # M dim
    Btlbound2 = H * W // 8
    Btlstride2 = 0

    # Batch dim
    Btlbound3 = Nbatch
    Btlstride3 = 0

    data_str += [
        format_scalar_definition("int32_t", "Bslstride0", Bslstride0),
        format_scalar_definition("int32_t", "Bslstride1", Bslstride1),
        format_scalar_definition("int32_t", "Btlbound0", Btlbound0),
        format_scalar_definition("int32_t", "Btlstride0", Btlstride0),
        format_scalar_definition("int32_t", "Btlbound1", Btlbound1),
        format_scalar_definition("int32_t", "Btlstride1", Btlstride1),
        format_scalar_definition("int32_t", "Btlbound2", Btlbound2),
        format_scalar_definition("int32_t", "Btlstride2", Btlstride2),
        format_scalar_definition("int32_t", "Btlbound3", Btlbound3),
        format_scalar_definition("int32_t", "Btlstride3", Btlstride3),
    ]

    # streamer setting for data mover C
    # C is int32_t so the stride is 4 times of the int8_t
    Cslstride0 = 4
    Cslstride1 = Cout * 4

    # N dim
    Ctlbound0 = Cout // 8
    Ctlstride0 = 8 * 4

    # M dim
    # K is merged because of the block gemm output stationarity
    Ctlbound1 = W // 8
    Ctlstride1 = Cout * 8 * 4

    Ctlbound2 = H
    Ctlstride2 = Cout * W * 4

    # Batch dim
    Ctlbound3 = Nbatch
    Ctlstride3 = Cout * H * W * 4

    data_str += [
        format_scalar_definition("int32_t", "Cslstride0", Cslstride0),
        format_scalar_definition("int32_t", "Cslstride1", Cslstride1),
        format_scalar_definition("int32_t", "Ctlbound0", Ctlbound0),
        format_scalar_definition("int32_t", "Ctlstride0", Ctlstride0),
        format_scalar_definition("int32_t", "Ctlbound1", Ctlbound1),
        format_scalar_definition("int32_t", "Ctlstride1", Ctlstride1),
        format_scalar_definition("int32_t", "Ctlbound2", Ctlbound2),
        format_scalar_definition("int32_t", "Ctlstride2", Ctlstride2),
        format_scalar_definition("int32_t", "Ctlbound3", Ctlbound3),
        format_scalar_definition("int32_t", "Ctlstride3", Ctlstride3),
    ]

    # Generating random 8 integer a and b for subtraction
    subtraction_a = 0
    subtraction_b = 0

    # Writing the subtraction value to data.h
    data_str += [
        format_scalar_definition("int8_t", "subtraction_a", subtraction_a),
        format_scalar_definition("int8_t", "subtraction_b", subtraction_b),
    ]

    # conv2d using im2col
    im2col_matrix = data_reshuffler_golden_model(
        K, M, 8, 8, 8, 8 * 8 * K, 1, 8 * K, im2col_matrix.reshape(-1)
    )
    # row major to column major for B
    im2col_kernel = im2col_kernel.T
    im2col_kernel = data_reshuffler_golden_model(
        K, N, 8, 8, 8, 8 * 8 * K, 1, 8 * K, im2col_kernel.reshape(-1)
    )
    im2col_conv2d_res = block_gemm_golden_model(
        M, K, N, 8, 8, 8, im2col_matrix, im2col_kernel, 0, 0
    )
    # im2col_conv2d_res = data_reshuffler_golden_model(N, M, 8, 8, 8, 8 * 8 * N,
    # 1, 8 * N, im2col_conv2d_res, 1)

    # direct conv2d
    direct_conv2d_res = conv2d(input_data, kernel, stride=stride, padding=padding)
    # output in NHWC format
    direct_conv2d_res = direct_conv2d_res.reshape(-1)

    # Writing testing data and golden data into data.h
    # implicit im2col matrix and kernel, store original input data and kernel
    data_str += [format_vector_definition("int8_t", "A", input_padding.reshape(-1))]
    data_str += [format_vector_definition("int8_t", "B", kernel.reshape(-1))]

    # explicit im2col matrix and kernel, store the columned input data
    # for comparing with the implicit im2col method
    # data_str += [format_vector_definition("int8_t", "A", im2col_matrix)]
    # data_str += [format_vector_definition("int8_t", "B", im2col_kernel)]

    data_str += [
        format_vector_definition("int32_t", "C_gemm_golden", im2col_conv2d_res)
    ]
    data_str += [
        format_vector_definition("int32_t", "C_direct_conv2d", direct_conv2d_res)
    ]

    data_str = "\n\n".join(data_str)

    return data_str


def test():
    np.set_printoptions(threshold=np.inf)

    # conv2d settings
    Nbatch, H, W, Cin = (1, 24, 24, 40)
    Cout, Kh, Kw, Cin = (8, 3, 3, 40)

    stride = (1, 1)
    padding = (1, 1)

    # test data generation
    input_data = np.random.randint(-10, 10, size=(Nbatch, H, W, Cin))
    kernel = np.random.randint(-10, 10, size=(Cout, Kh, Kw, Cin))

    im2col_matrix, im2col_kernel = im2col(
        input_data, kernel, stride=stride, padding=padding
    )

    M = im2col_matrix.shape[0] // 8
    K = im2col_matrix.shape[1] // 8
    N = im2col_kernel.shape[1] // 8

    # conv2d using im2col
    im2col_matrix, im2col_kernel = im2col(
        input_data, kernel, stride=stride, padding=padding
    )
    im2col_matrix = data_reshuffler_golden_model(
        K, M, 8, 8, 8, 8 * 8 * K, 1, 8 * K, im2col_matrix.reshape(-1)
    )
    im2col_kernel = data_reshuffler_golden_model(
        K, N, 8, 8, 8, 8 * 8 * K, 1, 8 * K, im2col_kernel.T.reshape(-1)
    )
    im2col_conv2d_res = block_gemm_golden_model(
        M, K, N, 8, 8, 8, im2col_matrix, im2col_kernel, 0, 0
    )

    # direct conv2d
    direct_conv2d_res = conv2d(input_data, kernel, stride=stride, padding=padding)
    direct_conv2d_res = direct_conv2d_res.reshape(-1)
    direct_conv2d_res = data_reshuffler_golden_model(
        N, M, 8, 8, 8, 8 * 8 * N, 1, 8 * N, direct_conv2d_res, 1
    )

    # result comparison
    assert (im2col_conv2d_res == direct_conv2d_res).all()


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

    # for testing
    # test()

    main()
