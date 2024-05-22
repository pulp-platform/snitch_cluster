// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi (xiaoling.yi@kuleuven.be)

// Accelerator wrapper
//-------------------------------
module snax_data_reshuffler_shell_wrapper #(
  parameter int unsigned RegRWCount   = 2,
  parameter int unsigned RegROCount   = 0,
  parameter int unsigned RegDataWidth = 32,
  parameter int unsigned RegAddrWidth = 32
)(
  //-------------------------------
  // Clocks and reset
  //-------------------------------
  input  logic clk_i,
  input  logic rst_ni,

  //-------------------------------
  // Accelerator ports
  //-------------------------------
  // Note, we maintained the form of these signals
  // just to comply with the top-level wrapper

  // Ports from accelerator to streamer
  output logic [(512)-1:0] acc2stream_0_data_o,
  output logic acc2stream_0_valid_o,
  input  logic acc2stream_0_ready_i,

  // Ports from streamer to accelerator
  input  logic [(512)-1:0] stream2acc_0_data_i,
  input  logic stream2acc_0_valid_i,
  output logic stream2acc_0_ready_o,

  //-------------------------------
  // CSR manager ports
  //-------------------------------
  input  logic [RegRWCount-1:0][RegDataWidth-1:0] csr_reg_set_i,
  input  logic                                    csr_reg_set_valid_i,
  output logic                                    csr_reg_set_ready_o,
  output logic [RegROCount-1:0][RegDataWidth-1:0] csr_reg_ro_set_o
);

  data_reshuffler data_reshuffler_i (
      .clk_i              ( clk_i                ),
      .rst_ni             ( rst_ni               ),
      .a_i                ( stream2acc_0_data_i  ),
      .a_valid_i          ( stream2acc_0_valid_i ),
      .a_ready_o          ( stream2acc_0_ready_o ),
      .z_o                ( acc2stream_0_data_o  ),
      .z_valid_o          ( acc2stream_0_valid_o ),
      .z_ready_i          ( acc2stream_0_ready_i ),
      .csr_en_transpose_i ( csr_reg_set_i[0]     ),
      .csr_valid          ( csr_reg_set_valid_i  ),
      .csr_ready          ( csr_reg_set_ready_o  )
  );

endmodule
