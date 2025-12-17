// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "fpu_interface/typedef.svh"

/// FPU Synthesis Wrapper
module snitch_fpu import snitch_pkg::*; #(
  parameter fpnew_pkg::fpu_implementation_t FpuImplementation = '0,
  parameter bit          RVF            = 1,
  parameter bit          RVD            = 1,
  parameter bit          XF16           = 0,
  parameter bit          XF16ALT        = 0,
  parameter bit          XF8            = 0,
  parameter bit          XF8ALT         = 0,
  parameter bit          XFVEC          = 0,
  parameter int unsigned FLEN           = 0,
  parameter bit          RegisterFpuReq = 0,
  parameter bit          RegisterFpuRsp = 0,
  parameter type         TagType        = logic,
  // Derived parameters *do not override*
  // TODO(colluca): this currently does not compile in Verilator (https://github.com/verilator/verilator/issues/6818)
  // localparam type        fpu_req_t      = `FPU_REQ_STRUCT(FLEN, TagType),
  // localparam type        fpu_rsp_t      = `FPU_RSP_STRUCT(FLEN, TagType)
  // Workaround:
  localparam type        fpu_req_chan_t = `FPU_REQ_CHAN_STRUCT(FLEN, TagType),
  localparam type        fpu_req_t = `GENERIC_REQRSP_REQ_STRUCT(fpu_req_chan_t),
  localparam type        fpu_rsp_chan_t = `FPU_RSP_CHAN_STRUCT(FLEN, TagType),
  localparam type        fpu_rsp_t = `GENERIC_REQRSP_RSP_STRUCT(fpu_rsp_chan_t)
) (
  input  logic        clk_i,
  input  logic        rst_ni,
  input  logic [31:0] hart_id_i,
  input  fpu_req_t    req_i,
  output fpu_rsp_t    rsp_o
);

  // TODO(colluca): not needed with workaround in parameter port list
  // Define fpu_req_chan_t and fpu_rsp_chan_t
  // `FPU_TYPEDEF_REQRSP_CHAN_ALL(fpu, FLEN, TagType)

  fpu_req_t fpu_req;
  fpu_rsp_t fpu_rsp;

  generic_reqrsp_cut #(
    .req_chan_t(fpu_req_chan_t),
    .rsp_chan_t(fpu_rsp_chan_t),
    .BypassReq (!RegisterFpuReq),
    .BypassRsp (!RegisterFpuRsp)
  ) i_cut (
    .clk_i,
    .rst_ni,
    .slv_req_i(req_i),
    .slv_rsp_o(rsp_o),
    .mst_req_o(fpu_req),
    .mst_rsp_i(fpu_rsp)
  );

  // FPU configuration
  localparam fpnew_pkg::fpu_features_t FpuFeatures = '{
    Width:         fpnew_pkg::maximum(FLEN, 32),
    EnableVectors: XFVEC,
    EnableNanBox:  1'b1,
    FpFmtMask:     {RVF, RVD, XF16, XF8, XF16ALT, XF8ALT},
    IntFmtMask:    {XFVEC && (XF8 || XF8ALT), XFVEC && (XF16 || XF16ALT), 1'b1, 1'b0}
  };

  fpnew_top #(
    .Features                   (FpuFeatures),
    .Implementation             (FpuImplementation),
    .TagType                    (TagType),
    .CompressedVecCmpResult     (1),
    .StochasticRndImplementation(fpnew_pkg::DEFAULT_RSR)
  ) i_fpu (
    .clk_i,
    .rst_ni,
    .hart_id_i     (hart_id_i),
    .operands_i    (fpu_req.q.operands),
    .rnd_mode_i    (fpu_req.q.rnd_mode),
    .op_i          (fpu_req.q.op),
    .op_mod_i      (fpu_req.q.op_mod),
    .src_fmt_i     (fpu_req.q.src_fmt),
    .dst_fmt_i     (fpu_req.q.dst_fmt),
    .int_fmt_i     (fpu_req.q.int_fmt),
    .vectorial_op_i(fpu_req.q.vectorial_op),
    .tag_i         (fpu_req.q.tag),
    .simd_mask_i   ('1),
    .in_valid_i    (fpu_req.q_valid),
    .in_ready_o    (fpu_rsp.q_ready),
    .flush_i       (1'b0),
    .result_o      (fpu_rsp.p.result),
    .status_o      (fpu_rsp.p.status),
    .tag_o         (fpu_rsp.p.tag),
    .out_valid_o   (fpu_rsp.p_valid),
    .out_ready_i   (fpu_req.p_ready),
    .busy_o        ()
  );

endmodule
