// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

<%
  num_tcdm_ports = 0

  num_tcdm_ports = round(cfg["dma_data_width"] / cfg["data_width"] * 2)
  ## Half of them are used for the reader, and half of them are used for writer

%>
//-----------------------------
// xdma wrapper
//-----------------------------
module ${cfg["name"]}_xdma_wrapper #(
  // TCDM typedefs
  parameter type         tcdm_req_t    = logic,
  parameter type         tcdm_rsp_t    = logic,
  // Parameters related to TCDM
  parameter int unsigned TCDMDataWidth = ${cfg["data_width"]},
  parameter int unsigned TCDMNumPorts  = ${num_tcdm_ports},
  parameter int unsigned PhysicalAddrWidth = ${cfg["addr_width"]}
)(
  //-----------------------------
  // Clocks and reset
  //-----------------------------
  input  logic clk_i,
  input  logic rst_ni,
  //-----------------------------
  // Cluster base address
  //-----------------------------
  input  logic [PhysicalAddrWidth-1:0]  cluster_base_addr_i,
  //-----------------------------
  // TCDM ports
  //-----------------------------
  output tcdm_req_t [TCDMNumPorts-1:0] tcdm_req_o,
  input  tcdm_rsp_t [TCDMNumPorts-1:0] tcdm_rsp_i,
  //-----------------------------
  // CSR control ports
  //-----------------------------
  // Request
  input  logic [31:0] csr_req_bits_data_i,
  input  logic [31:0] csr_req_bits_addr_i,
  input  logic        csr_req_bits_write_i,
  input  logic        csr_req_valid_i,
  output logic        csr_req_ready_o,
  // Response
  output logic [31:0] csr_rsp_bits_data_o,
  output logic        csr_rsp_valid_o,
  input  logic        csr_rsp_ready_i
);

  //-----------------------------
  // Wiring and combinational logic
  //-----------------------------

  // TCDM signals
  // Request
  logic [TCDMNumPorts-1:0][PhysicalAddrWidth-1:0] tcdm_req_addr;
  logic [TCDMNumPorts-1:0]                      tcdm_req_write;
  //Note that tcdm_req_amo_i is 4 bits based on reqrsp definition
  logic [TCDMNumPorts-1:0][                3:0] tcdm_req_amo;
  logic [TCDMNumPorts-1:0][  TCDMDataWidth-1:0] tcdm_req_data;
  logic [TCDMNumPorts-1:0][TCDMDataWidth/8-1:0] tcdm_req_strb;
  //Note that tcdm_req_user_core_id_i is 5 bits based on Snitch definition
  logic [TCDMNumPorts-1:0][                4:0] tcdm_req_user_core_id;
  logic [TCDMNumPorts-1:0]                      tcdm_req_user_is_core;
  logic [TCDMNumPorts-1:0]                      tcdm_req_q_valid;

  // Response
  logic [TCDMNumPorts-1:0]                      tcdm_rsp_q_ready;
  logic [TCDMNumPorts-1:0]                      tcdm_rsp_p_valid;
  logic [TCDMNumPorts-1:0][  TCDMDataWidth-1:0] tcdm_rsp_data;

  // Fixed ports that are defaulted to tie-low
  // towards the TCDM from the streamer
  always_comb begin
    for(int i = 0; i < TCDMNumPorts; i++ ) begin
      tcdm_req_amo          [i] = '0;
      tcdm_req_user_core_id [i] = '0;
      tcdm_req_user_is_core [i] = '0;
    end
  end

  // Re-mapping wires for TCDM IO ports
  always_comb begin
    for ( int i = 0; i < TCDMNumPorts; i++) begin
      tcdm_req_o[i].q.addr         = tcdm_req_addr   [i];
      tcdm_req_o[i].q.write        = tcdm_req_write  [i];
      tcdm_req_o[i].q.amo          = reqrsp_pkg::AMONone;
      tcdm_req_o[i].q.data         = tcdm_req_data   [i];
      tcdm_req_o[i].q.strb         = tcdm_req_strb   [i];
      tcdm_req_o[i].q.user.core_id = '0;
      tcdm_req_o[i].q.user.is_core = '0;
      tcdm_req_o[i].q_valid        = tcdm_req_q_valid[i];

      tcdm_rsp_q_ready[i] = tcdm_rsp_i[i].q_ready;
      tcdm_rsp_p_valid[i] = tcdm_rsp_i[i].p_valid;
      tcdm_rsp_data   [i] = tcdm_rsp_i[i].p.data ;
    end
  end

  // Streamer module that is generated
  // with template mechanics
  ${cfg["name"]}_xdma i_${cfg["name"]}_xdma (
    //-----------------------------
    // Clocks and reset
    //-----------------------------
    .clock ( clk_i   ),
    .reset ( ~rst_ni ),

    //-----------------------------
    // Cluster base address
    //-----------------------------
    .io_clusterBaseAddress(cluster_base_addr_i),
    //-----------------------------
    // TCDM Ports
    //-----------------------------
    // Reader's Request
    // Ready signal is very strange... ETH defines ready at rsp side, but we think it should at request-side (imagine system with outstanding request support)

% for idx in range(0, num_tcdm_ports >> 1):
    .io_tcdm_reader_req_${idx}_ready      ( tcdm_rsp_q_ready[${idx}] ),
    .io_tcdm_reader_req_${idx}_valid      ( tcdm_req_q_valid[${idx}] ),
    .io_tcdm_reader_req_${idx}_bits_addr  ( tcdm_req_addr   [${idx}] ),
    .io_tcdm_reader_req_${idx}_bits_write ( tcdm_req_write  [${idx}] ),
    .io_tcdm_reader_req_${idx}_bits_data  ( tcdm_req_data   [${idx}] ),
    .io_tcdm_reader_req_${idx}_bits_strb  ( tcdm_req_strb   [${idx}] ),
% endfor
    // Writer's Request
% for idx in range(0, num_tcdm_ports >> 1):
    .io_tcdm_writer_req_${idx}_ready      ( tcdm_rsp_q_ready[${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdm_writer_req_${idx}_valid      ( tcdm_req_q_valid[${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdm_writer_req_${idx}_bits_addr  ( tcdm_req_addr   [${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdm_writer_req_${idx}_bits_write ( tcdm_req_write  [${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdm_writer_req_${idx}_bits_data  ( tcdm_req_data   [${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdm_writer_req_${idx}_bits_strb  ( tcdm_req_strb   [${idx + (num_tcdm_ports >> 1)}] ),
% endfor
    // Reader's Respose
% for idx in range(num_tcdm_ports >> 1):
    .io_tcdm_reader_rsp_${idx}_valid    ( tcdm_rsp_p_valid[${idx}] ),
    .io_tcdm_reader_rsp_${idx}_bits_data( tcdm_rsp_data   [${idx}] ),
% endfor
    // Writer has no Respose
    //-----------------------------
    // CSR control ports
    //-----------------------------
    // Request
    .io_csrIO_req_bits_data             ( csr_req_bits_data_i  ),
    .io_csrIO_req_bits_addr             ( csr_req_bits_addr_i  ),
    .io_csrIO_req_bits_write            ( csr_req_bits_write_i ),
    .io_csrIO_req_valid                 ( csr_req_valid_i      ),
    .io_csrIO_req_ready                 ( csr_req_ready_o      ),

    // Response
    .io_csrIO_rsp_bits_data             ( csr_rsp_bits_data_o  ),
    .io_csrIO_rsp_valid                 ( csr_rsp_valid_o      ),
    .io_csrIO_rsp_ready                 ( csr_rsp_ready_i      ), 
    //-----------------------------
    // Tie-off unused AXI port
    //-----------------------------
    // Remote data
    .io_remoteDMADataPath_fromRemote_valid ('0),
    .io_remoteDMADataPath_fromRemote_ready (  ),
    .io_remoteDMADataPath_fromRemote_bits  ('0),

    .io_remoteDMADataPath_toRemote_ready ('0),
    .io_remoteDMADataPath_toRemote_valid (  ),
    .io_remoteDMADataPath_toRemote_bits  (  ),

    // Remote cfg
    .io_remoteDMADataPathCfg_fromRemote_valid ('0),
    .io_remoteDMADataPathCfg_fromRemote_ready (  ),
    .io_remoteDMADataPathCfg_fromRemote_bits  ('0),

    .io_remoteDMADataPathCfg_toRemote_ready ('0),
    .io_remoteDMADataPathCfg_toRemote_valid (  ),
    .io_remoteDMADataPathCfg_toRemote_bits  (  )
  );

endmodule
