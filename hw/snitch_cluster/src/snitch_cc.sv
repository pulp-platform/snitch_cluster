// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "common_cells/assertions.svh"
`include "common_cells/registers.svh"
`include "snitch_vm/typedef.svh"

/// Snitch Core Complex (CC)
/// Contains the Snitch Integer Core + FPU + Private Accelerators
module snitch_cc #(
  /// Address width of the buses
  parameter int unsigned AddrWidth          = 0,
  /// Data width of the buses.
  parameter int unsigned DataWidth          = 0,
  /// Data width of the AXI DMA buses.
  parameter int unsigned DMADataWidth       = 0,
  /// Id width of the AXI DMA bus.
  parameter int unsigned DMAIdWidth         = 0,
  /// User width of the AXI DMA bus.
  parameter int unsigned DMAUserWidth       = 0,
  parameter int unsigned DMANumAxInFlight   = 0,
  parameter int unsigned DMAReqFifoDepth    = 0,
  parameter int unsigned DMANumChannels     = 0,
  /// Data port request type.
  parameter type         dreq_t             = logic,
  /// Data port response type.
  parameter type         drsp_t             = logic,
  /// TCDM Address Width
  parameter int unsigned TCDMAddrWidth      = 0,
  /// Data port request type.
  parameter type         tcdm_req_t         = logic,
  /// Data port response type.
  parameter type         tcdm_rsp_t         = logic,
  /// TCDM User Payload
  parameter type         tcdm_user_t        = logic,
  parameter type         axi_ar_chan_t      = logic,
  parameter type         axi_aw_chan_t      = logic,
  parameter type         axi_req_t          = logic,
  parameter type         axi_rsp_t          = logic,
  parameter type         hive_req_t         = logic,
  parameter type         hive_rsp_t         = logic,
  parameter type         acc_req_t          = logic,
  parameter type         acc_resp_t         = logic,
  parameter type         dma_events_t       = logic,
  // XIF parameters
  parameter bit          EnableXif          = 1,
  parameter int unsigned XifIdWidth         = 4,
  // XIF port types
  parameter type         x_issue_req_t      = logic,
  parameter type         x_issue_resp_t     = logic,
  parameter type         x_register_t       = logic,
  parameter type         x_commit_t         = logic,
  parameter type         x_result_t         = logic,
  parameter fpnew_pkg::fpu_implementation_t FPUImplementation = '0,
  /// Boot address of core.
  parameter logic [31:0] BootAddr           = 32'h0000_1000,
  /// Reduced-register extension
  parameter bit          RVE                = 0,
  /// Enable F and D Extension
  parameter bit          RVF                = 1,
  parameter bit          RVD                = 1,
  parameter bit          XDivSqrt           = 0,
  parameter bit          XF8                = 0,
  parameter bit          XF8ALT             = 0,
  parameter bit          XF16               = 0,
  parameter bit          XF16ALT            = 0,
  parameter bit          XFVEC              = 0,
  parameter bit          XFDOTP             = 0,
  parameter bit		       Xpulppostmod	      = 0,
  parameter bit          Xpulpabs           = 0,
  parameter bit          Xpulpbitop         = 0,
  parameter bit          Xpulpbr            = 0,
  parameter bit          Xpulpclip          = 0,
  parameter bit          Xpulpmacsi         = 0,
  parameter bit          Xpulpminmax        = 0,
  parameter bit          Xpulpslet          = 0,
  parameter bit          Xpulpvect          = 0,
  parameter bit          Xpulpvectshufflepack = 0,
  /// Enable Snitch DMA
  parameter bit          Xdma               = 0,
  /// Has `frep` support.
  parameter bit          Xfrep              = 1,
  /// Has `SSR` support.
  parameter bit          Xssr               = 1,
  /// Has `COPIFT` support.
  parameter bit          Xcopift            = 1,
  /// Enable private IPU.
  parameter bit          PrivateIpu         = 0,
  /// Has virtual memory support.
  parameter bit          VMSupport          = 1,
  parameter int unsigned NumIntOutstandingLoads = 0,
  parameter int unsigned NumIntOutstandingMem = 0,
  parameter int unsigned NumFPOutstandingLoads = 0,
  parameter int unsigned NumFPOutstandingMem = 0,
  parameter int unsigned NumDTLBEntries = 0,
  parameter int unsigned NumITLBEntries = 0,
  parameter int unsigned NumSequencerInstr = 0,
  parameter int unsigned NumSequencerLoops = 0,
  parameter int unsigned NumSsrs = 0,
  parameter int unsigned SsrMuxRespDepth = 0,
  parameter snitch_ssr_pkg::ssr_cfg_t [NumSsrs-1:0] SsrCfgs = '0,
  parameter logic [NumSsrs-1:0][4:0] SsrRegs = '0,
  /// Add isochronous clock-domain crossings e.g., make it possible to operate
  /// the core in a slower clock domain.
  parameter bit          IsoCrossing        = 0,
  /// Timing Parameters
  /// Insert Pipeline registers into off-loading path (request)
  parameter bit          RegisterOffloadReq = 0,
  /// Insert Pipeline registers into off-loading path (response)
  parameter bit          RegisterOffloadRsp = 0,
  /// Insert Pipeline registers into data memory path (request)
  parameter bit          RegisterCoreReq    = 0,
  /// Insert Pipeline registers into data memory path (response)
  parameter bit          RegisterCoreRsp    = 0,
  /// Insert Pipeline register into the FPU data path (request)
  parameter bit          RegisterFPUReq     = 0,
  /// Insert Pipeline registers after sequencer
  parameter bit          RegisterSequencer  = 0,
  /// Insert Pipeline registers immediately before FPU datapath
  parameter bit          RegisterFPUIn      = 0,
  /// Insert Pipeline registers immediately after FPU datapath
  parameter bit          RegisterFPUOut     = 0,
  parameter snitch_pma_pkg::snitch_pma_t SnitchPMACfg = '{default: 0},
  /// Consistency Address Queue (CAQ) parameters.
  parameter int unsigned CaqDepth     = 0,
  parameter int unsigned CaqTagWidth  = 0,
  /// Enable debug support.
  parameter bit          DebugSupport = 1,
  /// Optional fixed TCDM alias.
  parameter bit          TCDMAliasEnable = 1'b0,
  parameter logic [AddrWidth-1:0] TCDMAliasStart  = '0,
  /// Derived parameter *Do not override*
  parameter int unsigned TCDMPorts = (NumSsrs > 1 ? NumSsrs : 1),
  parameter type addr_t = logic [AddrWidth-1:0],
  parameter type data_t = logic [DataWidth-1:0]
) (
  input  logic                              clk_i,
  input  logic                              clk_d2_i,
  input  logic                              rst_ni,
  input  logic                              rst_int_ss_ni,
  input  logic                              rst_fp_ss_ni,
  input  logic [31:0]                       hart_id_i,
  input  snitch_pkg::interrupts_t           irq_i,
  output hive_req_t                         hive_req_o,
  input  hive_rsp_t                         hive_rsp_i,
  // Core data ports
  output dreq_t                             data_req_o,
  input  drsp_t                             data_rsp_i,
  // TCDM Streamer Ports
  output tcdm_req_t [TCDMPorts-1:0]         tcdm_req_o,
  input  tcdm_rsp_t [TCDMPorts-1:0]         tcdm_rsp_i,
  // X Interface - Issue ports
  output x_issue_req_t                      x_issue_req_o,
  input  x_issue_resp_t                     x_issue_resp_i,
  output logic                              x_issue_valid_o,
  input  logic                              x_issue_ready_i,
  output x_register_t                       x_register_o,
  output logic                              x_register_valid_o,
  input  logic                              x_register_ready_i,
  output x_commit_t                         x_commit_o,
  output logic                              x_commit_valid_o,
  // X Interface - Result ports
  input  x_result_t                         x_result_i,
  input  logic                              x_result_valid_i,
  output logic                              x_result_ready_o,
  // DMA ports
  output axi_req_t    [DMANumChannels-1:0]  axi_dma_req_o,
  input  axi_rsp_t    [DMANumChannels-1:0]  axi_dma_res_i,
  output logic        [DMANumChannels-1:0]  axi_dma_busy_o,
  output dma_events_t [DMANumChannels-1:0]  axi_dma_events_o,
  // Core event strobes
  output snitch_pkg::core_events_t          core_events_o,
  input  addr_t                             tcdm_addr_base_i,
  // Cluster HW barrier
  output logic                              barrier_o,
  input  logic                              barrier_i
);

  // FMA architecture is "merged" -> mulexp and macexp instructions are supported
  localparam bit XFauxMerged  = (FPUImplementation.UnitTypes[3] == fpnew_pkg::MERGED);
  localparam bit FPEn = RVF | RVD | XF16 | XF16ALT | XF8 | XF8ALT | XFVEC | XFauxMerged | XFDOTP;
  localparam bit Xpulpv2 = Xpulpabs | Xpulpbitop | Xpulpbr | Xpulpclip | Xpulpmacsi | Xpulpminmax | Xpulpslet | Xpulpvect | Xpulpvectshufflepack;
  localparam int unsigned FLEN = RVD     ? 64 : // D ext.
                          RVF     ? 32 : // F ext.
                          XF16    ? 16 : // Xf16 ext.
                          XF16ALT ? 16 : // Xf16alt ext.
                          XF8     ? 8 :  // Xf8 ext.
                          XF8ALT  ? 8 :  // Xf8alt ext.
                          0;             // Unused in case of no FP

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

  acc_req_t acc_snitch_demux;
  acc_req_t acc_snitch_demux_q;
  acc_resp_t acc_demux_snitch;
  acc_resp_t acc_demux_snitch_q;
  acc_resp_t [snitch_pkg::NUM_ACC-1:0] acc_demux_snitch_in;
  acc_req_t fpss_req;
  acc_req_t dma_req;
  acc_req_t ipu_req;
  acc_req_t ssr_req;
  acc_resp_t fpss_resp;
  acc_resp_t dma_resp;
  acc_resp_t ipu_resp;
  acc_resp_t ssr_resp;

  logic acc_snitch_demux_qvalid, acc_snitch_demux_qready;
  logic acc_snitch_demux_qvalid_q, acc_snitch_demux_qready_q;
  logic [snitch_pkg::NUM_ACC-1:0] acc_snitch_demux_out_qvalid, acc_snitch_demux_out_qready;
  logic fpss_qvalid, fpss_qready;
  logic dma_qvalid, dma_qready;
  logic ssr_qvalid, ssr_qready;
  logic ipu_qvalid, ipu_qready;

  logic fpss_pvalid, fpss_pready;
  logic dma_pvalid, dma_pready;
  logic ssr_pvalid, ssr_pready;
  logic ipu_pvalid, ipu_pready;
  logic acc_demux_snitch_valid, acc_demux_snitch_ready;
  logic acc_demux_snitch_valid_q, acc_demux_snitch_ready_q;
  logic [snitch_pkg::NUM_ACC-1:0] acc_demux_snitch_in_valid, acc_demux_snitch_in_ready;

  logic [31:0] i2f_rdata;
  logic        i2f_rvalid;
  logic        i2f_rready;
  logic [31:0] f2i_wdata;
  logic        f2i_wvalid;
  logic        f2i_wready;
  logic        en_copift;

  fpnew_pkg::roundmode_e fpu_rnd_mode;
  fpnew_pkg::fmt_mode_t  fpu_fmt_mode;
  fpnew_pkg::status_t    fpu_status;

  snitch_pkg::core_events_t snitch_events;
  snitch_pkg::core_events_t fpu_events;

  // Snitch Integer Core
  dreq_t snitch_dreq_d, snitch_dreq_q, merged_dreq;
  drsp_t snitch_drsp_d, snitch_drsp_q, merged_drsp;

  logic wake_up;

  // Consistency Address Queue (CAQ) interface
  logic caq_pvalid, caq_pvalid_q;

  `SNITCH_VM_TYPEDEF(AddrWidth)

  snitch #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .acc_req_t (acc_req_t),
    .acc_resp_t (acc_resp_t),
    .dreq_t (dreq_t),
    .drsp_t (drsp_t),
    .pa_t (pa_t),
    .l0_pte_t (l0_pte_t),
    .EnableXif (EnableXif),
    .XifIdWidth (XifIdWidth),
    .x_issue_req_t (x_issue_req_t),
    .x_issue_resp_t (x_issue_resp_t),
    .x_register_t (x_register_t),
    .x_commit_t (x_commit_t),
    .x_result_t (x_result_t),
    .BootAddr (BootAddr),
    .SnitchPMACfg (SnitchPMACfg),
    .NumIntOutstandingLoads (NumIntOutstandingLoads),
    .NumIntOutstandingMem (NumIntOutstandingMem),
    .VMSupport (VMSupport),
    .NumDTLBEntries (NumDTLBEntries),
    .NumITLBEntries (NumITLBEntries),
    .RVE (RVE),
    .FP_EN (FPEn),
    .Xdma (Xdma),
    .Xssr (Xssr),
    .Xpulppostmod (Xpulppostmod),
    .Xpulpabs (Xpulpabs),
    .Xpulpbitop (Xpulpbitop),
    .Xpulpbr (Xpulpbr),
    .Xpulpclip (Xpulpclip),
    .Xpulpmacsi (Xpulpmacsi),
    .Xpulpminmax (Xpulpminmax),
    .Xpulpslet (Xpulpslet),
    .Xpulpvect (Xpulpvect),
    .Xpulpvectshufflepack (Xpulpvectshufflepack),
    .Xpulpv2 (Xpulpv2),
    .Xcopift (Xcopift),
    .RVF (RVF),
    .RVD (RVD),
    .XDivSqrt (XDivSqrt),
    .XF16 (XF16),
    .XF16ALT (XF16ALT),
    .XF8 (XF8),
    .XF8ALT (XF8ALT),
    .XFVEC (XFVEC),
    .XFDOTP (XFDOTP),
    .XFAUX (XFauxMerged),
    .FLEN (FLEN),
    .CaqDepth (CaqDepth),
    .CaqTagWidth (CaqTagWidth),
    .DebugSupport (DebugSupport)
  ) i_snitch (
    .clk_i ( clk_d2_i ), // if necessary operate on half the frequency
    .rst_i ( ~rst_ni ),
    .hart_id_i,
    .irq_i,
    .flush_i_valid_o (hive_req_o.flush_i_valid),
    .flush_i_ready_i (hive_rsp_i.flush_i_ready),
    .inst_addr_o (hive_req_o.inst_addr),
    .inst_cacheable_o (hive_req_o.inst_cacheable),
    .inst_data_i (hive_rsp_i.inst_data),
    .inst_valid_o (hive_req_o.inst_valid),
    .inst_ready_i (hive_rsp_i.inst_ready),
    .acc_qreq_o ( acc_snitch_demux ),
    .acc_qvalid_o ( acc_snitch_demux_qvalid ),
    .acc_qready_i ( acc_snitch_demux_qready ),
    .acc_prsp_i ( acc_demux_snitch ),
    .acc_pvalid_i ( acc_demux_snitch_valid ),
    .acc_pready_o ( acc_demux_snitch_ready ),
    .x_issue_req_o ( x_issue_req_o ),
    .x_issue_resp_i ( x_issue_resp_i ),
    .x_issue_valid_o ( x_issue_valid_o ),
    .x_issue_ready_i ( x_issue_ready_i ),
    .x_register_o ( x_register_o ),
    .x_register_valid_o ( x_register_valid_o ),
    .x_register_ready_i ( x_register_ready_i ),
    .x_commit_o ( x_commit_o ),
    .x_commit_valid_o ( x_commit_valid_o ),
    .x_result_i ( x_result_i ),
    .x_result_valid_i ( x_result_valid_i ),
    .x_result_ready_o ( x_result_ready_o ),
    .i2f_rdata_o ( i2f_rdata ),
    .i2f_rvalid_o ( i2f_rvalid ),
    .i2f_rready_i ( i2f_rready ),
    .f2i_wdata_i ( f2i_wdata ),
    .f2i_wvalid_i ( f2i_wvalid ),
    .f2i_wready_o ( f2i_wready ),
    .caq_pvalid_i ( caq_pvalid_q ),
    .data_req_o ( snitch_dreq_d ),
    .data_rsp_i ( snitch_drsp_d ),
    .ptw_valid_o (hive_req_o.ptw_valid),
    .ptw_ready_i (hive_rsp_i.ptw_ready),
    .ptw_va_o (hive_req_o.ptw_va),
    .ptw_ppn_o (hive_req_o.ptw_ppn),
    .ptw_pte_i (hive_rsp_i.ptw_pte),
    .ptw_is_4mega_i (hive_rsp_i.ptw_is_4mega),
    .fpu_rnd_mode_o ( fpu_rnd_mode ),
    .fpu_fmt_mode_o ( fpu_fmt_mode ),
    .fpu_status_i ( fpu_status ),
    .core_events_o ( snitch_events),
    .barrier_o ( barrier_o ),
    .barrier_i ( barrier_i ),
    .en_copift_o ( en_copift )
  );

  reqrsp_iso #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .req_t (dreq_t),
    .rsp_t (drsp_t),
    .BypassReq (!RegisterCoreReq),
    .BypassRsp (!IsoCrossing && !RegisterCoreRsp)
  ) i_reqrsp_iso (
    .src_clk_i (clk_d2_i),
    .src_rst_ni (rst_ni),
    .src_req_i (snitch_dreq_d),
    .src_rsp_o (snitch_drsp_d),
    .dst_clk_i (clk_i),
    .dst_rst_ni (rst_ni),
    .dst_req_o (snitch_dreq_q),
    .dst_rsp_i (snitch_drsp_q)
  );

  // Cut off-loading request path
  isochronous_spill_register #(
    .T      (acc_req_t),
    .Bypass (!IsoCrossing && !RegisterOffloadReq)
  ) i_spill_register_acc_demux_req (
    .src_clk_i   ( clk_d2_i                  ),
    .src_rst_ni  ( rst_ni                    ),
    .src_valid_i ( acc_snitch_demux_qvalid   ),
    .src_ready_o ( acc_snitch_demux_qready   ),
    .src_data_i  ( acc_snitch_demux          ),
    .dst_clk_i   ( clk_i                     ),
    .dst_rst_ni  ( rst_ni                    ),
    .dst_valid_o ( acc_snitch_demux_qvalid_q ),
    .dst_ready_i ( acc_snitch_demux_qready_q ),
    .dst_data_o  ( acc_snitch_demux_q        )
  );

  // Cut off-loading response path
  isochronous_spill_register #(
    .T (acc_resp_t),
    .Bypass (!IsoCrossing && !RegisterOffloadRsp)
  ) i_spill_register_acc_demux_resp (
    .src_clk_i   ( clk_i                    ),
    .src_rst_ni  ( rst_ni                   ),
    .src_valid_i ( acc_demux_snitch_valid_q ),
    .src_ready_o ( acc_demux_snitch_ready_q ),
    .src_data_i  ( acc_demux_snitch_q       ),
    .dst_clk_i   ( clk_d2_i                 ),
    .dst_rst_ni  ( rst_ni                   ),
    .dst_valid_o ( acc_demux_snitch_valid   ),
    .dst_ready_i ( acc_demux_snitch_ready   ),
    .dst_data_o  ( acc_demux_snitch         )
  );

  // Cut CAQ response for proper handshake with divided clock.
  // TODO: Check whether this should always be cut for timing.
  isochronous_spill_register #(
    .T (logic),
    .Bypass (!IsoCrossing)
  ) i_spill_register_caq_pvalid (
    .src_clk_i   ( clk_i  ),
    .src_rst_ni  ( rst_ni ),
    .src_valid_i ( caq_pvalid ),
    .src_ready_o (  ),
    .src_data_i  ( '0 ),
    .dst_clk_i   ( clk_d2_i ),
    .dst_rst_ni  ( rst_ni   ),
    .dst_valid_o ( caq_pvalid_q ),
    .dst_ready_i ( 1'b1 ),
    .dst_data_o  ( )
  );

  // Accelerator Demux Port
  stream_demux #(
    .N_OUP ( snitch_pkg::NUM_ACC )
  ) i_stream_demux_offload (
    .inp_valid_i  ( acc_snitch_demux_qvalid_q ),
    .inp_ready_o  ( acc_snitch_demux_qready_q ),
    .oup_sel_i    ( acc_snitch_demux_q.addr[$clog2(snitch_pkg::NUM_ACC)-1:0] ),
    .oup_valid_o  ( acc_snitch_demux_out_qvalid ),
    .oup_ready_i  ( acc_snitch_demux_out_qready )
  );

  assign fpss_qvalid = acc_snitch_demux_out_qvalid[snitch_pkg::FP_SS];
  if (PrivateIpu) begin : gen_private_ipu_connection
    assign ipu_qvalid = acc_snitch_demux_out_qvalid[snitch_pkg::IPU];
    assign hive_req_o.acc_qvalid = 1'b0;
  end else begin : gen_shared_ipu_connection
    assign hive_req_o.acc_qvalid = acc_snitch_demux_out_qvalid[snitch_pkg::IPU];
    assign ipu_qvalid = 1'b0;
  end
  assign dma_qvalid = acc_snitch_demux_out_qvalid[snitch_pkg::DMA_SS];
  assign ssr_qvalid = acc_snitch_demux_out_qvalid[snitch_pkg::SSR_CFG];

  assign acc_snitch_demux_out_qready[snitch_pkg::FP_SS] = fpss_qready;
  assign acc_snitch_demux_out_qready[snitch_pkg::IPU] = PrivateIpu ? ipu_qready : hive_rsp_i.acc_qready;
  assign acc_snitch_demux_out_qready[snitch_pkg::DMA_SS] = dma_qready;
  assign acc_snitch_demux_out_qready[snitch_pkg::SSR_CFG] = ssr_qready;

  assign fpss_req = acc_snitch_demux_q;
  assign ipu_req = acc_snitch_demux_q;
  assign hive_req_o.acc_req = acc_snitch_demux_q;
  assign dma_req = acc_snitch_demux_q;
  assign ssr_req = acc_snitch_demux_q;

  stream_arbiter #(
    .DATA_T      ( acc_resp_t ),
    .N_INP       ( snitch_pkg::NUM_ACC    )
  ) i_stream_arbiter_offload (
    .clk_i       ( clk_i                     ),
    .rst_ni      ( rst_ni                    ),
    .inp_data_i  ( acc_demux_snitch_in       ),
    .inp_valid_i ( acc_demux_snitch_in_valid ),
    .inp_ready_o ( acc_demux_snitch_in_ready ),
    .oup_data_o  ( acc_demux_snitch_q        ),
    .oup_valid_o ( acc_demux_snitch_valid_q  ),
    .oup_ready_i ( acc_demux_snitch_ready_q  )
  );

  assign acc_demux_snitch_in[snitch_pkg::FP_SS] = fpss_resp;
  assign acc_demux_snitch_in[snitch_pkg::IPU] = PrivateIpu ? ipu_resp : hive_rsp_i.acc_resp;
  assign acc_demux_snitch_in[snitch_pkg::DMA_SS] = dma_resp;
  assign acc_demux_snitch_in[snitch_pkg::SSR_CFG] = ssr_resp;

  assign acc_demux_snitch_in_valid[snitch_pkg::FP_SS] = fpss_pvalid;
  assign acc_demux_snitch_in_valid[snitch_pkg::IPU] = PrivateIpu ? ipu_pvalid : hive_rsp_i.acc_pvalid;
  assign acc_demux_snitch_in_valid[snitch_pkg::DMA_SS] = dma_pvalid;
  assign acc_demux_snitch_in_valid[snitch_pkg::SSR_CFG] = ssr_pvalid;

  assign fpss_pready = acc_demux_snitch_in_ready[snitch_pkg::FP_SS];
  assign ipu_pready = acc_demux_snitch_in_ready[snitch_pkg::IPU];
  assign hive_req_o.acc_pready = acc_demux_snitch_in_ready[snitch_pkg::IPU];
  assign dma_pready = acc_demux_snitch_in_ready[snitch_pkg::DMA_SS];
  assign ssr_pready = acc_demux_snitch_in_ready[snitch_pkg::SSR_CFG];

  if (Xdma) begin : gen_dma
    idma_inst64_top #(
      .AxiAddrWidth (AddrWidth),
      .AxiDataWidth (DMADataWidth),
      .AxiIdWidth (DMAIdWidth),
      .AxiUserWidth (DMAUserWidth),
      .NumAxInFlight (DMANumAxInFlight),
      .DMAReqFifoDepth (DMAReqFifoDepth),
      .NumChannels (DMANumChannels),
      .DMATracing (1),
      .axi_ar_chan_t (axi_ar_chan_t),
      .axi_aw_chan_t (axi_aw_chan_t),
      .axi_req_t (axi_req_t),
      .axi_res_t (axi_rsp_t),
      .acc_req_t (acc_req_t),
      .acc_res_t (acc_resp_t),
      .dma_events_t (dma_events_t)
    ) i_idma_inst64_top (
      .clk_i,
      .rst_ni,
      .testmode_i      ( 1'b0             ),
      .axi_req_o       ( axi_dma_req_o    ),
      .axi_res_i       ( axi_dma_res_i    ),
      .busy_o          ( axi_dma_busy_o   ),
      .acc_req_i       ( dma_req          ),
      .acc_req_valid_i ( dma_qvalid       ),
      .acc_req_ready_o ( dma_qready       ),
      .acc_res_o       ( dma_resp         ),
      .acc_res_valid_o ( dma_pvalid       ),
      .acc_res_ready_i ( dma_pready       ),
      .hart_id_i       ( hart_id_i        ),
      .events_o        ( axi_dma_events_o )
    );

  // no DMA instanciated
  end else begin : gen_no_dma
    // tie-off unused signals
    assign axi_dma_req_o    = '0;
    assign axi_dma_busy_o   = '0;
    assign dma_qready       = '0;
    assign dma_resp         = '0;
    assign dma_pvalid       = '0;
    assign axi_dma_events_o = '0;
  end

  // IPU
  if (PrivateIpu) begin : gen_ipu
    snitch_ipu #(
      .IdWidth   (5),
      .Xpulpv2   (Xpulpv2),
      .acc_resp_t(acc_resp_t),
      .acc_req_t (acc_req_t)
    ) i_snitch_ipu (
      .clk_i,
      .rst_ni,
      .acc_req_i       (ipu_req),
      .acc_req_valid_i (ipu_qvalid),
      .acc_req_ready_o (ipu_qready),
      .acc_resp_o      (ipu_resp),
      .acc_resp_valid_o(ipu_pvalid),
      .acc_resp_ready_i(ipu_pready)
    );
  end else begin : gen_no_ipu
    assign ipu_resp = '0;
    assign ipu_qready = 1'b0;
    assign ipu_pvalid = '0;
  end

  // pragma translate_off
  snitch_pkg::fpu_trace_port_t fpu_trace;
  snitch_pkg::fpu_sequencer_trace_port_t fpu_sequencer_trace;
  // pragma translate_on

  logic  [2:0][4:0] ssr_raddr;
  data_t [2:0]      ssr_rdata;
  logic  [2:0]      ssr_rvalid;
  logic  [2:0]      ssr_rready;
  logic  [2:0]      ssr_rdone;
  logic  [0:0][4:0] ssr_waddr;
  data_t [0:0]      ssr_wdata;
  logic  [0:0]      ssr_wvalid;
  logic  [0:0]      ssr_wready;
  logic  [0:0]      ssr_wdone;
  logic             ssr_streamctl_done;
  logic             ssr_streamctl_valid;
  logic             ssr_streamctl_ready;

  if (FPEn) begin : gen_fpu
    snitch_pkg::core_events_t fp_ss_core_events;

    dreq_t fpu_dreq;
    drsp_t fpu_drsp;

    snitch_fp_ss #(
      .AddrWidth (AddrWidth),
      .DataWidth (DataWidth),
      .NumFPOutstandingLoads (NumFPOutstandingLoads),
      .NumFPOutstandingMem (NumFPOutstandingMem),
      .NumFPUSequencerInstr (NumSequencerInstr),
      .NumFPUSequencerLoops (NumSequencerLoops),
      .FPUImplementation (FPUImplementation),
      .NumSsrs (NumSsrs),
      .SsrRegs (SsrRegs),
      .dreq_t (dreq_t),
      .drsp_t (drsp_t),
      .acc_req_t (acc_req_t),
      .acc_resp_t (acc_resp_t),
      .RegisterSequencer (RegisterSequencer),
      .RegisterFPUIn (RegisterFPUIn),
      .RegisterFPUOut (RegisterFPUOut),
      .Xfrep (Xfrep),
      .Xssr (Xssr),
      .Xcopift (Xcopift),
      .RVF (RVF),
      .RVD (RVD),
      .XF16 (XF16),
      .XF16ALT (XF16ALT),
      .XF8 (XF8),
      .XF8ALT (XF8ALT),
      .XFVEC (XFVEC),
      .FLEN (FLEN)
    ) i_snitch_fp_ss (
      .clk_i,
      .rst_i            ( ~rst_ni | (~rst_fp_ss_ni)   ),
      // pragma translate_off
      .trace_port_o            ( fpu_trace           ),
      .sequencer_tracer_port_o ( fpu_sequencer_trace ),
      // pragma translate_on
      .hart_id_i        ( hart_id_i      ),
      .acc_req_i        ( fpss_req       ),
      .acc_req_valid_i  ( fpss_qvalid    ),
      .acc_req_ready_o  ( fpss_qready    ),
      .acc_resp_o       ( fpss_resp      ),
      .acc_resp_valid_o ( fpss_pvalid    ),
      .acc_resp_ready_i ( fpss_pready    ),
      .i2f_rdata_i      ( i2f_rdata      ),
      .i2f_rvalid_i     ( i2f_rvalid     ),
      .i2f_rready_o     ( i2f_rready     ),
      .f2i_wdata_o      ( f2i_wdata      ),
      .f2i_wvalid_o     ( f2i_wvalid     ),
      .f2i_wready_i     ( f2i_wready     ),
      .caq_pvalid_o     ( caq_pvalid     ),
      .data_req_o       ( fpu_dreq       ),
      .data_rsp_i       ( fpu_drsp       ),
      .fpu_rnd_mode_i   ( fpu_rnd_mode   ),
      .fpu_fmt_mode_i   ( fpu_fmt_mode   ),
      .fpu_status_o     ( fpu_status     ),
      .ssr_raddr_o      ( ssr_raddr      ),
      .ssr_rdata_i      ( ssr_rdata      ),
      .ssr_rvalid_o     ( ssr_rvalid     ),
      .ssr_rready_i     ( ssr_rready     ),
      .ssr_rdone_o      ( ssr_rdone      ),
      .ssr_waddr_o      ( ssr_waddr      ),
      .ssr_wdata_o      ( ssr_wdata      ),
      .ssr_wvalid_o     ( ssr_wvalid     ),
      .ssr_wready_i     ( ssr_wready     ),
      .ssr_wdone_o      ( ssr_wdone      ),
      .streamctl_done_i   ( ssr_streamctl_done  ),
      .streamctl_valid_i  ( ssr_streamctl_valid ),
      .streamctl_ready_o  ( ssr_streamctl_ready ),
      .core_events_o      ( fp_ss_core_events   ),
      .en_copift_i ( en_copift )
    );

    reqrsp_mux #(
      .NrPorts (2),
      .AddrWidth (AddrWidth),
      .DataWidth (DataWidth),
      .req_t (dreq_t),
      .rsp_t (drsp_t),
      // TODO(zarubaf): Wire-up to top-level.
      .RespDepth (8),
      .RegisterReq ({RegisterFPUReq, 1'b0})
    ) i_reqrsp_mux (
      .clk_i,
      .rst_ni,
      .slv_req_i ({fpu_dreq, snitch_dreq_q}),
      .slv_rsp_o ({fpu_drsp, snitch_drsp_q}),
      .mst_req_o (merged_dreq),
      .mst_rsp_i (merged_drsp),
      .idx_o (/*not connected*/)
    );

    assign core_events_o.issue_fpu = fp_ss_core_events.issue_fpu;
    assign core_events_o.issue_fpu_seq = fp_ss_core_events.issue_fpu_seq;
    assign core_events_o.issue_core_to_fpu = fp_ss_core_events.issue_core_to_fpu;

  end else begin : gen_no_fpu
    assign fpu_status = '0;

    assign ssr_raddr = '0;
    assign ssr_rvalid = '0;
    assign ssr_rdone = '0;
    assign ssr_waddr = '0;
    assign ssr_wdata = '0;
    assign ssr_wvalid = '0;
    assign ssr_wdone = '0;

    assign fpss_qready     = '0;
    assign fpss_resp.data  = '0;
    assign fpss_resp.id    = '0;
    assign fpss_resp.error = '0;
    assign fpss_pvalid     = '0;

    assign caq_pvalid = '0;

    assign merged_dreq = snitch_dreq_q;
    assign snitch_drsp_q = merged_drsp;

    assign core_events_o.issue_fpu = '0;
    assign core_events_o.issue_fpu_seq = '0;
    assign core_events_o.issue_core_to_fpu = '0;
  end

  // Decide whether to go to SoC or TCDM
  dreq_t data_tcdm_req;
  drsp_t data_tcdm_rsp;
  localparam int unsigned SelectWidth = cf_math_pkg::idx_width(2);
  typedef logic [SelectWidth-1:0] select_t;
  select_t slave_select;
  reqrsp_demux #(
    .NrPorts (2),
    .req_t (dreq_t),
    .rsp_t (drsp_t),
    // TODO(zarubaf): Make a parameter.
    .RespDepth (4)
  ) i_reqrsp_demux (
    .clk_i,
    .rst_ni,
    .slv_select_i (slave_select),
    .slv_req_i (merged_dreq),
    .slv_rsp_o (merged_drsp),
    .mst_req_o ({data_tcdm_req, data_req_o}),
    .mst_rsp_i ({data_tcdm_rsp, data_rsp_i})
  );

  typedef struct packed {
    int unsigned idx;
    logic [AddrWidth-1:0] base;
    logic [AddrWidth-1:0] mask;
  } reqrsp_rule_t;

  reqrsp_rule_t [TCDMAliasEnable:0] addr_map;
  assign addr_map[0] = '{
    idx: 1,
    base: tcdm_addr_base_i,
    mask: ({AddrWidth{1'b1}} << TCDMAddrWidth)
  };
  if (TCDMAliasEnable) begin : gen_tcdm_alias_rule
    assign addr_map[1] = '{
      idx: 1,
      base: TCDMAliasStart,
      mask: ({AddrWidth{1'b1}} << TCDMAddrWidth)
    };
  end

  addr_decode_napot #(
    .NoIndices (2),
    .NoRules (1 + TCDMAliasEnable),
    .addr_t (logic [AddrWidth-1:0]),
    .rule_t (reqrsp_rule_t)
  ) i_addr_decode_napot (
    .addr_i (merged_dreq.q.addr),
    .addr_map_i (addr_map),
    .idx_o (slave_select),
    .dec_valid_o (),
    .dec_error_o (),
    .en_default_idx_i (1'b1),
    .default_idx_i ('0)
  );

  tcdm_req_t core_tcdm_req;
  tcdm_rsp_t core_tcdm_rsp;

  reqrsp_to_tcdm #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    // TODO(zarubaf): Make a parameter.
    .BufDepth (4),
    .reqrsp_req_t (dreq_t),
    .reqrsp_rsp_t (drsp_t),
    .tcdm_req_t (tcdm_req_t),
    .tcdm_rsp_t (tcdm_rsp_t)
  ) i_reqrsp_to_tcdm (
    .clk_i,
    .rst_ni,
    .reqrsp_req_i (data_tcdm_req),
    .reqrsp_rsp_o (data_tcdm_rsp),
    .tcdm_req_o (core_tcdm_req),
    .tcdm_rsp_i (core_tcdm_rsp)
  );

  // ----
  // SSRs
  // ----
  if (Xssr) begin : gen_ssrs
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

    always_comb begin
      import riscv_instr::*;
      automatic logic [11:0] addr;
      automatic logic [4:0] addr_dm;
      automatic logic [6:0] addr_reg;

      ssr_cfg_req.id = acc_snitch_demux_q.id;
      ssr_cfg_req.data = acc_snitch_demux_q.data_arga[31:0];
      ssr_cfg_req.word = '0;
      ssr_cfg_req.write = '0;

      addr = '0;
      unique casez (acc_snitch_demux_q.data_op)
        SCFGRI,
        SCFGWI: begin
          addr = acc_snitch_demux_q.data_op[31:20];
        end
        SCFGR,
        SCFGW: begin
          addr = acc_snitch_demux_q.data_argb[31:0];
        end
        default: ;
      endcase

      addr_reg = addr[11:5];
      addr_dm = addr[4:0];
      ssr_cfg_req.word = {addr_dm, addr_reg};

      unique casez (acc_snitch_demux_q.data_op)
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

    assign ssr_resp.id = ssr_cfg_rsp.id;
    assign ssr_resp.error = 1'b0;
    assign ssr_resp.data = ssr_cfg_rsp.data;

    stream_to_mem #(
      .mem_req_t (ssr_cfg_req_t),
      .mem_resp_t (ssr_cfg_rsp_t),
      .BufDepth (1)
    ) i_stream_to_mem (
      .clk_i,
      .rst_ni,
      .req_i (ssr_cfg_req),
      .req_valid_i (ssr_qvalid),
      .req_ready_o (ssr_qready),
      .resp_o (ssr_cfg_rsp),
      .resp_valid_o (ssr_pvalid),
      .resp_ready_i (ssr_pready),
      .mem_req_o (cfg_req),
      .mem_req_valid_o (cfg_req_valid),
      .mem_req_ready_i (cfg_req_ready),
      .mem_resp_i (cfg_rsp),
      .mem_resp_valid_i (cfg_req_valid_q)
    );

    // If Xssr is enabled, we should at least have one SSR
    `ASSERT_INIT(CheckSsrWithXssr, NumSsrs >= 1);

    snitch_ssr_streamer #(
      .NumSsrs (NumSsrs),
      .RPorts (3),
      .WPorts (1),
      .SsrCfgs (SsrCfgs),
      .SsrRegs (SsrRegs),
      .AddrWidth (TCDMAddrWidth),
      .DataWidth (DataWidth),
      .tcdm_req_t (tcdm_req_t),
      .tcdm_rsp_t (tcdm_rsp_t),
      .tcdm_user_t (tcdm_user_t)
    ) i_snitch_ssr_streamer (
      .clk_i,
      .rst_ni         ( rst_ni    ),
      .cfg_word_i     ( cfg_req.word  ),
      .cfg_write_i    ( cfg_req.write & cfg_req_valid ),
      .cfg_rdata_o    ( cfg_rsp_data ),
      .cfg_wdata_i    ( cfg_req.data ),
      .cfg_wready_o   ( cfg_req_wready ),

      .ssr_raddr_i    ( ssr_raddr  ),
      .ssr_rdata_o    ( ssr_rdata  ),
      .ssr_rvalid_i   ( ssr_rvalid ),
      .ssr_rready_o   ( ssr_rready ),
      .ssr_rdone_i    ( ssr_rdone  ),
      .ssr_waddr_i    ( ssr_waddr  ),
      .ssr_wdata_i    ( ssr_wdata  ),
      .ssr_wvalid_i   ( ssr_wvalid ),
      .ssr_wready_o   ( ssr_wready ),
      .ssr_wdone_i    ( ssr_wdone  ),
      .mem_req_o      ( ssr_req    ),
      .mem_rsp_i      ( ssr_rsp    ),
      .streamctl_done_o   ( ssr_streamctl_done  ),
      .streamctl_valid_o  ( ssr_streamctl_valid ),
      .streamctl_ready_i  ( ssr_streamctl_ready )
    );

  if (NumSsrs > 1) begin : gen_multi_ssr
    assign ssr_rsp = {tcdm_rsp_i[NumSsrs-1:1], tcdm_rsp};
    assign {tcdm_req_o[NumSsrs-1:1], tcdm_req} = ssr_req;
  end else begin : gen_one_ssr
    assign ssr_rsp = tcdm_rsp;
    assign tcdm_req = ssr_req;
  end

  tcdm_mux #(
    .NrPorts (2),
    .AddrWidth (TCDMAddrWidth),
    .DataWidth (DataWidth),
    .RespDepth (SsrMuxRespDepth),
    // TODO(zarubaf): USer type
    .tcdm_req_t (tcdm_req_t),
    .tcdm_rsp_t (tcdm_rsp_t),
    .user_t (tcdm_user_t)
  ) i_tcdm_mux (
    .clk_i,
    .rst_ni,
    .slv_req_i({core_tcdm_req, tcdm_req}),
    .slv_rsp_o({core_tcdm_rsp, tcdm_rsp}),
    .mst_req_o(tcdm_req_o[0]),
    .mst_rsp_i(tcdm_rsp_i[0])
  );

  end else begin : gen_no_ssrs
    // Connect single TCDM port
    assign tcdm_req_o[0] = core_tcdm_req;
    assign core_tcdm_rsp = tcdm_rsp_i[0];
    // Tie off SSR insruction stream
    assign ssr_qready     = '0;
    assign ssr_resp       = '0;
    assign ssr_pvalid     = '0;
    // Tie off SSR data stream
    assign ssr_rdata      = '0;
    assign ssr_rready     = '0;
    assign ssr_wready     = '0;
    // Tie off SSR stream control
    assign ssr_streamctl_done   = '0;
    assign ssr_streamctl_valid  = '0;
  end

  // Core events for performance counters
  assign core_events_o.retired_instr = snitch_events.retired_instr;
  assign core_events_o.retired_load = snitch_events.retired_load;
  assign core_events_o.retired_i = snitch_events.retired_i;
  assign core_events_o.retired_acc = snitch_events.retired_acc;

  // --------------------------
  // Tracer
  // --------------------------
  // pragma translate_off
  int f;
  string fn;
  logic [63:0] cycle;
  initial begin
    // We need to schedule the assignment into a safe region, otherwise
    // `hart_id_i` won't have a value assigned at the beginning of the first
    // delta cycle.
`ifndef VERILATOR
    #0;
`endif
    $system("mkdir logs -p");
    $sformat(fn, "logs/trace_hart_%05x.dasm", hart_id_i);
    f = $fopen(fn, "w");
    $display("[Tracer] Logging Hart %d to %s", hart_id_i, fn);
  end

  // verilog_lint: waive-start always-ff-non-blocking
  always_ff @(posedge clk_i or negedge rst_ni) begin
    automatic string trace_entry;
    automatic string extras_str;
    automatic snitch_pkg::snitch_trace_port_t extras_snitch;
    automatic snitch_pkg::fpu_trace_port_t extras_fpu;
    automatic snitch_pkg::fpu_sequencer_trace_port_t extras_fpu_seq_out;

    if (rst_ni) begin
      extras_snitch = '{
        // State
        source:       snitch_pkg::SrcSnitch,
        stall:        i_snitch.stall,
        exception:    i_snitch.exception,
        // Decoding
        rs1:          i_snitch.rs1,
        rs2:          i_snitch.rs2,
        rd:           i_snitch.rd,
        is_load:      i_snitch.is_load,
        is_store:     i_snitch.is_store,
        is_branch:    i_snitch.is_branch,
        pc_d:         i_snitch.pc_d,
        // Operands
        opa:          i_snitch.opa,
        opb:          i_snitch.opb,
        opa_select:   i_snitch.opa_select,
        opb_select:   i_snitch.opb_select,
        write_rd:     i_snitch.write_rd,
        csr_addr:     i_snitch.inst_data_i[31:20],
        // Pipeline writeback
        writeback:    i_snitch.alu_writeback,
        // Load/Store
        gpr_rdata_1:  i_snitch.gpr_rdata[1],
        ls_size:      i_snitch.ls_size,
        ld_result_32: i_snitch.ld_result[31:0],
        lsu_rd:       i_snitch.lsu_rd,
        retire_load:  i_snitch.retire_load,
        alu_result:   i_snitch.alu_result,
        // Atomics
        ls_amo:       i_snitch.ls_amo,
        // Accelerator
        retire_acc:   i_snitch.retire_acc,
        acc_pid:      i_snitch.acc_prsp_i.id,
        acc_pdata_32: i_snitch.acc_prsp_i.data[31:0],
        // FPU offload
        fpu_offload:
          (i_snitch.acc_qready_i && i_snitch.acc_qvalid_o && i_snitch.acc_qreq_o.addr == snitch_pkg::FP_SS),
        is_seq_insn:  (i_snitch.inst_data_i ==? riscv_instr::FREP_O)
      };

      if (FPEn) begin
        extras_fpu = fpu_trace;
        if (Xfrep) begin
          // Addenda to FPU extras iff popping sequencer
          extras_fpu_seq_out = fpu_sequencer_trace;
        end
      end

      cycle++;
      // Trace snitch iff:
      // we are not stalled <==> we have issued and processed an instruction (including offloads)
      // OR we are retiring (issuing a writeback from) a load or accelerator instruction
      if (
          !i_snitch.stall || i_snitch.retire_load || i_snitch.retire_acc
      ) begin
        $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
            $time, cycle, i_snitch.priv_lvl_q, i_snitch.pc_q, i_snitch.inst_data_i,
            snitch_pkg::print_snitch_trace(extras_snitch));
        $fwrite(f, trace_entry);
      end
      if (FPEn) begin
        // Trace FPU iff:
        // an incoming handshake on the accelerator bus occurs <==> an instruction was issued
        // OR an FPU result is ready to be written back to an FPR register or the bus
        // OR an LSU result is ready to be written back to an FPR register or the bus
        // OR an FPU result, LSU result or bus value is ready to be written back to an FPR register
        if (extras_fpu.acc_q_hs || extras_fpu.fpu_out_hs
        || extras_fpu.lsu_q_hs || extras_fpu.fpr_we) begin
          $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
              $time, cycle, i_snitch.priv_lvl_q, 32'hz, extras_fpu.op_in,
              snitch_pkg::print_fpu_trace(extras_fpu));
          $fwrite(f, trace_entry);
        end
        // sequencer instructions
        if (Xfrep) begin
          if (extras_fpu_seq_out.cbuf_push) begin
            $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
                $time, cycle, i_snitch.priv_lvl_q, 32'hz, 64'hz,
                snitch_pkg::print_fpu_sequencer_trace(extras_fpu_seq_out));
            $fwrite(f, trace_entry);
          end
        end
      end
    end else begin
      cycle = '0;
    end
  end

  final begin
    $fclose(f);
  end
  // verilog_lint: waive-stop always-ff-non-blocking
  // pragma translate_on

  `ASSERT_INIT(BootAddrAligned, BootAddr[1:0] == 2'b00)

endmodule
