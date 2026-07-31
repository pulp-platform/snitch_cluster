// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>

`include "reqrsp_interface/typedef.svh"

/// Address-map-based reqrsp demultiplexer.
///
/// Decodes the request address against an address map to select the target
/// master port, and forwards the request through a `reqrsp_demux`. The
/// address-based selection can be overridden externally (e.g. to force a
/// collective/multicast request onto a specific port) by asserting
/// `ext_select_override_i` and driving the desired port on `ext_select_i`.
module reqrsp_demux_mapped #(
    /// Number of master ports.
    parameter int unsigned  NrPorts     = 2,
    /// Request channel type.
    parameter type          req_chan_t  = logic,
    /// Response channel type.
    parameter type          rsp_chan_t  = logic,
    /// Amount of outstanding responses. Determines the response FIFO size.
    parameter int unsigned  RspDepth    = 8,
    /// Number of address map rules.
    parameter int unsigned  NoRules     = 1,
    /// Address type used by the address map.
    parameter type          addr_t      = logic,
    /// Address map rule type. Must be a packed struct `{idx, base, mask}` as
    /// expected by `cc_addr_decode_napot`.
    parameter type          rule_t      = logic,
    // Dependent parameters, DO NOT OVERRIDE!
    localparam int unsigned SelectWidth = cc_pkg::idx_width(NrPorts),
    localparam type         select_t    = logic [SelectWidth-1:0],
    localparam type         req_t       = `REQRSP_REQ_STRUCT(req_chan_t),
    localparam type         rsp_t       = `REQRSP_RSP_STRUCT(rsp_chan_t)
) (
    input  logic                clk_i,
    input  logic                rst_ni,
    /// Address map used to derive the master port from the request address.
    input  rule_t [NoRules-1:0] addr_map_i,
    /// Master port selected when no address map rule matches.
    input  select_t             default_select_i,
    /// Selection used in place of the address-based one when
    /// `ext_select_override_i` is asserted.
    input  select_t             ext_select_i,
    /// Override the internal address-based selection with `ext_select_i`.
    input  logic                ext_select_override_i,
    input  req_t                slv_req_i,
    output rsp_t                slv_rsp_o,
    output req_t [NrPorts-1:0]  mst_req_o,
    input  rsp_t [NrPorts-1:0]  mst_rsp_i
);

  select_t addr_select, slv_select;

  // Address-based master port selection.
  cc_addr_decode_napot #(
    .NoIndices (NrPorts),
    .NoRules   (NoRules),
    .addr_t    (addr_t),
    .rule_t    (rule_t)
  ) i_addr_decode_napot (
    .addr_i           (slv_req_i.q.addr),
    .addr_map_i       (addr_map_i),
    .idx_o            (addr_select),
    .dec_valid_o      (),
    .dec_error_o      (),
    .en_default_idx_i (1'b1),
    .default_idx_i    (default_select_i)
  );

  // Allow the address-based selection to be overridden externally.
  assign slv_select = ext_select_override_i ? ext_select_i : addr_select;

  reqrsp_demux #(
    .NrPorts   (NrPorts),
    .req_chan_t(req_chan_t),
    .rsp_chan_t(rsp_chan_t),
    .Ordered   (1'b1),
    .RspDepth  (RspDepth)
  ) i_reqrsp_demux (
    .clk_i,
    .rst_ni,
    .select_i (slv_select),
    .slv_req_i(slv_req_i),
    .slv_rsp_o(slv_rsp_o),
    .mst_req_o(mst_req_o),
    .mst_rsp_i(mst_rsp_i)
  );

endmodule
