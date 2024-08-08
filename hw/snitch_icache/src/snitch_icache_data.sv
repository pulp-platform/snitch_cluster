// Copyright 2024 KU Leuven.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

// The actual cache memory. This memory is made into a module
// to support multiple power domain needed by the floor plan tool

(* no_ungroup *)
(* no_boundary_optimization *)

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

`ifndef TARGET_TAPEOUT

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

`else

      //----------------------------------------------------
      // This is just a place holder for the synthesis tool
      // The cache memory is wide hence we break it into two
      //----------------------------------------------------
      syn_cache_data_mem i_cache_mem_0(
                  .CLK    ( clk_i                                                 ),
                  .CEB    ( ~ram_enable_i[i]                                      ),
                  .WEB    ( ~ram_write_i                                          ),
                  .A      ( ram_addr_i                                            ),
                  .D      ( ram_wdata_i   [(CFG.LINE_WIDTH)-1:(CFG.LINE_WIDTH)/2] ),
                  .BWEB   ( '0                                                    ),
                  .RTSEL  ( 2'b01                                                 ),
                  .WTSEL  ( 2'b01                                                 ),
                  .Q      ( ram_rdata_o[i][(CFG.LINE_WIDTH)-1:(CFG.LINE_WIDTH)/2] )
      );

      syn_cache_data_mem i_cache_mem_1(
                  .CLK    ( clk_i                                  ),
                  .CEB    ( ~ram_enable_i[i]                       ),
                  .WEB    ( ~ram_write_i                           ),
                  .A      ( ram_addr_i                             ),
                  .D      ( ram_wdata_i   [(CFG.LINE_WIDTH)/2-1:0] ),
                  .BWEB   ( '0                                     ),
                  .RTSEL  ( 2'b01                                  ),
                  .WTSEL  ( 2'b01                                  ),
                  .Q      ( ram_rdata_o[i][(CFG.LINE_WIDTH)/2-1:0] )
      );

`endif

  end

endmodule
