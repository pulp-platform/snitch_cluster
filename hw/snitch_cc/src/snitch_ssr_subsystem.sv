// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "common_cells/assertions.svh"
`include "common_cells/registers.svh"

/// Stream Semantic Register (SSR) subsystem of the Snitch Core Complex (CC).
/// Decodes the SCFG* configuration instructions offloaded on the accelerator
/// bus, drives the SSR streamer, and muxes the resulting TCDM traffic with
/// the core's own TCDM port. If `IsaCfg.Xssr` is disabled, the core TCDM port
/// is simply passed through and the SSR interfaces are tied off.
module snitch_ssr_subsystem #(
  parameter snitch_pkg::isa_cfg_t IsaCfg = '0,
  parameter int unsigned NumSsrs         = 0,
  parameter snitch_ssr_pkg::ssr_cfg_t [cc_pkg::iomsb(NumSsrs):0] SsrCfgs = '0,
  parameter logic [cc_pkg::iomsb(NumSsrs):0][4:0] SsrRegs = '0,
  parameter int unsigned SsrMuxRspDepth  = 0,
  parameter int unsigned TcdmAddrWidth   = 0,
  parameter int unsigned DataWidth       = 0,
  parameter int unsigned TcdmUserWidth   = 0,
  parameter type acc_req_t  = logic,
  parameter type acc_rsp_t  = logic,
  parameter type tcdm_req_t = logic,
  parameter type tcdm_rsp_t = logic,
  /// Derived parameter *Do not override*
  localparam type data_t = logic [DataWidth-1:0]
) (
  input  logic      clk_i,
  input  logic      rst_ni,
  // SSR configuration - accelerator bus (SSR_CFG offload)
  input  acc_req_t  acc_req_i,
  output acc_rsp_t  acc_rsp_o,
  // SSR data streams - FP subsystem side
  input  logic  [2:0][4:0] ssr_raddr_i,
  output data_t [2:0]      ssr_rdata_o,
  input  logic  [2:0]      ssr_rvalid_i,
  output logic  [2:0]      ssr_rready_o,
  input  logic  [2:0]      ssr_rdone_i,
  input  logic  [0:0][4:0] ssr_waddr_i,
  input  data_t [0:0]      ssr_wdata_i,
  input  logic  [0:0]      ssr_wvalid_i,
  output logic  [0:0]      ssr_wready_o,
  input  logic  [0:0]      ssr_wdone_i,
  output logic             ssr_streamctl_done_o,
  output logic             ssr_streamctl_valid_o,
  input  logic             ssr_streamctl_ready_i,
  // TCDM ports
  output tcdm_req_t [NumSsrs-1:0] tcdm_req_o,
  input  tcdm_rsp_t [NumSsrs-1:0] tcdm_rsp_i
);

  typedef struct packed {
    logic [4:0]  id;
    logic [11:0] word;
    logic [31:0] data;
    logic        write;
  } ssr_cfg_req_t;

  typedef struct packed {
    logic [4:0]  id;
    logic [31:0] data;
  } ssr_cfg_rsp_t;

  logic ssr_qvalid, ssr_qready;
  logic ssr_pvalid, ssr_pready;

  assign ssr_qvalid        = acc_req_i.q_valid;
  assign ssr_pready        = acc_req_i.p_ready;
  assign acc_rsp_o.q_ready = ssr_qready;
  assign acc_rsp_o.p_valid = ssr_pvalid;

  if (IsaCfg.Xssr) begin : gen_ssrs
    tcdm_req_t [NumSsrs-1:0] ssr_req;
    tcdm_rsp_t [NumSsrs-1:0] ssr_rsp;
    tcdm_req_t tcdm_req;
    tcdm_rsp_t tcdm_rsp;

    ssr_cfg_req_t ssr_cfg_req, cfg_req;
    ssr_cfg_rsp_t ssr_cfg_rsp, cfg_rsp;

    logic cfg_req_valid, cfg_req_valid_q;
    logic cfg_req_wready, cfg_req_ready, cfg_req_hs;
    logic [31:0] cfg_rsp_data;
    assign cfg_req_ready = ~cfg_req.write | cfg_req_wready;
    assign cfg_req_hs = cfg_req_valid & cfg_req_ready;
    `FF(cfg_req_valid_q, cfg_req_hs, 0)
    `FFL(cfg_rsp.id, ssr_cfg_req.id, cfg_req_hs, 0)
    `FFL(cfg_rsp.data, cfg_rsp_data, cfg_req_hs, 0)

    // SSR config decoder
    always_comb begin
      import snitch_riscv_instr::*;
      automatic logic [11:0] addr;
      automatic logic [4:0] addr_dm;
      automatic logic [6:0] addr_reg;

      ssr_cfg_req.id = acc_req_i.q.id;
      ssr_cfg_req.data = acc_req_i.q.data_arga[31:0];
      ssr_cfg_req.word = '0;
      ssr_cfg_req.write = '0;

      addr = '0;
      unique casez (acc_req_i.q.data_op)
        SCFGRI,
        SCFGWI: begin
          addr = acc_req_i.q.data_op[31:20];
        end
        SCFGR,
        SCFGW: begin
          addr = acc_req_i.q.data_argb[31:0];
        end
        default: ;
      endcase

      addr_reg = addr[11:5];
      addr_dm = addr[4:0];
      ssr_cfg_req.word = {addr_dm, addr_reg};

      unique casez (acc_req_i.q.data_op)
        SCFGRI,
        SCFGR:
          ssr_cfg_req.write = '0;
        SCFGWI,
        SCFGW: begin
          ssr_cfg_req.write = '1;
          ssr_cfg_req.id = '0; // prevent write-back of result
        end
        default: ;
      endcase
    end

    assign acc_rsp_o.p.id = ssr_cfg_rsp.id;
    assign acc_rsp_o.p.error = 1'b0;
    assign acc_rsp_o.p.data = ssr_cfg_rsp.data;

    cc_stream_to_mem #(
      .mem_req_t (ssr_cfg_req_t),
      .mem_resp_t(ssr_cfg_rsp_t),
      .BufDepth  (1)
    ) i_stream_to_mem (
      .clk_i,
      .rst_ni,
      .clr_i           (1'b0),
      .req_i           (ssr_cfg_req),
      .req_valid_i     (ssr_qvalid),
      .req_ready_o     (ssr_qready),
      .resp_o          (ssr_cfg_rsp),
      .resp_valid_o    (ssr_pvalid),
      .resp_ready_i    (ssr_pready),
      .mem_req_o       (cfg_req),
      .mem_req_valid_o (cfg_req_valid),
      .mem_req_ready_i (cfg_req_ready),
      .mem_resp_i      (cfg_rsp),
      .mem_resp_valid_i(cfg_req_valid_q)
    );

    snitch_ssr_streamer #(
      .NumSsrs   (NumSsrs),
      .RPorts    (3),
      .WPorts    (1),
      .SsrCfgs   (SsrCfgs),
      .SsrRegs   (SsrRegs),
      .AddrWidth (TcdmAddrWidth),
      .DataWidth (DataWidth),
      .UserWidth (TcdmUserWidth),
      .tcdm_req_t(tcdm_req_t),
      .tcdm_rsp_t(tcdm_rsp_t)
    ) i_snitch_ssr_streamer (
      .clk_i,
      .rst_ni           (rst_ni),
      .cfg_word_i       (cfg_req.word),
      .cfg_write_i      (cfg_req.write & cfg_req_valid),
      .cfg_rdata_o      (cfg_rsp_data),
      .cfg_wdata_i      (cfg_req.data),
      .cfg_wready_o     (cfg_req_wready),
      .ssr_raddr_i      (ssr_raddr_i),
      .ssr_rdata_o      (ssr_rdata_o),
      .ssr_rvalid_i     (ssr_rvalid_i),
      .ssr_rready_o     (ssr_rready_o),
      .ssr_rdone_i      (ssr_rdone_i),
      .ssr_waddr_i      (ssr_waddr_i),
      .ssr_wdata_i      (ssr_wdata_i),
      .ssr_wvalid_i     (ssr_wvalid_i),
      .ssr_wready_o     (ssr_wready_o),
      .ssr_wdone_i      (ssr_wdone_i),
      .mem_req_o        (tcdm_req_o),
      .mem_rsp_i        (tcdm_rsp_i),
      .streamctl_done_o (ssr_streamctl_done_o),
      .streamctl_valid_o(ssr_streamctl_valid_o),
      .streamctl_ready_i(ssr_streamctl_ready_i)
    );

  end else begin : gen_no_ssrs
    assign acc_rsp_o.p = '0;
    assign ssr_qready = '0;
    assign ssr_pvalid = '0;
    assign ssr_rdata_o = '0;
    assign ssr_rready_o = '0;
    assign ssr_wready_o = '0;
    assign tcdm_req_o = '0;
    assign ssr_streamctl_done_o = '0;
    assign ssr_streamctl_valid_o = '0;
  end

  // If Xssr is enabled, we should at least have one SSR
  `ASSERT_INIT(InvalidNumSsrs, (!IsaCfg.Xssr) || (NumSsrs >= 1));

endmodule
