#!/bin/bash
# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Generate the opcodes for the Snitch system.
set -e
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

OPCODES=($(cat "$(dirname "${BASH_SOURCE[0]}")/opcodes.txt"))

INSTR_SV=$ROOT/hw/snitch/src/riscv_instr.sv

cat > $INSTR_SV <<- EOM
// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

EOM
echo -e "// verilog_lint: waive-start parameter-name-style" >> $INSTR_SV
riscv_opcodes -sverilog --warn-overlap ${OPCODES[@]}
# Dump riscv_opcodes output to the instruction file
cat inst.sverilog >> $INSTR_SV
# Delete riscv_opcodes artifacts
rm inst.sverilog instr_dict.json
echo -e "// verilog_lint: waive-stop parameter-name-style" >> $INSTR_SV
