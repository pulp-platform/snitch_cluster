// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

${disclaimer}

<%def name="to_sv_hex(x, length=None)">\
${"{}'h{}".format(length or "", hex(x)[2:])}\
</%def>

<%def name="core_cfg(prop)">\
  % for c in cfg['cluster']['cores']:
${c[prop]}${', ' if not loop.last else ''}\
  % endfor
</%def>\

<%def name="core_cfg_flat(prop)">\
${cfg['cluster']['nr_cores']}'b\
  % for c in cfg['cluster']['cores'][::-1]:
${int(c[prop])}\
  % endfor
</%def>\

<%def name="core_isa(isa)">\
${cfg['cluster']['nr_cores']}'b\
  % for c in cfg['cluster']['cores'][::-1]:
${int(getattr(c['isa_parsed'], isa))}\
  % endfor
</%def>\

<%
  actual_num_exposed_wide_tcdm_ports = cfg['cluster']['num_exposed_wide_tcdm_ports']
  if actual_num_exposed_wide_tcdm_ports == 0:
    actual_num_exposed_wide_tcdm_ports += 1
%>

module ${cfg['cluster']['name']}_wrapper (
  input  logic                                   clk_i,
  input  logic                                   rst_ni,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] debug_req_i,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] meip_i,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] mtip_i,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] msip_i,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] mxip_i,
  input  logic [9:0]                             hart_base_id_i,
  input  logic [${cfg['cluster']['addr_width']-1}:0]                            cluster_base_addr_i,
  input  logic                                   clk_d2_bypass_i,
  input  ${cfg['cluster']['name']}_pkg::sram_cfgs_t         sram_cfgs_i,
  input  ${cfg['cluster']['name']}_pkg::narrow_in_req_t     narrow_in_req_i,
  output ${cfg['cluster']['name']}_pkg::narrow_in_resp_t    narrow_in_resp_o,
  output ${cfg['cluster']['name']}_pkg::narrow_out_req_t    narrow_out_req_o,
  input  ${cfg['cluster']['name']}_pkg::narrow_out_resp_t   narrow_out_resp_i,
  output ${cfg['cluster']['name']}_pkg::wide_out_req_t      wide_out_req_o,
  input  ${cfg['cluster']['name']}_pkg::wide_out_resp_t     wide_out_resp_i,
  input  ${cfg['cluster']['name']}_pkg::wide_in_req_t       wide_in_req_i,
  output ${cfg['cluster']['name']}_pkg::wide_in_resp_t      wide_in_resp_o,
  output ${cfg['cluster']['name']}_pkg::narrow_out_req_t    narrow_ext_req_o,
  input  ${cfg['cluster']['name']}_pkg::narrow_out_resp_t   narrow_ext_resp_i,
  input  ${cfg['cluster']['name']}_pkg::tcdm_dma_req_t [${actual_num_exposed_wide_tcdm_ports}-1:0] tcdm_ext_req_i,
  output ${cfg['cluster']['name']}_pkg::tcdm_dma_rsp_t [${actual_num_exposed_wide_tcdm_ports}-1:0] tcdm_ext_resp_o
);

  localparam int unsigned NumIntOutstandingLoads [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_int_outstanding_loads')}};
  localparam int unsigned NumIntOutstandingMem [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_int_outstanding_mem')}};
  localparam int unsigned NumFPOutstandingLoads [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_fp_outstanding_loads')}};
  localparam int unsigned NumFPOutstandingMem [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_fp_outstanding_mem')}};
  localparam int unsigned NumDTLBEntries [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_dtlb_entries')}};
  localparam int unsigned NumITLBEntries [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_itlb_entries')}};
  localparam int unsigned NumSequencerInstr [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_sequencer_instructions')}};
  localparam int unsigned NumSequencerLoops [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_sequencer_loops')}};
  localparam int unsigned NumSsrs [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_ssrs')}};
  localparam int unsigned SsrMuxRespDepth [${cfg['cluster']['nr_cores']}] = '{${core_cfg('ssr_mux_resp_depth')}};

  // Snitch cluster under test.
  snitch_cluster #(
    .PhysicalAddrWidth (${cfg['cluster']['addr_width']}),
    .NarrowDataWidth (${cfg['cluster']['data_width']}),
    .WideDataWidth (${cfg['cluster']['dma_data_width']}),
    .NarrowIdWidthIn (${cfg['cluster']['name']}_pkg::NarrowIdWidthIn),
    .WideIdWidthIn (${cfg['cluster']['name']}_pkg::WideIdWidthIn),
    .NarrowUserWidth (${cfg['cluster']['name']}_pkg::NarrowUserWidth),
    .WideUserWidth (${cfg['cluster']['name']}_pkg::WideUserWidth),
    .AtomicIdWidth (${cfg['cluster']['name']}_pkg::AtomicIdWidth),
    .BootAddr (${to_sv_hex(cfg['cluster']['boot_addr'], 32)}),
    .IntBootromEnable (${int(cfg['cluster']['int_bootrom_enable'])}),
    .narrow_in_req_t (${cfg['cluster']['name']}_pkg::narrow_in_req_t),
    .narrow_in_resp_t (${cfg['cluster']['name']}_pkg::narrow_in_resp_t),
    .narrow_out_req_t (${cfg['cluster']['name']}_pkg::narrow_out_req_t),
    .narrow_out_resp_t (${cfg['cluster']['name']}_pkg::narrow_out_resp_t),
    .wide_out_req_t (${cfg['cluster']['name']}_pkg::wide_out_req_t),
    .wide_out_resp_t (${cfg['cluster']['name']}_pkg::wide_out_resp_t),
    .wide_in_req_t (${cfg['cluster']['name']}_pkg::wide_in_req_t),
    .wide_in_resp_t (${cfg['cluster']['name']}_pkg::wide_in_resp_t),
    .tcdm_dma_req_t (${cfg['cluster']['name']}_pkg::tcdm_dma_req_t),
    .tcdm_dma_rsp_t (${cfg['cluster']['name']}_pkg::tcdm_dma_rsp_t),
    .NrHives (${cfg['cluster']['nr_hives']}),
    .NrCores (${cfg['cluster']['nr_cores']}),
    .TCDMDepth (${cfg['cluster']['tcdm']['depth']}),
    .ZeroMemorySize (snitch_cluster_pkg::ZeroMemorySize),
    .ExtMemorySize (snitch_cluster_pkg::ExtMemorySize),
    .BootRomSize (snitch_cluster_pkg::BootromSize),
    .ClusterPeriphSize (snitch_cluster_pkg::ClusterPeriphSize),
    .NrBanks (${cfg['cluster']['tcdm']['banks']}),
    .NrHyperBanks (${cfg['cluster']['tcdm']['hyperbanks']}),
    .DMANumAxInFlight (${cfg['cluster']['dma_axi_req_fifo_depth']}),
    .DMAReqFifoDepth (${cfg['cluster']['dma_req_fifo_depth']}),
    .DMANumChannels (${cfg['cluster']['dma_nr_channels']}),
    .NumExpWideTcdmPorts (${actual_num_exposed_wide_tcdm_ports}),
    .ICacheLineWidth (${cfg['cluster']['name']}_pkg::ICacheLineWidth),
    .ICacheLineCount (${cfg['cluster']['name']}_pkg::ICacheLineCount),
    .ICacheWays (${cfg['cluster']['name']}_pkg::ICacheWays),
    .VMSupport (${int(cfg['cluster']['vm_support'])}),
    .EnableDMAMulticast (${int(cfg['cluster']['enable_multicast'])}),
    .RVE (${core_isa('e')}),
    .RVF (${core_isa('f')}),
    .RVD (${core_isa('d')}),
    .XDivSqrt (${core_cfg_flat('Xdiv_sqrt')}),
    .XF16 (${core_cfg_flat('xf16')}),
    .XF16ALT (${core_cfg_flat('xf16alt')}),
    .XF8 (${core_cfg_flat('xf8')}),
    .XF8ALT (${core_cfg_flat('xf8alt')}),
    .XFVEC (${core_cfg_flat('xfvec')}),
    .XFDOTP (${core_cfg_flat('xfdotp')}),
    .Xdma (${core_cfg_flat('xdma')}),
    .Xssr (${core_cfg_flat('xssr')}),
    .Xfrep (${core_cfg_flat('xfrep')}),
    .Xcopift (${core_cfg_flat('xcopift')}),
    .FPUImplementation (${cfg['cluster']['name']}_pkg::FPUImplementation),
    .SnitchPMACfg (${cfg['cluster']['name']}_pkg::SnitchPMACfg),
    .NumIntOutstandingLoads (NumIntOutstandingLoads),
    .NumIntOutstandingMem (NumIntOutstandingMem),
    .NumFPOutstandingLoads (NumFPOutstandingLoads),
    .NumFPOutstandingMem (NumFPOutstandingMem),
    .NumDTLBEntries (NumDTLBEntries),
    .NumITLBEntries (NumITLBEntries),
    .NumSsrsMax (${cfg['cluster']['num_ssrs_max']}),
    .NumSsrs (NumSsrs),
    .SsrMuxRespDepth (SsrMuxRespDepth),
    .SsrRegs (${cfg['cluster']['name']}_pkg::SsrRegs),
    .SsrCfgs (${cfg['cluster']['name']}_pkg::SsrCfgs),
    .NumSequencerInstr (NumSequencerInstr),
    .NumSequencerLoops (NumSequencerLoops),
    .Hive (${cfg['cluster']['name']}_pkg::Hive),
    .Topology (snitch_pkg::${cfg['cluster']['tcdm']['topology']}),
    .Radix (${int(cfg['cluster']['tcdm']['radix'])}),
    .NumSwitchNets (${int(cfg['cluster']['tcdm']['num_switch_nets'])}),
    .SwitchLfsrArbiter (${int(cfg['cluster']['tcdm']['switch_lfsr_arbiter'])}),
    .RegisterOffloadReq (${int(cfg['cluster']['timing']['register_offload_req'])}),
    .RegisterOffloadRsp (${int(cfg['cluster']['timing']['register_offload_rsp'])}),
    .RegisterCoreReq (${int(cfg['cluster']['timing']['register_core_req'])}),
    .RegisterCoreRsp (${int(cfg['cluster']['timing']['register_core_rsp'])}),
    .RegisterTCDMCuts (${int(cfg['cluster']['timing']['register_tcdm_cuts'])}),
    .RegisterExtWide (${int(cfg['cluster']['timing']['register_ext_wide'])}),
    .RegisterExtNarrow (${int(cfg['cluster']['timing']['register_ext_narrow'])}),
    .RegisterExpNarrow (${int(cfg['cluster']['timing']['register_exp_narrow'])}),
    .RegisterFPUReq (${int(cfg['cluster']['timing']['register_fpu_req'])}),
    .RegisterFPUIn (${int(cfg['cluster']['timing']['register_fpu_in'])}),
    .RegisterFPUOut (${int(cfg['cluster']['timing']['register_fpu_out'])}),
    .RegisterSequencer (${int(cfg['cluster']['timing']['register_sequencer'])}),
    .IsoCrossing (${int(cfg['cluster']['timing']['iso_crossings'])}),
    .NarrowXbarLatency (axi_pkg::${cfg['cluster']['timing']['narrow_xbar_latency']}),
    .WideXbarLatency (axi_pkg::${cfg['cluster']['timing']['wide_xbar_latency']}),
    .WideMaxMstTrans (${cfg['cluster']['wide_trans']}),
    .WideMaxSlvTrans (${cfg['cluster']['wide_trans']}),
    .NarrowMaxMstTrans (${cfg['cluster']['narrow_trans']}),
    .NarrowMaxSlvTrans (${cfg['cluster']['narrow_trans']}),
    .sram_cfg_t (${cfg['cluster']['name']}_pkg::sram_cfg_t),
    .sram_cfgs_t (${cfg['cluster']['name']}_pkg::sram_cfgs_t),
    .CaqDepth (${int(cfg['cluster']['caq_depth'])}),
    .CaqTagWidth (${int(cfg['cluster']['caq_tag_width'])}),
    .DebugSupport (${int(cfg['cluster']['enable_debug'])}),
    .AliasRegionEnable (${int(cfg['cluster']['alias_region_enable'])}),
    .AliasRegionBase (${int(cfg['cluster']['alias_region_base'])})
  ) i_cluster (
    .clk_i,
    .rst_ni,
% if cfg['cluster']['enable_debug']:
    .debug_req_i,
% else:
    .debug_req_i ('0),
% endif
    .meip_i,
    .mtip_i,
    .msip_i,
% if cfg['cluster']['enable_external_interrupts']:
    .mxip_i,
% else:
    .mxip_i ('0),
% endif
% if cfg['cluster']['cluster_base_expose']:
    .hart_base_id_i,
    .cluster_base_addr_i,
% else:
    .hart_base_id_i (snitch_cluster_pkg::CfgBaseHartId),
    .cluster_base_addr_i (snitch_cluster_pkg::CfgClusterBaseAddr),
% endif
% if cfg['cluster']['timing']['iso_crossings']:
    .clk_d2_bypass_i,
% else:
    .clk_d2_bypass_i (1'b0),
% endif
% if cfg['cluster']['sram_cfg_expose']:
    .sram_cfgs_i (sram_cfgs_i),
% else:
    .sram_cfgs_i (${cfg['cluster']['name']}_pkg::sram_cfgs_t'('0)),
% endif
% if cfg['cluster']['narrow_axi_port_expose']:
    .narrow_ext_req_o (narrow_ext_req_o),
    .narrow_ext_resp_i (narrow_ext_resp_i),
% else:
    .narrow_ext_req_o (narrow_ext_req_o),
    .narrow_ext_resp_i (${cfg['cluster']['name']}_pkg::narrow_out_resp_t'('0)),
% endif
% if cfg['cluster']['num_exposed_wide_tcdm_ports']==0:
    .tcdm_ext_req_i (${cfg['cluster']['name']}_pkg::tcdm_dma_req_t'('0)),
% else:
    .tcdm_ext_req_i (tcdm_ext_req_i),
% endif
    .tcdm_ext_resp_o (tcdm_ext_resp_o),
    .narrow_in_req_i,
    .narrow_in_resp_o,
    .narrow_out_req_o,
    .narrow_out_resp_i,
    .wide_out_req_o,
    .wide_out_resp_i,
    .wide_in_req_i,
    .wide_in_resp_o
  );
endmodule
