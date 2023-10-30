// Copyright 2023 Katolieke Universiteit Leuven (KUL)
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Ryan Antonio (ryan.antonio@kuleuven.be)

// verilog_lint: waive-start line-length
// verilog_lint: waive-start no-trailing-spaces

import riscv_instr::*;

module snax_hwpe_ctrl #(
  parameter int unsigned DataWidth  = 64,
  parameter type acc_req_t          = logic,      // Memory request payload type, usually write enable, write data, etc.
  parameter type acc_rsp_t          = logic       // Memory response payload type, usually read data
)(
  input  logic                      clk_i,        // Clock
  input  logic                      rst_ni,       // Asynchronous reset, active low
  input  acc_req_t                  req_i,        // Request stream interface, payload
  input  logic                      req_valid_i,  // Request stream interface, payload is valid for transfer
  output logic                      req_ready_o,  // Request stream interface, payload can be accepted
  output acc_rsp_t                  resp_o,       // Response stream interface, payload
  output logic                      resp_valid_o, // Response stream interface, payload is valid for transfer
  input  logic                      resp_ready_i, // Response stream interface, payload can be accepted
  hwpe_ctrl_intf_periph.master      periph        // periph slave port
);

  //---------------------------------------------
  // Some important notes:
  // - The periph interface is fixed to 32 bits only
  // - That's the assumption of the HWPE
  //---------------------------------------------

  //---------------------------------------------
  // Local parameters
  //---------------------------------------------

  // Number of bits to fill to extend to DataWidth
  localparam int unsigned FillBits = DataWidth - 32;

  //---------------------------------------------
  // Registers and wires
  //---------------------------------------------

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

  // This is just a necessary wiring to re-map the data going
  // back to acc_reqrsp to 64 bits or anything beyond 32 bits
  logic [31:0] unpacked_data;

  //---------------------------------------------
  // Combinational logic and wiring assignments
  // for SN to HWPE FIFO direction
  // In this control we do a 1-step register buffer
  //---------------------------------------------
  logic transaction_start;
  logic transaction_end;
  logic is_write;

  // A transaction is valid when both ready and valid signal for requestor are valid
  assign transaction_start = req_valid_i & req_ready_o;
  assign transaction_end   = periph.req & periph.gnt;
  assign is_write          = transaction_start & !wen;

  // wen = 1'b1 whenever we read. wen = 1'b0 whenever we write
  // decode this based on the instruction given
  // Need to use unique casez to ignore `?` bits
  always_comb begin
    unique casez (req_i.data_op)
      CSRRS, CSRRSI, CSRRC, CSRRCI: begin
        wen = 1'b1;
      end
      default: begin
        wen = 1'b0;
      end
    endcase
  end

  // Adding switcher to handle both instruction extension and CSR
  logic [31:0] address_in;

  always_comb begin
    unique casez (req_i.data_op)
      CSRRW, CSRRWI, CSRRS, CSRRSI, CSRRC, CSRRCI: begin
        //Offset due to start of address CSR and << 2 due to "byte" addressable of registers
        address_in = (req_i.data_argb[31:0] - 32'd960) << 2; 
      end
      default: begin
        address_in = req_i.data_argb[31:0];
      end
    endcase
  end

  // Byte enable always only when we need to write
  assign be  = (is_write) ? 4'hF : 4'h0;

  //---------------------------------------------
  // Combinational logic and wiring assignments
  // for HWPE to SN FIFO queue
  //---------------------------------------------

  // Simply extending the unpacked_data to 64 bits
  // At the same time wiring it to the resp_o.data value
  // We make a condition here just for safety if DataWidth is less than 32
  if (FillBits > 0) begin: gen_fill_bits

    // Fill upper bits with 0s
    assign unpacked_data = {{FillBits{1'b0}},periph.r_data};

  end else begin: gen_no_fill_bits

    // This automatically truncates the upper bits
    // if the resp_o.data is more than 32 bits.
    assign unpacked_data = periph.r_data;

  end
 
  // Fully combinational control to the MAC engine
  // Avoids unnecessary cycle delays from buffers
  always_comb begin
    req_ready_o = periph.gnt;

    periph.id   = req_i.id;
    periph.req  = req_valid_i;
    periph.add  = address_in;
    periph.wen  = wen;
    periph.be   = be;
    periph.data = req_i.data_arga[31:0];
  end
  
//---------------------------------------------
  // FIFO queue for tranasctions from HWPE
  // to SNAX response ports. This becomes
  // necessary due to the r_valid signal only
  // of the TCDM. It becomes hard to control the timing
  // since there is no ready signal from the TCDM
  // The TCDM assumes that whenever r_valid is high,
  // which ever module gets it should buffer the data.
  // This is a low-cost buffer anyway.
  //---------------------------------------------

  tcdm_hwpe_t hwpe_sn_fifo_in;
  tcdm_hwpe_t hwpe_sn_fifo_out;

  logic fifo_hwpe_sn_push;
  logic fifo_hwpe_sn_pop;

  logic fifo_hwpe_sn_full;
  logic fifo_hwpe_sn_empty;

  logic sn_valid_trans_rsp;

  assign sn_valid_trans_rsp = resp_valid_o & resp_ready_i;
  
  // Packing
  always_comb begin
    hwpe_sn_fifo_in.r_id    = periph.r_id;
    hwpe_sn_fifo_in.r_data  = periph.r_data;
    hwpe_sn_fifo_in.r_valid = periph.r_valid;

    fifo_hwpe_sn_push = periph.r_valid & !fifo_hwpe_sn_full;
    fifo_hwpe_sn_pop  = sn_valid_trans_rsp & !fifo_hwpe_sn_empty;
  end

  fifo_v3 #(
    // When FALL_THROUGH = 0 we can push through without cycle latency
    // This is a feature of the fifo_v3 and hence we can get responses faster
    .FALL_THROUGH ( 1                   ), 
    .dtype        ( tcdm_hwpe_t         ), // Sum of address and 
    .DEPTH        ( 8                   )  // Arbitrarily chosen
  ) i_hwpe_sn_fifo (
    .clk_i        ( clk_i               ),
    .rst_ni       ( rst_ni              ),
    .flush_i      ( 1'b0                ),
    .testmode_i   ( 1'b0                ),
    .full_o       ( fifo_hwpe_sn_full   ),
    .empty_o      ( fifo_hwpe_sn_empty  ),
    .usage_o      ( /*unused*/          ),
    .data_i       ( hwpe_sn_fifo_in     ),
    .push_i       ( fifo_hwpe_sn_push   ),
    .data_o       ( hwpe_sn_fifo_out    ),
    .pop_i        ( fifo_hwpe_sn_pop    )
  );

  // Unpacking
  always_comb begin
    resp_valid_o = hwpe_sn_fifo_out.r_valid & !fifo_hwpe_sn_empty;

    resp_o.id    = hwpe_sn_fifo_out.r_id;
    resp_o.error = '0;
    resp_o.data  = hwpe_sn_fifo_out.r_data;
  end
// verilog_lint: waive-stop line-length
// verilog_lint: waive-stop no-trailing-spaces

endmodule
