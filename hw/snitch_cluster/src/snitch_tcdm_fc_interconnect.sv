// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Author: Wolfgang Roenninger <wroennin@ethz.ch>

`include "mem_interface/typedef.svh"

/// Lightweight wrapper for a fixed response latency fully-connected (FC) interconnect,
/// i.e. something that can be used to interconnect memories.
module snitch_tcdm_fc_interconnect #(
  /// Number of inputs into the interconnect (`> 0`).
  parameter int unsigned NumInp                = 32'd0,
  /// Number of outputs from the interconnect (`> 0`).
  parameter int unsigned NumOut                = 32'd0,
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

  localparam int unsigned ByteOffset = $clog2(DataWidth/8);
  localparam int unsigned StrbWidth = DataWidth/8;
  typedef logic [MemAddrWidth-1:0] addr_t;
  typedef logic [DataWidth-1:0] data_t;
  typedef logic [StrbWidth-1:0] strb_t;
  `MEM_TYPEDEF_REQ_CHAN_T(mem_req_chan_t, addr_t, data_t, strb_t, user_t);

  // Do not assert unconditional stability on write data inside interconnects,
  // as write data may freely change on (non-atomic) reads. We properly assert
  // conditional write data stability below.
  localparam mem_req_chan_t MemReqAsrtMask =
      '{data: '0, strb: '0, amo: reqrsp_pkg::amo_op_e'('1), default: '1};

  // Width of the bank select signal.
  localparam int unsigned SelWidth = cf_math_pkg::idx_width(NumOut);
  typedef logic [SelWidth-1:0] select_t;
  select_t [NumInp-1:0] bank_select;

  typedef struct packed {
    // Which bank was selected.
    select_t bank_select;
    // The response is valid.
    logic valid;
  } rsp_t;

  // Generate the `bank_select` signal based on the address.
  // This generates a bank interleaved addressing scheme, where consecutive
  // addresses are routed to individual banks.
  for (genvar i = 0; i < NumInp; i++) begin : gen_bank_select
    assign bank_select[i] = req_i[i].q.addr[TcdmAddrWidth-1:ByteOffset] % NumOut;
  end

  mem_req_chan_t [NumInp-1:0] in_req;
  mem_req_chan_t [NumOut-1:0] out_req;

  logic [NumInp-1:0] req_q_valid_flat, rsp_q_ready_flat;
  logic [NumOut-1:0] mem_q_valid_flat, mem_q_ready_flat;

  // The usual struct packing unpacking; also check write stability here.
  for (genvar i = 0; i < NumInp; i++) begin : gen_flat_inp
    assign req_q_valid_flat[i] = req_i[i].q_valid;
    assign rsp_o[i].q_ready = rsp_q_ready_flat[i];
    assign in_req[i] = '{
      addr: req_i[i].q.addr[TcdmAddrWidth-1:ByteOffset] / NumOut,
      write: req_i[i].q.write,
      amo: req_i[i].q.amo,
      data: req_i[i].q.data,
      strb: req_i[i].q.strb,
      user: req_i[i].q.user
    };

    // Write data must also be stable during AMOs, so include this case in assertions.
    logic in_req_alters_mem;
    assign in_req_alters_mem = in_req[i].write | (in_req[i].amo != reqrsp_pkg::AMONone);

    // TODO: we could clean this up with an additional common_cells assertion macro.
    `ifndef VERILATOR
    `ifndef SYNTHESIS
    assert property (@(posedge clk_i) disable iff (~rst_ni) (req_q_valid_flat[i] &&
        !rsp_q_ready_flat[i] && in_req_alters_mem |=> $stable(in_req[i].data))) else
      $error("write data during non-read is unstable at input: %0d", i);
    assert property (@(posedge clk_i) disable iff (~rst_ni) (req_q_valid_flat[i] &&
        !rsp_q_ready_flat[i] && in_req_alters_mem |=> $stable(in_req[i].strb))) else
      $error("write strobe during non-read is unstable at input: %0d", i);
    `endif
    `endif
  end

  for (genvar i = 0; i < NumOut; i++) begin : gen_flat_oup
    assign mem_req_o[i].q_valid = mem_q_valid_flat[i];
    assign mem_q_ready_flat[i] = mem_rsp_i[i].q_ready;
    assign mem_req_o[i].q = out_req[i];
  end

  // ------------
  // Request Side
  // ------------
  // We need to arbitrate the requests coming from the input side and resolve
  // potential bank conflicts. Therefore a full arbitration tree is needed.
  if (Topology == snitch_pkg::LogarithmicInterconnect) begin : gen_xbar
    stream_xbar #(
      .NumInp      ( NumInp    ),
      .NumOut      ( NumOut    ),
      .payload_t   ( mem_req_chan_t ),
      .OutSpillReg ( 1'b0      ),
      .ExtPrio     ( 1'b0      ),
      .AxiVldRdy   ( 1'b1      ),
      .LockIn      ( 1'b1      ),
      .AxiVldMask  ( MemReqAsrtMask )
    ) i_stream_xbar (
      .clk_i,
      .rst_ni,
      .flush_i ( 1'b0 ),
      .rr_i    ( '0 ),
      .data_i  ( in_req ),
      .sel_i   ( bank_select ),
      .valid_i ( req_q_valid_flat ),
      .ready_o ( rsp_q_ready_flat ),
      .data_o  ( out_req ),
      .idx_o   ( ),
      .valid_o ( mem_q_valid_flat ),
      .ready_i ( mem_q_ready_flat )
    );
  end else if (Topology == snitch_pkg::OmegaNet) begin : gen_omega_net
    localparam int unsigned NumInpPerNet = cf_math_pkg::ceil_div(NumInp, NumSwitchNets);

    // Intermediate request signals for Omega-to-Xbar interface
    mem_req_chan_t  [NumSwitchNets-1:0][NumOut-1:0] oout_data;
    logic           [NumSwitchNets-1:0][NumOut-1:0] oout_valid, oout_ready;

    // Arbitration for Omega and Xbar stages, respectively
    logic [cf_math_pkg::idx_width(NumOut)-1:0]        rr1;
    logic [cf_math_pkg::idx_width(NumSwitchNets)-1:0]  rr2;

    // Use pseudorandom arbitration if desired. For reference, see:
    // https://github.com/pulp-platform/cluster_interconnect/blob/master/rtl/tcdm_interconnect/tcdm_interconnect.sv
    if (SwitchLfsrArbiter) begin : gen_omega_lsfr
      logic [cf_math_pkg::idx_width(NumInp)-1:0] rr;
      lfsr #(
        .LfsrWidth    ( 64 ),
        .OutWidth     ( $clog2(NumInp) ),
        .CipherLayers ( 3 ),
        .CipherReg    ( 1'b1 )
      ) i_lfsr (
        .clk_i,
        .rst_ni,
        .en_i     ( |(req_q_valid_flat & rsp_q_ready_flat) ),
        .out_o    ( rr )
      );
      // The upper bits of `rr1` are truncated iff not needed in Butterfly networks.
      assign rr1 = rr[$high(rr):$clog2(NumSwitchNets)];
      assign rr2 = rr[$clog2(NumSwitchNets)-1:0];
    end else begin : gen_no_omega_lsfr
      assign rr1 = '0;
      assign rr2 = '0;
    end

    // Work around enum incompatibility and expand signals for part selects
    typedef logic  [$bits(mem_req_chan_t)-1:0]          data_t;
    typedef data_t [NumSwitchNets-1:0][NumInpPerNet-1:0] flat_data_t;
    typedef logic  [NumSwitchNets-1:0][NumInpPerNet-1:0] flat_hs_t;

    flat_data_t data_in;
    select_t    [NumSwitchNets-1:0][NumInpPerNet-1:0] in_sel;
    flat_hs_t   in_valid, in_ready;

    assign data_in  = in_req;
    assign in_sel   = bank_select;
    assign in_valid = req_q_valid_flat;
    assign rsp_q_ready_flat = in_ready;

    // Generate Omega networks (first stage)
    // TODO: Ideally, we should balance the tie-off of unused ports across networks,
    // minimizing request imbalalance and maximizing performance.
    for (genvar i = 0; i < NumSwitchNets; ++i) begin : gen_omega_nets
      data_t [NumOut-1:0] data_out;
      assign oout_data[i] = data_out;
      stream_omega_net #(
        .NumInp      ( NumInpPerNet ),
        .NumOut      ( NumOut ),
        .payload_t   ( data_t ),
        .ExtPrio     ( SwitchLfsrArbiter ),
        .SpillReg    ( 1'b0 ),
        .AxiVldRdy   ( 1'b1 ),
        .LockIn      ( 1'b1 ),
        .Radix       ( Radix ),
        .AxiVldMask  ( MemReqAsrtMask )
      ) i_stream_omega_net (
        .clk_i,
        .rst_ni,
        .flush_i ( 1'b0 ),
        // TODO: switch-level arbitration currently unconnected inside `stream_omega_net`
        .rr_i    ( /*rr1*/ '0 ),
        .sel_i   ( in_sel[i] ),
        .data_i  ( data_in[i]  ),
        .valid_i ( in_valid[i] ),
        .ready_o ( in_ready[i] ),
        .data_o  ( data_out ),
        .valid_o ( oout_valid[i] ),
        .ready_i ( oout_ready[i] ),
        .idx_o   ( )
      );
    end

    // Generate per-output multiplexers (second stage)
    for (genvar i = 0; i < NumOut; ++i) begin : gen_out_arbs
      mem_req_chan_t  [NumSwitchNets-1:0] rrin_data;
      logic           [NumSwitchNets-1:0] rrin_valid, rrin_ready;

      // Bundle Omega net request channels for this bank
      for (genvar k = 0; k < NumSwitchNets; ++k) begin : gen_rrin_in
        assign rrin_data[k]     = oout_data[k][i];
        assign rrin_valid[k]    = oout_valid[k][i];
        assign oout_ready[k][i] = rrin_ready[k];
      end

      rr_arb_tree #(
        .NumIn     ( NumSwitchNets ),
        .DataType  ( mem_req_chan_t ),
        .ExtPrio   ( SwitchLfsrArbiter ),
        .AxiVldRdy ( 1'b1 ),
        .LockIn    ( 1'b1 )
      ) i_rr_arb_tree (
        .clk_i,
        .rst_ni,
        .flush_i ( 1'b0 ),
        .rr_i    ( rr2 ),
        .data_i  ( rrin_data ),
        .req_i   ( rrin_valid ),
        .gnt_o   ( rrin_ready ),
        .data_o  ( out_req[i] ),
        .req_o   ( mem_q_valid_flat[i] ),
        .gnt_i   ( mem_q_ready_flat[i] ),
        .idx_o   (  )
      );
    end
  end

  // -------------
  // Response Side
  // -------------
  // A simple multiplexer is sufficient here.
  for (genvar i = 0; i < NumInp; i++) begin : gen_rsp_mux
    rsp_t out_rsp_mux, in_rsp_mux;
    assign in_rsp_mux = '{
      bank_select: bank_select[i],
      valid: req_i[i].q_valid & rsp_o[i].q_ready
    };
    // A this is a fixed latency interconnect a simple shift register is
    // sufficient to track the arbitration decisions.
    shift_reg #(
      .dtype ( rsp_t ),
      .Depth ( MemoryResponseLatency )
    ) i_shift_reg (
      .clk_i,
      .rst_ni,
      .d_i ( in_rsp_mux ),
      .d_o ( out_rsp_mux )
    );
    assign rsp_o[i].p.data = mem_rsp_i[out_rsp_mux.bank_select].p.data;
    assign rsp_o[i].p_valid = out_rsp_mux.valid;
  end


endmodule
