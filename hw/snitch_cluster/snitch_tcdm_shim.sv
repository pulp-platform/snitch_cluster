// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// TCDM Shim

// Description: Converts propper handshaking (ready/valid) to TCDM signalling
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "common_cells/registers.svh"

// TODO(zarubaf): Limit soc request protocol to 32 bit
module snitch_tcdm_shim #(
  parameter  int unsigned AddrWidth = 32,
  parameter  int unsigned DataWidth = 64,
  parameter  int unsigned MaxOutStandingReads = 2,
  parameter  bit          InclDemux = 1'b1,
  localparam int unsigned StrbWidth = DataWidth/8
) (
  input  logic                   clk_i,
  input  logic                   rst_i,
  // to TCDM
  output logic                   tcdm_req_o,
  output logic [AddrWidth-1:0]   tcdm_add_o,
  output logic                   tcdm_wen_o,
  output logic [DataWidth-1:0]   tcdm_wdata_o,
  output snitch_pkg::amo_op_t    tcdm_amo_o,
  output logic [StrbWidth-1:0]   tcdm_be_o,
  input  logic                   tcdm_gnt_i,
  input  logic                   tcdm_vld_i,
  input  logic [DataWidth-1:0]   tcdm_rdata_i,
  // to SoC
  output logic [AddrWidth-1:0]   soc_qaddr_o,
  output logic                   soc_qwrite_o,
  output snitch_pkg::amo_op_t    soc_qamo_o,
  output logic [DataWidth-1:0]   soc_qdata_o,
  output logic [1:0]             soc_qsize_o,
  output logic [StrbWidth-1:0]   soc_qstrb_o,
  output logic                   soc_qvalid_o,
  input  logic                   soc_qready_i,
  input  logic [DataWidth-1:0]   soc_pdata_i,
  input  logic                   soc_perror_i,
  input  logic                   soc_pvalid_i,
  output logic                   soc_pready_o,
  // from core
  input  logic [AddrWidth-1:0]   data_qaddr_i,
  input  logic                   data_qwrite_i,
  input  snitch_pkg::amo_op_t    data_qamo_i,
  input  logic [DataWidth-1:0]   data_qdata_i,
  input  logic [1:0]             data_qsize_i,
  input  logic [StrbWidth-1:0]   data_qstrb_i,
  input  logic                   data_qvalid_i,
  output logic                   data_qready_o,
  output logic [DataWidth-1:0]   data_pdata_o,
  output logic                   data_perror_o,
  output logic                   data_pvalid_o,
  input  logic                   data_pready_i
);

  // Response interface from TCDM, we need to add back-pressure for Snitch's interface
  logic tcdm_fifo_pop;
  logic empty;

  snitch_pkg::dreq_t  data_qpayload, soc_qpayload, tcdm_qpayload;
  logic               tcdm_qvalid;
  snitch_pkg::dresp_t data_ppayload, soc_ppayload, tcdm_ppayload;
  logic               tcdm_pvalid;
  logic               tcdm_pready;

  logic [$clog2(MaxOutStandingReads):0] credits_q, credits_d;
  `FFSR(credits_q, credits_d, MaxOutStandingReads, clk_i, rst_i)

  fifo #(
    .FALL_THROUGH ( 1'b1                ),
    .DATA_WIDTH   ( DataWidth           ),
    .DEPTH        ( MaxOutStandingReads )
  ) i_resp_fifo (
    .clk_i,
    .rst_ni      ( ~rst_i             ),
    .flush_i     ( 1'b0               ),
    .testmode_i  ( 1'b0               ),
    .full_o      (                    ),
    .empty_o     ( empty              ),
    .threshold_o (                    ),
    .data_i      ( tcdm_rdata_i       ),
    .push_i      ( tcdm_vld_i         ),
    .data_o      ( tcdm_ppayload.data ),
    .pop_i       ( tcdm_fifo_pop      )
  );

  // track credits
  always_comb begin
    automatic logic [$clog2(MaxOutStandingReads):0] credits;
    credits = credits_q;
    if (tcdm_req_o && tcdm_gnt_i && !tcdm_qpayload.write) credits--;
    if (tcdm_pvalid && tcdm_pready) credits++;
    credits_d = credits;
  end

  // we need space in the return fifo for reads
  assign tcdm_req_o = tcdm_qvalid & (credits_q != '0 | tcdm_qpayload.write);

  assign tcdm_pvalid = ~empty;
  assign tcdm_fifo_pop = tcdm_pvalid & tcdm_pready;
  assign tcdm_ppayload.error = 1'b0;

  if (InclDemux) begin : gen_addr_demux
    snitch_addr_demux #(
      .NrOutput            ( 2                   ),
      .AddressWidth        ( AddrWidth           ),
      .DefaultSlave        ( 1                   ),
      .NrRules             ( 1                   ),
      .MaxOutStandingReads ( 2                   ),
      .req_t               ( snitch_pkg::dreq_t  ),
      .resp_t              ( snitch_pkg::dresp_t )
    ) i_snitch_addr_demux (
      .clk_i,
      .rst_ni         ( ~rst_i         ),
      .req_addr_i     ( data_qaddr_i   ),
      .req_write_i    ( data_qwrite_i  ),
      .req_payload_i  ( data_qpayload  ),
      .req_valid_i    ( data_qvalid_i  ),
      .req_ready_o    ( data_qready_o  ),
      .resp_payload_o ( data_ppayload  ),
      .resp_valid_o   ( data_pvalid_o  ),
      .resp_ready_i   ( data_pready_i  ),

      .req_payload_o  ( {soc_qpayload, tcdm_qpayload} ),
      .req_valid_o    ( {soc_qvalid_o, tcdm_qvalid}   ),
      .req_ready_i    ( {soc_qready_i, tcdm_gnt_i}    ),
      .resp_payload_i ( {soc_ppayload, tcdm_ppayload} ),
      .resp_valid_i   ( {soc_pvalid_i, tcdm_pvalid}   ),
      .resp_ready_o   ( {soc_pready_o, tcdm_pready}   ),

      .addr_mask_i   ( { snitch_pkg::TCDMMask } ),
      .addr_base_i   ( { snitch_pkg::TCDMStartAddress } ),
      .addr_slave_i  ( { 1'b0          } )
    );
  end else begin : gen_no_addr_demux
    // directly connect TCDM port
    assign tcdm_qpayload = data_qpayload;
    assign tcdm_qvalid = data_qvalid_i;
    assign data_qready_o = tcdm_gnt_i;
    assign data_ppayload = tcdm_ppayload;
    assign data_pvalid_o = tcdm_pvalid;
    assign tcdm_pready = data_pready_i;
    // tie-off soc port
    assign soc_qpayload = '0;
    assign soc_qvalid_o = '0;
    assign soc_pready_o = '0;
  end

  assign data_qpayload.addr = data_qaddr_i;
  assign data_qpayload.write = data_qwrite_i;
  assign data_qpayload.amo = data_qamo_i;
  assign data_qpayload.data = data_qdata_i;
  assign data_qpayload.size = data_qsize_i;
  assign data_qpayload.strb = data_qstrb_i;

  assign data_pdata_o = data_ppayload.data;
  assign data_perror_o = data_ppayload.error;

  // Request interface
  assign tcdm_add_o = tcdm_qpayload.addr;
  assign tcdm_wen_o = tcdm_qpayload.write;
  assign tcdm_wdata_o = tcdm_qpayload.data;
  assign tcdm_amo_o = tcdm_qpayload.amo;
  assign tcdm_be_o = tcdm_qpayload.strb;

  assign soc_qaddr_o = soc_qpayload.addr;
  assign soc_qwrite_o = soc_qpayload.write;
  assign soc_qdata_o = soc_qpayload.data;
  assign soc_qsize_o = soc_qpayload.size;
  assign soc_qamo_o = soc_qpayload.amo;
  assign soc_qstrb_o = soc_qpayload.strb;

  assign soc_ppayload.data = soc_pdata_i;
  assign soc_ppayload.error = soc_perror_i;

endmodule
