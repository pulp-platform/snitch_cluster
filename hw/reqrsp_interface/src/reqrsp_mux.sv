// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"

/// Multiplex multiple `reqrsp` ports onto one, based on arbitration.
module reqrsp_mux #(
    /// Number of input ports.
    parameter int unsigned               NrPorts      = 2,
    /// Address width of the interface.
    parameter int unsigned               AddrWidth    = 0,
    /// Data width of the interface.
    parameter int unsigned               DataWidth    = 0,
    /// User width of the interface.
    parameter int unsigned               UserWidth    = 0,
    /// Request type.
    parameter type                       req_t        = logic,
    /// Response type.
    parameter type                       rsp_t        = logic,
    /// Amount of outstanding responses. Determines the FIFO size.
    parameter int unsigned               RespDepth    = 8,
    /// Cut timing paths on the request path. Incurs a cycle additional latency.
    /// Registers are inserted at the slave side.
    parameter bit          [NrPorts-1:0] RegisterReq  = '0,
    /// Dependent parameter, do **not** overwrite.
    /// Width of the arbitrated index.
    parameter int unsigned IdxWidth   = (NrPorts > 32'd1) ? unsigned'($clog2(NrPorts)) : 32'd1
) (
    input  logic                clk_i,
    input  logic                rst_ni,
    input  req_t [NrPorts-1:0]  slv_req_i,
    output rsp_t [NrPorts-1:0]  slv_rsp_o,
    output req_t                mst_req_o,
    input  rsp_t                mst_rsp_i,
    output logic [IdxWidth-1:0] idx_o
);

  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic [UserWidth-1:0] user_t;

  `REQRSP_TYPEDEF_REQ_CHAN_T(req_chan_t, addr_t, data_t, strb_t, user_t)
  `REQRSP_TYPEDEF_RSP_CHAN_T(rsp_chan_t, data_t)

  generic_reqrsp_mux #(
    .NrPorts(NrPorts),
    .req_chan_t(req_chan_t),
    .rsp_chan_t(rsp_chan_t),
    .RspDepth(RespDepth),
    .RegisterReq(RegisterReq)
  ) i_generic_reqrsp_mux (
    .clk_i,
    .rst_ni,
    .slv_req_i,
    .slv_rsp_o,
    .mst_req_o,
    .mst_rsp_i,
    .rsp_route_i('0),
    .idx_o
  );

endmodule

`include "reqrsp_interface/typedef.svh"
`include "reqrsp_interface/assign.svh"

/// Interface wrapper.
module reqrsp_mux_intf #(
    /// Number of input ports.
    parameter int unsigned      NrPorts      = 2,
    /// Address width of the interface.
    parameter int unsigned      AddrWidth    = 0,
    /// Data width of the interface.
    parameter int unsigned      DataWidth    = 0,
    /// User width of the interface.
    parameter int unsigned      UserWidth    = 0,
    /// Amount of outstanding responses. Determines the FIFO size.
    parameter int unsigned      RespDepth    = 8,
    /// Cut timing paths on the request path. Incurs a cycle additional latency.
    /// Registers are inserted at the slave side.
    parameter bit [NrPorts-1:0] RegisterReq  = '0
) (
    input  logic clk_i,
    input  logic rst_ni,
    REQRSP_BUS   slv [NrPorts],
    REQRSP_BUS   mst,
    output logic [$clog2(NrPorts)-1:0] idx_o
);

  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic [UserWidth-1:0] user_t;

  `REQRSP_TYPEDEF_ALL(reqrsp, addr_t, data_t, strb_t, user_t)

  reqrsp_req_t [NrPorts-1:0] reqrsp_slv_req;
  reqrsp_rsp_t [NrPorts-1:0] reqrsp_slv_rsp;

  reqrsp_req_t reqrsp_mst_req;
  reqrsp_rsp_t reqrsp_mst_rsp;

  reqrsp_mux #(
    .NrPorts (NrPorts),
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .UserWidth (UserWidth),
    .req_t (reqrsp_req_t),
    .rsp_t (reqrsp_rsp_t),
    .RespDepth (RespDepth),
    .RegisterReq (RegisterReq)
  ) i_reqrsp_mux (
    .clk_i,
    .rst_ni,
    .slv_req_i (reqrsp_slv_req),
    .slv_rsp_o (reqrsp_slv_rsp),
    .mst_req_o (reqrsp_mst_req),
    .mst_rsp_i (reqrsp_mst_rsp),
    .idx_o (idx_o)
  );

  for (genvar i = 0; i < NrPorts; i++) begin : gen_interface_assignment
    `REQRSP_ASSIGN_TO_REQ(reqrsp_slv_req[i], slv[i])
    `REQRSP_ASSIGN_FROM_RESP(slv[i], reqrsp_slv_rsp[i])
  end

  `REQRSP_ASSIGN_FROM_REQ(mst, reqrsp_mst_req)
  `REQRSP_ASSIGN_TO_RESP(reqrsp_mst_rsp, mst)

endmodule
