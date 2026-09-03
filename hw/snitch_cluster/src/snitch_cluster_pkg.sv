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
    BootRom    = 1
  } cluster_slave_dma_e;

    typedef enum logic {
    TCDMDMA   = 0,
    ToSoC     = 1
  } dma_e;

  /// Possible interconnect implementations.
  typedef enum bit {
    /// Crossbar implementation. We call it `LogarithmicInterconnect` because the
    /// response path isn't arbitrated.
    LogarithmicInterconnect,
    /// Omega Network. It is isomorphic to a butterfly network.
    OmegaNet
  } topo_e;

endpackage
