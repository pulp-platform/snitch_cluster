// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi (xiaoling.yi@kuleuven.be)

// Accelerator wrapper
//-------------------------------
module snax_data_reshuffler_shell_wrapper #(
  parameter int unsigned RegRWCount   = 2,
  parameter int unsigned RegROCount   = 2,
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

    assign csr_reg_ro_set_o[0][31:1] = 0;

    Reshuffler data_reshuffler_i (
        .clock                      ( clk_i                    ),
        .reset                      ( ~rst_ni                  ),
        .io_data_input_i_bits       ( stream2acc_0_data_i      ),
        .io_data_input_i_valid      ( stream2acc_0_valid_i     ),
        .io_data_input_i_ready      ( stream2acc_0_ready_o     ),
        .io_data_output_o_bits      ( acc2stream_0_data_o      ),
        .io_data_output_o_valid     ( acc2stream_0_valid_o     ),
        .io_data_output_o_ready     ( acc2stream_0_ready_i     ),
        .io_ctrl_bits_0             ( csr_reg_set_i[0]         ),
        .io_ctrl_valid              ( csr_reg_set_valid_i      ),
        .io_ctrl_ready              ( csr_reg_set_ready_o      ),
        // ro rsc
        .io_busy_o                  ( csr_reg_ro_set_o[0][0]   ),
        .io_performance_counter     ( csr_reg_ro_set_o[1]      )
    );

endmodule
