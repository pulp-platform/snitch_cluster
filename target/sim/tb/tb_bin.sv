// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// RTL Top-level for `fesvr` simulation.
module tb_bin;
  import "DPI-C" function int fesvr_tick();
  import "DPI-C" function void fesvr_cleanup();

  parameter realtime ClkPeriod = 1ns;

  testharness #(
    .ClkPeriod(ClkPeriod)
  ) fix();

  // Start `fesvr`
  initial begin
    automatic int exit_code;
    // Poll fesvr for exit code
    while ((exit_code = fesvr_tick()) == 0) #200ns;
    // Cleanup C++ simulation objects before $finish is called
    fesvr_cleanup();
    // Wait a couple hundred cycles for the binary to complete,
    // as a few instructions usually follow the exit routine,
    // and we need the core traces to be complete.
    #(200*ClkPeriod);
    // Return the exit code
    exit_code >>= 1;
    if (exit_code > 0) begin
      $error("[FAILURE] Finished with exit code %2d", exit_code);
    end else begin
      $info("[SUCCESS] Program finished successfully");
    end
    $finish;
  end

endmodule
