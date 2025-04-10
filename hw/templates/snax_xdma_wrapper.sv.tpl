// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

<%
  num_tcdm_ports = 0

  num_tcdm_ports = round(cfg["dma_data_width"] / cfg["data_width"] * 2)
  ## Half of them are used for the reader, and half of them are used for writer

  tcdm_addr_width = cfg["tcdm"]["size"].bit_length() - 1 + 10
%>
//-----------------------------
// xdma wrapper
//-----------------------------
module ${cfg["name"]}_xdma_wrapper
import xdma_pkg::*;
#(
  // Address width
  parameter int unsigned PhysicalAddrWidth = ${cfg["addr_width"]},
  // TCDM typedefs
  parameter type         tcdm_req_t        = logic,
  parameter type         tcdm_rsp_t        = logic,
  // AXI type
  parameter type         wide_slv_id_t     = logic,
  parameter type         wide_out_req_t    = logic,
  parameter type         wide_out_resp_t   = logic,
  parameter type         wide_in_req_t     = logic,
  parameter type         wide_in_resp_t    = logic,
  // Parameters related to TCDM
  parameter int unsigned TCDMDataWidth     = ${cfg["data_width"]},
  parameter int unsigned TCDMNumPorts      = ${num_tcdm_ports},
  parameter int unsigned TCDMAddrWidth     = ${tcdm_addr_width},
  // Cluster Addr
  parameter logic [PhysicalAddrWidth-1:0]  ClusterBaseAddr = 48'h1000_0000,
  parameter logic [PhysicalAddrWidth-1:0]  ClusterAddressSpace = 48'h0010_0000,
  parameter logic [PhysicalAddrWidth-1:0]  MainMemBaseAddr = 48'h8000_0000,
  parameter logic [PhysicalAddrWidth-1:0]  MainMemEndAddr = 48'h1_0000_0000,
  parameter int                            MMIOSize = 16
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
  input  logic        csr_rsp_ready_i,
  //-----------------------------
  // XDMA Intercluster Ports
  //-----------------------------
  output wide_out_req_t      xdma_wide_out_req_o,
  input  wide_out_resp_t     xdma_wide_out_resp_i,
  input  wide_in_req_t       xdma_wide_in_req_i,
  output wide_in_resp_t      xdma_wide_in_resp_o
);
  
  //-----------------------------
  // Wiring and combinational logic
  //-----------------------------

  // TCDM signals
  // Request
  logic [TCDMNumPorts-1:0][TCDMAddrWidth-1:0] tcdm_req_addr;
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

  ///---------------------------------------------------------------
  // XDMA Intercluster Signals
  ///---------------------------------------------------------------
  xdma_pkg::data_t                   xdma_to_remote_cfg_bits;
  xdma_pkg::data_t                   xdma_from_remote_cfg_bits;
  ///---------------------
  /// TO REMOTE
  ///---------------------
  // to remote cfg
  xdma_pkg::xdma_inter_cluster_cfg_t xdma_to_remote_cfg;
  logic                              xdma_to_remote_cfg_valid;
  logic                              xdma_to_remote_cfg_ready;
  // to remote data
  xdma_pkg::xdma_to_remote_data_t    xdma_to_remote_data;
  logic                              xdma_to_remote_data_valid;
  logic                              xdma_to_remote_data_ready;
  // to remote accompany cfg
  xdma_pkg::xdma_accompany_cfg_t     xdma_to_remote_data_accompany_cfg;
  xdma_pkg::id_t                     xdma_to_remote_data_accompany_cfg_dma_id;
  logic                              xdma_to_remote_data_accompany_cfg_dma_type;
  xdma_pkg::addr_t                   xdma_to_remote_data_accompany_cfg_src_addr;
  xdma_pkg::addr_t                   xdma_to_remote_data_accompany_cfg_dst_addr;
  xdma_pkg::len_t                    xdma_to_remote_data_accompany_cfg_dma_length;
  logic                              xdma_to_remote_data_accompany_cfg_ready_to_transfer;
  ///---------------------
  /// FROM REMOTE
  ///---------------------
  // from remote cfg
  xdma_pkg::xdma_inter_cluster_cfg_t xdma_from_remote_cfg;
  logic                              xdma_from_remote_cfg_valid;
  logic                              xdma_from_remote_cfg_ready;
  // from remote data
  xdma_pkg::xdma_from_remote_data_t  xdma_from_remote_data;
  logic                              xdma_from_remote_data_valid;
  logic                              xdma_from_remote_data_ready;
  // from remote data accompany cfg
  xdma_pkg::xdma_accompany_cfg_t     xdma_from_remote_data_accompany_cfg;
  xdma_pkg::id_t                     xdma_from_remote_data_accompany_cfg_dma_id;
  logic                              xdma_from_remote_data_accompany_cfg_dma_type;
  xdma_pkg::addr_t                   xdma_from_remote_data_accompany_cfg_src_addr;
  xdma_pkg::addr_t                   xdma_from_remote_data_accompany_cfg_dst_addr;
  xdma_pkg::len_t                    xdma_from_remote_data_accompany_cfg_dma_length;
  logic                              xdma_from_remote_data_accompany_cfg_ready_to_transfer;
  ///---------------------
  /// FINISH
  ///---------------------
  logic                              xdma_finish;
  ///---------------------------------------------------------------
  // Assign Signals
  ///---------------------------------------------------------------
  assign xdma_to_remote_cfg = xdma_pkg::xdma_inter_cluster_cfg_t'(xdma_to_remote_cfg_bits);
  assign xdma_from_remote_cfg_bits = xdma_pkg::data_t'(xdma_from_remote_cfg);
  assign xdma_to_remote_data_accompany_cfg = xdma_pkg::xdma_accompany_cfg_t'{
    dma_id:            xdma_to_remote_data_accompany_cfg_dma_id,
    dma_type:          xdma_to_remote_data_accompany_cfg_dma_type,
    src_addr:          xdma_to_remote_data_accompany_cfg_src_addr,
    dst_addr:          xdma_to_remote_data_accompany_cfg_dst_addr,
    dma_length:        xdma_to_remote_data_accompany_cfg_dma_length,
    ready_to_transfer: xdma_to_remote_data_accompany_cfg_ready_to_transfer
  };
  assign xdma_from_remote_data_accompany_cfg = xdma_pkg::xdma_accompany_cfg_t'{
    dma_id:            xdma_from_remote_data_accompany_cfg_dma_id,
    dma_type:          xdma_from_remote_data_accompany_cfg_dma_type,
    src_addr:          xdma_from_remote_data_accompany_cfg_src_addr,
    dst_addr:          xdma_from_remote_data_accompany_cfg_dst_addr,
    dma_length:        xdma_from_remote_data_accompany_cfg_dma_length,
    ready_to_transfer: xdma_from_remote_data_accompany_cfg_ready_to_transfer
  };

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
    .io_tcdmReader_req_${idx}_ready      ( tcdm_rsp_q_ready[${idx}] ),
    .io_tcdmReader_req_${idx}_valid      ( tcdm_req_q_valid[${idx}] ),
    .io_tcdmReader_req_${idx}_bits_addr  ( tcdm_req_addr   [${idx}] ),
    .io_tcdmReader_req_${idx}_bits_write ( tcdm_req_write  [${idx}] ),
    .io_tcdmReader_req_${idx}_bits_data  ( tcdm_req_data   [${idx}] ),
    .io_tcdmReader_req_${idx}_bits_strb  ( tcdm_req_strb   [${idx}] ),
% endfor
    // Writer's Request
% for idx in range(0, num_tcdm_ports >> 1):
    .io_tcdmWriter_req_${idx}_ready      ( tcdm_rsp_q_ready[${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdmWriter_req_${idx}_valid      ( tcdm_req_q_valid[${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdmWriter_req_${idx}_bits_addr  ( tcdm_req_addr   [${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdmWriter_req_${idx}_bits_write ( tcdm_req_write  [${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdmWriter_req_${idx}_bits_data  ( tcdm_req_data   [${idx + (num_tcdm_ports >> 1)}] ),
    .io_tcdmWriter_req_${idx}_bits_strb  ( tcdm_req_strb   [${idx + (num_tcdm_ports >> 1)}] ),
% endfor
    // Reader's Respose
% for idx in range(num_tcdm_ports >> 1):
    .io_tcdmReader_rsp_${idx}_valid    ( tcdm_rsp_p_valid[${idx}] ),
    .io_tcdmReader_rsp_${idx}_bits_data( tcdm_rsp_data   [${idx}] ),
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

    // RemoteTask finished Pin
    .io_remoteTaskFinished                                     (xdma_finish                ),

    // fromRemote data
    .io_remoteXDMAData_fromRemote_valid                        (xdma_from_remote_data_valid),
    .io_remoteXDMAData_fromRemote_ready                        (xdma_from_remote_data_ready),
    .io_remoteXDMAData_fromRemote_bits                         (xdma_from_remote_data      ),

    // fromRemote Accompanied Cfg
    // readyToTransfer = 0 -> 1: XDMA is ready for the next task
    .io_remoteXDMAData_fromRemoteAccompaniedCfg_readyToTransfer(xdma_from_remote_data_accompany_cfg_ready_to_transfer),
    // taskID: 8 bit signal to track each tasks
    .io_remoteXDMAData_fromRemoteAccompaniedCfg_taskID         (xdma_from_remote_data_accompany_cfg_dma_id           ),
    // length: 19 bit signal to indicate the total number of beats in this task
    .io_remoteXDMAData_fromRemoteAccompaniedCfg_length         (xdma_from_remote_data_accompany_cfg_dma_length       ),
    // taskType: 1 is Local Write, Remote Read; 0 is Local Read, Remote Write
    .io_remoteXDMAData_fromRemoteAccompaniedCfg_taskType       (xdma_from_remote_data_accompany_cfg_dma_type         ),
    // Addresses: 48 bit signal to indicate the src and dst of the task
    .io_remoteXDMAData_fromRemoteAccompaniedCfg_src            (xdma_from_remote_data_accompany_cfg_src_addr         ),
    .io_remoteXDMAData_fromRemoteAccompaniedCfg_dst            (xdma_from_remote_data_accompany_cfg_dst_addr         ),

    // toRemote data
    .io_remoteXDMAData_toRemote_ready                          (xdma_to_remote_data_ready),
    .io_remoteXDMAData_toRemote_valid                          (xdma_to_remote_data_valid),
    .io_remoteXDMAData_toRemote_bits                           (xdma_to_remote_data),

    // toRemote Accompanied Cfg
    // readyToTransfer = 0 -> 1: XDMA is ready for the next task
    .io_remoteXDMAData_toRemoteAccompaniedCfg_readyToTransfer  (xdma_to_remote_data_accompany_cfg_ready_to_transfer),
    // taskID: 8 bit signal to track each tasks
    .io_remoteXDMAData_toRemoteAccompaniedCfg_taskID           (xdma_to_remote_data_accompany_cfg_dma_id),
    // length: 19 bit signal to indicate the total number of beats in this task
    .io_remoteXDMAData_toRemoteAccompaniedCfg_length           (xdma_to_remote_data_accompany_cfg_dma_length),
    // taskType: 1 is Local Write, Remote Read; 0 is Local Read, Remote Write
    .io_remoteXDMAData_toRemoteAccompaniedCfg_taskType         (xdma_to_remote_data_accompany_cfg_dma_type),
    // Addresses: 48 bit signal to indicate the src and dst of the task
    .io_remoteXDMAData_toRemoteAccompaniedCfg_src              (xdma_to_remote_data_accompany_cfg_src_addr),
    .io_remoteXDMAData_toRemoteAccompaniedCfg_dst              (xdma_to_remote_data_accompany_cfg_dst_addr),

    // 512 bit Cfg
    .io_remoteXDMACfg_fromRemote_valid                         (xdma_from_remote_cfg_valid),
    .io_remoteXDMACfg_fromRemote_ready                         (xdma_from_remote_cfg_ready),
    .io_remoteXDMACfg_fromRemote_bits                          (xdma_from_remote_cfg_bits ),

    .io_remoteXDMACfg_toRemote_ready                           (xdma_to_remote_cfg_ready  ),
    .io_remoteXDMACfg_toRemote_valid                           (xdma_to_remote_cfg_valid  ),
    .io_remoteXDMACfg_toRemote_bits                            (xdma_to_remote_cfg_bits   )
  );


    xdma_axi_adapter_top #(
        .axi_id_t                             (wide_slv_id_t                     ),
        .axi_out_req_t                        (wide_out_req_t                    ),
        .axi_out_resp_t                       (wide_out_resp_t                   ),
        .axi_in_req_t                         (wide_in_req_t                     ),
        .axi_in_resp_t                        (wide_in_resp_t                    ),
        .reqrsp_req_t                         (xdma_pkg::reqrsp_req_t            ),
        .reqrsp_rsp_t                         (xdma_pkg::reqrsp_rsp_t            ),
        .data_t                               (xdma_pkg::data_t                  ),
        .strb_t                               (xdma_pkg::strb_t                  ),
        .addr_t                               (xdma_pkg::addr_t                  ),
        .len_t                                (xdma_pkg::len_t                   ),
        .xdma_to_remote_cfg_t                 (xdma_pkg::xdma_inter_cluster_cfg_t),
        .xdma_to_remote_data_t                (xdma_pkg::xdma_to_remote_data_t   ),
        .xdma_to_remote_data_accompany_cfg_t  (xdma_pkg::xdma_accompany_cfg_t    ),
        .xdma_req_desc_t                      (xdma_pkg::xdma_req_desc_t         ),
        .xdma_req_meta_t                      (xdma_pkg::xdma_req_meta_t         ),
        .xdma_to_remote_grant_t               (xdma_pkg::xdma_to_remote_grant_t  ),
        .xdma_from_remote_grant_t             (xdma_pkg::xdma_from_remote_grant_t),
        .xdma_from_remote_cfg_t               (xdma_pkg::xdma_inter_cluster_cfg_t),
        .xdma_from_remote_data_t              (xdma_pkg::xdma_from_remote_data_t ),
        .xdma_from_remote_data_accompany_cfg_t(xdma_pkg::xdma_accompany_cfg_t    ),
        .ClusterBaseAddr                      (ClusterBaseAddr),
        .ClusterAddressSpace                  (ClusterAddressSpace),
        .MainMemBaseAddr                      (MainMemBaseAddr),
        .MainMemEndAddr                       (MainMemEndAddr),
        .MMIOSize                             (MMIOSize)
    ) i_xdma_axi_adapter (
        .clk_i                           (clk_i),
        .rst_ni                          (rst_ni),
        .cluster_base_addr_i             (cluster_base_addr_i                ),
        // To remote cfg
        .to_remote_cfg_i                 (xdma_to_remote_cfg                 ),
        .to_remote_cfg_valid_i           (xdma_to_remote_cfg_valid           ),
        .to_remote_cfg_ready_o           (xdma_to_remote_cfg_ready           ),
        // to remote data
        .to_remote_data_i                (xdma_to_remote_data                ),
        .to_remote_data_valid_i          (xdma_to_remote_data_valid          ),
        .to_remote_data_ready_o          (xdma_to_remote_data_ready          ),
        // to remote data accompany cfg
        .to_remote_data_accompany_cfg_i  (xdma_to_remote_data_accompany_cfg  ),
        // from remote cfg
        .from_remote_cfg_o               (xdma_from_remote_cfg               ),
        .from_remote_cfg_valid_o         (xdma_from_remote_cfg_valid         ),
        .from_remote_cfg_ready_i         (xdma_from_remote_cfg_ready         ),
        // from remote data
        .from_remote_data_o              (xdma_from_remote_data              ),
        .from_remote_data_valid_o        (xdma_from_remote_data_valid        ),
        .from_remote_data_ready_i        (xdma_from_remote_data_ready        ),
        // from remote data accompany cfg
        .from_remote_data_accompany_cfg_i(xdma_from_remote_data_accompany_cfg),
        // finish
        .xdma_finish_o                   (xdma_finish                        ),
        // AXI interface
        .axi_xdma_wide_out_req_o         (xdma_wide_out_req_o                ),
        .axi_xdma_wide_out_resp_i        (xdma_wide_out_resp_i               ),
        .axi_xdma_wide_in_req_i          (xdma_wide_in_req_i                 ),
        .axi_xdma_wide_in_resp_o         (xdma_wide_in_resp_o                )
    );




endmodule
