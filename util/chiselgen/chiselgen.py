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
        "--streamer_cfg_para_name",
        "-c",
        type=str,
        required=True,
        help="The specific parameter class for the streamer \
        to generate the system verilog file",
    )
    parser.add_argument(
        "--outdir",
        "-o",
        type=pathlib.Path,
        required=True,
        help="Target directory to put the generated system verilog file.",
    )

    args = parser.parse_args()
    streamer_cfg_para = args.streamer_cfg_para_name
    outdir = args.outdir

    # call chisel environment and generate the system verilog file
    chisel_dir = "../../hw/chisel"
    cmd = f' cd {chisel_dir} && sbt "runMain snax.streamer.{streamer_cfg_para} {outdir}"'
    os.system(cmd)


if __name__ == "__main__":
    main()
