// Copyright 2023 Katolieke Universiteit Leuven (KUL)
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Ryan Antonio (ryan.antonio@kuleuven.be)

// verilog_lint: waive-start line-length
// verilog_lint: waive-start no-trailing-spaces

module snax_mac # (
  parameter int unsigned DataWidth         = 32,
  parameter int unsigned SnaxTcdmPorts     = 4,
  parameter type         acc_req_t         = logic,
  parameter type         acc_rsp_t         = logic,
  parameter type         tcdm_req_t        = logic,
  parameter type         tcdm_rsp_t        = logic
)(
  input     logic                               clk_i,
  input     logic                               rst_ni,
  input     logic                               snax_qvalid_i,
  output    logic                               snax_qready_o,
  input     acc_req_t                           snax_req_i,
  output    acc_rsp_t                           snax_resp_o,
  output    logic                               snax_pvalid_o,
  input     logic                               snax_pready_i,
  output    tcdm_req_t  [SnaxTcdmPorts-1:0] snax_tcdm_req_o,
  input     tcdm_rsp_t  [SnaxTcdmPorts-1:0] snax_tcdm_rsp_i
);
  //------------------------------
  // HWPE control interface
  //------------------------------
  hwpe_ctrl_intf_periph #(
      .ID_WIDTH ( 5 )
  ) snax_periph (
      .clk ( clk_i )
  );

  hwpe_stream_intf_tcdm snax_tcdm [SnaxTcdmPorts-1:0] (
      .clk ( clk_i )
  );

  //------------------------------
  // Some brute force typedefs and wiring
  //------------------------------
  typedef logic [31:0] hwpe_mem_addr_t;
  typedef logic [31:0] mem_data_t;
  typedef logic [ 3:0] mem_strb_t;

  typedef struct packed {
    logic           [SnaxTcdmPorts-1:0]  req;
    logic           [SnaxTcdmPorts-1:0]  gnt;
    hwpe_mem_addr_t [SnaxTcdmPorts-1:0]  add;
    logic           [SnaxTcdmPorts-1:0]  wen;
    mem_strb_t      [SnaxTcdmPorts-1:0]  be;
    mem_data_t      [SnaxTcdmPorts-1:0]  data;
    mem_data_t      [SnaxTcdmPorts-1:0]  r_data;
    logic           [SnaxTcdmPorts-1:0]  r_valid;
    logic                                r_opc;
    logic                                r_user;
  } loc_mem_t;

  loc_mem_t snax_mem;

  //------------------------------
  // SNAX HWPE controller
  // Translates the snax valid-ready signals
  // Into HWPE signals
  //------------------------------
  snax_hwpe_ctrl #(
    .DataWidth    ( DataWidth          ), // Default data width
    .acc_req_t    ( acc_req_t          ), // Memory request payload type, usually write enable, write data, etc.
    .acc_rsp_t    ( acc_rsp_t          )  // Memory response payload type, usually read data
  ) i_snax_hwpe_ctrl (
    .clk_i        ( clk_i              ), // Clock
    .rst_ni       ( rst_ni             ), // Asynchronous reset, active low
    .req_i        ( snax_req_i         ), // Request stream interface, payload
    .req_valid_i  ( snax_qvalid_i      ), // Request stream interface, payload is valid for transfer
    .req_ready_o  ( snax_qready_o      ), // Request stream interface, payload can be accepted
    .resp_o       ( snax_resp_o        ), // Response stream interface, payload
    .resp_valid_o ( snax_pvalid_o      ), // Response stream interface, payload is valid for transfer
    .resp_ready_i ( snax_pready_i      ), // Response stream interface, payload can be accepted
    .periph       ( snax_periph        )  // periph master port
  );

  //------------------------------
  // Main MAC engine
  //------------------------------
  mac_top_wrap #(
      .N_CORES      ( 1                   ),
      .MP           ( SnaxTcdmPorts       ),
      .ID           ( 5                   )
  ) i_mac_top (
    .clk_i          ( clk_i               ),
    .rst_ni         ( rst_ni              ),
    .test_mode_i    ( 1'b0                ),
    .evt_o          (                     ),      // Unused
    .tcdm_req       ( snax_mem.req        ),
    .tcdm_gnt       ( snax_mem.gnt        ),      // input
    .tcdm_add       ( snax_mem.add        ),
    .tcdm_wen       ( snax_mem.wen        ),
    .tcdm_be        ( snax_mem.be         ),
    .tcdm_data      ( snax_mem.data       ),
    .tcdm_r_data    ( snax_mem.r_data     ),      // input
    .tcdm_r_valid   ( snax_mem.r_valid    ),      // input
    .periph_req     ( snax_periph.req     ),
    .periph_gnt     ( snax_periph.gnt     ),
    .periph_add     ( snax_periph.add     ),
    .periph_wen     ( snax_periph.wen     ),
    .periph_be      ( snax_periph.be      ),
    .periph_data    ( snax_periph.data    ),
    .periph_id      ( snax_periph.id      ),
    .periph_r_data  ( snax_periph.r_data  ),
    .periph_r_valid ( snax_periph.r_valid ),
    .periph_r_id    ( snax_periph.r_id    )
  );

  //------------------------------
  // Manual remapping and porting of each
  // Streamer to a TCDM with valid-ready response
  // This part goes into the local memory
  //------------------------------
  genvar i;

  for (i = 0; i < SnaxTcdmPorts; i++) begin: gen_map_translate

    assign snax_tcdm       [i].req  = snax_mem.req [i];
    assign snax_mem.gnt    [i]      = snax_tcdm    [i].gnt;
    assign snax_tcdm       [i].add  = snax_mem.add [i];
    assign snax_tcdm       [i].wen  = snax_mem.wen [i];
    assign snax_tcdm       [i].be   = snax_mem.be  [i];
    assign snax_tcdm       [i].data = snax_mem.data[i];
    assign snax_mem.r_data [i]      = snax_tcdm    [i].r_data;
    assign snax_mem.r_valid[i]      = snax_tcdm    [i].r_valid;

    snax_hwpe_to_reqrsp #(
      .DataWidth        ( DataWidth           ),  // Data width to use
      .tcdm_req_t       ( tcdm_req_t          ),  // TCDM request type
      .tcdm_rsp_t       ( tcdm_rsp_t          )   // TCDM response type
    ) i_snax_hwpe_to_reqrsp (
      .clk_i            ( clk_i               ),  // Clock
      .rst_ni           ( rst_ni              ),  // Asynchronous reset, active low
      .tcdm_req_o       ( snax_tcdm_req_o[i]  ),  // TCDM valid ready format
      .tcdm_rsp_i       ( snax_tcdm_rsp_i[i]  ),  // TCDM valid ready format
      .hwpe_tcdm_slave  ( snax_tcdm[i]        )   // HWPE TCDM slave port
    );

  end

// verilog_lint: waive-stop line-length
// verilog_lint: waive-stop no-trailing-spaces

endmodule

/*---------- Module Usage ----------

snax_mac # (
  .DataWidth          ( DataWidth         ),
  .SnaxTcdmPorts      ( SnaxTcdmPorts     ),
  .acc_req_t          ( acc_req_t         ),
  .acc_rsp_t          ( acc_rsp_t         )
  .tcdm_req_t         ( tcdm_req_t        ),
  .tcdm_rsp_t         ( tcdm_rsp_t        )
) i_snax_mac (
  .clk_i              ( clk_i             ),
  .rst_ni             ( rst_ni            ),
  .snax_qvalid_i      ( snax_qvalid_i     ),
  .snax_qready_o      ( snax_qready_o     ),
  .snax_req_i         ( snax_req_i        ),
  .snax_resp_o        ( snax_resp_o       ),
  .snax_pvalid_o      ( snax_pvalid_o     ),
  .snax_pready_i      ( snax_pready_i     ),
  .snax_tcdm_req_o    ( snax_tcdm_req_o   ),
  .snax_tcdm_rsp_i    ( snax_tcdm_rsp_i   )
);

------------------------------------*/
