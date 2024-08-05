// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// Yunhao Deng <yunhao.deng@kuleuven.be>

module VerilogMemset #(
    parameter int UserCsrNum = 1,
    parameter int DataWidth = 512
) (
    input  logic clk_i,
    input  logic rst_ni,
    output logic ext_data_i_ready,
    input  logic ext_data_i_valid,
    input  logic [DataWidth-1:0] ext_data_i_bits,
    input  logic ext_data_o_ready,
    output logic ext_data_o_valid,
    output logic [DataWidth-1:0] ext_data_o_bits,
    input  logic [31:0]ext_csr_i_0,
    input  logic ext_start_i,
    output logic ext_busy_o
);

    assign ext_data_o_valid = ext_data_i_valid;
    assign ext_data_i_ready = ext_data_o_ready;
    logic [7:0] memset_data;
    assign memset_data = ext_csr_i_0[7:0];

    genvar i;
    generate
        for(i = 0; i < DataWidth/8; i = i + 1) begin: g_memset
            assign ext_data_o_bits[i*8 +: 8] = memset_data;
        end
    endgenerate
    assign ext_busy_o = 0;
endmodule
