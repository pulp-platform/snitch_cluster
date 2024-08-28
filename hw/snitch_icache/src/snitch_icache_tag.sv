// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

// The actual cache tag memory. This memory is made into a module
// to support multiple power domain needed by the floor plan tool

(* no_ungroup *)
(* no_boundary_optimization *)

module snitch_icache_tag #(
  parameter snitch_icache_pkg::config_t CFG = '0,
  /// Configuration input types for SRAMs used in implementation.
  parameter type sram_cfg_tag_t   = logic
)(
  input  logic                                          clk_i,
  input  logic                                          rst_ni,
  input  sram_cfg_tag_t                                 sram_cfg_tag_i,
  input  logic [  CFG.SET_COUNT-1:0]                    ram_enable_i,
  input  logic                                          ram_write_i,
  input  logic [CFG.COUNT_ALIGN-1:0]                    ram_addr_i,
  input  logic                      [CFG.TAG_WIDTH+1:0] ram_wtag_i,
  output logic [  CFG.SET_COUNT-1:0][CFG.TAG_WIDTH+1:0] ram_rtag_o
);

  for (genvar i = 0; i < CFG.SET_COUNT; i++) begin: g_cache_tag_sets
    tc_sram_impl #(
      .NumWords   ( CFG.LINE_COUNT  ),
      .DataWidth  ( CFG.TAG_WIDTH+2 ),
      .ByteWidth  ( 8               ),
      .NumPorts   ( 1               ),
      .Latency    ( 1               ),
      .impl_in_t  ( sram_cfg_tag_t  )
    ) i_tag (
      .clk_i      ( clk_i           ),
      .rst_ni     ( rst_ni          ),
      .impl_i     ( sram_cfg_tag_i  ),
      .impl_o     ( /*Unused*/      ),
      .req_i      ( ram_enable_i[i] ),
      .we_i       ( ram_write_i     ),
      .addr_i     ( ram_addr_i      ),
      .wdata_i    ( ram_wtag_i      ),
      .be_i       ( '1              ),
      .rdata_o    ( ram_rtag_o[i]   )
    );
  end

endmodule
