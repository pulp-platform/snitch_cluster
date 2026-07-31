// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "reqrsp_interface/typedef.svh"
`include "reqrsp_interface/assign.svh"
`include "snitch/typedef.svh"
`include "axi/typedef.svh"
`include "axi/assign.svh"

/// Interface wrapper for `axi_to_lsu`.
module axi_to_lsu_intf #(
  /// AXI addr width.
  parameter int unsigned AddrWidth  = 0,
  /// AXI data width.
  parameter int unsigned DataWidth  = 0,
  /// AXI id width.
  parameter int unsigned IdWidth    = 0,
  /// AXI user width.
  parameter int unsigned UserWidth  = 0,
  /// Depth of memory response buffer. This should be equal to the downstream
  /// response latency.
  parameter int unsigned BufDepth   = 1
) (
  /// Clock input.
  input  logic   clk_i,
  /// Asynchronous reset, active low.
  input  logic   rst_ni,
  /// The unit is busy handling an AXI4+ATOP request.
  output logic   busy_o,
  LSU_BUS        lsu,
  AXI_BUS        axi
);

  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic [IdWidth-1:0] id_t;
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

  axi_to_lsu #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .IdWidth (IdWidth),
    .UserWidth (UserWidth),
    .BufDepth (BufDepth)
  ) i_dut (
    .clk_i,
    .rst_ni,
    .busy_o,
    .axi_req_i (axi_req),
    .axi_rsp_o (axi_rsp),
    .lsu_req_o (lsu_req),
    .lsu_rsp_i (lsu_rsp)
  );

  `LSU_ASSIGN_FROM_REQ(lsu, lsu_req)
  `LSU_ASSIGN_TO_RSP(lsu_rsp, lsu)

  `AXI_ASSIGN_TO_REQ(axi_req, axi)
  `AXI_ASSIGN_FROM_RESP(axi, axi_rsp)

endmodule
