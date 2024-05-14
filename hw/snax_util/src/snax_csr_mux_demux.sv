// Copyright 2020 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

//-------------------------------
// CSR MUX and DEMUX control
// Fully combinational connections
//-------------------------------
module snax_csr_mux_demux #(
  parameter int unsigned AddrSelOffSet = 8,
  parameter int unsigned RegDataWidth  = 32,
  parameter int unsigned RegAddrWidth  = 32
)(
  //-------------------------------
  // Input Core
  //-------------------------------
  input  logic [RegAddrWidth-1:0] csr_req_addr_i,
  input  logic [RegDataWidth-1:0] csr_req_data_i,
  input  logic                    csr_req_wen_i,
  input  logic                    csr_req_valid_i,
  output logic                    csr_req_ready_o,
  output logic [RegDataWidth-1:0] csr_rsp_data_o,
  output logic                    csr_rsp_valid_o,
  input  logic                    csr_rsp_ready_i,
  //-------------------------------
  // Output Port
  //-------------------------------
  output logic [1:0][RegAddrWidth-1:0] acc_csr_req_addr_o,
  output logic [1:0][RegDataWidth-1:0] acc_csr_req_data_o,
  output logic [1:0][0:0]              acc_csr_req_wen_o,
  output logic [1:0][0:0]              acc_csr_req_valid_o,
  input  logic [1:0][0:0]              acc_csr_req_ready_i,
  input  logic [1:0][RegDataWidth-1:0] acc_csr_rsp_data_i,
  input  logic [1:0][0:0]              acc_csr_rsp_valid_i,
  output logic [1:0][0:0]              acc_csr_rsp_ready_o
);

  //-------------------------------
  // Ports take priority over [0] - for datapath connection
  // For simplicity the upper [1] - for streamer conenction
  //-------------------------------
  logic sel_output;
  assign sel_output = (csr_req_addr_i >= AddrSelOffSet);

  logic [RegAddrWidth-1:0] csr_addr_offset;
  assign csr_addr_offset = csr_req_addr_i - AddrSelOffSet;

  //-------------------------------
  // Demuxing happens from core to accelerators.
  // The signals are set to 0 if they are unused
  //-------------------------------
  always_comb begin
    // First port
    acc_csr_req_addr_o [0] = ( sel_output ) ? '0 : csr_req_addr_i;
    acc_csr_req_data_o [0] = ( sel_output ) ? '0 : csr_req_data_i;
    acc_csr_req_wen_o  [0] = ( sel_output ) ? '0 : csr_req_wen_i;
    acc_csr_req_valid_o[0] = ( sel_output ) ? '0 : csr_req_valid_i;

    // Second port
    // Take away the offsets
    acc_csr_req_addr_o [1] = ( sel_output ) ? csr_addr_offset : '0;
    acc_csr_req_data_o [1] = ( sel_output ) ? csr_req_data_i  : '0;
    acc_csr_req_wen_o  [1] = ( sel_output ) ? csr_req_wen_i   : '0;
    acc_csr_req_valid_o[1] = ( sel_output ) ? csr_req_valid_i : '0;

    //-------------------------------
    // Ready can be selectable as this way
    // because the ready signal is sticky
    // according to core control
    //-------------------------------
    csr_req_ready_o = ( sel_output ) ? acc_csr_req_ready_i[1] : acc_csr_req_ready_i[0];
  end

  //-------------------------------
  // MUX-ing happens from accelerators to core
  // We take the upper part ports to have priority
  // This is just for simplicity's sake
  //-------------------------------
  always_comb begin
    // For read and valid ports
    csr_rsp_data_o  = ( acc_csr_rsp_valid_i[1] ) ? acc_csr_rsp_data_i[1]  : acc_csr_rsp_data_i[0];
    csr_rsp_valid_o = ( acc_csr_rsp_valid_i[1] ) ? acc_csr_rsp_valid_i[1] : acc_csr_rsp_valid_i[0];

    // For ready ports
    acc_csr_rsp_ready_o[1] = ( acc_csr_rsp_valid_i[1] ) ? csr_rsp_ready_i : '0;
    acc_csr_rsp_ready_o[0] = ( acc_csr_rsp_valid_i[1] ) ? '0              : csr_rsp_ready_i;
  end

endmodule
