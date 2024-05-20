/* Copyright 2024 ETH Zurich and University of Bologna. */
/* Licensed under the Apache License, Version 2.0, see LICENSE for details. */
/* SPDX-License-Identifier: SHL-0.51 */

OUTPUT_ARCH( "riscv" )
ENTRY(_start)

MEMORY
{
  /*  Reserve upper 9*1Ki = 9Ki of TCDM for stack, plus some padding.
      This can be expanded to allocate the full CC TCDM as needed.
      A 2 KiB RO is provided in the TCDM for small data + consts. */
  tcdm (rw)   : ORIGIN = 0x10000000,  LENGTH = 0x1CC00
  tcdmc (r)   : ORIGIN = 0x1001CC00,  LENGTH = 2K
  dram (rwxa) : ORIGIN = 0x90000000,  LENGTH = 1024M
  dtxt (rwxa) : ORIGIN = 0x80000000,  LENGTH = 1024M
}

SECTIONS
{
  /DISCARD/ : { *(.riscv.attributes) *(.comment) *(.rela.*) *(.sym.*) }

  .text : { *(.text._start) *(.text) *(.text.*); . = ALIGN(16); } >dtxt
  .misc : { *(.data) *(.data.*) *(.putcb) } >dram
  .tcdm : { *(.tcdm) *(.l1) } >tcdm AT>dram
  .tcdmc : { *(.sdata) *(.sdata.*) *(.rodata) *(.rodata.*) } >tcdmc AT>dram

  /* Global and stack pointer: in TCDM */
  __global_pointer    = ADDR(.tcdmc) + SIZEOF(.tcdmc) / 2;

  /* Memory Layout Constants */
  __const_num_cores   = 9;
  __const_tcdm_start  = ORIGIN(tcdm);
  __const_tcdm_startc = ORIGIN(tcdmc);
  __const_tcdm_end    = ORIGIN(tcdm) + 128K;
  __const_dram_start  = ORIGIN(dram);

  /* TCDM Loading */
  __const_tcdm_losta  = LOADADDR(.tcdm);
  __const_tcdm_loend  = LOADADDR(.tcdm) + SIZEOF(.tcdm);
  __const_tcdmc_losta = LOADADDR(.tcdmc);
  __const_tcdmc_loend = LOADADDR(.tcdmc) + SIZEOF(.tcdmc);

  /* HTIF section for FESVR */
  .htif : { } >dram
}
