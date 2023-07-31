//---------------------------------------------
// Copyright 2023 Katolieke Universiteit Leuven (KUL)
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
// Author: Ryan Antonio (ryan.antonio@kuleuven.be)
//---------------------------------------------
// Description:
// A dummy memory that can be generated for convenience
// This assumes byte addressability and double word aligned
//---------------------------------------------

module tb_dummy_memory #(
  parameter int unsigned MemoryWidth  = 64,
  parameter int unsigned MemorySize   = 1024,
  parameter type         tcdm_req_t   = logic,
  parameter type         tcdm_rsp_t   = logic,
  parameter              ForceInitVal = 0,
  parameter              InitVal      = "./mem/data/zero_dm.txt"
)(
  input   logic          clk_i,
  input   logic          rst_ni,
  input   tcdm_req_t     data_req_i,
  output  tcdm_rsp_t     data_rsp_o
);


    logic [MemoryWidth-1:0] data_mem [0:255];

    // If initialization is necessary
    if(ForceInitVal) begin: gen_init_mem_values
        initial begin
            $readmemh(InitVal,data_mem);
        end
    end

    // This signal is to fake a start-up because starting immediately on a load
    // Messes up the simulation so we need to have a "fake" start-up
    logic start_mem;
    logic [MemoryWidth-1:0] data_addr_offset;
    logic [MemoryWidth-1:0] next_data_mem;

    assign data_addr_offset = data_req_i.q.addr >> 3;
    assign next_data_mem    = data_mem[data_addr_offset];

    // Seperate start memory for now
    always_ff @ (posedge clk_i or negedge rst_ni) begin
        if(!rst_ni) begin
            start_mem <= 1'b0;
        end else begin
            if(!start_mem) begin
                start_mem <= 1'b1;
            end else begin
                start_mem <= start_mem;
            end
        end
    end

    // Main memory control incorporated in the fake startup
    always_ff @ (posedge clk_i or negedge rst_ni) begin
        if(!rst_ni) begin
            data_rsp_o.p_valid <= 1'b0;
            data_rsp_o.p.data  <= 64'd0;
        end else begin
            data_rsp_o.p_valid <= (start_mem) ? data_rsp_o.q_ready & data_req_i.q_valid: 1'b0;
            data_rsp_o.p.data  <= (start_mem) ? next_data_mem : '0;
        end
    end

    // Synchronized writing of data since this messes up the simulation
    // Need to accommodate memory multiplexing for this part
    // Let's assume first that no arbitration is set
    always @ (posedge clk_i) begin

        if((data_req_i.q.write  & data_req_i.q_valid) & data_rsp_o.q_ready) begin
            data_mem[data_addr_offset] <= data_req_i.q.data;
        end

    end

    assign data_rsp_o.q_ready = (start_mem) ? 1'b1 : 1'b0;
    


endmodule


/*-------- Module Usage --------

    tb_dummy_memory #(
        .MemoryWidth  ( MemoryWidth  ), 
        .MemorySize   ( MemorySize   ),
        .reqrsp_req_t ( reqrsp_req_t ),
        .reqrsp_rsp_t ( reqrsp_rsp_t ),
        .ForceInitVal ( ForceInitVal ),
        .InitVal      ( InitVal      )
    ) i_tb_dummy_memory (
        .clk_i        ( clk_i        ),
        .rst_ni       ( rst_ni       ),
        .data_req_i   ( data_req_i   ),
        .data_rsp_o   ( data_rsp_o   )
    );

--------------------------------*/