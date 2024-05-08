#!/usr/bin/env python3

# Copyright 2023 KU Leuven.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

import argparse
import os
import pathlib


def main():
    """Generate the streamer system verilog files"""

    # parse the args
    parser = argparse.ArgumentParser(prog="chiselgen")
    parser.add_argument(
        "--chisel_param",
        type=str,
        required=True,
        help="Parameter class name",
    )
    parser.add_argument(
        "--chisel_path",
        type=pathlib.Path,
        required=True,
        help="Points to chisel source path",
    )
    parser.add_argument(
        "--gen_path",
        type=pathlib.Path,
        required=True,
        help="Target directory to put the generated system verilog file.",
    )

    args = parser.parse_args()
    chisel_path = args.chisel_path
    chisel_param = args.chisel_param
    gen_path = args.gen_path

    # Call chisel environment and generate the system verilog file
    cmd = f' cd {chisel_path} && sbt \
        "runMain {chisel_param} {gen_path}"'
    os.system(cmd)


if __name__ == "__main__":
    main()
