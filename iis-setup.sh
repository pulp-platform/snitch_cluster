#!/usr/bin/env bash
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Define environment variables
export PYTHON=/usr/local/anaconda3-2022.05/bin/python3
export BENDER=bender-0.27.1
export CC=gcc-9.2.0
export CXX=g++-9.2.0
export VCS_SEPP=vcs-2020.12
export VERILATOR_SEPP=verilator-4.110
export QUESTA_SEPP=questa-2022.3
export LLVM_BINROOT=/scratch/sem24f2/llvm-project
#export LLVM_BINROOT=/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0/bin

# Create Python virtual environment with required packages
$PYTHON -m venv .venv
source .venv/bin/activate
# Unpack packages in a local temporary directory which can be safely cleaned
# after installation. Also protects against "No space left on device" errors
# occurring when the /tmp folder is filled by other processes.
mkdir tmp
TMPDIR=tmp pip install -r python-requirements.txt
rm -rf tmp

# Bender initialization
$BENDER vendor init

# Install spike-dasm
mkdir tools/
cd tools/
wget https://github.com/pulp-platform/riscv-isa-sim/releases/download/snitch-v0.1.0/snitch-spike-dasm-0.1.0-x86_64-linux-gnu-almalinux8.7.tar.gz
tar xzf snitch-spike-dasm-0.1.0-x86_64-linux-gnu-almalinux8.7.tar.gz
cd -
echo $PATH
export PATH=$(pwd)/tools:$PATH
