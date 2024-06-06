// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Xiaoling Yi (xiaoling.yi@kuleuven.be)
//         Chao Fang (chao.fang@kuleuven.be)

//-------------------------------
// Data reshuffler that follows
// the valid-ready responses per port
//-------------------------------
module data_reshuffler #(
    parameter int unsigned SpatPar   = 8,
    parameter int unsigned DataWidth = 64,
    parameter int unsigned Elems     = DataWidth / SpatPar
) (
    input  logic                           clk_i,
    input  logic                           rst_ni,
    input  logic [(SpatPar*DataWidth)-1:0] a_i,
    input  logic                           a_valid_i,
    output logic                           a_ready_o,
    output logic [(SpatPar*DataWidth)-1:0] z_o,
    output logic                           z_valid_o,
    input  logic                           z_ready_i,
    // Fix this to 1 bits only
    // Let's check if transpose is enabled
    input  logic [                   31:0] csr_en_transpose_i,
    input  logic                           csr_valid,
    output logic                           csr_ready
);

  //-------------------------------
  // Wires and registers
  //-------------------------------
  logic [SpatPar-1:0][SpatPar-1:0][Elems-1:0] a_split;
  logic [SpatPar-1:0][SpatPar-1:0][Elems-1:0] z_split;
  logic [(SpatPar*DataWidth)-1:0] z_wide_tmp;

  logic a_success;
  logic z_success;

  // Store the configuration
  logic [31:0] transpose;

  //-------------------------------
  // Combinational logic
  //-------------------------------

  assign a_success = a_valid_i && a_ready_o;
  assign z_success = z_valid_o && z_ready_i;

  // Always ready CSR
  assign csr_ready = 1;

  // Combinational logic to transpose data
  for (genvar i = 0; i < SpatPar; i++) begin: gen_outer_loop
    for (genvar j = 0; j < SpatPar; j++) begin: gen_inner_loop
      assign a_split[i][j] = a_i[(i*SpatPar+j)*Elems+:Elems];
      // Transpose the data
      assign z_split[i][j] = a_split[j][i];
      assign z_wide_tmp[(i*SpatPar+j)*Elems+:Elems] = (transpose) ? z_split[i][j] : a_split[i][j];
    end
  end

  //-------------------------------
  // Registered signals
  //-------------------------------

  // Saving transpose state
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      transpose <= 0;
    end else begin
      if (csr_valid && csr_ready) begin
        transpose <= csr_en_transpose_i;
      end
    end
  end

  // Output control
  always_ff @(posedge clk_i or negedge rst_ni) begin

    if (!rst_ni) begin
      z_o       <= {(SpatPar * DataWidth) {1'b0}};
      z_valid_o <= 1'b0;
    end else begin

      // Output correctly if output is ready to
      // acess data, otherwise don't take it
      if (z_ready_i && a_success) begin
        z_o       <= z_wide_tmp;
        z_valid_o <= 1'b1;

      // If output is success and no new inputs
      // clear the output
      end else if (z_success) begin
        z_o       <= {(SpatPar * DataWidth) {1'b0}};
        z_valid_o <= 1'b0;

      // Retain state if nothing else happens
      end else begin
        z_o       <= z_o;
        z_valid_o <= z_valid_o;
      end
    end

  end
  assign a_ready_o = z_ready_i;

endmodule
