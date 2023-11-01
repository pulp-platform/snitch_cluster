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
// `include "csr_def.svh"

module snax_gemm # (
  parameter int unsigned DataWidth     = 64,
  parameter int unsigned SnaxTcdmPorts = 24,
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

  // CSR addresses setting
  localparam int unsigned Address_A_CSR = 32'h3c0;
  localparam int unsigned Address_B_CSR = 32'h3c1;
  localparam int unsigned Address_C_CSR = 32'h3c2;

  localparam int unsigned B_M_K_N_CSR = 32'h3c3;

  localparam int unsigned ldA_CSR = 32'h3c4;
  localparam int unsigned ldB_CSR = 32'h3c5;
  localparam int unsigned ldC_CSR = 32'h3c6;

  localparam int unsigned StrideA_CSR = 32'h3c7;
  localparam int unsigned StrideB_CSR = 32'h3c8;
  localparam int unsigned StrideC_CSR = 32'h3c9;

  localparam int unsigned STATE_CSR = 32'h3ca;

  // Local parameters for input and output sizes
  localparam int unsigned InputTcdmPorts = 16;
  localparam int unsigned OutputTcdmPorts = 8;
  localparam int unsigned InputMatrixSize  = DataWidth * SnaxTcdmPorts / 2;
  localparam int unsigned OutputMatrixSize = DataWidth * OutputTcdmPorts;          // x4 because of multiplication and addition considerations

  // CSRs
  localparam int unsigned RegNum        = 11;
  localparam int unsigned CsrAddrOFfset = 32'h3c0;

  logic [31:0] CSRs [RegNum];
  logic [31:0] csr_addr;

  logic write_csr;
  logic read_csr;

  // Gemm wires
  logic [ InputMatrixSize-1:0] io_data_a_i;
  logic [ InputMatrixSize-1:0] io_data_b_i;
  logic [OutputMatrixSize-1:0] io_data_multi_stage_c_o;

  logic      io_ctrl_start_do_i;
  logic      io_ctrl_data_valid_i;
  logic      io_ctrl_gemm_read_valid_o;
  logic io_ctrl_gemm_write_valid_o;
  logic io_ctrl_busy_o;

  logic [7:0] io_ctrl_B_i;
  logic [7:0] io_ctrl_M_i;
  logic [7:0] io_ctrl_K_i;
  logic [7:0] io_ctrl_N_i;

  logic [31:0] io_ctrl_ptr_addr_a_i;
  logic [31:0] io_ctrl_ptr_addr_b_i;
  logic [31:0] io_ctrl_ptr_addr_c_i;

  logic [31:0] io_ctrl_ldA_i;
  logic [31:0] io_ctrl_ldB_i;
  logic [31:0] io_ctrl_ldC_i;

  logic [31:0] io_ctrl_strideA_i;
  logic [31:0] io_ctrl_strideB_i;
  logic [31:0] io_ctrl_strideC_i;

  logic [31:0] io_ctrl_addr_a_o;
  logic [31:0] io_ctrl_addr_b_o;
  logic [31:0] io_ctrl_addr_c_o;

  logic [InputTcdmPorts-1:0] snax_tcdm_rsp_i_p_valid;
  tcdm_req_t  [InputTcdmPorts-1:0] snax_tcdm_req_o_input;
  tcdm_req_t  [OutputTcdmPorts-1:0] snax_tcdm_req_o_output;

  // Write CSRs
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      for (int i=0; i < RegNum - 1; i++) begin
        CSRs[i] <= 32'd0;
      end     
      CSRs[STATE_CSR - CsrAddrOFfset] <= 32'd1;
    end else begin
      if(write_csr == 1'b1 && io_ctrl_busy_o != 1'b1) begin
        CSRs[csr_addr] <= snax_req_i.data_arga[31:0];
      end 
      else begin
        if (io_ctrl_busy_o == 1'b1) begin
          CSRs[STATE_CSR - CsrAddrOFfset] <= 32'd0;          
        end        
        else if (io_ctrl_busy_o == 1'b0) begin
          CSRs[STATE_CSR - CsrAddrOFfset] <= 32'd1;
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

  // configuration of gemm
  assign io_ctrl_B_i = CSRs[B_M_K_N_CSR - CsrAddrOFfset][31:24];
  assign io_ctrl_M_i = CSRs[B_M_K_N_CSR - CsrAddrOFfset][23:16];
  assign io_ctrl_K_i = CSRs[B_M_K_N_CSR - CsrAddrOFfset][15:8];
  assign io_ctrl_N_i = CSRs[B_M_K_N_CSR - CsrAddrOFfset][7:0];

  assign io_ctrl_ptr_addr_a_i = CSRs[Address_A_CSR - CsrAddrOFfset];
  assign io_ctrl_ptr_addr_b_i = CSRs[Address_B_CSR - CsrAddrOFfset];
  assign io_ctrl_ptr_addr_c_i = CSRs[Address_C_CSR - CsrAddrOFfset];

  assign io_ctrl_ldA_i = CSRs[ldA_CSR - CsrAddrOFfset];
  assign io_ctrl_ldB_i = CSRs[ldB_CSR - CsrAddrOFfset];
  assign io_ctrl_ldC_i = CSRs[ldC_CSR - CsrAddrOFfset];

  assign io_ctrl_strideA_i = CSRs[StrideA_CSR - CsrAddrOFfset];
  assign io_ctrl_strideB_i = CSRs[StrideB_CSR - CsrAddrOFfset];
  assign io_ctrl_strideC_i = CSRs[StrideC_CSR - CsrAddrOFfset];

  BatchGemmTCDMWritePortsMultiOutput inst_BatchGemmTCDMWritePortsMultiOutput (
    .clock(clk_i), 
    .reset(!rst_ni),
    .io_ctrl_M_i(io_ctrl_M_i),
    .io_ctrl_K_i(io_ctrl_K_i),
    .io_ctrl_N_i(io_ctrl_N_i),
    .io_ctrl_start_do_i(io_ctrl_start_do_i),
    .io_ctrl_data_valid_i(io_ctrl_data_valid_i),
    .io_ctrl_ptr_addr_a_i(io_ctrl_ptr_addr_a_i),
    .io_ctrl_ptr_addr_b_i(io_ctrl_ptr_addr_b_i),
    .io_ctrl_ptr_addr_c_i(io_ctrl_ptr_addr_c_i),
    .io_ctrl_B_i(io_ctrl_B_i),
    .io_ctrl_ldA_i(io_ctrl_ldA_i),
    .io_ctrl_ldB_i(io_ctrl_ldB_i),
    .io_ctrl_ldC_i(io_ctrl_ldC_i),
    .io_ctrl_strideA_i(io_ctrl_strideA_i),
    .io_ctrl_strideB_i(io_ctrl_strideB_i),
    .io_ctrl_strideC_i(io_ctrl_strideC_i),
    .io_data_a_i(io_data_a_i),
    .io_data_b_i(io_data_b_i),
    .io_ctrl_gemm_read_valid_o(io_ctrl_gemm_read_valid_o),
    .io_ctrl_gemm_write_valid_o(io_ctrl_gemm_write_valid_o),
    .io_ctrl_addr_a_o(io_ctrl_addr_a_o),
    .io_ctrl_addr_b_o(io_ctrl_addr_b_o),
    .io_ctrl_addr_c_o(io_ctrl_addr_c_o),
    .io_ctrl_busy_o(io_ctrl_busy_o),
    .io_data_c_o(),
    .io_data_multi_stage_c_o(io_data_multi_stage_c_o)
  );

  assign io_ctrl_start_do_i = snax_qvalid_i && (csr_addr == (STATE_CSR - CsrAddrOFfset)) && snax_qready_o && snax_req_i.data_arga[0] == 1'b1;

  // request for reading data from TCDM and writing data to TCDM
  always_comb begin
      for (int i = 0; i < InputTcdmPorts / 2; i++) begin
        if(!rst_ni) begin
          snax_tcdm_req_o_input[i].q_valid = 1'b0;
          snax_tcdm_req_o_input[i].q.addr  = 17'b0;
          snax_tcdm_req_o_input[i].q.write = 1'b0;
          snax_tcdm_req_o_input[i].q.amo  = AMONone;
          snax_tcdm_req_o_input[i].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o_input[i].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o_input[i].q.user = '0;

          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q_valid = 1'b0;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.addr  = 17'b0;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.write = 1'b0;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.user = '0;          
        end
        else if(io_ctrl_gemm_read_valid_o) begin
          snax_tcdm_req_o_input[i].q_valid = 1'b1;
          snax_tcdm_req_o_input[i].q.addr  = io_ctrl_addr_a_o + i * 8;
          snax_tcdm_req_o_input[i].q.write = 1'b0;
          snax_tcdm_req_o_input[i].q.amo  = AMONone;
          snax_tcdm_req_o_input[i].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o_input[i].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o_input[i].q.user = '0;

          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q_valid = 1'b1;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.addr  = io_ctrl_addr_b_o + i * 8;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.write = 1'b0;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b1}};
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.user = '0;                    
        end
              
        else begin
          snax_tcdm_req_o_input[i].q_valid = 1'b0;
          snax_tcdm_req_o_input[i].q.addr  = 17'b0;
          snax_tcdm_req_o_input[i].q.write = 1'b0;
          snax_tcdm_req_o_input[i].q.amo  = AMONone;
          snax_tcdm_req_o_input[i].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o_input[i].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o_input[i].q.user = '0;        

          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q_valid = 1'b0;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.addr  = 17'b0;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.write = 1'b0;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.amo  = AMONone;
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o_input[i + InputTcdmPorts / 2].q.user = '0;                  
        end 
      end
  end 

  always_comb begin
    for (int i = 0; i < OutputTcdmPorts; i = i + 1) begin
      if(!rst_ni) begin
            snax_tcdm_req_o_output[i].q_valid = 1'b0;
            snax_tcdm_req_o_output[i].q.addr  = 17'b0;
            snax_tcdm_req_o_output[i].q.write = 1'b0;
            snax_tcdm_req_o_output[i].q.amo  = AMONone;
            snax_tcdm_req_o_output[i].q.data = {DataWidth{1'b0}};
            snax_tcdm_req_o_output[i].q.strb = {(DataWidth / 8){1'b0}};
            snax_tcdm_req_o_output[i].q.user = '0;       
      end
          else if(io_ctrl_gemm_write_valid_o) begin
            snax_tcdm_req_o_output[i].q_valid = 1'b1;
            snax_tcdm_req_o_output[i].q.addr  = io_ctrl_addr_c_o + i * 8;
            snax_tcdm_req_o_output[i].q.write = 1'b1;
            snax_tcdm_req_o_output[i].q.amo  = AMONone;
            snax_tcdm_req_o_output[i].q.data = io_data_multi_stage_c_o[i * DataWidth +: DataWidth];
            snax_tcdm_req_o_output[i].q.strb = {(DataWidth / 8){1'b1}};
            snax_tcdm_req_o_output[i].q.user = '0;                  
          end  
          else begin
            snax_tcdm_req_o_output[i].q_valid = 1'b0;
            snax_tcdm_req_o_output[i].q.addr  = 17'b0;
            snax_tcdm_req_o_output[i].q.write = 1'b0;
            snax_tcdm_req_o_output[i].q.amo  = AMONone;
            snax_tcdm_req_o_output[i].q.data = {DataWidth{1'b0}};
            snax_tcdm_req_o_output[i].q.strb = {(DataWidth / 8){1'b0}};
            snax_tcdm_req_o_output[i].q.user = '0;          
          end    
    end
  end

  always_comb begin
    for (int i = 0; i < SnaxTcdmPorts; i = i + 1) begin
      if(!rst_ni) begin
          snax_tcdm_req_o[i].q_valid = 1'b0;
          snax_tcdm_req_o[i].q.addr  = 17'b0;
          snax_tcdm_req_o[i].q.write = 1'b0;
          snax_tcdm_req_o[i].q.amo  = AMONone;
          snax_tcdm_req_o[i].q.data = {DataWidth{1'b0}};
          snax_tcdm_req_o[i].q.strb = {(DataWidth / 8){1'b0}};
          snax_tcdm_req_o[i].q.user = '0;
      end
      else begin
        if(i < InputTcdmPorts) begin
          snax_tcdm_req_o[i] = snax_tcdm_req_o_input[i];
        end
        else begin
          snax_tcdm_req_o[i] = snax_tcdm_req_o_output[i - InputTcdmPorts];
        end
      end
    end
  end

  // get input data for gemm from tcdm responds
  always_comb begin
    if (!rst_ni) begin
        io_data_a_i = {InputMatrixSize{1'b0}};        
        io_data_b_i = {InputMatrixSize{1'b0}};        
    end else begin
      for (int i = 0; i < InputTcdmPorts / 2; i++) begin
        if(io_ctrl_data_valid_i) begin
          io_data_a_i[i * DataWidth +: DataWidth] = snax_tcdm_rsp_i[i].p.data;
          io_data_b_i[i * DataWidth +: DataWidth] = snax_tcdm_rsp_i[i + InputTcdmPorts / 2].p.data;
        end
        else begin
          io_data_a_i[i * DataWidth +: DataWidth] = 0;
          io_data_b_i[i * DataWidth +: DataWidth] = 0;
        end
      end
    end
  end  

  always_comb begin
      for (int i = 0; i < InputTcdmPorts; i++) begin
        if(!rst_ni) begin
          snax_tcdm_rsp_i_p_valid[i] = 1'b0;
        end
        else begin
          snax_tcdm_rsp_i_p_valid[i] = snax_tcdm_rsp_i[i].p_valid;
        end 
        // if(io_data_in_valid) begin
        //   snax_tcdm_rsp_i[i].q_ready = 1'b1
        // end
        // else begin
        //   snax_tcdm_rsp_i[i].q_ready = 1'b0
        // end
      end
  end 

  assign io_ctrl_data_valid_i = (&snax_tcdm_rsp_i_p_valid) === 1'b1;

  // TODO: take consideration of mem ready and also take in data when signal data valid is asserted and give data to gemm when all data is valid

endmodule
