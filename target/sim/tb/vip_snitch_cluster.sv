// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "snitch_cluster_addrmap.svh"

module vip_snitch_cluster
  import snitch_cluster_pkg::*;
#(
  // Timing
  parameter realtime ClkPeriod = 10ns
) (
  output logic clk,
  output logic rst_n,
  // Interrupt lines
  output logic [NrCores-1:0] msip,
  output logic [NrCores-1:0] meip,
  output logic [NrCores-1:0] mtip,
  output logic [NrCores-1:0] mxip,
  // AXI interfaces
  output narrow_in_req_t narrow_in_req,
  input  narrow_in_resp_t narrow_in_resp,
  input  narrow_out_req_t narrow_out_req,
  output narrow_out_resp_t narrow_out_resp,
  output wide_in_req_t wide_in_req,
  input  wide_in_resp_t wide_in_resp,
  input  wide_out_req_t wide_out_req,
  output wide_out_resp_t wide_out_resp
);

  import snitch_cluster_peripheral_reg_pkg::*;

  import "DPI-C" function void clint_tick(output byte msip[]);
  import "DPI-C" function int unsigned get_bin_entry();

  localparam addr_t PeriphBaseAddr = CfgClusterBaseAddr + ((TcdmSizeNapotRounded + BootromSize) * 1024);
  localparam addr_t Scratch1Addr = PeriphBaseAddr + `SNITCH_CLUSTER_PERIPHERAL_REG_SCRATCH_1_REG_OFFSET;
  localparam addr_t SnitchClClintSetAddr = PeriphBaseAddr + `SNITCH_CLUSTER_PERIPHERAL_REG_CL_CLINT_SET_REG_OFFSET;

  ///////////////////////////
  //   Clock, Reset, etc.  //
  ///////////////////////////

  // Generate reset
  initial begin
    rst_n = 0;
    #ClkPeriod;
    rst_n = 1;
    #ClkPeriod;
    rst_n = 0;
    #ClkPeriod;
    rst_n = 1;
  end

  // Generate clock
  initial begin
    forever begin
      clk = 1;
      #(ClkPeriod/2);
      clk = 0;
      #(ClkPeriod/2);
    end
  end

  task wait_for_reset;
    @(posedge rst_n);
    @(posedge clk);
  endtask

  task wait_for_cycles(int unsigned cycles);
    repeat (cycles) @(posedge clk);
  endtask

  // Tie-off unused input ports.
  assign mtip = '0;
  assign meip = '0;
  assign mxip = '0;
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
    .clk_i (clk),
    .rst_ni (rst_n),
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
    .clk_i (clk),
    .rst_ni (rst_n),
    .req_i (wide_out_req),
    .rsp_o (wide_out_resp)
  );

  initial begin
    narrow_in_req = '0;
  end

  // Simple read/write tasks that are compatible with verilator.
  task automatic narrow_write(
    input logic [AddrWidth-1:0] addr,
    input logic [NarrowDataWidth-1:0] data,
    output axi_pkg::resp_t resp
  );
    narrow_in_req.aw.addr = addr;
    narrow_in_req.aw.size = axi_pkg::size_t'($clog2(NarrowDataWidth/8));
    narrow_in_req.aw_valid = 1'b1;
    do @(posedge clk); while (!narrow_in_resp.aw_ready);
    narrow_in_req.aw_valid = 1'b0;
    narrow_in_req.aw = '0;
    narrow_in_req.w.data = data;
    narrow_in_req.w.strb = '1;
    narrow_in_req.w.last = 1'b1;
    narrow_in_req.w_valid = 1'b1;
    do @(posedge clk); while (!narrow_in_resp.w_ready);
    narrow_in_req.w_valid = 1'b0;
    narrow_in_req.w = '0;
    narrow_in_req.b_ready = 1'b1;
    do @(posedge clk); while (!narrow_in_resp.b_valid);
    resp = narrow_in_resp.b.resp;
    narrow_in_req.b_ready = 1'b0;
  endtask

  task automatic narrow_read(
    input logic [AddrWidth-1:0] addr,
    output logic [NarrowDataWidth-1:0] data,
    output axi_pkg::resp_t resp
  );
    narrow_in_req.ar.addr = addr;
    narrow_in_req.ar.size = axi_pkg::size_t'($clog2(NarrowDataWidth/8));
    narrow_in_req.ar_valid = 1'b1;
    do @(posedge clk); while (!narrow_in_resp.ar_ready);
    narrow_in_req.ar_valid = 1'b0;
    narrow_in_req.ar = '0;
    narrow_in_req.r_ready = 1'b1;
    do @(posedge clk); while (!narrow_in_resp.r_valid);
    data = narrow_in_resp.r.data;
    resp = narrow_in_resp.r.resp;
    narrow_in_req.r_ready = 1'b0;
  endtask

  task automatic write_entry_point;
    axi_pkg::resp_t resp;
    $display("[NarrowAxi] Writing entry point %x to scratch1", get_bin_entry());
    narrow_write(Scratch1Addr, get_bin_entry(), resp);
    assert(resp == axi_pkg::RESP_OKAY);
  endtask

  task automatic set_cl_clint_interrupt;
    axi_pkg::resp_t resp;
    $display("[NarrowAxi] Setting Cluster Clint interrupt");
    narrow_write(SnitchClClintSetAddr, {NrCores{1'b1}}, resp);
    assert(resp == axi_pkg::RESP_OKAY);
  endtask

  // CLINT
  // verilog_lint: waive-start always-ff-non-blocking
  always_ff @(posedge clk) begin
    automatic byte msip_ret[NrCores];
    if (rst_n) begin
      clint_tick(msip_ret);
      for (int i = 0; i < NrCores; i++) begin
        msip[i] = msip_ret[i];
      end
    end
  end
  // verilog_lint: waive-stop always-ff-non-blocking

endmodule
