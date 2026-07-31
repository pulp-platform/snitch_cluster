// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Snitch LSU test interface.
///
/// This interface provides two channels, one for requests and one for
/// responses. Both channels have a valid/ready handshake. The master can
/// request a read or write on the `q` channel. The slave responds on the `p`
/// channel once the action has been completed.

// verilog_lint: waive interface-name-style
interface LSU_BUS #(
  /// The width of the address.
  parameter int ADDR_WIDTH = -1,
  /// The width of the data.
  parameter int DATA_WIDTH = -1
);

  import snitch_pkg::*;

  localparam int unsigned StrbWidth = DATA_WIDTH / 8;

  typedef logic [ADDR_WIDTH-1:0] addr_t;
  typedef logic [DATA_WIDTH-1:0] data_t;
  typedef logic [StrbWidth-1:0] strb_t;

  /// The request channel (Q).
  addr_t   q_addr;
  /// 0 = read, 1 = write, 1 = amo fetch-and-op
  logic    q_write;
  amo_op_e q_amo;
  data_t   q_data;
  /// Byte-wise strobe
  strb_t   q_strb;
  size_t   q_size;
  logic    q_valid;
  logic    q_ready;

  /// The response channel (P).
  data_t   p_data;
  /// 0 = ok, 1 = error
  logic    p_error;
  logic    p_valid;
  logic    p_ready;

  modport in  (
    input  q_addr, q_write, q_amo, q_size, q_data, q_strb, q_valid, p_ready,
    output q_ready, p_data, p_error, p_valid
  );
  modport out (
    output q_addr, q_write, q_amo, q_size, q_data, q_strb, q_valid, p_ready,
    input  q_ready, p_data, p_error, p_valid
  );

endinterface

// The DV interface additionally carries a clock signal.
// verilog_lint: waive interface-name-style
interface LSU_BUS_DV #(
  /// The width of the address.
  parameter int ADDR_WIDTH = -1,
  /// The width of the data.
  parameter int DATA_WIDTH = -1
) (
  input logic clk_i
);

  import snitch_pkg::*;

  localparam int unsigned StrbWidth = DATA_WIDTH / 8;

  typedef logic [ADDR_WIDTH-1:0] addr_t;
  typedef logic [DATA_WIDTH-1:0] data_t;
  typedef logic [StrbWidth-1:0] strb_t;

  /// The request channel (Q).
  addr_t   q_addr;
  /// 0 = read, 1 = write, 1 = amo fetch-and-op
  logic    q_write;
  amo_op_e q_amo;
  data_t   q_data;
  /// Byte-wise strobe
  strb_t   q_strb;
  size_t   q_size;
  logic    q_valid;
  logic    q_ready;

  /// The response channel (P).
  data_t   p_data;
  /// 0 = ok, 1 = error
  logic    p_error;
  logic    p_valid;
  logic    p_ready;

  modport in  (
    input  q_addr, q_write, q_amo, q_size, q_data, q_strb, q_valid, p_ready,
    output q_ready, p_data, p_error, p_valid
  );
  modport out (
    output q_addr, q_write, q_amo, q_size, q_data, q_strb, q_valid, p_ready,
    input  q_ready, p_data, p_error, p_valid
  );
  modport monitor (
    input q_addr, q_write, q_amo, q_size, q_data, q_strb, q_valid, p_ready,
          q_ready, p_data, p_error, p_valid
  );

  // pragma translate_off
  `ifndef VERILATOR
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> $stable(q_addr)));
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> $stable(q_write)));
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> $stable(q_amo)));
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> $stable(q_size)));
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> $stable(q_data)));
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> $stable(q_strb)));
  assert property (@(posedge clk_i) (q_valid && !q_ready |=> q_valid));

  assert property (@(posedge clk_i) (p_valid && !p_ready |=> $stable(p_data)));
  assert property (@(posedge clk_i) (p_valid && !p_ready |=> $stable(p_error)));
  assert property (@(posedge clk_i) (p_valid && !p_ready |=> p_valid));
  `endif
  // pragma translate_on

endinterface
