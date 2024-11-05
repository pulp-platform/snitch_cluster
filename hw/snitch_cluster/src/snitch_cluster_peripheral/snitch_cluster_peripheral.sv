// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Exposes cluster confugration and information as memory mapped information

`include "common_cells/registers.svh"

module snitch_cluster_peripheral
  import snitch_pkg::*;
  import snitch_icache_pkg::*;
  import snitch_cluster_peripheral_reg_pkg::*;
#(
  // Nr of cores in the cluster
  parameter int unsigned NrCores = 0,
  // Nr of DMA channels
  parameter int unsigned DMANumChannels = 0,
  parameter int unsigned DMADataWidth = 0,
  parameter type reg_req_t = logic,
  parameter type reg_rsp_t = logic,
  parameter type tcdm_events_t = logic,
  parameter type dma_events_t = logic
) (
  input  logic                       clk_i,
  input  logic                       rst_ni,

  input  reg_req_t                   reg_req_i,
  output reg_rsp_t                   reg_rsp_o,

  output logic                       icache_prefetch_enable_o,
  output logic [NrCores-1:0]         cl_clint_o,
  input  core_events_t [NrCores-1:0]                      core_events_i,
  input  tcdm_events_t                                    tcdm_events_i,
  input  dma_events_t [DMANumChannels-1:0]                dma_events_i,
  input  icache_l0_events_t [NrCores-1:0] icache_events_i
);

  // Pipeline register to ease timing.
  tcdm_events_t tcdm_events_q;
  dma_events_t [DMANumChannels-1:0] dma_events_q;
  icache_l0_events_t [NrCores-1:0] icache_events_q;
  `FF(tcdm_events_q, tcdm_events_i, '0)
  `FF(dma_events_q, dma_events_i, '0)
  `FF(icache_events_q, icache_events_i, '0)

  snitch_cluster_peripheral_reg2hw_t reg2hw;
  snitch_cluster_peripheral_hw2reg_t hw2reg;

  snitch_cluster_peripheral_reg_top #(
    .reg_req_t (reg_req_t),
    .reg_rsp_t (reg_rsp_t)
  ) i_snitch_cluster_peripheral_reg_top (
    .clk_i (clk_i),
    .rst_ni (rst_ni),
    .reg_req_i (reg_req_i),
    .reg_rsp_o (reg_rsp_o),
    .devmode_i (1'b0),
    .reg2hw (reg2hw),
    .hw2reg (hw2reg)
  );

  // As defined in the `.hjson` file. Unfortunately,
  // The regtool does not generate enums for SV,
  // only for C. So we have to define them here.
  typedef enum logic[4:0] {
    Cycle           = 5'd0,
    TcdmAccessed    = 5'd1,
    TcdmCongested   = 5'd2,
    IssueFpu        = 5'd3,
    IssueFpuSeq     = 5'd4,
    IssueCoreToFpu  = 5'd5,
    RetiredInstr    = 5'd6,
    RetiredLoad     = 5'd7,
    RetiredI        = 5'd8,
    RetiredAcc      = 5'd9,
    DmaAwStall      = 5'd10,
    DmaArStall      = 5'd11,
    DmaRStall       = 5'd12,
    DmaWStall       = 5'd13,
    DmaBufWStall    = 5'd14,
    DmaBufRStall    = 5'd15,
    DmaAwDone       = 5'd16,
    DmaAwBw         = 5'd17,
    DmaArDone       = 5'd18,
    DmaArBw         = 5'd19,
    DmaRDone        = 5'd20,
    DmaRBw          = 5'd21,
    DmaWDone        = 5'd22,
    DmaWBw          = 5'd23,
    DmaBDone        = 5'd24,
    DmaBusy         = 5'd25,
    IcacheMiss      = 5'd26,
    IcacheHit       = 5'd27,
    IcachePrefetch  = 5'd28,
    IcacheDoubleHit = 5'd29,
    IcacheStall     = 5'd30,
    NumMetrics      = 5'd31
  } perf_metrics_e;

  // The metrics that should be tracked immediately after reset.
  localparam int unsigned NumPerfMetricRstValues = 7;
  localparam perf_metrics_e PerfMetricRstValues[NumPerfMetricRstValues] = '{
    Cycle,
    RetiredInstr,
    TcdmAccessed,
    IcacheMiss,
    IcacheHit,
    IcachePrefetch,
    IcacheStall
  };

  logic [NumPerfCounters-1:0][47:0] perf_cnt_q, perf_cnt_d;
  perf_metrics_e [NumPerfCounters-1:0] perf_metrics_q, perf_metrics_d;
  logic [NumPerfCounters-1:0][$clog2(NrCores)-1:0] perf_hart_sel_q, perf_hart_sel_d;
  logic [31:0] cl_clint_d, cl_clint_q;

  // Wake-up logic: Bits in cl_clint_q can be set/cleared with writes to
  // cl_clint_set/cl_clint_clear
  always_comb begin
    cl_clint_d = cl_clint_q;
    if (reg2hw.cl_clint_set.qe) begin
      cl_clint_d = cl_clint_q | reg2hw.cl_clint_set.q;
    end else if (reg2hw.cl_clint_clear.qe) begin
      cl_clint_d = cl_clint_q & ~reg2hw.cl_clint_clear.q;
    end
  end
  `FF(cl_clint_q, cl_clint_d, '0, clk_i, rst_ni)
  assign cl_clint_o = cl_clint_q[NrCores-1:0];

  // Enable icache prefetch
  assign icache_prefetch_enable_o = reg2hw.icache_prefetch_enable.q;

  // Continuously assign the perf values.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_assign
    assign hw2reg.perf_cnt[i].d = perf_cnt_q[i];
    assign hw2reg.perf_cnt_sel[i].metric.d = perf_metrics_q[i];
    assign hw2reg.perf_cnt_sel[i].hart.d = perf_hart_sel_q[i];
  end

  always_comb begin
    perf_cnt_d = perf_cnt_q;
    perf_metrics_d = perf_metrics_q;
    perf_hart_sel_d = perf_hart_sel_q;
    for (int i = 0; i < NumPerfCounters; i++) begin
      automatic core_events_t sel_core_events;
      automatic dma_events_t sel_dma_events;
      automatic logic [$clog2(NrCores)-1:0] hart_select;
      hart_select = perf_hart_sel_q[i][$clog2(NrCores)-1:0];
      sel_core_events = core_events_i[hart_select];
      sel_dma_events = dma_events_q[hart_select];
      unique case (perf_metrics_q[i])
        Cycle: perf_cnt_d[i] += 1;
        TcdmAccessed: perf_cnt_d[i] += tcdm_events_q.inc_accessed;
        TcdmCongested: perf_cnt_d[i] += tcdm_events_q.inc_congested;
        IssueFpu: perf_cnt_d[i] += sel_core_events.issue_fpu;
        IssueFpuSeq: perf_cnt_d[i] += sel_core_events.issue_fpu_seq;
        IssueCoreToFpu: perf_cnt_d[i] += sel_core_events.issue_core_to_fpu;
        RetiredInstr: perf_cnt_d[i] += sel_core_events.retired_instr;
        RetiredLoad: perf_cnt_d[i] += sel_core_events.retired_load;
        RetiredI: perf_cnt_d[i] += sel_core_events.retired_i;
        RetiredAcc: perf_cnt_d[i] += sel_core_events.retired_acc;
        DmaAwStall: perf_cnt_d[i] += sel_dma_events.aw_stall;
        DmaArStall: perf_cnt_d[i] += sel_dma_events.ar_stall;
        DmaRStall: perf_cnt_d[i] += sel_dma_events.r_stall;
        DmaWStall: perf_cnt_d[i] += sel_dma_events.w_stall;
        DmaBufWStall: perf_cnt_d[i] += sel_dma_events.buf_w_stall;
        DmaBufRStall: perf_cnt_d[i] += sel_dma_events.buf_r_stall;
        DmaAwDone: perf_cnt_d[i] += sel_dma_events.aw_done;
        DmaAwBw: perf_cnt_d[i] += ((sel_dma_events.aw_len + 1) << (sel_dma_events.aw_size));
        DmaArDone: perf_cnt_d[i] += sel_dma_events.ar_done;
        DmaArBw: perf_cnt_d[i] += ((sel_dma_events.ar_len + 1) << (sel_dma_events.ar_size));
        DmaRDone: perf_cnt_d[i] += sel_dma_events.r_done;
        DmaRBw: perf_cnt_d[i] += DMADataWidth/8;
        DmaWDone: perf_cnt_d[i] += sel_dma_events.w_done;
        DmaWBw: perf_cnt_d[i] += sel_dma_events.num_bytes_written;
        DmaBDone: perf_cnt_d[i] += sel_dma_events.b_done;
        DmaBusy: perf_cnt_d[i] += sel_dma_events.dma_busy;
        IcacheMiss: perf_cnt_d[i] += icache_events_q[hart_select].l0_miss;
        IcacheHit: perf_cnt_d[i] += icache_events_q[hart_select].l0_hit;
        IcachePrefetch: perf_cnt_d[i] += icache_events_q[hart_select].l0_prefetch;
        IcacheDoubleHit: perf_cnt_d[i] += icache_events_q[hart_select].l0_double_hit;
        IcacheStall: perf_cnt_d[i] += icache_events_q[hart_select].l0_stall;
        default:;
      endcase
      // Set performance metric.
      if (reg2hw.perf_cnt_sel[i].metric.qe) begin
        perf_metrics_d[i] = perf_metrics_e'(reg2hw.perf_cnt_sel[i].metric.q);
      end
      // Set hart select.
      if (reg2hw.perf_cnt_sel[i].hart.qe) begin
        perf_hart_sel_d[i] = reg2hw.perf_cnt_sel[i].hart.q;
      end
    end
  end

  // Performance counter FFs.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_cnt
    `FFLARNC(perf_cnt_q[i], perf_cnt_d[i],
             reg2hw.perf_cnt_en[i], reg2hw.perf_cnt[i].qe, '0, clk_i, rst_ni)
  end

  // Set reset values for the metrics that should be tracked immediately after reset.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_metrics_assign
    if (i < NumPerfMetricRstValues) begin : gen_perf_metrics_rst_value
      `FF(perf_metrics_q[i], perf_metrics_d[i], PerfMetricRstValues[i], clk_i, rst_ni)
    end else begin : gen_perf_metrics_default
      `FF(perf_metrics_q[i], perf_metrics_d[i], Cycle, clk_i, rst_ni)
    end
  end

  // Use hart `0` as default.
  `FF(perf_hart_sel_q, perf_hart_sel_d, 0, clk_i, rst_ni)

endmodule
