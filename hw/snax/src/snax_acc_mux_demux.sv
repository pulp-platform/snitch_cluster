// Copyright 2020 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

// verilog_lint: waive-start line-length
// verilog_lint: waive-start no-trailing-spaces

module snax_acc_mux_demux #(
  parameter int unsigned          NumCsrs   = 32,
  parameter int unsigned          NumAcc    = 2,
  parameter type                  acc_req_t = logic,
  parameter type                  acc_rsp_t = logic
)(
  //------------------------
  // Clock and reset
  //------------------------
  input   logic                   clk_i,
  input   logic                   rst_ni,

  //------------------------
  // Main Snitch Port
  //------------------------
  input   acc_req_t               snax_req_i,
  input   logic                   snax_qvalid_i,
  output  logic                   snax_qready_o,

  output  acc_rsp_t               snax_resp_o,
  output  logic                   snax_pvalid_o,
  input   logic                   snax_pready_i,

  //------------------------
  // Split Ports
  //------------------------
  output  acc_req_t [NumAcc-1:0]  snax_split_req_o,
  output  logic     [NumAcc-1:0]  snax_split_qvalid_o,
  input   logic     [NumAcc-1:0]  snax_split_qready_i,

  input   acc_rsp_t [NumAcc-1:0]  snax_split_resp_i,
  input   logic     [NumAcc-1:0]  snax_split_pvalid_i,
  output  logic     [NumAcc-1:0]  snax_split_pready_o
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

  logic [31:0] internal_addr_sel;

  assign internal_addr_sel = snax_req_i.data_argb - 32'd960;

  always_comb begin
    for ( int i = 0; i < NumAcc; i ++ ) begin
      // This one is for setting the control signals for the demuxer
      if((internal_addr_sel >= i*NumCsrs) && (internal_addr_sel < (i+1)*NumCsrs - 1)) begin
        snax_req_sel = i;
      end

      // This one broadcasts the control to all request ports
      snax_split_req_o[i].addr      = snax_req_i.addr;
      snax_split_req_o[i].data_arga = snax_req_i.data_arga;
      snax_split_req_o[i].data_argb = snax_req_i.data_argb - i*NumCsrs;
      snax_split_req_o[i].data_argc = snax_req_i.data_argc;
      snax_split_req_o[i].data_op   = snax_req_i.data_op;
      snax_split_req_o[i].id        = snax_req_i.id;
    end
  end

  stream_demux #(
    .N_OUP        ( NumAcc              )
  ) i_stream_demux_offload (
    .inp_valid_i  ( snax_qvalid_i       ),
    .inp_ready_o  ( snax_qready_o       ),
    .oup_sel_i    ( snax_req_sel        ),
    .oup_valid_o  ( snax_split_qvalid_o ),
    .oup_ready_i  ( snax_split_qready_i )
  );


  //------------------------------------------
  // Accelerator MUX Port
  // For handling multiple transactions
  //------------------------------------------
  stream_arbiter #(
    .DATA_T      ( acc_rsp_t            ),
    .N_INP       ( NumAcc               )
  ) i_stream_arbiter_offload (
    .clk_i       ( clk_i                ),
    .rst_ni      ( rst_ni               ),
    .inp_data_i  ( snax_split_resp_i    ),
    .inp_valid_i ( snax_split_pvalid_i  ),
    .inp_ready_o ( snax_split_pready_o  ),
    .oup_data_o  ( snax_resp_o          ),
    .oup_valid_o ( snax_pvalid_o        ),
    .oup_ready_i ( snax_pready_i        )
  );

endmodule

// ----- Module Usage -----
// snax_acc_mux_demux #(
//     .NumCsrs   (),
//     .NumAcc    (),
//     .acc_req_t (),
//     .acc_rsp_t ()
//   ) i_snax_acc_mux_demux (
//     .clk_i(),
//     .rst_ni(),

//     //------------------------
//     // Main Snitch Port
//     //------------------------
//     .snax_req_i(),
//     .snax_qvalid_i(),
//     .snax_qready_o(),

//     .snax_resp_o(),
//     .snax_pvalid_o(),
//     .snax_pready_i(),

//     //------------------------
//     // Split Ports
//     //------------------------
//     .snax_split_req_o(),
//     .snax_split_qvalid_o(),
//     .snax_split_qready_i(),

//     .snax_split_resp_i(),
//     .snax_split_pvalid_i(),
//     .snax_split_pready_o()
//   );
