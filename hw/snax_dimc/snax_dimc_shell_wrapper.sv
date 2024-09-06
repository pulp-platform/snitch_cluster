// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

//-------------------------------
// DIMC Shell Wrapper
//-------------------------------

module snax_dimc_shell_wrapper # (
  //---------------------------
  // Outer Definitions
  //---------------------------
  parameter int unsigned NarrowDataWidth = 64,
  parameter int unsigned WideDataWidth   = 512,
  parameter int unsigned RegAddrWidth    = 32,
  parameter int unsigned RegDataWidth    = 32,
  //---------------------------
  // CSR Parameters
  //---------------------------
  parameter int unsigned CsrDataWidth    = RegAddrWidth,
  parameter int unsigned CsrAddrWidth    = RegDataWidth
)(
  //----------------------------
  // Clock and reset
  //----------------------------
  input  logic                       clk_i,
  input  logic                       rst_ni,
  //----------------------------
  // Accelerator ports
  //----------------------------
  // Ports from accelerator to streamer by writer data movers
  output logic [WideDataWidth-1:0]   acc2stream_0_data_o,
  output logic                       acc2stream_0_valid_o,
  input  logic                       acc2stream_0_ready_i,
  // Ports from streamer to accelerator by reader data movers
  input  logic [WideDataWidth-1:0]   stream2acc_0_data_i,
  input  logic                       stream2acc_0_valid_i,
  output logic                       stream2acc_0_ready_o,

  input  logic [WideDataWidth-1:0]   stream2acc_1_data_i,
  input  logic                       stream2acc_1_valid_i,
  output logic                       stream2acc_1_ready_o,

  input  logic [WideDataWidth-1:0]   stream2acc_2_data_i,
  input  logic                       stream2acc_2_valid_i,
  output logic                       stream2acc_2_ready_o,

  input  logic [WideDataWidth-1:0]   stream2acc_3_data_i,
  input  logic                       stream2acc_3_valid_i,
  output logic                       stream2acc_3_ready_o,
  //----------------------------
  // CSR control ports
  //----------------------------
  // Request
  input  logic [   RegAddrWidth-1:0] csr_req_addr_i,
  input  logic [   RegDataWidth-1:0] csr_req_data_i,
  input  logic                       csr_req_write_i,
  input  logic                       csr_req_valid_i,
  output logic                       csr_req_ready_o,
  // Response
  output logic [   RegDataWidth-1:0] csr_rsp_data_o,
  output logic                       csr_rsp_valid_o,
  input  logic                       csr_rsp_ready_i
);

  SNAX_DIMC i_dimc_acc_top(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .acc2stream_0_data_o(acc2stream_0_data_o),
    .acc2stream_0_valid_o(acc2stream_0_valid_o),
    .acc2stream_0_ready_i(acc2stream_0_ready_i),

    .stream2acc_0_data_i(stream2acc_0_data_i),
    .stream2acc_0_valid_i(stream2acc_0_valid_i),
    .stream2acc_0_ready_o(stream2acc_0_ready_o),

    .stream2acc_1_data_i(stream2acc_1_data_i),
    .stream2acc_1_valid_i(stream2acc_1_valid_i),
    .stream2acc_1_ready_o(stream2acc_1_ready_o),

    .stream2acc_2_data_i(stream2acc_2_data_i),
    .stream2acc_2_valid_i(stream2acc_2_valid_i),
    .stream2acc_2_ready_o(stream2acc_2_ready_o),

    .stream2acc_3_data_i(stream2acc_3_data_i),
    .stream2acc_3_valid_i(stream2acc_3_valid_i),
    .stream2acc_3_ready_o(stream2acc_3_ready_o),

    .csr_req_addr_i(csr_req_addr_i),
    .csr_req_data_i(csr_req_data_i),
    .csr_req_write_i(csr_req_write_i),
    .csr_req_valid_i(csr_req_valid_i),
    .csr_req_ready_o(csr_req_ready_o),

    .csr_rsp_data_o(csr_rsp_data_o),
    .csr_rsp_valid_o(csr_rsp_valid_o),
    .csr_rsp_ready_i(csr_rsp_ready_i)
  );

endmodule
