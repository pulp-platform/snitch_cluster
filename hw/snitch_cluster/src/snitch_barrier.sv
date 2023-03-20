// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`include "common_cells/registers.svh"

/// Hardware barrier to synchronize all cores in a cluster.
module snitch_barrier #(
  parameter int NrCores = 0
) (
  input  logic               clk_i,
  input  logic               rst_ni,
  input  logic [NrCores-1:0] barrier_i,
  output logic               barrier_o
);

  logic [NrCores-1:0] arrival_d, arrival_q;

  generate
    for (genvar i = 0; i < NrCores; i++) begin : gen_arrival_bit

      `FF(arrival_q[i], arrival_d[i], 1'b0, clk_i, rst_ni)

      always_comb begin
        if (barrier_o) arrival_d[i] = 1'b0;
        else if (barrier_i[i]) arrival_d[i] = 1'b1;
        else arrival_d[i] = arrival_q[i];
      end

    end
  endgenerate

  assign barrier_o = &arrival_q;

endmodule
