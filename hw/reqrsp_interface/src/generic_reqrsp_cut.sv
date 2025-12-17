// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"

/// Cut all combinatorial paths through a generic `reqrsp`-like interface.
module generic_reqrsp_cut #(
    /// Request type.
    parameter type req_chan_t = logic,
    /// Response type.
    parameter type rsp_chan_t = logic,
    /// Bypass request channel.
    parameter bit  BypassReq  = 0,
    /// Bypass Response channel.
    parameter bit  BypassRsp  = 0,
    /// Derived parameters *do not override*
    localparam type req_t     = `GENERIC_REQRSP_REQ_STRUCT(req_chan_t),
    localparam type rsp_t     = `GENERIC_REQRSP_RSP_STRUCT(rsp_chan_t)
) (
    input  logic clk_i,
    input  logic rst_ni,
    input  req_t slv_req_i,
    output rsp_t slv_rsp_o,
    output req_t mst_req_o,
    input  rsp_t mst_rsp_i
);

  spill_register #(
    .T     (req_chan_t),
    .Bypass(BypassReq)
  ) i_spill_register_q (
    .clk_i,
    .rst_ni,
    .valid_i(slv_req_i.q_valid),
    .ready_o(slv_rsp_o.q_ready),
    .data_i (slv_req_i.q),
    .valid_o(mst_req_o.q_valid),
    .ready_i(mst_rsp_i.q_ready),
    .data_o (mst_req_o.q)
  );

  spill_register #(
    .T     (rsp_chan_t),
    .Bypass(BypassRsp)
  ) i_spill_register_p (
    .clk_i,
    .rst_ni,
    .valid_i(mst_rsp_i.p_valid),
    .ready_o(mst_req_o.p_ready),
    .data_i (mst_rsp_i.p),
    .valid_o(slv_rsp_o.p_valid),
    .ready_i(slv_req_i.p_ready),
    .data_o (slv_rsp_o.p)
  );

endmodule
