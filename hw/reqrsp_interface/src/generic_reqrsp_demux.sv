// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"

/*
Module: generic_reqrsp_demux
Demultiplex one generic `reqrsp`-like port onto multiple, based on an external index.
Ordering of responses is not guaranteed to match request ordering.

Parameters:
  NrPorts    - Number of output ports.
  req_chan_t - Request channel type.
  rsp_chan_t - Response channel type.

Ports:
  clk_i     - Clock.
  rst_ni    - Active-low reset.
  slv_req_i - Slave port, request from single master.
  slv_rsp_o - Slave port, response to single master.
  mst_req_o - Master ports, requests to all slaves.
  mst_rsp_i - Master ports, responses from all slaves.
  idx_i     - Index selecting which master port to route the incoming request to.
*/
module generic_reqrsp_demux #(
  parameter int unsigned NrPorts    = 2,
  parameter type         req_chan_t = logic,
  parameter type         rsp_chan_t = logic,
  // Dependent parameters
  localparam int unsigned IdxWidth = cf_math_pkg::idx_width(NrPorts),
  localparam type         req_t    = `GENERIC_REQRSP_REQ_STRUCT(req_chan_t),
  localparam type         rsp_t    = `GENERIC_REQRSP_RSP_STRUCT(rsp_chan_t)
) (
  input  logic                clk_i,
  input  logic                rst_ni,
  input  req_t                slv_req_i,
  output rsp_t                slv_rsp_o,
  output req_t [NrPorts-1:0]  mst_req_o,
  input  rsp_t [NrPorts-1:0]  mst_rsp_i,
  input  logic [IdxWidth-1:0] idx_i
);

  logic [NrPorts-1:0] mst_q_valid, mst_q_ready;
  logic [NrPorts-1:0] mst_p_valid, mst_p_ready;
  rsp_chan_t [NrPorts-1:0] mst_p_data;

  // Demux the request valid/ready handshake to the selected master port.
  stream_demux #(
    .N_OUP(NrPorts)
  ) i_stream_demux (
    .inp_valid_i(slv_req_i.q_valid),
    .inp_ready_o(slv_rsp_o.q_ready),
    .oup_sel_i  (idx_i),
    .oup_valid_o(mst_q_valid),
    .oup_ready_i(mst_q_ready)
  );

  // Arbitrate responses from all master ports back to the slave.
  stream_arbiter #(
    .DATA_T(rsp_chan_t),
    .N_INP (NrPorts)
  ) i_stream_arbiter (
    .clk_i,
    .rst_ni,
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

endmodule
