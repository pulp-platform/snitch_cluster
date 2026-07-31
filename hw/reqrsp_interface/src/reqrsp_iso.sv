// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"

/// Decouple `src` and `dst` side of a `reqrsp`-like interface using an
/// isochronous clock-domain crossing. See
/// `common_cells/isochronous_spill_register` for further detail on the clock
/// requirements.
module reqrsp_iso #(
    /// Request channel type.
    parameter type req_chan_t = logic,
    /// Response channel type.
    parameter type rsp_chan_t = logic,
    /// Bypass request channel.
    parameter bit  BypassReq  = 0,
    /// Bypass response channel.
    parameter bit  BypassRsp  = 0,
    /// Derived parameters *do not override*
    localparam type req_t     = `REQRSP_REQ_STRUCT(req_chan_t),
    localparam type rsp_t     = `REQRSP_RSP_STRUCT(rsp_chan_t)
) (
    /// Clock of source clock domain.
    input  logic src_clk_i,
    /// Active low async reset in source domain.
    input  logic src_rst_ni,
    /// Source request data.
    input  req_t src_req_i,
    /// Source response data.
    output rsp_t src_rsp_o,
    /// Clock of destination clock domain.
    input  logic dst_clk_i,
    /// Active low async reset in destination domain.
    input  logic dst_rst_ni,
    /// Destination request data.
    output req_t dst_req_o,
    /// Destination response data.
    input  rsp_t dst_rsp_i
);

  cc_isochronous_spill_register #(
    .data_t (req_chan_t),
    .Bypass (BypassReq)
  ) i_isochronous_spill_register_q (
    .src_clk_i (src_clk_i),
    .src_rst_ni (src_rst_ni),
    .src_valid_i (src_req_i.q_valid) ,
    .src_ready_o (src_rsp_o.q_ready) ,
    .src_data_i (src_req_i.q),
    .dst_clk_i (dst_clk_i),
    .dst_rst_ni (dst_rst_ni),
    .dst_valid_o (dst_req_o.q_valid),
    .dst_ready_i (dst_rsp_i.q_ready),
    .dst_data_o (dst_req_o.q)
  );

  cc_isochronous_spill_register #(
    .data_t (rsp_chan_t),
    .Bypass (BypassRsp)
  ) i_isochronous_spill_register_p (
    .src_clk_i (dst_clk_i),
    .src_rst_ni (dst_rst_ni),
    .src_valid_i (dst_rsp_i.p_valid) ,
    .src_ready_o (dst_req_o.p_ready) ,
    .src_data_i (dst_rsp_i.p),
    .dst_clk_i (src_clk_i),
    .dst_rst_ni (src_rst_ni),
    .dst_valid_o (src_rsp_o.p_valid),
    .dst_ready_i (src_req_i.p_ready),
    .dst_data_o (src_rsp_o.p)
  );

endmodule
