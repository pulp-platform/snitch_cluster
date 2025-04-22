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
  parameter type addr_t = logic,
  parameter type data_t = logic,
  parameter type strb_t = logic,
  parameter type apb_req_t = logic,
  parameter type apb_resp_t = logic,
  parameter type tcdm_events_t = logic,
  parameter type dma_events_t = logic
) (
  input  logic                                   clk_i,
  input  logic                                   rst_ni,

  input  apb_req_t                               apb_req_i,
  output apb_resp_t                              apb_resp_o,

  output logic                                   icache_prefetch_enable_o,
  output logic              [NrCores-1:0]        cl_clint_o,
  input  core_events_t      [NrCores-1:0]        core_events_i,
  input  tcdm_events_t                           tcdm_events_i,
  input  dma_events_t       [DMANumChannels-1:0] dma_events_i,
  input  icache_l0_events_t [NrCores-1:0]        icache_events_i
);

  // Pipeline register to ease timing.
  tcdm_events_t tcdm_events_q;
  dma_events_t [DMANumChannels-1:0] dma_events_q;
  icache_l0_events_t [NrCores-1:0] icache_events_q;
  `FF(tcdm_events_q, tcdm_events_i, '0)
  `FF(dma_events_q, dma_events_i, '0)
  `FF(icache_events_q, icache_events_i, '0)

  snitch_cluster_peripheral_reg__out_t reg2hw;
  snitch_cluster_peripheral_reg__in_t  hw2reg;

  snitch_cluster_peripheral_reg i_snitch_cluster_peripheral_reg (
    .clk    (clk_i),
    .arst_n (rst_ni),
    .s_apb_psel    ( apb_req_i.psel    ),
    .s_apb_penable ( apb_req_i.penable ),
    .s_apb_pwrite  ( apb_req_i.pwrite  ),
    .s_apb_pprot   ( apb_req_i.pprot   ),
    .s_apb_paddr   (apb_req_i.paddr[SNITCH_CLUSTER_PERIPHERAL_REG_MIN_ADDR_WIDTH-1:0]),
    .s_apb_pwdata  ( apb_req_i.pwdata  ),
    .s_apb_pstrb   ( apb_req_i.pstrb   ),
    .s_apb_pready  ( apb_resp_o.pready  ),
    .s_apb_prdata  ( apb_resp_o.prdata  ),
    .s_apb_pslverr ( apb_resp_o.pslverr ),
    .hwif_out (reg2hw),
    .hwif_in  (hw2reg)
  );

  // The metrics that should be tracked immediately after reset.
  localparam int unsigned NumPerfMetricRstValues = 7;
  localparam snitch_cluster_peripheral_reg__perf_metric_e
    PerfMetricRstValues[NumPerfMetricRstValues] = '{
      snitch_cluster_peripheral_reg__perf_metric__cycle,
      snitch_cluster_peripheral_reg__perf_metric__retired_instr,
      snitch_cluster_peripheral_reg__perf_metric__tcdm_accessed,
      snitch_cluster_peripheral_reg__perf_metric__icache_miss,
      snitch_cluster_peripheral_reg__perf_metric__icache_hit,
      snitch_cluster_peripheral_reg__perf_metric__icache_prefetch,
      snitch_cluster_peripheral_reg__perf_metric__icache_stall
  };

  logic [NumPerfCounters-1:0][47:0] perf_cnt_q, perf_cnt_d;
  snitch_cluster_peripheral_reg__perf_metric_e [NumPerfCounters-1:0] perf_metrics_q, perf_metrics_d;
  logic [NumPerfCounters-1:0][$clog2(NrCores)-1:0] perf_hart_sel_q, perf_hart_sel_d;
  logic [31:0] cl_clint_d, cl_clint_q;

  // Wake-up logic: Bits in cl_clint_q can be set/cleared with writes to
  // cl_clint_set/cl_clint_clear
  always_comb begin
    cl_clint_d = cl_clint_q;
    if (reg2hw.cl_clint_set.req && reg2hw.cl_clint_set.req_is_wr) begin
      cl_clint_d = cl_clint_q | (reg2hw.cl_clint_set.wr_biten.cl_clint_set &
                                 reg2hw.cl_clint_set.wr_data.cl_clint_set);
    end else if (reg2hw.cl_clint_clear.req && reg2hw.cl_clint_clear.req_is_wr) begin
      cl_clint_d = cl_clint_q & ~(reg2hw.cl_clint_clear.wr_biten.cl_clint_clear &
                                  reg2hw.cl_clint_clear.wr_data.cl_clint_clear);
    end
  end
  `FF(cl_clint_q, cl_clint_d, '0, clk_i, rst_ni)
  assign cl_clint_o = cl_clint_q[NrCores-1:0];

  // Enable icache prefetch
  assign icache_prefetch_enable_o = reg2hw.icache_prefetch_enable.icache_prefetch_enable.value;

  // Continuously assign the perf values.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_assign
    assign hw2reg.perf_regs.perf_cnt[i].rd_data.perf_counter = perf_cnt_q[i];
    assign hw2reg.perf_regs.perf_cnt_sel[i].rd_data.metric = perf_metrics_q[i];
    assign hw2reg.perf_regs.perf_cnt_sel[i].rd_data.hart = perf_hart_sel_q[i];
    assign hw2reg.perf_regs.perf_cnt[i].rd_ack = reg2hw.perf_regs.perf_cnt[i].req &
                                                !reg2hw.perf_regs.perf_cnt[i].req_is_wr;
    assign hw2reg.perf_regs.perf_cnt_sel[i].rd_ack = reg2hw.perf_regs.perf_cnt_sel[i].req &
                                                !reg2hw.perf_regs.perf_cnt_sel[i].req_is_wr;
    assign hw2reg.perf_regs.perf_cnt[i].wr_ack = reg2hw.perf_regs.perf_cnt[i].req &
                                                reg2hw.perf_regs.perf_cnt[i].req_is_wr;
    assign hw2reg.perf_regs.perf_cnt_sel[i].wr_ack = reg2hw.perf_regs.perf_cnt_sel[i].req &
                                                reg2hw.perf_regs.perf_cnt_sel[i].req_is_wr;
    assign hw2reg.perf_regs.perf_cnt[i].rd_data._reserved_63_48 = '0;
    assign hw2reg.perf_regs.perf_cnt_sel[i].rd_data._reserved_63_32 = '0;
  end

  assign hw2reg.cl_clint_set.wr_ack = reg2hw.cl_clint_set.req &
                                      reg2hw.cl_clint_set.req_is_wr;
  assign hw2reg.cl_clint_clear.wr_ack = reg2hw.cl_clint_clear.req &
                                        reg2hw.cl_clint_clear.req_is_wr;

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
        snitch_cluster_peripheral_reg__perf_metric__cycle: perf_cnt_d[i] += 1;
        snitch_cluster_peripheral_reg__perf_metric__tcdm_accessed: perf_cnt_d[i] +=
          tcdm_events_q.inc_accessed;
        snitch_cluster_peripheral_reg__perf_metric__tcdm_congested: perf_cnt_d[i] +=
          tcdm_events_q.inc_congested;
        snitch_cluster_peripheral_reg__perf_metric__issue_fpu: perf_cnt_d[i] +=
          sel_core_events.issue_fpu;
        snitch_cluster_peripheral_reg__perf_metric__issue_fpu_seq: perf_cnt_d[i] +=
          sel_core_events.issue_fpu_seq;
        snitch_cluster_peripheral_reg__perf_metric__issue_core_to_fpu: perf_cnt_d[i] +=
          sel_core_events.issue_core_to_fpu;
        snitch_cluster_peripheral_reg__perf_metric__retired_instr: perf_cnt_d[i] +=
          sel_core_events.retired_instr;
        snitch_cluster_peripheral_reg__perf_metric__retired_load: perf_cnt_d[i] +=
          sel_core_events.retired_load;
        snitch_cluster_peripheral_reg__perf_metric__retired_i: perf_cnt_d[i] +=
          sel_core_events.retired_i;
        snitch_cluster_peripheral_reg__perf_metric__retired_acc: perf_cnt_d[i] +=
          sel_core_events.retired_acc;
        snitch_cluster_peripheral_reg__perf_metric__dma_aw_stall: perf_cnt_d[i] +=
          sel_dma_events.aw_stall;
        snitch_cluster_peripheral_reg__perf_metric__dma_ar_stall: perf_cnt_d[i] +=
          sel_dma_events.ar_stall;
        snitch_cluster_peripheral_reg__perf_metric__dma_r_stall: perf_cnt_d[i] +=
          sel_dma_events.r_stall;
        snitch_cluster_peripheral_reg__perf_metric__dma_w_stall: perf_cnt_d[i] +=
          sel_dma_events.w_stall;
        snitch_cluster_peripheral_reg__perf_metric__dma_buf_w_stall: perf_cnt_d[i] +=
          sel_dma_events.buf_w_stall;
        snitch_cluster_peripheral_reg__perf_metric__dma_buf_r_stall: perf_cnt_d[i] +=
          sel_dma_events.buf_r_stall;
        snitch_cluster_peripheral_reg__perf_metric__dma_aw_done: perf_cnt_d[i] +=
          sel_dma_events.aw_done;
        snitch_cluster_peripheral_reg__perf_metric__dma_aw_bw: perf_cnt_d[i] +=
          ((sel_dma_events.aw_len + 1) << (sel_dma_events.aw_size));
        snitch_cluster_peripheral_reg__perf_metric__dma_ar_done: perf_cnt_d[i] +=
          sel_dma_events.ar_done;
        snitch_cluster_peripheral_reg__perf_metric__dma_ar_bw: perf_cnt_d[i] +=
          ((sel_dma_events.ar_len + 1) << (sel_dma_events.ar_size));
        snitch_cluster_peripheral_reg__perf_metric__dma_r_done: perf_cnt_d[i] +=
          sel_dma_events.r_done;
        snitch_cluster_peripheral_reg__perf_metric__dma_r_bw: perf_cnt_d[i] += DMADataWidth/8;
        snitch_cluster_peripheral_reg__perf_metric__dma_w_done: perf_cnt_d[i] +=
          sel_dma_events.w_done;
        snitch_cluster_peripheral_reg__perf_metric__dma_w_bw: perf_cnt_d[i] +=
          sel_dma_events.num_bytes_written;
        snitch_cluster_peripheral_reg__perf_metric__dma_b_done: perf_cnt_d[i] +=
          sel_dma_events.b_done;
        snitch_cluster_peripheral_reg__perf_metric__dma_busy: perf_cnt_d[i] +=
          sel_dma_events.dma_busy;
        snitch_cluster_peripheral_reg__perf_metric__icache_miss: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_miss;
        snitch_cluster_peripheral_reg__perf_metric__icache_hit: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_hit;
        snitch_cluster_peripheral_reg__perf_metric__icache_prefetch: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_prefetch;
        snitch_cluster_peripheral_reg__perf_metric__icache_double_hit: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_double_hit;
        snitch_cluster_peripheral_reg__perf_metric__icache_stall: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_stall;
        default:;
      endcase
      // Set performance metric.
      if (reg2hw.perf_regs.perf_cnt_sel[i].req &&
          reg2hw.perf_regs.perf_cnt_sel[i].req_is_wr &&
          |reg2hw.perf_regs.perf_cnt_sel[i].wr_biten.metric) begin
        perf_metrics_d[i] = snitch_cluster_peripheral_reg__perf_metric_e'(
          reg2hw.perf_regs.perf_cnt_sel[i].wr_data.metric);
      end
      // Set hart select.
      if (reg2hw.perf_regs.perf_cnt_sel[i].req &&
          reg2hw.perf_regs.perf_cnt_sel[i].req_is_wr &&
          |reg2hw.perf_regs.perf_cnt_sel[i].wr_biten.hart) begin
        perf_hart_sel_d[i] = reg2hw.perf_regs.perf_cnt_sel[i].wr_data.hart;
      end
    end
  end

  // Performance counter FFs.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_cnt
    logic perf_cnt_req_and_wr;
    assign perf_cnt_req_and_wr = reg2hw.perf_regs.perf_cnt[i].req &
                                 reg2hw.perf_regs.perf_cnt[i].req_is_wr;
    `FFLARNC(perf_cnt_q[i], perf_cnt_d[i], reg2hw.perf_regs.perf_cnt_en[i].enable.value,
             perf_cnt_req_and_wr,
             '0, clk_i, rst_ni)
  end

  // Set reset values for the metrics that should be tracked immediately after reset.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_metrics_assign
    if (i < NumPerfMetricRstValues) begin : gen_perf_metrics_rst_value
      `FF(perf_metrics_q[i], perf_metrics_d[i], PerfMetricRstValues[i], clk_i, rst_ni)
    end else begin : gen_perf_metrics_default
      `FF(perf_metrics_q[i], perf_metrics_d[i],
          snitch_cluster_peripheral_reg__perf_metric__cycle, clk_i, rst_ni)
    end
  end

  // Use hart `0` as default.
  `FF(perf_hart_sel_q, perf_hart_sel_d, 0, clk_i, rst_ni)

endmodule
