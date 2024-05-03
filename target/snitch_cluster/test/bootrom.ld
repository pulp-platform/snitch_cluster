/* Copyright 2020 ETH Zurich and University of Bologna. */
/* Solderpad Hardware License, Version 0.51, see LICENSE for details. */
/* SPDX-License-Identifier: SHL-0.51 */

ENTRY(_snitch_park)

SECTIONS
{
  . = 0x1000;
  ctrl_scratch1 = 0x18020188;
  .text : { *(.text) }
  
  /*
  .text : { *(.text._start) *(.text) *(.text.*) } > bootrom
  . = ALIGN(16);
  .misc : { *(.data) *(.sdata) *(.*) } > bootrom
  */
}
