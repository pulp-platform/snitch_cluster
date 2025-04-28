// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Exposes cluster confugration and information as memory mapped information

`include "apb/typedef.svh"
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
  parameter type reg_req_t = logic,
  parameter type reg_rsp_t = logic,
  parameter type tcdm_events_t = logic,
  parameter type dma_events_t = logic
) (
  input  logic                                   clk_i,
  input  logic                                   rst_ni,

  input  reg_req_t                               reg_req_i,
  output reg_rsp_t                               reg_rsp_o,

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

  `APB_TYPEDEF_ALL(sn_periph_regs_apb, addr_t, data_t, strb_t)
  sn_periph_regs_apb_req_t  sn_periph_regs_apb_req;
  sn_periph_regs_apb_resp_t sn_periph_regs_apb_rsp;

  reg_to_apb #(
    .reg_req_t  ( reg_req_t ),
    .reg_rsp_t  ( reg_rsp_t ),
    .apb_req_t  ( sn_periph_regs_apb_req_t ),
    .apb_rsp_t  ( sn_periph_regs_apb_resp_t )
  ) chs_regs_reg_to_apb (
    .clk_i,
    .rst_ni,
    .reg_req_i  ( reg_req_i ),
    .reg_rsp_o  ( reg_rsp_o ),
    .apb_req_o  ( sn_periph_regs_apb_req ),
    .apb_rsp_i  ( sn_periph_regs_apb_rsp )
  );

  snitch_cluster_peripheral_reg i_snitch_cluster_peripheral_reg (
    .clk (clk_i),
    .arst_n (rst_ni),
    .s_apb_psel    ( sn_periph_regs_apb_req.psel    ),
    .s_apb_penable ( sn_periph_regs_apb_req.penable ),
    .s_apb_pwrite  ( sn_periph_regs_apb_req.pwrite  ),
    .s_apb_pprot   ( sn_periph_regs_apb_req.pprot   ),
    .s_apb_paddr   ( sn_periph_regs_apb_req.paddr   ),
    .s_apb_pwdata  ( sn_periph_regs_apb_req.pwdata  ),
    .s_apb_pstrb   ( sn_periph_regs_apb_req.pstrb   ),
    .s_apb_pready  ( sn_periph_regs_apb_rsp.pready  ),
    .s_apb_prdata  ( sn_periph_regs_apb_rsp.prdata  ),
    .s_apb_pslverr ( sn_periph_regs_apb_rsp.pslverr ),
    .hwif_out (reg2hw),
    .hwif_in  (hw2reg)
  );

  // The metrics that should be tracked immediately after reset.
  localparam int unsigned NumPerfMetricRstValues = 7;
  localparam snitch_cluster_peripheral_reg__PERF_METRIC_e
    PerfMetricRstValues[NumPerfMetricRstValues] = '{
      snitch_cluster_peripheral_reg__PERF_METRIC__CYCLE,
      snitch_cluster_peripheral_reg__PERF_METRIC__RETIRED_INSTR,
      snitch_cluster_peripheral_reg__PERF_METRIC__TCDM_ACCESSED,
      snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_MISS,
      snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_HIT,
      snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_PREFETCH,
      snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_STALL
  };

  logic [NumPerfCounters-1:0][47:0] perf_cnt_q, perf_cnt_d;
  snitch_cluster_peripheral_reg__PERF_METRIC_e [NumPerfCounters-1:0] perf_metrics_q, perf_metrics_d;
  logic [NumPerfCounters-1:0][$clog2(NrCores)-1:0] perf_hart_sel_q, perf_hart_sel_d;
  logic [31:0] cl_clint_d, cl_clint_q;

  // Wake-up logic: Bits in cl_clint_q can be set/cleared with writes to
  // cl_clint_set/cl_clint_clear
  always_comb begin
    cl_clint_d = cl_clint_q;
    if (reg2hw.CL_CLINT_SET.req && reg2hw.CL_CLINT_SET.req_is_wr) begin
      cl_clint_d = cl_clint_q | reg2hw.CL_CLINT_SET.wr_biten.CL_CLINT_SET &
                                reg2hw.CL_CLINT_SET.wr_data.CL_CLINT_SET;
    end else if (reg2hw.CL_CLINT_CLEAR.req && reg2hw.CL_CLINT_CLEAR.req_is_wr) begin
      cl_clint_d = cl_clint_q & ~(reg2hw.CL_CLINT_CLEAR.wr_biten.CL_CLINT_CLEAR &
                                  reg2hw.CL_CLINT_CLEAR.wr_data.CL_CLINT_CLEAR);
    end
  end
  `FF(cl_clint_q, cl_clint_d, '0, clk_i, rst_ni)
  assign cl_clint_o = cl_clint_q[NrCores-1:0];

  // Enable icache prefetch
  assign icache_prefetch_enable_o = reg2hw.ICACHE_PREFETCH_ENABLE.ICACHE_PREFETCH_ENABLE.value;

  // Continuously assign the perf values.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_assign
    assign hw2reg.PERF_REGS.PERF_CNT[i].rd_data.PERF_COUNTER = perf_cnt_q[i];
    assign hw2reg.PERF_REGS.PERF_CNT_SEL[i].rd_data.METRIC = perf_metrics_q[i];
    assign hw2reg.PERF_REGS.PERF_CNT_SEL[i].rd_data.HART = perf_hart_sel_q[i];
    assign hw2reg.PERF_REGS.PERF_CNT[i].rd_ack = 1'b1;
    assign hw2reg.PERF_REGS.PERF_CNT_SEL[i].rd_ack = 1'b1;
    assign hw2reg.PERF_REGS.PERF_CNT[i].wr_ack = 1'b1;
    assign hw2reg.PERF_REGS.PERF_CNT_SEL[i].wr_ack = 1'b1;
    assign hw2reg.PERF_REGS.PERF_CNT[i].rd_data._reserved_63_48 = '0;
    assign hw2reg.PERF_REGS.PERF_CNT_SEL[i].rd_data._reserved_63_32 = '0;
  end

  assign hw2reg.CL_CLINT_SET.wr_ack = 1'b1;
  assign hw2reg.CL_CLINT_CLEAR.wr_ack = 1'b1;

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
        snitch_cluster_peripheral_reg__PERF_METRIC__CYCLE: perf_cnt_d[i] += 1;
        snitch_cluster_peripheral_reg__PERF_METRIC__TCDM_ACCESSED: perf_cnt_d[i] +=
          tcdm_events_q.inc_accessed;
        snitch_cluster_peripheral_reg__PERF_METRIC__TCDM_CONGESTED: perf_cnt_d[i] +=
          tcdm_events_q.inc_congested;
        snitch_cluster_peripheral_reg__PERF_METRIC__ISSUE_FPU: perf_cnt_d[i] +=
          sel_core_events.issue_fpu;
        snitch_cluster_peripheral_reg__PERF_METRIC__ISSUE_FPU_SEQ: perf_cnt_d[i] +=
          sel_core_events.issue_fpu_seq;
        snitch_cluster_peripheral_reg__PERF_METRIC__ISSUE_CORE_TO_FPU: perf_cnt_d[i] +=
          sel_core_events.issue_core_to_fpu;
        snitch_cluster_peripheral_reg__PERF_METRIC__RETIRED_INSTR: perf_cnt_d[i] +=
          sel_core_events.retired_instr;
        snitch_cluster_peripheral_reg__PERF_METRIC__RETIRED_LOAD: perf_cnt_d[i] +=
          sel_core_events.retired_load;
        snitch_cluster_peripheral_reg__PERF_METRIC__RETIRED_I: perf_cnt_d[i] +=
          sel_core_events.retired_i;
        snitch_cluster_peripheral_reg__PERF_METRIC__RETIRED_ACC: perf_cnt_d[i] +=
          sel_core_events.retired_acc;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_AW_STALL: perf_cnt_d[i] +=
          sel_dma_events.aw_stall;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_AR_STALL: perf_cnt_d[i] +=
          sel_dma_events.ar_stall;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_R_STALL: perf_cnt_d[i] +=
          sel_dma_events.r_stall;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_W_STALL: perf_cnt_d[i] +=
          sel_dma_events.w_stall;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_BUF_W_STALL: perf_cnt_d[i] +=
          sel_dma_events.buf_w_stall;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_BUF_R_STALL: perf_cnt_d[i] +=
          sel_dma_events.buf_r_stall;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_AW_DONE: perf_cnt_d[i] +=
          sel_dma_events.aw_done;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_AW_BW: perf_cnt_d[i] +=
          ((sel_dma_events.aw_len + 1) << (sel_dma_events.aw_size));
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_AR_DONE: perf_cnt_d[i] +=
          sel_dma_events.ar_done;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_AR_BW: perf_cnt_d[i] +=
          ((sel_dma_events.ar_len + 1) << (sel_dma_events.ar_size));
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_R_DONE: perf_cnt_d[i] +=
          sel_dma_events.r_done;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_R_BW: perf_cnt_d[i] += DMADataWidth/8;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_W_DONE: perf_cnt_d[i] +=
          sel_dma_events.w_done;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_W_BW: perf_cnt_d[i] +=
          sel_dma_events.num_bytes_written;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_B_DONE: perf_cnt_d[i] +=
          sel_dma_events.b_done;
        snitch_cluster_peripheral_reg__PERF_METRIC__DMA_BUSY: perf_cnt_d[i] +=
          sel_dma_events.dma_busy;
        snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_MISS: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_miss;
        snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_HIT: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_hit;
        snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_PREFETCH: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_prefetch;
        snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_DOUBLE_HIT: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_double_hit;
        snitch_cluster_peripheral_reg__PERF_METRIC__ICACHE_STALL: perf_cnt_d[i] +=
          icache_events_q[hart_select].l0_stall;
        default:;
      endcase
      // Set performance metric.
      if (reg2hw.PERF_REGS.PERF_CNT_SEL[i].req &&
          reg2hw.PERF_REGS.PERF_CNT_SEL[i].req_is_wr &&
          |reg2hw.PERF_REGS.PERF_CNT_SEL[i].wr_biten.METRIC) begin
        perf_metrics_d[i] = snitch_cluster_peripheral_reg__PERF_METRIC_e'(
          reg2hw.PERF_REGS.PERF_CNT_SEL[i].wr_data.METRIC);
      end
      // Set hart select.
      if (reg2hw.PERF_REGS.PERF_CNT_SEL[i].req &&
          reg2hw.PERF_REGS.PERF_CNT_SEL[i].req_is_wr &&
          |reg2hw.PERF_REGS.PERF_CNT_SEL[i].wr_biten.HART) begin
        perf_hart_sel_d[i] = reg2hw.PERF_REGS.PERF_CNT_SEL[i].wr_data.HART;
      end
    end
  end

  // Performance counter FFs.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_cnt
    logic perf_cnt_req_and_wr;
    assign perf_cnt_req_and_wr = reg2hw.PERF_REGS.PERF_CNT[i].req &
                                 reg2hw.PERF_REGS.PERF_CNT[i].req_is_wr;
    `FFLARNC(perf_cnt_q[i], perf_cnt_d[i], reg2hw.PERF_REGS.PERF_CNT_EN[i].ENABLE.value,
             perf_cnt_req_and_wr,
             '0, clk_i, rst_ni)
  end

  // Set reset values for the metrics that should be tracked immediately after reset.
  for (genvar i = 0; i < NumPerfCounters; i++) begin : gen_perf_metrics_assign
    if (i < NumPerfMetricRstValues) begin : gen_perf_metrics_rst_value
      `FF(perf_metrics_q[i], perf_metrics_d[i], PerfMetricRstValues[i], clk_i, rst_ni)
    end else begin : gen_perf_metrics_default
      `FF(perf_metrics_q[i], perf_metrics_d[i],
          snitch_cluster_peripheral_reg__PERF_METRIC__CYCLE, clk_i, rst_ni)
    end
  end

  // Use hart `0` as default.
  `FF(perf_hart_sel_q, perf_hart_sel_d, 0, clk_i, rst_ni)

endmodule
