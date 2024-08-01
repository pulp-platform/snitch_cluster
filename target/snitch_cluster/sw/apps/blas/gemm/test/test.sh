#!/bin/sh
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>
# Viviane Potocnik <vivianep@iis.ee.ethz.ch>

ROOT=$(git rev-parse --show-toplevel)
BUILD_PY=$ROOT/target/snitch_cluster/util/build.py
RUN_PY=$ROOT/target/snitch_cluster/util/run.py
TEST_LIST=$(pwd)/run.yaml
CFG_FILES=$(pwd)/cfg/"*"
CMD="$ROOT/sw/blas/gemm/scripts/verify.py \${sim_bin} \${elf} --dump-results"

$BUILD_PY gemm --cfg $CFG_FILES --testlist $TEST_LIST --testlist-cmd "$CMD"
$RUN_PY $TEST_LIST --simulator vsim -j
