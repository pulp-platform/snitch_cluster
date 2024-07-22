/* Copyright 2020 ETH Zurich and University of Bologna. */
/* Solderpad Hardware License, Version 0.51, see LICENSE for details. */
/* SPDX-License-Identifier: SHL-0.51 */

INCLUDE "memory.ld"
ENTRY(_start)

SECTIONS
{
  .text : { *(.text) }
  _l3_base = ORIGIN(L3);
}
