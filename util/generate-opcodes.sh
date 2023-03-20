#!/bin/bash
# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Generate the opcodes for the Snitch system.
set -e
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

RISCV_OPCODES=$ROOT/sw/deps/riscv-opcodes
OPCODES=(opcodes-pseudo opcodes-rv32i opcodes-rv64i opcodes-rv32m opcodes-rv64m opcodes-rv32a opcodes-rv64a opcodes-rv32h opcodes-rv64h opcodes-rv32f opcodes-rv64f opcodes-rv32d opcodes-rv64d opcodes-rv32q opcodes-rv64q opcodes-system opcodes-custom opcodes-rv32b_CUSTOM opcodes-dma_CUSTOM opcodes-frep_CUSTOM opcodes-ssr_CUSTOM opcodes-flt-occamy_CUSTOM opcodes-rvv-pseudo)

#######
# RTL #
#######
OPCODES+=(opcodes-ipu_CUSTOM)
INSTR_SV=$ROOT/hw/snitch/src/riscv_instr.sv

cat > $INSTR_SV <<- EOM
// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

EOM
echo -e "// verilog_lint: waive-start parameter-name-style" >> $INSTR_SV
cd $RISCV_OPCODES && cat ${OPCODES[@]} | ./parse_opcodes -sverilog >> $INSTR_SV
echo -e "// verilog_lint: waive-stop parameter-name-style" >> $INSTR_SV
