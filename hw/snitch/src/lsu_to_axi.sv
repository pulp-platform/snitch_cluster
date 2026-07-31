// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// AUthor: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "common_cells/registers.svh"
`include "common_cells/assertions.svh"
`include "snitch/typedef.svh"
`include "axi/typedef.svh"

/// Convert the Snitch LSU interface to AXI.
///
/// Two things make this module a bit more special:
/// 1. We need to be careful with the memory model: AXI does not imply any
///    ordering between the read and the write channel. On the other hand the
///    LSU protocol does (implicitly because everything is in issue order).
/// 2. Atomic memory operations are supported and they are a bit quirky in the
///    AXI5 standard. In particular the kind of break the assumption that every
///    `AW` implies exactly one `B` because the read data is also returned on
///    the `R` channel.
///
/// ## Memory Ordering
///
/// 1. Atomics need to block and wait until the ID becomes available again.
/// 2. Reads can go after reads, AXI will maintain the ordering.
/// 3. Similarly, writes can go after writes, AXI will also maintain the
///    ordering there.
///
/// This has the drawback that we are overly conservative when only
/// point-to-point ordering is needed. In the future one can implement two
/// regions: (i) one where the ordering between reads and writs is point to
/// point (ii) one where the ordering is strong as it is currently the case.
/// That would also mean that we would need to keep a FIFO width the arbitration
/// decisions so that we can route the response from the correct channel.
///
/// ## Complexity
///
/// The module just needs to save the amount of transactions which are currently
/// in-flight. This parameter is bound by `MaxTrans` and O(log2(MaxTrans)))
/// storage complexity is needed.
///
/// This module does not emit any bursts, but AXI5 capability is needed because
/// of the atomic memory operations.
module lsu_to_axi import snitch_pkg::*; #(
  /// Number of same transactions which can be in-flight
  /// simulatnously. Must be greater than 1.
  parameter int unsigned MaxTrans = 4,
  /// ID with which to send the transactions.
  parameter int unsigned ID = 0,
  parameter int unsigned AddrWidth = 0,
  parameter int unsigned DataWidth = 0,
  parameter int unsigned IdWidth = 0,
  parameter int unsigned UserWidth = 0,
  /// Derived parameters *do not override*
  localparam int unsigned StrbWidth = DataWidth/8,
  localparam type addr_t = logic [AddrWidth-1:0],
  localparam type data_t = logic [DataWidth-1:0],
  localparam type strb_t = logic [StrbWidth-1:0],
  localparam type id_t = logic [IdWidth-1:0],
  localparam type user_t = logic [UserWidth-1:0],
  localparam type lsu_req_t = `LSU_REQ_STRUCT(DataWidth, AddrWidth, UserWidth),
  localparam type lsu_rsp_t = `LSU_RSP_STRUCT(DataWidth),
  localparam type aw_chan_t = `AXI_DECL_AW_CHAN_T(addr_t, id_t, user_t),
  localparam type w_chan_t = `AXI_DECL_W_CHAN_T(data_t, strb_t, user_t),
  localparam type b_chan_t = `AXI_DECL_B_CHAN_T(id_t, user_t),
  localparam type ar_chan_t = `AXI_DECL_AR_CHAN_T(addr_t, id_t, user_t),
  localparam type r_chan_t = `AXI_DECL_R_CHAN_T(data_t, id_t, user_t),
  localparam type axi_req_t = `AXI_DECL_REQ_T(aw_chan_t, w_chan_t, ar_chan_t),
  localparam type axi_rsp_t = `AXI_DECL_RESP_T(b_chan_t, r_chan_t)
) (
  input  logic clk_i,
  input  logic rst_ni,
  input  lsu_req_t lsu_req_i,
  output lsu_rsp_t lsu_rsp_o,
  output axi_req_t axi_req_o,
  input  axi_rsp_t axi_rsp_i
);

  localparam int unsigned CounterWidth = cc_pkg::idx_width(MaxTrans);
  typedef logic [CounterWidth-1:0] cnt_t;
  logic req_is_amo;
  logic is_write;

  logic atomic_in_flight_d, atomic_in_flight_q;
  cnt_t read_cnt_d, read_cnt_q;
  cnt_t write_cnt_d, write_cnt_q;
  logic [DataWidth-1:0] write_data;

  logic q_valid, q_ready;
  logic q_valid_read, q_ready_read;
  logic q_valid_write, q_ready_write;

  logic delay_r_for_atomic, delay_r_for_atomic_q;
  logic r_valid, r_ready;

  // Globally no new transactions can be accepted if there is an unresolved
  // atomic transactions and per channel we can not accept a new transaction iff:
  // - The other channel has in-flight transactions (we can't guarantee the ordering).
  // - The counter would overflow.
  logic stall_read, dec_read_cnt, read_cnt_not_zero;
  logic stall_write, dec_write_cnt, write_cnt_not_zero;
  // AMos need to make sure that they don't re-use an in-flight ID.
  logic stall_amo;

  assign req_is_amo = is_amo(lsu_req_i.q.amo);
  assign is_write = lsu_req_i.q.write | req_is_amo | (lsu_req_i.q.amo == AMOSC);

  assign dec_read_cnt = r_valid & r_ready;
  assign dec_write_cnt = axi_rsp_i.b_valid & axi_req_o.b_ready;

  // Read count isn't zero in this cycle.
  assign read_cnt_not_zero = read_cnt_q > 1 | (read_cnt_q == 1 & ~dec_read_cnt);
  // Write count isn't zero in this cycle.
  assign write_cnt_not_zero = write_cnt_q > 1 | (write_cnt_q == 1 & ~dec_write_cnt);
  // Reads and writes stall iff there are transactions of the othter type in place.
  // See ordering rules above.
  assign stall_write = is_write & (write_cnt_q == MaxTrans-1 | read_cnt_not_zero);
  assign stall_read = !is_write & (read_cnt_q == MaxTrans-1 | write_cnt_not_zero);
  // For atomics we additionally need to check whether there are any in-flight
  // writes, as atomci are already write transactions this wouldn't be captured
  // by the regular case. This makes sure that neither read nor writes are
  // in-flight.
  assign stall_amo = req_is_amo & write_cnt_not_zero;

  // Incoming handshake. Make sure we can accept the new transactions according
  // to our rules.
  always_comb begin
    q_valid = lsu_req_i.q_valid;
    lsu_rsp_o.q_ready = q_ready;
    // Stall new transaction.
    if (atomic_in_flight_q || stall_write || stall_read || stall_amo) begin
      q_valid = 1'b0;
      lsu_rsp_o.q_ready = 1'b0;
    end
  end

  assign q_valid_read = q_valid & ~is_write;
  assign q_valid_write = q_valid & is_write;
  assign q_ready = (q_valid_read & q_ready_read) | (q_valid_write & q_ready_write);

  // ------------------
  // Counter Management
  // ------------------
  // Count the number of in-fligh reads.
  `FF(read_cnt_q, read_cnt_d, '0)
  // Count the number of in-fligh writes.
  `FF(write_cnt_q, write_cnt_d, '0)
  `FF(atomic_in_flight_q, atomic_in_flight_d, '0)

  always_comb begin
    atomic_in_flight_d = atomic_in_flight_q;
    read_cnt_d = read_cnt_q;
    write_cnt_d = write_cnt_q;

    if (lsu_req_i.q_valid && lsu_rsp_o.q_ready) begin
      // Set atomic in-flight flag if we sent an atomic.
      if (req_is_amo) begin
        atomic_in_flight_d = 1'b1;
        read_cnt_d++;
      end

      if (!is_write) read_cnt_d++;
      else write_cnt_d++;
    end

    // Reset atomic in-flight flag.
    if (read_cnt_d == 0 && write_cnt_d == 0) begin
      atomic_in_flight_d = 1'b0;
    end
    // Decrement the write counter again when the signals arrived.
    if (dec_read_cnt) read_cnt_d--;
    if (dec_write_cnt) write_cnt_d--;
  end

  `ASSERT(WriteCntOverflow,  (write_cnt_q == MaxTrans - 1) |=> !(write_cnt_q == 0))
  `ASSERT(ReadCntOverflow,  (read_cnt_q == MaxTrans - 1) |=> !(read_cnt_q == 0))
  `ASSERT(WriteCntUnderflow, (write_cnt_q == 0) |=> !(write_cnt_q == MaxTrans - 1))
  `ASSERT(ReadCntUnderflow,  (read_cnt_q == 0) |=> !(read_cnt_q == MaxTrans - 1))

  // -------------
  // Read Channel
  // -------------

  // AXI read bus assignment.
  assign axi_req_o.ar.addr   = lsu_req_i.q.addr;
  assign axi_req_o.ar.size   = {1'b0, lsu_req_i.q.size};
  assign axi_req_o.ar.burst  = axi_pkg::BURST_INCR;
  assign axi_req_o.ar.lock   = (lsu_req_i.q.amo == AMOLR);
  assign axi_req_o.ar.cache  = axi_pkg::CACHE_MODIFIABLE;
  assign axi_req_o.ar.id     = ID;
  assign axi_req_o.ar.user   = lsu_req_i.q.user;
  assign axi_req_o.ar_valid  = q_valid_read;
  assign q_ready_read        = axi_rsp_i.ar_ready;

  // -------------
  // Write Channel
  // -------------

  // AXI write bus assignment.
  assign axi_req_o.aw.addr   = lsu_req_i.q.addr;
  assign axi_req_o.aw.size   = {1'b0, lsu_req_i.q.size};
  assign axi_req_o.aw.burst  = axi_pkg::BURST_INCR;
  assign axi_req_o.aw.lock   = (lsu_req_i.q.amo == AMOSC);
  assign axi_req_o.aw.cache  = axi_pkg::CACHE_MODIFIABLE;
  assign axi_req_o.aw.id     = ID;
  assign axi_req_o.aw.user   = lsu_req_i.q.user;
  assign axi_req_o.w.data    = write_data;
  assign axi_req_o.w.strb    = lsu_req_i.q.strb;
  assign axi_req_o.w.last    = 1'b1;
  assign axi_req_o.w.user    = lsu_req_i.q.user;

  // Both channels need to handshake (independently).
  cc_stream_fork #(
    .NumOup (2)
  ) i_stream_fork (
    .clk_i,
    .rst_ni,
    .clr_i   (1'b0),
    .valid_i (q_valid_write),
    .ready_o (q_ready_write),
    .valid_o ({axi_req_o.aw_valid, axi_req_o.w_valid}),
    .ready_i ({axi_rsp_i.aw_ready, axi_rsp_i.w_ready})
  );

  `ASSERT(AssertStability, q_valid_write && !q_ready_write |=> q_valid_write)

  // Atomic signalling.
  assign axi_req_o.aw.atop = to_axi_amo(lsu_req_i.q.amo);
  always_comb begin
    write_data = lsu_req_i.q.data;
    if (lsu_req_i.q.amo == AMOAnd) begin
      // in this case we need to invert the data to get a "CLR"
      write_data = ~lsu_req_i.q.data;
    end
  end

  // -----------
  // Return Path
  // -----------
  // There is an atomic instruction present which didn't receive a full
  // handshake on either the AW or W channel. We silence the R channel.
  assign delay_r_for_atomic = q_valid_write & ~q_ready_write & req_is_amo;

  assign r_valid = axi_rsp_i.r_valid & ~delay_r_for_atomic_q;
  assign axi_req_o.r_ready  = r_ready & ~delay_r_for_atomic_q;

  // Delay the signal for one cycle. We will never get the R response in the
  // same cycle as the request. (Except for when the W is after the AW and the R
  // comes in the same cycle, we will loose a cycle latency)
  `FF(delay_r_for_atomic_q, delay_r_for_atomic, '0)

  // As we can never have two read and write transactions in-flight (except for
  // atomics) simultaneously return path arbitration becomes quite an simply an
  // `or` between `r` and `b` channel.
  assign lsu_rsp_o.p.error = (r_valid & axi_rsp_i.r.resp[1])
                              | (axi_rsp_i.b_valid & axi_rsp_i.b.resp[1]);

  // In case we have an atomic instruction in-flight we don't pass on the
  // b channel as we are just interested in the read data. The logic in this
  // module will make sure that we only issue new instructions if the atomic has
  // been fully resolved.
  assign lsu_rsp_o.p_valid = r_valid | (~atomic_in_flight_q & axi_rsp_i.b_valid);
  // In case we have an atomic in flight we need to delay the r response. In AXI
  // they can come before the interface accepted the W beat, this would mess
  // with the counters (underflow).
  assign r_ready = lsu_req_i.p_ready & r_valid;
  assign axi_req_o.b_ready = (lsu_req_i.p_ready | atomic_in_flight_q) & axi_rsp_i.b_valid;

  always_comb begin
    lsu_rsp_o.p.data = '0;
    // Normal case.
    if (r_valid) lsu_rsp_o.p.data = axi_rsp_i.r.data;
    // In case we got a B response and this wasn't an atomic, let's check
    // if we need to signal an `exclusive error` i.e., check if the we got `RESP_EXOKAY`.
    // In case we didn't, we set the response to `1` which signals a failed
    // store conditional for the LSU interface.
    if ((axi_rsp_i.b_valid && ~atomic_in_flight_q
          && axi_rsp_i.b.resp != axi_pkg::RESP_EXOKAY)) begin
      // Set all 32-bit words to 1 since we don't know the alignment
      // and which bits are cut off by the core.
      lsu_rsp_o.p.data = {DataWidth/32{32'h1}};
    end
  end

  // AXI auxiliary signal
  assign axi_req_o.aw.len = '0;
  assign axi_req_o.aw.qos = 4'b0;
  assign axi_req_o.aw.prot = 3'b0;
  assign axi_req_o.aw.region = 4'b0;
  assign axi_req_o.ar.len = '0;
  assign axi_req_o.ar.qos = 4'b0;
  assign axi_req_o.ar.prot = 3'b0;
  assign axi_req_o.ar.region = 4'b0;

  // Assertions:
  // Make sure that write is never set for AMOs.
  `ASSERT(AMOWriteEnable, lsu_req_i.q_valid &&
    (lsu_req_i.q.amo != snitch_pkg::AMONone) |-> !lsu_req_i.q.write)
  // Check that the data width is in the range of 32 or 64 bit. We didn't define
  // any other bus widths so far.
  `ASSERT_INIT(check_DataWidth, DataWidth inside {32, 64})
  `ASSERT_INIT(MaxTrans_greater_than_one, MaxTrans > 1)
  // 1. Assert that the in-flight counters are never both 2+ == 2+, that would
  //    imply an illegal state.

endmodule
