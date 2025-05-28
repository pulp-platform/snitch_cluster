// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
// Florian Zaruba <zarubaf@iis.ee.ethz.ch>

module tb_memory_axi #(
  /// AXI4+ATOP address width.
  parameter int unsigned AxiAddrWidth  = 0,
  /// AXI4+ATOP data width.
  parameter int unsigned AxiDataWidth  = 0,
  /// AXI4+ATOP ID width.
  parameter int unsigned AxiIdWidth  = 0,
  /// AXI4+ATOP User width.
  parameter int unsigned AxiUserWidth  = 0,
  /// Atomic memory support.
  parameter bit unsigned ATOPSupport = 1,
  parameter type req_t = logic,
  parameter type rsp_t = logic
)(
  input  logic clk_i,
  input  logic rst_ni,
  input  req_t req_i,
  output rsp_t rsp_o
);

  `include "axi/assign.svh"
  `include "axi/typedef.svh"

  `include "common_cells/assertions.svh"
  `include "common_cells/registers.svh"

  localparam int NumBytes = AxiDataWidth/8;
  localparam int BusAlign = $clog2(NumBytes);

  AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth ),
    .AXI_DATA_WIDTH ( AxiDataWidth ),
    .AXI_ID_WIDTH   ( AxiIdWidth   ),
    .AXI_USER_WIDTH ( AxiUserWidth )
  ) axi(),
    axi_wo_atomics(),
    axi_wo_atomics_cut();

  `AXI_ASSIGN_FROM_REQ(axi, req_i)
  `AXI_ASSIGN_TO_RESP(rsp_o, axi)

  // Filter atomic operations.
  if (ATOPSupport) begin : gen_atop_support
    axi_riscv_atomics_wrap #(
      .AXI_ADDR_WIDTH (AxiAddrWidth),
      .AXI_DATA_WIDTH (AxiDataWidth),
      .AXI_ID_WIDTH (AxiIdWidth),
      .AXI_USER_WIDTH (AxiUserWidth),
      .AXI_MAX_READ_TXNS (2),
      .AXI_MAX_WRITE_TXNS (2),
      .RISCV_WORD_WIDTH (32)
    ) i_axi_riscv_atomics_wrap (
      .clk_i (clk_i),
      .rst_ni (rst_ni),
      .slv (axi),
      .mst (axi_wo_atomics)
    );
  end else begin : gen_no_atop_support
    `AXI_ASSIGN(axi_wo_atomics, axi)
    `ASSERT(NoAtomicOperation, axi.aw_valid & axi.aw_ready |-> (axi.aw_atop == axi_pkg::ATOP_NONE))
  end

  // Ensure the AXI interface has not feedthrough signals.
  axi_cut_intf #(
    .BYPASS     (1'b0),
    .ADDR_WIDTH (AxiAddrWidth),
    .DATA_WIDTH (AxiDataWidth),
    .ID_WIDTH   (AxiIdWidth),
    .USER_WIDTH (AxiUserWidth)
  ) i_cut (
    .clk_i (clk_i),
    .rst_ni (rst_ni),
    .in (axi_wo_atomics),
    .out (axi_wo_atomics_cut)
  );

  logic mem_req, mem_req_q;
  logic [AxiAddrWidth-1:0] mem_addr;
  logic [AxiDataWidth-1:0] mem_wdata;
  logic [AxiDataWidth/8-1:0] mem_strb;
  logic mem_we;
  logic [AxiDataWidth-1:0] mem_rdata_q;

  axi_to_mem_intf #(
    .ADDR_WIDTH    (AxiAddrWidth),
    .DATA_WIDTH    (AxiDataWidth),
    .ID_WIDTH      (AxiIdWidth),
    .USER_WIDTH    (AxiUserWidth),
    .NUM_BANKS     (1)
  ) i_axi_to_mem_intf (
    .clk_i       (clk_i),
    .rst_ni      (rst_ni),
    .busy_o      ( ),
    .slv         (axi_wo_atomics_cut),
    .mem_req_o   (mem_req),
    .mem_gnt_i   (1'b1), // Always ready
    .mem_addr_o  (mem_addr),
    .mem_wdata_o (mem_wdata),
    .mem_strb_o  (mem_strb),
    .mem_atop_o  ( ), // ATOPs are resolved before
    .mem_we_o    (mem_we),
    .mem_rvalid_i(mem_req_q),
    .mem_rdata_i (mem_rdata_q)
  );

  import "DPI-C" function void tb_memory_read(
    input longint addr,
    input int len,
    output byte data[]
  );
  import "DPI-C" function void tb_memory_write(
    input longint addr,
    input int len,
    input byte data[],
    input bit strb[]
  );

  // Respond in the next cycle to the request.
  `FF(mem_req_q, mem_req, '0)

  // Handle write requests on the mem bus.
  always_ff @(posedge clk_i) begin
    if (rst_ni && mem_req) begin
      automatic byte data[NumBytes];
      automatic bit  strb[NumBytes];
      if (mem_we) begin
        for (int i = 0; i < NumBytes; i++) begin
          // verilog_lint: waive-start always-ff-non-blocking
          data[i] = mem_wdata[i*8+:8];
          strb[i] = mem_strb[i];
          // verilog_lint: waive-start always-ff-non-blocking
        end
        tb_memory_write((mem_addr >> BusAlign) << BusAlign, NumBytes, data, strb);
      end
    end
  end

  // Handle read requests on the mem bus.
  always_ff @(posedge clk_i) begin
    mem_rdata_q <= '0;
    if (rst_ni && mem_req) begin
      automatic byte data[NumBytes];
      tb_memory_read((mem_addr >> BusAlign) << BusAlign, NumBytes, data);
      for (int i = 0; i < NumBytes; i++) begin
        mem_rdata_q[i*8+:8] <= data[i];
      end
    end
  end

endmodule
