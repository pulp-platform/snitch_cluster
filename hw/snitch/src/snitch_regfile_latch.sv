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
  parameter bit          ZeroRegZero  = 1,
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

  localparam int unsigned NumWords = 2**AddrWidth;

  logic clk;
  logic [NumWords-1:0] mem_clocks;

  logic [NumWords-1:0][DataWidth-1:0]     mem;

  logic [NrWritePorts-1:0][DataWidth-1:0] wdata_q;
  logic [NrWritePorts-1:0][NumWords-1:0]  waddr_onehot;
  logic [NumWords-1:0][NrWritePorts-1:0]  waddr_onehot_trans; // transposed index version

  for (genvar i = 0; i < NrWritePorts; i++) begin : gen_oh_write_ports
    for (genvar j = 0; j < NumWords; j++) begin : gen_oh_words
      assign waddr_onehot_trans[j][i] = waddr_onehot[i][j];
    end
  end

  tc_clk_gating i_regfile_cg (
    .clk_i,
    .en_i      ( |we_i  ),
    .test_en_i ( 1'b0   ),
    .clk_o     ( clk    )
  );

  // Sample Input Data
  for (genvar i = 0; i < NrWritePorts; i++) begin : gen_data_ports

    `FF(wdata_q[i], wdata_i[i], '0, clk, rst_ni)

    for (genvar j = ZeroRegZero; j < NumWords; j++) begin : gen_data_words
      always_comb begin
        if (we_i[i] && waddr_i[i] == j) waddr_onehot[i][j] = 1'b1;
        else waddr_onehot[i][j] = 1'b0;
      end
    end
  end

  for (genvar i = 0; i <  NumWords; i++) begin : gen_clk_gate
    tc_clk_gating i_regfile_cg (
      .clk_i     ( clk                    ),
      .en_i      ( |waddr_onehot_trans[i] ),
      .test_en_i ( 1'b0                   ),
      .clk_o     ( mem_clocks[i]          )
    );
  end

  always_latch begin
    if (ZeroRegZero) mem[0] = '0;

    for (int unsigned i = ZeroRegZero; i < NumWords; i++) begin : gen_read_words
      for (int unsigned j = 0; j < NrWritePorts; j++) begin : gen_read_ports
        if (mem_clocks[i]) begin
          // TODO(zarubaf) generalize to more than 1 read port
          mem[i] = wdata_q[j];
        end
      end
    end
  end

  for (genvar i = 0; i < NrReadPorts; i++) assign rdata_o[i] = mem[raddr_i[i][AddrWidth-1:0]];

endmodule
