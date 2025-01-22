// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "axi/typedef.svh"
`include "axi/assign.svh"

module testharness;

  import snitch_cluster_pkg::*;

  logic clk;
  logic rst_n;

  narrow_in_req_t narrow_in_req;
  narrow_in_resp_t narrow_in_resp;
  narrow_out_req_t narrow_out_req;
  narrow_out_resp_t narrow_out_resp;
  wide_out_req_t wide_out_req;
  wide_out_resp_t wide_out_resp;
  wide_in_req_t wide_in_req;
  wide_in_resp_t wide_in_resp;
  logic [snitch_cluster_pkg::NrCores-1:0] msip, meip, mtip;

  snitch_cluster_wrapper i_snitch_cluster (
    .clk_i (clk),
    .rst_ni (rst_n),
    .debug_req_i ('0),
    .meip_i (meip),
    .mtip_i (mtip),
    .msip_i (msip),
    .hart_base_id_i (CfgBaseHartId),
    .cluster_base_addr_i (CfgClusterBaseAddr),
    .clk_d2_bypass_i (1'b0),
    .sram_cfgs_i (snitch_cluster_pkg::sram_cfgs_t'('0)),
    .narrow_in_req_i (narrow_in_req),
    .narrow_in_resp_o (narrow_in_resp),
    .narrow_out_req_o (narrow_out_req),
    .narrow_out_resp_i (narrow_out_resp),
    .wide_out_req_o (wide_out_req),
    .wide_out_resp_i (wide_out_resp),
    .wide_in_req_i (wide_in_req),
    .wide_in_resp_o (wide_in_resp)
  );

  ///////////
  //  VIP  //
  ///////////

  vip_snitch_cluster vip (.*);

  initial begin
    // Wait for the reset
    vip.wait_for_reset();
    // Wait for a few cycles
    vip.wait_for_cycles(1000);
    // Write entrypoint to the scratch register
    vip.write_entry_point();
    // Set Cluster Clint interrupt
    vip.set_cl_clint_interrupt();
  end

endmodule
