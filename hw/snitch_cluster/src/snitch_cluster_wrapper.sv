// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

module snitch_cluster_wrapper
  import snitch_cluster_wrapper_pkg::*;
(
  input  logic                                    clk_i,
  input  logic                                    rst_ni,
  input  logic [NrCores-1:0]                      debug_req_i,
  input  logic [NrCores-1:0]                      meip_i,
  input  logic [NrCores-1:0]                      mtip_i,
  input  logic [NrCores-1:0]                      msip_i,
  input  logic [NrCores-1:0]                      mxip_i,
  input  snitch_pkg::hart_id_t                    hart_base_id_i,
  input  logic [AddrWidth-1:0]                    cluster_base_addr_i,
  input  logic [AddrWidth-1:0]                    cluster_base_offset_i,
  input  logic                                    clk_d2_bypass_i,
  input  sram_cfg_t                               sram_cfg_tcdm_i,
  input  sram_cfg_t [NrHives-1:0]                 sram_cfg_icache_tag_i,
  input  sram_cfg_t [NrHives-1:0]                 sram_cfg_icache_data_i,
  input  narrow_in_req_t                          narrow_in_req_i,
  output narrow_in_resp_t                         narrow_in_resp_o,
  output narrow_out_req_t                         narrow_out_req_o,
  input  narrow_out_resp_t                        narrow_out_resp_i,
  output wide_out_req_t                           wide_out_req_o,
  input  wide_out_resp_t                          wide_out_resp_i,
  input  wide_in_req_t                            wide_in_req_i,
  output wide_in_resp_t                           wide_in_resp_o,
  output x_issue_req_t  [NrCores-1:0]             x_issue_req_o,
  input  x_issue_resp_t [NrCores-1:0]             x_issue_resp_i,
  output logic [NrCores-1:0]                      x_issue_valid_o,
  input  logic [NrCores-1:0]                      x_issue_ready_i,
  output x_register_t [NrCores-1:0]               x_register_o,
  output logic [NrCores-1:0]                      x_register_valid_o,
  input  logic [NrCores-1:0]                      x_register_ready_i,
  output x_commit_t [NrCores-1:0]                 x_commit_o,
  output logic [NrCores-1:0]                      x_commit_valid_o,
  input  x_result_t [NrCores-1:0]                 x_result_i,
  input  logic [NrCores-1:0]                      x_result_valid_i,
  output logic [NrCores-1:0]                      x_result_ready_o,
  output narrow_out_req_t                         narrow_ext_req_o,
  input  narrow_out_resp_t                        narrow_ext_resp_i,
  input  tcdm_dma_req_t [NumExpWideTcdmPorts-1:0] tcdm_ext_req_i,
  output tcdm_dma_rsp_t [NumExpWideTcdmPorts-1:0] tcdm_ext_resp_o,
  input  dca_req_t                                dca_req_i,
  output dca_rsp_t                                dca_rsp_o
);

  // debug_req
  logic [NrCores-1:0] debug_req_int;
  if (DebugSupport) begin : gen_debug_fwd
    assign debug_req_int = debug_req_i;
  end else begin : gen_debug_tie
    assign debug_req_int = '0;
  end

  // mxip (external interrupts)
  logic [NrCores-1:0] mxip_int;
  if (EnableExternalInterrupts) begin : gen_mxip_fwd
    assign mxip_int = mxip_i;
  end else begin : gen_mxip_tie
    assign mxip_int = '0;
  end

  // hart_base_id / cluster_base_addr / cluster_base_offset
  snitch_pkg::hart_id_t hart_base_id_int;
  logic [AddrWidth-1:0] cluster_base_addr_int;
  logic [AddrWidth-1:0] cluster_base_offset_int;
  if (ClusterBaseExpose) begin : gen_base_fwd
    assign hart_base_id_int        = hart_base_id_i;
    assign cluster_base_addr_int   = cluster_base_addr_i;
    assign cluster_base_offset_int = cluster_base_offset_i;
  end else begin : gen_base_tie
    assign hart_base_id_int        = CfgBaseHartId;
    assign cluster_base_addr_int   = CfgClusterBaseAddr;
    assign cluster_base_offset_int = CfgClusterBaseOffset;
  end

  // clk_d2_bypass
  logic clk_d2_bypass_int;
  if (IsoCrossing) begin : gen_clk_d2_fwd
    assign clk_d2_bypass_int = clk_d2_bypass_i;
  end else begin : gen_clk_d2_tie
    assign clk_d2_bypass_int = 1'b0;
  end

  // SRAM configuration
  sram_cfg_t               sram_cfg_tcdm_int;
  sram_cfg_t [NrHives-1:0] sram_cfg_icache_tag_int;
  sram_cfg_t [NrHives-1:0] sram_cfg_icache_data_int;
  if (SramCfgExpose) begin : gen_sram_cfg_fwd
    assign sram_cfg_tcdm_int        = sram_cfg_tcdm_i;
    assign sram_cfg_icache_tag_int  = sram_cfg_icache_tag_i;
    assign sram_cfg_icache_data_int = sram_cfg_icache_data_i;
  end else begin : gen_sram_cfg_tie
    assign sram_cfg_tcdm_int        = '0;
    assign sram_cfg_icache_tag_int  = '0;
    assign sram_cfg_icache_data_int = '0;
  end

  // XIF
  x_issue_resp_t [NrCores-1:0] x_issue_resp_int;
  logic          [NrCores-1:0] x_issue_ready_int;
  logic          [NrCores-1:0] x_register_ready_int;
  x_result_t     [NrCores-1:0] x_result_int;
  logic          [NrCores-1:0] x_result_valid_int;
  x_issue_req_t  [NrCores-1:0] x_issue_req_int;
  logic          [NrCores-1:0] x_issue_valid_int;
  x_register_t   [NrCores-1:0] x_register_int;
  logic          [NrCores-1:0] x_register_valid_int;
  x_commit_t     [NrCores-1:0] x_commit_int;
  logic          [NrCores-1:0] x_commit_valid_int;
  logic          [NrCores-1:0] x_result_ready_int;
  if (EnableXif) begin : gen_xif_fwd
    assign x_issue_resp_int    = x_issue_resp_i;
    assign x_issue_ready_int   = x_issue_ready_i;
    assign x_register_ready_int = x_register_ready_i;
    assign x_result_int        = x_result_i;
    assign x_result_valid_int  = x_result_valid_i;
    assign x_issue_req_o       = x_issue_req_int;
    assign x_issue_valid_o     = x_issue_valid_int;
    assign x_register_o        = x_register_int;
    assign x_register_valid_o  = x_register_valid_int;
    assign x_commit_o          = x_commit_int;
    assign x_commit_valid_o    = x_commit_valid_int;
    assign x_result_ready_o    = x_result_ready_int;
  end else begin : gen_xif_tie
    assign x_issue_resp_int    = '{NrCores{x_issue_resp_t'('0)}};
    assign x_issue_ready_int   = '1;
    assign x_register_ready_int = '0;
    assign x_result_int        = '{NrCores{x_result_t'('0)}};
    assign x_result_valid_int  = '0;
    assign x_issue_req_o       = '{default: x_issue_req_t'('0)};
    assign x_issue_valid_o     = '0;
    assign x_register_o        = '{default: x_register_t'('0)};
    assign x_register_valid_o  = '0;
    assign x_commit_o          = '{default: x_commit_t'('0)};
    assign x_commit_valid_o    = '0;
    assign x_result_ready_o    = '0;
  end

  // narrow external AXI port
  narrow_out_req_t  narrow_ext_req_int;
  narrow_out_resp_t narrow_ext_resp_int;
  if (NarrowAxiPortExpose) begin : gen_narrow_ext_fwd
    assign narrow_ext_req_o    = narrow_ext_req_int;
    assign narrow_ext_resp_int = narrow_ext_resp_i;
  end else begin : gen_narrow_ext_tie
    assign narrow_ext_req_o    = '0;
    assign narrow_ext_resp_int = narrow_out_resp_t'('0);
  end

  // exposed wide TCDM ports
  tcdm_dma_req_t [NumExpWideTcdmPorts-1:0] tcdm_ext_req_int;
  tcdm_dma_rsp_t [NumExpWideTcdmPorts-1:0] tcdm_ext_resp_int;
  if (NumExpWideTcdmPortsCfg > 0) begin : gen_tcdm_ext_fwd
    assign tcdm_ext_req_int = tcdm_ext_req_i;
    assign tcdm_ext_resp_o  = tcdm_ext_resp_int;
  end else begin : gen_tcdm_ext_tie
    assign tcdm_ext_req_int = tcdm_dma_req_t'('0);
    assign tcdm_ext_resp_o  = '0;
  end

  // DCA
  dca_req_t dca_req_int;
  dca_rsp_t dca_rsp_int;
  if (EnableDca) begin : gen_dca_fwd
    assign dca_req_int = dca_req_i;
    assign dca_rsp_o   = dca_rsp_int;
  end else begin : gen_dca_tie
    assign dca_req_int = '0;
    assign dca_rsp_o   = '0;
  end

  // Snitch cluster under test.
  snitch_cluster #(
    .PhysicalAddrWidth        (AddrWidth),
    .NarrowDataWidth          (NarrowDataWidth),
    .WideDataWidth            (WideDataWidth),
    .NarrowIdWidthIn          (NarrowIdWidthIn),
    .WideIdWidthIn            (WideIdWidthIn),
    .AtomicIdWidth            (AtomicIdWidth),
    .CollectiveWidth          (CollectiveWidth),
    .BootAddr                 (BootAddr),
    .IntBootromEnable         (IntBootromEnable),
    .narrow_in_req_t          (narrow_in_req_t),
    .narrow_in_resp_t         (narrow_in_resp_t),
    .narrow_out_req_t         (narrow_out_req_t),
    .narrow_out_resp_t        (narrow_out_resp_t),
    .wide_out_req_t           (wide_out_req_t),
    .wide_out_resp_t          (wide_out_resp_t),
    .wide_in_req_t            (wide_in_req_t),
    .wide_in_resp_t           (wide_in_resp_t),
    .x_issue_req_t            (x_issue_req_t),
    .x_issue_resp_t           (x_issue_resp_t),
    .x_register_t             (x_register_t),
    .x_commit_t               (x_commit_t),
    .x_result_t               (x_result_t),
    .NrHives                  (NrHives),
    .NrCores                  (NrCores),
    .TCDMDepth                (TCDMDepth),
    .ExtMemorySize            (ExtMemorySize),
    .ClusterPeriphSize        (ClusterPeriphSize),
    .NrBanks                  (NrBanks),
    .NrHyperBanks             (NrHyperBanks),
    .DMANumAxInFlight         (DMANumAxInFlight),
    .DMAReqFifoDepth          (DMAReqFifoDepth),
    .DMANumChannels           (DMANumChannels),
    .NumExpWideTcdmPorts      (NumExpWideTcdmPorts),
    .ICacheLineWidth          (ICacheLineWidth),
    .ICacheLineCount          (ICacheLineCount),
    .ICacheWays               (ICacheWays),
    .ICacheL1TagScm           (ICacheL1TagScm),
    .ICacheL1DataScm          (ICacheL1DataScm),
    .VMSupport                (VMSupport),
    .EnableWideCollectives    (EnableWideCollectives),
    .EnableNarrowCollectives  (EnableNarrowCollectives),
    .EnableXif                (EnableXif),
    .XifIdWidth               (XifIdWidth),
    .IsaCfg                   (IsaCfg),
    .PrivateIpu               (PrivateIpu),
    .FPUImplementation        (FPUImplementation),
    .SnitchPMACfg             (SnitchPMACfg),
    .NumIntOutstandingLoads   (NumIntOutstandingLoads),
    .NumIntOutstandingMem     (NumIntOutstandingMem),
    .NumFPOutstandingLoads    (NumFPOutstandingLoads),
    .NumFPOutstandingMem      (NumFPOutstandingMem),
    .NumDTLBEntries           (NumDTLBEntries),
    .NumITLBEntries           (NumITLBEntries),
    .NumSsrsMax               (NumSsrsMax),
    .NumSsrs                  (NumSsrs),
    .SsrMuxRspDepth           (SsrMuxRspDepth),
    .SsrRegs                  (SsrRegs),
    .SsrCfgs                  (SsrCfgs),
    .SpatzDoubleBw            (SpatzDoubleBw),
    .NumSpatzOutstandingLoads (NumSpatzOutstandingLoads),
    .NumSequencerInstr        (NumSequencerInstr),
    .NumSequencerLoops        (NumSequencerLoops),
    .Hive                     (Hive),
    .Topology                 (Topology),
    .Radix                    (Radix),
    .NumSwitchNets            (NumSwitchNets),
    .SwitchLfsrArbiter        (SwitchLfsrArbiter),
    .RegisterOffloadReq       (RegisterOffloadReq),
    .RegisterOffloadRsp       (RegisterOffloadRsp),
    .RegisterCoreReq          (RegisterCoreReq),
    .RegisterCoreRsp          (RegisterCoreRsp),
    .RegisterTCDMCuts         (RegisterTCDMCuts),
    .RegisterExtWide          (RegisterExtWide),
    .RegisterExtNarrow        (RegisterExtNarrow),
    .RegisterExpNarrow        (RegisterExpNarrow),
    .RegisterFPUReq           (RegisterFPUReq),
    .RegisterFPUIn            (RegisterFPUIn),
    .RegisterFPUOut           (RegisterFPUOut),
    .RegisterDcaReq           (RegisterDcaReq),
    .RegisterDcaRsp           (RegisterDcaRsp),
    .RegisterSequencer        (RegisterSequencer),
    .IsoCrossing              (IsoCrossing),
    .NarrowXbarLatency        (NarrowXbarLatency),
    .WideXbarLatency          (WideXbarLatency),
    .WideMaxMstTrans          (WideMaxTrans),
    .WideMaxSlvTrans          (WideMaxTrans),
    .NarrowMaxMstTrans        (NarrowMaxTrans),
    .NarrowMaxSlvTrans        (NarrowMaxTrans),
    .sram_cfg_t               (sram_cfg_t),
    .user_narrow_t            (user_narrow_t),
    .user_dma_t               (user_dma_t),
    .CaqDepth                 (CaqDepth),
    .CaqTagWidth              (CaqTagWidth),
    .DebugSupport             (DebugSupport),
    .AliasRegionEnable        (AliasRegionEnable),
    .AliasRegionBase          (AliasRegionBase),
    .EnableDca                (EnableDca),
    .DcaDataWidth             (DcaDataWidth)
  ) i_cluster (
    .clk_i,
    .rst_ni,
    .debug_req_i              (debug_req_int),
    .meip_i,
    .mtip_i,
    .msip_i,
    .mxip_i                   (mxip_int),
    .hart_base_id_i           (hart_base_id_int),
    .cluster_base_addr_i      (cluster_base_addr_int),
    .cluster_base_offset_i    (cluster_base_offset_int),
    .clk_d2_bypass_i          (clk_d2_bypass_int),
    .sram_cfg_tcdm_i          (sram_cfg_tcdm_int),
    .sram_cfg_icache_tag_i    (sram_cfg_icache_tag_int),
    .sram_cfg_icache_data_i   (sram_cfg_icache_data_int),
    .x_issue_resp_i           (x_issue_resp_int),
    .x_issue_ready_i          (x_issue_ready_int),
    .x_register_ready_i       (x_register_ready_int),
    .x_result_i               (x_result_int),
    .x_result_valid_i         (x_result_valid_int),
    .x_issue_req_o            (x_issue_req_int),
    .x_issue_valid_o          (x_issue_valid_int),
    .x_register_o             (x_register_int),
    .x_register_valid_o       (x_register_valid_int),
    .x_commit_o               (x_commit_int),
    .x_commit_valid_o         (x_commit_valid_int),
    .x_result_ready_o         (x_result_ready_int),
    .narrow_ext_req_o         (narrow_ext_req_int),
    .narrow_ext_resp_i        (narrow_ext_resp_int),
    .tcdm_ext_req_i           (tcdm_ext_req_int),
    .tcdm_ext_resp_o          (tcdm_ext_resp_int),
    .narrow_in_req_i,
    .narrow_in_resp_o,
    .narrow_out_req_o,
    .narrow_out_resp_i,
    .wide_out_req_o,
    .wide_out_resp_i,
    .wide_in_req_i,
    .wide_in_resp_o,
    .dca_req_i                (dca_req_int),
    .dca_rsp_o                (dca_rsp_int)
  );

endmodule
