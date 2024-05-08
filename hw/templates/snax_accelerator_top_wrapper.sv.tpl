// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

<%
  num_stream2acc_ports = len(cfg["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"])
  num_acc2stream_ports = len(cfg["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"])
  num_tcdm_ports = sum(cfg["snax_streamer_cfg"]["data_reader_params"]["tcdm_ports_num"]) + \
                   sum(cfg["snax_streamer_cfg"]["data_writer_params"]["tcdm_ports_num"])

  # We make the hasty assumption the ports
  # will use the TCDM Data widths
  stream_data_width = cfg["snax_streamer_cfg"]["fifo_reader_params"]["fifo_width"][0]
%>

//-------------------------------
// Streamer-MUL wrapper
// This is the entire accelerator
// That connecst to the TCDM subsystem
//-------------------------------
module ${cfg["tag_name"]}_top_wrapper # (
  // Reconfigurable parameters
  parameter int unsigned TCDMDataWidth      = ${cfg["tcdm_data_width"]},
  parameter int unsigned TCDMReqPorts       = ${num_tcdm_ports},
  // Addr width is pre-computed in the generator
  // TCDMAddrWidth = log2(TCDMBankNum * TCDMDepth * (TCDMDataWidth/8))
  parameter int unsigned TCDMAddrWidth      = ${cfg["tcdm_addr_width"]},
  // Don't touch parameters (or modify at your own risk)
  parameter int unsigned RegCount           = ${cfg["snax_acc_num_csr"]},
  parameter int unsigned RegDataWidth       = 32,
  parameter int unsigned RegAddrWidth       = 32,
  parameter int unsigned StreamerDataWidth  = ${stream_data_width},
  parameter int unsigned NumStream2AccPorts = ${num_stream2acc_ports},
  parameter int unsigned NumAcc2StreamPorts = ${num_acc2stream_ports}
)(
  //-----------------------------
  // Clocks and reset
  //-----------------------------
  input  logic clk_i,
  input  logic rst_ni,

  //-----------------------------
  // TCDM ports
  //-----------------------------
  // Request
  output logic [TCDMReqPorts-1:0]                      tcdm_req_write_o,
  output logic [TCDMReqPorts-1:0][  TCDMAddrWidth-1:0] tcdm_req_addr_o,
  //Note that tcdm_req_amo_i is 4 bits based on reqrsp definition
  output logic [TCDMReqPorts-1:0][                3:0] tcdm_req_amo_o,
  output logic [TCDMReqPorts-1:0][  TCDMDataWidth-1:0] tcdm_req_data_o,
  //Note that tcdm_req_user_core_id_i is 5 bits based on Snitch definition
  output logic [TCDMReqPorts-1:0][                4:0] tcdm_req_user_core_id_o,
  output logic [TCDMReqPorts-1:0]                      tcdm_req_user_is_core_o,
  output logic [TCDMReqPorts-1:0][TCDMDataWidth/8-1:0] tcdm_req_strb_o,
  output logic [TCDMReqPorts-1:0]                      tcdm_req_q_valid_o,

  // Response
  input  logic [TCDMReqPorts-1:0]                      tcdm_rsp_q_ready_i,
  input  logic [TCDMReqPorts-1:0]                      tcdm_rsp_p_valid_i,
  input  logic [TCDMReqPorts-1:0][  TCDMDataWidth-1:0] tcdm_rsp_data_i,

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
  output logic [31:0] snax_rsp_data_o
);

  //-----------------------------
  // Internal local parameters
  //-----------------------------
  localparam int unsigned NumCsr = ${cfg["snax_acc_num_csr"]};

  //-----------------------------
  // Accelerator ports
  //-----------------------------
  // Ports from accelerator to streamer
  logic [NumAcc2StreamPorts-1:0][StreamerDataWidth-1:0] acc2stream_data;
  logic [NumAcc2StreamPorts-1:0]                        acc2stream_valid;
  logic [NumAcc2StreamPorts-1:0]                        acc2stream_ready,

  // Ports from accelerator to streamer
  logic [NumStream2AccPorts-1:0][StreamerDataWidth-1:0] stream2acc_data;
  logic [NumStream2AccPorts-1:0]                        stream2acc_valid;
  logic [NumStream2AccPorts-1:0]                        stream2acc_ready;

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
  logic [NumCsr-1:0][31:0] acc_csr_reg_set;
  logic                    acc_csr_reg_set_valid;
  logic                    acc_csr_reg_set_ready;

  //-------------------------------
  // MUX and DEMUX for control signals
  // That separate between streamer CSRs
  // and accelerator CSRs
  //-------------------------------
  csr_mux_demux #(
    // The AddrSelOffset indicates when the MUX switches
    // To streamer or the accelerator CSRs
    // If snax_req_addr_i <  AddrSelOffset, it points
    // to the accelerator CSR manager
    .AddrSelOffSet        ( RegCount              ),
    .RegDataWidth         ( RegDataWidth          ),
    .RegAddrWidth         ( RegAddrWidth          )
  ) i_csr_mux_demux (
    //-------------------------------
    // Input Core
    //-------------------------------
    .csr_req_addr_i       ( snax_req_addr_i       ),
    .csr_req_data_i       ( snax_req_data_i       ),
    .csr_req_wen_i        ( snax_req_write_i      ),
    .csr_req_valid_i      ( snax_req_valid_i      ),
    .csr_req_ready_o      ( snax_req_ready_o      ),
    .csr_rsp_data_o       ( snax_rsp_data_o       ),
    .csr_rsp_valid_o      ( snax_rsp_valid_o      ),
    .csr_rsp_ready_i      ( snax_rsp_ready_i      ),

    //-------------------------------
    // Output Port
    //-------------------------------
    .acc_csr_req_addr_o   ( acc_csr_req_addr      ),
    .acc_csr_req_data_o   ( acc_csr_req_data      ),
    .acc_csr_req_wen_o    ( acc_csr_req_wen       ),
    .acc_csr_req_valid_o  ( acc_csr_req_valid     ),
    .acc_csr_req_ready_i  ( acc_csr_req_ready     ),
    .acc_csr_rsp_data_i   ( acc_csr_rsp_data      ),
    .acc_csr_rsp_valid_i  ( acc_csr_rsp_valid     ),
    .acc_csr_rsp_ready_o  ( acc_csr_rsp_ready     )
  );

  //-----------------------------
  // CSR Manager to control the accelerator
  //-----------------------------
  ${cfg["tag_name"]}_csrman_wrapper #(
    .NumCsr               ( NumCsr                )
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
    .csr_req_addr_i       ( acc_csr_req_addr [0]  ),
    .csr_req_data_i       ( acc_csr_req_data [0]  ),
    .csr_req_write_i      ( acc_csr_req_wen  [0]  ),
    .csr_req_valid_i      ( acc_csr_req_valid[0]  ),
    .csr_req_ready_o      ( acc_csr_req_ready[0]  ),

    // Response
    .csr_rsp_data_o       ( acc_csr_rsp_data [0]  ),
    .csr_rsp_ready_i      ( acc_csr_rsp_valid[0]  ),
    .csr_rsp_valid_o      ( acc_csr_rsp_ready[0]  ),

    //-----------------------------
    // Packed CSR register signals
    //-----------------------------
    .csr_reg_set_o        ( acc_csr_reg_set       ),
    .csr_reg_set_valid_o  ( acc_csr_reg_set_valid ),
    .csr_reg_set_ready_i  ( acc_csr_reg_set_ready )
  );

  //-----------------------------
  // Accelerator
  //-----------------------------
  // Note: This is the part that needs to be consistent
  // It needs to have the correct connections to the control and data ports!

  ${cfg["tag_name"]}_wrapper #(
    .NumStream2AccPorts        ( NumStream2AccPorts         ),
    .NumAcc2StreamPorts       ( NumAcc2StreamPorts        ),
    .DataWidth            ( TCDMDataWidth       )
  ) i_${cfg["tag_name"]}_wrapper (
    //-------------------------------
    // Clocks and reset
    //-------------------------------
    .clk_i                ( clk_i                 ),
    .rst_ni               ( rst_ni                ),

    //-----------------------------
    // Accelerator ports
    //-----------------------------
    // Ports from streamer to accelerator
    .stream2acc_data_i    ( stream2acc_data       ),
    .stream2acc_valid_i   ( stream2acc_valid      ),
    .stream2acc_ready_o   ( stream2acc_ready      ),

    // Ports from accelerator to streamer
    .acc2stream_data_o    ( acc2stream_data       ),
    .acc2stream_valid_o   ( acc2stream_valid      ),
    .acc2stream_ready_i   ( acc2stream_ready      ),

    //-----------------------------
    // Packed CSR register signals
    //-----------------------------
    .csr_reg_set_i        ( acc_csr_reg_set       ),
    .csr_reg_set_valid_i  ( acc_csr_reg_set_valid ),
    .csr_reg_set_ready_o  ( acc_csr_reg_set_ready )
  );

  //-----------------------------
  // Streamer Wrapper
  //-----------------------------
  ${cfg["tag_name"]}_streamer_wrapper #(
    .TCDMDataWidth            ( TCDMDataWidth           ),
    .TCDMReqPorts             ( TCDMReqPorts            ),
    .TCDMAddrWidth            ( TCDMAddrWidth           )
  ) i_${cfg["tag_name"]}_streamer_wrapper (
    //-----------------------------
    // Clocks and reset
    //-----------------------------
    .clk_i                    ( clk_i                   ),
    .rst_ni                   ( rst_ni                  ),

    //-------------------------------
    // Accelerator ports
    //-------------------------------

    // Ports from streamer to accelerator
    .stream2acc_data_o        ( stream2acc_data         ),
    .stream2acc_valid_o       ( stream2acc_valid        ),
    .stream2acc_ready_i       ( stream2acc_ready        ),

    // Ports from acceleartor to streamer
    .acc2stream_data_i        ( acc2stream_data         ),
    .acc2stream_valid_i       ( acc2stream_valid        ),
    .acc2stream_ready_o       ( acc2stream_ready        ),

    //-----------------------------
    // TCDM ports 
    //-----------------------------
    // Request
    .tcdm_req_write_o         ( tcdm_req_write_o        ),
    .tcdm_req_addr_o          ( tcdm_req_addr_o         ),
    .tcdm_req_amo_o           ( tcdm_req_amo_o          ), 
    .tcdm_req_data_o          ( tcdm_req_data_o         ),
    .tcdm_req_user_core_id_o  ( tcdm_req_user_core_id_o ), 
    .tcdm_req_user_is_core_o  ( tcdm_req_user_is_core_o ),
    .tcdm_req_strb_o          ( tcdm_req_strb_o         ),
    .tcdm_req_q_valid_o       ( tcdm_req_q_valid_o      ),
    // Response
    .tcdm_rsp_q_ready_i       ( tcdm_rsp_q_ready_i      ),
    .tcdm_rsp_p_valid_i       ( tcdm_rsp_p_valid_i      ),
    .tcdm_rsp_data_i          ( tcdm_rsp_data_i         ),

    //-----------------------------
    // CSR control ports
    //-----------------------------
    // Request
    .io_csr_req_bits_data_i   ( acc_csr_req_data [1]    ),
    .io_csr_req_bits_addr_i   ( acc_csr_req_addr [1]    ),
    .io_csr_req_bits_write_i  ( acc_csr_req_wen  [1]    ),
    .io_csr_req_valid_i       ( acc_csr_req_valid[1]    ),
    .io_csr_req_ready_o       ( acc_csr_req_ready[1]    ),
    // Response
    .io_csr_rsp_ready_i       ( acc_csr_rsp_ready[1]    ),
    .io_csr_rsp_valid_o       ( acc_csr_rsp_valid[1]    ),
    .io_csr_rsp_bits_data_o   ( acc_csr_rsp_data [1]    )
  );

endmodule
