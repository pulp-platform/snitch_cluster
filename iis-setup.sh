#!/usr/bin/env bash
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Define environment variables
export CC=gcc-9.2.0
export CXX=g++-9.2.0
export SN_OSEDA="oseda -2025.03"
export SN_BENDER=bender-0.28.1
export SN_VCS_SEPP=vcs-2024.09
export SN_VERILATOR_SEPP=$SN_OSEDA
export SN_QUESTA_SEPP=questa-2023.4
export SN_YOSYS="$SN_OSEDA yosys"
export SN_LLVM_BINROOT=/usr/scratch2/vulcano/colluca/tools/riscv32-snitch-llvm-almalinux8-15.0.0-snitch-0.5.0/bin

# Add simulator binaries to PATH
export PATH=$PWD/target/sim/build/bin:$PATH

# We use `uv` for managing python dependencies and environments
export SN_UV="/usr/local/uv/uv run --all-extras"
# Setting the path is only necessary for manual `uv run` commands
export PATH=$PATH:/usr/local/uv
# Copy instead link packages from global cache, since the cache is typically
# located on a different file system (e.g. your home directory).
export UV_LINK_MODE=copy
