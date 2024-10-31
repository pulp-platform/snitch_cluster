// Copyright 2020 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

//-------------------------------
// SNAX interface translator for converting
// Snitch accelerator ports to
// CSR ports
//-------------------------------

import riscv_instr::*;
import reqrsp_pkg::*;

module snax_intf_translator #(
  parameter type                        acc_req_t = logic,
  parameter type                        acc_rsp_t = logic,
  // Careful! Sensitive parameter that depends
  // On the offset of where the CSRs are placed
  parameter int unsigned                NumOutstandingLoads = 4,
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

  // ID needs to be handled with a fifo buffer
  // we know that the responses will always
  // be in order, so we can just use a simple
  // fifo buffer to align the request id

  acc_req_t rsp_fifo_out;
  logic rsp_fifo_full, rsp_fifo_empty;
  logic rsp_fifo_push, rsp_fifo_pop;

  // Combinational logic

  // We push everytime there is a new read request
  // but then the response is not immediatley available
  // and when the fifo is not full!
  assign rsp_fifo_push =   snax_qvalid_i
                        && !write_csr
                        && !snax_csr_rsp_valid_i
                        && !rsp_fifo_full;

  // We pop when the response is valid and the fifo is not empty
  assign rsp_fifo_pop  =   snax_csr_rsp_valid_i
                        && !rsp_fifo_empty;

  // Buffer for aligning request id
  fifo_v3 #(
    .FALL_THROUGH ( 1'b0                ),
    .DEPTH        ( NumOutstandingLoads ),
    .dtype        ( acc_req_t           )
  ) i_rsp_fifo (
    .clk_i        ( clk_i               ),
    .rst_ni       ( rst_ni              ),
    .flush_i      ( 1'b0                ),
    .testmode_i   ( 1'b0                ),
    .full_o       ( rsp_fifo_full       ),
    .empty_o      ( rsp_fifo_empty      ),
    .usage_o      ( /* open */          ),
    .data_i       ( snax_req_i          ),
    .push_i       ( rsp_fifo_push       ),
    .data_o       ( rsp_fifo_out        ),
    .pop_i        ( rsp_fifo_pop        )
  );

  // Ready only when snax is ready and fifo is not full
  assign snax_csr_rsp_ready_o = snax_pready_i && !rsp_fifo_full;
  // pvalid is high always when p_valid is high
  assign snax_pvalid_o        = snax_csr_rsp_valid_i;
  // Data is always pass through too
  assign snax_resp_o.data     = snax_csr_rsp_bits_data_i;
  // If fifo is not empty, use the one from the FIFO
  // Else just make it pass through
  assign snax_resp_o.id       = (!rsp_fifo_empty) ? rsp_fifo_out.id: snax_req_i.id;
  // Leave this as always error for now
  assign snax_resp_o.error    = 1'b0;

endmodule
