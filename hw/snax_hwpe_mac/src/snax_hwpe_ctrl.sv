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

  // CSR addresses for HWPE register mappings
  localparam int unsigned HwpeStreamAddrA   = 32'd64;
  localparam int unsigned HwpeStreamAddrB   = 32'd68;
  localparam int unsigned HwpeStreamAddrC   = 32'd72;
  localparam int unsigned HwpeStreamAddrOut = 32'd76;

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

  hwpe_tcdm_t sn_hwpe_reg;

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
  logic is_read;

  // A transaction is valid when both ready and valid signal for requestor are valid
  assign transaction_start = req_valid_i & req_ready_o;
  assign transaction_end   = periph.req & periph.gnt;
  assign is_write          = transaction_start & !wen;
  assign is_read           = transaction_start &  wen;

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

  // If the writes are towards address settings
  // Make sure to trigger the flag so we can offset the addresses
  logic  address_register;
  assign address_register = ( address_in == HwpeStreamAddrA
                           || address_in == HwpeStreamAddrB
                           || address_in == HwpeStreamAddrC
                           || address_in == HwpeStreamAddrOut );

  // Byte enable always only when we need to write
  assign be  = (is_write) ? 4'hF : 4'h0;

  // States
  typedef enum logic [1:0] {
    WAIT,
    WRITE,
    READ
  } ctrl_states_t;

  
  ctrl_states_t cstate, nstate;

  // Changing states
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      cstate <= WAIT;
    end else begin
      cstate <= nstate;
    end
  end

  // Next state changes
  always_comb begin
    case(cstate)
      WAIT: begin
        if (is_write) begin
          nstate = WRITE;
        end else if (is_read) begin
          nstate = READ;
        end else begin
          nstate = WAIT;
        end
      end 
      WRITE: begin
        if (transaction_end) begin 
          nstate = WAIT; 
        end else begin
          nstate = WRITE; 
        end
      end
      READ: begin
        if (periph.r_valid) begin 
          nstate = WAIT; 
        end else begin
          nstate = READ; 
        end
      end
      default: begin
        nstate = WAIT;
      end
    endcase

  end

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
 
  // Controller
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      req_ready_o   <= 1'b1;
      periph.id     <= '0;
      periph.req    <= '0;
      periph.add    <= '0;
      periph.wen    <= '0;
      periph.be     <= '0;
      periph.data   <= '0;
    end else begin

      case (cstate)
        WAIT: begin
          if (is_write || is_read) begin 
            req_ready_o <= 1'b0;
            periph.id   <= req_i.id;
            periph.req  <= 1'b1;
            periph.add  <= address_in;
            periph.wen  <= wen;
            periph.be   <= be;
            // If the CSR update is for a address setting,
            // then we align to double (64 bits)
            periph.data <= (address_register) ? {req_i.data_arga[31:3],3'b000} >> 1: req_i.data_arga[31:0];
          end
        end 
        WRITE: begin 
          if (transaction_end) begin 
            req_ready_o <= 1'b1;
            periph.id   <= '0;
            periph.req  <= '0;
            periph.add  <= '0;
            periph.wen  <= '0;
            periph.be   <= '0;
            periph.data <= '0;
          end
        end
        READ: begin
          if (periph.r_valid) begin
            req_ready_o <= 1'b1;
            periph.id   <= '0;
            periph.req  <= '0;
            periph.add  <= '0;
            periph.wen  <= '0;
            periph.be   <= '0;
            periph.data <= '0;
          end
        end
        default: begin
          req_ready_o   <= 1'b1;
          periph.id     <= '0;
          periph.req    <= '0;
          periph.add    <= '0;
          periph.wen    <= '0;
          periph.be     <= '0;
          periph.data   <= '0;
        end
      endcase
    end
  end
  
  // Response port
  always_ff @ (posedge clk_i or negedge rst_ni) begin
    if(!rst_ni) begin
      resp_o.id     <= '0;
      resp_o.error  <= '0;
      resp_o.data   <= '0;
      resp_valid_o  <= 1'b0;
    end else begin

      case (cstate)
        READ: begin
          if (periph.r_valid) begin 
            resp_o.id     <= periph.r_id;
            resp_o.error  <= '0;
            resp_o.data   <= unpacked_data;
            resp_valid_o  <= 1'b1;
          end
        end 
        default: begin
          resp_o.id     <= '0;
          resp_o.error  <= '0;
          resp_o.data   <= '0;
          resp_valid_o  <= 1'b0;
        end
      endcase
    end
  end

// verilog_lint: waive-stop line-length
// verilog_lint: waive-stop no-trailing-spaces

endmodule
