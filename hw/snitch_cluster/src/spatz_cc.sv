// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "common_cells/assertions.svh"
`include "common_cells/registers.svh"
`include "snitch/typedef.svh"
`include "reqrsp_interface/typedef.svh"
`include "dca_interface/typedef.svh"

/// Snitch Core Complex (CC)
/// Contains the Snitch Integer Core + FPU + Private Accelerators
module spatz_cc #(
  /// Address width of the buses
  parameter int unsigned AddrWidth          = 0,
  /// Data width of the buses.
  parameter int unsigned DataWidth          = 0,
  /// User width of the TCDM bus.
  parameter int unsigned TcdmUserWidth      = 0,
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
  parameter type         axi_ar_chan_t      = logic,
  parameter type         axi_aw_chan_t      = logic,
  parameter type         axi_req_t          = logic,
  parameter type         axi_rsp_t          = logic,
  parameter type         hive_req_t         = logic,
  parameter type         hive_rsp_t         = logic,
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
  // Spatz / RVV parameters
  parameter int unsigned                 NumSpatzOutstandingLoads  = 4,
  // TCDM channel types (used by Spatz mem ports)
  parameter type                         tcdm_req_chan_t           = logic,
  parameter type                         tcdm_rsp_chan_t           = logic,
  // Internal acc-shaped types (forwarded to Spatz; harmless when defaulted)
  parameter type                         acc_issue_req_t           = logic,
  parameter type                         acc_issue_rsp_t           = logic,
  parameter fpnew_pkg::fpu_implementation_t FPUImplementation = '0,
  /// Boot address of core.
  parameter logic [31:0] BootAddr           = 32'h0000_1000,
  /// Core ISA configuration.
  parameter snitch_pkg::isa_cfg_t IsaCfg    = '0,
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
  parameter snitch_ssr_pkg::ssr_cfg_t [cf_math_pkg::iomsb(NumSsrs):0] SsrCfgs = '0,
  parameter logic [cf_math_pkg::iomsb(NumSsrs):0][4:0] SsrRegs = '0,
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
  /// Cut DCA request to FPU
  parameter bit          RegisterDcaReq     = 0,
  /// Cut DCA response from FPU
  parameter bit          RegisterDcaRsp     = 0,
  parameter snitch_pma_pkg::snitch_pma_t SnitchPMACfg = '{default: 0},
  /// Consistency Address Queue (CAQ) parameters.
  parameter int unsigned CaqDepth     = 0,
  parameter int unsigned CaqTagWidth  = 0,
  /// Enable debug support.
  parameter bit          DebugSupport = 1,
  /// Optional fixed TCDM alias.
  parameter bit          TCDMAliasEnable = 1'b0,
  parameter logic [AddrWidth-1:0] TCDMAliasStart  = '0,
  /// Width of the collective operation field
  parameter int unsigned CollectiveWidth    = 1,
  /// Enable direct compute access (DCA).
  parameter bit          EnableDca          = 0,
  /// Derived parameter *Do not override*
  // With Spatz integrated, the TCDM port array carries Spatz's NumMemPortsPerSpatz
  // mem ports in indices [0:NumMemPortsPerSpatz-1] and the integer core's data
  // TCDM port at index [NumMemPortsPerSpatz]. SSR/FP_SS no longer share this
  // array (use a different cc file for the SSR+FP_SS variant).
  localparam int unsigned NumSpatzFUs = spatz_pkg::N_FU,
`ifdef DOUBLE_BW
  localparam int unsigned NumMemPortsPerSpatz = 2 * NumSpatzFUs,
`else
  localparam int unsigned NumMemPortsPerSpatz = NumSpatzFUs,
`endif
  localparam int unsigned TCDMPorts = IsaCfg.RVV ? NumMemPortsPerSpatz + 1 : 1,
  localparam type addr_t = logic [AddrWidth-1:0],
  localparam type data_t = logic [DataWidth-1:0],
  localparam type dca_req_t = `DCA_REQ_STRUCT(DataWidth),
  localparam type dca_rsp_t = `DCA_RSP_STRUCT(DataWidth)
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
  // When use Spatz, this interface will not be connected
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
  input  logic                              barrier_i,
  // Direct Compute Access (DCA) interface
  input  dca_req_t                          dca_req_i,
  output dca_rsp_t                          dca_rsp_o
);

  localparam bit FpEn = snitch_pkg::calculate_fp_enable(IsaCfg);
  localparam bit Xpulpv2 = snitch_pkg::calculate_xpulpv2(IsaCfg);
  localparam int unsigned FLEN = snitch_pkg::calculate_flen(IsaCfg);

  localparam snitch_pkg::isa_cfg_t IsaCfgSpatz = '{
    RVE                 : IsaCfg.RVE,
    RVV                 : IsaCfg.RVV,
    Xdma                : IsaCfg.Xdma,
    Xssr                : IsaCfg.Xssr,
    Xfrep               : 0,
    Xcopift             : IsaCfg.Xcopift,
    RVF                 : 0,
    RVD                 : 0,
    XF16                : 0,
    XF16ALT             : 0,
    XF8                 : 0,
    XF8ALT              : 0,
    XDivSqrt            : IsaCfg.XDivSqrt,
    XFVEC               : 0,
    XFDOTP              : 0,
    XFAUX               : 0,
    Xpulppostmod        : IsaCfg.Xpulppostmod,
    Xpulpabs            : IsaCfg.Xpulpabs,
    Xpulpbitop          : IsaCfg.Xpulpbitop,
    Xpulpbr             : IsaCfg.Xpulpbr,
    Xpulpclip           : IsaCfg.Xpulpclip,
    Xpulpmacsi          : IsaCfg.Xpulpmacsi,
    Xpulpminmax         : IsaCfg.Xpulpminmax,
    Xpulpslet           : IsaCfg.Xpulpslet,
    Xpulpvect           : IsaCfg.Xpulpvect,
    Xpulpvectshufflepack: IsaCfg.Xpulpvectshufflepack
  };

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

  // Define dca_req_chan_t and dca_rsp_chan_t
  `DCA_TYPEDEF_REQRSP_CHAN_ALL(dca, DataWidth)

  `SNITCH_ACC_TYPEDEF_ALL(DataWidth, AddrWidth)
  `SNITCH_INSTR_TYPEDEF_ALL(AddrWidth)
  `SNITCH_VM_TYPEDEF_ALL(AddrWidth)

  // Accelerator offload interface
  acc_req_t snitch_acc_req;
  acc_rsp_t snitch_acc_rsp;
  acc_req_t snitch_acc_req_q;
  acc_rsp_t snitch_acc_rsp_q;
  acc_req_t [snitch_pkg::NUM_ACC-1:0] snitch_acc_req_demuxed;
  acc_rsp_t [snitch_pkg::NUM_ACC-1:0] snitch_acc_rsp_demuxed;

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
  snitch_pkg::core_events_t fpss_events;

  // Snitch Integer Core
  dreq_t snitch_dreq_d, snitch_dreq_q, merged_dreq;
  drsp_t snitch_drsp_d, snitch_drsp_q, merged_drsp;

  // Consistency Address Queue (CAQ) interface
  logic caq_pvalid, caq_pvalid_q;

  // ----------------------------------------------------------------------
  // Internal X-Interface (Snitch <-> Spatz)
  // ----------------------------------------------------------------------
  x_issue_req_t  x_issue_req;
  x_issue_resp_t x_issue_resp;
  logic          x_issue_valid;
  logic          x_issue_ready;
  x_register_t   x_register;
  logic          x_register_valid;
  logic          x_register_ready;
  x_commit_t     x_commit;
  logic          x_commit_valid;
  x_result_t     x_result;
  logic          x_result_valid;
  logic          x_result_ready;

  // ----------------------------------------------------------------------
  // Spatz mem-port and FP-LSU signals
  // ----------------------------------------------------------------------
  dreq_t fp_lsu_mem_req;
  drsp_t fp_lsu_mem_rsp;

  tcdm_req_chan_t [NumMemPortsPerSpatz-1:0] spatz_mem_req;
  logic           [NumMemPortsPerSpatz-1:0] spatz_mem_req_valid;
  logic           [NumMemPortsPerSpatz-1:0] spatz_mem_req_ready;
  tcdm_rsp_chan_t [NumMemPortsPerSpatz-1:0] spatz_mem_rsp;
  logic           [NumMemPortsPerSpatz-1:0] spatz_mem_rsp_valid;

  // Spatz memory-completion signals: kept internal, not plumbed further yet.
  logic [1:0] spatz_mem_finished;
  logic [1:0] spatz_mem_str_finished;

  ////////////
  // Snitch //
  ////////////

  snitch #(
    .BootAddr (BootAddr),
    .IsaCfg (IsaCfgSpatz),
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .VMSupport (VMSupport),
    .DebugSupport (DebugSupport),
    .EnableXif (EnableXif),
    .XifIdWidth (XifIdWidth),
    .NumIntOutstandingLoads (NumIntOutstandingLoads),
    .NumIntOutstandingMem (NumIntOutstandingMem),
    .NumDTLBEntries (NumDTLBEntries),
    .NumITLBEntries (NumITLBEntries),
    .SnitchPMACfg (SnitchPMACfg),
    .CaqDepth (CaqDepth),
    .CaqTagWidth (CaqTagWidth)
  ) i_snitch (
    .clk_i ( clk_d2_i ), // if necessary operate on half the frequency
    .rst_i ( ~rst_ni ),
    .hart_id_i,
    .irq_i,
    .flush_i_valid_o (hive_req_o.flush_i_valid),
    .flush_i_ready_i (hive_rsp_i.flush_i_ready),
    .inst_req_o      ( hive_req_o.instr_req ),
    .inst_rsp_i      ( hive_rsp_i.instr_rsp ),
    .acc_req_o       ( snitch_acc_req ),
    .acc_rsp_i       ( snitch_acc_rsp ),
    .x_issue_req_o ( x_issue_req ),
    .x_issue_resp_i ( x_issue_resp ),
    .x_issue_valid_o ( x_issue_valid ),
    .x_issue_ready_i ( x_issue_ready ),
    .x_register_o ( x_register ),
    .x_register_valid_o ( x_register_valid ),
    .x_register_ready_i ( x_register_ready ),
    .x_commit_o ( x_commit ),
    .x_commit_valid_o ( x_commit_valid ),
    .x_result_i ( x_result ),
    .x_result_valid_i ( x_result_valid ),
    .x_result_ready_o ( x_result_ready ),
    .i2f_rdata_o ( i2f_rdata ),
    .i2f_rvalid_o ( i2f_rvalid ),
    .i2f_rready_i ( i2f_rready ),
    .f2i_wdata_i ( f2i_wdata ),
    .f2i_wvalid_i ( f2i_wvalid ),
    .f2i_wready_o ( f2i_wready ),
    .caq_pvalid_i ( caq_pvalid_q ),
    .data_req_o ( snitch_dreq_d ),
    .data_rsp_i ( snitch_drsp_d ),
    .ptw_req_o  ( hive_req_o.ptw_req ),
    .ptw_rsp_i  ( hive_rsp_i.ptw_rsp ),
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
    .UserWidth (64),
    .req_t (dreq_t),
    .rsp_t (drsp_t),
    .BypassReq (!RegisterCoreReq),
    .BypassRsp (!IsoCrossing && !RegisterCoreRsp)
  ) i_data_cut (
    .src_clk_i (clk_d2_i),
    .src_rst_ni (rst_ni),
    .src_req_i (snitch_dreq_d),
    .src_rsp_o (snitch_drsp_d),
    .dst_clk_i (clk_i),
    .dst_rst_ni (rst_ni),
    .dst_req_o (snitch_dreq_q),
    .dst_rsp_i (snitch_drsp_q)
  );

  generic_reqrsp_cut #(
    .req_chan_t(acc_req_chan_t),
    .rsp_chan_t(acc_rsp_chan_t),
    .BypassReq (!RegisterOffloadReq),
    .BypassRsp (!RegisterOffloadRsp)
  ) i_acc_cut (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .slv_req_i(snitch_acc_req),
    .slv_rsp_o(snitch_acc_rsp),
    .mst_req_o(snitch_acc_req_q),
    .mst_rsp_i(snitch_acc_rsp_q)
  );

  // Cut CAQ response for proper handshake with divided clock.
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

  generic_reqrsp_demux #(
    .NrPorts   (snitch_pkg::NUM_ACC),
    .req_chan_t(acc_req_chan_t),
    .rsp_chan_t(acc_rsp_chan_t)
  ) i_acc_demux (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .slv_req_i(snitch_acc_req_q),
    .slv_rsp_o(snitch_acc_rsp_q),
    .mst_req_o(snitch_acc_req_demuxed),
    .mst_rsp_i(snitch_acc_rsp_demuxed),
    .idx_i    (snitch_acc_req_q.q.addr[$clog2(snitch_pkg::NUM_ACC)-1:0])
  );

  /////////
  // DMA //
  /////////

  if (IsaCfg.Xdma) begin : gen_dma
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
      .acc_req_t (acc_req_chan_t),
      .acc_res_t (acc_rsp_chan_t),
      .dma_events_t (dma_events_t)
    ) i_idma_inst64_top (
      .clk_i,
      .rst_ni,
      .testmode_i      ( 1'b0             ),
      .axi_req_o       ( axi_dma_req_o    ),
      .axi_res_i       ( axi_dma_res_i    ),
      .busy_o          ( axi_dma_busy_o   ),
      .acc_req_i       ( snitch_acc_req_demuxed[snitch_pkg::DMA_SS].q       ),
      .acc_req_valid_i ( snitch_acc_req_demuxed[snitch_pkg::DMA_SS].q_valid ),
      .acc_req_ready_o ( snitch_acc_rsp_demuxed[snitch_pkg::DMA_SS].q_ready ),
      .acc_res_o       ( snitch_acc_rsp_demuxed[snitch_pkg::DMA_SS].p       ),
      .acc_res_valid_o ( snitch_acc_rsp_demuxed[snitch_pkg::DMA_SS].p_valid ),
      .acc_res_ready_i ( snitch_acc_req_demuxed[snitch_pkg::DMA_SS].p_ready ),
      .hart_id_i       ( hart_id_i        ),
      .events_o        ( axi_dma_events_o )
    );
  end else begin : gen_no_dma
    // tie-off unused signals
    assign axi_dma_req_o    = '0;
    assign axi_dma_busy_o   = '0;
    assign snitch_acc_rsp_demuxed[snitch_pkg::DMA_SS] = '0;
    assign axi_dma_events_o = '0;
  end

  /////////
  // IPU //
  /////////

  if (PrivateIpu) begin : gen_ipu
    snitch_ipu #(
      .IdWidth  (5),
      .Xpulpv2  (Xpulpv2),
      .acc_rsp_t(acc_rsp_t),
      .acc_req_t(acc_req_t)
    ) i_snitch_ipu (
      .clk_i,
      .rst_ni,
      .acc_req_i(snitch_acc_req_demuxed[snitch_pkg::IPU]),
      .acc_rsp_o(snitch_acc_rsp_demuxed[snitch_pkg::IPU])
    );
    assign hive_req_o.acc_req = '0;
  end else begin
    assign hive_req_o.acc_req = snitch_acc_req_demuxed[snitch_pkg::IPU];
    assign snitch_acc_rsp_demuxed[snitch_pkg::IPU] = hive_rsp_i.acc_rsp;
  end

  ///////////
  // Spatz //
  ///////////

  // The X-Interface (declared above) connects Snitch's X-IF master ports to
  // Spatz's X-IF slave ports. Spatz internally converts X to acc.
  // FP_SS and SSR are removed from this cc variant; Spatz now handles all FP
  // (RV32F) and vector (RVV) work. For an SSR+FP_SS configuration, use the
  // SSR-aware cc variant instead.

  if (IsaCfg.RVV) begin : gen_spatz
    spatz #(
      .NrMemPorts          (NumMemPortsPerSpatz     ),
      .NumOutstandingLoads (NumSpatzOutstandingLoads),
      .FPUImplementation   (FPUImplementation       ),
      .RegisterRsp         (RegisterOffloadRsp      ),
      .dreq_t              (dreq_t                  ),
      .drsp_t              (drsp_t                  ),
      .spatz_mem_req_t     (tcdm_req_chan_t         ),
      .spatz_mem_rsp_t     (tcdm_rsp_chan_t         ),
      // X-IF types (used; Spatz must be compiled with `define X_INTERFACE).
      .x_issue_req_t       (x_issue_req_t           ),
      .x_issue_resp_t      (x_issue_resp_t          ),
      .x_register_t        (x_register_t            ),
      .x_commit_t          (x_commit_t              ),
      .x_result_t          (x_result_t              )
    ) i_spatz (
      .clk_i                    (clk_i                 ),
      .rst_ni                   (rst_ni                ),
      .testmode_i               (1'b0                  ),
      .hart_id_i                (hart_id_i             ),
      // X-Interface (slave) — driven by Snitch
      .x_issue_valid_i          (x_issue_valid         ),
      .x_issue_ready_o          (x_issue_ready         ),
      .x_issue_req_i            (x_issue_req           ),
      .x_issue_resp_o           (x_issue_resp          ),
      .x_register_valid_i       (x_register_valid      ),
      .x_register_ready_o       (x_register_ready      ),
      .x_register_i             (x_register            ),
      .x_commit_valid_i         (x_commit_valid        ),
      .x_commit_i               (x_commit              ),
      .x_result_valid_o         (x_result_valid        ),
      .x_result_ready_i         (x_result_ready        ),
      .x_result_o               (x_result              ),
      // Spatz mem ports
      .spatz_mem_req_o          (spatz_mem_req         ),
      .spatz_mem_req_valid_o    (spatz_mem_req_valid   ),
      .spatz_mem_req_ready_i    (spatz_mem_req_ready   ),
      .spatz_mem_rsp_i          (spatz_mem_rsp         ),
      .spatz_mem_rsp_valid_i    (spatz_mem_rsp_valid   ),
      .spatz_mem_finished_o     (spatz_mem_finished    ),
      .spatz_mem_str_finished_o (spatz_mem_str_finished),
      // FP-LSU port (muxed with snitch dreq below)
      .fp_lsu_mem_req_o         (fp_lsu_mem_req        ),
      .fp_lsu_mem_rsp_i         (fp_lsu_mem_rsp        ),
      // FPU side channel
      .fpu_rnd_mode_i           (fpu_rnd_mode          ),
      .fpu_fmt_mode_i           (fpu_fmt_mode          ),
      .fpu_status_o             (fpu_status            )
    );

    // Wire Spatz mem ports to TCDM ports [0:NumMemPortsPerSpatz-1].
    for (genvar p = 0; p < NumMemPortsPerSpatz; p++) begin: gen_spatz_tcdm_assignment
      assign tcdm_req_o[p] = '{
          q       : spatz_mem_req[p],
          q_valid : spatz_mem_req_valid[p]
        };
      assign spatz_mem_req_ready[p] = tcdm_rsp_i[p].q_ready;
      assign spatz_mem_rsp[p]       = tcdm_rsp_i[p].p;
      assign spatz_mem_rsp_valid[p] = tcdm_rsp_i[p].p_valid;
    end

    // Mux Spatz's FP-LSU req with Snitch's dreq into the merged data path.
    reqrsp_mux #(
      .NrPorts     (2          ),
      .AddrWidth   (AddrWidth  ),
      .DataWidth   (DataWidth  ),
      .UserWidth   (64         ),
      .req_t       (dreq_t     ),
      .rsp_t       (drsp_t     ),
      .RespDepth   (8          ),
      .RegisterReq ({1'b1, 1'b0})
    ) i_reqrsp_mux (
      .clk_i,
      .rst_ni,
      .slv_req_i ({fp_lsu_mem_req, snitch_dreq_q}),
      .slv_rsp_o ({fp_lsu_mem_rsp, snitch_drsp_q}),
      .mst_req_o (merged_dreq),
      .mst_rsp_i (merged_drsp),
      .idx_o     (/*not connected*/)
    );

    // External X-Interface will be tied off
    assign x_issue_req_o = '0;
    assign x_issue_valid_o = '0;
    assign x_register_o = '0;
    assign x_register_valid_o = '0;
    assign x_commit_o = '0;
    assign x_commit_valid_o = '0;
    assign x_result_ready_o = '0;

  end else begin : gen_no_spatz
    // X-Interface will connect to cluster level
    assign x_issue_req_o = x_issue_ready;
    assign x_issue_resp  = x_issue_resp_i;
    assign x_issue_valid_o = x_issue_valid;
    assign x_issue_ready = x_issue_ready_i;
    assign x_register_o = x_register;
    assign x_register_valid_o = x_register_valid;
    assign x_register_ready = x_register_ready_i;
    assign x_commit_o = x_commit;
    assign x_commit_valid_o = x_commit_valid;
    assign x_result = x_result_i;
    assign x_result_valid = x_result_valid_i;
    assign x_result_ready_o = x_result_ready;

    // Mem and side-channel tie-offs.
    assign fp_lsu_mem_req         = '0;
    assign spatz_mem_finished     = '0;
    assign spatz_mem_str_finished = '0;
    assign fpu_status             = '0;
    // Snitch dreq passes straight through.
    assign merged_dreq            = snitch_dreq_q;
    assign snitch_drsp_q          = merged_drsp;
  end

  // DCA is removed in this cc variant (lived inside the FP subsystem).
  // dca_rsp_o is an output, tied to '0; dca_req_i is left dangling.
  assign dca_rsp_o = '0;

  // FP_SS slot of the acc demux is permanently unused in this cc variant.
  assign snitch_acc_rsp_demuxed[snitch_pkg::FP_SS] = '0;
  assign caq_pvalid = 1'b0;

  // FP_SS-side signals on Snitch are tied to safe defaults: i2f/f2i are
  // FP_SS<->Snitch handshakes (FP_SS removed), and en_copift is unused.
  // Output-from-Snitch signals (i2f_rdata, i2f_rvalid, f2i_wready, en_copift)
  // are left dangling (no consumer).
  assign i2f_rready = 1'b1; // accept any (never-asserted) i2f response
  assign f2i_wdata  = '0;
  assign f2i_wvalid = 1'b0;
  // fpss_events is left dangling (declared above; no driver, no consumer
  // outside commented-out core_events block).

  // Decide whether to go to SoC or TCDM

  localparam int unsigned SelectWidth = cf_math_pkg::idx_width(2);
  typedef logic [SelectWidth-1:0] select_t;
  typedef enum select_t {SelectTcdm = 1, SelectSoc = 0} select_e;

  dreq_t data_tcdm_req;
  drsp_t data_tcdm_rsp;

  select_t slave_select, slave_select_coll_op;

  reqrsp_demux #(
    .NrPorts (2),
    .req_t (dreq_t),
    .rsp_t (drsp_t),
    // TODO(zarubaf): Make a parameter.
    .RespDepth (4)
  ) i_reqrsp_demux (
    .clk_i,
    .rst_ni,
    .slv_select_i (slave_select_coll_op),
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
    idx: SelectTcdm,
    base: tcdm_addr_base_i,
    mask: ({AddrWidth{1'b1}} << TCDMAddrWidth)
  };
  if (TCDMAliasEnable) begin : gen_tcdm_alias_rule
    assign addr_map[1] = '{
      idx: SelectTcdm,
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
    .default_idx_i (SelectSoc)
  );

  // Collective communication operations are performed within the interconnect at the SoC
  // level. However, requests destined to the TCDM never arrive at the SoC interconnect,
  // as they are routed internally within the cluster. In order for collectives destined to
  // the TCDM to work, we need to handle them differently, and always forward them to the
  // SoC interconnect, which will reroute them back to the TCDM from outside the cluster.
  // The collective mask, in the user field, is used to detect collective operations.
  addr_t collective_mask;
  assign collective_mask = addr_t'(merged_dreq.q.user[CollectiveWidth+:AddrWidth]);
  assign slave_select_coll_op = (collective_mask != 0) ? SelectSoc : slave_select;

  tcdm_req_t core_tcdm_req;
  tcdm_rsp_t core_tcdm_rsp;

  reqrsp_to_tcdm #(
    .AddrWidth (AddrWidth),
    .DataWidth (DataWidth),
    .UserWidth (64),
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

  //////////////////////////////
  // Core TCDM port routing   //
  //////////////////////////////
  //
  // SSRs are removed in this cc variant. The Snitch integer core's TCDM port
  // (core_tcdm_req/rsp) is routed to the last TCDM port:
  //   - With Spatz (RVV=1): tcdm port [NumMemPortsPerSpatz]; ports
  //     [0..NumMemPortsPerSpatz-1] are owned by Spatz (wired in gen_spatz).
  //   - Without Spatz: tcdm port [0] (only one port exists).

  if (IsaCfg.RVV) begin : gen_core_tcdm_routing_with_spatz
    assign tcdm_req_o[NumMemPortsPerSpatz] = core_tcdm_req;
    assign core_tcdm_rsp                   = tcdm_rsp_i[NumMemPortsPerSpatz];
  end else begin : gen_core_tcdm_routing_no_spatz
    assign tcdm_req_o[0] = core_tcdm_req;
    assign core_tcdm_rsp = tcdm_rsp_i[0];
  end

  // SSR_CFG acc-demux slot: SSR is removed, tie off response side.
  assign snitch_acc_rsp_demuxed[snitch_pkg::SSR_CFG] = '0;



  /////////////////
  // Core events //
  /////////////////

  // FP_SS is removed in this cc variant; FP-related event fields are no longer
  // populated. Original assignments preserved below as comments for future
  // reference.
  // always_comb begin
  //   core_events_o = snitch_events;
  //   core_events_o.issue_fpu = fpss_events.issue_fpu;
  //   core_events_o.issue_fpu_seq = fpss_events.issue_fpu_seq;
  //   core_events_o.issue_core_to_fpu = fpss_events.issue_core_to_fpu;
  // end
  assign core_events_o = '0;

  ////////////
  // Tracer //
  ////////////

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
    automatic snitch_pkg::dca_trace_port_t extras_dca;

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
        opc_select:   i_snitch.opc_select,
        write_rd:     i_snitch.write_rd,
        csr_addr:     i_snitch.inst_rsp_i.data[31:20],
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
        acc_pid:      i_snitch.acc_rsp_i.p.id,
        acc_pdata_32: i_snitch.acc_rsp_i.p.data[31:0],
        // FPU offload
        fpu_offload:
          (i_snitch.acc_rsp_i.q_ready && i_snitch.acc_req_o.q_valid &&
           i_snitch.acc_req_o.q.addr == snitch_pkg::FP_SS),
        is_seq_insn:  (i_snitch.inst_rsp_i.data ==? riscv_instr::FREP_O)
      };

      if (1'b0) begin // FPU/sequencer tracer disabled: FP_SS removed in this cc variant
        // extras_fpu = fpu_trace;
        // if (IsaCfg.Xfrep) extras_fpu_seq_out = fpu_sequencer_trace;
      end

      cycle++;
      // Trace snitch iff:
      // we are not stalled <==> we have issued and processed an instruction (including offloads)
      // OR we are retiring (issuing a writeback from) a load or accelerator instruction
      if (
          !i_snitch.stall || i_snitch.retire_load || i_snitch.retire_acc
      ) begin
        $sformat(trace_entry, "%t %1d %8d 0x%h DASM(%h) #; %s\n",
            $time, cycle, i_snitch.priv_lvl_q, i_snitch.pc_q, i_snitch.inst_rsp_i.data,
            snitch_pkg::print_snitch_trace(extras_snitch));
        $fwrite(f, trace_entry);
`ifdef DEBUG
        $fflush(f);
`endif
      end
      // FPU and DCA tracer blocks omitted: FP_SS / DCA removed in this cc variant.
    end else begin
      cycle = '0;
    end
  end

  final begin
    $fclose(f);
  end
  // verilog_lint: waive-stop always-ff-non-blocking
  // pragma translate_on

  ////////////////
  // Assertions //
  ////////////////

  `ASSERT_INIT(BootAddrAligned, BootAddr[1:0] == 2'b00)
  
  // DCA extension currently only supports 64-bit datawidth
  `ASSERT_INIT(DcaCoreConfiguration, (!EnableDca) || IsaCfg.RVD)
  `ASSERT_INIT(DcaDataWidth, (!EnableDca) || (DataWidth == 64))

endmodule
