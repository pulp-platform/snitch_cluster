//--------------------------------------------------------------------
// Copyright 2023 Katolieke Universiteit Leuven (KUL)
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Xiaoling Yi (xiaoling.yi@kuleuven.be)
//--------------------------------------------------------------------

// verilog_lint: waive-start line-length
// verilog_lint: waive-start no-trailing-spaces

module gemm_controller (
    input     logic                           clk_i,
    input     logic                           rst_ni,
    input     logic       [4:0]               M_in,
    input     logic       [4:0]               K_in,
    input     logic       [4:0]               N_in,
    input     logic                           config_valid,
    input     logic                           io_data_out_valid,

    input     logic       [31:0]               addr_a_in,
    input     logic       [31:0]               addr_b_in,
    input     logic       [31:0]               addr_c_in,

    output     logic                           gemm_read,
    output     logic                           gemm_write,

    output     logic       [31:0]               addr_a_out,
    output     logic       [31:0]               addr_b_out,
    output     logic       [31:0]               addr_c_out,

);
    localparam int unsigned InputMatrixSizeA  = 8 * 8 * 8;
    localparam int unsigned InputMatrixSizeB  = 8 * 8 * 8;
    localparam int unsigned OutputMatrixSizeC = 8 * 8 * 32;

    logic [4:0] M;
    logic [4:0] N;
    logic [4:0] K;

    logic [4:0] M_counter;
    logic [4:0] N_counter;
    logic [4:0] K_counter;
    logic gemm_done;

    always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        M <= '0;
        K <= '0;
        N <= '0;
    end else if(config_valid) begin
        M <= M_in;
        K <= K_in;
        N <= N_in;
    end
    end

    always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni || config_valid) begin
        K_counter <= 5'b1;
    end else if((io_data_out_valid == 1) && (K_counter != K - 1)) begin
        K_counter <= K_counter + 1'b1;
    end else if((io_data_out_valid == 1) && (K_counter == K - 1)) begin
        K_counter <= 5'b0;
    end
    end

    always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        N_counter <= 5'b0;
    end else if((K_counter == K - 1) && (N_counter != N_counter - 1) ) begin
        N_counter <= N_counter + 1'b1;
    end else if((K_counter == K - 1) && (N_counter == N - 1) ) begin
        N_counter <= 5'b0;
    end
    end

    always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        M_counter <= 5'0;
    end else if((K_counter == K - 1) && (N_counter == N - 1)) begin
        M_counter <= M_counter + 1'b1;
    end
    end

    assign gemm_done = (M_counter == M - 1) && (N_counter == N - 1) && (K_counter == K - 1);
    assign gemm_read = io_data_out_valid & (!gemm_done);
    assign gemm_write = K_counter == K - 1;

    assign addr_a_out = InputMatrixSizeA * (M_counter * K + K_counter);
    assign addr_b_out = InputMatrixSizeB * (N_counter * K + K_counter);
    assign addr_c_out = InputMatrixSizeC * (M_counter * N + N_counter);

endmodule