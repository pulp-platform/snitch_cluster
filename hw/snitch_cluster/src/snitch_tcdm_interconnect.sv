// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Maximilian Coco <mcoco@student.ethz.ch>
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "mem_interface/typedef.svh"
`include "tcdm_interface/typedef.svh"
`include "common_cells/registers.svh"
`include "common_cells/assertions.svh"

/*
Module: snitch_tcdm_interconnect
Fixed response latency interconnect with support for multiple hyperbanks.

Parameters:
  NumInp                - Number of inputs into the interconnect (`> 0`).
  NumOut                - Number of outputs from the interconnect (`> 0`).
  NumHyperBanks         - Number of hyperbanks.
  Radix                 - Radix of the individual switch points of the network.
  NumSwitchNets         - Number of parallel networks for switch-based interconnects.
  SwitchLfsrArbiter     - Whether to use an LFSR to arbitrate switch-based networks.
  DataWidth             - Size of the data payload on the interconnect.
  TcdmAddrWidth         - Address width on the request side.
  MemAddrWidth          - Address width on the memory side.
  MemoryResponseLatency - Latency of memory response (in cycles).
  Topology              - Interconnect topology.
  user_t                - Additional user payload to route.
  mem_req_t             - Type of the data request ports.
  mem_rsp_t             - Type of the data response ports.

Ports:
  clk_i     - Clock, positive edge triggered.
  rst_ni    - Reset, active low.
  req_i     - Request ports.
  rsp_o     - Response ports.
  mem_req_o - Memory-side request ports.
  mem_rsp_i - Memory-side response ports.
*/
module snitch_tcdm_interconnect #(
  parameter int unsigned NumInp                = 32'd0,
  parameter int unsigned NumOut                = 32'd0,
  parameter int unsigned NumHyperBanks         = 32'd1,
  parameter int unsigned Radix                 = 32'd2,
  parameter int unsigned NumSwitchNets         = 32'd2,
  parameter bit          SwitchLfsrArbiter     = 1'b0,
  parameter int unsigned DataWidth             = 32,
  parameter int unsigned TcdmAddrWidth         = 32,
  parameter int unsigned MemAddrWidth          = 32,
  parameter int unsigned MemoryResponseLatency = 1,
  parameter snitch_pkg::topo_e Topology        = snitch_pkg::LogarithmicInterconnect,
  parameter type         user_t                = logic,
  parameter type         mem_req_t             = logic,
  parameter type         mem_rsp_t             = logic,
  // Derived parameters
  localparam type        tcdm_req_t            = `TCDM_REQ_STRUCT(DataWidth, TcdmAddrWidth, user_t),
  localparam type        tcdm_rsp_t            = `TCDM_RSP_STRUCT(DataWidth)
) (
  input  logic                   clk_i,
  input  logic                   rst_ni,
  input  tcdm_req_t [NumInp-1:0] req_i,
  output tcdm_rsp_t [NumInp-1:0] rsp_o,
  output mem_req_t  [NumOut-1:0] mem_req_o,
  input  mem_rsp_t  [NumOut-1:0] mem_rsp_i
);

  localparam int unsigned BanksPerHyperBank = NumOut / NumHyperBanks;
  localparam int unsigned VirtualMemAddrWidth = MemAddrWidth + $clog2(NumHyperBanks);
  // TODO we can pass the parameters we need from the top level instead of redefining them here
  localparam int unsigned StrbWidth = DataWidth / 8;
  typedef logic [VirtualMemAddrWidth-1:0] virtual_mem_addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [StrbWidth-1:0] strb_t;

  // Define a new datatype to support larger addresses from TCDM interconnect
  // We basically pretend to the IC that our banks are combined as larger hyperbanks (Add memoryspace from two banks into one), such that we can demux the address later
  // Banks within the same hyperbank cannot be accessed simultaiousely
  `MEM_TYPEDEF_REQ_CHAN_T(mem_req_chan_t, virtual_mem_addr_t, data_t, strb_t, user_t);
  `MEM_TYPEDEF_REQ_T(virtual_mem_req_t, mem_req_chan_t);
  virtual_mem_req_t [BanksPerHyperBank-1:0] ic_mem_req;
  mem_rsp_t         [BanksPerHyperBank-1:0] ic_mem_rsp;

  // Instantiate one demux per bank in the hyperbank
  for (genvar i = 0; i < BanksPerHyperBank; i++) begin : gen_bank_connection
    if (NumHyperBanks > 1) begin : gen_hyperbank_demux

      logic select, sel_q, sel_d;

      `FF(sel_q, sel_d, '0, clk_i, rst_ni)

      // Demux select signal is determined by the MSB of the request address
      assign select = ic_mem_req[i].q.addr[VirtualMemAddrWidth-1];
      assign sel_d = ic_mem_req[i].q_valid && ic_mem_rsp[i].q_ready ? select : sel_q;

      // Request demux
      assign mem_req_o[i].q_valid = !select && ic_mem_req[i].q_valid;
      assign mem_req_o[i].q.addr  = ic_mem_req[i].q.addr[MemAddrWidth-1:0];
      assign mem_req_o[i].q.write = ic_mem_req[i].q.write;
      assign mem_req_o[i].q.data  = ic_mem_req[i].q.data;
      assign mem_req_o[i].q.strb  = ic_mem_req[i].q.strb;
      assign mem_req_o[i].q.user  = ic_mem_req[i].q.user;
      assign mem_req_o[i].q.amo   = ic_mem_req[i].q.amo;
      assign mem_req_o[i+BanksPerHyperBank].q_valid = select && ic_mem_req[i].q_valid;
      assign mem_req_o[i+BanksPerHyperBank].q.addr  = ic_mem_req[i].q.addr[MemAddrWidth-1:0];
      assign mem_req_o[i+BanksPerHyperBank].q.write = ic_mem_req[i].q.write;
      assign mem_req_o[i+BanksPerHyperBank].q.data  = ic_mem_req[i].q.data;
      assign mem_req_o[i+BanksPerHyperBank].q.strb  = ic_mem_req[i].q.strb;
      assign mem_req_o[i+BanksPerHyperBank].q.user  = ic_mem_req[i].q.user;
      assign mem_req_o[i+BanksPerHyperBank].q.amo   = ic_mem_req[i].q.amo;

      // Response mux (currently assumes response arrives exactly one cycle after request)
      assign ic_mem_rsp[i].q_ready = select ? mem_rsp_i[i+BanksPerHyperBank].q_ready :
        mem_rsp_i[i].q_ready;
      assign ic_mem_rsp[i].p = sel_q ? mem_rsp_i[i+BanksPerHyperBank].p : mem_rsp_i[i].p;

    end else begin : gen_no_demux

      // Demux and mux degenerate to direct one-to-one connections
      assign mem_req_o[i].q_valid  = ic_mem_req[i].q_valid;
      assign mem_req_o[i].q.addr   = ic_mem_req[i].q.addr[MemAddrWidth-1:0];
      assign mem_req_o[i].q.write  = ic_mem_req[i].q.write;
      assign mem_req_o[i].q.data   = ic_mem_req[i].q.data;
      assign mem_req_o[i].q.strb   = ic_mem_req[i].q.strb;
      assign mem_req_o[i].q.user   = ic_mem_req[i].q.user;
      assign mem_req_o[i].q.amo    = ic_mem_req[i].q.amo;
      assign ic_mem_rsp[i].q_ready = mem_rsp_i[i].q_ready;
      assign ic_mem_rsp[i].p       = mem_rsp_i[i].p;

    end
  end

  // We can ignore the existence of two hyperbanks, and use the regular TCDM interconnect to route requests
  // to the bank within the hyperbank. The MSB of the request will determine which hyperbank is addressed.
  // We need to provide space for this MSB by virtually doubling the size of each TCDM bank, as controlled by
  // the `MemAddrWidth` and `mem_req_t` parameters.
  snitch_tcdm_fc_interconnect #(
    .NumInp (NumInp),
    .NumOut (BanksPerHyperBank),
    .mem_req_t (virtual_mem_req_t),
    .mem_rsp_t (mem_rsp_t),
    .TcdmAddrWidth (TcdmAddrWidth),
    .MemAddrWidth (VirtualMemAddrWidth),
    .DataWidth (DataWidth),
    .user_t (user_t),
    .MemoryResponseLatency (MemoryResponseLatency),
    .Radix (Radix),
    .Topology (Topology),
    .NumSwitchNets (NumSwitchNets),
    .SwitchLfsrArbiter (SwitchLfsrArbiter)
  ) i_tcdm_internal_interconnect (
    .clk_i,
    .rst_ni,
    .req_i (req_i),
    .rsp_o (rsp_o),
    .mem_req_o (ic_mem_req),
    .mem_rsp_i (ic_mem_rsp)
  );

  // Only one or two hyperbanks are currently supported
  `ASSERT_INIT(CheckNumHyperbanks, (NumHyperBanks == 1 || NumHyperBanks == 2));

  // MemAddrWidth must be smaller than TcdmAddrWidth.
  `ASSERT_INIT(CheckMemAddrWidth, MemAddrWidth <= TcdmAddrWidth);

endmodule
