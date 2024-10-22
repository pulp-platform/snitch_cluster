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

<%def name="snax_custom_tcdm_idx(prop)">\
  % for idx in range(len(cfg['snax_custom_tcdm_assign'][prop])):
${cfg['snax_custom_tcdm_assign'][prop][idx]}${', ' if not loop.last else ''}\
  % endfor
</%def>\

<%def name="acc_cfg(prop)">\
  % for idx in range(len(prop)):
${prop[idx]}${', ' if not loop.last else ''}\
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

// These includes are necessary for pre-defined typedefs
`include "axi/typedef.svh"
`include "tcdm_interface/typedef.svh"

// Main cluster package
// verilog_lint: waive-start package-filename
package ${cfg['name']}_pkg;

  // Addressing Parameters
  localparam logic [ 9:0] HartBaseID = ${to_sv_hex(cfg['cluster_base_hartid'], 10)};
  localparam logic [${cfg['addr_width']-1}:0] ClusterBaseAddr = ${to_sv_hex(cfg['cluster_base_addr'], cfg['addr_width'])};
  localparam logic [31:0] BootAddr = ${to_sv_hex(cfg['boot_addr'], 32)};

  // Base and pre-calculated parameters
  localparam int unsigned NrCores = ${cfg['nr_cores']};
  localparam int unsigned NrHives = ${cfg['nr_hives']};

  localparam int unsigned AddrWidth = ${cfg['addr_width']};
  localparam int unsigned NarrowDataWidth = ${cfg['data_width']};
  localparam int unsigned WideDataWidth = ${cfg['dma_data_width']};

  localparam int unsigned NarrowIdWidthIn = ${cfg['id_width_in']};
  localparam int unsigned NrMasters = 3;
  localparam int unsigned NarrowIdWidthOut = $clog2(NrMasters) + NarrowIdWidthIn;

  localparam int unsigned NrDmaMasters = 2 + ${cfg['nr_hives']};
  localparam int unsigned WideIdWidthIn = ${cfg['dma_id_width_in']};
  localparam int unsigned WideIdWidthOut = $clog2(NrDmaMasters) + WideIdWidthIn;

  localparam int unsigned CoreIDWidth = cf_math_pkg::idx_width(NrCores);

  localparam int unsigned TCDMDepth = ${cfg['tcdm']['depth']};
  localparam int unsigned NrBanks = ${cfg['tcdm']['banks']};

  localparam int unsigned NarrowUserWidth = ${cfg['user_width']};
  localparam int unsigned WideUserWidth = ${cfg['dma_user_width']};

  localparam int unsigned ICacheLineWidth [NrHives] = '{${icache_cfg('cacheline')}};
  localparam int unsigned ICacheLineCount [NrHives] = '{${icache_cfg('depth')}};
  localparam int unsigned ICacheSets [NrHives] = '{${icache_cfg('sets')}};

  localparam int unsigned Hive [NrCores] = '{${core_cfg('hive')}};
% if cfg['observable_pin_width'] > 0:
  parameter int unsigned ObsWidth = ${cfg['observable_pin_width']};
% endif

  // SRAM configurations
  typedef struct packed {
% for field, width in cfg['sram_cfg_fields'].items():
    logic [${width-1}:0] ${field};
% endfor
  } sram_cfg_t;

  typedef struct packed {
    sram_cfg_t icache_tag;
    sram_cfg_t icache_data;
    sram_cfg_t tcdm;
  } sram_cfgs_t;

  // Re-defined typedefs used for other typedefs
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

  // Typedefs for the AXI connections
  `AXI_TYPEDEF_ALL(narrow_in, addr_t, narrow_in_id_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_ALL(narrow_out, addr_t, narrow_out_id_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_ALL(wide_in, addr_t, wide_in_id_t, data_dma_t, strb_dma_t, user_dma_t)
  `AXI_TYPEDEF_ALL(wide_out, addr_t, wide_out_id_t, data_dma_t, strb_dma_t, user_dma_t)

  localparam int unsigned TCDMMemAddrWidth = $clog2(TCDMDepth);
  localparam int unsigned TCDMSize = NrBanks * TCDMDepth * (NarrowDataWidth/8);
  localparam int unsigned TCDMAddrWidth = $clog2(TCDMSize);
  typedef logic [TCDMAddrWidth-1:0] tcdm_addr_t;

  // TCDM definitions
  typedef struct packed {
    logic [CoreIDWidth-1:0] core_id;
    bit                     is_core;
  } tcdm_user_t;

  `TCDM_TYPEDEF_ALL(tcdm, tcdm_addr_t, data_t, strb_t, tcdm_user_t)

  // Accelerator definitions for SNAX and other Snitch L0 accelerators
  // (e.g., of L0 accelerators - DMA, FPSS, and so on)
  typedef struct packed {
    snitch_pkg::acc_addr_e   addr;
    logic [4:0]  id;
    logic [31:0] data_op;
    data_t       data_arga;
    data_t       data_argb;
    addr_t       data_argc;
  } acc_req_t;

  typedef struct packed {
    logic [4:0] id;
    logic       error;
    data_t      data;
  } acc_resp_t;

  // Function pre-calculations
  function automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] get_cached_regions();
    automatic snitch_pma_pkg::rule_t [snitch_pma_pkg::NrMaxRules-1:0] cached_regions;
    cached_regions = '{default: '0};
% for i, cp in enumerate(cfg['pmas']['cached']):
    cached_regions[${i}] = '{base: ${to_sv_hex(cp[0], cfg['addr_width'])}, mask: ${to_sv_hex(cp[1], cfg['addr_width'])}};
% endfor
    return cached_regions;
  endfunction

  localparam snitch_pma_pkg::snitch_pma_t SnitchPMACfg = '{
      NrCachedRegionRules: ${len(cfg['pmas']['cached'])},
      CachedRegion: get_cached_regions(),
      default: 0
  };

  // FPU configurations per FPU that has a core
  localparam fpnew_pkg::fpu_implementation_t FPUImplementation [${cfg['nr_cores']}] = '{
  % for c in cfg['cores']:
    '{
        PipeRegs: // FMA Block
                  '{
                    '{  ${cfg['timing']['lat_comp_fp32']}, // FP32
                        ${cfg['timing']['lat_comp_fp64']}, // FP64
                        ${cfg['timing']['lat_comp_fp16']}, // FP16
                        ${cfg['timing']['lat_comp_fp8']}, // FP8
                        ${cfg['timing']['lat_comp_fp16_alt']}, // FP16alt
                        ${cfg['timing']['lat_comp_fp8_alt']}  // FP8alt
                      },
                    '{1, 1, 1, 1, 1, 1},   // DIVSQRT
                    '{${cfg['timing']['lat_noncomp']},
                      ${cfg['timing']['lat_noncomp']},
                      ${cfg['timing']['lat_noncomp']},
                      ${cfg['timing']['lat_noncomp']},
                      ${cfg['timing']['lat_noncomp']},
                      ${cfg['timing']['lat_noncomp']}},   // NONCOMP
                    '{${cfg['timing']['lat_conv']},
                      ${cfg['timing']['lat_conv']},
                      ${cfg['timing']['lat_conv']},
                      ${cfg['timing']['lat_conv']},
                      ${cfg['timing']['lat_conv']},
                      ${cfg['timing']['lat_conv']}},   // CONV
                    '{${cfg['timing']['lat_sdotp']},
                      ${cfg['timing']['lat_sdotp']},
                      ${cfg['timing']['lat_sdotp']},
                      ${cfg['timing']['lat_sdotp']},
                      ${cfg['timing']['lat_sdotp']},
                      ${cfg['timing']['lat_sdotp']}}    // DOTP
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
        PipeConfig: fpnew_pkg::${cfg['timing']['fpu_pipe_config']}
    }${',\n' if not loop.last else '\n'}\
  % endfor
  };

% if cfg['num_ssrs_max'] > 0:
  localparam snitch_ssr_pkg::ssr_cfg_t [${cfg['num_ssrs_max']}-1:0] SsrCfgs [${cfg['nr_cores']}] = '{
${ssr_cfg(core, "'{{{indirection:d}, {isect_master:d}, {isect_master_idx:d}, {isect_slave:d}, "\
  "{isect_slave_spill:d}, {indir_out_spill:d}, {num_loops}, {index_width}, {pointer_width}, "\
  "{shift_width}, {rpt_width}, {index_credits}, {isect_slave_credits}, {data_credits}, "\
  "{mux_resp_depth}}}", "/*None*/ '0", ',\n     ')}\
  };

  localparam logic [${cfg['num_ssrs_max']}-1:0][4:0] SsrRegs [${cfg['nr_cores']}] = '{
${ssr_cfg(core, '{reg_idx}', '/*None*/ 0', ',')}\
  };
% endif

endpackage
// verilog_lint: waive-stop package-filename

// Main snitch or SNAX cluster wrapper
module ${cfg['name']}_wrapper (
  //-----------------------------
  // Clock and reset
  //-----------------------------
  input  logic                                   clk_i,
  input  logic                                   rst_ni,
% if cfg['observable_pin_width'] > 0:
  //-----------------------------
  // Observable pins
  //-----------------------------
  output logic [${cfg['pkg_name']}::ObsWidth-1:0] obs_o,
% endif
  //-----------------------------
  // Interrupt ports
  //-----------------------------
% if cfg['enable_debug']:
  input  logic [${cfg['pkg_name']}::NrCores-1:0] debug_req_i,
% endif
  input  logic [${cfg['pkg_name']}::NrCores-1:0] meip_i,
  input  logic [${cfg['pkg_name']}::NrCores-1:0] mtip_i,
  input  logic [${cfg['pkg_name']}::NrCores-1:0] msip_i,
  //-----------------------------
  // Cluster base addressing
  //-----------------------------
  input  logic [9:0]                             hart_base_id_i,
  input  logic [${cfg['addr_width']-1}:0]        cluster_base_addr_i,
  input  logic [31:0]                            boot_addr_i,
% if cfg['timing']['iso_crossings']:
  //-----------------------------
  // ISO crossings
  //-----------------------------
  input  logic                                   clk_d2_bypass_i,
% endif
% if cfg['sram_cfg_expose']:
  //-----------------------------
  // SRAM configurations
  //-----------------------------
  input  ${cfg['pkg_name']}::sram_cfgs_t         sram_cfgs_i,
%endif
  //-----------------------------
  // Narrow AXI ports
  //-----------------------------
  input  ${cfg['pkg_name']}::narrow_in_req_t     narrow_in_req_i,
  output ${cfg['pkg_name']}::narrow_in_resp_t    narrow_in_resp_o,
  output ${cfg['pkg_name']}::narrow_out_req_t    narrow_out_req_o,
  input  ${cfg['pkg_name']}::narrow_out_resp_t   narrow_out_resp_i,
  //-----------------------------
  //Wide AXI ports
  //-----------------------------
  output ${cfg['pkg_name']}::wide_out_req_t      wide_out_req_o,
  input  ${cfg['pkg_name']}::wide_out_resp_t     wide_out_resp_i,
  input  ${cfg['pkg_name']}::wide_in_req_t       wide_in_req_i,
  output ${cfg['pkg_name']}::wide_in_resp_t      wide_in_resp_o
);

<%
# Just some working variables
tcdm_offset_start = 0
tcdm_offset_stop = -1
total_snax_tcdm_ports = 0
snax_core_acc = {}
total_snax_narrow_ports = 0
total_snax_wide_ports = 0
snax_narrow_tcdm_ports_list = []
snax_wide_tcdm_ports_list = []

# Cycle through each core
# and check if an accelerator setting exists

for i in range(len(cfg['cores'])):

  # Make sure to initialize a dictionary
  # that describes accelerators each core
  curr_snax_acc_core = 'snax_core_' + str(i)
  snax_acc_dict = {}
  snax_acc_flag = False
  snax_xdma_flag = False
  snax_acc_multi_flag = False
  snax_use_custom_ports = False
  snax_num_acc = None
  snax_total_num_csr = None
  prefix_snax_nonacc_count = 0
  prefix_snax_count = 0
  snax_tcdm_ports = 0

  # If an accelerator setting exists
  # Layout all possible accelerator configurations
  # Per snitch cluster core
  if ('snax_acc_cfg' in cfg['cores'][i]):
    snax_acc_flag = True

    # Note that the order is from last core to the first core
    snax_narrow_tcdm_ports_list.append(cfg['cores'][i]['snax_acc_cfg']['snax_narrow_tcdm_ports'])
    snax_wide_tcdm_ports_list.append(cfg['cores'][i]['snax_acc_cfg']['snax_wide_tcdm_ports'])

    if(cfg['cores'][i]['snax_acc_cfg']['snax_num_acc'] > 1):
      snax_acc_multi_flag = True
      snax_num_rw_csr = cfg['cores'][i]['snax_acc_cfg'].get('snax_num_rw_csr', 0)
      snax_num_ro_csr = cfg['cores'][i]['snax_acc_cfg'].get('snax_num_ro_csr', 0)
      snax_total_num_csr = snax_num_rw_csr + snax_num_ro_csr
      snax_num_acc = cfg['cores'][i]['snax_acc_cfg']['snax_num_acc']

    snax_use_custom_ports = cfg['cores'][i]['snax_use_custom_ports']

    for j in range(cfg['cores'][i]['snax_acc_cfg']['snax_num_acc']):

      # Prepare accelerator tags
      curr_snax_acc = ''
      curr_snax_acc = "i_snax_core_" + str(i) + "_acc_" + str(prefix_snax_count) + "_" + cfg['cores'][i]['snax_acc_cfg']['snax_acc_name']

      # Set tcdm offset ports
      snax_narrow_tcdm_ports = cfg['cores'][i]['snax_acc_cfg']['snax_narrow_tcdm_ports']
      snax_wide_tcdm_ports = cfg['cores'][i]['snax_acc_cfg']['snax_wide_tcdm_ports']
      snax_tcdm_ports = snax_narrow_tcdm_ports + snax_wide_tcdm_ports
      tcdm_offset_stop += snax_tcdm_ports

      # Save settings in the dictionary
      snax_acc_dict[curr_snax_acc] = {
            'snax_acc_name': cfg['cores'][i]['snax_acc_cfg']['snax_acc_name'],
            'snax_tcdm_ports': snax_tcdm_ports,
            'snax_tcdm_offset_start': tcdm_offset_start,
            'snax_tcdm_offset_stop': tcdm_offset_stop
          }
      tcdm_offset_start += snax_tcdm_ports
      prefix_snax_count += 1
      total_snax_narrow_ports += snax_narrow_tcdm_ports
      total_snax_wide_ports += snax_wide_tcdm_ports

  elif ('snax_xdma_cfg' in cfg['cores'][i]):
    snax_xdma_flag = True
    xdma_cfg = cfg['cores'][i]['snax_xdma_cfg']
    # Note that the order is from last core to the first core
    snax_narrow_tcdm_ports_list.append(round(cfg['dma_data_width'] / cfg['data_width']) << 1)
    snax_wide_tcdm_ports_list.append(0)

    # Prepare accelerator tags
    xdma_instance_name = "xdma"
    for key, value in xdma_cfg.items():
      if key.startswith('has_'):
        xdma_instance_name += ("_" + key[4:])
    curr_snax_acc = ''
    curr_snax_acc = "i_snax_core_" + str(i) + "_" + xdma_instance_name

    # Set tcdm offset ports
    snax_narrow_tcdm_ports = round(cfg['dma_data_width'] / cfg['data_width']) * 2
    snax_wide_tcdm_ports = 0
    snax_tcdm_ports = snax_narrow_tcdm_ports + snax_wide_tcdm_ports
    tcdm_offset_stop += snax_tcdm_ports

    # Save settings in the dictionary
    snax_acc_dict[curr_snax_acc] = {
          'snax_acc_name': xdma_instance_name,
          'snax_tcdm_ports': snax_tcdm_ports,
          'snax_tcdm_offset_start': tcdm_offset_start,
          'snax_tcdm_offset_stop': tcdm_offset_stop
        }
    tcdm_offset_start += snax_tcdm_ports
    total_snax_narrow_ports += snax_narrow_tcdm_ports
    total_snax_wide_ports += snax_wide_tcdm_ports

  else:

    # Consider cases without accelerators
    # Just leave them as none
    curr_snax_acc = "i_snax_core_" + str(i) + "_noacc_" + str(prefix_snax_nonacc_count)
    snax_acc_dict[curr_snax_acc] = None

    # Note that the order is from last core to the first core
    snax_narrow_tcdm_ports_list.append(0)
    snax_wide_tcdm_ports_list.append(0)
    
  # This is the packed configuration
  snax_core_acc[curr_snax_acc_core] = {
    'snax_acc_flag': snax_acc_flag,
    'snax_xdma_flag': snax_xdma_flag,
    'snax_acc_multi_flag':snax_acc_multi_flag,
    'snax_use_custom_ports': snax_use_custom_ports,
    'snax_total_num_csr': snax_total_num_csr,
    'snax_num_acc': snax_num_acc,
    'snax_acc_dict':snax_acc_dict
  }

total_snax_tcdm_ports = total_snax_narrow_ports + total_snax_wide_ports
%>\
  // Internal local parameters to be hooked into the Snitch / SNAX cluster
  localparam int unsigned NumIntOutstandingLoads  [${cfg['nr_cores']}] = '{${core_cfg('num_int_outstanding_loads')}};
  localparam int unsigned NumIntOutstandingMem    [${cfg['nr_cores']}] = '{${core_cfg('num_int_outstanding_mem')}};
  localparam int unsigned NumFPOutstandingLoads   [${cfg['nr_cores']}] = '{${core_cfg('num_fp_outstanding_loads')}};
  localparam int unsigned NumFPOutstandingMem     [${cfg['nr_cores']}] = '{${core_cfg('num_fp_outstanding_mem')}};
  localparam int unsigned NumDTLBEntries          [${cfg['nr_cores']}] = '{${core_cfg('num_dtlb_entries')}};
  localparam int unsigned NumITLBEntries          [${cfg['nr_cores']}] = '{${core_cfg('num_itlb_entries')}};
  localparam int unsigned NumSequencerInstr       [${cfg['nr_cores']}] = '{${core_cfg('num_sequencer_instructions')}};
  localparam int unsigned NumSsrs                 [${cfg['nr_cores']}] = '{${core_cfg('num_ssrs')}};
  localparam int unsigned SsrMuxRespDepth         [${cfg['nr_cores']}] = '{${core_cfg('ssr_mux_resp_depth')}};
  localparam int unsigned SnaxNarrowTcdmPorts     [${cfg['nr_cores']}] = '{${acc_cfg(snax_narrow_tcdm_ports_list)}};
  localparam int unsigned SnaxWideTcdmPorts       [${cfg['nr_cores']}] = '{${acc_cfg(snax_wide_tcdm_ports_list)}};
% if 'snax_custom_tcdm_assign' in cfg:
% if cfg['snax_custom_tcdm_assign']['snax_enable_assign_tcdm_idx']:
  localparam int unsigned SnaxNarrowStartIdx      [${len(cfg['snax_custom_tcdm_assign']['snax_narrow_assign_start_idx'])}] = '{${snax_custom_tcdm_idx('snax_narrow_assign_start_idx')}};
  localparam int unsigned SnaxNarrowEndIdx        [${len(cfg['snax_custom_tcdm_assign']['snax_narrow_assign_end_idx'])}] = '{${snax_custom_tcdm_idx('snax_narrow_assign_end_idx')}};
  localparam int unsigned SnaxWideStartIdx        [${len(cfg['snax_custom_tcdm_assign']['snax_wide_assign_start_idx'])}] = '{${snax_custom_tcdm_idx('snax_wide_assign_start_idx')}};
  localparam int unsigned SnaxWideEndIdx          [${len(cfg['snax_custom_tcdm_assign']['snax_wide_assign_end_idx'])}] = '{${snax_custom_tcdm_idx('snax_wide_assign_end_idx')}};
% endif
% endif

  //-----------------------------
  // SNAX Custom Instruction Ports
  //-----------------------------
  // Request for custom instruction format
  ${cfg['pkg_name']}::acc_req_t [${cfg['pkg_name']}::NrCores-1:0] snax_req;
  logic [${cfg['pkg_name']}::NrCores-1:0] snax_qvalid;
  logic [${cfg['pkg_name']}::NrCores-1:0] snax_qready;
  // Response for custom instruction format
  ${cfg['pkg_name']}::acc_resp_t [${cfg['pkg_name']}::NrCores-1:0] snax_resp;
  logic [${cfg['pkg_name']}::NrCores-1:0] snax_pvalid;
  logic [${cfg['pkg_name']}::NrCores-1:0] snax_pready;

  //-----------------------------
  // SNAX CSR Ports
  //-----------------------------
  // Request for CSR format
  logic [${cfg['pkg_name']}::NrCores-1:0][31:0] snax_csr_req_data;
  logic [${cfg['pkg_name']}::NrCores-1:0][31:0] snax_csr_req_addr;
  logic [${cfg['pkg_name']}::NrCores-1:0]       snax_csr_req_write;
  logic [${cfg['pkg_name']}::NrCores-1:0]       snax_csr_req_valid;
  logic [${cfg['pkg_name']}::NrCores-1:0]       snax_csr_req_ready;
  ///Response for CSR format
  logic [${cfg['pkg_name']}::NrCores-1:0][31:0] snax_csr_rsp_data;
  logic [${cfg['pkg_name']}::NrCores-1:0]       snax_csr_rsp_valid;
  logic [${cfg['pkg_name']}::NrCores-1:0]       snax_csr_rsp_ready;
    
  //-----------------------------
  // SNAX TCDM wires
  //-----------------------------
  ${cfg['pkg_name']}::tcdm_req_t [${total_snax_tcdm_ports-1}:0] snax_tcdm_req;
  ${cfg['pkg_name']}::tcdm_rsp_t [${total_snax_tcdm_ports-1}:0] snax_tcdm_rsp;

  //-----------------------------
  // SNAX Barrier Wire
  //-----------------------------
  logic [${cfg['pkg_name']}::NrCores-1:0] snax_barrier;

  // Snitch cluster under test.
  snitch_cluster #(
    .PhysicalAddrWidth (${cfg['addr_width']}),
    .NarrowDataWidth (${cfg['data_width']}),
    .WideDataWidth (${cfg['dma_data_width']}),
    .NarrowIdWidthIn (${cfg['pkg_name']}::NarrowIdWidthIn),
    .WideIdWidthIn (${cfg['pkg_name']}::WideIdWidthIn),
    .NarrowUserWidth (${cfg['pkg_name']}::NarrowUserWidth),
    .WideUserWidth (${cfg['pkg_name']}::WideUserWidth),
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
    .TCDMDepth (${cfg['pkg_name']}::TCDMDepth),
    .ZeroMemorySize (${cfg['zero_mem_size']}),
    .ClusterPeriphSize (${cfg['cluster_periph_size']}),
    .NrBanks (${cfg['pkg_name']}::NrBanks),
    .DMAAxiReqFifoDepth (${cfg['dma_axi_req_fifo_depth']}),
    .DMAReqFifoDepth (${cfg['dma_req_fifo_depth']}),
    .ICacheLineWidth (${cfg['pkg_name']}::ICacheLineWidth),
    .ICacheLineCount (${cfg['pkg_name']}::ICacheLineCount),
    .ICacheSets (${cfg['pkg_name']}::ICacheSets),
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
    .SnaxNarrowTcdmPorts (SnaxNarrowTcdmPorts),
    .SnaxWideTcdmPorts (SnaxWideTcdmPorts),
    .TotalSnaxNarrowTcdmPorts(${total_snax_narrow_ports}),
    .TotalSnaxWideTcdmPorts(${total_snax_wide_ports}),
    .SnaxUseCustomPorts (${core_cfg_flat('snax_use_custom_ports')}),
% if 'snax_custom_tcdm_assign' in cfg:
  % if cfg['snax_custom_tcdm_assign']['snax_enable_assign_tcdm_idx']:
    .SnaxUseIdxTcdmAssign(1'b1),
    .SnaxNumNarrowAssignIdx(${len(cfg['snax_custom_tcdm_assign']['snax_narrow_assign_start_idx'])}),
    .SnaxNumWideAssignIdx(${len(cfg['snax_custom_tcdm_assign']['snax_wide_assign_start_idx'])}),
    .SnaxNarrowStartIdx(SnaxNarrowStartIdx),
    .SnaxNarrowEndIdx(SnaxNarrowEndIdx),
    .SnaxWideStartIdx(SnaxWideStartIdx),
    .SnaxWideEndIdx(SnaxWideEndIdx),
  % endif
% endif
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
% if cfg['num_ssrs_max'] > 0:
    .SsrRegs (${cfg['pkg_name']}::SsrRegs),
    .SsrCfgs (${cfg['pkg_name']}::SsrCfgs),
% endif
    .NumSequencerInstr (NumSequencerInstr),
    .Hive (${cfg['pkg_name']}::Hive),
    .Topology (snitch_pkg::LogarithmicInterconnect),
    .Radix (2),
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
% if cfg['observable_pin_width'] > 0:
    .ObsWidth (${cfg['pkg_name']}::ObsWidth),
% endif
    .DebugSupport (${int(cfg['enable_debug'])}),
    .acc_req_t (${cfg['pkg_name']}::acc_req_t),
    .acc_resp_t (${cfg['pkg_name']}::acc_resp_t),
    .tcdm_req_t (${cfg['pkg_name']}::tcdm_req_t),
    .tcdm_rsp_t (${cfg['pkg_name']}::tcdm_rsp_t)
  ) i_cluster (
    //-----------------------------
    // Clock and reset
    //-----------------------------
    .clk_i  ( clk_i  ),
    .rst_ni ( rst_ni ),
% if cfg['observable_pin_width'] > 0:
    //-----------------------------
    // Observable pins
    //-----------------------------
    .obs_o  ( obs_o  ),
% endif
    //-----------------------------
    // Interrupt ports
    //----------------------------
% if cfg['enable_debug']:
    .debug_req_i ( debug_req_i ),
% else:
    .debug_req_i ('0),
% endif
    .meip_i ( meip_i ),
    .mtip_i ( mtip_i ),
    .msip_i ( msip_i ),
    //-----------------------------
    // Cluster base and boot addressing
    //-----------------------------
    .hart_base_id_i ( hart_base_id_i ),
    .cluster_base_addr_i ( cluster_base_addr_i ),
    .boot_addr_i  (boot_addr_i),
    //-----------------------------
    // ISO crossings
    //-----------------------------
% if cfg['timing']['iso_crossings']:
    .clk_d2_bypass_i ( clk_d2_bypass_i ),
% else:
    .clk_d2_bypass_i ( 1'b0 ),
% endif
    //-----------------------------
    // SNAX Custom Instruction Ports
    //-----------------------------
    // Request custom instruction format ports
    .snax_req_o    ( snax_req    ),
    .snax_qvalid_o ( snax_qvalid ),
    .snax_qready_i ( snax_qready ),
    // Response custom instruction format ports
    .snax_resp_i   ( snax_resp   ),
    .snax_pvalid_i ( snax_pvalid ),
    .snax_pready_o ( snax_pready ),
    //-----------------------------
    // SNAX CSR Ports
    //-----------------------------
    // Request for CSR format ports
    .snax_csr_req_bits_data_o   ( snax_csr_req_data  ),
    .snax_csr_req_bits_addr_o   ( snax_csr_req_addr  ),
    .snax_csr_req_bits_write_o  ( snax_csr_req_write ),
    .snax_csr_req_valid_o       ( snax_csr_req_valid ),
    .snax_csr_req_ready_i       ( snax_csr_req_ready ),
    // Response for CSR format ports
    .snax_csr_rsp_bits_data_i   ( snax_csr_rsp_data  ),
    .snax_csr_rsp_valid_i       ( snax_csr_rsp_valid ),
    .snax_csr_rsp_ready_o       ( snax_csr_rsp_ready ),

    //-----------------------------
    // SNAX TCDM wires
    //-----------------------------
    .snax_tcdm_req_i ( snax_tcdm_req),
    .snax_tcdm_rsp_o ( snax_tcdm_rsp),
    //-----------------------------
    // SNAX Barrier Wire
    //-----------------------------
    .snax_barrier_i  (snax_barrier),
% if cfg['sram_cfg_expose']:
    .sram_cfgs_i (sram_cfgs_i),
% else:
    .sram_cfgs_i (${cfg['pkg_name']}::sram_cfgs_t'('0)),
%endif
    //-----------------------------
    // Narrow AXI ports
    //-----------------------------
    .narrow_in_req_i    ( narrow_in_req_i   ),
    .narrow_in_resp_o   ( narrow_in_resp_o  ),
    .narrow_out_req_o   ( narrow_out_req_o  ),
    .narrow_out_resp_i  ( narrow_out_resp_i ),
    //-----------------------------
    // Wide AXI ports
    //-----------------------------
    .wide_out_req_o     ( wide_out_req_o    ),
    .wide_out_resp_i    ( wide_out_resp_i   ),
    .wide_in_req_i      ( wide_in_req_i     ),
    .wide_in_resp_o     ( wide_in_resp_o    )
  );

% for idx, idx_key in enumerate(snax_core_acc):
  // ------------------------- Accelerator Set for Core ${idx} -------------------------
  // This is an accelerator set controlled by 1 Snitch core
  % if snax_core_acc[idx_key]['snax_acc_flag']:
    % if snax_core_acc[idx_key]['snax_acc_multi_flag']:

  // Wire declaration
  ${cfg['pkg_name']}::acc_req_t  [${snax_core_acc[idx_key]['snax_num_acc']-1}:0] snax_core_${idx}_split_req;
  logic      [${snax_core_acc[idx_key]['snax_num_acc']-1}:0] snax_core_${idx}_split_qvalid;
  logic      [${snax_core_acc[idx_key]['snax_num_acc']-1}:0] snax_core_${idx}_split_qready;
  ${cfg['pkg_name']}::acc_resp_t [${snax_core_acc[idx_key]['snax_num_acc']-1}:0] snax_core_${idx}_split_resp;
  logic      [${snax_core_acc[idx_key]['snax_num_acc']-1}:0] snax_core_${idx}_split_pvalid;
  logic      [${snax_core_acc[idx_key]['snax_num_acc']-1}:0] snax_core_${idx}_split_pready;
  logic      [${snax_core_acc[idx_key]['snax_num_acc']-1}:0] snax_core_${idx}_split_barrier;

  // This is a combined barrier for all barriers
  // Controlled by 1 Snitch core. It's an OR of all barriers.
  assign snax_barrier[${idx}] = |snax_core_${idx}_split_barrier;

  // MUX-DEMUX declaration
  // TODO: make a version for the csr ports next time...
  snax_acc_mux_demux #(
    .NumCsrs              (${snax_core_acc[idx_key]['snax_total_num_csr']}),
    .NumAcc               (${snax_core_acc[idx_key]['snax_num_acc']}),
    .acc_req_t            (${cfg['pkg_name']}::acc_req_t),
    .acc_rsp_t            (${cfg['pkg_name']}::acc_resp_t)
  ) i_snax_acc_mux_demux_core_${idx} (
    .clk_i                (clk_i),
    .rst_ni               (rst_ni),

    //------------------------
    // Main Snitch Port
    //------------------------
    .snax_req_i           (snax_req[${idx}]),
    .snax_qvalid_i        (snax_qvalid[${idx}]),
    .snax_qready_o        (snax_qready[${idx}]),

    .snax_resp_o          (snax_resp[${idx}]),
    .snax_pvalid_o        (snax_pvalid[${idx}]),
    .snax_pready_i        (snax_pready[${idx}]),

    //------------------------
    // Split Ports
    //------------------------
    .snax_split_req_o     (snax_core_${idx}_split_req),
    .snax_split_qvalid_o  (snax_core_${idx}_split_qvalid),
    .snax_split_qready_i  (snax_core_${idx}_split_qready),

    .snax_split_resp_i    (snax_core_${idx}_split_resp),
    .snax_split_pvalid_i  (snax_core_${idx}_split_pvalid),
    .snax_split_pready_o  (snax_core_${idx}_split_pready)
  );

  // Multiple accelerator instances
  // Controlled with 1 Snitch core
      % for jdx, jdx_key in enumerate(snax_core_acc[idx_key]['snax_acc_dict']):
  // Accelerator ${jdx} for core ${idx}
  ${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_acc_name']}_wrapper # (
    .DataWidth       ( ${cfg['pkg_name']}::NarrowDataWidth ),
    .SnaxTcdmPorts   ( ${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_ports']} ),
      %if snax_core_acc[idx_key]['snax_use_custom_ports']:
    .acc_req_t        ( ${cfg['pkg_name']}::acc_req_t ),
    .acc_rsp_t        ( ${cfg['pkg_name']}::acc_resp_t ),
      %endif
    .tcdm_req_t      ( ${cfg['pkg_name']}::tcdm_req_t ),
    .tcdm_rsp_t      ( ${cfg['pkg_name']}::tcdm_rsp_t )
  ) ${jdx_key}  (
    //-----------------------------
    // Clock and reset
    //-----------------------------
    .clk_i           ( clk_i ),
    .rst_ni          ( rst_ni ),
      %if snax_core_acc[idx_key]['snax_use_custom_ports']:
    //-----------------------------
    // Custom instruction format control ports
    //-----------------------------
    // Request
    .snax_req_i      ( snax_core_${idx}_split_req[${jdx}] ),
    .snax_qvalid_i   ( snax_core_${idx}_split_qvalid[${jdx}] ),
    .snax_qready_o   ( snax_core_${idx}_split_qready[${jdx}] ),
    // Response
    .snax_resp_o     ( snax_core_${idx}_split_resp[${jdx}] ),
    .snax_pvalid_o   ( snax_core_${idx}_split_pvalid[${jdx}] ),
    .snax_pready_i   ( snax_core_${idx}_split_pready[${jdx}] ),
      %else:
    //-----------------------------
    // CSR  format control ports
    //-----------------------------
    // Request
    .snax_req_data_i  ( snax_csr_req_data [${idx}] ),
    .snax_req_addr_i  ( snax_csr_req_addr [${idx}] ),
    .snax_req_write_i ( snax_csr_req_write[${idx}] ),
    .snax_req_valid_i ( snax_csr_req_valid[${idx}] ),
    .snax_req_ready_o ( snax_csr_req_ready[${idx}] ),
    // Response
    .snax_rsp_data_o  ( snax_csr_rsp_data [${idx}] ),
    .snax_rsp_valid_o ( snax_csr_rsp_valid[${idx}] ),
    .snax_rsp_ready_i ( snax_csr_rsp_ready[${idx}] ),
      %endif
    .snax_barrier_o  ( snax_core_${idx}_split_barrier[${jdx}] ),
    .snax_tcdm_req_o ( snax_tcdm_req[${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_stop']}:${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_start']}] ),
    .snax_tcdm_rsp_i ( snax_tcdm_rsp[${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_stop']}:${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_start']}] )
  );
      %if snax_core_acc[idx_key]['snax_use_custom_ports']:

  assign snax_csr_req_ready [${idx}] = '0;
  assign snax_csr_rsp_data  [${idx}] = '0;
  assign snax_csr_rsp_valid [${idx}] = '0;

      %else:
        // TODO: Not yet supported for multiple CSR ports
      %endif
      %endfor
    % else:
      % for jdx, jdx_key in enumerate(snax_core_acc[idx_key]['snax_acc_dict']):

  // Accelerators controlled with custom instruction format ports
  ${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_acc_name']}_wrapper # (
    .DataWidth        ( ${cfg['pkg_name']}::NarrowDataWidth ),
    .SnaxTcdmPorts    ( ${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_ports']} ),
        %if snax_core_acc[idx_key]['snax_use_custom_ports']:
    .acc_req_t        ( ${cfg['pkg_name']}::acc_req_t ),
    .acc_rsp_t        ( ${cfg['pkg_name']}::acc_resp_t ),
        %endif
    .tcdm_req_t       ( ${cfg['pkg_name']}::tcdm_req_t ),
    .tcdm_rsp_t       ( ${cfg['pkg_name']}::tcdm_rsp_t )
  ) ${jdx_key}  (
    //-----------------------------
    // Clock and reset
    //-----------------------------
    .clk_i            ( clk_i  ),
    .rst_ni           ( rst_ni ),
        %if snax_core_acc[idx_key]['snax_use_custom_ports']:
    //-----------------------------
    // Custom instruction format control ports
    //-----------------------------
    // Request
    .snax_req_i       ( snax_req   [${idx}] ),
    .snax_qvalid_i    ( snax_qvalid[${idx}] ),
    .snax_qready_o    ( snax_qready[${idx}] ),
    // Response
    .snax_resp_o      ( snax_resp  [${idx}] ),
    .snax_pvalid_o    ( snax_pvalid[${idx}] ),
    .snax_pready_i    ( snax_pready[${idx}] ),
        % else:
    //-----------------------------
    // CSR  format control ports
    //-----------------------------
    // Request
    .snax_req_data_i  ( snax_csr_req_data [${idx}] ),
    .snax_req_addr_i  ( snax_csr_req_addr [${idx}] ),
    .snax_req_write_i ( snax_csr_req_write[${idx}] ),
    .snax_req_valid_i ( snax_csr_req_valid[${idx}] ),
    .snax_req_ready_o ( snax_csr_req_ready[${idx}] ),
    // Response
    .snax_rsp_data_o  ( snax_csr_rsp_data [${idx}] ),
    .snax_rsp_valid_o ( snax_csr_rsp_valid[${idx}] ),
    .snax_rsp_ready_i ( snax_csr_rsp_ready[${idx}] ),
        %endif
    //-----------------------------
    // Hardware barrier
    //-----------------------------
    .snax_barrier_o   ( snax_barrier[${idx}] ),
    //-----------------------------
    // TCDM ports
    //-----------------------------
    .snax_tcdm_req_o  ( snax_tcdm_req[${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_stop']}:${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_start']}] ),
    .snax_tcdm_rsp_i  ( snax_tcdm_rsp[${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_stop']}:${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_start']}] )
  );

        %if snax_core_acc[idx_key]['snax_use_custom_ports']:
  // Tie unused CSR ports to 0
  assign snax_csr_rsp_valid [${idx}] = '0;
  assign snax_csr_rsp_data  [${idx}] = '0;
  assign snax_csr_req_ready [${idx}] = '0;
        %else:
  // Tie unused custom instruction ports to 0
  assign snax_qready  [${idx}] = '0;
  assign snax_resp    [${idx}] = '0;
  assign snax_pvalid  [${idx}] = '0;
        %endif

      % endfor
    % endif
  
  % elif snax_core_acc[idx_key]['snax_xdma_flag']:
    % for jdx, jdx_key in enumerate(snax_core_acc[idx_key]['snax_acc_dict']):
  // Instantiation of xdma wrapper
  ${cfg['name']}_xdma_wrapper # (
    .tcdm_req_t       ( ${cfg['pkg_name']}::tcdm_req_t ),
    .tcdm_rsp_t       ( ${cfg['pkg_name']}::tcdm_rsp_t )
  ) ${jdx_key}  (
    //-----------------------------
    // Clock and reset
    //-----------------------------
    .clk_i            ( clk_i  ),
    .rst_ni           ( rst_ni ),
    //-----------------------------
    // Cluster Base Address
    //-----------------------------
    .cluster_base_addr_i( cluster_base_addr_i ),
    //-----------------------------
    // CSR  format control ports
    //-----------------------------
    // Request
    .csr_req_bits_data_i  ( snax_csr_req_data [${idx}] ),
    .csr_req_bits_addr_i  ( snax_csr_req_addr [${idx}] ),
    .csr_req_bits_write_i ( snax_csr_req_write[${idx}] ),
    .csr_req_valid_i ( snax_csr_req_valid[${idx}] ),
    .csr_req_ready_o ( snax_csr_req_ready[${idx}] ),
    // Response
    .csr_rsp_bits_data_o  ( snax_csr_rsp_data [${idx}] ),
    .csr_rsp_valid_o ( snax_csr_rsp_valid[${idx}] ),
    .csr_rsp_ready_i ( snax_csr_rsp_ready[${idx}] ),
    //-----------------------------
    // Hardware barrier is not supported by xdma at the moment
    //-----------------------------
    //-----------------------------
    // TCDM ports
    //-----------------------------
    .tcdm_req_o  ( snax_tcdm_req[${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_stop']}:${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_start']}] ),
    .tcdm_rsp_i  ( snax_tcdm_rsp[${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_stop']}:${snax_core_acc[idx_key]['snax_acc_dict'][jdx_key]['snax_tcdm_offset_start']}] )
  );

  // Tie unused custom instruction ports to 0
  assign snax_qready  [${idx}] = '0;
  assign snax_resp    [${idx}] = '0;
  assign snax_pvalid  [${idx}] = '0;
  // Tie barrier to 0
  assign snax_barrier [${idx}] = '0;

    % endfor

  % else:
  
  // If no accelerator is connected to Snitch core
  // Tie SNAX custom ports to 0
  assign snax_qready  [${idx}] = '0;
  assign snax_resp    [${idx}] = '0;
  assign snax_pvalid  [${idx}] = '0;
  // Tie CSR ports to 0
  assign snax_csr_rsp_data [ ${idx}] = '0;
  assign snax_csr_rsp_valid [${idx}] = '0;
  assign snax_csr_req_ready [${idx}] = '0;
  // Tie barrier to 0
  assign snax_barrier [${idx}] = '0;

  % endif
% endfor

endmodule
