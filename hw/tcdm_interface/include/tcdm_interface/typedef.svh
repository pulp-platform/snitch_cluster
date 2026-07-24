// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Author: Fabian Schuiki <fschuiki@iis.ee.ethz.ch>

`ifndef TCDM_INTERFACE_TYPEDEF_SVH_
`define TCDM_INTERFACE_TYPEDEF_SVH_

`include "reqrsp_interface/typedef.svh"

`define TCDM_REQ_CHAN_STRUCT(__data_width, __addr_width, __user_width) \
  struct packed {                                                      \
    logic [``__addr_width``-1:0]   addr;                               \
    logic                          write;                              \
    snitch_pkg::amo_op_e           amo;                                \
    logic [``__data_width``-1:0]   data;                               \
    logic [``__data_width``/8-1:0] strb;                               \
    logic [``__user_width``-1:0]   user;                               \
  }

`define TCDM_RSP_CHAN_STRUCT(__data_width) \
  struct packed {                          \
    logic [``__data_width``-1:0] data;     \
  }

`define TCDM_REQ_STRUCT(__data_width, __addr_width, __user_width)            \
  struct packed {                                                            \
    `TCDM_REQ_CHAN_STRUCT(__data_width, __addr_width, __user_width) q;       \
    logic                                                           q_valid; \
  }

`define TCDM_RSP_STRUCT(__data_width) \
  `GENERIC_REQRSP_RSP_STRUCT(`TCDM_RSP_CHAN_STRUCT(__data_width))

`define TCDM_TYPEDEF_REQ_CHAN_T(__name, __data_width, __addr_width, __user_width) \
  typedef `TCDM_REQ_CHAN_STRUCT(__data_width, __addr_width, __user_width) __name``_req_chan_t;

`define TCDM_TYPEDEF_RSP_CHAN_T(__name, __data_width) \
  typedef `TCDM_RSP_CHAN_STRUCT(__data_width) __name``_rsp_chan_t;

`define TCDM_TYPEDEF_REQRSP_CHAN_ALL(__name, __data_width, __addr_width, __user_width) \
  `TCDM_TYPEDEF_REQ_CHAN_T(__name, __data_width, __addr_width, __user_width) \
  `TCDM_TYPEDEF_RSP_CHAN_T(__name, __data_width) \

`define TCDM_TYPEDEF_ALL(__name, __data_width, __addr_width, __user_width)           \
  `TCDM_TYPEDEF_REQRSP_CHAN_ALL(__name, __data_width, __addr_width, __user_width)    \
  typedef `TCDM_REQ_STRUCT(__data_width, __addr_width, __user_width) __name``_req_t; \
  `GENERIC_REQRSP_TYPEDEF_RSP_T(__name``_rsp_t, __name``_rsp_chan_t)

`endif  // TCDM_INTERFACE_TYPEDEF_SVH_
