// Copyright 2025 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

`ifndef FPU_INTERFACE_ASSIGN_SVH_
`define FPU_INTERFACE_ASSIGN_SVH_

`define FPU_REQRSP_ASSIGN_REQ(__opt_as, dst, src)   \
  __opt_as dst.q_valid        = src.q_valid;        \
  __opt_as dst.p_ready        = src.p_ready;        \
  __opt_as dst.q.operands     = src.q.operands;     \
  __opt_as dst.q.rnd_mode     = src.q.rnd_mode;     \
  __opt_as dst.q.op           = src.q.op;           \
  __opt_as dst.q.op_mod       = src.q.op_mod;       \
  __opt_as dst.q.src_fmt      = src.q.src_fmt;      \
  __opt_as dst.q.dst_fmt      = src.q.dst_fmt;      \
  __opt_as dst.q.int_fmt      = src.q.int_fmt;      \
  __opt_as dst.q.vectorial_op = src.q.vectorial_op; \
  __opt_as dst.q.tag          = src.q.tag;
`define FPU_REQRSP_ASSIGN_RSP(__opt_as, dst, src) \
  __opt_as dst.p_valid  = src.p_valid;            \
  __opt_as dst.q_ready  = src.q_ready;            \
  __opt_as dst.p.status = src.p.status;           \
  __opt_as dst.p.result = src.p.result;           \
  __opt_as dst.p.tag    = src.p.tag;

`endif
