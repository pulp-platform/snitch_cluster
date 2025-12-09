// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Shared Multiply/Divide a.k.a M Extension
/// Based on Ariane's Multiply Divide
/// Author: Michael Schaffner  <schaffner@iis.ee.ethz.ch>
/// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "common_cells/registers.svh"

module snitch_multiplier #(
  parameter int unsigned Width   = 64,
  parameter int unsigned IdWidth = 5
) (
  input  logic               clk_i,
  input  logic               rst_ni,
  input  logic [IdWidth-1:0] id_i,
  input  logic [       31:0] operator_i,
  input  logic [  Width-1:0] operand_a_i,
  input  logic [  Width-1:0] operand_b_i,
  input  logic               valid_i,
  output logic               ready_o,
  output logic [  Width-1:0] result_o,
  output logic               valid_o,
  input  logic               ready_i,
  output logic [IdWidth-1:0] id_o
);
  // Pipeline register
  logic [IdWidth-1:0] id_q;
  logic valid_d, valid_q;
  logic select_upper_q, select_upper_d;
  logic [2*Width-1:0] result_d, result_q;

  // control registers
  logic sign_a, sign_b;
  // control signals
  assign ready_o = ~valid_o | ready_i;
  // datapath
  logic [2*Width-1:0] mult_result;
  assign mult_result = $signed(
      {operand_a_i[Width-1] & sign_a, operand_a_i}
  ) * $signed(
      {operand_b_i[Width-1] & sign_b, operand_b_i}
  );
  // Sign Select MUX
  always_comb begin
    sign_a = 1'b0;
    sign_b = 1'b0;
    unique casez (operator_i)
      riscv_instr::MULH: begin
        sign_a = 1'b1;
        sign_b = 1'b1;
        select_upper_d = 1'b1;
      end
      riscv_instr::MULHU: begin
        select_upper_d = 1'b1;
      end
      riscv_instr::MULHSU: begin
        sign_a = 1'b1;
        select_upper_d = 1'b1;
      end
      // MUL performs an XLEN-bit × XLEN-bit multiplication and places the lower
      // XLEN bits in the destination register
      default: begin  // including MUL
        select_upper_d = 1'b0;
      end
    endcase
  end
  // single stage version
  assign result_d = $signed(
      {operand_a_i[Width-1] & sign_a, operand_a_i}
  ) * $signed(
      {operand_b_i[Width-1] & sign_b, operand_b_i}
  );
  // ressult mux
  always_comb begin
    result_o = result_q[Width-1:0];
    if (select_upper_q) begin
      result_o = result_q[2*Width-1:Width];
    end
  end

  always_comb begin
    valid_d = valid_q;
    if (valid_q & ready_i) valid_d = 0;
    if (valid_i & ready_o) valid_d = 1;
  end
  `FF(valid_q, valid_d, '0)
  // Pipe-line registers
  `FFL(id_q, id_i, (valid_i & ready_o), '0, clk_i, rst_ni)
  `FFL(result_q, result_d, (valid_i & ready_o), '0, clk_i, rst_ni)
  `FFL(select_upper_q, select_upper_d, (valid_i & ready_o), '0, clk_i, rst_ni)

  assign id_o = id_q;
  assign valid_o = valid_q;

endmodule
