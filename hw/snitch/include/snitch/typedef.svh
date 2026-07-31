// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`ifndef SNITCH_TYPEDEF_SVH_
`define SNITCH_TYPEDEF_SVH_

`include "reqrsp_interface/typedef.svh"

///////////////////
// LSU interface //
///////////////////

`define LSU_REQ_CHAN_STRUCT(__data_width, __addr_width, __user_width) \
  struct packed {                                                     \
    logic [``__addr_width``-1:0]   addr;                              \
    logic                          write;                             \
    snitch_pkg::amo_op_e           amo;                               \
    logic [``__data_width``-1:0]   data;                              \
    logic [``__data_width``/8-1:0] strb;                              \
    logic [``__user_width``-1:0]   user;                              \
    snitch_pkg::size_t             size;                              \
  }

`define LSU_RSP_CHAN_STRUCT(__data_width) \
  struct packed {                         \
    logic [``__data_width``-1:0] data;    \
    logic                        error;   \
  }

`define LSU_REQ_STRUCT(__data_width, __addr_width, __user_width) \
  `REQRSP_REQ_STRUCT(`LSU_REQ_CHAN_STRUCT(__data_width, __addr_width, __user_width))

`define LSU_RSP_STRUCT(__data_width) \
  `REQRSP_RSP_STRUCT(`LSU_RSP_CHAN_STRUCT(__data_width))

`define LSU_TYPEDEF_REQ_CHAN_T(__name, __data_width, __addr_width, __user_width) \
  typedef `LSU_REQ_CHAN_STRUCT(__data_width, __addr_width, __user_width) __name``_req_chan_t;

`define LSU_TYPEDEF_RSP_CHAN_T(__name, __data_width) \
  typedef `LSU_RSP_CHAN_STRUCT(__data_width) __name``_rsp_chan_t;

`define LSU_TYPEDEF_REQRSP_CHAN_ALL(__name, __data_width, __addr_width, __user_width) \
  `LSU_TYPEDEF_REQ_CHAN_T(__name, __data_width, __addr_width, __user_width) \
  `LSU_TYPEDEF_RSP_CHAN_T(__name, __data_width)

`define LSU_TYPEDEF_ALL(__name, __data_width, __addr_width, __user_width) \
  `LSU_TYPEDEF_REQRSP_CHAN_ALL(__name, __data_width, __addr_width, __user_width) \
  `REQRSP_TYPEDEF_ALL(__name, __name``_req_chan_t, __name``_rsp_chan_t)

`define LSU_ASSIGN_FROM_REQ(__lsu, __req)      \
  assign ``__lsu``.q_addr  = ``__req``.q.addr; \
  assign ``__lsu``.q_write = ``__req``.q.write; \
  assign ``__lsu``.q_amo   = ``__req``.q.amo;  \
  assign ``__lsu``.q_data  = ``__req``.q.data; \
  assign ``__lsu``.q_strb  = ``__req``.q.strb; \
  assign ``__lsu``.q_size  = ``__req``.q.size; \
  assign ``__lsu``.q_valid = ``__req``.q_valid; \
  assign ``__req``.p_ready = ``__lsu``.p_ready;

`define LSU_ASSIGN_TO_REQ(__req, __lsu)        \
  assign ``__req``.q.addr  = ``__lsu``.q_addr; \
  assign ``__req``.q.write = ``__lsu``.q_write; \
  assign ``__req``.q.amo   = ``__lsu``.q_amo;  \
  assign ``__req``.q.data  = ``__lsu``.q_data; \
  assign ``__req``.q.strb  = ``__lsu``.q_strb; \
  assign ``__req``.q.user  = '0;               \
  assign ``__req``.q.size  = ``__lsu``.q_size; \
  assign ``__req``.q_valid = ``__lsu``.q_valid; \
  assign ``__req``.p_ready = ``__lsu``.p_ready;

`define LSU_ASSIGN_FROM_RSP(__lsu, __rsp)       \
  assign ``__lsu``.q_ready = ``__rsp``.q_ready; \
  assign ``__lsu``.p_data  = ``__rsp``.p.data;  \
  assign ``__lsu``.p_error = ``__rsp``.p.error; \
  assign ``__lsu``.p_valid = ``__rsp``.p_valid;

`define LSU_ASSIGN_TO_RSP(__rsp, __lsu)          \
  assign ``__rsp``.q_ready = ``__lsu``.q_ready;  \
  assign ``__rsp``.p.data  = ``__lsu``.p_data;   \
  assign ``__rsp``.p.error = ``__lsu``.p_error;  \
  assign ``__rsp``.p_valid = ``__lsu``.p_valid;

`define LSU_ASSIGN(__slv, __mst)         \
  assign ``__slv``.q_addr  = ``__mst``.q_addr; \
  assign ``__slv``.q_write = ``__mst``.q_write; \
  assign ``__slv``.q_amo   = ``__mst``.q_amo; \
  assign ``__slv``.q_data  = ``__mst``.q_data; \
  assign ``__slv``.q_strb  = ``__mst``.q_strb; \
  assign ``__slv``.q_size  = ``__mst``.q_size; \
  assign ``__slv``.q_valid = ``__mst``.q_valid; \
  assign ``__mst``.q_ready = ``__slv``.q_ready; \
  assign ``__mst``.p_data  = ``__slv``.p_data; \
  assign ``__mst``.p_error = ``__slv``.p_error; \
  assign ``__mst``.p_valid = ``__slv``.p_valid; \
  assign ``__slv``.p_ready = ``__mst``.p_ready;

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
  `REQRSP_REQ_STRUCT(`SNITCH_ACC_REQ_CHAN_STRUCT(__data_width, __addr_width))

`define SNITCH_ACC_RSP_STRUCT(__data_width) \
  `REQRSP_RSP_STRUCT(`SNITCH_ACC_RSP_CHAN_STRUCT(__data_width))

`define SNITCH_ACC_TYPEDEF_REQ_CHAN_T(__data_width, __addr_width) \
  typedef `SNITCH_ACC_REQ_CHAN_STRUCT(__data_width, __addr_width) acc_req_chan_t;

`define SNITCH_ACC_TYPEDEF_RSP_CHAN_T(__data_width) \
  typedef `SNITCH_ACC_RSP_CHAN_STRUCT(__data_width) acc_rsp_chan_t;

`define SNITCH_ACC_TYPEDEF_REQRSP_CHAN_ALL(__data_width, __addr_width) \
  `SNITCH_ACC_TYPEDEF_REQ_CHAN_T(__data_width, __addr_width) \
  `SNITCH_ACC_TYPEDEF_RSP_CHAN_T(__data_width)

`define SNITCH_ACC_TYPEDEF_ALL(__data_width, __addr_width) \
  `SNITCH_ACC_TYPEDEF_REQRSP_CHAN_ALL(__data_width, __addr_width) \
  `REQRSP_TYPEDEF_ALL(acc, acc_req_chan_t, acc_rsp_chan_t)

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
