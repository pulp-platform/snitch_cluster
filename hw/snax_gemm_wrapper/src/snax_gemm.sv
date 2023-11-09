//--------------------------------------------------------------------
// Copyright 2023 Katolieke Universiteit Leuven (KUL)
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Xiaoling Yi (xiaoling.yi@kuleuven.be)
//--------------------------------------------------------------------

// verilog_lint: waive-start line-length
// verilog_lint: waive-start no-trailing-spaces

import riscv_instr::*;
import reqrsp_pkg::*;

module snax_gemm # (
  parameter int unsigned DataWidth     = 64,
  parameter int unsigned SnaxTcdmPorts = 16,
  parameter type         acc_req_t     = logic,
  parameter type         acc_rsp_t     = logic,
  parameter type         tcdm_req_t    = logic,
  parameter type         tcdm_rsp_t    = logic
)(
  input     logic                           clk_i,
  input     logic                           rst_ni,

  input     logic                           snax_qvalid_i,
  output    logic                           snax_qready_o,
  input     acc_req_t                       snax_req_i,

  output    acc_rsp_t                       snax_resp_o,
  output    logic                           snax_pvalid_o,
  input     logic                           snax_pready_i,

  output    tcdm_req_t  [SnaxTcdmPorts-1:0] snax_tcdm_req_o,
  input     tcdm_rsp_t  [SnaxTcdmPorts-1:0] snax_tcdm_rsp_i
);

  // Local parameters for input and output sizes
  localparam int unsigned InputMatrixSize  = DataWidth*SnaxTcdmPorts/2;
  localparam int unsigned OutputMatrixSize = InputMatrixSize*4;          // x4 because of multiplication and addition considerations

  // CSRs
  localparam int unsigned RegNum        = 5;
  localparam int unsigned CsrAddrOFfset = 32'h3c0;

  logic [31:0] CSRs [RegNum];
  logic [31:0] csr_addr;

  logic write_csr;
  logic read_csr;


  // Gemm wires
  logic [ InputMatrixSize-1:0] io_a_io_in;
  logic [ InputMatrixSize-1:0] io_b_io_in;
  logic [OutputMatrixSize-1:0] io_c_io_out;
  logic [OutputMatrixSize / 2 -1:0] io_c_io_out_reg;
  logic      io_start_do;
  logic      io_data_in_valid;
  logic      io_data_out_valid;

  localparam int unsigned HalfC         = InputMatrixSize*2;
  localparam int unsigned HalfHalfCAddr = HalfC/2/8;
  localparam int unsigned HalfCAddr     = HalfC/8;
  localparam int unsigned HalfHalfC     = HalfC/2;
  
  // 2 cycle to write data out because output is 8 * 8 * 32bits = 2048.
  // But TCDM has 16 ports only (2048 / (16 * 32) = 2).
  logic read_tcdm;
  logic write_tcdm_1;
  logic write_tcdm_2;
  logic read_tcdm_done;
  logic write_tcdm_done;
  logic write_tcdm_done_1;
  logic write_tcdm_done_2;
  logic tcdm_not_ready;
  logic [SnaxTcdmPorts-1:0] snax_tcdm_rsp_i_p_valid;
  logic [SnaxTcdmPorts-1:0] snax_tcdm_req_o_q_valid;

  // Gemm control states, we have 3 states currently.
  // By default, the state is IDLE_GEMM
  // When io_start_do assert, we send read data request and turn to COMP_GEMM
  // When io_data_out_valid assert, we write back the least half of results to TCDM and turn to WRITE_GEMM
  // Afterwards, we turn to IDLE_GEMM.
  typedef enum logic [2:0] {
    IDLE_GEMM,
    COMP_GEMM,
    WRITE_GEMM
  } ctrl_states_t;

  ctrl_states_t cstate, nstate;

  // Write CSRs
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      for (int i=0; i < RegNum - 1; i++) begin
        CSRs[i] <= 32'd0;
      end     
      CSRs[4] <= 32'd1;
    end else begin
      if(write_csr == 1'b1 && io_start_do != 1'b1) begin
        CSRs[csr_addr] <= snax_req_i.data_arga[31:0];
      end 
      else begin
        if (io_start_do == 1'b1) begin
          CSRs[4] <= 32'd0;          
        end        
        else if (write_tcdm_done_2 == 1'b1) begin
          CSRs[4] <= 32'd1;
        end
      end
    end
  end

  // Read CSRs
  always_comb begin
    if (!rst_ni) begin
        snax_resp_o.data  = 0;
        snax_resp_o.id    = 0;
        snax_resp_o.error = 1'b0;
        snax_pvalid_o     = 1'b0;        
    end else begin
      if(read_csr) begin
        snax_resp_o.data  = {32'b0,CSRs[csr_addr]};
        snax_resp_o.id    = snax_req_i.id;
        snax_resp_o.error = 1'b0;
        snax_pvalid_o     = 1'b1;
      end
      else begin
        snax_resp_o.data  = 0;
        snax_resp_o.id    = 0;
        snax_resp_o.error = 1'b0;
        snax_pvalid_o     = 1'b0;        
      end
    end
  end

  // Read or write control logic
  always_comb begin
    if (!rst_ni) begin
      read_csr = 1'b0;
      write_csr = 1'b0;      
    end
    else if(snax_qvalid_i) begin
      unique casez (snax_req_i.data_op)
        CSRRS, CSRRSI, CSRRC, CSRRCI: begin
          read_csr  = 1'b1;
          write_csr = 1'b0;
        end
        default: begin
          write_csr = 1'b1;
          read_csr  = 1'b0;
        end
      endcase      
    end   
    else begin
      read_csr  = 1'b0;
      write_csr = 1'b0;
    end
  end

  assign snax_qready_o = 1'b1;
  assign csr_addr = snax_req_i.data_argb - CsrAddrOFfset;

  Gemm inst_gemm(
    .clock             ( clk_i             ),   // <stdin>:9016:11
    .reset             ( !rst_ni           ),   // <stdin>:9017:11
    .io_data_in_valid  ( io_data_in_valid  ),   // src/main/scala/gemm/gemm.scala:309:16
    .io_a_io_in        ( io_a_io_in        ),   // src/main/scala/gemm/gemm.scala:309:16
    .io_b_io_in        ( io_b_io_in        ),   // src/main/scala/gemm/gemm.scala:309:16
    .io_data_out_valid ( io_data_out_valid ),   // src/main/scala/gemm/gemm.scala:309:16
    .io_c_io_out       ( io_c_io_out       )    // src/main/scala/gemm/gemm.scala:309:16
  );

  // Holding output
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      io_c_io_out_reg <= 0;
    end else begin
      if (io_data_out_valid) begin
        io_c_io_out_reg <= io_c_io_out[OutputMatrixSize - 1: OutputMatrixSize / 2];
      end
    end
  end

  // Changing states
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      cstate <= IDLE_GEMM;
    end else begin
      cstate <= nstate;
    end
  end

  // Next state changes
  always_comb begin
    case(cstate)
      IDLE_GEMM: begin
        if (io_start_do) begin
          nstate = COMP_GEMM;
        end else begin
          nstate = IDLE_GEMM;
        end
      end 
      COMP_GEMM: begin
        if (write_tcdm_done_1) begin 
          nstate = WRITE_GEMM;
        end else begin
          nstate = COMP_GEMM;
        end
      end          
      WRITE_GEMM: begin
        if (write_tcdm_done_2) begin 
          nstate = IDLE_GEMM;
        end else begin
          nstate = WRITE_GEMM;
        end
      end    
      default: begin
        nstate = IDLE_GEMM;
      end
    endcase

  end

  assign io_start_do = snax_qvalid_i & (csr_addr == 3) & snax_qready_o;

  // read data from TCDM and write data to TCDM

  always_comb begin
      for (int i = 0; i < SnaxTcdmPorts / 2; i++) begin
        if(!rst_ni) begin
          snax_tcdm_req_o[i].q_valid = 1'b0;
          snax_tcdm_req_o[i].q.addr  = 17'b0;
          snax_tcdm_req_o[i].q.write = 1'b0;
          snax_tcdm_req_o[i].q.amo  = AMONone;
          snax_tcdm_req_o[i].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o[i].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o[i].q.user = '0;

          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q_valid = 1'b0;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.addr  = 17'b0;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.write = 1'b0;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.user = '0;          
        end
        else if(read_tcdm) begin
          snax_tcdm_req_o[i].q_valid = 1'b1;
          snax_tcdm_req_o[i].q.addr  = CSRs[0] + i * 8;
          snax_tcdm_req_o[i].q.write = 1'b0;
          snax_tcdm_req_o[i].q.amo  = AMONone;
          snax_tcdm_req_o[i].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o[i].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o[i].q.user = '0;

          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q_valid = 1'b1;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.addr  = CSRs[1] + i * 8;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.write = 1'b0;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.user = '0;                    
        end
        else if(write_tcdm_1) begin
          snax_tcdm_req_o[i].q_valid = 1'b1;
          snax_tcdm_req_o[i].q.addr  = CSRs[2] + i * 8;
          snax_tcdm_req_o[i].q.write = 1'b1;
          snax_tcdm_req_o[i].q.amo  = AMONone;
          snax_tcdm_req_o[i].q.data = io_c_io_out[i * DataWidth +: DataWidth];
          snax_tcdm_req_o[i].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o[i].q.user = '0;

          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q_valid = 1'b1;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.addr  = CSRs[2] + i * 8 + HalfHalfCAddr;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.write = 1'b1;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.data = io_c_io_out[(i * DataWidth + HalfHalfC) +: DataWidth];
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.user = '0;                   
        end  
        else if(write_tcdm_2) begin
          snax_tcdm_req_o[i].q_valid = 1'b1;
          snax_tcdm_req_o[i].q.addr  = CSRs[2] + i * 8 + HalfCAddr;
          snax_tcdm_req_o[i].q.write = 1'b1;
          snax_tcdm_req_o[i].q.amo  = AMONone;
          snax_tcdm_req_o[i].q.data = io_c_io_out_reg[(i * DataWidth) +: DataWidth];
          snax_tcdm_req_o[i].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o[i].q.user = '0;

          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q_valid = 1'b1;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.addr  = CSRs[2] + i * 8 + HalfCAddr + HalfHalfCAddr;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.write = 1'b1;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.data = io_c_io_out_reg[(i * DataWidth + HalfHalfC) +: DataWidth];
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.user = '0;                    
        end              
        else begin
          snax_tcdm_req_o[i].q_valid = 1'b0;
          snax_tcdm_req_o[i].q.addr  = 17'b0;
          snax_tcdm_req_o[i].q.write = 1'b0;
          snax_tcdm_req_o[i].q.amo  = AMONone;
          snax_tcdm_req_o[i].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o[i].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o[i].q.user = '0;        

          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q_valid = 1'b0;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.addr  = 17'b0;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.write = 1'b0;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o[i + SnaxTcdmPorts / 2].q.user = '0;                  
        end 
      end
  end 

  always_comb begin
    if (!rst_ni) begin
        io_a_io_in = 512'b0;        
        io_b_io_in = 512'b0;        
    end else begin
      for (int i = 0; i < SnaxTcdmPorts / 2; i++) begin
        if(io_data_in_valid) begin
          io_a_io_in[i * DataWidth +: DataWidth] = snax_tcdm_rsp_i[i].p.data;
          io_b_io_in[i * DataWidth +: DataWidth] = snax_tcdm_rsp_i[i + SnaxTcdmPorts / 2].p.data;
        end
        else begin
          io_a_io_in[i * DataWidth +: DataWidth] = 0;
          io_b_io_in[i * DataWidth +: DataWidth] = 0;
        end
      end
    end
  end  

  always_comb begin
      for (int i = 0; i < SnaxTcdmPorts; i++) begin
        if(!rst_ni) begin
          snax_tcdm_rsp_i_p_valid[i] = 1'b0;
          snax_tcdm_req_o_q_valid[i] = 1'b0;
        end
        else begin
          snax_tcdm_rsp_i_p_valid[i] = snax_tcdm_rsp_i[i].p_valid;
          snax_tcdm_req_o_q_valid[i] = snax_tcdm_req_o[i].q_valid;
        end 
      end
  end 

  assign tcdm_not_ready    = ~io_data_in_valid;
  assign io_data_in_valid  = ((&snax_tcdm_rsp_i_p_valid) === 1'b1 && (cstate == COMP_GEMM))? 1'b1 : 1'b0;
  assign read_tcdm         = io_start_do;
  assign write_tcdm_1      = io_data_out_valid;
  assign write_tcdm_2      = cstate                               == WRITE_GEMM;
  assign read_tcdm_done    = io_data_in_valid;
  assign write_tcdm_done_1 = (&snax_tcdm_req_o_q_valid) && cstate == COMP_GEMM;
  assign write_tcdm_done_2 = (&snax_tcdm_req_o_q_valid) && cstate == WRITE_GEMM;
  assign write_tcdm_done   = write_tcdm_done_1 & write_tcdm_done_2;

endmodule
