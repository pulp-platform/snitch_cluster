// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Exposes cluster confugration and information as memory mapped information

`include "common_cells/registers.svh"

module snitch_cluster_peripheral
  import snitch_pkg::*;
  import snitch_cluster_peripheral_reg_pkg::*;
#(
  parameter int unsigned AddrWidth = 0,
  parameter int unsigned DMADataWidth = 0,
  parameter type reg_req_t = logic,
  parameter type reg_rsp_t = logic,
  parameter type         tcdm_events_t = logic,
  parameter type         dma_events_t = logic,
  // Nr of course in the cluster
  parameter logic [31:0] NrCores       = 0,
  /// Derived parameter *Do not override*
  parameter type addr_t = logic [AddrWidth-1:0]
) (
  input  logic                       clk_i,
  input  logic                       rst_ni,

  input  reg_req_t                   reg_req_i,
  output reg_rsp_t                   reg_rsp_o,

  output logic                       icache_prefetch_enable_o,
  output logic [NrCores-1:0]         cl_clint_o,
  input  logic [9:0]                 cluster_hart_base_id_i,
  input  core_events_t [NrCores-1:0] core_events_i,
  input  tcdm_events_t               tcdm_events_i,
  input  dma_events_t                dma_events_i,
  input  snitch_icache_pkg::icache_events_t [NrCores-1:0] icache_events_i
);

  // Pipeline register to ease timing.
  tcdm_events_t tcdm_events_q;
  dma_events_t dma_events_q;
  snitch_icache_pkg::icache_events_t [NrCores-1:0] icache_events_q;
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

  // As defined in the `.hjson` file. Unforunately,
  // The regtool does not generate enums for SV,
  // only for C. So we have to define them here.
  typedef enum logic[9:0] {
    Cycle           = 10'd0,
    TcdmAccessed    = 10'd1,
    TcdmCongested   = 10'd2,
    IssueFpu        = 10'd3,
    IssueFpuSeq     = 10'd4,
    IssueCoreToFpu  = 10'd5,
    RetiredInstr    = 10'd6,
    RetiredLoad     = 10'd7,
    RetiredI        = 10'd8,
    RetiredAcc      = 10'd9,
    DmaAwStall      = 10'd10,
    DmaArStall      = 10'd11,
    DmaRStall       = 10'd12,
    DmaWStall       = 10'd13,
    DmaBufWStall    = 10'd14,
    DmaBufRStall    = 10'd15,
    DmaAwDone       = 10'd16,
    DmaAwBw         = 10'd17,
    DmaArDone       = 10'd18,
    DmaArBw         = 10'd19,
    DmaRDone        = 10'd20,
    DmaRBw          = 10'd21,
    DmaWDone        = 10'd22,
    DmaWBw          = 10'd23,
    DmaBDone        = 10'd24,
    DmaBusy         = 10'd25,
    IcacheMiss      = 10'd26,
    IcacheHit       = 10'd27,
    IcachePrefetch  = 10'd28,
    IcacheDoubleHit = 10'd29,
    IcacheStall     = 10'd30,
    NumMetrics      = 10'd31
  } perf_metrics_e;

  // The metrics that should be tracked immediately after reset.
  // TODO: Choose reasonable metrics.
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

  // The hardware barrier is external and always reads `0`.
  assign hw2reg.hw_barrier.d = 0;

  always_comb begin
    perf_metrics_d = perf_metrics_q;
    perf_hart_sel_d = perf_hart_sel_q;
    for (int i = 0; i < NumPerfCounters; i++) begin
      automatic core_events_t sel_core_events;
      automatic logic [$clog2(NrCores)-1:0] hart_select;
      hart_select = reg2hw.perf_cnt_sel[i].hart.q[$clog2(NrCores):0];
      sel_core_events = core_events_i[hart_select];
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
        DmaAwStall: perf_cnt_d[i] += dma_events_q.aw_stall;
        DmaArStall: perf_cnt_d[i] += dma_events_q.ar_stall;
        DmaRStall: perf_cnt_d[i] += dma_events_q.r_stall;
        DmaWStall: perf_cnt_d[i] += dma_events_q.w_stall;
        DmaBufWStall: perf_cnt_d[i] += dma_events_q.buf_w_stall;
        DmaBufRStall: perf_cnt_d[i] += dma_events_q.buf_r_stall;
        DmaAwDone: perf_cnt_d[i] += dma_events_q.aw_done;
        DmaAwBw: perf_cnt_d[i] += ((dma_events_q.aw_len + 1) << (dma_events_q.aw_size));
        DmaArDone: perf_cnt_d[i] += dma_events_q.ar_done;
        DmaArBw: perf_cnt_d[i] += ((dma_events_q.ar_len + 1) << (dma_events_q.ar_size));
        DmaRDone: perf_cnt_d[i] += dma_events_q.r_done;
        DmaRBw: perf_cnt_d[i] += DMADataWidth/8;
        DmaWDone: perf_cnt_d[i] += dma_events_q.w_done;
        DmaWBw: perf_cnt_d[i] += dma_events_q.num_bytes_written;
        DmaBDone: perf_cnt_d[i] += dma_events_q.b_done;
        DmaBusy: perf_cnt_d[i] += dma_events_q.dma_busy;
        IcacheMiss: perf_cnt_d[i] += icache_events_q[hart_select].l0_miss;
        IcacheHit: perf_cnt_d[i] += icache_events_q[hart_select].l0_hit;
        IcachePrefetch: perf_cnt_d[i] += icache_events_q[hart_select].l0_prefetch;
        IcacheDoubleHit: perf_cnt_d[i] += icache_events_q[hart_select].l0_double_hit;
        IcacheStall: perf_cnt_d[i] += icache_events_q[hart_select].l0_stall;
        default: perf_cnt_d[i] = perf_cnt_q[i];
      endcase
      // Reset performance counter.
      if (reg2hw.perf_cnt[i].qe) begin
        perf_cnt_d[i] = reg2hw.perf_cnt[i].q;
      end
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

  // Actual performance counters.
  `FF(perf_cnt_q, perf_cnt_d, '0, clk_i, rst_ni)

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
