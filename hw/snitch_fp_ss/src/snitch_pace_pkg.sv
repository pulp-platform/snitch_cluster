// Copyright 2026 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

package snitch_pace_pkg;

  import fpnew_pkg::*;
  import snitch_pkg::*;

  /// Configuration shared by the Snitch PACE integration.
  typedef struct packed {
    logic        enable;
    logic [31:0] memory_size;
    logic [31:0] degree;
    logic [31:0] parts;
    logic [31:0] eps;
    logic [31:0] data_width;
    logic [31:0] param_width;
    logic [31:0] fmt_config;
    logic [31:0] pipe_dist;
  } pace_cfg_t;

  function automatic int unsigned pace_param_count(pace_cfg_t cfg);
    return cfg.enable ?
      ((cfg.degree + 1) * cfg.parts + cfg.parts - 1 + 2 * cfg.eps) : 0;
  endfunction

  function automatic bit pace_enable(pace_cfg_t cfg);
    return cfg.enable;
  endfunction

  function automatic int unsigned pace_memory_size(pace_cfg_t cfg);
    return cfg.memory_size;
  endfunction

  function automatic int unsigned pace_param_width(pace_cfg_t cfg);
    return cfg.param_width;
  endfunction

  function automatic int unsigned pace_degree(pace_cfg_t cfg);
    return cfg.degree;
  endfunction

  function automatic int unsigned pace_parts(pace_cfg_t cfg);
    return cfg.parts;
  endfunction

  function automatic int unsigned pace_eps(pace_cfg_t cfg);
    return cfg.eps;
  endfunction

  function automatic int unsigned pace_data_width(pace_cfg_t cfg);
    return cfg.data_width;
  endfunction

  function automatic int unsigned pace_fmt_config(pace_cfg_t cfg);
    return cfg.fmt_config;
  endfunction

  function automatic int unsigned pace_pipe_dist(pace_cfg_t cfg);
    return cfg.pipe_dist;
  endfunction

  function automatic logic is_pace_instr(input logic [31:0] instr);
    unique casez (instr)
      snitch_riscv_instr::PACE_PWPA_S, snitch_riscv_instr::PACE_INV_S,
      snitch_riscv_instr::PACE_SQRT_S, snitch_riscv_instr::PACE_RSQRT_S,
      snitch_riscv_instr::PACE_PWPA_H, snitch_riscv_instr::PACE_INV_H,
      snitch_riscv_instr::PACE_SQRT_H, snitch_riscv_instr::PACE_RSQRT_H:
        is_pace_instr = 1'b1;
      default: is_pace_instr = 1'b0;
    endcase
  endfunction

  function automatic logic is_vpace_instr(input logic [31:0] instr);
    unique casez (instr)
      snitch_riscv_instr::VPACE_PWPA_S, snitch_riscv_instr::VPACE_INV_S,
      snitch_riscv_instr::VPACE_SQRT_S, snitch_riscv_instr::VPACE_RSQRT_S,
      snitch_riscv_instr::VPACE_PWPA_H, snitch_riscv_instr::VPACE_INV_H,
      snitch_riscv_instr::VPACE_SQRT_H, snitch_riscv_instr::VPACE_RSQRT_H:
        is_vpace_instr = 1'b1;
      default: is_vpace_instr = 1'b0;
    endcase
  endfunction

  function automatic logic is_pace_single_instr(input logic [31:0] instr);
    unique casez (instr)
      snitch_riscv_instr::PACE_PWPA_S, snitch_riscv_instr::PACE_INV_S,
      snitch_riscv_instr::PACE_SQRT_S, snitch_riscv_instr::PACE_RSQRT_S,
      snitch_riscv_instr::VPACE_PWPA_S, snitch_riscv_instr::VPACE_INV_S,
      snitch_riscv_instr::VPACE_SQRT_S, snitch_riscv_instr::VPACE_RSQRT_S:
        is_pace_single_instr = 1'b1;
      default: is_pace_single_instr = 1'b0;
    endcase
  endfunction

  function automatic logic is_pace_half_instr(input logic [31:0] instr);
    unique casez (instr)
      snitch_riscv_instr::PACE_PWPA_H, snitch_riscv_instr::PACE_INV_H,
      snitch_riscv_instr::PACE_SQRT_H, snitch_riscv_instr::PACE_RSQRT_H,
      snitch_riscv_instr::VPACE_PWPA_H, snitch_riscv_instr::VPACE_INV_H,
      snitch_riscv_instr::VPACE_SQRT_H, snitch_riscv_instr::VPACE_RSQRT_H:
        is_pace_half_instr = 1'b1;
      default: is_pace_half_instr = 1'b0;
    endcase
  endfunction

  // The MSB is reserved for a future extended mode; only the lower two bits
  // currently select the PACE operation.
  function automatic logic [2:0] pace_mode_bits(input logic [31:0] instr);
    if (is_pace_instr(instr)) return instr[14:12];
    if (is_vpace_instr(instr)) return instr[27:25];
    return 3'b000;
  endfunction

  function automatic operation_e pace_fpu_op(input logic [1:0] mode);
    unique case (mode)
      2'b01: return PACE_INV;
      2'b10: return PACE_SQRT;
      2'b11: return PACE_RSQRT;
      default: return PWPA;
    endcase
  endfunction

  function automatic pace_mode_t pace_fpu_mode(
    input pace_mode_t core_mode, input logic pace_valid, input logic [1:0] mode);
    pace_fpu_mode = '0;
    pace_fpu_mode.degree = core_mode.degree;
    pace_fpu_mode.enable = pace_valid;
    // mode[2] is reserved for a future extended mode.
    pace_fpu_mode.extend = 1'b0;
  endfunction

endpackage
