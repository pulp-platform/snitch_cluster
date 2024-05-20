// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

//-------------------------------
// Simple ALU processing element
//-------------------------------
module snax_alu_pe #(
  parameter int unsigned DataWidth = 64
)(
  input  logic                   clk_i,
  input  logic                   rst_ni,
  input  logic [  DataWidth-1:0] a_i,
  input  logic                   a_valid_i,
  output logic                   a_ready_o,
  input  logic [  DataWidth-1:0] b_i,
  input  logic                   b_valid_i,
  output logic                   b_ready_o,
  output logic [2*DataWidth-1:0] c_o,
  output logic                   c_valid_o,
  input  logic                   c_ready_i,
  // Fix this to 2 bits only
  // Let's do 4 ALU operations for simplicity
  input  logic                   acc_ready_i,
  input  logic [            1:0] alu_config_i
);

  //-------------------------------
  // Local parameter
  //-------------------------------
  localparam int unsigned CsrAddrAdd = 0;
  localparam int unsigned CsrAddrSub = 1;
  localparam int unsigned CsrAddrMul = 2;
  localparam int unsigned CsrAddrXor = 3;

  //-------------------------------
  // Wires and combinational logic
  //-------------------------------
  logic [2*DataWidth-1:0] result_wide;

  logic input_success;

  logic result_success;
  logic result_valid;

  assign input_success  = (a_valid_i && a_ready_o) && (b_valid_i && b_ready_o);

  //-------------------------------
  // Registered output
  //-------------------------------
  always_comb begin
    case(alu_config_i)
      default: result_wide = a_i + b_i;
      CsrAddrSub: result_wide = a_i - b_i;
      CsrAddrMul: result_wide = a_i * b_i;
      CsrAddrXor: result_wide = a_i ^ b_i;
    endcase
  end
  //-------------------------------
  // Assignments
  //-------------------------------
  // Input ports are ready when the output ready
  // is also ready and when busy state is high
  assign a_ready_o = acc_ready_i && c_ready_i;
  assign b_ready_o = acc_ready_i && c_ready_i;
  assign c_valid_o = input_success;
  assign c_o       = result_wide;

endmodule
