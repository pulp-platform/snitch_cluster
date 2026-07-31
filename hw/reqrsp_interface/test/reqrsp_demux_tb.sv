// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "reqrsp_interface/assign.svh"
`include "reqrsp_interface/typedef.svh"

/// Testbench for `reqrsp_demux`. Random drivers on the slave and master
/// ports drive a random opaque payload pattern. The monitors track all packets and
/// the scoreboard checks the integrity of the schedule and data.
module reqrsp_demux_tb #(
  parameter int unsigned ReqWidth = 64,
  parameter int unsigned RspWidth = 32,
  parameter int unsigned NrPorts = 4,
  parameter int unsigned RspDepth = 2,
  parameter int unsigned NrRandomTransactions = 1000
);
  localparam time ClkPeriod = 10ns;
  localparam time ApplTime =  2ns;
  localparam time TestTime =  8ns;
  localparam int unsigned SelectWidth = cc_pkg::idx_width(NrPorts);

  typedef logic [ReqWidth-1:0] req_chan_t;
  typedef logic [RspWidth-1:0] rsp_chan_t;
  typedef logic [SelectWidth-1:0] select_t;

  `REQRSP_TYPEDEF_ALL(demux, req_chan_t, rsp_chan_t)

  logic clk, rst_n;
  select_t slv_select;
  mailbox #(select_t) select_mbx = new();

  REQRSP_BUS_DV #(
    .req_chan_t (req_chan_t),
    .rsp_chan_t (rsp_chan_t)
  ) master_dv (clk);

  REQRSP_BUS_DV #(
    .req_chan_t (req_chan_t),
    .rsp_chan_t (rsp_chan_t)
  ) slave_dv [NrPorts] (clk);

  demux_req_t demux_slv_req;
  demux_rsp_t demux_slv_rsp;
  demux_req_t [NrPorts-1:0] demux_mst_req;
  demux_rsp_t [NrPorts-1:0] demux_mst_rsp;

  reqrsp_demux #(
    .NrPorts    (NrPorts),
    .req_chan_t (req_chan_t),
    .rsp_chan_t (rsp_chan_t),
    .RspDepth   (RspDepth)
  ) dut (
    .clk_i     (clk),
    .rst_ni    (rst_n),
    .select_i  (slv_select),
    .slv_req_i (demux_slv_req),
    .slv_rsp_o (demux_slv_rsp),
    .mst_req_o (demux_mst_req),
    .mst_rsp_i (demux_mst_rsp)
  );

  `REQRSP_ASSIGN_TO_REQ(demux_slv_req, master_dv)
  `REQRSP_ASSIGN_FROM_RSP(master_dv, demux_slv_rsp)

  for (genvar i = 0; i < NrPorts; i++) begin : gen_if_assignment
    `REQRSP_ASSIGN_FROM_REQ(slave_dv[i], demux_mst_req[i])
    `REQRSP_ASSIGN_TO_RSP(demux_mst_rsp[i], slave_dv[i])
  end

  // ----------------
  // Clock generation
  // ----------------
  initial begin
    rst_n = 0;
    repeat (3) begin
      #(ClkPeriod/2) clk = 0;
      #(ClkPeriod/2) clk = 1;
    end
    rst_n = 1;
    forever begin
      #(ClkPeriod/2) clk = 0;
      #(ClkPeriod/2) clk = 1;
    end
  end

  // -----------------
  // Select generation
  // -----------------
  initial begin
    slv_select = '0;
    @(posedge rst_n);
    forever begin
      automatic select_t select;
      assert(std::randomize(select) with { select < NrPorts; });
      slv_select <= #ApplTime select;
      do @(posedge clk); while (!(master_dv.q_valid && master_dv.q_ready));
      select_mbx.put(select);
    end
  end

  // -------
  // Monitor
  // -------
  typedef reqrsp_test::reqrsp_monitor #(
    .req_chan_t (req_chan_t),
    .rsp_chan_t (rsp_chan_t),
    .TA (ApplTime),
    .TT (TestTime)
  ) reqrsp_monitor_t;

  reqrsp_monitor_t reqrsp_mst_monitor = new(master_dv);
  initial begin
    @(posedge rst_n);
    reqrsp_mst_monitor.monitor();
  end

  reqrsp_monitor_t reqrsp_slv_monitor [NrPorts];
  for (genvar i = 0; i < NrPorts; i++) begin : gen_mst_mon
    initial begin
      reqrsp_slv_monitor[i] = new(slave_dv[i]);
      @(posedge rst_n);
      reqrsp_slv_monitor[i].monitor();
    end
  end

  // ------
  // Driver
  // ------
  typedef reqrsp_test::rand_reqrsp_slave #(
    .req_chan_t (req_chan_t),
    .rsp_chan_t (rsp_chan_t),
    .TA (ApplTime),
    .TT (TestTime)
  ) reqrsp_rand_slave_t;

  reqrsp_rand_slave_t rand_reqrsp_slave [NrPorts];
  for (genvar i = 0; i < NrPorts; i++) begin : gen_slv_driver
    initial begin
      rand_reqrsp_slave[i] = new(slave_dv[i]);
      rand_reqrsp_slave[i].reset();
      @(posedge rst_n);
      rand_reqrsp_slave[i].run();
    end
  end

  typedef reqrsp_test::rand_reqrsp_master #(
    .req_chan_t (req_chan_t),
    .rsp_chan_t (rsp_chan_t),
    .TA (ApplTime),
    .TT (TestTime)
  ) reqrsp_rand_master_t;

  reqrsp_rand_master_t rand_reqrsp_master = new(master_dv);

  initial begin
    rand_reqrsp_master.reset();
    @(posedge rst_n);
    rand_reqrsp_master.run(NrRandomTransactions);
    // Wait until all transactions have ceased.
    repeat(1000) @(posedge clk);
    $finish;
  end

  // ----------
  // Scoreboard
  // ----------
  initial begin
    forever begin
      automatic reqrsp_test::req_t #(.req_chan_t(req_chan_t)) req;
      automatic reqrsp_test::req_t #(.req_chan_t(req_chan_t)) req_slv;
      automatic reqrsp_test::rsp_t #(.rsp_chan_t(rsp_chan_t)) rsp;
      automatic reqrsp_test::rsp_t #(.rsp_chan_t(rsp_chan_t)) rsp_slv;
      automatic select_t select;
      reqrsp_mst_monitor.req_mbx.get(req);
      reqrsp_mst_monitor.rsp_mbx.get(rsp);
      // Check that for each master transaction we see a slave transaction on
      // the port selected by the randomized sideband select.
      select_mbx.get(select);
      reqrsp_slv_monitor[select].req_mbx.get(req_slv);
      reqrsp_slv_monitor[select].rsp_mbx.get(rsp_slv);
      assert(req_slv.do_compare(req));
      assert(rsp_slv.do_compare(rsp));
    end
  end

  // Check that we have associated all transactions.
  final begin
    assert(reqrsp_mst_monitor.req_mbx.num() == 0);
    assert(reqrsp_mst_monitor.rsp_mbx.num() == 0);
    for (int i = 0; i < NrPorts; i++) begin
      assert(reqrsp_slv_monitor[i].req_mbx.num() == 0);
      assert(reqrsp_slv_monitor[i].rsp_mbx.num() == 0);
    end
    $display("Checked for non-empty mailboxes.");
  end

endmodule
