// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
`include "reqrsp_interface/typedef.svh"
`include "lsu_interface/typedef.svh"
`include "tcdm_interface/typedef.svh"
`include "axi/typedef.svh"

/// Convert AXI to TCDM protocol.
module axi_to_tcdm #(
    parameter int unsigned AddrWidth = 0,
    parameter int unsigned DataWidth = 0,
    parameter int unsigned IdWidth   = 0,
    parameter int unsigned UserWidth = 0,
    parameter int unsigned BufDepth  = 1,
    /// Derived parameters *do not override*
    localparam int unsigned StrbWidth = DataWidth/8,
    localparam type addr_t = logic [AddrWidth-1:0],
    localparam type data_t = logic [DataWidth-1:0],
    localparam type strb_t = logic [StrbWidth-1:0],
    localparam type id_t = logic [IdWidth-1:0],
    localparam type user_t = logic [UserWidth-1:0],
    localparam type tcdm_req_t = `TCDM_REQ_STRUCT(DataWidth, AddrWidth, UserWidth),
    localparam type tcdm_rsp_t = `TCDM_RSP_STRUCT(DataWidth),
    localparam type aw_chan_t = `AXI_DECL_AW_CHAN_T(addr_t, id_t, user_t),
    localparam type w_chan_t = `AXI_DECL_W_CHAN_T(data_t, strb_t, user_t),
    localparam type b_chan_t = `AXI_DECL_B_CHAN_T(id_t, user_t),
    localparam type ar_chan_t = `AXI_DECL_AR_CHAN_T(addr_t, id_t, user_t),
    localparam type r_chan_t = `AXI_DECL_R_CHAN_T(data_t, id_t, user_t),
    localparam type axi_req_t = `AXI_DECL_REQ_T(aw_chan_t, w_chan_t, ar_chan_t),
    localparam type axi_rsp_t = `AXI_DECL_RESP_T(b_chan_t, r_chan_t)
) (
    input  logic      clk_i,
    input  logic      rst_ni,
    input  axi_req_t  axi_req_i,
    output axi_rsp_t  axi_rsp_o,
    output tcdm_req_t tcdm_req_o,
    input  tcdm_rsp_t tcdm_rsp_i
);

  `LSU_TYPEDEF_ALL(lsu, DataWidth, AddrWidth, UserWidth)

  lsu_req_t lsu_req;
  lsu_rsp_t lsu_rsp;

  axi_to_lsu #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .IdWidth (IdWidth),
    .UserWidth (UserWidth),
    .BufDepth (BufDepth)
  ) i_axi_to_lsu (
    .clk_i (clk_i),
    .rst_ni (rst_ni),
    .busy_o (/* open */),
    .axi_req_i (axi_req_i),
    .axi_rsp_o (axi_rsp_o),
    .lsu_req_o (lsu_req),
    .lsu_rsp_i (lsu_rsp)
  );

  lsu_to_tcdm #(
    .BufDepth (BufDepth),
    .AddrWidth (AddrWidth),
    .UserWidth (UserWidth),
    .DataWidth (DataWidth)
  ) i_lsu_to_tcdm (
    .clk_i (clk_i),
    .rst_ni (rst_ni),
    .lsu_req_i (lsu_req),
    .lsu_rsp_o (lsu_rsp),
    .tcdm_req_o (tcdm_req_o),
    .tcdm_rsp_i (tcdm_rsp_i)
  );

endmodule
