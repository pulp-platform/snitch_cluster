// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "reqrsp_interface/assign.svh"
`include "lsu_interface/typedef.svh"
`include "tcdm_interface/assign.svh"

/// Testbench for `lsu_to_tcdm` module.
module lsu_to_tcdm_tb #(
  parameter int unsigned AW = 32,
  parameter int unsigned DW = 32,
  parameter int unsigned BufDepth = 4,
  parameter int unsigned NrRandomTransactions = 1000
);

  localparam time ClkPeriod = 10ns;
  localparam time ApplTime =  2ns;
  localparam time TestTime =  8ns;

  logic  clk, rst_n;

  typedef logic [AW-1:0] addr_t;
  typedef logic [DW-1:0] data_t;
  typedef logic [DW/8-1:0] strb_t;

  // interfaces
  LSU_BUS #(
    .ADDR_WIDTH ( AW ),
    .DATA_WIDTH ( DW )
  ) master ();

  LSU_BUS_DV #(
    .ADDR_WIDTH ( AW ),
    .DATA_WIDTH ( DW )
  ) master_dv (clk);

  TCDM_BUS #(
    .ADDR_WIDTH ( AW ),
    .DATA_WIDTH ( DW ),
    .user_t (logic)
  ) slave ();

  TCDM_BUS_DV #(
    .ADDR_WIDTH ( AW ),
    .DATA_WIDTH ( DW ),
    .user_t (logic)
  ) slave_dv (clk);


  lsu_to_tcdm_intf #(
    .AddrWidth (AW),
    .DataWidth (DW),
    .BufDepth (BufDepth)
  ) i_dut (
    .clk_i (clk),
    .rst_ni (rst_n),
    .lsu (master),
    .tcdm (slave)
  );

  `LSU_ASSIGN(master, master_dv)
  `TCDM_ASSIGN(slave_dv, slave)

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

  // ------
  // Driver
  // ------
  // TCDM Driver
  typedef tcdm_test::rand_tcdm_slave #(
    // tcdm interface parameters
    .AW ( AW ),
    .DW ( DW ),
    .user_t (logic),
    // Stimuli application and test time
    .TA ( ApplTime ),
    .TT ( TestTime )
  ) rand_tcdm_slave_t;

  rand_tcdm_slave_t rand_tcdm_slave = new (slave_dv);

  typedef lsu_test::rand_lsu_master #(
    // LSU bus interface paramaters;
    .AW ( AW ),
    .DW ( DW ),
    // Stimuli application and test time
    .TA ( ApplTime ),
    .TT ( TestTime )
  ) lsu_driver_t;

  lsu_driver_t rand_lsu_master = new (master_dv);

  // tcdm side.
  initial begin
    rand_tcdm_slave.reset();
    @(posedge rst_n);
    rand_tcdm_slave.run();
  end

  // tcdm side.
  initial begin
    rand_lsu_master.reset();
    @(posedge rst_n);
    rand_lsu_master.run(NrRandomTransactions);
    repeat (100) @(posedge clk);
    $finish;
  end

  // -------
  // Monitor
  // -------
  typedef lsu_test::lsu_monitor #(
    // LSU bus interface paramaters;
    .AW ( AW ),
    .DW ( DW ),
    // Stimuli application and test time
    .TA ( ApplTime ),
    .TT ( TestTime )
  ) lsu_monitor_t;

  lsu_monitor_t lsu_monitor = new (master_dv);
  // LSU Monitor.
  initial begin
    @(posedge rst_n);
    lsu_monitor.monitor();
  end

  // TCDM Monitor
  typedef tcdm_test::tcdm_monitor #(
    // tcdm interface parameters
    .AW ( AW ),
    .DW ( DW ),
    .user_t (logic),
    // Stimuli application and test time
    .TA ( ApplTime ),
    .TT ( TestTime )
  ) tcdm_monitor_t;

  tcdm_monitor_t tcdm_monitor = new (slave_dv);
  initial begin
    @(posedge rst_n);
    tcdm_monitor.monitor();
  end

  // ----------
  // Scoreboard
  // ----------
  int unsigned nr_transactions;
  /// Make sure that each transaction on the input side is observeable on the
  /// output.
  initial begin
    forever begin
      automatic lsu_test::req_t req;
      automatic lsu_test::rsp_t rsp;
      automatic tcdm_test::req_t tcdm_req;
      automatic tcdm_test::rsp_t tcdm_rsp;
      lsu_monitor.req_mbx.get(req);
      lsu_monitor.rsp_mbx.get(rsp);
      tcdm_monitor.req_mbx.get(tcdm_req);
      tcdm_monitor.rsp_mbx.get(tcdm_rsp);
      nr_transactions++;
      assert(tcdm_req.addr == req.addr)
        else $error("Expected `%h` got `%h`", req.addr, tcdm_req.addr);
      assert(tcdm_req.write == req.write);
      assert(tcdm_req.amo == req.amo);
      assert(tcdm_req.data == req.data);
      assert(tcdm_req.strb == req.strb);
      assert(tcdm_rsp.data == rsp.data) else $error("Responses didn't match.");

    end
  end

  final begin
    assert(lsu_monitor.req_mbx.num() == 0);
    assert(lsu_monitor.req_mbx.num() == 0);
    assert(tcdm_monitor.req_mbx.num() == 0);
    assert(tcdm_monitor.rsp_mbx.num() == 0);
    $info("Finished with %d transactions.", nr_transactions);
  end
endmodule
