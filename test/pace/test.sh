#!/bin/sh
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

set -e

ROOT=$(git rev-parse --show-toplevel)
BUILD_PY=$ROOT/util/experiments/build.py
RUN_PY=$ROOT/util/experiments/run.py
TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)

ELEMENTWISE_CFG="$ROOT/sw/kernels/pace/elementwise/data/params_*.json"
SOFTMAX_CFG="$ROOT/sw/kernels/pace/softmax/data/params.json"
ELEMENTWISE_TEST_LIST=$TEST_DIR/elementwise.yaml
SOFTMAX_TEST_LIST=$TEST_DIR/softmax.yaml
ELEMENTWISE_CMD="$ROOT/sw/kernels/pace/elementwise/scripts/verify.py \${sim_bin} \${elf} --dump-results"
SOFTMAX_CMD="$ROOT/sw/kernels/pace/softmax/scripts/verify.py \${sim_bin} \${elf} --dump-results"

cd "$TEST_DIR"

$BUILD_PY pace_elementwise \
    --cfg $ELEMENTWISE_CFG \
    --testlist "$ELEMENTWISE_TEST_LIST" \
    --testlist-cmd "$ELEMENTWISE_CMD"
$BUILD_PY pace_softmax \
    --cfg $SOFTMAX_CFG \
    --testlist "$SOFTMAX_TEST_LIST" \
    --testlist-cmd "$SOFTMAX_CMD"

$RUN_PY "$ELEMENTWISE_TEST_LIST" --simulator "${SIMULATOR:-vsim}" -j
$RUN_PY "$SOFTMAX_TEST_LIST" --simulator "${SIMULATOR:-vsim}" -j
