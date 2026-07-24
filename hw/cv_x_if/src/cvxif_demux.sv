// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
//
// Demultiplex one CV-X-IF CPU port onto multiple coprocessors, following the
// OpenHWGroup recommendations for implementing multiple coprocessors on a shared
// interface (see the CORE-V-XIF specification). From the CPU's point of view the
// aggregate of coprocessors behaves as a single coprocessor.
//
// The CPU->coprocessor channels (issue request, register, commit) are broadcast
// to all coprocessors. The issue response is de-multiplexed based on the
// `accept` bit: at most one coprocessor is allowed to accept a given instruction
// (`AtMostOneAccept` below), so the aggregate response reduces to an
// accept-masked reduction of the per-coprocessor responses. The result channel
// is arbitrated (round-robin), which supports coprocessors with long-latency
// and/or out-of-order completing instructions.
//
// Coprocessors are expected to be compliant with the specification, in
// particular:
// - `issue_resp.accept` is a combinational function of `issue_req`, valid
//   whenever `issue_valid` is asserted, and mutually exclusive across
//   coprocessors.
// - `register_ready` is asserted only for an instruction the coprocessor
//   accepted.
// - The commit transaction is tolerated for `id`s the coprocessor never
//   accepted.
// - Outputs are driven to 0 when idle, so the response reductions are clean.

`include "common_cells/assertions.svh"

module cvxif_demux #(
  parameter int unsigned NumCopro       = 2,
  parameter type         x_issue_req_t  = logic,
  parameter type         x_issue_resp_t = logic,
  parameter type         x_register_t   = logic,
  parameter type         x_commit_t     = logic,
  parameter type         x_result_t     = logic
) (
  input  logic          clk_i,
  input  logic          rst_ni,
  // CPU side (slave)
  // Issue interface
  input  x_issue_req_t  cpu_issue_req_i,
  output x_issue_resp_t cpu_issue_resp_o,
  input  logic          cpu_issue_valid_i,
  output logic          cpu_issue_ready_o,
  // Register interface
  input  x_register_t   cpu_register_i,
  input  logic          cpu_register_valid_i,
  output logic          cpu_register_ready_o,
  // Commit interface
  input  x_commit_t     cpu_commit_i,
  input  logic          cpu_commit_valid_i,
  // Result interface
  output x_result_t     cpu_result_o,
  output logic          cpu_result_valid_o,
  input  logic          cpu_result_ready_i,
  // Coprocessor side (master). All ports are per-coprocessor arrays; the
  // CPU->coprocessor channels (issue request, register, commit) are broadcast
  // internally to every coprocessor, so instantiation is a plain array connect.
  // Issue interface
  output x_issue_req_t  [NumCopro-1:0] copro_issue_req_o,
  output logic          [NumCopro-1:0] copro_issue_valid_o,
  input  x_issue_resp_t [NumCopro-1:0] copro_issue_resp_i,
  input  logic          [NumCopro-1:0] copro_issue_ready_i,
  // Register interface
  output x_register_t   [NumCopro-1:0] copro_register_o,
  output logic          [NumCopro-1:0] copro_register_valid_o,
  input  logic          [NumCopro-1:0] copro_register_ready_i,
  // Commit interface
  output x_commit_t     [NumCopro-1:0] copro_commit_o,
  output logic          [NumCopro-1:0] copro_commit_valid_o,
  // Result interface
  input  x_result_t     [NumCopro-1:0] copro_result_i,
  input  logic          [NumCopro-1:0] copro_result_valid_i,
  output logic          [NumCopro-1:0] copro_result_ready_o
);

  ///////////////////////////////////
  // Issue and register interfaces //
  ///////////////////////////////////

  // Broadcast the issue request, the register transaction and (below) the commit
  // transaction to every coprocessor, and collect the per-coprocessor accept bit.
  logic [NumCopro-1:0] accept;
  for (genvar i = 0; i < NumCopro; i++) begin : gen_copro
    assign copro_issue_req_o[i]      = cpu_issue_req_i;
    assign copro_issue_valid_o[i]    = cpu_issue_valid_i;
    assign copro_register_o[i]       = cpu_register_i;
    assign copro_register_valid_o[i] = cpu_register_valid_i;
    assign copro_commit_o[i]         = cpu_commit_i;
    assign copro_commit_valid_o[i]   = cpu_commit_valid_i;
    assign accept[i]                 = copro_issue_resp_i[i].accept;
  end
  logic any_accept;
  assign any_accept = |accept;

  // De-multiplex the issue response. Since at most one coprocessor accepts, and
  // the `writeback`/`register_read` fields are only meaningful for the accepting
  // coprocessor, we reduce them masked by `accept` (robust even if a rejecting
  // coprocessor leaves these fields non-zero).
  always_comb begin
    cpu_issue_resp_o = '0;
    cpu_issue_resp_o.accept = any_accept;
    for (int unsigned i = 0; i < NumCopro; i++) begin
      if (accept[i]) begin
        cpu_issue_resp_o.writeback     |= copro_issue_resp_i[i].writeback;
        cpu_issue_resp_o.register_read |= copro_issue_resp_i[i].register_read;
      end
    end
  end

  // Combined handshake. The CPU (Snitch) advances its offload state on the issue
  // handshake but stalls its pipeline on both the issue and register readys, so
  // the two must be asserted atomically and only for the accepting coprocessor.
  // When no coprocessor accepts, complete the handshake immediately so the CPU
  // can flag the instruction as illegal.
  logic handshake;
  assign handshake = any_accept ? |(accept & copro_issue_ready_i & copro_register_ready_i)
                                : 1'b1;
  assign cpu_issue_ready_o    = handshake;
  assign cpu_register_ready_o = handshake;

  //////////////////////
  // Result interface //
  //////////////////////

  // Arbitrate the results produced by the coprocessors onto the single CPU port.
  // A round-robin arbiter (rather than a valid-based de-multiplexer) is required
  // because coprocessors may complete instructions out of order and with
  // variable latency.
  cc_stream_arbiter #(
    .data_t (x_result_t),
    .NumInp (NumCopro  )
  ) i_result_arb (
    .clk_i,
    .rst_ni,
    .clr_i       (1'b0                ),
    .inp_data_i  (copro_result_i      ),
    .inp_valid_i (copro_result_valid_i),
    .inp_ready_o (copro_result_ready_o),
    .oup_data_o  (cpu_result_o        ),
    .oup_valid_o (cpu_result_valid_o  ),
    .oup_ready_i (cpu_result_ready_i  )
  );

  ////////////////
  // Assertions //
  ////////////////

  // The accept-masked response reduction is only correct if no more than one
  // coprocessor accepts an instruction. This must be guaranteed by design (the
  // coprocessors must recognize disjoint instruction sets).
  `ASSERT(AtMostOneAccept, cpu_issue_valid_i |-> $onehot0(accept))

endmodule
