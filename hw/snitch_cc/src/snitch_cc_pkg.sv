// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

package snitch_cc_pkg;

  // LSU requests can go either to the TCDM or out of the cluster to the SoC.
  localparam int unsigned DreqPaths = 2;
  localparam int unsigned DreqSelectWidth = cc_pkg::idx_width(DreqPaths);
  typedef logic [DreqSelectWidth-1:0] dreq_select_t;
  typedef enum dreq_select_t {DreqSelectTcdm = 1, DreqSelectSoc = 0} dreq_select_e;

  // Coprocessor IDs
  typedef enum logic [1:0] {
    ExternalCopro = 0,
    SpatzCopro = 1,
    NumCopro = 2
  } copro_id_e;

  // DCA demux port IDs
  typedef enum logic [1:0] {
    DcaFpss = 0,
    DcaSpatz = 1,
    NumDcaDemuxPorts = 2
  } dca_demux_port_e;

  function automatic int unsigned num_spatz_mem_ports(
    int unsigned spatz_num_fu,
    bit spatz_double_bw
  );
    return spatz_double_bw ? spatz_num_fu * 2 : spatz_num_fu;
  endfunction

  function automatic int unsigned get_tcdm_ports(
    snitch_pkg::isa_cfg_t isa,
    int unsigned num_ssrs,
    int unsigned spatz_num_fu,
    bit spatz_double_bw
  );
    int unsigned ssr_ports, spatz_ports;
    ssr_ports = num_ssrs;
    spatz_ports = isa.RVV ? num_spatz_mem_ports(spatz_num_fu, spatz_double_bw) : 0;
    // SSR 0 shares port with LSU, take the maximum between one port
    // and the number of SSR ports.
    return cc_pkg::max(ssr_ports, 1) + spatz_ports;
  endfunction

  // Datapath width of the CC (depends if RVV or not)
  function automatic int unsigned datapath_width(
    input snitch_pkg::isa_cfg_t isa_cfg,
    input int unsigned narrow_data_width
  );
    return isa_cfg.RVV ? (spatz_pkg::N_FPU * spatz_pkg::ELEN) : narrow_data_width;
  endfunction

endpackage
