#!/usr/bin/env bash
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Define environment variables
export BENDER=bender-0.28.1
export CC=gcc-9.2.0
export CXX=g++-9.2.0
export VCS_SEPP=vcs-2020.12
export VERILATOR_SEPP=verilator-5.020
export QUESTA_SEPP=questa-2022.3
export LLVM_BINROOT=/usr/scratch2/vulcano/colluca/tools/riscv32-snitch-llvm-almalinux8-15.0.0-snitch-0.1.0/bin

# Create Python virtual environment with required packages
/usr/local/anaconda3-2023.07/bin/python -m venv .venv
source .venv/bin/activate
# Install local packages in editable mode and unpack packages in a
# local temporary directory which can be safely cleaned after installation.
# Also protects against "No space left on device" errors
# occurring when the /tmp folder is filled by other processes.
mkdir tmp
TMPDIR=tmp pip install -e .
rm -rf tmp
