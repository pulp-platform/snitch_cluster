// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "reqrsp_interface/typedef.svh"
`include "reqrsp_interface/assign.svh"
`include "snitch/typedef.svh"
`include "axi/typedef.svh"
`include "axi/assign.svh"

/// Interface wrapper for `lsu_to_axi`.
module lsu_to_axi_intf #(
  /// ID width which to send the transactions.
  parameter int unsigned ID = 0,
  /// AXI ID width.
  parameter int unsigned AxiIdWidth = 32'd0,
  /// AXI and LSU address width.
  parameter int unsigned AddrWidth = 32'd0,
  /// AXI and LSU data width.
  parameter int unsigned DataWidth = 32'd0,
  /// AXI and LSU user width.
  parameter int unsigned UserWidth = 32'd0
) (
  input logic clk_i,
  input logic rst_ni,
  LSU_BUS     lsu,
  AXI_BUS     axi
);

  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic [AxiIdWidth-1:0] id_t;
  typedef logic [UserWidth-1:0] user_t;

  `LSU_TYPEDEF_ALL(lsu, DataWidth, AddrWidth, UserWidth)

  `AXI_TYPEDEF_AW_CHAN_T(aw_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_W_CHAN_T(w_chan_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_B_CHAN_T(b_chan_t, id_t, user_t)
  `AXI_TYPEDEF_AR_CHAN_T(ar_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_R_CHAN_T(r_chan_t, data_t, id_t, user_t)

  `AXI_TYPEDEF_REQ_T(axi_req_t, aw_chan_t, w_chan_t, ar_chan_t)
  `AXI_TYPEDEF_RESP_T(axi_rsp_t, b_chan_t, r_chan_t)

  lsu_req_t lsu_req;
  lsu_rsp_t lsu_rsp;

  axi_req_t axi_req;
  axi_rsp_t axi_rsp;

  lsu_to_axi #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .IdWidth (AxiIdWidth),
    .UserWidth (UserWidth)
  ) i_lsu_to_axi (
    .clk_i,
    .rst_ni,
    .lsu_req_i (lsu_req),
    .lsu_rsp_o (lsu_rsp),
    .axi_req_o (axi_req),
    .axi_rsp_i (axi_rsp)
  );

  `LSU_ASSIGN_TO_REQ(lsu_req, lsu)
  `LSU_ASSIGN_FROM_RSP(lsu, lsu_rsp)

  `AXI_ASSIGN_FROM_REQ(axi, axi_req)
  `AXI_ASSIGN_TO_RESP(axi_rsp, axi)

endmodule
