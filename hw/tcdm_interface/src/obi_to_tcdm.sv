// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Lucia Luzi <luzil@ethz.ch>

`include "reqrsp_interface/typedef.svh"

/// Convert OBI to TCDM protocol.
module obi_to_tcdm #(
    parameter type obi_req_t = logic,
    parameter type obi_rsp_t = logic,
    parameter type tcdm_req_t = logic,
    parameter type tcdm_rsp_t = logic,
    parameter int unsigned AddrWidth   = 0,
    parameter int unsigned DataWidth   = 0,
    parameter int unsigned IdWidth     = 0,
    parameter int unsigned UserWidth   = 0,
    parameter int unsigned BufDepth    = 1,
    parameter int unsigned NumChannels = 1
) (
    input  logic      clk_i,
    input  logic      rst_ni,
    input  obi_req_t  [NumChannels-1:0] obi_req_i,
    output obi_rsp_t  [NumChannels-1:0] obi_rsp_o,
    output tcdm_req_t [NumChannels-1:0] tcdm_req_o,
    input  tcdm_rsp_t [NumChannels-1:0] tcdm_rsp_i
);

  typedef logic [AddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [DataWidth/8-1:0] strb_t;
  typedef logic [UserWidth-1:0] user_t;

  `REQRSP_TYPEDEF_ALL(reqrsp, addr_t, data_t, strb_t, user_t)

  for (genvar i = 0; i < NumChannels; i++) begin : gen_tcdm_obi_adapt
    assign tcdm_req_o[i].q_valid = obi_req_i[i].req;
    assign tcdm_req_o[i].q = '{
      addr: obi_req_i[i].a.addr,
      write: obi_req_i[i].a.we,
      amo: reqrsp_pkg::AMONone,
      data: obi_req_i[i].a.wdata,
      strb: obi_req_i[i].a.be,
      user: '0
    };

    assign obi_rsp_o[i].r = '{
      rdata: tcdm_rsp_i[i].p.data,
      rid: '0,
      err: 1'b0,
      r_optional: '0
    };
    assign obi_rsp_o[i].gnt = tcdm_rsp_i[i].q_ready;
    assign obi_rsp_o[i].rvalid = tcdm_rsp_i[i].p_valid;
  end

endmodule
