#!/bin/bash
# Copyright 2020 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

# Generate the opcodes for the Snitch system.
set -e
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)

# TODO(colluca): what about rvv-pseudo?
OPCODES=(rv_i rv32_i rv64_i rv_zicsr rv_zifencei rv_s rv_m rv_sdext rv32_m rv64_m rv_a rv64_a rv32_h rv64_h rv_f rv64_f rv_d rv64_d rv_q rv64_q rv_system unratified/rv32_b unratified/rv_dma unratified/rv_frep unratified/rv_ssr unratified/rv_ipu unratified/rv_copift unratified/rv_flt_occamy unratified/rv32_xpulppostmod unratified/rv32_xpulpabs unratified/rv32_xpulpbitop unratified/rv32_xpulpbr unratified/rv32_xpulpclip unratified/rv32_xpulpmacsi unratified/rv32_xpulpminmax unratified/rv32_xpulpslet unratified/rv32_xpulpvect unratified/rv32_xpulpvectshufflepack)

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
