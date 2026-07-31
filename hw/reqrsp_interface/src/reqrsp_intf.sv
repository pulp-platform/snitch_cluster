// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>

/// A simple two-channel req/rsp interface.
///
/// This interface provides two channels, one for requests and one for
/// responses. Both channels have a valid/ready handshake. The sender sets the
/// channel signals and pulls valid high. Once pulled high, valid must remain
/// high and none of the signals may change. The transaction completes when both
/// valid and ready are high. Valid must not depend on ready. The master sends
/// an opaque request payload on the `q` channel. The slave responds with an
/// opaque response payload on the `p` channel. Every request returns a response.

// verilog_lint: waive interface-name-style
interface REQRSP_BUS_DV #(
  parameter type req_chan_t = logic,
  parameter type rsp_chan_t = logic
) (
  input logic clk_i
);

  req_chan_t q;
  logic      q_valid;
  logic      q_ready;

  rsp_chan_t p;
  logic      p_valid;
  logic      p_ready;

  modport in (
    input  q, q_valid, p_ready,
    output q_ready, p, p_valid
  );
  modport out (
    output q, q_valid, p_ready,
    input  q_ready, p, p_valid
  );
  modport monitor (
    input q, q_valid, q_ready, p, p_valid, p_ready
  );

  // pragma translate_off
  `ifndef VERILATOR
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> $stable(q)));
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> q_valid));

  assert property (@(posedge clk_i) (p_valid && !p_ready |=> $stable(p)));
  assert property (@(posedge clk_i) (p_valid && !p_ready |=> p_valid));
  `endif
  // pragma translate_on

endinterface
