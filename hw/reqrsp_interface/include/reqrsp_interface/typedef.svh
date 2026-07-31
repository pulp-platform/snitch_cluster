// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`ifndef REQRSP_TYPEDEF_SVH_
`define REQRSP_TYPEDEF_SVH_

`define REQRSP_REQ_STRUCT(__req_chan_t) \
  struct packed {                               \
    __req_chan_t q;                             \
    logic        q_valid;                       \
    logic        p_ready;                       \
  }

`define REQRSP_RSP_STRUCT(__rsp_chan_t) \
  struct packed {                               \
    __rsp_chan_t p;                             \
    logic        p_valid;                       \
    logic        q_ready;                       \
  }

`define REQRSP_TYPEDEF_REQ_T(__req_t, __req_chan_t) \
  typedef `REQRSP_REQ_STRUCT(__req_chan_t) __req_t;

`define REQRSP_TYPEDEF_RSP_T(__rsp_t, __rsp_chan_t) \
  typedef `REQRSP_RSP_STRUCT(__rsp_chan_t) __rsp_t;

`define REQRSP_TYPEDEF_ALL(__name, __req_chan_t, __rsp_chan_t) \
  `REQRSP_TYPEDEF_REQ_T(__name``_req_t, __req_chan_t) \
  `REQRSP_TYPEDEF_RSP_T(__name``_rsp_t, __rsp_chan_t)

`endif
