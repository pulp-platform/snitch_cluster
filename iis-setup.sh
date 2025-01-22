#!/usr/bin/env bash
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Define environment variables
export BENDER=bender-0.28.1
export CC=gcc-9.2.0
export CXX=g++-9.2.0
export VCS_SEPP=vcs-2024.09
export VERILATOR_SEPP=verilator-5.020
export QUESTA_SEPP=questa-2023.4
export LLVM_BINROOT=/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0/bin

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
