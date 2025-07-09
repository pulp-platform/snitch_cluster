// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

/// Load Store Unit (can handle `NumOutstandingLoads` outstanding loads and
/// `NumOutstandingMem` requests in total) and optionally NaNBox if used in a
/// floating-point setting. It expects its memory sub-system to keep order (as if
/// issued with a single ID).
module snitch_lsu #(
  parameter int unsigned AddrWidth           = 32,
  parameter int unsigned DataWidth           = 32,
  /// Tag passed from input to output. All transactions are in-order.
  parameter type tag_t                       = logic [4:0],
  /// Number of outstanding memory transactions.
  parameter int unsigned NumOutstandingMem   = 1,
  /// Number of outstanding loads.
  parameter int unsigned NumOutstandingLoads = 1,
  /// Whether to NaN Box values. Used for floating-point load/stores.
  parameter bit          NaNBox              = 0,
  /// Whether to instantiate a consistency address queue (CAQ). The CAQ enables
  /// consistency with another LSU in the same hart (i.e. in the FPSS) strictly
  /// *downstream* of the issuing Snitch core. For all offloaded accesses, the
  /// word address LSBs are pushed into the Snitch core's CAQ on offload and
  /// popped when completed by the downstream LSU. Incoming accesses possibly
  /// overtaking pending downstream accesses in the CAQ are stalled.
  parameter bit          Caq                 = 0,
  /// CAQ Depth; should match the number of downstream LSU outstanding requests.
  parameter int unsigned CaqDepth            = 0,
  /// Size of CAQ address LSB tags; provides a pessimism-complexity tradeoff.
  parameter int unsigned CaqTagWidth         = 0,
  /// Whether the LSU should track repeated instructions issued by a sequencer
  /// and accordingly filter them from its CAQ responses as is necessary.
  parameter bit          CaqRespTrackSeq     = 0,
  parameter type         dreq_t              = logic,
  parameter type         drsp_t              = logic,
  /// Derived parameter *Do not override*
  parameter type addr_t = logic [AddrWidth-1:0],
  parameter type data_t = logic [DataWidth-1:0]
) (
  input  logic                 clk_i,
  input  logic                 rst_i,
  // request channel
  input  tag_t                 lsu_qtag_i,
  input  logic                 lsu_qwrite_i,
  input  logic                 lsu_qsigned_i,
  input  addr_t                lsu_qaddr_i,
  input  data_t                lsu_qdata_i,
  input  logic [1:0]           lsu_qsize_i,
  input  reqrsp_pkg::amo_op_e  lsu_qamo_i,
  input  logic                 lsu_qrepd_i,  // Whether this is a sequencer repetition
  input  addr_t                lsu_qmcast_i,  // Multicast mask
  input  logic                 lsu_qvalid_i,
  output logic                 lsu_qready_o,
  // response channel
  output data_t                lsu_pdata_o,
  output tag_t                 lsu_ptag_o,
  output logic                 lsu_perror_o,
  output logic                 lsu_pvalid_o,
  input  logic                 lsu_pready_i,
  /// CAQ request snoop channel. Only some address bits will be read.
  /// Fork offloaded loads/stores to here iff `Caq` is 1.
  input  addr_t                caq_qaddr_i,
  input  logic                 caq_qwrite_i,
  input  logic                 caq_qvalid_i,
  output logic                 caq_qready_o,
  /// Incoming CAQ response snoop channel.
  /// Fork responses to offloaded loads/stores to here iff `Caq` is 1.
  input  logic                 caq_pvalid_i,
  /// Outgoing CAQ response snoop channel.
  /// Signals whether access response was handshaked.
  output logic                 caq_pvalid_o,
  /// High if there is currently no transaction pending.
  output logic                 lsu_empty_o,
  /// High if the CAQ is empty.
  output logic                 caq_empty_o,
  // Memory Interface Channel
  output dreq_t                data_req_o,
  input  drsp_t                data_rsp_i
);

  `include "common_cells/assertions.svh"

  localparam int unsigned DataAlign = $clog2(DataWidth/8);

  // -------------------------------
  // Consistency Address Queue (CAQ)
  // -------------------------------

  // TODO: What about exceptions? We *should* get a response for all offloaded
  // loads/stores anyways as already issued instructions should conclude, but
  // if this is not the case, things go south!

  logic lsu_postcaq_qvalid, lsu_postcaq_qready;

  if (Caq) begin : gen_caq

    logic caq_lsu_gnt, caq_lsu_exists;
    logic caq_out_valid, caq_out_gnt;
    logic caq_pass, caq_alters_mem;

    // CAQ passes requests to downstream LSU only once they are known not to collide.
    // This is assumed to be *stable* once given as the Snitch core is stalled on a
    // load/store and elements can only be popped from the queue, not pushed.
    assign caq_pass = caq_lsu_gnt & ~caq_lsu_exists;

    // We need to stall on collisions with anything altering memory, including atomics
    assign caq_alters_mem = lsu_qwrite_i | (lsu_qamo_i != reqrsp_pkg::AMONone);

    // Gate downstream LSU on CAQ pass
    assign lsu_postcaq_qvalid = caq_pass & lsu_qvalid_i;
    assign lsu_qready_o = caq_pass & lsu_postcaq_qready;

    id_queue #(
      .data_t    ( logic [CaqTagWidth:0] ), // Store address tag *and* write enable
      .ID_WIDTH  ( 1 ),                     // De facto 0: no reorder capability here
      .CAPACITY  ( CaqDepth ),
      .FULL_BW   ( 1 )
    ) i_caq (
      .clk_i,
      .rst_ni   ( ~rst_i ),
      // Push in snooped accesses offloaded to downstream LSU
      .inp_id_i   ( '0 ),
      .inp_data_i ( {caq_qwrite_i, caq_qaddr_i[CaqTagWidth+DataAlign-1:DataAlign]} ),
      .inp_req_i  ( caq_qvalid_i ),
      .inp_gnt_o  ( caq_qready_o ),
      // Check if currently presented request collides with any snooped ones.
      // Check address tag in any case. Check the write enable only when it
      // is necessary. If we receive a write, stall on any address match
      // (i.e. exclude MSB from the collision check, can be 0 or 1). If we
      // receive a non-altering access, we stall only if a write collides.
      .exists_mask_i  ( {~caq_alters_mem, {(CaqTagWidth){1'b1}}} ),
      .exists_data_i  ( {1'b1, lsu_qaddr_i[CaqTagWidth+DataAlign-1:DataAlign]} ),
      .exists_req_i   ( lsu_qvalid_i ),
      .exists_gnt_o   ( caq_lsu_gnt ),
      .exists_o       ( caq_lsu_exists ),
      // Pop output whenever we get a response for a snooped request.
      // This has no backpressure as we should snoop as many responses as requests.
      .oup_id_i         ( '0 ),
      .oup_pop_i        ( caq_pvalid_i ),
      .oup_req_i        ( caq_pvalid_i ),
      .oup_data_o       (  ),
      .oup_data_valid_o ( caq_out_valid ),
      .oup_gnt_o        ( caq_out_gnt ),
      // Status interface
      .full_o           ( ),
      .empty_o          ( caq_empty_o )
    );

    // Check that we do not pop more snooped responses than we pushed requests.
    `ASSERT(CaqPopEmpty, (caq_pvalid_i |-> caq_out_gnt && caq_out_valid), clk_i, rst_i)

    // Check that once asserted, `caq_pass` is stable until we handshake the load/store
    `ASSERT(CaqPassStable, ($rose(caq_pass) |->
        (caq_pass until_with lsu_qvalid_i & lsu_qready_o)), clk_i, rst_i)

  end else begin : gen_no_caq

    // No CAQ can stall us; forward request handshake to LSU logic
    assign lsu_postcaq_qvalid = lsu_qvalid_i;
    assign lsu_qready_o = lsu_postcaq_qready;

    // Tie CAQ interface
    assign caq_qready_o = '1;

  end

  // --------------
  // Downstream LSU
  // --------------

  logic [63:0] ld_result;
  logic [63:0] lsu_qdata, data_qdata;

  typedef struct packed {
    tag_t                  tag;
    logic                  sign_ext;
    logic [DataAlign-1:0] offset;
    logic [1:0]            size;
  } laq_t;

  // Load Address Queue (LAQ)
  laq_t laq_in, laq_out;
  logic mem_out;
  logic laq_full, mem_full;
  logic laq_push;

  fifo_v3 #(
    .FALL_THROUGH ( 1'b0                ),
    .DEPTH        ( NumOutstandingLoads ),
    .dtype        ( laq_t               )
  ) i_fifo_laq (
    .clk_i,
    .rst_ni (~rst_i),
    .flush_i (1'b0),
    .testmode_i(1'b0),
    .full_o (laq_full),
    .empty_o (/* open */),
    .usage_o (/* open */),
    .data_i (laq_in),
    .push_i (laq_push),
    .data_o (laq_out),
    .pop_i (data_rsp_i.p_valid & data_req_o.p_ready & ~mem_out)
  );

  // For each memory transaction save whether this was a load or a store. We
  // need this information to suppress stores.
  logic [CaqRespTrackSeq:0] req_queue_in, req_queue_out;

  assign req_queue_in[0] = lsu_qwrite_i;
  assign mem_out = req_queue_out[0];

  if (CaqRespTrackSeq) begin : gen_caq_resp_track_seq
    assign req_queue_in[1] = lsu_qrepd_i;
    // When tracking a sequencer, repeated accesses are masked as the core issues them only once.
    // Thus, for sequenced loads or stores, only the *first issue* is popped in the CAQ.
    // This means that the first issue will block on collisions and subsequent repeats will not.
    // Like SSRs, loads or stores in sequencer loops (i.e. FREP) do *not* guarantee consistency.
    assign caq_pvalid_o = data_rsp_i.p_valid & data_req_o.p_ready & ~req_queue_out[1];
  end else begin : gen_no_caq_resp_track_seq
    // When not tracking a sequencer, simply signal the response handshake.
    assign caq_pvalid_o = data_rsp_i.p_valid & data_req_o.p_ready;
  end

  fifo_v3 #(
    .FALL_THROUGH (1'b0),
    .DEPTH (NumOutstandingMem),
    .DATA_WIDTH (1 + CaqRespTrackSeq)
  ) i_fifo_mem (
    .clk_i,
    .rst_ni (~rst_i),
    .flush_i (1'b0),
    .testmode_i (1'b0),
    .full_o (mem_full),
    .empty_o (lsu_empty_o),
    .usage_o ( /* open */ ),
    .data_i (req_queue_in),
    .push_i (data_req_o.q_valid & data_rsp_i.q_ready),
    .data_o (req_queue_out),
    .pop_i (data_rsp_i.p_valid & data_req_o.p_ready)
  );

  assign laq_in = '{
    tag:      lsu_qtag_i,
    sign_ext: lsu_qsigned_i,
    offset:   lsu_qaddr_i[DataAlign-1:0],
    size:     lsu_qsize_i
  };

  // Only make a request when we got a valid request and if it is a load also
  // check that we can actually store the necessary information to process it in
  // the upcoming cycle(s).
  assign data_req_o.q_valid = lsu_postcaq_qvalid & (lsu_qwrite_i | ~laq_full) & ~mem_full;
  assign data_req_o.q.write = lsu_qwrite_i;
  assign data_req_o.q.addr = lsu_qaddr_i;
  assign data_req_o.q.mask = lsu_qmcast_i;
  assign data_req_o.q.amo  = lsu_qamo_i;
  assign data_req_o.q.size = lsu_qsize_i;

  // Generate byte enable mask.
  always_comb begin
    unique case (lsu_qsize_i)
      2'b00: data_req_o.q.strb = ('b1 << lsu_qaddr_i[DataAlign-1:0]);
      2'b01: data_req_o.q.strb = ('b11 << lsu_qaddr_i[DataAlign-1:0]);
      2'b10: data_req_o.q.strb = ('b1111 << lsu_qaddr_i[DataAlign-1:0]);
      2'b11: data_req_o.q.strb = '1;
      default: data_req_o.q.strb = '0;
    endcase
  end

  // Re-align write data.
  /* verilator lint_off WIDTH */
  assign lsu_qdata = $unsigned(lsu_qdata_i);
  always_comb begin
    unique case (lsu_qaddr_i[DataAlign-1:0])
      3'b000: data_qdata = lsu_qdata;
      3'b001: data_qdata = {lsu_qdata[55:0], lsu_qdata[63:56]};
      3'b010: data_qdata = {lsu_qdata[47:0], lsu_qdata[63:48]};
      3'b011: data_qdata = {lsu_qdata[39:0], lsu_qdata[63:40]};
      3'b100: data_qdata = {lsu_qdata[31:0], lsu_qdata[63:32]};
      3'b101: data_qdata = {lsu_qdata[23:0], lsu_qdata[63:24]};
      3'b110: data_qdata = {lsu_qdata[15:0], lsu_qdata[63:16]};
      3'b111: data_qdata = {lsu_qdata[7:0],  lsu_qdata[63:8]};
      default: data_qdata = lsu_qdata;
    endcase
  end
  assign data_req_o.q.data = data_qdata[DataWidth-1:0];
  /* verilator lint_on WIDTH */

  // The interface didn't accept our request yet
  assign lsu_postcaq_qready = ~(data_req_o.q_valid & ~data_rsp_i.q_ready)
                      & (lsu_qwrite_i | ~laq_full) & ~mem_full;
  assign laq_push = ~lsu_qwrite_i & data_rsp_i.q_ready & data_req_o.q_valid & ~laq_full;

  // Return Path
  // shift the load data back
  logic [63:0] shifted_data;
  assign shifted_data = data_rsp_i.p.data >> {laq_out.offset, 3'b000};
  always_comb begin
    unique case (laq_out.size)
      2'b00: ld_result = {{56{(shifted_data[7] | NaNBox) & laq_out.sign_ext}}, shifted_data[7:0]};
      2'b01: ld_result = {{48{(shifted_data[15] | NaNBox) & laq_out.sign_ext}}, shifted_data[15:0]};
      2'b10: ld_result = {{32{(shifted_data[31] | NaNBox) & laq_out.sign_ext}}, shifted_data[31:0]};
      2'b11: ld_result = shifted_data;
      default: ld_result = shifted_data;
    endcase
  end

  assign lsu_perror_o = data_rsp_i.p.error;
  assign lsu_pdata_o = ld_result[DataWidth-1:0];
  assign lsu_ptag_o = laq_out.tag;
  // In case of a write, don't signal a valid transaction. Stores are always
  // without ans answer to the core.
  assign lsu_pvalid_o = data_rsp_i.p_valid & ~mem_out;
  assign data_req_o.p_ready = lsu_pready_i | mem_out;

endmodule
