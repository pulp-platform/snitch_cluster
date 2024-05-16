// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

<%
  num_tcdm_ports = sum(cfg["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"]) + \
                   sum(cfg["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"])
%>

//-------------------------------
// Streamer-MUL wrapper
// This is the entire accelerator
// That connecst to the TCDM subsystem
//-------------------------------
module ${cfg["tag_name"]}_wrapper # (
  // TCDM typedefs
  parameter type         tcdm_req_t         = logic,
  parameter type         tcdm_rsp_t         = logic,
  // Reconfigurable parameters
  parameter int unsigned DataWidth          = ${cfg["tcdm_data_width"]},
  parameter int unsigned SnaxTcdmPorts      = ${num_tcdm_ports},
  // Addr width is pre-computed in the generator
  // TCDMAddrWidth = log2(TCDMBankNum * TCDMDepth * (TCDMDataWidth/8))
  parameter int unsigned TCDMAddrWidth      = ${cfg["tcdm_addr_width"]},
  // Don't touch parameters (or modify at your own risk)
  parameter int unsigned RegRWCount         = ${cfg["snax_num_rw_csr"]},
  parameter int unsigned RegROCount         = ${cfg["snax_num_ro_csr"]},
  parameter int unsigned TotalRegCount      = RegRWCount + RegROCount,
  parameter int unsigned RegDataWidth       = 32,
  parameter int unsigned RegAddrWidth       = 32
)(
  //-----------------------------
  // Clocks and reset
  //-----------------------------
  input  logic clk_i,
  input  logic rst_ni,
  //-----------------------------
  // CSR control ports
  //-----------------------------
  // Request
  input  logic [31:0] snax_req_data_i,
  input  logic [31:0] snax_req_addr_i,
  input  logic        snax_req_write_i,
  input  logic        snax_req_valid_i,
  output logic        snax_req_ready_o,
  // Response
  input  logic        snax_rsp_ready_i,
  output logic        snax_rsp_valid_o,
  output logic [31:0] snax_rsp_data_o,
  //-----------------------------
  // Barrier
  //-----------------------------
  output logic        snax_barrier_o,
  //-----------------------------
  // TCDM ports
  //-----------------------------
  output tcdm_req_t [SnaxTcdmPorts-1:0] snax_tcdm_req_o,
  input  tcdm_rsp_t [SnaxTcdmPorts-1:0] snax_tcdm_rsp_i
);

  //-----------------------------
  // Internal local parameters
  //-----------------------------
  localparam int unsigned NumRwCsr = ${cfg["snax_num_rw_csr"]};
  localparam int unsigned NumRoCsr = ${cfg["snax_num_ro_csr"]};

  //-----------------------------
  // Accelerator ports
  //-----------------------------
  // Note that these have very specific data widths
  // found from the configuration file

  // Ports from accelerator to streamer
% for idx, dw in enumerate(cfg["snax_streamer_cfg"]["fifo_writer_params"]["fifo_width"]):
  logic [${dw-1}:0] acc2stream_${idx}_data;
  logic acc2stream_${idx}_valid;
  logic acc2stream_${idx}_ready;

% endfor
  // Ports from streamer to accelerator
% for idx, dw in enumerate(cfg["snax_streamer_cfg"]["fifo_reader_params"]["fifo_width"]):
  logic [${dw-1}:0] stream2acc_${idx}_data;
  logic stream2acc_${idx}_valid;
  logic stream2acc_${idx}_ready;

% endfor

  // CSR MUXing
  logic [1:0][RegAddrWidth-1:0] acc_csr_req_addr;
  logic [1:0][RegDataWidth-1:0] acc_csr_req_data;
  logic [1:0]                   acc_csr_req_wen;
  logic [1:0]                   acc_csr_req_valid;
  logic [1:0]                   acc_csr_req_ready;
  logic [1:0][RegDataWidth-1:0] acc_csr_rsp_data;
  logic [1:0]                   acc_csr_rsp_valid;
  logic [1:0]                   acc_csr_rsp_ready;

  // Register set signals
  logic [NumRwCsr-1:0][31:0]    acc_csr_reg_rw_set;
  logic                         acc_csr_reg_set_valid;
  logic                         acc_csr_reg_set_ready;
  logic [NumRoCsr-1:0][31:0]    acc_csr_reg_ro_set;

  //-------------------------------
  // MUX and DEMUX for control signals
  // That separate between streamer CSRs
  // and accelerator CSRs
  //-------------------------------
  snax_csr_mux_demux #(
    // The AddrSelOffset indicates when the MUX switches
    // To streamer or the accelerator CSRs
    // If snax_req_addr_i <  AddrSelOffset, it points
    // to the accelerator CSR manager
    .AddrSelOffSet        ( ${cfg["streamer_csr_num"]}     ), // Streamer CSR number
    .RegDataWidth         ( RegDataWidth      ),
    .RegAddrWidth         ( RegAddrWidth      )
  ) i_snax_csr_mux_demux (
    //-------------------------------
    // Input Core
    //-------------------------------
    .csr_req_addr_i       ( snax_req_addr_i   ),
    .csr_req_data_i       ( snax_req_data_i   ),
    .csr_req_wen_i        ( snax_req_write_i  ),
    .csr_req_valid_i      ( snax_req_valid_i  ),
    .csr_req_ready_o      ( snax_req_ready_o  ),
    .csr_rsp_data_o       ( snax_rsp_data_o   ),
    .csr_rsp_valid_o      ( snax_rsp_valid_o  ),
    .csr_rsp_ready_i      ( snax_rsp_ready_i  ),

    //-------------------------------
    // Output Port
    //-------------------------------
    .acc_csr_req_addr_o   ( acc_csr_req_addr  ),
    .acc_csr_req_data_o   ( acc_csr_req_data  ),
    .acc_csr_req_wen_o    ( acc_csr_req_wen   ),
    .acc_csr_req_valid_o  ( acc_csr_req_valid ),
    .acc_csr_req_ready_i  ( acc_csr_req_ready ),
    .acc_csr_rsp_data_i   ( acc_csr_rsp_data  ),
    .acc_csr_rsp_valid_i  ( acc_csr_rsp_valid ),
    .acc_csr_rsp_ready_o  ( acc_csr_rsp_ready )
  );

  //-----------------------------
  // CSR Manager to control the accelerator
  //-----------------------------
  ${cfg["tag_name"]}_csrman_wrapper #(
    .NumRwCsr             ( NumRwCsr              ),
    .NumRoCsr             ( NumRoCsr              )
  ) i_${cfg["tag_name"]}_csrman_wrapper (
    //-------------------------------
    // Clocks and reset
    //-------------------------------
    .clk_i                ( clk_i                 ),
    .rst_ni               ( rst_ni                ),
    //-----------------------------
    // CSR control ports
    //-----------------------------
    // Request
    .csr_req_addr_i       ( acc_csr_req_addr [1]  ),
    .csr_req_data_i       ( acc_csr_req_data [1]  ),
    .csr_req_write_i      ( acc_csr_req_wen  [1]  ),
    .csr_req_valid_i      ( acc_csr_req_valid[1]  ),
    .csr_req_ready_o      ( acc_csr_req_ready[1]  ),

    // Response
    .csr_rsp_data_o       ( acc_csr_rsp_data [1]  ),
    .csr_rsp_ready_i      ( acc_csr_rsp_valid[1]  ),
    .csr_rsp_valid_o      ( acc_csr_rsp_ready[1]  ),

    //-----------------------------
    // Packed CSR register signals
    //-----------------------------
    // Read-write CSRs
    .csr_reg_rw_set_o     ( acc_csr_reg_rw_set    ),
    .csr_reg_set_valid_o  ( acc_csr_reg_set_valid ),
    .csr_reg_set_ready_i  ( acc_csr_reg_set_ready ),
    // Read-only CSRs
    .csr_reg_ro_set_i     ( acc_csr_reg_ro_set    )  
  );

  //-----------------------------
  // Accelerator
  //-----------------------------
  // Note: This is the part that needs to be consistent
  // It needs to have the correct connections to the control and data ports!
  // Parameter declarations are custom inside the shell
  // Do not pass it from the top towards here to achieve
  // Uniform shell wrapping :)
  
  ${cfg["tag_name"]}_shell_wrapper i_${cfg["tag_name"]}_shell_wrapper (
    //-------------------------------
    // Clocks and reset
    //-------------------------------
    .clk_i                ( clk_i                 ),
    .rst_ni               ( rst_ni                ),

    //-----------------------------
    // Accelerator ports
    //-----------------------------
    // Note that these have very specific data widths
    // found from the configuration file

    // Ports from accelerator to streamer
% for idx, dw in enumerate(cfg["snax_streamer_cfg"]["fifo_writer_params"]["fifo_width"]):
    .acc2stream_${idx}_data_o  ( acc2stream_${idx}_data  ),
    .acc2stream_${idx}_valid_o ( acc2stream_${idx}_valid ),
    .acc2stream_${idx}_ready_i ( acc2stream_${idx}_ready ),

% endfor
    // Ports from streamer to accelerator
% for idx, dw in enumerate(cfg["snax_streamer_cfg"]["fifo_reader_params"]["fifo_width"]):
    .stream2acc_${idx}_data_i  ( stream2acc_${idx}_data  ),
    .stream2acc_${idx}_valid_i ( stream2acc_${idx}_valid ),
    .stream2acc_${idx}_ready_o ( stream2acc_${idx}_ready ),

% endfor
    //-----------------------------
    // Packed CSR register signals
    //-----------------------------
    .csr_reg_set_i        ( acc_csr_reg_rw_set    ),
    .csr_reg_set_valid_i  ( acc_csr_reg_set_valid ),
    .csr_reg_set_ready_o  ( acc_csr_reg_set_ready ),
    .csr_reg_ro_set_o     ( acc_csr_reg_ro_set    )
  );

  //-----------------------------
  // Streamer Wrapper
  //-----------------------------
  ${cfg["tag_name"]}_streamer_wrapper #(
    .tcdm_req_t               ( tcdm_req_t    ),
    .tcdm_rsp_t               ( tcdm_rsp_t    ),
    .TCDMDataWidth            ( DataWidth     ),
    .TCDMNumPorts             ( SnaxTcdmPorts ),
    .TCDMAddrWidth            ( TCDMAddrWidth )
  ) i_${cfg["tag_name"]}_streamer_wrapper (
    //-----------------------------
    // Clocks and reset
    //-----------------------------
    .clk_i                    ( clk_i  ),
    .rst_ni                   ( rst_ni ),
    //-----------------------------
    // Accelerator ports
    //-----------------------------
    // Note that these have very specific data widths
    // found from the configuration file

    // Ports from accelerator to streamer
% for idx, dw in enumerate(cfg["snax_streamer_cfg"]["fifo_writer_params"]["fifo_width"]):
    .acc2stream_${idx}_data_i  ( acc2stream_${idx}_data  ),
    .acc2stream_${idx}_valid_i ( acc2stream_${idx}_valid ),
    .acc2stream_${idx}_ready_o ( acc2stream_${idx}_ready ),

% endfor
    // Ports from streamer to accelerator
% for idx, dw in enumerate(cfg["snax_streamer_cfg"]["fifo_reader_params"]["fifo_width"]):
    .stream2acc_${idx}_data_o  ( stream2acc_${idx}_data  ),
    .stream2acc_${idx}_valid_o ( stream2acc_${idx}_valid ),
    .stream2acc_${idx}_ready_i ( stream2acc_${idx}_ready ),

% endfor

    //-----------------------------
    // TCDM ports
    //-----------------------------
    .tcdm_req_o ( snax_tcdm_req_o ),
    .tcdm_rsp_i ( snax_tcdm_rsp_i ),

    //-----------------------------
    // CSR control ports
    //-----------------------------
    // Request
    .csr_req_bits_data_i   ( acc_csr_req_data [0] ),
    .csr_req_bits_addr_i   ( acc_csr_req_addr [0] ),
    .csr_req_bits_write_i  ( acc_csr_req_wen  [0] ),
    .csr_req_valid_i       ( acc_csr_req_valid[0] ),
    .csr_req_ready_o       ( acc_csr_req_ready[0] ),
    // Response
    .csr_rsp_bits_data_o   ( acc_csr_rsp_data [0] ),
    .csr_rsp_valid_o       ( acc_csr_rsp_valid[0] ),
    .csr_rsp_ready_i       ( acc_csr_rsp_ready[0] )
  );

  //-----------------------------
  // Barrier control
  // TODO: Fix me later
  //-----------------------------
  assign snax_barrier_o = '0;

endmodule
