#!/usr/bin/env python3

# Copyright 2024 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Fanchen Kong <fanchen.kong@kuleuven.be>

import numpy as np
import argparse
import pathlib
import hjson
import sys
import os

# Add data utility path
sys.path.append(os.path.join(os.path.dirname(
    __file__), "../../../../../../util/sim/"))
from data_utils import format_scalar_definition, format_vector_definition  # noqa E402
from snax_utils import max_pooling  # noqa E402
np.random.seed(42)


# Add stdint.h header
def emit_header_file(**kwargs):
    emit_str = "#include <stdint.h>\n\n"
    emit_str += "#include <stdbool.h> \n\n"
    emit_str += emit_data(**kwargs)
    return emit_str


def emit_data(**kwargs):
    MIN = -128
    MAX = 127

    data_str = ""
    data_str += format_scalar_definition("int8_t",
                                         "H",
                                         kwargs["H"]) + "\n"
    data_str += format_scalar_definition("int8_t",
                                         "W",
                                         kwargs["W"]) + "\n"
    data_str += format_scalar_definition("int8_t",
                                         "Cin",
                                         kwargs["Cin"]) + "\n"
    data_str += format_scalar_definition("int8_t",
                                         "Kh",
                                         kwargs["Kh"]) + "\n"
    data_str += format_scalar_definition("int8_t", "Kw", kwargs["Kw"]) + "\n"
    data_str += format_scalar_definition("int8_t",
                                         "pad_h", kwargs["pad_h"]) + "\n"
    data_str += format_scalar_definition("int8_t",
                                         "pad_w", kwargs["pad_w"]) + "\n"
    data_str += format_scalar_definition("int8_t",
                                         "stride_h", kwargs["stride_h"]) + "\n"
    data_str += format_scalar_definition("int8_t",
                                         "stride_w", kwargs["stride_w"]) + "\n"
    padded_h = kwargs["H"] + 2 * kwargs["pad_h"]
    padded_w = kwargs["W"] + 2 * kwargs["pad_w"]
    out_h = (kwargs["H"] + 2 * kwargs["pad_h"] -
             kwargs["Kh"]) // kwargs["stride_h"] + 1
    out_w = (kwargs["W"] + 2 * kwargs["pad_w"] -
             kwargs["Kw"]) // kwargs["stride_w"] + 1

    data_str += format_scalar_definition("int8_t", "out_H", out_h) + "\n"
    data_str += format_scalar_definition("int8_t", "out_W", out_w) + "\n"
    data_str += format_scalar_definition("int8_t", "padded_H", padded_h) + "\n"
    data_str += format_scalar_definition("int8_t", "padded_W", padded_w) + "\n"

    # Generating random input data vector
    data_in = np.random.randint(
        MIN, MAX, (1, kwargs["H"], kwargs["W"], kwargs["Cin"])
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
    data_str += format_vector_definition("int8_t",
                                         "padded_data_in",
                                         padded_data_in.reshape(-1)) + "\n"
    data_str += format_vector_definition("int8_t",
                                         "golden_data_out",
                                         c_golden.reshape(-1)) + "\n"

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
