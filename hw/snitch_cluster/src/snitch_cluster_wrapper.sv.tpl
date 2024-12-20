// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

${disclaimer}

<%def name="icache_cfg(prop)">
  % for lw in cfg['hives']:
    ${lw['icache'][prop]}${',' if not loop.last else ''}
  % endfor
</%def>

<%def name="core_cfg(prop)">\
  % for c in cfg['cores']:
${c[prop]}${', ' if not loop.last else ''}\
  % endfor
</%def>\

<%def name="core_cfg_flat(prop)">\
${cfg['nr_cores']}'b\
  % for c in cfg['cores'][::-1]:
${int(c[prop])}\
  % endfor
</%def>\

<%def name="core_isa(isa)">\
${cfg['nr_cores']}'b\
  % for c in cfg['cores'][::-1]:
${int(getattr(c['isa_parsed'], isa))}\
  % endfor
</%def>\

<%def name="ssr_cfg(core, ssr_fmt_str, none_str, inner_sep)">\
% for core in cfg['cores']:
  % for s in list(reversed(core['ssrs'] + [None]*(cfg['num_ssrs_max']-len(core['ssrs'])))):
${("    '{" if loop.first else ' ') + \
    (ssr_fmt_str.format(**s) if s is not None else none_str) \
    + (inner_sep if not loop.last else '}')}\
  % endfor
${',' if not loop.last else ''}
% endfor
</%def>\

module ${cfg['name']}_wrapper (
  input  logic                                   clk_i,
  input  logic                                   rst_ni,
  input  logic [${cfg['pkg_name']}::NrCores-1:0] debug_req_i,
  input  logic [${cfg['pkg_name']}::NrCores-1:0] meip_i,
  input  logic [${cfg['pkg_name']}::NrCores-1:0] mtip_i,
  input  logic [${cfg['pkg_name']}::NrCores-1:0] msip_i,
  input  logic [9:0]                             hart_base_id_i,
  input  logic [${cfg['addr_width']-1}:0]                            cluster_base_addr_i,
  input  logic                                   clk_d2_bypass_i,
  input  ${cfg['pkg_name']}::sram_cfgs_t         sram_cfgs_i,
  input  ${cfg['pkg_name']}::narrow_in_req_t     narrow_in_req_i,
  output ${cfg['pkg_name']}::narrow_in_resp_t    narrow_in_resp_o,
  output ${cfg['pkg_name']}::narrow_out_req_t    narrow_out_req_o,
  input  ${cfg['pkg_name']}::narrow_out_resp_t   narrow_out_resp_i,
  output ${cfg['pkg_name']}::wide_out_req_t      wide_out_req_o,
  input  ${cfg['pkg_name']}::wide_out_resp_t     wide_out_resp_i,
  input  ${cfg['pkg_name']}::wide_in_req_t       wide_in_req_i,
  output ${cfg['pkg_name']}::wide_in_resp_t      wide_in_resp_o
);

  localparam int unsigned NumIntOutstandingLoads [${cfg['nr_cores']}] = '{${core_cfg('num_int_outstanding_loads')}};
  localparam int unsigned NumIntOutstandingMem [${cfg['nr_cores']}] = '{${core_cfg('num_int_outstanding_mem')}};
  localparam int unsigned NumFPOutstandingLoads [${cfg['nr_cores']}] = '{${core_cfg('num_fp_outstanding_loads')}};
  localparam int unsigned NumFPOutstandingMem [${cfg['nr_cores']}] = '{${core_cfg('num_fp_outstanding_mem')}};
  localparam int unsigned NumDTLBEntries [${cfg['nr_cores']}] = '{${core_cfg('num_dtlb_entries')}};
  localparam int unsigned NumITLBEntries [${cfg['nr_cores']}] = '{${core_cfg('num_itlb_entries')}};
  localparam int unsigned NumSequencerInstr [${cfg['nr_cores']}] = '{${core_cfg('num_sequencer_instructions')}};
  localparam int unsigned NumSsrs [${cfg['nr_cores']}] = '{${core_cfg('num_ssrs')}};
  localparam int unsigned SsrMuxRespDepth [${cfg['nr_cores']}] = '{${core_cfg('ssr_mux_resp_depth')}};

  // Snitch cluster under test.
  snitch_cluster #(
    .PhysicalAddrWidth (${cfg['addr_width']}),
    .NarrowDataWidth (${cfg['data_width']}),
    .WideDataWidth (${cfg['dma_data_width']}),
    .NarrowIdWidthIn (${cfg['pkg_name']}::NarrowIdWidthIn),
    .WideIdWidthIn (${cfg['pkg_name']}::WideIdWidthIn),
    .NarrowUserWidth (${cfg['pkg_name']}::NarrowUserWidth),
    .WideUserWidth (${cfg['pkg_name']}::WideUserWidth),
    .BootAddr (${to_sv_hex(cfg['boot_addr'], 32)}),
    .narrow_in_req_t (${cfg['pkg_name']}::narrow_in_req_t),
    .narrow_in_resp_t (${cfg['pkg_name']}::narrow_in_resp_t),
    .narrow_out_req_t (${cfg['pkg_name']}::narrow_out_req_t),
    .narrow_out_resp_t (${cfg['pkg_name']}::narrow_out_resp_t),
    .wide_out_req_t (${cfg['pkg_name']}::wide_out_req_t),
    .wide_out_resp_t (${cfg['pkg_name']}::wide_out_resp_t),
    .wide_in_req_t (${cfg['pkg_name']}::wide_in_req_t),
    .wide_in_resp_t (${cfg['pkg_name']}::wide_in_resp_t),
    .NrHives (${cfg['nr_hives']}),
    .NrCores (${cfg['nr_cores']}),
    .TCDMDepth (${cfg['tcdm']['depth']}),
    .ZeroMemorySize (${cfg['zero_mem_size']}),
    .ClusterPeriphSize (${cfg['cluster_periph_size']}),
    .NrBanks (${cfg['tcdm']['banks']}),
    .DMANumAxInFlight (${cfg['dma_axi_req_fifo_depth']}),
    .DMAReqFifoDepth (${cfg['dma_req_fifo_depth']}),
    .DMANumChannels (${cfg['dma_nr_channels']}),
    .ICacheLineWidth (${cfg['pkg_name']}::ICacheLineWidth),
    .ICacheLineCount (${cfg['pkg_name']}::ICacheLineCount),
    .ICacheWays (${cfg['pkg_name']}::ICacheWays),
    .VMSupport (${int(cfg['vm_support'])}),
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
    .FPUImplementation (${cfg['pkg_name']}::FPUImplementation),
    .SnitchPMACfg (${cfg['pkg_name']}::SnitchPMACfg),
    .NumIntOutstandingLoads (NumIntOutstandingLoads),
    .NumIntOutstandingMem (NumIntOutstandingMem),
    .NumFPOutstandingLoads (NumFPOutstandingLoads),
    .NumFPOutstandingMem (NumFPOutstandingMem),
    .NumDTLBEntries (NumDTLBEntries),
    .NumITLBEntries (NumITLBEntries),
    .NumSsrsMax (${cfg['num_ssrs_max']}),
    .NumSsrs (NumSsrs),
    .SsrMuxRespDepth (SsrMuxRespDepth),
    .SsrRegs (${cfg['pkg_name']}::SsrRegs),
    .SsrCfgs (${cfg['pkg_name']}::SsrCfgs),
    .NumSequencerInstr (NumSequencerInstr),
    .Hive (${cfg['pkg_name']}::Hive),
    .Topology (snitch_pkg::${cfg['tcdm']['topology']}),
    .Radix (${int(cfg['tcdm']['radix'])}),
    .NumSwitchNets (${int(cfg['tcdm']['num_switch_nets'])}),
    .SwitchLfsrArbiter (${int(cfg['tcdm']['switch_lfsr_arbiter'])}),
    .RegisterOffloadReq (${int(cfg['timing']['register_offload_req'])}),
    .RegisterOffloadRsp (${int(cfg['timing']['register_offload_rsp'])}),
    .RegisterCoreReq (${int(cfg['timing']['register_core_req'])}),
    .RegisterCoreRsp (${int(cfg['timing']['register_core_rsp'])}),
    .RegisterTCDMCuts (${int(cfg['timing']['register_tcdm_cuts'])}),
    .RegisterExtWide (${int(cfg['timing']['register_ext_wide'])}),
    .RegisterExtNarrow (${int(cfg['timing']['register_ext_narrow'])}),
    .RegisterFPUReq (${int(cfg['timing']['register_fpu_req'])}),
    .RegisterFPUIn (${int(cfg['timing']['register_fpu_in'])}),
    .RegisterFPUOut (${int(cfg['timing']['register_fpu_out'])}),
    .RegisterSequencer (${int(cfg['timing']['register_sequencer'])}),
    .IsoCrossing (${int(cfg['timing']['iso_crossings'])}),
    .NarrowXbarLatency (axi_pkg::${cfg['timing']['narrow_xbar_latency']}),
    .WideXbarLatency (axi_pkg::${cfg['timing']['wide_xbar_latency']}),
    .WideMaxMstTrans (${cfg['wide_trans']}),
    .WideMaxSlvTrans (${cfg['wide_trans']}),
    .NarrowMaxMstTrans (${cfg['narrow_trans']}),
    .NarrowMaxSlvTrans (${cfg['narrow_trans']}),
    .sram_cfg_t (${cfg['pkg_name']}::sram_cfg_t),
    .sram_cfgs_t (${cfg['pkg_name']}::sram_cfgs_t),
    .CaqDepth (${int(cfg['caq_depth'])}),
    .CaqTagWidth (${int(cfg['caq_tag_width'])}),
    .DebugSupport (${int(cfg['enable_debug'])}),
    .AliasRegionEnable (${int(cfg['alias_region_enable'])}),
    .AliasRegionBase (${int(cfg['alias_region_base'])})
  ) i_cluster (
    .clk_i,
    .rst_ni,
% if cfg['enable_debug']:
    .debug_req_i,
% else:
    .debug_req_i ('0),
% endif
    .meip_i,
    .mtip_i,
    .msip_i,
% if cfg['cluster_base_expose']:
    .hart_base_id_i,
    .cluster_base_addr_i,
% else:
    .hart_base_id_i (snitch_cluster_pkg::CfgBaseHartId),
    .cluster_base_addr_i (snitch_cluster_pkg::CfgClusterBaseAddr),
% endif
% if cfg['timing']['iso_crossings']:
    .clk_d2_bypass_i,
% else:
    .clk_d2_bypass_i (1'b0),
% endif
% if cfg['sram_cfg_expose']:
    .sram_cfgs_i (sram_cfgs_i),
% else:
    .sram_cfgs_i (${cfg['pkg_name']}::sram_cfgs_t'('0)),
%endif
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
