// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
// Description: Variable Register File
// verilog_lint: waive module-filename
module snitch_regfile #(
  parameter int unsigned DataWidth    = 32,
  parameter int unsigned NrReadPorts  = 2,
  parameter int unsigned NrWritePorts = 1,
  parameter bit          ZeroRegZero  = 0,
  parameter int unsigned AddrWidth    = 4
) (
  // clock and reset
  input  logic                                    clk_i,
  input  logic                                    rst_ni,
  // read port
  input  logic [NrReadPorts-1:0][AddrWidth-1:0]   raddr_i,
  output logic [NrReadPorts-1:0][DataWidth-1:0]   rdata_o,
  // write port
  input  logic [NrWritePorts-1:0][AddrWidth-1:0]  waddr_i,
  input  logic [NrWritePorts-1:0][DataWidth-1:0]  wdata_i,
  input  logic [NrWritePorts-1:0]                 we_i
);

  localparam int unsigned NumWords  = 2**AddrWidth;

  logic [NumWords-1:0][DataWidth-1:0]     mem;
  logic [NrWritePorts-1:0][NumWords-1:0] we_dec;


  always_comb begin : we_decoder
    for (int unsigned j = 0; j < NrWritePorts; j++) begin
      for (int unsigned i = 0; i < NumWords; i++) begin
        if (waddr_i[j] == i) we_dec[j][i] = we_i[j];
        else we_dec[j][i] = 1'b0;
      end
    end
  end

  // loop from 1 to NumWords-1 as R0 is nil
  always_ff @(posedge clk_i, negedge rst_ni) begin : register_write_behavioral
    if (~rst_ni) begin
      mem <= '0;
    end else begin
      for (int unsigned j = 0; j < NrWritePorts; j++) begin
        for (int unsigned i = 0; i < NumWords; i++) begin
          if (we_dec[j][i]) begin
            mem[i] <= wdata_i[j];
          end
        end
      end
      if (ZeroRegZero) begin
        mem[0] <= '0;
      end
    end
  end

  for (genvar i = 0; i < NrReadPorts; i++) begin : gen_read_port
    assign rdata_o[i] = mem[raddr_i[i]];
  end

endmodule
