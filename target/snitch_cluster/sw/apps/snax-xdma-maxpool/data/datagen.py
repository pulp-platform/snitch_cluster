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
from snax_utils import data_reshuffler_golden_model, max_pooling, im2col  # noqa E402

np.random.seed(42)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = "#include <stdint.h>\n\n"
    emit_str += "#include <stdbool.h> \n\n"
    emit_str += emit_data_reshuffler(**kwargs)
    return emit_str


MIN = -128
MAX = 127


def emit_data_reshuffler(**kwargs):
    data_str = []

    assert (
        kwargs["ifMaxPool"] + kwargs["iftestIm2Col"] + kwargs["ifTestTransposer"] == 1
    ), "Only one kernel can be tested at a time"

    if kwargs["ifTestTransposer"] is True:
        # Generating loop bounds settings
        data_str += [
            format_scalar_definition("int32_t", "tempLoop0_in", kwargs["tempLoop0"]),
            format_scalar_definition("int32_t", "tempLoop1_in", kwargs["tempLoop1"]),
            format_scalar_definition("int32_t", "tempLoop2_in", 1),
            format_scalar_definition("int32_t", "tempLoop3_in", 1),
            format_scalar_definition("int32_t", "tempLoop4_in", 1),
            format_scalar_definition("int32_t", "tempLoop0_out", kwargs["tempLoop0"]),
            format_scalar_definition("int32_t", "tempLoop1_out", kwargs["tempLoop1"]),
            format_scalar_definition("int32_t", "tempLoop2_out", 1),
            format_scalar_definition(
                "int32_t",
                "input_data_len",
                kwargs["tempLoop0"] * kwargs["tempLoop1"] * 8 * 8,
            ),
            format_scalar_definition(
                "int32_t",
                "output_data_len",
                kwargs["tempLoop0"] * kwargs["tempLoop1"] * 8 * 8,
            ),
        ]

        # Generating temporal strides settings
        data_str += [
            # data reshuffler input strides
            format_scalar_definition(
                "int32_t", "tempStride0_in", kwargs["tempStride0_in"]
            ),
            format_scalar_definition(
                "int32_t", "tempStride1_in", kwargs["tempStride1_in"]
            ),
            format_scalar_definition("int32_t", "tempStride2_in", 0),
            format_scalar_definition("int32_t", "tempStride3_in", 0),
            format_scalar_definition("int32_t", "tempStride4_in", 0),
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
            format_scalar_definition("int32_t", "tempStride2_out", 0),
            format_scalar_definition(
                "int32_t", "spatialStride1_out", kwargs["spatialStride1_out"]
            ),
            # Generating base address pointers
            format_scalar_definition(
                "int32_t", "delta_local_in", kwargs["delta_local_in"]
            ),
            format_scalar_definition(
                "int32_t", "delta_local_out", kwargs["delta_local_out"]
            ),
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
        data_str += [
            format_scalar_definition(
                "int", "TloopLen", kwargs["tempLoop0"] * kwargs["tempLoop1"]
            )
        ]
        data_str += [format_scalar_definition("int", "reduceLen", 1)]
        data_str += [format_scalar_definition("int", "opcode", transpose)]

        # Writing testing data and golden data into data.h
        data_str += [format_vector_definition("int8_t", "DataIn", data_in)]
        data_str += [format_vector_definition("int8_t", "C_golden", c_golden)]

    elif kwargs["iftestIm2Col"] is True:
        assert (
            kwargs["ifC8HW8datalayout"] is True
        ), "Only C8HW8 data layout is supported for im2col testing"

        # Generating layer settings
        Nbatch = kwargs["Nbatch"]
        Cin8 = kwargs["Cin"] // 8
        H = kwargs["H"]
        W = kwargs["W"]
        Kh = kwargs["Kh"]
        Kw = kwargs["Kw"]
        stride_h, stride_w = (kwargs["stride_h"], kwargs["stride_w"])
        pad_h, pad_w = (kwargs["pad_h"], kwargs["pad_w"])

        # make sure the output width is multiple of 8
        if W // stride_w % 8 != 0:
            W = W + (stride_w * (8 - (W // stride_w) % 8)) % (stride_w * 8)

        # generate random input and kernel data
        input_data = np.random.randint(-10, 10, size=(Nbatch, Cin8, H, W, 8))
        kernel = np.random.randint(-10, 10, size=(1, Cin8, Kh, Kw, 8, 8))

        # Padding the input data
        input_padding = np.pad(
            input_data,
            ((0, 0), (0, 0), (pad_h, pad_h), (pad_w, pad_w), (0, 0)),
            mode="constant",
        )

        # Calculate the size of the output feature map
        out_height = (H + 2 * pad_h - Kh) // stride_h + 1
        out_width = (W + 2 * pad_w - Kw) // stride_w + 1

        assert out_width % 8 == 0, "out_width must be multiple of 8"

        tempLoop0_in = Kw
        tempLoop1_in = Kh
        tempLoop2_in = Cin8
        tempLoop3_in = out_width // 8
        tempLoop4_in = out_height

        spatialStride1_in = 8 * stride_w

        tempStride0_in = 8
        tempStride1_in = 8 * (W + 2 * pad_w)
        tempStride2_in = 8 * (W + 2 * pad_w) * (H + 2 * pad_h)
        tempStride3_in = 8 * 8 * stride_w
        tempStride4_in = 8 * (W + 2 * pad_w) * stride_h

        tempLoop0_out = Cin8 * Kw * Kh
        tempLoop1_out = out_width // 8 * out_height
        tempLoop2_out = 1

        spatialStride1_out = 8
        tempStride0_out = 8 * 8
        tempStride1_out = 8 * 8 * Cin8 * Kw * Kh
        tempStride2_out = 0

        assert (
            tempLoop0_in * tempLoop1_in * tempLoop2_in * tempLoop3_in * tempLoop4_in
            == tempLoop0_out * tempLoop1_out * tempLoop2_out
        )

        input_data_len = input_padding.size

        explicit_im2col, _ = im2col(
            input_data, kernel, stride=(stride_h, stride_w), padding=(pad_h, pad_w)
        )
        output_data_len = explicit_im2col.size

        delta_local_in = 0
        delta_local_out = input_data_len

        data_str += [
            format_scalar_definition("int32_t", "tempLoop0_in", tempLoop0_in),
            format_scalar_definition("int32_t", "tempLoop1_in", tempLoop1_in),
            format_scalar_definition("int32_t", "tempLoop2_in", tempLoop2_in),
            format_scalar_definition("int32_t", "tempLoop3_in", tempLoop3_in),
            format_scalar_definition("int32_t", "tempLoop4_in", tempLoop4_in),
            format_scalar_definition("int32_t", "tempLoop0_out", tempLoop0_out),
            format_scalar_definition("int32_t", "tempLoop1_out", tempLoop1_out),
            format_scalar_definition("int32_t", "tempLoop2_out", tempLoop2_out),
            format_scalar_definition("int32_t", "input_data_len", input_data_len),
            format_scalar_definition("int32_t", "output_data_len", output_data_len),
            format_scalar_definition("int32_t", "spatialStride1_in", spatialStride1_in),
            format_scalar_definition("int32_t", "tempStride0_in", tempStride0_in),
            format_scalar_definition("int32_t", "tempStride1_in", tempStride1_in),
            format_scalar_definition("int32_t", "tempStride2_in", tempStride2_in),
            format_scalar_definition("int32_t", "tempStride3_in", tempStride3_in),
            format_scalar_definition("int32_t", "tempStride4_in", tempStride4_in),
            format_scalar_definition(
                "int32_t", "spatialStride1_out", spatialStride1_out
            ),
            format_scalar_definition("int32_t", "tempStride0_out", tempStride0_out),
            format_scalar_definition("int32_t", "tempStride1_out", tempStride1_out),
            format_scalar_definition("int32_t", "tempStride2_out", tempStride2_out),
            format_scalar_definition("int32_t", "delta_local_in", delta_local_in),
            format_scalar_definition("int32_t", "delta_local_out", delta_local_out),
            format_vector_definition("int8_t", "DataIn", input_padding.reshape(-1)),
            format_vector_definition("int8_t", "C_golden", explicit_im2col.reshape(-1)),
        ]

        TloopLen = (
            tempLoop0_in * tempLoop1_in * tempLoop2_in * tempLoop3_in * tempLoop4_in
        )
        reduceLen = 1
        opcode = 0

        data_str += [
            format_scalar_definition("int", "TloopLen", TloopLen),
            format_scalar_definition("int", "reduceLen", reduceLen),
            format_scalar_definition("int", "opcode", opcode),
        ]

    # max pooling then
    elif kwargs["ifC8HW8datalayout"] is True:
        # data layout, C8HW8
        # Generating loop bounds settings
        padded_input_tensor_w = kwargs["W"] + kwargs["pad_w"] * 2
        padded_input_tensor_h = kwargs["H"] + kwargs["pad_h"] * 2

        padded_output_tensor_w = (
            kwargs["W"] + kwargs["pad_w"] * 2 - kwargs["Kw"]
        ) // kwargs["stride_w"] + 1
        padded_output_tensor_h = (
            kwargs["H"] + kwargs["pad_h"] * 2 - kwargs["Kh"]
        ) // kwargs["stride_h"] + 1

        input_data_len = padded_input_tensor_w * padded_input_tensor_h * kwargs["Cin"]
        output_data_len = (
            padded_output_tensor_w * padded_output_tensor_h * kwargs["Cin"]
        )

        assert padded_output_tensor_w % 8 == 0
        assert kwargs["Cin"] % 8 == 0

        assert (
            input_data_len + output_data_len < 128 * 1024
        ), "Data size too large for 128 KB TCDM"

        data_str += [
            format_scalar_definition("int32_t", "input_data_len", input_data_len),
            # input data reshuffler loop bounds settings
            format_scalar_definition("int32_t", "tempLoop0_in", kwargs["Kw"]),
            format_scalar_definition("int32_t", "tempLoop1_in", kwargs["Kh"]),
            format_scalar_definition(
                "int32_t", "tempLoop2_in", padded_output_tensor_w // 8
            ),
            format_scalar_definition("int32_t", "tempLoop3_in", padded_output_tensor_h),
            format_scalar_definition("int32_t", "tempLoop4_in", kwargs["Cin"] // 8),
        ]

        assert padded_output_tensor_w % 8 == 0

        # data reshuffler input strides
        spatialStride1_in = kwargs["stride_w"] * 8
        tempStride0_in = 8
        tempStride1_in = padded_input_tensor_w * 8
        tempStride2_in = 8 * 8 * kwargs["stride_w"]
        tempStride3_in = padded_input_tensor_w * 8 * kwargs["stride_h"]
        tempStride4_in = padded_input_tensor_w * padded_input_tensor_h * 8
        data_str += [
            format_scalar_definition("int32_t", "delta_local_in", 0),
            format_scalar_definition("int32_t", "spatialStride1_in", spatialStride1_in),
            format_scalar_definition("int32_t", "tempStride0_in", tempStride0_in),
            format_scalar_definition("int32_t", "tempStride1_in", tempStride1_in),
            format_scalar_definition("int32_t", "tempStride2_in", tempStride2_in),
            format_scalar_definition(
                "int32_t",
                "tempStride3_in",
                tempStride3_in,
            ),
            format_scalar_definition(
                "int32_t",
                "tempStride4_in",
                tempStride4_in,
            ),
        ]

        data_str += [
            # output data reshuffler loop bounds settings
            format_scalar_definition(
                "int32_t", "tempLoop0_out", padded_output_tensor_w // 8
            ),
            format_scalar_definition(
                "int32_t", "tempLoop1_out", padded_output_tensor_h
            ),
            format_scalar_definition("int32_t", "tempLoop2_out", kwargs["Cin"] // 8),
            # data length setting
            format_scalar_definition("int32_t", "output_data_len", output_data_len),
        ]

        # data reshuffler output strides
        delta_local_out = padded_input_tensor_h * padded_input_tensor_w * kwargs["Cin"]
        spatialStride1_out = 8
        tempStride0_out = 8 * 8
        tempStride1_out = padded_output_tensor_w * 8
        tempStride2_out = padded_output_tensor_w * padded_output_tensor_h * 8
        data_str += [
            # Generating base address pointers
            format_scalar_definition(
                "int32_t",
                "delta_local_out",
                delta_local_out,
            ),
            format_scalar_definition(
                "int32_t", "spatialStride1_out", spatialStride1_out
            ),
            format_scalar_definition(
                "int32_t",
                "tempStride0_out",
                tempStride0_out,
            ),
            format_scalar_definition("int32_t", "tempStride1_out", tempStride1_out),
            format_scalar_definition(
                "int32_t",
                "tempStride2_out",
                tempStride2_out,
            ),
        ]

        assert delta_local_out % 8 == 0
        assert tempStride0_in % 8 == 0
        assert tempStride1_in % 8 == 0
        assert tempStride2_in % 8 == 0
        assert tempStride3_in % 8 == 0
        assert tempStride4_in % 8 == 0
        assert tempStride0_out % 8 == 0
        assert tempStride1_out % 8 == 0
        assert tempStride2_out % 8 == 0

        # Generating random input data vector
        data_in = np.random.randint(
            MIN, MAX, (kwargs["Cin"] // 8, kwargs["H"], kwargs["W"], 8)
        )

        # Generating golden data
        c_golden = max_pooling(
            data_in,
            kwargs["Kw"],
            kwargs["Kh"],
            kwargs["stride_w"],
            kwargs["stride_h"],
            kwargs["pad_w"],
            kwargs["pad_h"],
            "C8HW8",
        )

        padded_data_in = np.pad(
            data_in,
            (
                (0, 0),
                (kwargs["pad_h"], kwargs["pad_h"]),
                (kwargs["pad_w"], kwargs["pad_w"]),
                (0, 0),
            ),
            "constant",
        )

        # datapath setting
        # set opcode
        data_str += [format_scalar_definition("int", "opcode", 2)]
        # set TloopLen and reduceLen
        data_str += [
            format_scalar_definition(
                "int32_t",
                "TloopLen",
                padded_output_tensor_w
                * padded_output_tensor_h
                * kwargs["Cin"]
                // 8
                // 8,
            ),
            format_scalar_definition(
                "int32_t", "reduceLen", kwargs["Kw"] * kwargs["Kh"]
            ),
        ]

        # Writing testing data and golden data into data.h
        assert padded_data_in.shape == (
            kwargs["Cin"] // 8,
            padded_input_tensor_h,
            padded_input_tensor_w,
            8,
        )
        assert padded_data_in.reshape(-1).shape[0] == input_data_len
        data_str += [
            format_vector_definition("int8_t", "DataIn", padded_data_in.reshape(-1))
        ]

        assert c_golden.shape == (
            kwargs["Cin"] // 8,
            padded_output_tensor_h,
            padded_output_tensor_w,
            8,
        )
        assert c_golden.reshape(-1).shape[0] == output_data_len

        data_str += [
            format_vector_definition("int8_t", "C_golden", c_golden.reshape(-1))
        ]

    else:
        # data layout HWCin
        # Generating loop bounds settings
        padded_input_tensor_w = kwargs["W"] + kwargs["pad_w"] * 2
        padded_input_tensor_h = kwargs["H"] + kwargs["pad_h"] * 2

        padded_output_tensor_w = (
            kwargs["W"] + kwargs["pad_w"] * 2 - kwargs["Kw"]
        ) // kwargs["stride_w"] + 1
        padded_output_tensor_h = (
            kwargs["H"] + kwargs["pad_h"] * 2 - kwargs["Kh"]
        ) // kwargs["stride_h"] + 1

        input_data_len = padded_input_tensor_w * padded_input_tensor_h * kwargs["Cin"]
        output_data_len = (
            padded_output_tensor_w * padded_output_tensor_h * kwargs["Cin"]
        )

        assert padded_output_tensor_w == kwargs["W"]
        assert padded_output_tensor_h == kwargs["H"]

        data_str += [
            # input data reshuffler loop bounds settings
            format_scalar_definition("int32_t", "tempLoop0_in", kwargs["Kw"]),
            format_scalar_definition("int32_t", "tempLoop1_in", kwargs["Kh"]),
            format_scalar_definition("int32_t", "tempLoop2_in", kwargs["Cin"] // 8),
            format_scalar_definition(
                "int32_t", "tempLoop3_in", padded_output_tensor_w // 8
            ),
            format_scalar_definition("int32_t", "tempLoop4_in", padded_output_tensor_h),
            # output data reshuffler loop bounds settings
            format_scalar_definition("int32_t", "tempLoop0_out", kwargs["Cin"] // 8),
            format_scalar_definition(
                "int32_t", "tempLoop1_out", padded_output_tensor_w // 8
            ),
            format_scalar_definition(
                "int32_t", "tempLoop2_out", padded_output_tensor_h
            ),
            # data length setting
            format_scalar_definition("int32_t", "input_data_len", input_data_len),
            format_scalar_definition("int32_t", "output_data_len", output_data_len),
            format_scalar_definition(
                "int32_t",
                "TloopLen",
                padded_output_tensor_w
                * padded_output_tensor_h
                * kwargs["Cin"]
                // 8
                // 8,
            ),
            format_scalar_definition(
                "int32_t", "reduceLen", kwargs["Kw"] * kwargs["Kh"]
            ),
        ]

        data_str += [
            # data reshuffler input strides
            format_scalar_definition("int32_t", "spatialStride1_in", kwargs["Cin"]),
            format_scalar_definition(
                "int32_t", "tempStride0_in", kwargs["stride_w"] * kwargs["Cin"]
            ),
            format_scalar_definition(
                "int32_t", "tempStride1_in", padded_input_tensor_w * kwargs["Cin"]
            ),
            format_scalar_definition("int32_t", "tempStride2_in", 8),
            format_scalar_definition("int32_t", "tempStride3_in", 8 * kwargs["Cin"]),
            format_scalar_definition(
                "int32_t", "tempStride4_in", padded_input_tensor_w * kwargs["Cin"]
            ),
            # data reshuffler output strides
            format_scalar_definition("int32_t", "spatialStride1_out", kwargs["Cin"]),
            format_scalar_definition("int32_t", "tempStride0_out", 8),
            format_scalar_definition("int32_t", "tempStride1_out", 8 * kwargs["Cin"]),
            format_scalar_definition(
                "int32_t", "tempStride2_out", padded_output_tensor_w * kwargs["Cin"]
            ),
            # Generating base address pointers
            format_scalar_definition("int32_t", "delta_local_in", 0),
            format_scalar_definition(
                "int32_t",
                "delta_local_out",
                padded_input_tensor_h * padded_input_tensor_w * kwargs["Cin"],
            ),
        ]

        # Generating random input data vector
        data_in = np.random.randint(
            MIN, MAX, (1, kwargs["H"], kwargs["W"], kwargs["Cin"])
        )

        # Generating golden data
        c_golden = max_pooling(
            data_in,
            kwargs["Kw"],
            kwargs["Kh"],
            kwargs["stride_w"],
            kwargs["stride_h"],
            kwargs["pad_w"],
            kwargs["pad_h"],
            "HWC",
        )

        padded_data_in = np.pad(
            data_in,
            (
                (0, 0),
                (kwargs["pad_h"], kwargs["pad_h"]),
                (kwargs["pad_w"], kwargs["pad_w"]),
                (0, 0),
            ),
            "constant",
        )

        # set opcode
        data_str += [format_scalar_definition("int", "opcode", 2)]

        # Writing testing data and golden data into data.h
        assert padded_data_in.shape == (
            1,
            padded_input_tensor_h,
            padded_input_tensor_w,
            kwargs["Cin"],
        )
        assert padded_data_in.reshape(-1).shape[0] == input_data_len
        data_str += [
            format_vector_definition("int8_t", "DataIn", padded_data_in.reshape(-1))
        ]

        assert c_golden.shape == (
            1,
            padded_output_tensor_h,
            padded_output_tensor_w,
            kwargs["Cin"],
        )
        assert c_golden.reshape(-1).shape[0] == output_data_len

        data_str += [
            format_vector_definition("int8_t", "C_golden", c_golden.reshape(-1))
        ]

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
