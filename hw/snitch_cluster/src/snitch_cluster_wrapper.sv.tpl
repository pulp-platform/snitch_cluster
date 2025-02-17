// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

${disclaimer}

<%def name="to_sv_hex(x, length=None)">\
${"{}'h{}".format(length or "", hex(x)[2:])}\
</%def>

<%def name="icache_cfg(prop)">
  % for lw in cfg['cluster']['hives']:
    ${lw['icache'][prop]}${',' if not loop.last else ''}
  % endfor
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

<%def name="ssr_cfg(core, ssr_fmt_str, none_str, inner_sep)">\
% for core in cfg['cluster']['cores']:
  % for s in list(reversed(core['ssrs'] + [None]*(cfg['cluster']['num_ssrs_max']-len(core['ssrs'])))):
${("    '{" if loop.first else ' ') + \
    (ssr_fmt_str.format(**s) if s is not None else none_str) \
    + (inner_sep if not loop.last else '}')}\
  % endfor
${',' if not loop.last else ''}
% endfor
</%def>\

`include "axi/typedef.svh"

// verilog_lint: waive-start package-filename
package ${cfg['cluster']['name']}_pkg;

  localparam int unsigned NrCores = ${cfg['cluster']['nr_cores']};
  localparam int unsigned NrHives = ${cfg['cluster']['nr_hives']};

  localparam int unsigned TcdmSize = ${cfg['cluster']['tcdm']['size']};
  localparam int unsigned BootromSize = 4; // Fixed size of 4kB
  localparam int unsigned ClusterPeriphSize = ${cfg['cluster']['cluster_periph_size']};
  localparam int unsigned ZeroMemorySize = ${cfg['cluster']['zero_mem_size']};

  localparam int unsigned AddrWidth = ${cfg['cluster']['addr_width']};
  localparam int unsigned NarrowDataWidth = ${cfg['cluster']['data_width']};
  localparam int unsigned WideDataWidth = ${cfg['cluster']['dma_data_width']};

  localparam int unsigned NarrowIdWidthIn = ${cfg['cluster']['id_width_in']};
  localparam int unsigned NrNarrowMasters = 3;
  localparam int unsigned NarrowIdWidthOut = $clog2(NrNarrowMasters) + NarrowIdWidthIn;

  localparam int unsigned NrWideMasters = 1 + ${cfg['cluster']['dma_nr_channels']} + ${cfg['cluster']['nr_hives']};
  localparam int unsigned WideIdWidthIn = ${cfg['cluster']['dma_id_width_in']};
  localparam int unsigned WideIdWidthOut = $clog2(NrWideMasters) + WideIdWidthIn;

  localparam int unsigned NarrowUserWidth = ${cfg['cluster']['user_width']};
  localparam int unsigned WideUserWidth = ${cfg['cluster']['dma_user_width']};

  localparam int unsigned ICacheLineWidth [NrHives] = '{${icache_cfg('cacheline')}};
  localparam int unsigned ICacheLineCount [NrHives] = '{${icache_cfg('depth')}};
  localparam int unsigned ICacheSets [NrHives] = '{${icache_cfg('sets')}};

  localparam int unsigned Hive [NrCores] = '{${core_cfg('hive')}};

  typedef struct packed {
% for field, width in cfg['cluster']['sram_cfg_fields'].items():
    logic [${width-1}:0] ${field};
% endfor
  } sram_cfg_t;

  typedef struct packed {
    sram_cfg_t icache_tag;
    sram_cfg_t icache_data;
    sram_cfg_t tcdm;
  } sram_cfgs_t;

  typedef logic [AddrWidth-1:0]         addr_t;
  typedef logic [NarrowDataWidth-1:0]   data_t;
  typedef logic [NarrowDataWidth/8-1:0] strb_t;
  typedef logic [WideDataWidth-1:0]     data_dma_t;
  typedef logic [WideDataWidth/8-1:0]   strb_dma_t;
  typedef logic [NarrowIdWidthIn-1:0]   narrow_in_id_t;
  typedef logic [NarrowIdWidthOut-1:0]  narrow_out_id_t;
  typedef logic [WideIdWidthIn-1:0]     wide_in_id_t;
  typedef logic [WideIdWidthOut-1:0]    wide_out_id_t;
  typedef logic [NarrowUserWidth-1:0]   user_t;
  typedef logic [WideUserWidth-1:0]     user_dma_t;

  `AXI_TYPEDEF_ALL(narrow_in, addr_t, narrow_in_id_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_ALL(narrow_out, addr_t, narrow_out_id_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_ALL(wide_in, addr_t, wide_in_id_t, data_dma_t, strb_dma_t, user_dma_t)
  `AXI_TYPEDEF_ALL(wide_out, addr_t, wide_out_id_t, data_dma_t, strb_dma_t, user_dma_t)

  function automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] get_cached_regions();
    automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] cached_regions;
    cached_regions = '{default: '0};
% for i, cp in enumerate(cfg['pmas']['cached']):
    cached_regions[${i}] = '{base: ${to_sv_hex(cp[0], cfg['cluster']['addr_width'])}, mask: ${to_sv_hex(cp[1], cfg['cluster']['addr_width'])}};
% endfor
    return cached_regions;
  endfunction

  localparam snitch_pma_pkg::snitch_pma_t SnitchPMACfg = '{
      NrCachedRegionRules: ${len(cfg['pmas']['cached'])},
      CachedRegion: get_cached_regions(),
      default: 0
  };

  localparam fpnew_pkg::fpu_implementation_t FPUImplementation [${cfg['cluster']['nr_cores']}] = '{
  % for c in cfg['cluster']['cores']:
    '{
        PipeRegs: // FMA Block
                  '{
                    '{  ${cfg['cluster']['timing']['lat_comp_fp32']}, // FP32
                        ${cfg['cluster']['timing']['lat_comp_fp64']}, // FP64
                        ${cfg['cluster']['timing']['lat_comp_fp16']}, // FP16
                        ${cfg['cluster']['timing']['lat_comp_fp8']}, // FP8
                        ${cfg['cluster']['timing']['lat_comp_fp16_alt']}, // FP16alt
                        ${cfg['cluster']['timing']['lat_comp_fp8_alt']}  // FP8alt
                      },
                    '{1, 1, 1, 1, 1, 1},   // DIVSQRT
                    '{${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']}},   // NONCOMP
                    '{${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']}},   // CONV
                    '{${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']}}    // DOTP
                    },
        UnitTypes: '{'{fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED},  // FMA
% if c["Xdiv_sqrt"]:
                    '{fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED}, // DIVSQRT
% else:
                    '{fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED}, // DIVSQRT
% endif
                    '{fpnew_pkg::PARALLEL,
                        fpnew_pkg::PARALLEL,
                        fpnew_pkg::PARALLEL,
                        fpnew_pkg::PARALLEL,
                        fpnew_pkg::PARALLEL,
                        fpnew_pkg::PARALLEL}, // NONCOMP
                    '{fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED},   // CONV
% if c["xfdotp"]:
                    '{fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED}},  // DOTP
% else:
                    '{fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED}}, // DOTP
% endif
        PipeConfig: fpnew_pkg::${cfg['cluster']['timing']['fpu_pipe_config']}
    }${',\n' if not loop.last else '\n'}\
  % endfor
  };

  localparam snitch_ssr_pkg::ssr_cfg_t [${cfg['cluster']['num_ssrs_max']}-1:0] SsrCfgs [${cfg['cluster']['nr_cores']}] = '{
${ssr_cfg(core, "'{{{indirection:d}, {isect_master:d}, {isect_master_idx:d}, {isect_slave:d}, "\
  "{isect_slave_spill:d}, {indir_out_spill:d}, {num_loops}, {index_width}, {pointer_width}, "\
  "{shift_width}, {rpt_width}, {index_credits}, {isect_slave_credits}, {data_credits}, "\
  "{mux_resp_depth}}}", "/*None*/ '0", ',\n     ')}\
  };

  localparam logic [${cfg['cluster']['num_ssrs_max']}-1:0][4:0] SsrRegs [${cfg['cluster']['nr_cores']}] = '{
${ssr_cfg(core, '{reg_idx}', '/*None*/ 0', ',')}\
  };

  // Forward potentially optional configuration parameters
  localparam logic [9:0] CfgBaseHartId      =  (${to_sv_hex(cfg['cluster']['cluster_base_hartid'], 10)});
  localparam addr_t    	 CfgClusterBaseAddr = (${to_sv_hex(cfg['cluster']['cluster_base_addr'], cfg['cluster']['addr_width'])});

endpackage
// verilog_lint: waive-stop package-filename

module ${cfg['cluster']['name']}_wrapper (
  input  logic                                   clk_i,
  input  logic                                   rst_ni,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] debug_req_i,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] meip_i,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] mtip_i,
  input  logic [${cfg['cluster']['name']}_pkg::NrCores-1:0] msip_i,
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
  output ${cfg['cluster']['name']}_pkg::wide_in_resp_t      wide_in_resp_o
);

  localparam int unsigned NumIntOutstandingLoads [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_int_outstanding_loads')}};
  localparam int unsigned NumIntOutstandingMem [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_int_outstanding_mem')}};
  localparam int unsigned NumFPOutstandingLoads [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_fp_outstanding_loads')}};
  localparam int unsigned NumFPOutstandingMem [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_fp_outstanding_mem')}};
  localparam int unsigned NumDTLBEntries [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_dtlb_entries')}};
  localparam int unsigned NumITLBEntries [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_itlb_entries')}};
  localparam int unsigned NumSequencerInstr [${cfg['cluster']['nr_cores']}] = '{${core_cfg('num_sequencer_instructions')}};
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
    .NrHives (${cfg['cluster']['nr_hives']}),
    .NrCores (${cfg['cluster']['nr_cores']}),
    .TCDMDepth (${cfg['cluster']['tcdm']['depth']}),
    .ZeroMemorySize (snitch_cluster_pkg::ZeroMemorySize),
    .BootRomSize (snitch_cluster_pkg::BootromSize),
    .ClusterPeriphSize (snitch_cluster_pkg::ClusterPeriphSize),
    .NrBanks (${cfg['cluster']['tcdm']['banks']}),
    .DMANumAxInFlight (${cfg['cluster']['dma_axi_req_fifo_depth']}),
    .DMAReqFifoDepth (${cfg['cluster']['dma_req_fifo_depth']}),
    .DMANumChannels (${cfg['cluster']['dma_nr_channels']}),
    .ICacheLineWidth (${cfg['cluster']['name']}_pkg::ICacheLineWidth),
    .ICacheLineCount (${cfg['cluster']['name']}_pkg::ICacheLineCount),
    .ICacheSets (${cfg['cluster']['name']}_pkg::ICacheSets),
    .VMSupport (${int(cfg['cluster']['vm_support'])}),
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
