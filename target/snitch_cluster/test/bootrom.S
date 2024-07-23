# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

.global _start
.extern _l3_base

_start:
    lui   t0, %hi(_l3_base) // Load the L3 base address
    addi  t0, t0, %lo(_l3_base)
    jalr  zero, t0, 0  // Jump to the L3 base address
wfi_loop:
    wfi
    j     wfi_loop
