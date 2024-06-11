// Copyright 2020 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

//-------------------------------
// SNAX interface translator for converting
// Snitch accelerator ports to
// CSR ports
//-------------------------------
`ifndef TARGET_VERILATOR
import riscv_instr::*;
import reqrsp_pkg::*;
`endif

module snax_intf_translator #(
  parameter type                        acc_req_t = logic,
  parameter type                        acc_rsp_t = logic,
  // Careful! Sensitive parameter that depends
  // On the offset of where the CSRs are placed
  parameter int unsigned                CsrAddrOffset = 32'h3c0
)(
  //-------------------------------
  // Clocks and reset
  //-------------------------------
  input  logic        clk_i,
  input  logic        rst_ni,

  //-------------------------------
  // Request
  //-------------------------------
  input  acc_req_t    snax_req_i,
  input  logic        snax_qvalid_i,
  output logic        snax_qready_o,

  //-------------------------------
  // Response
  //-------------------------------
  output acc_rsp_t    snax_resp_o,
  output logic        snax_pvalid_o,
  input  logic        snax_pready_i,

  //-----------------------------
  // Simplified CSR control ports
  //-----------------------------
  // Request
  output logic [31:0] snax_csr_req_bits_data_o,
  output logic [31:0] snax_csr_req_bits_addr_o,
  output logic        snax_csr_req_bits_write_o,
  output logic        snax_csr_req_valid_o,
  input  logic        snax_csr_req_ready_i,

  // Response
  input  logic [31:0] snax_csr_rsp_bits_data_i,
  input  logic        snax_csr_rsp_valid_i,
  output logic        snax_csr_rsp_ready_o

);

  //-------------------------------
  // Request handler
  //-------------------------------
  logic  write_csr;

  // Combinational logic to detect CSR
  // Write operations
  always_comb begin
    if (snax_qvalid_i) begin
      unique casez (snax_req_i.data_op)
          CSRRS, CSRRSI, CSRRC, CSRRCI: begin
              write_csr = 1'b0;
          end
          default: begin
              write_csr = 1'b1;
          end
        endcase
    end else begin
      write_csr = 1'b0;
    end
  end

  assign snax_csr_req_bits_data_o  = snax_req_i.data_arga[31:0];
  assign snax_csr_req_bits_addr_o  = snax_req_i.data_argb - CsrAddrOffset;
  assign snax_csr_req_bits_write_o = write_csr;
  assign snax_csr_req_valid_o      = snax_qvalid_i;
  assign snax_qready_o             = snax_csr_req_ready_i;

  //-------------------------------
  // Response handler
  //-------------------------------
  // TODO: Need to fix the response port actually
  // Such that it handles the correct id
  // rsp
  assign snax_csr_rsp_ready_o = snax_pready_i;
  assign snax_pvalid_o        = snax_csr_rsp_valid_i;
  assign snax_resp_o.data     = snax_csr_rsp_bits_data_i;
  assign snax_resp_o.id       = snax_req_i.id;
  assign snax_resp_o.error    = 1'b0;

endmodule
