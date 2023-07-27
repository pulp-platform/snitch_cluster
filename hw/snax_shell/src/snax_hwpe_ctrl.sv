//---------------------------------------------
// Copyright 2023 Katolieke Universiteit Leuven (KUL)
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
// Author: Ryan Antonio (ryan.antonio@kuleuven.be)
//---------------------------------------------

// verilog_lint: waive-start line-length
// verilog_lint: waive-start no-trailing-spaces

import snax_riscv_instr::*;

module snax_hwpe_ctrl #(
  parameter int unsigned DataWidth       = 64,
  parameter type acc_req_t  = logic,          // Memory request payload type, usually write enable, write data, etc.
  parameter type acc_resp_t = logic           // Memory response payload type, usually read data
)(
  input  logic                  clk_i,        // Clock
  input  logic                  rst_ni,       // Asynchronous reset, active low
  input  acc_req_t              req_i,        // Request stream interface, payload
  input  logic                  req_valid_i,  // Request stream interface, payload is valid for transfer
  output logic                  req_ready_o,  // Request stream interface, payload can be accepted
  output acc_resp_t             resp_o,       // Response stream interface, payload
  output logic                  resp_valid_o, // Response stream interface, payload is valid for transfer
  input  logic                  resp_ready_i, // Response stream interface, payload can be accepted
  hwpe_ctrl_intf_periph.master  periph        // periph slave port
);

  //---------------------------------------------
  // Some important notes:
  // - The periph interface is fixed to 32 bits only
  // - That's the assumption of the HWPE
  //---------------------------------------------

  //---------------------------------------------
  // Local parameters
  //---------------------------------------------

  // We need to pack and unpack in order:
  // {id, req, add, wen, be, data} - which leads to a total of...
  localparam int unsigned TotalSnHwpeFifoWidth = 5 + 1 + 32 + 1 + 1 + 32; //67 in total

  // {r_id, r_valid, r_data}
  localparam int unsigned TotalHwpeSnFifoWidth = 5 + 32 + 1;

  // Number of bits to fill to extend to DataWidth
  localparam int unsigned FillBits = DataWidth - 32;

  //---------------------------------------------
  // Registers and wires
  //---------------------------------------------

  // FIFO full signals
  logic fifo_sn_hwpe_full;
  logic fifo_hwpe_sn_full;

  // These signals are decoded and come from
  // the acc_reqrsp signals
  logic       req;
  logic       wen;
  logic [3:0] be;

  // Typedef struct for pack and unpack signals
  typedef struct packed {
    logic [ 4:0] id;
    logic        req;
    logic [31:0] add;
    logic        wen;
    logic        be;
    logic [31:0] data;
  } hwpe_tcdm_t;

  typedef struct packed {
    logic [ 4:0] r_id;
    logic        r_valid;
    logic [31:0] r_data;
  } tcdm_hwpe_t;

  // Pack and unpack signals
  hwpe_tcdm_t fifo_sn_hwpe_in;
  hwpe_tcdm_t fifo_sn_hwpe_out;

  tcdm_hwpe_t fifo_hwpe_sn_in;
  tcdm_hwpe_t fifo_hwpe_sn_out;

  // Push and pop signals, the latter 2 labels indicate direction
  logic push_sn_hwpe;
  logic pop_sn_hwpe;
  logic push_hwpe_sn;
  logic pop_hwpe_sn;

  // This is just a necessary wiring to re-map the data going
  // back to acc_reqrsp to 64 bits or anything beyond 32 bits
  logic [31:0] unpacked_data;

  //---------------------------------------------
  // Combinational logic and wiring assignments
  // for SN to HWPE FIFO direction
  //---------------------------------------------

  // A transaction is valid when both ready and valid signal for requestor are valid
  assign transaction_valid = req_valid_i & req_ready_o;

  // wen = 1'b1 whenever we read. wen = 1'b0 whenever we write
  // decode this based on the instruction given
  assign wen = (req_i.data_op == SNAX_RD_ACC) ? 1'b1 : 1'b0;

  // Byte enable always only when we need to write
  assign be  = (transaction_valid & !wen) ? 4'hF : 4'h0;

  // Pack
  assign fifo_sn_hwpe_in.id   = req_i.id;
  assign fifo_sn_hwpe_in.req  = transaction_valid;
  assign fifo_sn_hwpe_in.add  = req_i.data_arga[31:0];
  assign fifo_sn_hwpe_in.wen  = wen;
  assign fifo_sn_hwpe_in.be   = be;
  assign fifo_sn_hwpe_in.data = req_i.data_argb[31:0];

  // Unpack
  assign periph.id   = fifo_sn_hwpe_out.id;
  assign periph.req  = fifo_sn_hwpe_out.req;
  assign periph.add  = fifo_sn_hwpe_out.add;
  assign periph.wen  = fifo_sn_hwpe_out.wen;
  assign periph.be   = fifo_sn_hwpe_out.be;
  assign periph.data = fifo_sn_hwpe_out.data;

  // Push into SN to HWPE FIFO queue if transaction is valid and for HWPE ACC
  assign push_sn_hwpe = transaction_valid;

  // POP SN to HWPE FIFO queue when the HWPE transaction is valid
  assign pop_sn_hwpe  = periph.gnt && periph.req;

  // As long as FIFO is not full, we are always ready to take in data
  // from the snitch's acc_reqrsp ports
  assign req_ready_o = !fifo_sn_hwpe_full;

  //---------------------------------------------
  // FIFO queue for tranasctions from Snitch to HWPE
  //---------------------------------------------
  fifo_v3 #(
    .dtype      ( hwpe_tcdm_t         ), // Sum of address and 
    .DEPTH      ( 8                   )  // Arbitrarily chosen
  ) i_sn_hwpe_fifo (
    .clk_i      ( clk_i               ),
    .rst_ni     ( rst_ni              ),
    .flush_i    ( 1'b0                ),
    .testmode_i ( 1'b0                ),
    .full_o     ( fifo_sn_hwpe_full   ),
    .empty_o    ( /*unused*/          ),
    .usage_o    ( /*unused*/          ),
    .data_i     ( fifo_sn_hwpe_in     ),
    .push_i     ( push_sn_hwpe        ),
    .data_o     ( fifo_sn_hwpe_out    ),
    .pop_i      (  pop_sn_hwpe        )
  );

  //---------------------------------------------
  // Combinational logic and wiring assignments
  // for HWPE to SN FIFO queue
  //---------------------------------------------

  // Pack
  assign fifo_hwpe_sn_in.r_id    = periph.r_id;
  assign fifo_hwpe_sn_in.r_valid = periph.r_valid;
  assign fifo_hwpe_sn_in.r_data  = periph.r_data;
  
  // Unpack
  assign resp_o.id     = fifo_hwpe_sn_out.r_id;
  assign resp_valid_o  = fifo_hwpe_sn_out.r_valid;
  assign unpacked_data = fifo_hwpe_sn_out.r_data;

  // The only signal we get from HWPE is the r_valid to indicate valid read data
  // Push HWPE to SN FIFO queue when r_valid is asserted
  assign push_hwpe_sn = periph.r_valid;

  // Pop HWPE to SN FIFO queue when acc_resp transaction is valid
  // And also if the transaction is not a base register
  assign pop_hwpe_sn = resp_ready_i & resp_valid_o;

  // Simply extending the unpacked_data to 64 bits
  // At the same time wiring it to the resp_o.data value
  // We make a condition here just for safety if DataWidth is less than 32
  if (FillBits > 0) begin: gen_fill_bits

    // Fill upper bits with 0s
    assign resp_o.data = {{FillBits{1'b0}},unpacked_data};

  end else begin: gen_no_fill_bits

    // This automatically truncates the upper bits
    // if the resp_o.data is more than 32 bits.
    assign resp_o.data = unpacked_data;

  end

  // No need for error signal
  assign resp_o.error = '0;
  
  //---------------------------------------------
  // FIFO queue for valid reads from HWPE to Snitch
  //---------------------------------------------
  fifo_v3 #(
    .dtype      ( tcdm_hwpe_t       ), // Sum of address and 
    .DEPTH      ( 8                 )  // Arbitrarily chosen
  ) i_hwpe_sn_fifo (
    .clk_i      ( clk_i             ),
    .rst_ni     ( rst_ni            ),
    .flush_i    ( 1'b0              ),
    .testmode_i ( 1'b0              ),
    .full_o     ( fifo_hwpe_sn_full ), //WARNING: for now the signal is here but it's usage is unclear. Will see what happens later.
    .empty_o    ( /*unused*/        ),
    .usage_o    ( /*unused*/        ),
    .data_i     ( fifo_hwpe_sn_in   ),
    .push_i     ( push_hwpe_sn      ),
    .data_o     ( fifo_hwpe_sn_out  ),
    .pop_i      (  pop_hwpe_sn      )
  );

// verilog_lint: waive-stop line-length
// verilog_lint: waive-stop no-trailing-spaces

endmodule
