// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "tcdm_interface/typedef.svh"

/// Combinational TCDM interface width converter.
///
/// Narrower outputs keep the least-significant bits. Wider outputs are padded
/// with zeros.
module tcdm_width_converter #(
  parameter int unsigned InAddrWidth  = 0,
  parameter int unsigned InDataWidth  = 0,
  parameter int unsigned InUserWidth  = 0,
  parameter int unsigned OutAddrWidth = 0,
  parameter int unsigned OutDataWidth = 0,
  parameter int unsigned OutUserWidth = 0,
  /// Derived parameter *Do not override*
  localparam type in_req_t  = `TCDM_REQ_STRUCT(InDataWidth, InAddrWidth, InUserWidth),
  localparam type in_rsp_t  = `TCDM_RSP_STRUCT(InDataWidth),
  localparam type out_req_t = `TCDM_REQ_STRUCT(OutDataWidth, OutAddrWidth, OutUserWidth),
  localparam type out_rsp_t = `TCDM_RSP_STRUCT(OutDataWidth)
) (
  input  in_req_t  tcdm_req_i,
  output in_rsp_t  tcdm_rsp_o,
  output out_req_t tcdm_req_o,
  input  out_rsp_t tcdm_rsp_i
);

  always_comb begin
    tcdm_req_o.q.addr  = tcdm_req_i.q.addr;
    tcdm_req_o.q.write = tcdm_req_i.q.write;
    tcdm_req_o.q.amo   = tcdm_req_i.q.amo;
    tcdm_req_o.q.data  = tcdm_req_i.q.data;
    tcdm_req_o.q.strb  = tcdm_req_i.q.strb;
    tcdm_req_o.q.user  = tcdm_req_i.q.user;
    tcdm_req_o.q_valid = tcdm_req_i.q_valid;

    tcdm_rsp_o.p.data  = tcdm_rsp_i.p.data;
    tcdm_rsp_o.p_valid = tcdm_rsp_i.p_valid;
    tcdm_rsp_o.q_ready = tcdm_rsp_i.q_ready;
  end

endmodule
