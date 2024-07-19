// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "axi/typedef.svh"
`include "axi/assign.svh"

module testharness import snitch_cluster_pkg::*; (
  input  logic        clk_i,
  input  logic        rst_ni
);
  import "DPI-C" function int unsigned get_bin_entry();
  import "DPI-C" function void clint_tick(
    output byte msip[]
  );

  narrow_in_req_t narrow_in_req;
  narrow_in_resp_t narrow_in_resp;
  narrow_out_req_t narrow_out_req;
  narrow_out_resp_t narrow_out_resp;
  wide_out_req_t wide_out_req;
  wide_out_resp_t wide_out_resp;
  wide_in_req_t wide_in_req;
  wide_in_resp_t wide_in_resp;
  logic [snitch_cluster_pkg::NrCores-1:0] msip, meip;

  snitch_cluster_wrapper i_snitch_cluster (
    .clk_i,
    .rst_ni,
    .debug_req_i ('0),
    .meip_i (meip),
    .mtip_i ('0),
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

  // Tie-off unused input ports.
  assign wide_in_req = '0;

  // Narrow port into simulation memory.
  tb_memory_axi #(
    .AxiAddrWidth (AddrWidth),
    .AxiDataWidth (NarrowDataWidth),
    .AxiIdWidth (NarrowIdWidthOut),
    .AxiUserWidth (NarrowUserWidth),
    .req_t (narrow_out_req_t),
    .rsp_t (narrow_out_resp_t)
  ) i_mem (
    .clk_i,
    .rst_ni,
    .req_i (narrow_out_req),
    .rsp_o (narrow_out_resp)
  );

  // Wide port into simulation memory.
  tb_memory_axi #(
    .AxiAddrWidth (AddrWidth),
    .AxiDataWidth (WideDataWidth),
    .AxiIdWidth (WideIdWidthOut),
    .AxiUserWidth (WideUserWidth),
    .req_t (wide_out_req_t),
    .rsp_t (wide_out_resp_t)
  ) i_dma (
    .clk_i,
    .rst_ni,
    .req_i (wide_out_req),
    .rsp_o (wide_out_resp)
  );

  task narrow_write(
    input logic [AddrWidth-1:0] addr,
    input logic [NarrowDataWidth-1:0] data,
    output axi_pkg::resp_t resp
  );
    narrow_in_req.aw.addr = addr;
    narrow_in_req.aw.size = $clog2(NarrowDataWidth/8);
    narrow_in_req.aw.burst = axi_pkg::BURST_INCR;
    narrow_in_req.aw_valid = 1'b1;
    do @(posedge clk_i); while (!narrow_in_resp.aw_ready);
    narrow_in_req.aw_valid = 1'b0;
    narrow_in_req.w.data = data;
    narrow_in_req.w.strb = '1;
    narrow_in_req.w_valid = 1'b1;
    do @(posedge clk_i); while (!narrow_in_resp.w_ready);
    narrow_in_req.w_valid = 1'b0;
    narrow_in_req.b_ready = 1'b1;
    do @(posedge clk_i); while (!narrow_in_resp.b_valid);
    resp = narrow_in_resp.b.resp;
    narrow_in_req.b_ready = 1'b0;
  endtask

  localparam int unsigned PeriphBaseAddr = snitch_cluster_pkg::CfgClusterBaseAddr +
    (snitch_cluster_pkg::TcdmSize * 1024);
  localparam int unsigned Scratch1Addr = PeriphBaseAddr +
    snitch_cluster_peripheral_reg_pkg::SNITCH_CLUSTER_PERIPHERAL_SCRATCH_1_OFFSET;

  initial begin
    axi_pkg::resp_t resp;
    meip = '0;
    narrow_in_req = '0;
    narrow_in_req.aw.burst = axi_pkg::BURST_INCR;
    narrow_in_req.ar.burst = axi_pkg::BURST_INCR;
    narrow_in_req.aw.cache = axi_pkg::CACHE_MODIFIABLE;
    narrow_in_req.ar.cache = axi_pkg::CACHE_MODIFIABLE;
    @(negedge rst_ni);
    // Wait for some time
    #300ns;
    // Write to the scratch1 register
    @(posedge clk_i);
    narrow_write(Scratch1Addr, get_bin_entry(), resp);
    assert(resp == axi_pkg::RESP_OKAY);
    $display("[NarrowAxi] Writing entry point %x to scratch1", get_bin_entry());
    // Assert the external interrupt for a single cycle
    // to start the cores
    meip = '1;
    @(posedge clk_i);
    meip = '0;
  end

  // CLINT
  // verilog_lint: waive-start always-ff-non-blocking
  localparam int NumCores = snitch_cluster_pkg::NrCores;
  always_ff @(posedge clk_i) begin
    automatic byte msip_ret[NumCores];
    if (rst_ni) begin
      clint_tick(msip_ret);
      for (int i = 0; i < NumCores; i++) begin
        msip[i] = msip_ret[i];
      end
    end
  end
  // verilog_lint: waive-stop always-ff-non-blocking

endmodule
