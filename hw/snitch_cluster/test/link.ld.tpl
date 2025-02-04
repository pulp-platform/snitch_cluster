/* Copyright 2020 ETH Zurich and University of Bologna. */
/* Solderpad Hardware License, Version 0.51, see LICENSE for details. */
/* SPDX-License-Identifier: SHL-0.51 */

OUTPUT_ARCH( "riscv" )
ENTRY(_start)
<% dram_address = next(reg['address'] for reg in cfg['external_addr_regions'] if reg['name'] == 'dram'); %>
<% dram_length = next(reg['length'] for reg in cfg['external_addr_regions'] if reg['name'] == 'dram'); %>

MEMORY
{
    DRAM (rwxai)  : ORIGIN = ${dram_address}, LENGTH = ${dram_length}
    L1 (rw) : ORIGIN = ${l1_region[0]}, LENGTH = ${l1_region[1]}K
}

SECTIONS
{
  . = ${dram_address};
  .text.init : { *(.text.init) }
  . = ALIGN(0x1000);
  .tohost : { *(.tohost) }
  . = ALIGN(0x1000);
  .text : { *(.text) }
  . = ALIGN(0x1000);
  .data : { *(.data) }
  .bss : { *(.bss) }
  _end = .;
}
