// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

${disclaimer}

<%def name="to_sv_hex(x, length=None)">\
${"{}'h{}".format(length or "", hex(x)[2:])}\
</%def>

<%def name="icache_cfg(prop)">
  % for lw in cfg['cluster']['hives']:
    ${int(lw['icache'][prop])}${',' if not loop.last else ''}
  % endfor
</%def>

<%def name="core_cfg(prop)">\
  % for c in cfg['cluster']['cores']:
${c[prop]}${', ' if not loop.last else ''}\
  % endfor
</%def>\

<%def name="core_cfg_lambda(f)">\
  % for c in cfg['cluster']['cores']:
${f(c)}${', ' if not loop.last else ''}\
  % endfor
</%def>\

<%def name="core_cfg_flat(prop)">\
${cfg['cluster']['nr_cores']}'b\
  % for c in cfg['cluster']['cores'][::-1]:
${int(c[prop])}\
  % endfor
</%def>\

<%def name="core_isa(core_idx,isa)">\
${int(getattr(cfg['cluster']['cores'][core_idx]['isa_parsed'], isa))}\
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

<%
  actual_num_exposed_wide_tcdm_ports = cfg['cluster']['num_exposed_wide_tcdm_ports']
  if actual_num_exposed_wide_tcdm_ports == 0:
    actual_num_exposed_wide_tcdm_ports += 1
%>

`include "axi/typedef.svh"
`include "tcdm_interface/typedef.svh"
`include "dca_interface/typedef.svh"
`include "cv_x_if/typedef.svh"

// verilog_lint: waive-start package-filename
package snitch_cluster_wrapper_pkg;

  localparam int unsigned NrCores = ${cfg['cluster']['nr_cores']};
  localparam int unsigned NrHives = ${cfg['cluster']['nr_hives']};

  localparam int unsigned TcdmSize = ${cfg['cluster']['tcdm']['size']};
  localparam int unsigned TcdmSizeNapotRounded = 1 << $clog2(TcdmSize);
  localparam int unsigned ClusterPeriphSize = ${cfg['cluster']['cluster_periph_size']};
  localparam int unsigned ExtMemorySize = ${cfg['cluster']['ext_mem_size']};

  localparam int unsigned AddrWidth = ${cfg['cluster']['addr_width']};
  localparam int unsigned NarrowDataWidth = ${cfg['cluster']['data_width']};
  localparam int unsigned WideDataWidth = ${cfg['cluster']['dma_data_width']};

  localparam int unsigned NarrowIdWidthIn = ${cfg['cluster']['id_width_in']};
  localparam int unsigned NrNarrowMasters = 3;
  localparam int unsigned NarrowIdWidthOut = $clog2(NrNarrowMasters) + NarrowIdWidthIn;

  localparam int unsigned NrWideMasters = ${cfg['cluster']['dma_nr_channels']} + ${cfg['cluster']['nr_hives']};
  localparam int unsigned WideIdWidthIn = ${cfg['cluster']['dma_id_width_in']};
  localparam int unsigned WideIdWidthOut = $clog2(NrWideMasters) + WideIdWidthIn;

  localparam bit EnableWideCollectives = ${int(cfg['cluster']['enable_wide_collectives'])};
  localparam bit EnableNarrowCollectives = ${int(cfg['cluster']['enable_narrow_collectives'])};

  localparam int unsigned AtomicIdWidth = ${cfg['cluster']['atomic_id_width']};
  localparam int unsigned CollectiveWidth = ${cfg['cluster']['collective_width']};

  localparam int unsigned ICacheLineWidth [NrHives] = '{${icache_cfg('cacheline')}};
  localparam int unsigned ICacheLineCount [NrHives] = '{${icache_cfg('depth')}};
  localparam int unsigned ICacheWays [NrHives] = '{${icache_cfg('ways')}};
  localparam bit ICacheL1TagScm [NrHives] = '{${icache_cfg('tag_scm')}};
  localparam bit ICacheL1DataScm [NrHives] = '{${icache_cfg('data_scm')}};

  localparam int unsigned Hive [NrCores] = '{${core_cfg('hive')}};

  localparam int unsigned TcdmAddrWidth = $clog2(TcdmSize*1024);

  localparam int unsigned XifIdWidth = ${cfg['cluster']['xif_id_width']};

  typedef struct packed {
% for field, width in cfg['cluster']['sram_cfg_fields'].items():
    logic [${width-1}:0] ${field};
% endfor
  } sram_cfg_t;

  // Define dca_req_t and dca_rsp_t
  `DCA_TYPEDEF_ALL(dca, WideDataWidth)

  // Define x_issue_req_t, x_issue_resp_t, x_register_t, x_commit_t, x_result_t
  `CV_X_IF_TYPEDEF_ALL(XifIdWidth)

  typedef logic [AddrWidth-1:0]         addr_t;
  typedef logic [NarrowDataWidth-1:0]   data_t;
  typedef logic [NarrowDataWidth/8-1:0] strb_t;
  typedef logic [WideDataWidth-1:0]     data_dma_t;
  typedef logic [WideDataWidth/8-1:0]   strb_dma_t;
  typedef logic [NarrowIdWidthIn-1:0]   narrow_in_id_t;
  typedef logic [NarrowIdWidthOut-1:0]  narrow_out_id_t;
  typedef logic [WideIdWidthIn-1:0]     wide_in_id_t;
  typedef logic [WideIdWidthOut-1:0]    wide_out_id_t;

% if cfg['cluster']['enable_narrow_collectives']:
  typedef struct packed {
    addr_t                          collective_mask;
    logic [CollectiveWidth-1:0]     collective_op;
    logic [AtomicIdWidth-1:0]       atomic_id;
  } user_narrow_t;
%else:
  typedef struct packed {
    logic [AtomicIdWidth-1:0]       atomic_id;
  } user_narrow_t;
%endif

% if cfg['cluster']['enable_wide_collectives']:
  typedef struct packed {
    addr_t                          collective_mask;
    logic [CollectiveWidth-1:0]     collective_op;
  } user_dma_t;
%else:
  typedef logic user_dma_t;
%endif

  localparam int unsigned NarrowUserWidth = $bits(user_narrow_t);
  localparam int unsigned WideUserWidth = $bits(user_dma_t);

  `AXI_TYPEDEF_ALL(narrow_in, addr_t, narrow_in_id_t, data_t, strb_t, user_narrow_t)
  `AXI_TYPEDEF_ALL(narrow_out, addr_t, narrow_out_id_t, data_t, strb_t, user_narrow_t)
  `AXI_TYPEDEF_ALL(wide_in, addr_t, wide_in_id_t, data_dma_t, strb_dma_t, user_dma_t)
  `AXI_TYPEDEF_ALL(wide_out, addr_t, wide_out_id_t, data_dma_t, strb_dma_t, user_dma_t)

  `TCDM_TYPEDEF_ALL(tcdm_dma, WideDataWidth, TcdmAddrWidth, 1)

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
                        ${cfg['cluster']['timing']['lat_comp_fp8_alt']},  // FP8alt
                        1, // FP6
                        1, // FP6alt
                        1  // FP4
                      },
                    '{1, 1, 1, 1, 1, 1, 1, 1, 1},   // DIVSQRT
                    '{${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      ${cfg['cluster']['timing']['lat_noncomp']},
                      1,
                      1,
                      1},   // NONCOMP
                    '{${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      ${cfg['cluster']['timing']['lat_conv']},
                      1,
                      1,
                      1},   // CONV
                    '{${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      ${cfg['cluster']['timing']['lat_sdotp']},
                      1,
                      1,
                      1},    // DOTP
                    '{1, 1, 1, 1, 1, 1, 1, 1, 1}   // MXDOTP
                    },
        UnitTypes: '{'{fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::MERGED,
                       fpnew_pkg::DISABLED,
                       fpnew_pkg::DISABLED,
                       fpnew_pkg::DISABLED},  // FMA
% if c["Xdiv_sqrt"]:
                    '{fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED}, // DIVSQRT
% else:
                    '{fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
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
                        fpnew_pkg::PARALLEL,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED}, // NONCOMP
                    '{fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED},   // CONV
% if c["xfdotp"]:
                    '{fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::MERGED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED},  // DOTP
% else:
                    '{fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED}, // DOTP
% endif
                    '{fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED,
                        fpnew_pkg::DISABLED}}, // MXDOTP
        PipeConfig: fpnew_pkg::${cfg['cluster']['timing']['fpu_pipe_config']}
    }${',\n' if not loop.last else '\n'}\
  % endfor
  };

  localparam snitch_pkg::isa_cfg_t IsaCfg [${cfg['cluster']['nr_cores']}] = '{
  % for i, c in list(enumerate(cfg['cluster']['cores'])):
    '{
      RVE: ${int(getattr(c['isa_parsed'], 'e'))},
      RVF: ${int(getattr(c['isa_parsed'], 'f'))},
      RVD: ${int(getattr(c['isa_parsed'], 'd'))},
      RVV: ${int(getattr(c['isa_parsed'], 'v'))},
      Xdma: ${int(c['xdma'])},
      Xssr: ${int(c['xssr'])},
      Xfrep: ${int(c['xfrep'])},
      Xcopift: ${int(c['xcopift'])},
      Zfh: ${int(c['zfh'])},
      XF16ALT: ${int(c['xf16alt'])},
      XF8: ${int(c['xf8'])},
      XF8ALT: ${int(c['xf8alt'])},
      XDivSqrt: ${int(c['Xdiv_sqrt'])},
      XFVEC: ${int(c['xfvec'])},
      XFDOTP: ${int(c['xfdotp'])},
      // FMA architecture is "merged" -> mulexp and macexp instructions are supported
      XFAUX: FPUImplementation[${i}].UnitTypes[3] == fpnew_pkg::MERGED,
      Xcvmem: ${int(c['xcvmem'])},
      Xpulpabs: ${int(c['xpulpabs'])},
      Xpulpbitop: ${int(c['xpulpbitop'])},
      Xpulpbr: ${int(c['xpulpbr'])},
      Xpulpclip: ${int(c['xpulpclip'])},
      Xpulpmacsi: ${int(c['xpulpmacsi'])},
      Xpulpminmax: ${int(c['xpulpminmax'])},
      Xpulpslet: ${int(c['xpulpslet'])},
      Xpulpvect: ${int(c['xpulpvect'])},
      Xpulpvectshufflepack: ${int(c['xpulpvectshufflepack'])}
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
  localparam snitch_pkg::hart_id_t   CfgBaseHartId        = (${to_sv_hex(cfg['cluster']['cluster_base_hartid'], 32)});
  localparam addr_t                  CfgClusterBaseAddr   = (${to_sv_hex(cfg['cluster']['cluster_base_addr'], cfg['cluster']['addr_width'])});
  localparam addr_t                  CfgClusterBaseOffset = (${to_sv_hex(cfg['cluster']['cluster_base_offset'], cfg['cluster']['addr_width'])});

  // Cluster configuration parameters for snitch_cluster instantiation
  localparam logic [31:0]            BootAddr           = ${to_sv_hex(cfg['cluster']['boot_addr'], 32)};
  localparam bit                     IntBootromEnable   = ${int(cfg['cluster']['int_bootrom_enable'])};
  localparam int unsigned            TCDMDepth          = ${cfg['cluster']['tcdm']['depth']};
  localparam int unsigned            NrBanks            = ${cfg['cluster']['tcdm']['banks']};
  localparam int unsigned            NrHyperBanks       = ${cfg['cluster']['tcdm']['hyperbanks']};
  localparam int unsigned            DMANumAxInFlight   = ${cfg['cluster']['dma_axi_req_fifo_depth']};
  localparam int unsigned            DMAReqFifoDepth    = ${cfg['cluster']['dma_req_fifo_depth']};
  localparam int unsigned            DMANumChannels     = ${cfg['cluster']['dma_nr_channels']};
  // NumExpWideTcdmPorts is the effective count used for port sizing (minimum 1).
  // NumExpWideTcdmPortsCfg is the raw configured value used for connection gating.
  localparam int unsigned            NumExpWideTcdmPorts    = ${actual_num_exposed_wide_tcdm_ports};
  localparam int unsigned            NumExpWideTcdmPortsCfg = ${cfg['cluster']['num_exposed_wide_tcdm_ports']};
  localparam bit                     VMSupport          = ${int(cfg['cluster']['vm_support'])};
  localparam bit                     EnableXif          = ${int(cfg['cluster']['enable_xif'])};
  localparam bit [NrCores-1:0]       PrivateIpu         = ${core_cfg_flat('private_ipu')};
  localparam int unsigned            NumSsrsMax         = ${cfg['cluster']['num_ssrs_max']};
  localparam snitch_cluster_pkg::topo_e Topology        = snitch_cluster_pkg::${cfg['cluster']['tcdm']['topology']};
  localparam int unsigned            Radix              = ${int(cfg['cluster']['tcdm']['radix'])};
  localparam int unsigned            NumSwitchNets      = ${int(cfg['cluster']['tcdm']['num_switch_nets'])};
  localparam bit                     SwitchLfsrArbiter  = ${int(cfg['cluster']['tcdm']['switch_lfsr_arbiter'])};
  localparam bit                     RegisterOffloadReq = ${int(cfg['cluster']['timing']['register_offload_req'])};
  localparam bit                     RegisterOffloadRsp = ${int(cfg['cluster']['timing']['register_offload_rsp'])};
  localparam bit                     RegisterCoreReq    = ${int(cfg['cluster']['timing']['register_core_req'])};
  localparam bit                     RegisterCoreRsp    = ${int(cfg['cluster']['timing']['register_core_rsp'])};
  localparam bit                     RegisterTCDMCuts   = ${int(cfg['cluster']['timing']['register_tcdm_cuts'])};
  localparam bit                     RegisterExtWide    = ${int(cfg['cluster']['timing']['register_ext_wide'])};
  localparam bit                     RegisterExtNarrow  = ${int(cfg['cluster']['timing']['register_ext_narrow'])};
  localparam bit                     RegisterExpNarrow  = ${int(cfg['cluster']['timing']['register_exp_narrow'])};
  localparam bit                     RegisterFPUReq     = ${int(cfg['cluster']['timing']['register_fpu_req'])};
  localparam bit                     RegisterFPUIn      = ${int(cfg['cluster']['timing']['register_fpu_in'])};
  localparam bit                     RegisterFPUOut     = ${int(cfg['cluster']['timing']['register_fpu_out'])};
  localparam bit                     RegisterDcaReq     = ${int(cfg['cluster']['timing']['register_dca_req'])};
  localparam bit                     RegisterDcaRsp     = ${int(cfg['cluster']['timing']['register_dca_rsp'])};
  localparam bit                     RegisterSequencer  = ${int(cfg['cluster']['timing']['register_sequencer'])};
  localparam bit                     IsoCrossing        = ${int(cfg['cluster']['timing']['iso_crossings'])};
  localparam axi_pkg::xbar_latency_e NarrowXbarLatency  = axi_pkg::${cfg['cluster']['timing']['narrow_xbar_latency']};
  localparam axi_pkg::xbar_latency_e WideXbarLatency    = axi_pkg::${cfg['cluster']['timing']['wide_xbar_latency']};
  localparam int unsigned            WideMaxTrans       = ${cfg['cluster']['wide_trans']};
  localparam int unsigned            NarrowMaxTrans     = ${cfg['cluster']['narrow_trans']};
  localparam int unsigned            CaqDepth           = ${int(cfg['cluster']['caq_depth'])};
  localparam int unsigned            CaqTagWidth        = ${int(cfg['cluster']['caq_tag_width'])};
  localparam bit                     DebugSupport       = ${int(cfg['cluster']['enable_debug'])};
  localparam bit                     AliasRegionEnable  = ${int(cfg['cluster']['alias_region_enable'])};
  localparam int unsigned            AliasRegionBase    = ${int(cfg['cluster']['alias_region_base'])};
  localparam bit                     EnableDca          = ${int(cfg['cluster']['enable_dca'])};
  localparam int unsigned            DcaDataWidth       = ${int(cfg['cluster']['dca_data_width'])};

  // Feature flags controlling wrapper port connections
  localparam bit EnableExternalInterrupts = ${int(cfg['cluster']['enable_external_interrupts'])};
  localparam bit ClusterBaseExpose        = ${int(cfg['cluster']['cluster_base_expose'])};
  localparam bit SramCfgExpose            = ${int(cfg['cluster']['sram_cfg_expose'])};
  localparam bit NarrowAxiPortExpose      = ${int(cfg['cluster']['narrow_axi_port_expose'])};

  // Per-core localparam arrays
  localparam int unsigned NumIntOutstandingLoads   [NrCores] = '{${core_cfg('num_int_outstanding_loads')}};
  localparam int unsigned NumIntOutstandingMem     [NrCores] = '{${core_cfg('num_int_outstanding_mem')}};
  localparam int unsigned NumFPOutstandingLoads    [NrCores] = '{${core_cfg('num_fp_outstanding_loads')}};
  localparam int unsigned NumFPOutstandingMem      [NrCores] = '{${core_cfg('num_fp_outstanding_mem')}};
  localparam int unsigned NumDTLBEntries           [NrCores] = '{${core_cfg('num_dtlb_entries')}};
  localparam int unsigned NumITLBEntries           [NrCores] = '{${core_cfg('num_itlb_entries')}};
  localparam int unsigned NumSequencerInstr        [NrCores] = '{${core_cfg('num_sequencer_instructions')}};
  localparam int unsigned NumSequencerLoops        [NrCores] = '{${core_cfg('num_sequencer_loops')}};
  localparam int unsigned NumSsrs                  [NrCores] = '{${core_cfg('num_ssrs')}};
  localparam int unsigned SsrMuxRspDepth           [NrCores] = '{${core_cfg('ssr_mux_rsp_depth')}};
  localparam bit          SpatzDoubleBw            [NrCores] = '{${core_cfg_lambda(lambda x: int(x['spatz']['double_bw']))}};
  localparam int unsigned NumSpatzOutstandingLoads [NrCores] = '{${core_cfg_lambda(lambda x: int(x['spatz']['num_outstanding_loads']))}};

endpackage
// verilog_lint: waive-stop package-filename
