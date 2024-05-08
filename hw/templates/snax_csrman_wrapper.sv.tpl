// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

module ${cfg["tag_name"]}_csrman_wrapper #(
  parameter int unsigned NumCsr = ${cfg["snax_acc_num_csr"]}
)(
  //-----------------------------
  // Clocks and reset
  //-----------------------------
  input  logic clk_i,
  input  logic rst_ni,

  //-----------------------------
  // CSR control ports
  //-----------------------------
  // Request
  input  logic [31:0] csr_req_data_i,
  input  logic [31:0] csr_req_addr_i,
  input  logic        csr_req_write_i,
  input  logic        csr_req_valid_i,
  output logic        csr_req_ready_o,

  // Response
  output logic [31:0] csr_rsp_data_o,
  input  logic        csr_rsp_ready_i,
  output logic        csr_rsp_valid_o,

  //-----------------------------
  // Packed CSR register signals
  //-----------------------------
  output logic [NumCsr-1:0][31:0] csr_reg_set_o,
  output logic                    csr_reg_set_valid_o,
  input  logic                    csr_reg_set_ready_i
);


  //-----------------------------
  // Chisel generated CSR manager
  //-----------------------------
  ${cfg["tag_name"]}CsrManager i_${cfg["tag_name"]}CsrManager (
    //-----------------------------
    // Clocks and reset
    //-----------------------------
    .clock  ( clk_i  ),
    .reset  ( rst_ni ),

    //-----------------------------
    // CSR ports
    //-----------------------------
    // Request ports
    .io_csr_config_in_req_bits_data   ( csr_req_data_i      ),
    .io_csr_config_in_req_bits_addr   ( csr_req_addr_i      ),
    .io_csr_config_in_req_bits_write  ( csr_req_write_i     ),
    .io_csr_config_in_req_valid       ( csr_req_valid_i     ),
    .io_csr_config_in_req_ready       ( csr_req_ready_o     ),

    // Response ports
    .io_csr_config_in_rsp_bits_data   ( csr_rsp_data_o      ),
    .io_csr_config_in_rsp_valid       ( csr_rsp_valid_o     ),
    .io_csr_config_in_rsp_ready       ( csr_rsp_ready_i     ),	

    //-----------------------------
    // CSR configurations
    //-----------------------------
% for i in range(cfg["snax_acc_num_csr"]):
    .io_csr_config_out_bits_${i}      ( csr_reg_set_o[${i}] ),
% endfor
    .io_csr_config_out_valid          ( csr_reg_set_valid_o ),
    .io_csr_config_out_ready          ( csr_reg_set_ready_i )

  );

endmodule
