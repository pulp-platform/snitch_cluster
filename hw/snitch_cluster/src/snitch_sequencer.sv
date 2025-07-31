// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "common_cells/registers.svh"
`include "common_cells/assertions.svh"

/// Description: Filters FPU repetition instructions
module snitch_sequencer import snitch_pkg::*; #(
    parameter int unsigned AddrWidth = 0,
    parameter int unsigned DataWidth = 0,
    parameter int unsigned BufferDepth = 32,
    parameter int unsigned NestDepth = 1,
    parameter acc_addr_e DstAddr = FP_SS,
    /// Derived parameter *Do not override*
    localparam type addr_t = logic [AddrWidth-1:0],
    localparam type data_t = logic [DataWidth-1:0]
) (
    input  logic                             clk_i,
    input  logic                             rst_i,
    // pragma translate_off
    output fpu_sequencer_trace_port_t        trace_port_o,
    // pragma translate_on
    input  acc_addr_e                        inp_qaddr_i,
    input  logic                      [ 4:0] inp_qid_i,
    input  logic                      [31:0] inp_qdata_op_i,  // RISC-V instruction
    input  data_t                            inp_qdata_arga_i,
    input  data_t                            inp_qdata_argb_i,
    input  addr_t                            inp_qdata_argc_i,
    input  logic                             inp_qvalid_i,
    output logic                             inp_qready_o,
    output acc_addr_e                        oup_qaddr_o,
    output logic                      [ 4:0] oup_qid_o,
    output logic                      [31:0] oup_qdata_op_o,  // RISC-V instruction
    output data_t                            oup_qdata_arga_o,
    output data_t                            oup_qdata_argb_o,
    output addr_t                            oup_qdata_argc_o,
    output logic                             oup_qdata_repd_o,  // Whether this is a repeated issue
    output logic                             oup_qvalid_o,
    input  logic                             oup_qready_i,
    // SSR stream control interface
    input  logic                             streamctl_done_i,
    input  logic                             streamctl_valid_i,
    output logic                             streamctl_ready_o
);

  //////////////////////////
  // Parameters and types //
  //////////////////////////

  localparam int unsigned DepthBits = $clog2(BufferDepth);
  localparam int unsigned LoopCntBits = $clog2(NestDepth + 1);
  localparam int unsigned LoopIdxBits = cf_math_pkg::idx_width(NestDepth);
  // We arbitrarily limit this to 16 bits, i.e. max 65536 iterations
  localparam int LoopIterBits = 16;

  typedef logic [LoopCntBits-1:0] loop_cnt_t;
  typedef logic [LoopIdxBits-1:0] loop_idx_t;

  // Instruction type
  typedef enum logic [1:0] {
    Frep = 2,
    Direct = 1,
    Buffer = 0
  } inst_path_t;

  // Loop configuration
  typedef struct packed {
    logic is_streamctl;
    logic [DepthBits-1:0] max_inst;
    logic [LoopIterBits-1:0] max_iter;
    logic [2:0] stagger_max;
    logic [3:0] stagger_mask;  // one-hot stagger mask
    logic [DepthBits:0] base_pointer;  // loop base pointer where the config starts
  } loop_cfg_t;

  // Ring buffer entry type
  typedef struct packed {
    logic [31:0] qdata_op;
    addr_t qdata_argc;
  } rb_entry_t;

  // Sequencer output struct
  typedef struct packed {
    acc_addr_e   qaddr;
    logic  [4:0] qid;
    logic [31:0] qdata_op;  // RISC-V instruction
    data_t       qdata_arga;
    data_t       qdata_argb;
    addr_t       qdata_argc;
    logic        qdata_repd;
  } oup_data_t;

  /////////////////
  // Connections //
  /////////////////

  // Loop controllers to nest controller
  logic [NestDepth-1:0] last_iter;
  logic [NestDepth-1:0] last_inst;

  // Nest controller to loop controllers
  logic [NestDepth-1:0] incr_inst;

  // Nest controller to ring buffer
  logic [DepthBits-1:0] rb_raddr;
  logic rb_rvalid;
  logic rb_advance;
  logic [$clog2(BufferDepth+1)-1:0] rb_step;

  // Ring buffer to nest controller
  logic [DepthBits-1:0] rb_wptr;
  logic rb_rready;

  // Nest controller to output mux
  oup_data_t seq_out_data;
  logic seq_out_valid;

  // Output mux to nest controller
  logic seq_out_ready;

  /////////////
  // Decoder //
  /////////////

  inst_path_t inst_path_sel;

  always_comb begin : proc_decoder
    inst_path_sel = Buffer;

    unique casez (inp_qdata_op_i)
      riscv_instr::FREP_O,
      riscv_instr::IREP: begin
        inst_path_sel = Frep;
      end

      // Instructions which explicitly sync between int and float
      // pipeline are not supported within an FREP and need to
      // bypass the ring buffer.

      // float to int
      riscv_instr::FLE_S,
      riscv_instr::FLT_S,
      riscv_instr::FEQ_S,
      riscv_instr::FCLASS_S,
      riscv_instr::FCVT_W_S,
      riscv_instr::FCVT_WU_S,
      riscv_instr::FMV_X_W,
      riscv_instr::VFEQ_S,
      riscv_instr::VFEQ_R_S,
      riscv_instr::VFNE_S,
      riscv_instr::VFNE_R_S,
      riscv_instr::VFLT_S,
      riscv_instr::VFLT_R_S,
      riscv_instr::VFGE_S,
      riscv_instr::VFGE_R_S,
      riscv_instr::VFLE_S,
      riscv_instr::VFLE_R_S,
      riscv_instr::VFGT_S,
      riscv_instr::VFGT_R_S,
      riscv_instr::VFCLASS_S,
      riscv_instr::FLE_D,
      riscv_instr::FLT_D,
      riscv_instr::FEQ_D,
      riscv_instr::FCLASS_D,
      riscv_instr::FCVT_W_D,
      riscv_instr::FCVT_WU_D,
      riscv_instr::FMV_X_D,
      riscv_instr::FLE_H,
      riscv_instr::FLT_H,
      riscv_instr::FEQ_H,
      riscv_instr::FCLASS_H,
      riscv_instr::FCVT_W_H,
      riscv_instr::FCVT_WU_H,
      riscv_instr::FMV_X_H,
      riscv_instr::VFEQ_H,
      riscv_instr::VFEQ_R_H,
      riscv_instr::VFNE_H,
      riscv_instr::VFNE_R_H,
      riscv_instr::VFLT_H,
      riscv_instr::VFLT_R_H,
      riscv_instr::VFGE_H,
      riscv_instr::VFGE_R_H,
      riscv_instr::VFLE_H,
      riscv_instr::VFLE_R_H,
      riscv_instr::VFGT_H,
      riscv_instr::VFGT_R_H,
      riscv_instr::VFCLASS_H,
      riscv_instr::VFMV_X_H,
      riscv_instr::VFCVT_X_H,
      riscv_instr::VFCVT_XU_H,
      riscv_instr::FLE_AH,
      riscv_instr::FLT_AH,
      riscv_instr::FEQ_AH,
      riscv_instr::FCLASS_AH,
      riscv_instr::FMV_X_AH,
      riscv_instr::VFEQ_AH,
      riscv_instr::VFEQ_R_AH,
      riscv_instr::VFNE_AH,
      riscv_instr::VFNE_R_AH,
      riscv_instr::VFLT_AH,
      riscv_instr::VFLT_R_AH,
      riscv_instr::VFGE_AH,
      riscv_instr::VFGE_R_AH,
      riscv_instr::VFLE_AH,
      riscv_instr::VFLE_R_AH,
      riscv_instr::VFGT_AH,
      riscv_instr::VFGT_R_AH,
      riscv_instr::VFCLASS_AH,
      riscv_instr::VFMV_X_AH,
      riscv_instr::VFCVT_X_AH,
      riscv_instr::VFCVT_XU_AH,
      riscv_instr::FLE_B,
      riscv_instr::FLT_B,
      riscv_instr::FEQ_B,
      riscv_instr::FCLASS_B,
      riscv_instr::FCVT_W_B,
      riscv_instr::FCVT_WU_B,
      riscv_instr::FMV_X_B,
      riscv_instr::VFEQ_B,
      riscv_instr::VFEQ_R_B,
      riscv_instr::VFNE_B,
      riscv_instr::VFNE_R_B,
      riscv_instr::VFLT_B,
      riscv_instr::VFLT_R_B,
      riscv_instr::VFGE_B,
      riscv_instr::VFGE_R_B,
      riscv_instr::VFLE_B,
      riscv_instr::VFLE_R_B,
      riscv_instr::VFGT_B,
      riscv_instr::VFGT_R_B,
      riscv_instr::VFCLASS_B,
      riscv_instr::VFMV_X_B,
      riscv_instr::VFCVT_X_B,
      riscv_instr::VFCVT_XU_B,

      // int to float
      riscv_instr::FMV_W_X,
      riscv_instr::FCVT_S_W,
      riscv_instr::FCVT_S_WU,
      riscv_instr::FCVT_D_W,
      riscv_instr::FCVT_D_WU,
      riscv_instr::FMV_H_X,
      riscv_instr::FCVT_H_W,
      riscv_instr::FCVT_H_WU,
      riscv_instr::VFMV_H_X,
      riscv_instr::VFCVT_H_X,
      riscv_instr::VFCVT_H_XU,
      riscv_instr::FMV_AH_X,
      riscv_instr::VFMV_AH_X,
      riscv_instr::VFCVT_AH_X,
      riscv_instr::VFCVT_AH_XU,
      riscv_instr::FMV_B_X,
      riscv_instr::FCVT_B_W,
      riscv_instr::FCVT_B_WU,
      riscv_instr::VFMV_B_X,
      riscv_instr::VFCVT_B_X,
      riscv_instr::VFCVT_B_XU,
      riscv_instr::IMV_X_W,
      riscv_instr::IMV_W_X,

      // CSR accesses
      riscv_instr::CSRRW,
      riscv_instr::CSRRS,
      riscv_instr::CSRRC,
      riscv_instr::CSRRWI,
      riscv_instr::CSRRSI,
      riscv_instr::CSRRCI: begin
        inst_path_sel = Direct;
      end

      // All other instructions have to be buffered
      default: begin
        inst_path_sel = Buffer;
      end
    endcase
  end

  /////////////////
  // Input demux //
  /////////////////

  logic core_rb_valid, core_rb_ready;
  logic core_frep_valid, core_frep_ready;
  logic core_direct_valid, core_direct_ready;

  stream_demux #(
    .N_OUP(3)
  ) i_input_demux (
    .inp_valid_i(inp_qvalid_i),
    .inp_ready_o(inp_qready_o),
    .oup_sel_i(inst_path_sel),
    .oup_valid_o({core_frep_valid, core_direct_valid, core_rb_valid}),
    .oup_ready_i({core_frep_ready, core_direct_ready, core_rb_ready})
  );

  ////////////////
  // Nest state //
  ////////////////

  loop_cfg_t [NestDepth-1:0] nest_cfg_d, nest_cfg_q;
  `FFAR(nest_cfg_q, nest_cfg_d, '0, clk_i, rst_i);

  logic loop_active_d, loop_active_q;
  `FFAR(loop_active_q, loop_active_d, '0, clk_i, rst_i);

  loop_idx_t loop_idx_d, loop_idx_q;
  loop_cnt_t loop_cnt_d, loop_cnt_q;
  `FFAR(loop_idx_q, loop_idx_d, '0, clk_i, rst_i);
  `FFAR(loop_cnt_q, loop_cnt_d, '0, clk_i, rst_i);

  logic [DepthBits-1:0] rd_pointer_d, rd_pointer_q;
  `FFAR(rd_pointer_q, rd_pointer_d, '0, clk_i, rst_i)

  logic [2:0] stagger_cnt_q, stagger_cnt_d;
  `FFAR(stagger_cnt_q, stagger_cnt_d, '0, clk_i, rst_i)

  logic received_all_nest_insns_q, received_all_nest_insns_d;
  `FFAR(received_all_nest_insns_q, received_all_nest_insns_d, 1'b0, clk_i, rst_i);

  /////////////////
  // Ring buffer //
  /////////////////

  rb_entry_t rb_rdata;
  rb_entry_t rb_wdata;

  assign rb_wdata = '{
    qdata_op: inp_qdata_op_i,
    qdata_argc: inp_qdata_argc_i
  };

  ring_buffer #(
    .Depth(BufferDepth),
    .data_t(rb_entry_t)
  ) i_ring_buffer (
    .clk_i(clk_i),
    .rst_ni(~rst_i),
    .wvalid_i(core_rb_valid),
    .wready_o(core_rb_ready),
    .wdata_i(rb_wdata),
    .rvalid_i(rb_rvalid),
    .rready_o(rb_rready),
    .raddr_i(rb_raddr),
    .rdata_o(rb_rdata),
    .advance_i(rb_advance),
    .step_i(rb_step),
    .wptr_o(rb_wptr),
    .rptr_o(),
    .full_o(),
    .empty_o(rb_empty)
  );

  //////////////////////
  // Loop controllers //
  //////////////////////

  logic [NestDepth-1:0][LoopIterBits-1:0] iter_cnt;

  for (genvar i = 0; i < NestDepth; i++) begin : gen_loop_controllers

    logic incr_iter;

    trip_counter #(
      .WIDTH(DepthBits)
    ) i_inst_counter (
      .clk_i(clk_i),
      .rst_ni(~rst_i),
      .en_i(incr_inst[i]),
      .delta_i(DepthBits'(1)),
      .bound_i(nest_cfg_q[i].max_inst),
      .q_o(),
      .last_o(last_inst[i]),
      .trip_o(incr_iter)
    );

    trip_counter #(
      .WIDTH(LoopIterBits)
    ) i_iter_counter (
      .clk_i(clk_i),
      .rst_ni(~rst_i),
      .en_i(incr_iter),
      .delta_i(LoopIterBits'(1)),
      .bound_i(nest_cfg_q[i].max_iter),
      .q_o(iter_cnt[i]),
      .last_o(last_iter[i]),
      .trip_o()
    );
  end

  /////////////////////
  // Nest controller //
  /////////////////////

  logic seq_next;
  logic nest_ends;

  //--- FREP handshaking logic ---

  // An FREP can only be accepted if no loop nest is currently configured, or if it
  // is nested within the current loop nest. The latter means checking if the write
  // pointer is within the outermost loop bounds. But the write pointer can wrap to
  // the start of the loop, so we also need to track if we've already received all
  // instructions. And this involves comparing the write pointer to the end pointer,
  // when writing a loop nest instruction. The first instructions following an FREP,
  // i.e. received while loop_cnt_q > 0, are guaranteed to be within the loop nest.

  logic rb_wptr_within_bounds;
  logic [DepthBits-1:0] nest_start_pointer, nest_end_pointer;

  always_comb begin : proc_frep_handshake
    received_all_nest_insns_d = received_all_nest_insns_q;
    nest_start_pointer = nest_cfg_q[0].base_pointer;
    nest_end_pointer = nest_cfg_q[0].base_pointer + nest_cfg_q[0].max_inst;

    if ((loop_cnt_q > 0) && (rb_wptr == nest_end_pointer) && (core_rb_valid && core_rb_ready)) begin
      received_all_nest_insns_d = 1'b1;
    end else if (nest_ends) begin
      received_all_nest_insns_d = 1'b0;
    end

    if (nest_start_pointer <= nest_end_pointer) begin
      rb_wptr_within_bounds = (rb_wptr >= nest_start_pointer) && (rb_wptr <= nest_end_pointer);
    end else begin
      rb_wptr_within_bounds = (rb_wptr >= nest_start_pointer) || (rb_wptr <= nest_end_pointer);
    end

    core_frep_ready = (loop_cnt_q == 0) || (!received_all_nest_insns_q && rb_wptr_within_bounds);
  end

  //--- Nest configuration update logic ---

  always_comb begin : proc_update_config
    nest_cfg_d = nest_cfg_q;
    loop_cnt_d = loop_cnt_q;

    if (nest_ends) begin
      loop_cnt_d = 0;
    end

    if (core_frep_valid && core_frep_ready) begin
      nest_cfg_d[loop_cnt_d].is_streamctl = inp_qdata_op_i[31];
      nest_cfg_d[loop_cnt_d].max_inst = inp_qdata_op_i[20+:DepthBits];
      nest_cfg_d[loop_cnt_d].stagger_max = inp_qdata_op_i[14:12];
      nest_cfg_d[loop_cnt_d].stagger_mask = inp_qdata_op_i[11:8];
      nest_cfg_d[loop_cnt_d].max_iter = inp_qdata_arga_i[LoopIterBits-1:0];
      nest_cfg_d[loop_cnt_d].base_pointer = rb_wptr;

      loop_cnt_d = loop_cnt_q + 1;
    end
  end

  //--- Inner loops in last iteration detector ---

  // Instructions in inner loop bodies may be repeated multiple times, but must
  // be counted only once by the outer loop instruction counter. Specifically,
  // we count them when they are last issued, i.e. when all loops between the
  // one containing the current instruction (loop_idx_q) and the outer loop (i)
  // are in their last iteration.

  logic [NestDepth-1:0] last_iter_inner_loops;

  for (genvar i = 0; i < NestDepth; i++) begin : gen_last_iter_inner_loops_detector

    logic [NestDepth-1:0] last_iter_inner_loops_mask;

    // Mask to select only the loops which need to be considered
    // to find the innermost loop starting at the next instruction,
    // That is all loops j, with i < j <= loop_idx_q.
    boxcar #(.Width(NestDepth)) i_last_iter_inner_loops_mask (
      .lsb_i (loop_idx_t'(i)),
      .msb_i (loop_idx_q),
      .mask_o(last_iter_inner_loops_mask)
    );

    assign last_iter_inner_loops[i] = &(last_iter | ~last_iter_inner_loops_mask);
    assign incr_inst[i] = loop_active_q && seq_next
      && (((i == loop_idx_q) && (i < loop_cnt_q))
      || ((loop_idx_q > i) && last_iter_inner_loops[i]));
  end

  //--- Starting loops detector ---

  logic [NestDepth-1:0] inst_starts_loop;
  logic [NestDepth-1:0] inst_starts_mask;
  logic no_loop_starts;
  loop_idx_t lzc_cnt;
  loop_idx_t starting_loop_idx;

  // Check if a loop starts at the next instruction.
  // We look at the `nest_cfg_d` signal, to update `loop_active_q` as early as
  // possible, i.e. right after receiving an FREP.
  for (genvar i = 0; i < NestDepth; i++) begin : gen_starting_loops_detector
    assign inst_starts_loop[i] = (rd_pointer_d == nest_cfg_d[i].base_pointer);
  end

  // Mask to select only the loops which need to be considered
  // to find the innermost loop starting at the next instruction,
  // That is all loops i, with loop_idx_q < i < loop_cnt_d.
  // We use the `loop_cnt_d` signal here, as we want to update `loop_idx_q`
  // right after receiving a nested FREP.
  boxcar #(.Width(NestDepth)) i_inst_starts_mask (
    .lsb_i (loop_idx_q),
    .msb_i (loop_idx_t'(loop_cnt_d - 1)),
    .mask_o(inst_starts_mask)
  );

  // Find the innermost loop starting at the next instruction.
  lzc #(
    .WIDTH(NestDepth),
    .MODE(1)
  ) i_loop_start_lzc (
    .in_i(inst_starts_mask & inst_starts_loop),
    .cnt_o(lzc_cnt),
    .empty_o(no_loop_starts)
  );
  assign starting_loop_idx = NestDepth - lzc_cnt - 1;

  //--- Ending loops detector ---

  loop_idx_t innermost_non_ending_loop;
  loop_idx_t outermost_ending_loop;
  logic [NestDepth-1:0] loop_ends;
  logic [NestDepth-1:0] loop_active;
  logic no_loop_ends;

  // Mask to select only loops which end on current instruction
  assign loop_ends = last_inst & last_iter & last_iter_inner_loops;

  // Mask to select active loops only
  heaviside #(.Width(NestDepth)) i_loop_active_mask (
    .x_i(loop_idx_q),
    .mask_o(loop_active)
  );

  // Compute the innermost active loop which does not end with the current instruction,
  // using a trailing zero counter.
  lzc #(
    .WIDTH(NestDepth),
    .MODE(0)
  ) i_loop_end_tzc (
    .in_i(loop_ends & loop_active),
    .cnt_o(outermost_ending_loop),
    .empty_o(no_loop_ends)
  );
  assign innermost_non_ending_loop = no_loop_ends ? loop_idx_q : outermost_ending_loop - 1;

  //--- Read pointer update logic ---

  always_comb begin : proc_update_rd_pointer
    rd_pointer_d = rd_pointer_q;

    // Update read pointer into the ring buffer
    if (seq_next) begin
      rd_pointer_d = rd_pointer_q + 1;
      // We must reset the read pointer to the base pointer of the
      // innermost non-ending loop if we are at the last instruction
      // of that loop and not at the end of the loop nest.
      if (loop_active_q) begin
        if (!nest_ends && last_inst[innermost_non_ending_loop]) begin
          rd_pointer_d = nest_cfg_q[innermost_non_ending_loop].base_pointer;
        end
      end
    end
  end

  //--- Loop index update logic ---

  // Loop index update
  always_comb begin : proc_update_loop_idx
    loop_idx_d = loop_idx_q;
    loop_active_d = loop_active_q;
    nest_ends = 1'b0;

    // Update frep active flag
    if (loop_cnt_d > 0 && inst_starts_loop[0]) begin
      loop_active_d = 1'b1;
    end

    // When we complete an inner loop we must update the active loop index to
    // the innermost non-ending loop, if any, i.e. if the outermost loop is not
    // ending. In the latter case, the loop nest is done so we reset its state.
    if (loop_active_q && seq_next && !no_loop_ends) begin
      if (outermost_ending_loop != 0) begin
        loop_idx_d = innermost_non_ending_loop;
      end else begin
        loop_idx_d = '0;
        nest_ends = 1'b1;
        loop_active_d = 1'b0;
      end
    end
    // When a loop starts with the next instruction we must update the
    // active loop index to the innermost starting loop.
    // An inner loop cannot start in correspondence with the end of a loop,
    // so this need only be checked when no loop ends.
    // This check would anyways be invalid when `nest_ends`, as
    // `loop_cnt_d - 1` would underflow.
    else if (loop_active_q && !no_loop_starts) begin
      loop_idx_d = starting_loop_idx;
    end
  end

  //--- Staggering counter update logic ---

  // Note: staggering is only supported in the innermost loop.
  // Any use of staggering in outer loops should be avoided in software,
  // and otherwise results in undefined behaviour.
  always_comb begin : proc_update_stagger_cnt
    stagger_cnt_d = stagger_cnt_q;
    if (loop_active_q && loop_idx_q == (loop_cnt_q - 1) && seq_next) begin
      if (nest_ends) begin
        stagger_cnt_d = '0;
      end else if (seq_next) begin
        if (last_inst[loop_idx_q]) begin
          stagger_cnt_d = last_iter[loop_idx_q] ? 0 :
            ((stagger_cnt_q == nest_cfg_q[loop_idx_q].stagger_max) ? 0 : stagger_cnt_q + 1);
        end
      end
    end
  end

  //--- Ring buffer request ---

  assign rb_rvalid = 1'b1;
  assign rb_raddr = rd_pointer_q;
  assign rb_advance = loop_active_q ? nest_ends : seq_next;
  assign rb_step = loop_active_q ? nest_cfg_q[0].max_inst + 1 : 1;

  //--- Stream control and output handshake interface ---

  logic stream_done;

  always_comb begin : proc_streamctl
    seq_out_valid     = rb_rready;
    stream_done       = 1'b0;
    streamctl_ready_o = 1'b0;
    if ((loop_cnt_q > 0) && nest_cfg_q[loop_idx_q].is_streamctl) begin
      seq_out_valid     = rb_rready && streamctl_valid_i && !streamctl_done_i;
      stream_done       = rb_rready && streamctl_valid_i && streamctl_done_i;
      streamctl_ready_o = (rb_rready && seq_out_ready) || stream_done;
    end
  end

  assign seq_next = seq_out_valid & seq_out_ready;

  //--- Compose output instruction ---

  logic [31:0] seq_qdata_op;

  always_comb begin : proc_compose_output_insn
    seq_qdata_op   = rb_rdata.qdata_op;
    if (nest_cfg_q[loop_idx_q].stagger_mask[0]) seq_qdata_op[11:7] += stagger_cnt_q;
    if (nest_cfg_q[loop_idx_q].stagger_mask[1]) seq_qdata_op[19:15] += stagger_cnt_q;
    if (nest_cfg_q[loop_idx_q].stagger_mask[2]) seq_qdata_op[24:20] += stagger_cnt_q;
    if (nest_cfg_q[loop_idx_q].stagger_mask[3]) seq_qdata_op[31:27] += stagger_cnt_q;
  end

  assign seq_out_data = '{
    qaddr:      DstAddr,
    qid:        '0,
    qdata_op:   seq_qdata_op,
    qdata_arga: '0,
    qdata_argb: '0,
    qdata_argc: $unsigned(rb_rdata.qdata_argc),
    // When we repeat a previously issued instruction, communicate this
    // to subsystem (e.g. for single issuing of CAQ responses).
    qdata_repd: (iter_cnt[loop_idx_q] != 0)
  };

  ////////////////
  // Output mux //
  ////////////////

  oup_data_t core_direct_data, oup_data;

  assign core_direct_data = '{
    qaddr:      inp_qaddr_i,
    qid:        inp_qid_i,
    qdata_op:   inp_qdata_op_i,
    qdata_arga: inp_qdata_arga_i,
    qdata_argb: inp_qdata_argb_i,
    qdata_argc: inp_qdata_argc_i,
    qdata_repd: 1'b0
  };

  // Select direct path iff ring buffer is empty
  stream_mux #(
    .DATA_T(oup_data_t),
    .N_INP(2)
  ) i_output_mux (
    .inp_data_i({core_direct_data, seq_out_data}),
    .inp_valid_i({core_direct_valid, seq_out_valid}),
    .inp_ready_o({core_direct_ready, seq_out_ready}),
    .inp_sel_i(!rb_rready),
    .oup_data_o(oup_data),
    .oup_valid_o(oup_qvalid_o),
    .oup_ready_i(oup_qready_i)
  );

  assign oup_qaddr_o      = oup_data.qaddr;
  assign oup_qid_o        = oup_data.qid;
  assign oup_qdata_op_o   = oup_data.qdata_op;
  assign oup_qdata_arga_o = oup_data.qdata_arga;
  assign oup_qdata_argb_o = oup_data.qdata_argb;
  assign oup_qdata_argc_o = oup_data.qdata_argc;
  assign oup_qdata_repd_o = oup_data.qdata_repd;

  ////////////
  // Tracer //
  ////////////

  // pragma translate_off
  assign trace_port_o.source    = snitch_pkg::SrcFpuSeq;
  assign trace_port_o.cbuf_push = core_frep_valid && core_frep_ready;
  assign trace_port_o.max_inst  = inp_qdata_op_i[20+:DepthBits];
  assign trace_port_o.max_iter  = inp_qdata_arga_i[LoopIterBits-1:0];
  assign trace_port_o.stg_max   = inp_qdata_op_i[14:12];
  assign trace_port_o.stg_mask  = inp_qdata_op_i[11:8];
  // pragma translate_on

  ////////////////
  // Assertions //
  ////////////////

  // Ensure that `max_inst` bits fit into assigned slot
  `ASSERT_INIT(CheckMaxInstFieldWidth, DepthBits < 11);

  // Ensure that we never exceed the number of supported nested FREP loops.
  `ASSERT_IF(
    LoopCountOverflow, !(core_frep_valid && core_frep_ready),
    loop_cnt_q == NestDepth, clk_i, rst_i,
    $sformatf("cannot increment loop_cnt_q beyond supported NestDepth (%0d)", NestDepth)
  )

  // Ensure that innermost non ending loop index is within bounds.
  // If there is only one loop, and this loop ends, then there is no non-ending loop,
  // so we disable the check.
  `ASSERT_IF(
    InvalidInnermostNonEndingLoop, innermost_non_ending_loop < loop_cnt_q,
    loop_active_q && (loop_cnt_q > 1 || !loop_ends[0]), clk_i, rst_i,
    "innermost non ending loop exceeds configured nest bound"
  );

  // Ensure that outermost ending loop index is within bounds.
  `ASSERT_IF(
    InvalidOutermostEndingLoop, outermost_ending_loop < loop_cnt_q, loop_active_q && !no_loop_ends,
    clk_i, rst_i, "outermost ending loop exceeds configured nest bound"
  );

  // Ensure that the active loop index is within bounds.
  `ASSERT_IF(
    InvalidLoopIdx, loop_idx_q < loop_cnt_q, loop_active_q,
    clk_i, rst_i, "active loop index exceeds configured nest bound"
  );

  // Ensure that no handshake occurs on the direct path if an FREP loop is active.
  `ASSERT_IF(
    DirectPathHSDuringFrep, !(core_direct_valid && core_direct_ready), loop_active_q,
    clk_i, rst_i, "handshake on direct path occured while FREP loop is active"
  );

  // Ensure that no handshake occurs on the direct path if the ring buffer is not empty.
  `ASSERT_IF(
    DirectPathHSRingBufferNotEmpty, !(core_direct_valid && core_direct_ready), !rb_empty,
    clk_i, rst_i, "handshake on direct path occured while ring buffer is not empty"
  );

endmodule
