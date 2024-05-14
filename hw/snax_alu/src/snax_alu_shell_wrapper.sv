// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

//-------------------------------
// Accelerator wrapper
//-------------------------------
module snax_alu_shell_wrapper #(
  // Custom parameters. As much as possible,
  // these parameters should not be taken from outside
  parameter int unsigned RegRWCount   = 3,
  parameter int unsigned RegROCount   = 2,
  parameter int unsigned NumPE        = 4,
  parameter int unsigned DataWidth    = 64,
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
  output logic [(NumPE*DataWidth*2)-1:0] acc2stream_0_data_o,
  output logic acc2stream_0_valid_o,
  input  logic acc2stream_0_ready_i,

  // Ports from streamer to accelerator
  input  logic [(NumPE*DataWidth)-1:0] stream2acc_0_data_i,
  input  logic stream2acc_0_valid_i,
  output logic stream2acc_0_ready_o,

  input  logic [(NumPE*DataWidth)-1:0] stream2acc_1_data_i,
  input  logic stream2acc_1_valid_i,
  output logic stream2acc_1_ready_o,

  //-------------------------------
  // CSR manager ports
  //-------------------------------
  input  logic [RegRWCount-1:0][RegDataWidth-1:0] csr_reg_set_i,
  input  logic                                    csr_reg_set_valid_i,
  output logic                                    csr_reg_set_ready_o,
  output logic [RegROCount-1:0][RegDataWidth-1:0] csr_reg_ro_set_o
);

  //-------------------------------
  // Wires
  //-------------------------------

  // Wiring for accelerator ports
  logic [NumPE-1:0][DataWidth-1  :0] a_split;
  logic [NumPE-1:0][DataWidth-1  :0] b_split;
  logic [NumPE-1:0][DataWidth*2-1:0] c_split;

  logic [NumPE-1:0] a_ready;
  logic [NumPE-1:0] b_ready;
  logic [NumPE-1:0] result_valid;

  // Control signals
  logic       acc_output_success;
  logic       acc_ready;
  logic [1:0] csr_alu_config;

  // Read only signals towards CSR manager
  logic [RegROCount-1:0][RegDataWidth-1:0] csr_reg_ro_set;

  //-------------------------------
  // Re-mapping
  //-------------------------------

  // Re-mapping for configuration registers
  // This is doing some SystemVerilog part slicing!
  always_comb begin
    for (int i = 0; i < NumPE; i++) begin
      // De-concatanating the input signals
      a_split[i] = stream2acc_0_data_i[i*DataWidth+:DataWidth];
      b_split[i] = stream2acc_1_data_i[i*DataWidth+:DataWidth];

      // Concatenating the output signals
      acc2stream_0_data_o[i*DataWidth+:DataWidth] = c_split[i];
    end

    // Inputs are read when all ready signals are ready
    // Output valid is valid only when all outputs are valid
    stream2acc_0_ready_o = &a_ready;
    stream2acc_1_ready_o = &b_ready;
    acc2stream_0_valid_o = &result_valid;
  end

  //-------------------------------
  // Combinational logic
  //-------------------------------
  assign acc_output_success = acc2stream_0_valid_o && acc2stream_0_ready_i;

  //-------------------------------
  // CSR Manager
  //-------------------------------
  snax_alu_csr #(
    .RegDataWidth         ( RegDataWidth        )
  ) i_simple_alu_csr (
    //-------------------------------
    // Clocks and reset
    //-------------------------------
    .clk_i                ( clk_i               ),
    .rst_ni               ( rst_ni              ),
    //-------------------------------
    // Register config inputs from CSR manager
    //-------------------------------
    .csr_reg_set_i        ( csr_reg_set_i       ),
    .csr_reg_set_valid_i  ( csr_reg_set_valid_i ),
    .csr_reg_set_ready_o  ( csr_reg_set_ready_o ),
    //-------------------------------
    // Register config inputs from CSR manager
    //-------------------------------
    .csr_reg_ro_set_o     ( csr_reg_ro_set_o    ),
    //-------------------------------
    // Direct register control signals
    //-------------------------------
    .acc_output_success_i ( acc_output_success  ),
    .acc_ready_o          ( acc_ready           ),
    .csr_alu_config_o     ( csr_alu_config      )
  );

  //-------------------------------
  // Generate parallel arrays
  //-------------------------------
  for (genvar i = 0; i < NumPE; i ++) begin: gen_muls
    snax_alu_pe #(
      .DataWidth      ( DataWidth            )
    ) i_snax_alu_pe (
      .clk_i          ( clk_i                ),
      .rst_ni         ( rst_ni               ),
      .a_i            ( a_split[i]           ),
      .a_valid_i      ( stream2acc_0_valid_i ),
      .a_ready_o      ( a_ready[i]           ),
      .b_i            ( b_split[i]           ),
      .b_valid_i      ( stream2acc_1_valid_i ),
      .b_ready_o      ( b_ready[i]           ),
      .c_o            ( c_split[i]           ),
      .c_valid_o      ( result_valid[i]      ),
      .c_ready_i      ( acc2stream_0_ready_i ),
      .acc_ready_i    ( acc_ready            ),
      .alu_config_i   ( csr_alu_config       )
    );
  end


endmodule
