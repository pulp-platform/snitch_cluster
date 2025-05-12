// Copyright 2020 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

// verilog_lint: waive-start line-length
// verilog_lint: waive-start no-trailing-spaces

module snax_acc_mux_demux #(
  parameter int unsigned NumAcc               = 2,
  parameter int unsigned RegDataWidth         = 32,
  parameter int unsigned RegAddrWidth         = 32
)(
  //------------------------
  // Clock and reset
  //------------------------
  input   logic                   clk_i,
  input   logic                   rst_ni,

  //------------------------
  // Multi-accelerator MUX control
  //------------------------
  input  logic [RegDataWidth-1:0] multi_acc_mux_i,

  //------------------------
  // Main Snitch Port
  //------------------------
  input  logic [RegAddrWidth-1:0] csr_req_addr_i,
  input  logic [RegDataWidth-1:0] csr_req_data_i,
  input  logic                    csr_req_wen_i,
  input  logic                    csr_req_valid_i,
  output logic                    csr_req_ready_o,
  output logic [RegDataWidth-1:0] csr_rsp_data_o,
  output logic                    csr_rsp_valid_o,
  input  logic                    csr_rsp_ready_i,

  //------------------------
  // Split Ports
  //------------------------
  output logic [NumAcc-1:0][RegAddrWidth-1:0] acc_csr_req_addr_o,
  output logic [NumAcc-1:0][RegDataWidth-1:0] acc_csr_req_data_o,
  output logic [NumAcc-1:0][0:0]              acc_csr_req_wen_o,
  output logic [NumAcc-1:0][0:0]              acc_csr_req_valid_o,
  input  logic [NumAcc-1:0][0:0]              acc_csr_req_ready_i,
  input  logic [NumAcc-1:0][RegDataWidth-1:0] acc_csr_rsp_data_i,
  input  logic [NumAcc-1:0][0:0]              acc_csr_rsp_valid_i,
  output logic [NumAcc-1:0][0:0]              acc_csr_rsp_ready_o
);

  //------------------------------------------
  // Local parameters
  //------------------------------------------
  localparam int unsigned AccNumBitWidth = $clog2(NumAcc);

  //------------------------------------------
  // Accelerator Demux Port
  // For splitting the accelerator into parts
  //------------------------------------------
  logic [AccNumBitWidth-1:0] snax_req_sel;
  assign snax_req_sel = multi_acc_mux_i[AccNumBitWidth-1:0];

  always_comb begin
    for ( int i = 0; i < NumAcc; i ++ ) begin
      // This one broadcasts the control to all request ports
      acc_csr_req_addr_o[i] = csr_req_addr_i;
      acc_csr_req_data_o[i] = csr_req_data_i;
      acc_csr_req_wen_o [i] = csr_req_wen_i;
    end
  end

  stream_demux #(
    .N_OUP        ( NumAcc              )
  ) i_stream_demux_offload (
    .inp_valid_i  ( csr_req_valid_i     ),
    .inp_ready_o  ( csr_req_ready_o     ),
    .oup_sel_i    ( snax_req_sel        ),
    .oup_valid_o  ( acc_csr_req_valid_o ),
    .oup_ready_i  ( acc_csr_req_ready_i )
  );

  //------------------------------------------
  // Accelerator MUX Port
  // For handling multiple transactions
  //------------------------------------------
  typedef logic [RegDataWidth-1:0] data_t;

  stream_arbiter #(
    .DATA_T      ( data_t               ),
    .N_INP       ( NumAcc               )
  ) i_stream_arbiter_offload (
    .clk_i       ( clk_i                ),
    .rst_ni      ( rst_ni               ),
    .inp_data_i  ( acc_csr_rsp_data_i   ),
    .inp_valid_i ( acc_csr_rsp_valid_i  ),
    .inp_ready_o ( acc_csr_rsp_ready_o  ),
    .oup_data_o  ( csr_rsp_data_o       ),
    .oup_valid_o ( csr_rsp_valid_o      ),
    .oup_ready_i ( csr_rsp_ready_i      )
  );

endmodule

// ----- Module Usage -----
// snax_acc_mux_demux #(
//     .NumCsrs      (),
//     .NumAcc       (),
//     .RegDataWidth (),
//     .RegAddrWidth ()
// ) i_snax_acc_mux_demux (
//     //------------------------
//     // Clock and reset
//     //------------------------
//     .clk_i  (),
//     .rst_ni (),
//
//     //------------------------
//     // Main Snitch Port
//     //------------------------
//     .csr_req_addr_i  (),
//     .csr_req_data_i  (),
//     .csr_req_wen_i   (),
//     .csr_req_valid_i (),
//     .csr_req_ready_o (),
//     .csr_rsp_data_o  (),
//     .csr_rsp_valid_o (),
//     .csr_rsp_ready_i (),
//
//     //------------------------
//     // Split Ports
//     //------------------------
//     .acc_csr_req_addr_o  (),
//     .acc_csr_req_data_o  (),
//     .acc_csr_req_wen_o   (),
//     .acc_csr_req_valid_o (),
//     .acc_csr_req_ready_i (),
//     .acc_csr_rsp_data_i  (),
//     .acc_csr_rsp_valid_i (),
//     .acc_csr_rsp_ready_o ()
//   );
