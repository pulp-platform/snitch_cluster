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
`include "tcdm_interface/typedef.svh"

// verilog_lint: waive-start package-filename
package ${cfg['cluster']['name']}_pkg;

  localparam int unsigned NrCores = ${cfg['cluster']['nr_cores']};
  localparam int unsigned NrHives = ${cfg['cluster']['nr_hives']};

  localparam int unsigned TcdmSize = ${cfg['cluster']['tcdm']['size']};
  localparam int unsigned TcdmSizeNapotRounded = 1 << $clog2(TcdmSize);
  localparam int unsigned BootromSize = 4; // Fixed size of 4kB
  localparam int unsigned ClusterPeriphSize = ${cfg['cluster']['cluster_periph_size']};
  localparam int unsigned ZeroMemorySize = ${cfg['cluster']['zero_mem_size']};
  localparam int unsigned ExtMemorySize = ${cfg['cluster']['ext_mem_size']};

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
  localparam int unsigned AtomicIdWidth = ${cfg['cluster']['atomic_id_width']};

  localparam int unsigned ICacheLineWidth [NrHives] = '{${icache_cfg('cacheline')}};
  localparam int unsigned ICacheLineCount [NrHives] = '{${icache_cfg('depth')}};
  localparam int unsigned ICacheWays [NrHives] = '{${icache_cfg('ways')}};

  localparam int unsigned Hive [NrCores] = '{${core_cfg('hive')}};

  localparam int unsigned TcdmAddrWidth = $clog2(TcdmSize*1024);

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

  typedef logic [TcdmAddrWidth-1:0]     tcdm_addr_t;

  `TCDM_TYPEDEF_ALL(tcdm_dma, tcdm_addr_t, data_dma_t, strb_dma_t, logic)

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
