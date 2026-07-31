// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
// Florian Zaruba <zarubaf@iis.ee.ethz.ch>

/// A set of testbench utilities for reqrsp interfaces.
package reqrsp_test;

  class req_t #(
    parameter type req_chan_t = logic
  );
    rand req_chan_t q;

    function bit do_compare(req_t #(.req_chan_t(req_chan_t)) rhs);
      return q == rhs.q;
    endfunction
  endclass

  class rsp_t #(
    parameter type rsp_chan_t = logic
  );
    rand rsp_chan_t p;

    function bit do_compare(rsp_t #(.rsp_chan_t(rsp_chan_t)) rhs);
      return p == rhs.p;
    endfunction
  endclass

  /// A driver for reqrsp-like interfaces with opaque payloads.
  class reqrsp_driver #(
    parameter type req_chan_t = logic,
    parameter type rsp_chan_t = logic,
    parameter time TA = 0,
    parameter time TT = 0
  );
    typedef reqrsp_test::req_t #(.req_chan_t(req_chan_t)) req_item_t;
    typedef reqrsp_test::rsp_t #(.rsp_chan_t(rsp_chan_t)) rsp_item_t;

    virtual REQRSP_BUS_DV #(
      .req_chan_t(req_chan_t),
      .rsp_chan_t(rsp_chan_t)
    ) bus;

    function new(
      virtual REQRSP_BUS_DV #(
        .req_chan_t(req_chan_t),
        .rsp_chan_t(rsp_chan_t)
      ) bus
    );
      this.bus = bus;
    endfunction

    task reset_master;
      bus.q       <= '0;
      bus.q_valid <= '0;
      bus.p_ready <= '0;
    endtask

    task reset_slave;
      bus.q_ready <= '0;
      bus.p       <= '0;
      bus.p_valid <= '0;
    endtask

    task cycle_start;
      #TT;
    endtask

    task cycle_end;
      @(posedge bus.clk_i);
    endtask

    task send_req(input req_item_t req);
      bus.q       <= #TA req.q;
      bus.q_valid <= #TA 1'b1;
      cycle_start();
      while (bus.q_ready != 1'b1) begin cycle_end(); cycle_start(); end
      cycle_end();
      bus.q       <= #TA '0;
      bus.q_valid <= #TA 1'b0;
    endtask

    task send_rsp(input rsp_item_t rsp);
      bus.p       <= #TA rsp.p;
      bus.p_valid <= #TA 1'b1;
      cycle_start();
      while (bus.p_ready != 1'b1) begin cycle_end(); cycle_start(); end
      cycle_end();
      bus.p       <= #TA '0;
      bus.p_valid <= #TA 1'b0;
    endtask

    task recv_req(output req_item_t req);
      bus.q_ready <= #TA 1'b1;
      cycle_start();
      while (bus.q_valid != 1'b1) begin cycle_end(); cycle_start(); end
      req = new;
      req.q = bus.q;
      cycle_end();
      bus.q_ready <= #TA 1'b0;
    endtask

    task recv_rsp(output rsp_item_t rsp);
      bus.p_ready <= #TA 1'b1;
      cycle_start();
      while (bus.p_valid != 1'b1) begin cycle_end(); cycle_start(); end
      rsp = new;
      rsp.p = bus.p;
      cycle_end();
      bus.p_ready <= #TA 1'b0;
    endtask

    task mon_req(output req_item_t req);
      cycle_start();
      while (!(bus.q_valid && bus.q_ready)) begin cycle_end(); cycle_start(); end
      req = new;
      req.q = bus.q;
      cycle_end();
    endtask

    task mon_rsp(output rsp_item_t rsp);
      cycle_start();
      while (!(bus.p_valid && bus.p_ready)) begin cycle_end(); cycle_start(); end
      rsp = new;
      rsp.p = bus.p;
      cycle_end();
    endtask
  endclass

  virtual class rand_reqrsp #(
    parameter type req_chan_t = logic,
    parameter type rsp_chan_t = logic,
    parameter time TA = 0ps,
    parameter time TT = 0ps
  );
    typedef reqrsp_driver #(
      .req_chan_t (req_chan_t),
      .rsp_chan_t (rsp_chan_t),
      .TA (TA),
      .TT (TT)
    ) reqrsp_driver_t;

    reqrsp_driver_t drv;

    function new(
      virtual REQRSP_BUS_DV #(
        .req_chan_t(req_chan_t),
        .rsp_chan_t(rsp_chan_t)
      ) bus
    );
      this.drv = new(bus);
    endfunction

    task automatic rand_wait(input int unsigned min, input int unsigned max);
      int unsigned rand_success, cycles;
      rand_success = std::randomize(cycles) with {
        cycles >= min;
        cycles <= max;
        cycles dist {min := 10, [min+1:max] := 1};
      };
      assert (rand_success) else $error("Failed to randomize wait cycles!");
      repeat (cycles) @(posedge this.drv.bus.clk_i);
    endtask
  endclass

  class rand_reqrsp_master #(
    parameter type req_chan_t = logic,
    parameter type rsp_chan_t = logic,
    parameter time TA = 0ps,
    parameter time TT = 0ps,
    parameter int unsigned REQ_MIN_WAIT_CYCLES = 1,
    parameter int unsigned REQ_MAX_WAIT_CYCLES = 20,
    parameter int unsigned RSP_MIN_WAIT_CYCLES = 1,
    parameter int unsigned RSP_MAX_WAIT_CYCLES = 20
  ) extends rand_reqrsp #(
    .req_chan_t(req_chan_t), .rsp_chan_t(rsp_chan_t), .TA(TA), .TT(TT)
  );
    typedef reqrsp_test::req_t #(.req_chan_t(req_chan_t)) req_item_t;
    typedef reqrsp_test::rsp_t #(.rsp_chan_t(rsp_chan_t)) rsp_item_t;

    int unsigned cnt = 0;
    bit req_done = 0;

    task reset();
      drv.reset_master();
    endtask

    function new(
      virtual REQRSP_BUS_DV #(
        .req_chan_t(req_chan_t),
        .rsp_chan_t(rsp_chan_t)
      ) bus
    );
      super.new(bus);
    endfunction

    task run(input int n);
      fork
        send_requests(n);
        recv_responses();
      join
    endtask

    task send_requests(input int n);
      repeat (n) begin
        automatic req_item_t req = new;
        this.cnt++;
        assert(req.randomize());
        rand_wait(REQ_MIN_WAIT_CYCLES, REQ_MAX_WAIT_CYCLES);
        this.drv.send_req(req);
      end
      this.req_done = 1;
    endtask

    task recv_responses;
      while (!this.req_done || this.cnt > 0) begin
        automatic rsp_item_t rsp;
        this.cnt--;
        rand_wait(RSP_MIN_WAIT_CYCLES, RSP_MAX_WAIT_CYCLES);
        this.drv.recv_rsp(rsp);
      end
    endtask
  endclass

  class rand_reqrsp_slave #(
    parameter type req_chan_t = logic,
    parameter type rsp_chan_t = logic,
    parameter time TA = 0ps,
    parameter time TT = 0ps,
    parameter int unsigned REQ_MIN_WAIT_CYCLES = 0,
    parameter int unsigned REQ_MAX_WAIT_CYCLES = 10,
    parameter int unsigned RSP_MIN_WAIT_CYCLES = 0,
    parameter int unsigned RSP_MAX_WAIT_CYCLES = 10
  ) extends rand_reqrsp #(
    .req_chan_t(req_chan_t), .rsp_chan_t(rsp_chan_t), .TA(TA), .TT(TT)
  );
    typedef reqrsp_test::req_t #(.req_chan_t(req_chan_t)) req_item_t;
    typedef reqrsp_test::rsp_t #(.rsp_chan_t(rsp_chan_t)) rsp_item_t;

    mailbox req_mbx = new();

    task reset();
      drv.reset_slave();
    endtask

    function new(
      virtual REQRSP_BUS_DV #(
        .req_chan_t(req_chan_t),
        .rsp_chan_t(rsp_chan_t)
      ) bus
    );
      super.new(bus);
    endfunction

    task run();
      fork
        recv_requests();
        send_responses();
      join
    endtask

    task recv_requests();
      forever begin
        automatic req_item_t req;
        rand_wait(REQ_MIN_WAIT_CYCLES, REQ_MAX_WAIT_CYCLES);
        this.drv.recv_req(req);
        req_mbx.put(req);
      end
    endtask

    task send_responses();
      forever begin
        automatic req_item_t req;
        automatic rsp_item_t rsp = new;
        req_mbx.get(req);
        assert(rsp.randomize());
        @(posedge this.drv.bus.clk_i);
        rand_wait(RSP_MIN_WAIT_CYCLES, RSP_MAX_WAIT_CYCLES);
        this.drv.send_rsp(rsp);
      end
    endtask
  endclass

  class reqrsp_monitor #(
    parameter type req_chan_t = logic,
    parameter type rsp_chan_t = logic,
    parameter time TA = 0ps,
    parameter time TT = 0ps
  ) extends rand_reqrsp #(
    .req_chan_t(req_chan_t), .rsp_chan_t(rsp_chan_t), .TA(TA), .TT(TT)
  );
    typedef reqrsp_test::req_t #(.req_chan_t(req_chan_t)) req_item_t;
    typedef reqrsp_test::rsp_t #(.rsp_chan_t(rsp_chan_t)) rsp_item_t;

    mailbox req_mbx = new, rsp_mbx = new;

    function new(
      virtual REQRSP_BUS_DV #(
        .req_chan_t(req_chan_t),
        .rsp_chan_t(rsp_chan_t)
      ) bus
    );
      super.new(bus);
    endfunction

    task monitor;
      fork
        forever begin
          automatic req_item_t req;
          this.drv.mon_req(req);
          req_mbx.put(req);
        end
        forever begin
          automatic rsp_item_t rsp;
          this.drv.mon_rsp(rsp);
          rsp_mbx.put(rsp);
        end
      join
    endtask
  endclass

endpackage
