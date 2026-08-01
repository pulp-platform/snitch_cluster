// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"
`include "lsu_interface/typedef.svh"
`include "tcdm_interface/typedef.svh"

/// Convert from the Snitch LSU interface to tcdm.
module lsu_to_tcdm #(
  parameter int unsigned BufDepth = 2,
  parameter int unsigned AddrWidth = 0,
  parameter int unsigned UserWidth = 0,
  parameter int unsigned DataWidth = 0,
  /// Derived parameters *do not override*
  localparam type lsu_req_t = `LSU_REQ_STRUCT(DataWidth, AddrWidth, UserWidth),
  localparam type lsu_rsp_t = `LSU_RSP_STRUCT(DataWidth),
  localparam type tcdm_req_t = `TCDM_REQ_STRUCT(DataWidth, AddrWidth, UserWidth),
  localparam type tcdm_rsp_t = `TCDM_RSP_STRUCT(DataWidth)
) (
  input  logic      clk_i,
  input  logic      rst_ni,
  input  lsu_req_t  lsu_req_i,
  output lsu_rsp_t  lsu_rsp_o,
  output tcdm_req_t tcdm_req_o,
  input  tcdm_rsp_t tcdm_rsp_i
);

  `LSU_TYPEDEF_REQRSP_CHAN_ALL(lsu, DataWidth, AddrWidth, UserWidth)

  lsu_req_chan_t req;
  lsu_rsp_chan_t rsp;

  cc_stream_to_mem #(
    .mem_req_t (lsu_req_chan_t),
    .mem_resp_t (lsu_rsp_chan_t),
    .BufDepth (BufDepth)
  ) i_stream_to_mem (
    .clk_i,
    .rst_ni,
    .clr_i (1'b0),
    .req_i (lsu_req_i.q),
    .req_valid_i (lsu_req_i.q_valid),
    .req_ready_o (lsu_rsp_o.q_ready),
    .resp_o (lsu_rsp_o.p),
    .resp_valid_o (lsu_rsp_o.p_valid),
    .resp_ready_i (lsu_req_i.p_ready),
    .mem_req_o (req),
    .mem_req_valid_o (tcdm_req_o.q_valid),
    .mem_req_ready_i (tcdm_rsp_i.q_ready),
    .mem_resp_i (rsp),
    .mem_resp_valid_i (tcdm_rsp_i.p_valid)
  );

  assign tcdm_req_o.q = '{
    addr: req.addr,
    write: req.write,
    amo: req.amo,
    data: req.data,
    strb: req.strb,
    user: req.user
  };

  assign rsp = '{
    data: tcdm_rsp_i.p.data,
    error: 1'b0
  };

endmodule
