// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Package containing common req resp definitions.
package reqrsp_pkg;

  import snitch_pkg::*;

  /// The given operation falls into the atomic fetch-and-op memory operations.
  function automatic logic is_amo(amo_op_e amo);
    if (amo inside {AMOSwap, AMOAdd, AMOAnd, AMOOr, AMOXor, AMOMax, AMOMaxu, AMOMin, AMOMinu}) begin
      return 1;
    end else begin
      return 0;
    end
  endfunction

  /// Translate to AXI5+ATOP AMOs
  function automatic logic [5:0] to_axi_amo(amo_op_e amo);
    logic [5:0] result;
    unique case (amo)
      AMOSwap: result = axi_pkg::ATOP_ATOMICSWAP;
      AMOAdd: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_ADD};
      // Careful, this case needs to invert the bits on the write data bus.
      AMOAnd: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_CLR};
      AMOOr: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SET};
      AMOXor: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_EOR};
      AMOMax: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMAX};
      AMOMaxu: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMAX};
      AMOMin: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMIN};
      AMOMinu: result = {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMIN};
      default: result = '0;
    endcase
    return result;
  endfunction

  /// Translate from AXI5+ATOP AMOs
  function automatic amo_op_e from_axi_amo(axi_pkg::atop_t amo);
    amo_op_e result;
    unique case (amo)
      axi_pkg::ATOP_ATOMICSWAP: result = AMOSwap;
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_ADD}: result = AMOAdd;
      // Careful, this case needs to invert the bits on the write data bus.
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_CLR}: result = AMOAnd;
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SET}: result = AMOOr;
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_EOR}: result = AMOXor;
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMAX}: result = AMOMax;
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMAX}: result = AMOMaxu;
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_SMIN}: result = AMOMin;
      {axi_pkg::ATOP_ATOMICLOAD, axi_pkg::ATOP_LITTLE_END, axi_pkg::ATOP_UMIN}: result = AMOMinu;
      default: result = AMONone;
    endcase
    return result;
  endfunction
endpackage
