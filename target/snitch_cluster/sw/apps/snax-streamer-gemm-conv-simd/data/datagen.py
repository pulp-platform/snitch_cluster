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
)  # noqa E402

np.random.seed(42)


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
    input_data = np.random.randint(MIN, MAX, size=(Nbatch, H, W, Cin))
    kernel = np.random.randint(MIN, MAX, size=(Cout, Kh, Kw, Cin))

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

    length_c = M * N * 8 * 8
    bias = np.random.randint(-(2**30), 2**30 - 1, length_c)

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
    delta_local_d8 = input_padding.size + kernel.size + length_c * 4
    delta_local_d32 = delta_local_d8
    data_str += [
        format_scalar_definition("int32_t", "delta_local_a", delta_local_a),
        format_scalar_definition("int32_t", "delta_local_b", delta_local_b),
        format_scalar_definition("int32_t", "delta_local_d8", delta_local_d8),
        format_scalar_definition("int32_t", "delta_local_c", delta_local_c),
        format_scalar_definition("int32_t", "delta_local_d32", delta_local_d32),
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
    Cslstride0 = 1 * 4
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

    # D32 is int32_t so the stride is 4 times of the int8_t
    D32out = Cout
    D32slstride0 = 1 * 4
    D32slstride1 = D32out * 4

    # N dim
    D32tlbound0 = D32out // 8
    D32tlstride0 = 8 * 4

    # M dim
    # K is merged because of the block gemm output stationarity
    D32tlbound1 = W // 8
    D32tlstride1 = D32out * 8 * 4

    D32tlbound2 = H
    D32tlstride2 = D32out * W * 4

    # Batch dim
    D32tlbound3 = Nbatch
    D32tlstride3 = D32out * H * W * 4

    data_str += [
        format_scalar_definition("int32_t", "D32slstride0", D32slstride0),
        format_scalar_definition("int32_t", "D32slstride1", D32slstride1),
        format_scalar_definition("int32_t", "D32tlbound0", D32tlbound0),
        format_scalar_definition("int32_t", "D32tlstride0", D32tlstride0),
        format_scalar_definition("int32_t", "D32tlbound1", D32tlbound1),
        format_scalar_definition("int32_t", "D32tlstride1", D32tlstride1),
        format_scalar_definition("int32_t", "D32tlbound2", D32tlbound2),
        format_scalar_definition("int32_t", "D32tlstride2", D32tlstride2),
        format_scalar_definition("int32_t", "D32tlbound3", D32tlbound3),
        format_scalar_definition("int32_t", "D32tlstride3", D32tlstride3),
    ]

    # postprocessing D8 settings
    D8out = Cout
    D8slstride0 = 1
    D8slstride1 = D8out

    # N dim
    D8tlbound0 = D8out // 8
    D8tlstride0 = 8

    # M dim
    # K is merged because of the block gemm output stationarity
    D8tlbound1 = W // 8
    D8tlstride1 = D8out * 8

    D8tlbound2 = H
    D8tlstride2 = D8out * W

    # Batch dim
    D8tlbound3 = Nbatch
    D8tlstride3 = D8out * H * W

    data_str += [
        format_scalar_definition("int32_t", "D8slstride0", D8slstride0),
        format_scalar_definition("int32_t", "D8slstride1", D8slstride1),
        format_scalar_definition("int32_t", "D8tlbound0", D8tlbound0),
        format_scalar_definition("int32_t", "D8tlstride0", D8tlstride0),
        format_scalar_definition("int32_t", "D8tlbound1", D8tlbound1),
        format_scalar_definition("int32_t", "D8tlstride1", D8tlstride1),
        format_scalar_definition("int32_t", "D8tlbound2", D8tlbound2),
        format_scalar_definition("int32_t", "D8tlstride2", D8tlstride2),
        format_scalar_definition("int32_t", "D8tlbound3", D8tlbound3),
        format_scalar_definition("int32_t", "D8tlstride3", D8tlstride3),
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
    # im2col_conv2d_res = block_gemm_golden_model(
    #     M, K, N, 8, 8, 8, im2col_matrix, im2col_kernel, 0, 0, bias
    # )
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
    data_str += [format_vector_definition("int32_t", "C", bias.reshape(-1))]

    # explicit im2col matrix and kernel, store the columned input data
    # for comparing with the implicit im2col method
    # data_str += [format_vector_definition("int8_t", "A", im2col_matrix)]
    # data_str += [format_vector_definition("int8_t", "B", im2col_kernel)]

    # -----------------------------------------------------------
    # Postprocessing
    # -----------------------------------------------------------

    # Generating random constant values
    input_zp_i = np.random.randint(MIN, MAX)
    output_zp_i = np.random.randint(MIN, MAX)
    shift_i = np.random.randint(0, 63)  # values between 0-63
    max_int_i = MAX
    min_int_i = MIN
    double_round_i = np.random.randint(0, 1)
    multiplier_i = np.random.randint(-(2**31), 2**31 - 1)

    # Writing the constant values to data.h
    data_str += [
        format_scalar_definition("int8_t", "input_zp_i", input_zp_i),
        format_scalar_definition("int8_t", "output_zp_i", output_zp_i),
        format_scalar_definition("int8_t", "shift_i", shift_i),
        format_scalar_definition("int8_t", "max_int_i", max_int_i),
        format_scalar_definition("int8_t", "min_int_i", min_int_i),
        format_scalar_definition("int8_t", "double_round_i", double_round_i),
        format_scalar_definition("int32_t", "multiplier_i", multiplier_i),
    ]

    bypassSIMD = kwargs["bypassSIMD"]
    data_str += [format_scalar_definition("int32_t", "bypassSIMD", bypassSIMD)]

    data_str += [
        format_vector_definition(
            "int32_t", "D32_direct_conv2d", np.add(direct_conv2d_res, bias)
        )
    ]

    if bypassSIMD == 0:
        direct_conv2d_res = postprocessing_simd_golden_model(
            np.add(direct_conv2d_res, bias),
            input_zp_i,
            output_zp_i,
            shift_i,
            max_int_i,
            min_int_i,
            double_round_i,
            multiplier_i,
        )
        data_str += [
            format_vector_definition("int8_t", "D8_direct_conv2d", direct_conv2d_res)
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
