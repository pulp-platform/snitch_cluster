// Copyright 2021 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

package snitch_cluster_pkg;

  /// Fixed bootrom size in kB (always 4 kB).
  localparam int unsigned BootromSize = 4;

  // Slaves on Cluster AXI Bus
  typedef enum integer {
    SoC                = 0,
    TCDM               = 1,
    ClusterPeripherals = 2,
    ExtSlave           = 3
  } cluster_slave_e;

  typedef enum integer {
    CoreReq = 0,
    AXISoC  = 1,
    PTW     = 2
  } cluster_master_e;

  // Slaves on Cluster DMA AXI Bus
  typedef enum int unsigned {
    SoCDMAOut  = 0,
    TCDMDMA    = 1,
    ZeroMemory = 2,
    Bootrom    = 3
  } cluster_slave_dma_e;

  typedef enum int unsigned {
    SoCDMAIn = 32'd0,
    SDMAMst  = 32'd1,
    ICache   = 32'd2
  } cluster_master_dma_e;

  /// Possible interconnect implementations.
  typedef enum bit {
    /// Crossbar implementation. We call it `LogarithmicInterconnect` because the
    /// response path isn't arbitrated.
    LogarithmicInterconnect,
    /// Omega Network. It is isomorphic to a butterfly network.
    OmegaNet
  } topo_e;

  ///////////////////
  // DCA functions //
  ///////////////////

  // Calculate number of DCA lanes. Assumes that the first N cores all have the same datapath
  // width, for some N. This is the value calculated by this function.
  function automatic int unsigned num_dca_lanes_available(
    input snitch_pkg::isa_cfg_t isa_cfg[],
    input int unsigned nr_cores
  );
    automatic int unsigned lanes = 0;
    if (isa_cfg[0].RVV) begin
      for (int i = 0; i < nr_cores; i++) begin
        if (isa_cfg[i].RVV) begin
          lanes++;
        end else begin
          break;
        end
      end
    end else begin
      for (int i = 0; i < nr_cores; i++) begin
        if (!isa_cfg[i].RVV) begin
          lanes++;
        end else begin
          break;
        end
      end
    end
    return lanes;
  endfunction

  // DCA lane width. Assumes that the first N cores all have the same datapath width, for some N,
  // and that these cores are the ones that support DCA.
  function automatic int unsigned dca_lane_width(
    input snitch_pkg::isa_cfg_t isa_cfg[],
    input int unsigned narrow_data_width
  );
    return cc_pkg::datapath_width(isa_cfg[0], narrow_data_width);
  endfunction

  // Maximum DCA data width. Assumes that all DCA lanes have the same datapath width.
  function automatic int unsigned max_dca_width(
    input snitch_pkg::isa_cfg_t isa_cfg[],
    input int unsigned nr_cores,
    input int unsigned narrow_data_width
  );
    return dca_lane_width(isa_cfg, narrow_data_width) * num_dca_lanes_available(isa_cfg, nr_cores);
  endfunction

endpackage
