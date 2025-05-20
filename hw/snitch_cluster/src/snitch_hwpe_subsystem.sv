// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

`include "hci_helpers.svh"

module snitch_hwpe_subsystem
  import hci_package::*;
  import hwpe_ctrl_package::*;
  import reqrsp_pkg::amo_op_e;
#(
  parameter type          tcdm_req_t     = logic,
  parameter type          tcdm_rsp_t     = logic,
  parameter type          periph_req_t   = logic,
  parameter type          periph_rsp_t   = logic,
  parameter int unsigned  HwpeDataWidth  = 256,
  parameter int unsigned  IdWidth        = 8,
  parameter int unsigned  NrCores        = 8,
  parameter  int unsigned TCDMDataWidth  = 64
) (
  input  logic clk_i,
  input  logic rst_ni,
  input  logic test_mode_i,

  // TCDM interface (Master)
  output tcdm_req_t tcdm_req_o,
  input  tcdm_rsp_t tcdm_rsp_i,

  // HWPE control interface (Slave)
  input  periph_req_t hwpe_ctrl_req_i,
  output periph_rsp_t hwpe_ctrl_rsp_o
);

  localparam int unsigned NrTCDMPorts = (HwpeDataWidth / TCDMDataWidth);

  localparam hci_size_parameter_t `HCI_SIZE_PARAM(tcdm) = '{
    DW:  HwpeDataWidth,
    AW:  DEFAULT_AW,
    BW:  DEFAULT_BW,
    UW:  DEFAULT_UW,
    IW:  DEFAULT_IW,
    EW:  0,
    EHW: 0
  };

  logic [1:0] hwpe_clk;
  logic [1:0] clk_en;
  logic mux_sel;

  // Currently unused
  logic [NrCores-1:0][1:0] evt;
  logic busy;

  hwpe_ctrl_intf_periph #(.ID_WIDTH(IdWidth)) periph[0:1] (.clk(clk_i));

  hci_core_intf #(
    `ifndef SYNTHESIS
      .WAIVE_RSP3_ASSERT ( 1'b1 ),
    `endif
    .DW ( HwpeDataWidth )
  ) tcdm (
    .clk (clk_i)
  );

  hci_core_intf #(
    `ifndef SYNTHESIS
      .WAIVE_RSP3_ASSERT ( 1'b1 ),
    `endif
    .DW ( HwpeDataWidth )
  ) tcdm_to_mux [0:1] (
    .clk (clk_i)
  );

  // request channel
  assign tcdm_req_o.q_valid        = tcdm.req;
  assign tcdm_req_o.q.addr         = tcdm.add;
  assign tcdm_req_o.q.write        = ~tcdm.wen;
  assign tcdm_req_o.q.strb         = tcdm.be;
  assign tcdm_req_o.q.data         = tcdm.data;
  assign tcdm_req_o.q.amo          = reqrsp_pkg::AMONone;
  assign tcdm_req_o.q.user         = '0;
  // response channel
  assign tcdm.gnt                  = tcdm_rsp_i.q_ready;
  assign tcdm.r_valid              = tcdm_rsp_i.p_valid;
  assign tcdm.r_data               = tcdm_rsp_i.p.data;
  assign tcdm.r_opc                = '0;
  assign tcdm.r_user               = '0;

  always_comb begin
    periph[0].req           = '0;
    periph[0].add           = '0;
    periph[0].wen           = '0;
    periph[0].be            = '0;
    periph[0].data          = '0;
    periph[0].id            = '0;
    periph[1].req           = '0;
    periph[1].add           = '0;
    periph[1].wen           = '0;
    periph[1].be            = '0;
    periph[1].data          = '0;
    periph[1].id            = '0;
    hwpe_ctrl_rsp_o.q_ready = '0;
    hwpe_ctrl_rsp_o.p.data  = '0;
    hwpe_ctrl_rsp_o.p_valid = '0;

    if ((hwpe_ctrl_req_i.q.addr[7:0] == 'h9C || hwpe_ctrl_req_i.q.addr[7:0] == 'h98) && hwpe_ctrl_req_i.q_valid) begin
      hwpe_ctrl_rsp_o.q_ready = '1;
      hwpe_ctrl_rsp_o.p_valid = '1;
    end else begin
      if(hwpe_ctrl_req_i.q.addr[8] == 1'b0) begin
        periph[0].req              = hwpe_ctrl_req_i.q_valid;
        periph[0].add              = hwpe_ctrl_req_i.q.addr;
        periph[0].wen              = ~hwpe_ctrl_req_i.q.write;
        periph[0].be               = hwpe_ctrl_req_i.q.strb;
        periph[0].data             = hwpe_ctrl_req_i.q.data;
        periph[0].id               = hwpe_ctrl_req_i.q.user;
        hwpe_ctrl_rsp_o.q_ready = periph[0].gnt;
        hwpe_ctrl_rsp_o.p.data  = periph[0].r_data;
        hwpe_ctrl_rsp_o.p_valid = periph[0].r_valid;
      end
      else begin
        periph[1].req              = hwpe_ctrl_req_i.q_valid;
        periph[1].add              = hwpe_ctrl_req_i.q.addr;
        periph[1].wen              = ~hwpe_ctrl_req_i.q.write;
        periph[1].be               = hwpe_ctrl_req_i.q.strb;
        periph[1].data             = hwpe_ctrl_req_i.q.data;
        periph[1].id               = hwpe_ctrl_req_i.q.user;
        hwpe_ctrl_rsp_o.q_ready = periph[1].gnt;
        hwpe_ctrl_rsp_o.p.data  = periph[1].r_data;
        hwpe_ctrl_rsp_o.p_valid = periph[1].r_valid;
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      clk_en <= '0;
    end else begin
      if (hwpe_ctrl_req_i.q.addr[7:0] == 'h9C && hwpe_ctrl_req_i.q_valid && hwpe_ctrl_req_i.q.write) begin
        clk_en <= hwpe_ctrl_req_i.q.data[1:0];
      end
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      mux_sel <= '0;
    end else begin
      if (hwpe_ctrl_req_i.q.addr[7:0] == 'h98 && hwpe_ctrl_req_i.q_valid && hwpe_ctrl_req_i.q.write) begin
        mux_sel <= hwpe_ctrl_req_i.q.data[0];
      end
    end
  end

  tc_clk_gating i_redmule_clk_gate (
    .clk_i     ( clk_i       ),
    .en_i      ( clk_en[0]   ),
    .test_en_i ( '0          ),
    .clk_o     ( hwpe_clk[0] )
  );

  tc_clk_gating i_datamover_clk_gate (
    .clk_i     ( clk_i       ),
    .en_i      ( clk_en[1]   ),
    .test_en_i ( '0          ),
    .clk_o     ( hwpe_clk[1] )
  );

  redmule_top #(
    .ID_WIDTH              ( IdWidth               ),
    .N_CORES               ( NrCores               ),
    .DW                    ( HwpeDataWidth         ),
    .`HCI_SIZE_PARAM(tcdm) ( `HCI_SIZE_PARAM(tcdm) )
  ) i_redmule_top       (
    .clk_i              ( hwpe_clk[0]        ),
    .rst_ni             ( rst_ni             ),
    .test_mode_i        ( test_mode_i        ),
    .evt_o              ( evt                ),
    .busy_o             ( busy               ),
    .tcdm               ( tcdm_to_mux[0]     ),
    .periph             ( periph[0]          )
  );

  datamover_top #(
    .ID                    ( IdWidth               ),
    .N_CORES               ( NrCores               ),
    .`HCI_SIZE_PARAM(tcdm) ( `HCI_SIZE_PARAM(tcdm) )
  ) i_datamover_top (
    .clk_i              ( hwpe_clk[1]        ),
    .rst_ni             ( rst_ni             ),
    .test_mode_i        ( test_mode_i        ),
    .evt_o              (                    ),
    .tcdm               ( tcdm_to_mux[1]     ),
    .periph             ( periph[1]          )
  );
  
  hci_core_mux_static #(
    .NB_CHAN ( 2 ),
    .`HCI_SIZE_PARAM(in) ( `HCI_SIZE_PARAM(tcdm) )
  ) i_static_mux (
    .clk_i   ( clk_i       ),
    .rst_ni  ( rst_ni      ),
    .clear_i ( 1'b0        ),
    .sel_i   ( mux_sel     ),
    .in      ( tcdm_to_mux ),
    .out     ( tcdm        )
  );

endmodule : snitch_hwpe_subsystem
