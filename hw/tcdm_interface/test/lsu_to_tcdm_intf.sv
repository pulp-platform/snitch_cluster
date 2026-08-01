// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "reqrsp_interface/typedef.svh"
`include "reqrsp_interface/assign.svh"
`include "lsu_interface/typedef.svh"
`include "tcdm_interface/typedef.svh"
`include "tcdm_interface/assign.svh"

/// Interface wrapper for `lsu_to_tcdm`.
module lsu_to_tcdm_intf #(
  parameter int unsigned AddrWidth  = 0,
  parameter int unsigned DataWidth  = 0,
  parameter int unsigned UserWidth  = 0,
  parameter int unsigned BufDepth = 2
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  LSU_BUS             lsu,
  TCDM_BUS            tcdm
);

  `LSU_TYPEDEF_ALL(lsu, DataWidth, AddrWidth, UserWidth)
  `TCDM_TYPEDEF_ALL(tcdm, DataWidth, AddrWidth, UserWidth)

  lsu_req_t lsu_req;
  lsu_rsp_t lsu_rsp;

  tcdm_req_t tcdm_req;
  tcdm_rsp_t tcdm_rsp;

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
    .tcdm_req_o (tcdm_req),
    .tcdm_rsp_i (tcdm_rsp)
  );

  `LSU_ASSIGN_TO_REQ(lsu_req, lsu)
  `LSU_ASSIGN_FROM_RSP(lsu, lsu_rsp)

  `TCDM_ASSIGN_FROM_REQ(tcdm, tcdm_req)
  `TCDM_ASSIGN_TO_RSP(tcdm_rsp, tcdm)

endmodule
