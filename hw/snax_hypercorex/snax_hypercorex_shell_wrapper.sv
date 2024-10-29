// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

//-------------------------------
// Hypercorex Shell Wrapper
//-------------------------------

module snax_hypercorex_shell_wrapper # (
  //---------------------------
  // Outer Definitions
  //---------------------------
  parameter int unsigned NarrowDataWidth = 64,
  parameter int unsigned WideDataWidth   = 512,
  parameter int unsigned RegAddrWidth    = 32,
  parameter int unsigned RegDataWidth    = 32,
  //---------------------------
  // General Parameters
  //---------------------------
  parameter int unsigned HVDimension     = 512,
  //---------------------------
  // CSR Parameters
  //---------------------------
  parameter int unsigned CsrDataWidth    = RegAddrWidth,
  parameter int unsigned CsrAddrWidth    = RegDataWidth,
  //---------------------------
  // Item Memory Parameters
  //---------------------------
  parameter int unsigned NumTotIm        = 1024,
  parameter int unsigned NumPerImBank    = 128,
  parameter int unsigned ImAddrWidth     = $clog2(NumTotIm),
  parameter int unsigned SeedWidth       = CsrDataWidth,
  parameter int unsigned HoldFifoDepth   = 2,
  parameter bit          EnableRomIM     = 1'b1,
  //---------------------------
  // Instruction Memory Parameters
  //---------------------------
  parameter int unsigned InstMemDepth    = 128,
  //---------------------------
  // HDC Encoder Parameters
  //---------------------------
  parameter int unsigned BundCountWidth  = 8,
  parameter int unsigned BundMuxWidth    = 2,
  parameter int unsigned ALUMuxWidth     = 2,
  parameter int unsigned ALUMaxShiftAmt  = 128,
  parameter int unsigned RegMuxWidth     = 2,
  parameter int unsigned QvMuxWidth      = 2,
  parameter int unsigned RegNum          = 4
)(
  //-----------------------------
  // Clock and reset
  //-----------------------------
  input  logic                       clk_i,
  input  logic                       rst_ni,

  //-----------------------------
  // Accelerator ports
  //-----------------------------
  // Ports from accelerator to streamer by writer data movers
  output logic [NarrowDataWidth-1:0] acc2stream_0_data_o,
  output logic                       acc2stream_0_valid_o,
  input  logic                       acc2stream_0_ready_i,

  output logic [WideDataWidth-1:0]   acc2stream_1_data_o,
  output logic                       acc2stream_1_valid_o,
  input  logic                       acc2stream_1_ready_i,

  // Ports from streamer to accelerator by reader data movers
  input  logic [NarrowDataWidth-1:0] stream2acc_0_data_i,
  input  logic                       stream2acc_0_valid_i,
  output logic                       stream2acc_0_ready_o,

  input  logic [NarrowDataWidth-1:0] stream2acc_1_data_i,
  input  logic                       stream2acc_1_valid_i,
  output logic                       stream2acc_1_ready_o,

  input  logic [  WideDataWidth-1:0] stream2acc_2_data_i,
  input  logic                       stream2acc_2_valid_i,
  output logic                       stream2acc_2_ready_o,

  input  logic [  WideDataWidth-1:0] stream2acc_3_data_i,
  input  logic                       stream2acc_3_valid_i,
  output logic                       stream2acc_3_ready_o,

  input  logic [  WideDataWidth-1:0] stream2acc_4_data_i,
  input  logic                       stream2acc_4_valid_i,
  output logic                       stream2acc_4_ready_o,

  //-----------------------------
  // CSR control ports
  //-----------------------------
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

  //---------------------------
  // Assignments to take out bit-width warnings
  //---------------------------
  logic [CsrDataWidth-1:0] predict_data;

  // Outputs
  assign acc2stream_0_data_o =
    {{(NarrowDataWidth-CsrDataWidth){1'b0}},
    predict_data};


  //---------------------------
  // Hypercore Top Module
  //---------------------------
  hypercorex_top # (
    //---------------------------
    // General Parameters
    //---------------------------
    .HVDimension        ( HVDimension          ),
    .LowDimWidth        ( NarrowDataWidth      ),
    //---------------------------
    // CSR Parameters
    //---------------------------
    .CsrDataWidth       ( CsrDataWidth         ),
    .CsrAddrWidth       ( CsrAddrWidth         ),
    //---------------------------
    // Item Memory Parameters
    //---------------------------
    .NumTotIm           ( NumTotIm             ),
    .NumPerImBank       ( NumPerImBank         ),
    .SeedWidth          ( SeedWidth            ),
    .HoldFifoDepth      ( HoldFifoDepth        ),
    .EnableRomIM        ( EnableRomIM          ),
    //---------------------------
    // Instruction Memory Parameters
    //---------------------------
    .InstMemDepth       ( InstMemDepth         ),
    //---------------------------
    // HDC Encoder Parameters
    //---------------------------
    .BundCountWidth     ( BundCountWidth       ),
    .BundMuxWidth       ( BundMuxWidth         ),
    .ALUMuxWidth        ( ALUMuxWidth          ),
    .ALUMaxShiftAmt     ( ALUMaxShiftAmt       ),
    .RegMuxWidth        ( RegMuxWidth          ),
    .QvMuxWidth         ( QvMuxWidth           ),
    .RegNum             ( RegNum               )
  ) i_hypercorex_top (
    //---------------------------
    // Clocks and reset
    //---------------------------
    .clk_i              ( clk_i                ),
    .rst_ni             ( rst_ni               ),
    //---------------------------
    // CSR RW control signals
    //---------------------------
    // Request
    .csr_req_data_i     ( csr_req_data_i       ),
    .csr_req_addr_i     ( csr_req_addr_i       ),
    .csr_req_write_i    ( csr_req_write_i      ),
    .csr_req_valid_i    ( csr_req_valid_i      ),
    .csr_req_ready_o    ( csr_req_ready_o      ),
    // Response
    .csr_rsp_data_o     ( csr_rsp_data_o       ),
    .csr_rsp_ready_i    ( csr_rsp_ready_i      ),
    .csr_rsp_valid_o    ( csr_rsp_valid_o      ),
    //---------------------------
    // IM ports
    //---------------------------
    .lowdim_a_data_i    ( stream2acc_0_data_i  ),
    .lowdim_a_valid_i   ( stream2acc_0_valid_i ),
    .lowdim_a_ready_o   ( stream2acc_0_ready_o ),

    .lowdim_b_data_i    ( stream2acc_1_data_i  ),
    .lowdim_b_valid_i   ( stream2acc_1_valid_i ),
    .lowdim_b_ready_o   ( stream2acc_1_ready_o ),

    .highdim_a_data_i   ( stream2acc_2_data_i  ),
    .highdim_a_valid_i  ( stream2acc_2_valid_i ),
    .highdim_a_ready_o  ( stream2acc_2_ready_o ),

    .highdim_b_data_i   ( stream2acc_3_data_i  ),
    .highdim_b_valid_i  ( stream2acc_3_valid_i ),
    .highdim_b_ready_o  ( stream2acc_3_ready_o ),
    //---------------------------
    // QHV ports
    //---------------------------
    .qhv_o              ( acc2stream_1_data_o  ),
    .qhv_valid_o        ( acc2stream_1_valid_o ),
    .qhv_ready_i        ( acc2stream_1_ready_i ),
    //---------------------------
    // AM ports
    //---------------------------
    .class_hv_i         ( stream2acc_4_data_i  ),
    .class_hv_valid_i   ( stream2acc_4_valid_i ),
    .class_hv_ready_o   ( stream2acc_4_ready_o ),
    //---------------------------
    // Low-dim prediction
    //---------------------------
    .predict_o          ( predict_data         ),
    .predict_valid_o    ( acc2stream_0_valid_o ),
    .predict_ready_i    ( acc2stream_0_ready_i )
  );


endmodule
