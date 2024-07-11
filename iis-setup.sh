#!/usr/bin/env bash
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Define environment variables
export BENDER=bender-0.27.1
export CC=gcc-9.2.0
export CXX=g++-9.2.0
export VCS_SEPP=vcs-2020.12
export VERILATOR_SEPP=verilator-4.110
export QUESTA_SEPP=questa-2022.3
export LLVM_BINROOT=/usr/pack/riscv-1.0-kgf/pulp-llvm-0.12.0/bin

# Create Python virtual environment with required packages
/usr/local/anaconda3-2022.05/bin/python3 -m venv .venv
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
wget https://raw.githubusercontent.com/pulp-platform/riscv-isa-sim/snitch/iis-install-spike-dasm.sh
chmod +x iis-install-spike-dasm.sh && ./iis-install-spike-dasm.sh && rm iis-install-spike-dasm.sh
cd -
export PATH=$(pwd)/tools:$PATH
