// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Lucia Luzi <luzil@student.ethz.ch>
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>

module snitch_shuffle_unit #(
  parameter bit          XFVEC  = 0,
  parameter int unsigned FLEN   = 0
) (
  input logic                               clk_i,
  input logic                               rst_ni,
  // Input signals
  input logic [2:0][FLEN-1:0]               operands_i,
  input logic                               op_mod_i,
  input fpnew_pkg::fp_format_e              src_fmt_i,
  input fpnew_pkg::fp_format_e              dst_fmt_i,
  input logic [6:0]                         tag_i,
  // Input Handshake
  input  logic                              in_valid_i,
  output logic                              in_ready_o,
  // Output signals
  output logic [FLEN-1:0]                   result_o,
  output logic [6:0]                        tag_o,
  // Output handshake
  output logic                              out_valid_o,
  input  logic                              out_ready_i
);

  // ----------------------
  // Mask
  // ----------------------

  logic [FLEN/8:0]                 vec_mask;
  logic [FLEN/8:0][2:0]            element_mask;

  for (genvar i = 0; i < FLEN/8; i++) begin
    assign vec_mask[i] = operands_i[1][(i*4)+3];
    assign element_mask[i] = operands_i[1][(i*4) +: 3];
  end

  // ----------------------
  // Shuffle Unit
  // ----------------------

  logic [FLEN-1:0] result_f32, result_f16, result_f8;

  assign in_ready_o = out_ready_i;
  assign tag_o = tag_i;

  if (XFVEC && FLEN >= 64) begin : gen_64
    logic [FLEN/32-1:0][31:0] op1_vec_f32, op2_vec_f32, op1_vec_sel_f32, op2_vec_sel_f32;
    assign op1_vec_f32 = operands_i[0];
    assign op2_vec_f32 = operands_i[2];
    for (genvar i = 0; i < FLEN/32; i++) begin : gen_vec_sel
      assign op1_vec_sel_f32[i] = op1_vec_f32[element_mask[i]];
      assign op2_vec_sel_f32[i] = op2_vec_f32[element_mask[i]];
      assign result_f32[(i*32) +: 32] = (vec_mask[i] & op_mod_i) ? op2_vec_sel_f32[i] : op1_vec_sel_f32[i];
    end
  end else begin
    assign result_f32 = '0;
  end
  if (XFVEC && FLEN >= 32) begin : gen_32
    logic [FLEN/16-1:0][15:0] op1_vec_f16, op2_vec_f16, op1_vec_sel_f16, op2_vec_sel_f16;
    assign op1_vec_f16 = operands_i[0];
    assign op2_vec_f16 = operands_i[2];
    for (genvar i = 0; i < FLEN/16; i++) begin : gen_vec_sel
      assign op1_vec_sel_f16[i] = op1_vec_f16[element_mask[i]];
      assign op2_vec_sel_f16[i] = op2_vec_f16[element_mask[i]];
      assign result_f16[(i*16) +: 16] = (vec_mask[i] & op_mod_i) ? op2_vec_sel_f16[i] : op1_vec_sel_f16[i];
    end
  end else begin
    assign result_f16 = '0;
  end
  if (XFVEC && FLEN >= 16) begin : gen_16
    logic [FLEN/8-1:0][7:0] op1_vec_f8, op2_vec_f8, op1_vec_sel_f8, op2_vec_sel_f8;
    assign op1_vec_f8 = operands_i[0];
    assign op2_vec_f8 = operands_i[2];
    for (genvar i = 0; i < FLEN/8; i++) begin : gen_vec_sel
      assign op1_vec_sel_f8[i] = op1_vec_f8[element_mask[i]];
      assign op2_vec_sel_f8[i] = op2_vec_f8[element_mask[i]];
      assign result_f8[(i*8) +: 8] = (vec_mask[i] & op_mod_i) ? op2_vec_sel_f8[i] : op1_vec_sel_f8[i];
    end
  end else begin
    assign result_f8 = '0;
  end


  always_comb begin
    result_o = '0;
    out_valid_o = in_valid_i;
    if (in_valid_i & out_ready_i) begin
      unique case (src_fmt_i)
        fpnew_pkg::FP32: begin
          result_o = result_f32;
        end
        fpnew_pkg::FP16,
        fpnew_pkg::FP16ALT: begin
          result_o = result_f16;
        end
        fpnew_pkg::FP8,
        fpnew_pkg::FP8ALT: begin
          result_o = result_f8;
        end
        default:;
      endcase
      out_valid_o = 1'b1;
    end
  end

endmodule
