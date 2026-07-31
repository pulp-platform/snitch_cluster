// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"
`include "common_cells/assertions.svh"

/*
Module: reqrsp_demux
Demultiplex one `reqrsp`-like port onto multiple, based on an external index.

By default (`Ordered = 1`), responses are guaranteed to be returned to the single
upstream master in the same order requests were issued, regardless of which output
port each request targeted or how long each port takes to respond. This is implemented
with an `RspDepth`-deep FIFO recording, in issue order, which output port each accepted
request was routed to.

Setting `Ordered = 0` instead arbitrates responses from all master ports back to the
slave with no ordering guarantee (round-robin, whichever port responds first is
forwarded first). This mode is cheaper (no FIFO) and is kept only for callers that do
not need ordering and want to avoid its cost.

Parameters:
  NrPorts    - Number of output ports.
  req_chan_t - Request channel type.
  rsp_chan_t - Response channel type.
  Ordered    - Guarantee responses are returned in request order (default), or not.
  RspDepth   - Depth of the response-routing FIFO. Only used when `Ordered = 1`.

Ports:
  clk_i     - Clock.
  rst_ni    - Active-low reset.
  slv_req_i - Slave port, request from single master.
  slv_rsp_o - Slave port, response to single master.
  mst_req_o - Master ports, requests to all slaves.
  mst_rsp_i - Master ports, responses from all slaves.
  select_i  - Index selecting which master port to route the incoming request to.
*/
module reqrsp_demux #(
  parameter int unsigned NrPorts    = 2,
  parameter bit          Ordered    = 1'b1,
  parameter int unsigned RspDepth   = 8,
  parameter type         req_chan_t = logic,
  parameter type         rsp_chan_t = logic,
  // Dependent parameters
  localparam int unsigned IdxWidth = cc_pkg::idx_width(NrPorts),
  localparam type         req_t    = `REQRSP_REQ_STRUCT(req_chan_t),
  localparam type         rsp_t    = `REQRSP_RSP_STRUCT(rsp_chan_t)
) (
  input  logic                clk_i,
  input  logic                rst_ni,
  input  req_t                slv_req_i,
  output rsp_t                slv_rsp_o,
  output req_t [NrPorts-1:0]  mst_req_o,
  input  rsp_t [NrPorts-1:0]  mst_rsp_i,
  input  logic [IdxWidth-1:0] select_i
);

  if (Ordered) begin : gen_ordered

    logic [NrPorts-1:0] fwd;
    logic req_ready, req_valid;
    logic fifo_full, fifo_empty;
    logic [NrPorts-1:0] fifo_data;
    logic push_id_fifo, pop_id_fifo;

    // we need space in the return id fifo, silence if no space is available
    assign req_valid = ~fifo_full & slv_req_i.q_valid;
    assign slv_rsp_o.q_ready = ~fifo_full & req_ready;

    // Stream demux (unwrapped because of struct issues)
    always_comb begin
      for (int i = 0; i < NrPorts; i++) begin
        mst_req_o[i].q_valid = '0;
        mst_req_o[i].q = slv_req_i.q;
        mst_req_o[i].p_ready = fwd[i] ? slv_req_i.p_ready : 1'b0;
      end
      mst_req_o[select_i].q_valid = req_valid;
    end
    assign req_ready = mst_rsp_i[select_i].q_ready;

    assign push_id_fifo = req_valid & slv_rsp_o.q_ready;
    assign pop_id_fifo = slv_rsp_o.p_valid & slv_req_i.p_ready;

    for (genvar i = 0; i < NrPorts; i++) begin : gen_fifo_data
      assign fifo_data[i] = mst_rsp_i[i].q_ready & mst_req_o[i].q_valid;
    end

    // Remember selected master for correct forwarding of read data/acknowledge.
    cc_fifo #(
      .DataWidth ( NrPorts ),
      .Depth ( RspDepth )
    ) i_id_fifo (
      .clk_i,
      .rst_ni,
      .clr_i (1'b0),
      .flush_i (1'b0),
      .full_o (fifo_full),
      .empty_o (fifo_empty),
      .usage_o ( ),
      // Onehot mask.
      .data_i (fifo_data),
      .push_i (push_id_fifo),
      .data_o (fwd),
      .pop_i (pop_id_fifo)
    );

    // Response data routing.
    always_comb begin
      slv_rsp_o.p  = '0;
      slv_rsp_o.p_valid = '0;
      for (int i = 0; i < NrPorts; i++) begin
        if (fwd[i]) begin
          slv_rsp_o.p  = mst_rsp_i[i].p;
          slv_rsp_o.p_valid = mst_rsp_i[i].p_valid;
        end
      end
    end

    `ASSERT(SelectStable, slv_req_i.q_valid && !slv_rsp_o.q_ready |=> $stable(select_i))
    `ASSERT(SelectInBounds, slv_req_i.q_valid |-> (select_i <= NrPorts))

  end else begin : gen_unordered

    logic [NrPorts-1:0] mst_q_valid, mst_q_ready;
    logic [NrPorts-1:0] mst_p_valid, mst_p_ready;
    rsp_chan_t [NrPorts-1:0] mst_p_data;

    // Demux the request valid/ready handshake to the selected master port.
    cc_stream_demux #(
      .NumOup(NrPorts)
    ) i_stream_demux (
      .inp_valid_i(slv_req_i.q_valid),
      .inp_ready_o(slv_rsp_o.q_ready),
      .oup_sel_i  (select_i),
      .oup_valid_o(mst_q_valid),
      .oup_ready_i(mst_q_ready)
    );

    // Arbitrate responses from all master ports back to the slave.
    cc_stream_arbiter #(
      .data_t(rsp_chan_t),
      .NumInp(NrPorts)
    ) i_stream_arbiter (
      .clk_i,
      .rst_ni,
      .clr_i      (1'b0),
      .inp_data_i (mst_p_data),
      .inp_valid_i(mst_p_valid),
      .inp_ready_o(mst_p_ready),
      .oup_data_o (slv_rsp_o.p),
      .oup_valid_o(slv_rsp_o.p_valid),
      .oup_ready_i(slv_req_i.p_ready)
    );

    for (genvar i = 0; i < NrPorts; i++) begin : gen_port_connections
      assign mst_req_o[i].q_valid = mst_q_valid[i];
      assign mst_req_o[i].q       = slv_req_i.q;
      assign mst_q_ready[i]       = mst_rsp_i[i].q_ready;
      assign mst_req_o[i].p_ready = mst_p_ready[i];
      assign mst_p_valid[i]       = mst_rsp_i[i].p_valid;
      assign mst_p_data[i]        = mst_rsp_i[i].p;
    end

  end

endmodule
