// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`ifndef SNITCH_TYPEDEF_SVH_
`define SNITCH_TYPEDEF_SVH_

`include "reqrsp_interface/typedef.svh"

////////////////////
// Data interface //
////////////////////

`define SNITCH_DATA_REQ_CHAN_STRUCT(__data_width, __addr_width) \
  struct packed {                                               \
    logic [``__addr_width``-1:0]   addr;                        \
    logic                          write;                       \
    snitch_pkg::amo_op_e           amo;                         \
    logic [``__data_width``-1:0]   data;                        \
    logic [``__data_width``/8-1:0] strb;                        \
    logic [63:0]                   user;                        \
    snitch_pkg::size_t             size;                        \
  }

`define SNITCH_DATA_RSP_CHAN_STRUCT(__data_width) \
  struct packed {                                 \
    logic [``__data_width``-1:0] data;            \
    logic                        error;           \
  }

`define SNITCH_DATA_REQ_STRUCT(__data_width, __addr_width) \
  `GENERIC_REQRSP_REQ_STRUCT(`SNITCH_DATA_REQ_CHAN_STRUCT(__data_width, __addr_width))

`define SNITCH_DATA_RSP_STRUCT(__data_width) \
  `GENERIC_REQRSP_RSP_STRUCT(`SNITCH_DATA_RSP_CHAN_STRUCT(__data_width))

///////////////////////////
// Accelerator interface //
///////////////////////////

`define SNITCH_ACC_REQ_CHAN_STRUCT(__data_width, __addr_width) \
  struct packed {                                              \
    snitch_pkg::acc_addr_e       addr;                         \
    logic [4:0]                  id;                           \
    logic [31:0]                 data_op;                      \
    logic [``__data_width``-1:0] data_arga;                    \
    logic [``__data_width``-1:0] data_argb;                    \
    logic [``__addr_width``-1:0] data_argc;                    \
  }

`define SNITCH_ACC_RSP_CHAN_STRUCT(__data_width) \
  struct packed {                                \
    logic [4:0]                  id;             \
    logic                        error;          \
    logic [``__data_width``-1:0] data;           \
  }

`define SNITCH_ACC_REQ_STRUCT(__data_width, __addr_width) \
  `GENERIC_REQRSP_REQ_STRUCT(`SNITCH_ACC_REQ_CHAN_STRUCT(__data_width, __addr_width))

`define SNITCH_ACC_RSP_STRUCT(__data_width) \
  `GENERIC_REQRSP_RSP_STRUCT(`SNITCH_ACC_RSP_CHAN_STRUCT(__data_width))

`define SNITCH_ACC_TYPEDEF_REQ_CHAN_T(__data_width, __addr_width) \
  typedef `SNITCH_ACC_REQ_CHAN_STRUCT(__data_width, __addr_width) acc_req_chan_t;

`define SNITCH_ACC_TYPEDEF_RSP_CHAN_T(__data_width) \
  typedef `SNITCH_ACC_RSP_CHAN_STRUCT(__data_width) acc_rsp_chan_t;

`define SNITCH_ACC_TYPEDEF_REQRSP_CHAN_ALL(__data_width, __addr_width) \
  `SNITCH_ACC_TYPEDEF_REQ_CHAN_T(__data_width, __addr_width) \
  `SNITCH_ACC_TYPEDEF_RSP_CHAN_T(__data_width)

`define SNITCH_ACC_TYPEDEF_ALL(__data_width, __addr_width) \
  `SNITCH_ACC_TYPEDEF_REQRSP_CHAN_ALL(__data_width, __addr_width) \
  `GENERIC_REQRSP_TYPEDEF_ALL(acc, acc_req_chan_t, acc_rsp_chan_t)

///////////////////////////
// Instruction interface //
///////////////////////////

`define SNITCH_INSTR_REQ_STRUCT(__addr_width) \
  struct packed {                             \
    logic [``__addr_width``-1:0] addr;        \
    logic                        cacheable;   \
    logic                        q_valid;     \
  }

`define SNITCH_INSTR_RSP_STRUCT \
  struct packed {               \
    logic [31:0] data;          \
    logic        error;         \
    logic        q_ready;       \
  }

`define SNITCH_INSTR_TYPEDEF_ALL(__addr_width) \
  typedef `SNITCH_INSTR_REQ_STRUCT(__addr_width) instr_req_t;
  typedef `SNITCH_INSTR_RSP_STRUCT instr_rsp_t;

//////////////////
// VM interface //
//////////////////

`define SNITCH_PA_STRUCT(__plen)                                                    \
  struct packed {                                                                   \
    logic [``__plen``-1:snitch_pkg::PageShift+snitch_pkg::VpnSize] ppn1;            \
    logic [snitch_pkg::PageShift+snitch_pkg::VpnSize-1:snitch_pkg::PageShift] ppn0; \
  }

`define SNITCH_L0_PTE_STRUCT(__plen) \
  struct packed {                    \
    `SNITCH_PA_STRUCT(__plen) pa;    \
    snitch_pkg::pte_flags_t   flags; \
  }

`define SNITCH_PTE_SV32_STRUCT(__plen) \
  struct packed {                      \
    `SNITCH_PA_STRUCT(__plen) pa;      \
    logic [9:8]               rsw;     \
    logic                     d;       \
    logic                     a;       \
    logic                     g;       \
    logic                     u;       \
    logic                     x;       \
    logic                     w;       \
    logic                     r;       \
    logic                     v;       \
  }

`define SNITCH_PTW_REQ_STRUCT(__plen) \
  struct packed {                     \
    logic                     valid;  \
    snitch_pkg::va_t          va;     \
    `SNITCH_PA_STRUCT(__plen) ppn;    \
  }

`define SNITCH_PTW_RSP_STRUCT(__plen)       \
  struct packed {                           \
    logic                         ready;    \
    `SNITCH_L0_PTE_STRUCT(__plen) pte;      \
    logic                         is_4mega; \
  }

`define SNITCH_TYPEDEF_PA_T(__plen) \
  typedef `SNITCH_PA_STRUCT(__plen) pa_t;

`define SNITCH_TYPEDEF_L0_PTE_T(__plen) \
  typedef `SNITCH_L0_PTE_STRUCT(__plen) l0_pte_t;

`define SNITCH_TYPEDEF_PTE_SV32_T(__plen) \
  typedef `SNITCH_PTE_SV32_STRUCT(__plen) pte_sv32_t;

`define SNITCH_TYPEDEF_PTW_REQ_T(__plen) \
  typedef `SNITCH_PTW_REQ_STRUCT(__plen) ptw_req_t;

`define SNITCH_TYPEDEF_PTW_RSP_T(__plen) \
  typedef `SNITCH_PTW_RSP_STRUCT(__plen) ptw_rsp_t;

`define SNITCH_VM_TYPEDEF_ALL(__plen) \
  `SNITCH_TYPEDEF_PA_T(__plen)        \
  `SNITCH_TYPEDEF_L0_PTE_T(__plen)    \
  `SNITCH_TYPEDEF_PTE_SV32_T(__plen)  \
  `SNITCH_TYPEDEF_PTW_REQ_T(__plen)   \
  `SNITCH_TYPEDEF_PTW_RSP_T(__plen)

`endif  // SNITCH_TYPEDEF_SVH_
