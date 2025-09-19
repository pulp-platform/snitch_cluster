// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"

/// Multiplex multiple generic `reqrsp`-like ports onto one, based on arbitration.
module generic_reqrsp_mux #(
  /// Number of input ports.
  parameter int unsigned      NrPorts     = 2,
  /// Request channel type.
  parameter type              req_chan_t  = logic,
  /// Response channel type.
  parameter type              rsp_chan_t  = logic,
  /// Amount of outstanding responses. Determines the FIFO size.
  parameter int unsigned      RspDepth   = 8,
  /// Cut timing paths on the request path. Incurs a cycle additional latency.
  /// Registers are inserted at the slave side.
  parameter bit [NrPorts-1:0] RegisterReq = '0,
  /// Externally provide routing information for responses. Can be used when
  /// storing response routes externally, e.g. as a source tag passed along a
  /// pipeline, i.e. when RspDepth == 0.
  parameter bit               ExtRspRoute = 1'b0,
  /// Dependent parameters *do not override*
  /// Width of the arbitrated index.
  localparam int unsigned     IdxWidth    = cf_math_pkg::idx_width(NrPorts),
  localparam type             req_t       = `GENERIC_REQRSP_REQ_STRUCT(req_chan_t),
  localparam type             rsp_t       = `GENERIC_REQRSP_RSP_STRUCT(rsp_chan_t)
) (
  input  logic                clk_i,
  input  logic                rst_ni,
  input  req_t [NrPorts-1:0]  slv_req_i,
  output rsp_t [NrPorts-1:0]  slv_rsp_o,
  output req_t                mst_req_o,
  input  rsp_t                mst_rsp_i,
  // Route responses should follow when using external routing.
  input  logic [IdxWidth-1:0] rsp_route_i,
  // Request port select by the arbitration logic.
  output logic [IdxWidth-1:0] idx_o
);

  logic [NrPorts-1:0] req_valid_masked, req_ready_masked;
  logic [IdxWidth-1:0] idx, idx_rsp;
  logic full;

  req_chan_t [NrPorts-1:0] req_payload_q;
  logic [NrPorts-1:0] req_valid_q, req_ready_q;

  // Unforunately we need this signal otherwise the simulator complains about
  // multiple driven signals, because some other signals are driven from an
  // `always_comb` block.
  logic [NrPorts-1:0] slv_rsp_q_ready;

  // Optionally cut the incoming paths
  for (genvar i = 0; i < NrPorts; i++) begin : gen_cuts
    spill_register #(
      .T (req_chan_t),
      .Bypass (!RegisterReq[i])
    ) i_spill_register_req (
      .clk_i,
      .rst_ni,
      .valid_i (slv_req_i[i].q_valid),
      .ready_o (slv_rsp_q_ready[i]),
      .data_i (slv_req_i[i].q),
      .valid_o (req_valid_q[i]),
      .ready_i (req_ready_masked[i]),
      .data_o (req_payload_q[i])
    );
  end

  // We need to silence the handshake in case the fifo is full and we can't
  // accept more transactions.
  for (genvar i = 0; i < NrPorts; i++) begin : gen_req_valid_masked
    assign req_valid_masked[i] = req_valid_q[i] & ~full;
    assign req_ready_masked[i] = req_ready_q[i] & ~full;
  end

  /// Arbitrate requests
  rr_arb_tree #(
    .NumIn (NrPorts),
    .DataType (req_chan_t),
    .AxiVldRdy (1'b1),
    .LockIn (1'b1)
  ) i_q_mux (
    .clk_i,
    .rst_ni,
    .flush_i (1'b0),
    .rr_i  ('0),
    .req_i (req_valid_masked),
    .gnt_o (req_ready_q),
    .data_i (req_payload_q),
    .gnt_i (mst_rsp_i.q_ready),
    .req_o (mst_req_o.q_valid),
    .data_o (mst_req_o.q),
    .idx_o (idx_o)
  );

  // De-generate version does not need a fifo. We always know where to route
  // back the responses.
  if (NrPorts == 1) begin : gen_single_port
    assign idx_rsp = 0;
    assign full = 1'b0;
  end else begin : gen_multi_port
    if (ExtRspRoute) begin : gen_no_rsp_fifo
      // Alternatively select route based on externally provided information.
      assign idx_rsp = rsp_route_i;
      assign full = 1'b0;
    end else begin : gen_rsp_fifo
      // For the "normal" case we need to save the arbitration decision. We do so
      // by converting the handshake into a binary signal which we save for
      // response routing.
      onehot_to_bin #(
        .ONEHOT_WIDTH (NrPorts)
      ) i_onehot_to_bin (
        .onehot (req_valid_q & req_ready_q),
        .bin    (idx)
      );
      // Save the arbitration decision.
      fifo_v3 #(
        .DATA_WIDTH (IdxWidth),
        .DEPTH (RspDepth)
      ) i_rsp_fifo (
        .clk_i,
        .rst_ni,
        .flush_i (1'b0),
        .testmode_i (1'b0),
        .full_o (full),
        .empty_o (),
        .usage_o (),
        .data_i (idx),
        .push_i (mst_req_o.q_valid & mst_rsp_i.q_ready),
        .data_o (idx_rsp),
        .pop_i (mst_req_o.p_ready & mst_rsp_i.p_valid)
      );
    end
  end

  // Output Mux
  always_comb begin
    for (int i = 0; i < NrPorts; i++) begin
      slv_rsp_o[i].p_valid = '0;
      slv_rsp_o[i].q_ready = slv_rsp_q_ready[i];
      slv_rsp_o[i].p = mst_rsp_i.p;
    end
    slv_rsp_o[idx_rsp].p_valid = mst_rsp_i.p_valid;
  end

  assign mst_req_o.p_ready = slv_req_i[idx_rsp].p_ready;

endmodule
