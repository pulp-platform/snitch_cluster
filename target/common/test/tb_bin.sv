// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// RTL Top-level for `fesvr` simulation.
module tb_bin;
  import "DPI-C" function int fesvr_tick();
  import "DPI-C" function void fesvr_cleanup();

  // This can't have an explicit type, otherwise the simulation will not advance
  // for whatever reason.
  // verilog_lint: waive explicit-parameter-storage-type
  localparam TCK = 1ns;

  logic rst_ni, clk_i;

  testharness i_dut (
    .clk_i,
    .rst_ni
  );

  // Function to generate a random delay between min and max
  function int random_delay(int min, int max);
    automatic int range;
    begin
      if (min > max) begin
        // Swap if min is greater than max
        automatic int temp = min;
        min = max;
        max = temp;
      end
      range = max - min + 1;
      return min + ($urandom % range);
    end
  endfunction

  // Generate reset
  initial begin
    automatic real rst_delay;
    rst_ni = 0;
    rst_delay = random_delay(10,20);
    #rst_delay;
    rst_ni = 1;
    rst_delay = random_delay(10,20);
    #rst_delay;
    rst_ni = 0;
    rst_delay = random_delay(10,20);
    #rst_delay;
    rst_ni = 1;
  end

  // Generate clock
  initial begin
    forever begin
      clk_i = 1;
      #(TCK/2);
      clk_i = 0;
      #(TCK/2);
    end
  end

  // Start `fesvr`
  initial begin
    automatic int exit_code;
    while ((exit_code = fesvr_tick()) == 0) #200ns;
    // Cleanup C++ simulation objects before $finish is called
    fesvr_cleanup();
    exit_code >>= 1;
    if (exit_code > 0) begin
      $error("[FAILURE] Finished with exit code %2d", exit_code);
    end else begin
      $info("[SUCCESS] Program finished successfully");
    end
    $finish;
  end

endmodule
