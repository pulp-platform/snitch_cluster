// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "snitch/typedef.svh"

/// Combinational LSU interface width converter.
///
/// Narrower outputs keep the least-significant bits. Wider outputs are padded
/// with zeros.
module lsu_width_converter #(
  parameter int unsigned InAddrWidth  = 0,
  parameter int unsigned InDataWidth  = 0,
  parameter int unsigned InUserWidth  = 0,
  parameter int unsigned OutAddrWidth = 0,
  parameter int unsigned OutDataWidth = 0,
  parameter int unsigned OutUserWidth = 0,
  /// Derived parameter *Do not override*
  localparam type in_req_t  = `LSU_REQ_STRUCT(InDataWidth, InAddrWidth, InUserWidth),
  localparam type in_rsp_t  = `LSU_RSP_STRUCT(InDataWidth),
  localparam type out_req_t = `LSU_REQ_STRUCT(OutDataWidth, OutAddrWidth, OutUserWidth),
  localparam type out_rsp_t = `LSU_RSP_STRUCT(OutDataWidth)
) (
  input  in_req_t  lsu_req_i,
  output in_rsp_t  lsu_rsp_o,
  output out_req_t lsu_req_o,
  input  out_rsp_t lsu_rsp_i
);

  always_comb begin
    lsu_req_o.q.addr  = lsu_req_i.q.addr;
    lsu_req_o.q.write = lsu_req_i.q.write;
    lsu_req_o.q.amo   = lsu_req_i.q.amo;
    lsu_req_o.q.data  = lsu_req_i.q.data;
    lsu_req_o.q.strb  = lsu_req_i.q.strb;
    lsu_req_o.q.user  = lsu_req_i.q.user;
    lsu_req_o.q.size  = lsu_req_i.q.size;
    lsu_req_o.q_valid = lsu_req_i.q_valid;
    lsu_req_o.p_ready = lsu_req_i.p_ready;

    lsu_rsp_o.p.data  = lsu_rsp_i.p.data;
    lsu_rsp_o.p.error = lsu_rsp_i.p.error;
    lsu_rsp_o.p_valid = lsu_rsp_i.p_valid;
    lsu_rsp_o.q_ready = lsu_rsp_i.q_ready;
  end

endmodule
