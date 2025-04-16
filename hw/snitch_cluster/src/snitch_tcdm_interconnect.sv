// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Maximilian Coco <mcoco@student.ethz.ch>
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "mem_interface/typedef.svh"
`include "common_cells/registers.svh"
`include "common_cells/assertions.svh"

/// Fixed response latency interconnect with support for multiple hyperbanks.
module snitch_tcdm_interconnect #(
  /// Number of inputs into the interconnect (`> 0`).
  parameter int unsigned NumInp                = 32'd0,
  /// Number of outputs from the interconnect (`> 0`).
  parameter int unsigned NumOut                = 32'd0,
  /// Number of hyperbanks.
  parameter int unsigned NumHyperBanks         = 32'd1,
  /// Radix of the individual switch points of the network.
  /// Currently supported are `32'd2` and `32'd4`.
  parameter int unsigned Radix                 = 32'd2,
  /// Number of parallel networks for switch-based interconnects.
  parameter int unsigned NumSwitchNets          = 32'd2,
  /// Whether to use an LFSR to arbitrate switch-based networks.
  parameter bit          SwitchLfsrArbiter      = 1'b0,
  /// Payload type of the data request ports.
  parameter type         tcdm_req_t            = logic,
  /// Payload type of the data response ports.
  parameter type         tcdm_rsp_t            = logic,
  /// Payload type of the data request ports.
  parameter type         mem_req_t             = logic,
  /// Payload type of the data response ports.
  parameter type         mem_rsp_t             = logic,
  /// Address width on the request side.
  parameter int unsigned TcdmAddrWidth         = 32,
  /// Address width on the memory side. Must be smaller than the incoming
  /// address width.
  parameter int unsigned MemAddrWidth          = 32,
  /// Data size of the interconnect. Only the data portion counts. The offsets
  /// into the address are derived from this.
  parameter int unsigned DataWidth             = 32,
  /// Additional user payload to route.
  parameter type         user_t                = logic,
  /// Latency of memory response (in cycles)
  parameter int unsigned MemoryResponseLatency = 1,
  parameter snitch_pkg::topo_e Topology        = snitch_pkg::LogarithmicInterconnect
) (
  /// Clock, positive edge triggered.
  input  logic                             clk_i,
  /// Reset, active low.
  input  logic                             rst_ni,
  /// Request port.
  input  tcdm_req_t           [NumInp-1:0] req_i,
  /// Resposne port.
  output tcdm_rsp_t           [NumInp-1:0] rsp_o,
  /// Memory Side
  /// Request.
  output mem_req_t            [NumOut-1:0] mem_req_o,
  /// Response.
  input  mem_rsp_t            [NumOut-1:0] mem_rsp_i
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
    .tcdm_req_t (tcdm_req_t),
    .tcdm_rsp_t (tcdm_rsp_t),
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

endmodule
