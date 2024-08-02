// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

// The actual cache memory. This memory is made into a module
// to support multiple power domain needed by the floor plan tool

module snitch_icache_data #(
  parameter snitch_icache_pkg::config_t CFG = '0,
  /// Configuration input types for SRAMs used in implementation.
  parameter type sram_cfg_data_t    = logic
)(
  input  logic                                           clk_i,
  input  logic                                           rst_ni,
  input  sram_cfg_data_t                                 sram_cfg_data_i,
  input  logic [  CFG.SET_COUNT-1:0]                     ram_enable_i,
  input  logic                                           ram_write_i,
  input  logic [CFG.COUNT_ALIGN-1:0]                     ram_addr_i,
  input  logic                      [CFG.LINE_WIDTH-1:0] ram_wdata_i,
  output logic [  CFG.SET_COUNT-1:0][CFG.LINE_WIDTH-1:0] ram_rdata_o
);

  for (genvar i = 0; i < CFG.SET_COUNT; i++) begin: g_cache_data_sets
    tc_sram_impl #(
      .NumWords   ( CFG.LINE_COUNT  ),
      .DataWidth  ( CFG.LINE_WIDTH  ),
      .ByteWidth  ( 8               ),
      .NumPorts   ( 1               ),
      .Latency    ( 1               ),
      .impl_in_t  ( sram_cfg_data_t )
    ) i_data (
      .clk_i      ( clk_i           ),
      .rst_ni     ( rst_ni          ),
      .impl_i     ( sram_cfg_data_i ),
      .impl_o     ( /*Unused*/      ),
      .req_i      ( ram_enable_i[i] ),
      .we_i       ( ram_write_i     ),
      .addr_i     ( ram_addr_i      ),
      .wdata_i    ( ram_wdata_i     ),
      .be_i       ( '1              ),
      .rdata_o    ( ram_rdata_o[i]  )
    );
  end

endmodule
