# Copyright 2024 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51

.global _start
.extern _l3_base

_start:
    lui   t0, %hi(_l3_base)        /* Load upper 20 bits of _l3_base into t0 */
    addi  t0, t0, %lo(_l3_base)    /* Add lower 12 bits to get the full address in t0 */
    jalr  zero, t0, 0              /* Absolute jump to the address in t0 */
wfi_loop:
    wfi
    j     wfi_loop
