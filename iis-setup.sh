#!/usr/bin/env bash
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Define environment variables
export CC=gcc-9.2.0
export CXX=g++-9.2.0
export SN_BENDER=bender-0.28.1
export SN_VCS_SEPP=vcs-2024.09
export SN_VERILATOR_SEPP=oseda
export SN_QUESTA_SEPP=questa-2023.4
export SN_LLVM_BINROOT=/usr/scratch2/vulcano/colluca/tools/riscv32-snitch-llvm-almalinux8-15.0.0-snitch-0.2.0/bin

# Add simulator binaries to PATH
export PATH=$PWD/target/sim/build/bin:$PATH

# For all python developments we use uv to setup the environment etc.,
export SN_UV="/usr/local/uv/uv run --all-extras"
export PATH="/usr/local/uv/:$PATH"
# IT does not like if stuff is cached in home. We could use a temporary
# directory, but since this script is not usually run numerous times, we
# just disable the cache.
# (see .gitlab-ci.yml for example of using smart caching with uv)
export UV_NO_CACHE="true"
