// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`ifndef FPU_INTERFACE_TYPEDEF_SVH_
`define FPU_INTERFACE_TYPEDEF_SVH_

`include "reqrsp_interface/typedef.svh"

`define FPU_REQ_CHAN_STRUCT(__data_width, __tag_t) \
  struct packed {                                  \
    logic [2:0][__data_width-1:0] operands;        \
    fpnew_pkg::roundmode_e        rnd_mode;        \
    fpnew_pkg::operation_e        op;              \
    logic                         op_mod;          \
    fpnew_pkg::fp_format_e        src_fmt;         \
    fpnew_pkg::fp_format_e        dst_fmt;         \
    fpnew_pkg::int_format_e       int_fmt;         \
    logic                         vectorial_op;    \
    __tag_t                       tag;             \
  }

`define FPU_RSP_CHAN_STRUCT(__data_width, __tag_t) \
  struct packed {                                  \
    fpnew_pkg::status_t      status;               \
    logic [__data_width-1:0] result;               \
    __tag_t                  tag;                  \
  }

`define FPU_REQ_STRUCT(__data_width, __tag_t) \
  `GENERIC_REQRSP_REQ_STRUCT(`FPU_REQ_CHAN_STRUCT(__data_width, __tag_t))

`define FPU_RSP_STRUCT(__data_width, __tag_t) \
  `GENERIC_REQRSP_RSP_STRUCT(`FPU_RSP_CHAN_STRUCT(__data_width, __tag_t))

`define FPU_TYPEDEF_REQ_CHAN_T(__name, __data_width, __tag_t) \
  typedef `FPU_REQ_CHAN_STRUCT(__data_width, __tag_t) __name``_req_chan_t;

`define FPU_TYPEDEF_RSP_CHAN_T(__name, __data_width, __tag_t) \
  typedef `FPU_RSP_CHAN_STRUCT(__data_width, __tag_t) __name``_rsp_chan_t;

`define FPU_TYPEDEF_REQRSP_CHAN_ALL(__name, __data_width, __tag_t) \
  `FPU_TYPEDEF_REQ_CHAN_T(__name, __data_width, __tag_t)           \
  `FPU_TYPEDEF_RSP_CHAN_T(__name, __data_width, __tag_t)

`define FPU_TYPEDEF_REQRSP_ALL(__name, __data_width, __tag_t) \
  `FPU_TYPEDEF_REQRSP_CHAN_ALL(__name, __data_width, __tag_t) \
  `GENERIC_REQRSP_TYPEDEF_ALL(__name, __name``_req_chan_t, __name``_rsp_chan_t)

`endif // FPU_INTERFACE_TYPEDEF_SVH_
