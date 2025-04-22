// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

#define MSTATUS_MIE 8

.global _snitch_park
_snitch_park:
    # Set trap vector
    la      t0, _snitch_resume
    csrw    mtvec, t0
    # Enable software and cluster interrupts
    csrsi   mstatus, MSTATUS_MIE # CSR set (uimm)
    lui     t0, 0x80  # (1 << 19) cluster clint interrupt
    addi    t0, t0, 8 # (1 << 3) software interrupts (msip)
    csrw    mie, t0
    wfi

_snitch_resume:
    auipc   t0, 0
    # We need to know the address of the scratch1 register in
    # the peripherals, which is a constant offset of our current PC,
    # independent of the cluster configuration.
    # This offset can be calculated as follows:
    # - 0x20 (start of this bootrom)
    # + 0x1000 (bootrom size 4kB)
    # + 0x188 (offset of the scratch1 register)
    li      t1, 0x1168
    add     t0, t0, t1
    lw      t0, 0(t0)
    jalr    ra, 0(t0)
    j       _snitch_park
