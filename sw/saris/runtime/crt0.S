// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

# HTIF sections
.pushsection .htif,"aw",@progbits;
.align 6; .global tohost; tohost: .dword 0;
.align 6; .global fromhost; fromhost: .dword 0;

.globl _start
.section .text._start
_start:
  # Set global pointer
  .option push
  .option norelax
  la      gp, __global_pointer
  .option pop

  # Prepare main arguments for single cluster
  csrr    a0, mhartid
  la      a1, __const_num_cores
  la      a2, __const_tcdm_start
  la      a3, __const_tcdm_end

  # Set stack pointer; 1KiB per core
  # Offset by 8B to prevent bank collisions
  slli    t0, a0, 10
  addi    sp, a3, -8
  sub     sp, sp, t0
  slli    t0, a0, 3
  sub     sp, sp, t0

.globl _putcb
_init_putcb:
  la      t0, _putcb
  # Initialize ptchar buffer size of each core to 0
  slli    t1, a0, 10
  add     t0, t0, t1
  sw      zero, 0(t0)
  sw      zero, 4(t0)

_skip_dmcc_work:
  # Skip the coming two steps unless we are the DMA core
  # NOTE: this assumes the DMA core being the last in the cluster
  addi    t0, a1, -1
  bne     a0, t0, _dmcc_work_sync

_preload_tcdm:
  # Preload thread-local storage (TCDM) using DMA
  la      t0, __const_tcdm_losta
  la      t1, __const_tcdm_loend
  sub     t3, t1, t0
  # Branch off if no tcdm data
  beqz    t3, _preload_tcdmc
  # Launch copy to base of TCDM
  dmsrc   t0, zero
  dmdst   a2, zero
  dmcpyi  zero, t3, 0
  # Await DMA
  1:
  dmstati t0, 2
  bnez    t0, 1b

_preload_tcdmc:
  # Preload thread-local storage (TCDM) using DMA
  la      t0, __const_tcdmc_losta
  la      t1, __const_tcdmc_loend
  sub     t3, t1, t0
  # Get tcdmc base, branch off if no tcdmc data
  la      t2, __const_tcdm_startc
  beqz    t3, _dmcc_work_sync
  # Launch copy to past end of TCDM
  dmsrc   t0, zero
  dmdst   t2, zero
  dmcpyi  zero, t3, 0
  # Await DMA
  1:
  dmstati t0, 2
  bnez    t0, 1b

_dmcc_work_sync:
  # Synchronize cores so data is ready
  csrr    x0, 0x7C2

  # check if the core has the F-extension
  csrr    t0, misa
  andi    t0, t0, (1 << 5)
  beqz    t0, _clr_ireg

  # Reset float regs if present
_clr_freg:
  fcvt.d.w f0, x0
  fmv.d   f1, f0
  fmv.d   f2, f0
  fmv.d   f3, f0
  fmv.d   f4, f0
  fmv.d   f5, f0
  fmv.d   f6, f0
  fmv.d   f7, f0
  fmv.d   f8, f0
  fmv.d   f9, f0
  fmv.d   f10, f0
  fmv.d   f11, f0
  fmv.d   f12, f0
  fmv.d   f13, f0
  fmv.d   f14, f0
  fmv.d   f15, f0
  fmv.d   f16, f0
  fmv.d   f17, f0
  fmv.d   f18, f0
  fmv.d   f19, f0
  fmv.d   f20, f0
  fmv.d   f10, f0
  fmv.d   f21, f0
  fmv.d   f22, f0
  fmv.d   f23, f0
  fmv.d   f24, f0
  fmv.d   f25, f0
  fmv.d   f26, f0
  fmv.d   f27, f0
  fmv.d   f28, f0
  fmv.d   f29, f0
  fmv.d   f30, f0
  fmv.d   f31, f0

  # Reset remaining int regs
_clr_ireg:
  li      tp, 0
  li      t0, 0
  li      t1, 0
  li      t2, 0
  li      t3, 0
  li      t4, 0
  li      t5, 0
  li      t6, 0
  li      a6, 0
  li      a7, 0
  li      s0, 0
  li      s1, 0
  li      s2, 0
  li      s3, 0
  li      s4, 0
  li      s5, 0
  li      s6, 0
  li      s7, 0
  li      s8, 0
  li      s9, 0
  li      s10, 0
  li      s11, 0

  # Call main
  call smain

_eoc:
  # Synchronize cores
  csrr    x0, 0x7C2
  # Only core 0 (of all cores) returns
  csrr    t0, mhartid
  bnez    t0, _done
  # Write termination bit and return code (a0) to tohost
  slli    a0, a0, 1
  ori     a0, a0, 1
  la      t0, tohost
  sw      a0, 0(t0)
  # Go to sleep
_done:
  wfi


.section .data._putcb
_putcb:
