// Copyright 2020 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

/// Integer Processing Unit
/// Author: Florian Zaruba <zarubaf@iis.ee.ethz.ch>
/// Author: Sergio Mazzola, <smazzola@student.ethz.ch>

module snitch_ipu import snitch_pkg::*;  #(
  parameter int unsigned IdWidth = 5,
  parameter bit Xpulpv2 = 0,
  parameter type acc_req_t = logic,
  parameter type acc_resp_t = logic
) (
  input  logic                     clk_i,
  input  logic                     rst_ni,
  // Accelerator Interface - Slave
  input  acc_req_t         acc_req_i,
  input  logic             acc_req_valid_i,
  output logic             acc_req_ready_o,
  output acc_resp_t        acc_resp_o,
  output logic             acc_resp_valid_o,
  input  logic             acc_resp_ready_i
);
  `include "common_cells/registers.svh"

  typedef struct packed {
    logic [31:0]        result;
    logic [IdWidth-1:0] id;
  } result_t;
  // input handshake
  logic div_valid_op, div_ready_op;
  /* verilator lint_off UNDRIVEN */
  logic mul_valid_op, mul_ready_op;
  logic dsp_valid_op, dsp_ready_op;
  /* verilator lint_on UNDRIVEN */
  // output handshake
  logic mul_valid, mul_ready;
  logic div_valid, div_ready;
  logic dsp_valid, dsp_ready;
  result_t div, mul, dsp, oup;
  logic illegal_instruction;

  always_comb begin
    mul_valid_op = 1'b0;
    div_valid_op = 1'b0;
    dsp_valid_op = 1'b0;
    acc_req_ready_o = 1'b0;
    acc_resp_o.error = 1'b0;
    illegal_instruction = 1'b0;
    unique casez (acc_req_i.data_op)
      riscv_instr::MUL,
      riscv_instr::MULH,
      riscv_instr::MULHSU,
      riscv_instr::MULHU: begin
        if (Xpulpv2) begin
          dsp_valid_op = acc_req_valid_i;
          acc_req_ready_o = dsp_ready_op;
        end else begin
          mul_valid_op = acc_req_valid_i;
          acc_req_ready_o = mul_ready_op;
        end
      end
      riscv_instr::DIV,
      riscv_instr::DIVU,
      riscv_instr::REM,
      riscv_instr::REMU: begin
        div_valid_op = acc_req_valid_i;
        acc_req_ready_o = div_ready_op;
      end
      riscv_instr::P_ABS,                 // Xpulpv2: p.abs
      riscv_instr::P_SLET,                // Xpulpv2: p.slet
      riscv_instr::P_SLETU,               // Xpulpv2: p.sletu
      riscv_instr::P_MIN,                 // Xpulpv2: p.min
      riscv_instr::P_MINU,                // Xpulpv2: p.minu
      riscv_instr::P_MAX,                 // Xpulpv2: p.max
      riscv_instr::P_MAXU,                // Xpulpv2: p.maxu
      riscv_instr::P_EXTHS,               // Xpulpv2: p.exths
      riscv_instr::P_EXTHZ,               // Xpulpv2: p.exthz
      riscv_instr::P_EXTBS,               // Xpulpv2: p.extbs
      riscv_instr::P_EXTBZ,               // Xpulpv2: p.extbz
      riscv_instr::P_CLIP,                // Xpulpv2: p.clip
      riscv_instr::P_CLIPU,               // Xpulpv2: p.clipu
      riscv_instr::P_CLIPR,               // Xpulpv2: p.clipr
      riscv_instr::P_CLIPUR,              // Xpulpv2: p.clipur
      riscv_instr::P_MAC,                 // Xpulpv2: p.mac
      riscv_instr::P_MSU,                 // Xpulpv2: p.msu
      riscv_instr::PV_ADD_H,              // Xpulpv2: pv.add.h
      riscv_instr::PV_ADD_SC_H,           // Xpulpv2: pv.add.sc.h
      riscv_instr::PV_ADD_SCI_H,          // Xpulpv2: pv.add.sci.h
      riscv_instr::PV_ADD_B,              // Xpulpv2: pv.add.b
      riscv_instr::PV_ADD_SC_B,           // Xpulpv2: pv.add.sc.b
      riscv_instr::PV_ADD_SCI_B,          // Xpulpv2: pv.add.sci.b
      riscv_instr::PV_SUB_H,              // Xpulpv2: pv.sub.h
      riscv_instr::PV_SUB_SC_H,           // Xpulpv2: pv.sub.sc.h
      riscv_instr::PV_SUB_SCI_H,          // Xpulpv2: pv.sub.sci.h
      riscv_instr::PV_SUB_B,              // Xpulpv2: pv.sub.b
      riscv_instr::PV_SUB_SC_B,           // Xpulpv2: pv.sub.sc.b
      riscv_instr::PV_SUB_SCI_B,          // Xpulpv2: pv.sub.sci.b
      riscv_instr::PV_AVG_H,              // Xpulpv2: pv.avg.h
      riscv_instr::PV_AVG_SC_H,           // Xpulpv2: pv.avg.sc.h
      riscv_instr::PV_AVG_SCI_H,          // Xpulpv2: pv.avg.sci.h
      riscv_instr::PV_AVG_B,              // Xpulpv2: pv.avg.b
      riscv_instr::PV_AVG_SC_B,           // Xpulpv2: pv.avg.sc.b
      riscv_instr::PV_AVG_SCI_B,          // Xpulpv2: pv.avg.sci.b
      riscv_instr::PV_AVGU_H,             // Xpulpv2: pv.avgu.h
      riscv_instr::PV_AVGU_SC_H,          // Xpulpv2: pv.avgu.sc.h
      riscv_instr::PV_AVGU_SCI_H,         // Xpulpv2: pv.avgu.sci.h
      riscv_instr::PV_AVGU_B,             // Xpulpv2: pv.avgu.b
      riscv_instr::PV_AVGU_SC_B,          // Xpulpv2: pv.avgu.sc.b
      riscv_instr::PV_AVGU_SCI_B,         // Xpulpv2: pv.avgu.sci.b
      riscv_instr::PV_MIN_H,              // Xpulpv2: pv.min.h
      riscv_instr::PV_MIN_SC_H,           // Xpulpv2: pv.min.sc.h
      riscv_instr::PV_MIN_SCI_H,          // Xpulpv2: pv.min.sci.h
      riscv_instr::PV_MIN_B,              // Xpulpv2: pv.min.b
      riscv_instr::PV_MIN_SC_B,           // Xpulpv2: pv.min.sc.b
      riscv_instr::PV_MIN_SCI_B,          // Xpulpv2: pv.min.sci.b
      riscv_instr::PV_MINU_H,             // Xpulpv2: pv.minu.h
      riscv_instr::PV_MINU_SC_H,          // Xpulpv2: pv.minu.sc.h
      riscv_instr::PV_MINU_SCI_H,         // Xpulpv2: pv.minu.sci.h
      riscv_instr::PV_MINU_B,             // Xpulpv2: pv.minu.b
      riscv_instr::PV_MINU_SC_B,          // Xpulpv2: pv.minu.sc.b
      riscv_instr::PV_MINU_SCI_B,         // Xpulpv2: pv.minu.sci.b
      riscv_instr::PV_MAX_H,              // Xpulpv2: pv.max.h
      riscv_instr::PV_MAX_SC_H,           // Xpulpv2: pv.max.sc.h
      riscv_instr::PV_MAX_SCI_H,          // Xpulpv2: pv.max.sci.h
      riscv_instr::PV_MAX_B,              // Xpulpv2: pv.max.b
      riscv_instr::PV_MAX_SC_B,           // Xpulpv2: pv.max.sc.b
      riscv_instr::PV_MAX_SCI_B,          // Xpulpv2: pv.max.sci.b
      riscv_instr::PV_MAXU_H,             // Xpulpv2: pv.maxu.h
      riscv_instr::PV_MAXU_SC_H,          // Xpulpv2: pv.maxu.sc.h
      riscv_instr::PV_MAXU_SCI_H,         // Xpulpv2: pv.maxu.sci.h
      riscv_instr::PV_MAXU_B,             // Xpulpv2: pv.maxu.b
      riscv_instr::PV_MAXU_SC_B,          // Xpulpv2: pv.maxu.sc.b
      riscv_instr::PV_MAXU_SCI_B,         // Xpulpv2: pv.maxu.sci.b
      riscv_instr::PV_SRL_H,              // Xpulpv2: pv.srl.h
      riscv_instr::PV_SRL_SC_H,           // Xpulpv2: pv.srl.sc.h
      riscv_instr::PV_SRL_SCI_H,          // Xpulpv2: pv.srl.sci.h
      riscv_instr::PV_SRL_B,              // Xpulpv2: pv.srl.b
      riscv_instr::PV_SRL_SC_B,           // Xpulpv2: pv.srl.sc.b
      riscv_instr::PV_SRL_SCI_B,          // Xpulpv2: pv.srl.sci.b
      riscv_instr::PV_SRA_H,              // Xpulpv2: pv.sra.h
      riscv_instr::PV_SRA_SC_H,           // Xpulpv2: pv.sra.sc.h
      riscv_instr::PV_SRA_SCI_H,          // Xpulpv2: pv.sra.sci.h
      riscv_instr::PV_SRA_B,              // Xpulpv2: pv.sra.b
      riscv_instr::PV_SRA_SC_B,           // Xpulpv2: pv.sra.sc.b
      riscv_instr::PV_SRA_SCI_B,          // Xpulpv2: pv.sra.sci.b
      riscv_instr::PV_SLL_H,              // Xpulpv2: pv.sll.h
      riscv_instr::PV_SLL_SC_H,           // Xpulpv2: pv.sll.sc.h
      riscv_instr::PV_SLL_SCI_H,          // Xpulpv2: pv.sll.sci.h
      riscv_instr::PV_SLL_B,              // Xpulpv2: pv.sll.b
      riscv_instr::PV_SLL_SC_B,           // Xpulpv2: pv.sll.sc.b
      riscv_instr::PV_SLL_SCI_B,          // Xpulpv2: pv.sll.sci.b
      riscv_instr::PV_OR_H,               // Xpulpv2: pv.or.h
      riscv_instr::PV_OR_SC_H,            // Xpulpv2: pv.or.sc.h
      riscv_instr::PV_OR_SCI_H,           // Xpulpv2: pv.or.sci.h
      riscv_instr::PV_OR_B,               // Xpulpv2: pv.or.b
      riscv_instr::PV_OR_SC_B,            // Xpulpv2: pv.or.sc.b
      riscv_instr::PV_OR_SCI_B,           // Xpulpv2: pv.or.sci.b
      riscv_instr::PV_XOR_H,              // Xpulpv2: pv.xor.h
      riscv_instr::PV_XOR_SC_H,           // Xpulpv2: pv.xor.sc.h
      riscv_instr::PV_XOR_SCI_H,          // Xpulpv2: pv.xor.sci.h
      riscv_instr::PV_XOR_B,              // Xpulpv2: pv.xor.b
      riscv_instr::PV_XOR_SC_B,           // Xpulpv2: pv.xor.sc.b
      riscv_instr::PV_XOR_SCI_B,          // Xpulpv2: pv.xor.sci.b
      riscv_instr::PV_AND_H,              // Xpulpv2: pv.and.h
      riscv_instr::PV_AND_SC_H,           // Xpulpv2: pv.and.sc.h
      riscv_instr::PV_AND_SCI_H,          // Xpulpv2: pv.and.sci.h
      riscv_instr::PV_AND_B,              // Xpulpv2: pv.and.b
      riscv_instr::PV_AND_SC_B,           // Xpulpv2: pv.and.sc.b
      riscv_instr::PV_AND_SCI_B,          // Xpulpv2: pv.and.sci.b
      riscv_instr::PV_ABS_H,              // Xpulpv2: pv.abs.h
      riscv_instr::PV_ABS_B,              // Xpulpv2: pv.abs.b
      riscv_instr::PV_EXTRACT_H,          // Xpulpv2: pv.extract.h
      riscv_instr::PV_EXTRACT_B,          // Xpulpv2: pv.extract.b
      riscv_instr::PV_EXTRACTU_H,         // Xpulpv2: pv.extractu.h
      riscv_instr::PV_EXTRACTU_B,         // Xpulpv2: pv.extractu.b
      riscv_instr::PV_INSERT_H,           // Xpulpv2: pv.insert.h
      riscv_instr::PV_INSERT_B,           // Xpulpv2: pv.insert.b
      riscv_instr::PV_DOTUP_H,            // Xpulpv2: pv.dotup.h
      riscv_instr::PV_DOTUP_SC_H,         // Xpulpv2: pv.dotup.sc.h
      riscv_instr::PV_DOTUP_SCI_H,        // Xpulpv2: pv.dotup.sci.h
      riscv_instr::PV_DOTUP_B,            // Xpulpv2: pv.dotup.b
      riscv_instr::PV_DOTUP_SC_B,         // Xpulpv2: pv.dotup.sc.b
      riscv_instr::PV_DOTUP_SCI_B,        // Xpulpv2: pv.dotup.sci.b
      riscv_instr::PV_DOTUSP_H,           // Xpulpv2: pv.dotusp.h
      riscv_instr::PV_DOTUSP_SC_H,        // Xpulpv2: pv.dotusp.sc.h
      riscv_instr::PV_DOTUSP_SCI_H,       // Xpulpv2: pv.dotusp.sci.h
      riscv_instr::PV_DOTUSP_B,           // Xpulpv2: pv.dotusp.b
      riscv_instr::PV_DOTUSP_SC_B,        // Xpulpv2: pv.dotusp.sc.b
      riscv_instr::PV_DOTUSP_SCI_B,       // Xpulpv2: pv.dotusp.sci.b
      riscv_instr::PV_DOTSP_H,            // Xpulpv2: pv.dotsp.h
      riscv_instr::PV_DOTSP_SC_H,         // Xpulpv2: pv.dotsp.sc.h
      riscv_instr::PV_DOTSP_SCI_H,        // Xpulpv2: pv.dotsp.sci.h
      riscv_instr::PV_DOTSP_B,            // Xpulpv2: pv.dotsp.b
      riscv_instr::PV_DOTSP_SC_B,         // Xpulpv2: pv.dotsp.sc.b
      riscv_instr::PV_DOTSP_SCI_B,        // Xpulpv2: pv.dotsp.sci.b
      riscv_instr::PV_SDOTUP_H,           // Xpulpv2: pv.sdotup.h
      riscv_instr::PV_SDOTUP_SC_H,        // Xpulpv2: pv.sdotup.sc.h
      riscv_instr::PV_SDOTUP_SCI_H,       // Xpulpv2: pv.sdotup.sci.h
      riscv_instr::PV_SDOTUP_B,           // Xpulpv2: pv.sdotup.b
      riscv_instr::PV_SDOTUP_SC_B,        // Xpulpv2: pv.sdotup.sc.b
      riscv_instr::PV_SDOTUP_SCI_B,       // Xpulpv2: pv.sdotup.sci.b
      riscv_instr::PV_SDOTUSP_H,          // Xpulpv2: pv.sdotusp.h
      riscv_instr::PV_SDOTUSP_SC_H,       // Xpulpv2: pv.sdotusp.sc.h
      riscv_instr::PV_SDOTUSP_SCI_H,      // Xpulpv2: pv.sdotusp.sci.h
      riscv_instr::PV_SDOTUSP_B,          // Xpulpv2: pv.sdotusp.b
      riscv_instr::PV_SDOTUSP_SC_B,       // Xpulpv2: pv.sdotusp.sc.b
      riscv_instr::PV_SDOTUSP_SCI_B,      // Xpulpv2: pv.sdotusp.sci.b
      riscv_instr::PV_SDOTSP_H,           // Xpulpv2: pv.sdotsp.h
      riscv_instr::PV_SDOTSP_SC_H,        // Xpulpv2: pv.sdotsp.sc.h
      riscv_instr::PV_SDOTSP_SCI_H,       // Xpulpv2: pv.sdotsp.sci.h
      riscv_instr::PV_SDOTSP_B,           // Xpulpv2: pv.sdotsp.b
      riscv_instr::PV_SDOTSP_SC_B,        // Xpulpv2: pv.sdotsp.sc.b
      riscv_instr::PV_SDOTSP_SCI_B,       // Xpulpv2: pv.sdotsp.sci.b
      riscv_instr::PV_SHUFFLE2_H,         // Xpulpv2: pv.shuffle2.h
      riscv_instr::PV_SHUFFLE2_B,         // Xpulpv2: pv.shuffle2.b
      riscv_instr::PV_PACK,               // Xpulpv2: pv.pack
      riscv_instr::PV_PACK_H: begin       // Xpulpv2: pv.pack.h
        if (Xpulpv2) begin
          dsp_valid_op = acc_req_valid_i;
          acc_req_ready_o = dsp_ready_op;
        end else begin
          illegal_instruction = 1'b1;
        end
      end
      default: illegal_instruction = 1'b1;
    endcase
  end

  // Serial Divider
  snitch_serial_divider #(
      .WIDTH       ( 32      ),
      .IdWidth     ( IdWidth )
  ) i_div (
      .clk_i       ( clk_i                    ),
      .rst_ni      ( rst_ni                   ),
      .id_i        ( acc_req_i.id             ),
      .operator_i  ( acc_req_i.data_op        ),
      .op_a_i      ( acc_req_i.data_arga[31:0]),
      .op_b_i      ( acc_req_i.data_argb[31:0]),
      .in_vld_i    ( div_valid_op             ),
      .in_rdy_o    ( div_ready_op             ),
      .out_vld_o   ( div_valid                ),
      .out_rdy_i   ( div_ready                ),
      .id_o        ( div.id                   ),
      .res_o       ( div.result               )
  );

  if (Xpulpv2) begin : gen_Xpulpv2
    // DSP Unit
    dspu #(
        .Width    ( 32      ),
        .IdWidth  ( IdWidth )
    ) i_dspu (
        .clk_i       ( clk_i                    ),
        .rst_ni      ( rst_ni                   ),
        .id_i        ( acc_req_i.id             ),
        .operator_i  ( acc_req_i.data_op        ),
        .op_a_i      ( acc_req_i.data_arga[31:0]),
        .op_b_i      ( acc_req_i.data_argb[31:0]),
        .op_c_i      ( acc_req_i.data_argc[31:0]),
        .in_valid_i  ( dsp_valid_op             ),
        .in_ready_o  ( dsp_ready_op             ),
        .out_valid_o ( dsp_valid                ),
        .out_ready_i ( dsp_ready                ),
        .id_o        ( dsp.id                   ),
        .result_o    ( dsp.result               )
    );
    // Output Arbitration
    stream_arbiter #(
      .DATA_T ( result_t ),
      .N_INP  ( 2        )
    ) i_stream_arbiter (
      .clk_i,
      .rst_ni,
      .inp_data_i  ( {div, dsp}             ),
      .inp_valid_i ( {div_valid, dsp_valid} ),
      .inp_ready_o ( {div_ready, dsp_ready} ),
      .oup_data_o  ( oup                    ),
      .oup_valid_o ( acc_resp_valid_o       ),
      .oup_ready_i ( acc_resp_ready_i       )
    );
  end else begin : gen_vanilla
    // Multiplication
    snitch_multiplier #(
      .Width    ( 32      ),
      .IdWidth  ( IdWidth )
    ) i_multiplier (
      .clk_i,
      .rst_ni,
      .id_i        ( acc_req_i.id             ),
      .operator_i  ( acc_req_i.data_op        ),
      .operand_a_i ( acc_req_i.data_arga[31:0]),
      .operand_b_i ( acc_req_i.data_argb[31:0]),
      .valid_i     ( mul_valid_op             ),
      .ready_o     ( mul_ready_op             ),
      .result_o    ( mul.result               ),
      .valid_o     ( mul_valid                ),
      .ready_i     ( mul_ready                ),
      .id_o        ( mul.id                   )
    );
    // Output Arbitration
    stream_arbiter #(
      .DATA_T ( result_t ),
      .N_INP  ( 2        )
    ) i_stream_arbiter (
      .clk_i,
      .rst_ni,
      .inp_data_i  ( {div, mul}             ),
      .inp_valid_i ( {div_valid, mul_valid} ),
      .inp_ready_o ( {div_ready, mul_ready} ),
      .oup_data_o  ( oup                    ),
      .oup_valid_o ( acc_resp_valid_o       ),
      .oup_ready_i ( acc_resp_ready_i       )
    );
  end

  assign acc_resp_o.data = oup.result;
  assign acc_resp_o.id = oup.id;
endmodule

module dspu #(
  parameter int unsigned Width = 32,
  parameter int unsigned IdWidth = 5
) (
    input  logic               clk_i,      // unused
    input  logic               rst_ni,     // unused
    input  logic [IdWidth-1:0] id_i,
    input  logic [31:0]        operator_i,
    input  logic [Width-1:0]   op_a_i,
    input  logic [Width-1:0]   op_b_i,
    input  logic [Width-1:0]   op_c_i,
    input  logic               in_valid_i,
    output logic               in_ready_o,
    output logic               out_valid_o,
    input  logic               out_ready_i,
    output logic [IdWidth-1:0] id_o,
    output logic [Width-1:0]   result_o
);

  typedef struct packed {
    logic [31:0] op_a;
    logic [31:0] op_b;
    logic [31:0] op_c;
    logic [5:0] imm6;
  } dspu_input_t;

  typedef enum logic [1:0] {
    None, Reg, Zero, ClipBound
  } cmp_op_b_sel_e;

  typedef enum logic [1:0] {
    NoMul, MulLow, MulHigh, MulMac
  } mac_op_e;

  typedef enum logic [4:0] {
    SimdNop, SimdAdd, SimdSub, SimdAvg, SimdMin, SimdMax, SimdSrl, SimdSra, SimdSll, SimdOr,
    SimdXor, SimdAnd, SimdAbs, SimdExt, SimdIns, SimdDotp, SimdShuffle, SimdPack
  } simd_op_e;

  typedef enum logic {
    HalfWord, Byte
  } simd_size_e;

  typedef enum logic [1:0] {
    Vect, Sc, Sci, High
  } simd_mode_e;

  typedef enum logic [3:0] {
    Nop, Abs, Sle, Min, Max, Exths, Exthz, Extbs, Extbz, Clip, Mac, Simd
  } res_sel_e;

  // Control signals
  assign out_valid_o = in_valid_i;
  assign in_ready_o = out_ready_i;
  assign id_o = id_i;

  // Decoded fields
  logic [4:0] imm5;
  logic [5:0] imm6;
  assign imm5 = operator_i[24:20];
  assign imm6 = {operator_i[24:20], operator_i[25]};

  // Internal control signals
  logic cmp_signed;            // comparator operation is signed
  cmp_op_b_sel_e cmp_op_b_sel; // selection of shared comparator operands
  logic clip_unsigned;         // clip operation has "0" as lower bound
  logic clip_register;         // if 1 clip operation uses rs2, else imm5

  dspu_input_t mac_gated;
  mac_op_e mac_op;             // type of multiplication operation
  logic mac_msu;               // multiplication operation is MSU
  logic mac_op_a_sign;         // sign of multiplier operand a
  logic mac_op_b_sign;         // sign of multiplier operand b

  dspu_input_t simd_gated;
  simd_op_e simd_op;           // SIMD operation
  simd_size_e simd_size;       // SIMD granularity
  simd_mode_e simd_mode;       // SIMD mode
  logic simd_signed;           // SIMD operation is signed and uses sign-extended imm6
  logic simd_dotp_op_a_signed; // signedness of SIMD dotp operand a
  logic simd_dotp_op_b_signed; // signedness of SIMD dotp operand b
  logic simd_dotp_acc;         // accumulate result of SIMD dotp on destination reg

  res_sel_e res_sel;  // result selection

  // --------------------
  // Decoder
  // --------------------

  // decoder plugin for gating
  always_comb begin
    mac_gated = 'b0;
    simd_gated = 'b0;
    if (mac_op != NoMul) begin
      mac_gated.op_a = op_a_i;
      mac_gated.op_b = op_b_i;
      mac_gated.op_c = op_c_i;
      mac_gated.imm6 = imm6;
    end else if (simd_op != SimdNop) begin
      simd_gated.op_a = op_a_i;
      simd_gated.op_b = op_b_i;
      simd_gated.op_c = op_c_i;
      simd_gated.imm6 = imm6;
    end
  end

  always_comb begin
    cmp_signed = 1'b1;
    cmp_op_b_sel = None;
    clip_unsigned = 1'b0;
    clip_register = 1'b0;
    mac_op = NoMul;
    mac_msu = 1'b0;
    mac_op_a_sign = 1'b0;
    mac_op_b_sign = 1'b0;
    res_sel = Nop;
    simd_op = SimdNop;
    simd_size = HalfWord;
    simd_mode = Vect;
    simd_signed = 1;
    simd_dotp_op_a_signed = 1;
    simd_dotp_op_b_signed = 1;
    simd_dotp_acc = 0;
    unique casez (operator_i)
      // Multiplications from M extension
      riscv_instr::MUL: begin
        mac_op = MulLow;
        mac_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::MULH: begin
        mac_op = MulHigh;
        mac_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::MULHSU: begin
        mac_op = MulHigh;
        mac_op_a_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::MULHU: begin
        mac_op = MulHigh;
        res_sel = Mac;
      end
      // Instructions from Xpulpv2
      riscv_instr::P_ABS: begin
        cmp_op_b_sel = Zero;
        res_sel = Abs;
      end
      riscv_instr::P_SLET: begin
        cmp_op_b_sel = Reg;
        res_sel = Sle;
      end
      riscv_instr::P_SLETU: begin
        cmp_signed = 1'b0;
        cmp_op_b_sel = Reg;
        res_sel = Sle;
      end
      riscv_instr::P_MIN: begin
        cmp_op_b_sel = Reg;
        res_sel = Min;
      end
      riscv_instr::P_MINU: begin
        cmp_signed = 1'b0;
        cmp_op_b_sel = Reg;
        res_sel = Min;
      end
      riscv_instr::P_MAX: begin
        cmp_op_b_sel = Reg;
        res_sel = Max;
      end
      riscv_instr::P_MAXU: begin
        cmp_signed = 1'b0;
        cmp_op_b_sel = Reg;
        res_sel = Max;
      end
      riscv_instr::P_EXTHS: begin
        cmp_op_b_sel = Reg;
        res_sel = Exths;
      end
      riscv_instr::P_EXTHZ: begin
        cmp_op_b_sel = Reg;
        res_sel = Exthz;
      end
      riscv_instr::P_EXTBS: begin
        cmp_op_b_sel = Reg;
        res_sel = Extbs;
      end
      riscv_instr::P_EXTBZ: begin
        cmp_op_b_sel = Reg;
        res_sel = Extbz;
      end
      riscv_instr::P_CLIP: begin
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_CLIPU: begin
        clip_unsigned = 1'b1;
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_CLIPR: begin
        clip_register = 1'b1;
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_CLIPUR: begin
        clip_unsigned = 1'b1;
        clip_register = 1'b1;
        cmp_op_b_sel = ClipBound;
        res_sel = Clip;
      end
      riscv_instr::P_MAC: begin
        mac_op = MulMac;
        mac_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::P_MSU: begin
        mac_op = MulMac;
        mac_msu = 1'b1;
        mac_op_a_sign = 1'b1;
        mac_op_b_sign = 1'b1;
        res_sel = Mac;
      end
      riscv_instr::PV_ADD_H: begin
        simd_op = SimdAdd;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SC_H: begin
        simd_op = SimdAdd;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SCI_H: begin
        simd_op = SimdAdd;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_B: begin
        simd_op = SimdAdd;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SC_B: begin
        simd_op = SimdAdd;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_ADD_SCI_B: begin
        simd_op = SimdAdd;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_H: begin
        simd_op = SimdSub;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SC_H: begin
        simd_op = SimdSub;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SCI_H: begin
        simd_op = SimdSub;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_B: begin
        simd_op = SimdSub;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SC_B: begin
        simd_op = SimdSub;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SUB_SCI_B: begin
        simd_op = SimdSub;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_H: begin
        simd_op = SimdAvg;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SC_H: begin
        simd_op = SimdAvg;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SCI_H: begin
        simd_op = SimdAvg;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SC_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AVG_SCI_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_H: begin
        simd_op = SimdAvg;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SC_H: begin
        simd_op = SimdAvg;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SCI_H: begin
        simd_op = SimdAvg;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SC_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_AVGU_SCI_B: begin
        simd_op = SimdAvg;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_H: begin
        simd_op = SimdMin;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SC_H: begin
        simd_op = SimdMin;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SCI_H: begin
        simd_op = SimdMin;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SC_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MIN_SCI_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_H: begin
        simd_op = SimdMin;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SC_H: begin
        simd_op = SimdMin;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SCI_H: begin
        simd_op = SimdMin;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SC_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MINU_SCI_B: begin
        simd_op = SimdMin;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_H: begin
        simd_op = SimdMax;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SC_H: begin
        simd_op = SimdMax;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SCI_H: begin
        simd_op = SimdMax;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SC_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_MAX_SCI_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_H: begin
        simd_op = SimdMax;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SC_H: begin
        simd_op = SimdMax;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SCI_H: begin
        simd_op = SimdMax;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SC_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_MAXU_SCI_B: begin
        simd_op = SimdMax;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_H: begin
        simd_op = SimdSrl;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SC_H: begin
        simd_op = SimdSrl;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SCI_H: begin
        simd_op = SimdSrl;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_B: begin
        simd_op = SimdSrl;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SC_B: begin
        simd_op = SimdSrl;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRL_SCI_B: begin
        simd_op = SimdSrl;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_H: begin
        simd_op = SimdSra;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SC_H: begin
        simd_op = SimdSra;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SCI_H: begin
        simd_op = SimdSra;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_B: begin
        simd_op = SimdSra;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SC_B: begin
        simd_op = SimdSra;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SRA_SCI_B: begin
        simd_op = SimdSra;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_H: begin
        simd_op = SimdSll;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SC_H: begin
        simd_op = SimdSll;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SCI_H: begin
        simd_op = SimdSll;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_B: begin
        simd_op = SimdSll;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SC_B: begin
        simd_op = SimdSll;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_SLL_SCI_B: begin
        simd_op = SimdSll;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_H: begin
        simd_op = SimdOr;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SC_H: begin
        simd_op = SimdOr;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SCI_H: begin
        simd_op = SimdOr;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_B: begin
        simd_op = SimdOr;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SC_B: begin
        simd_op = SimdOr;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_OR_SCI_B: begin
        simd_op = SimdOr;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_H: begin
        simd_op = SimdXor;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SC_H: begin
        simd_op = SimdXor;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SCI_H: begin
        simd_op = SimdXor;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_B: begin
        simd_op = SimdXor;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SC_B: begin
        simd_op = SimdXor;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_XOR_SCI_B: begin
        simd_op = SimdXor;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_H: begin
        simd_op = SimdAnd;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SC_H: begin
        simd_op = SimdAnd;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SCI_H: begin
        simd_op = SimdAnd;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_B: begin
        simd_op = SimdAnd;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SC_B: begin
        simd_op = SimdAnd;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_AND_SCI_B: begin
        simd_op = SimdAnd;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_ABS_H: begin
        simd_op = SimdAbs;
        res_sel = Simd;
      end
      riscv_instr::PV_ABS_B: begin
        simd_op = SimdAbs;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACT_H: begin
        simd_op = SimdExt;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACT_B: begin
        simd_op = SimdExt;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACTU_H: begin
        simd_op = SimdExt;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_EXTRACTU_B: begin
        simd_op = SimdExt;
        simd_size = Byte;
        simd_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_INSERT_H: begin
        simd_op = SimdIns;
        res_sel = Simd;
      end
      riscv_instr::PV_INSERT_B: begin
        simd_op = SimdIns;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_H: begin
        simd_op = SimdDotp;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_H: begin
        simd_op = SimdDotp;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTUSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_H: begin
        simd_op = SimdDotp;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        res_sel = Simd;
      end
      riscv_instr::PV_DOTSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_H: begin
        simd_op = SimdDotp;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_signed = 0;
        simd_dotp_op_a_signed = 0;
        simd_dotp_op_b_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_H: begin
        simd_op = SimdDotp;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTUSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_dotp_op_a_signed = 0;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_H: begin
        simd_op = SimdDotp;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SC_H: begin
        simd_op = SimdDotp;
        simd_mode = Sc;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SCI_H: begin
        simd_op = SimdDotp;
        simd_mode = Sci;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SC_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sc;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SDOTSP_SCI_B: begin
        simd_op = SimdDotp;
        simd_size = Byte;
        simd_mode = Sci;
        simd_dotp_acc = 1;
        res_sel = Simd;
      end
      riscv_instr::PV_SHUFFLE2_H: begin
        simd_op = SimdShuffle;
        res_sel = Simd;
      end
      riscv_instr::PV_SHUFFLE2_B: begin
        simd_op = SimdShuffle;
        simd_size = Byte;
        res_sel = Simd;
      end
      riscv_instr::PV_PACK: begin
        simd_op = SimdPack;
        res_sel = Simd;
      end
      riscv_instr::PV_PACK_H: begin
        simd_op = SimdPack;
        simd_mode = High;
        res_sel = Simd;
      end
      default: ;
    endcase
  end

  //  ___    _  _____  _    ___   _  _____  _  _
  // |   \  /_\|_   _|/_\  | _ \ /_\|_   _|| || |
  // | |) |/ _ \ | | / _ \ |  _// _ \ | |  | __ |
  // |___//_/ \_\|_|/_/ \_\|_| /_/ \_\|_|  |_||_|
  //

  // --------------------
  // Clips
  // --------------------
  logic clip_use_n_bound;
  logic [Width-1:0] clip_op_b_n, clip_op_b; // clip lower and upper bounds
  logic [Width-1:0] clip_lower;
  logic [Width-1:0] clip_comp;

  // Generate -2^(imm5-1), 2^(imm5-1)-1 for clip/clipu and -rs2-1, rs2 for clipr, clipur
  assign clip_lower = ({(Width+1){1'b1}} << $unsigned(imm5)) >> 1;
  assign clip_op_b_n = clip_unsigned ? 'b0 : (clip_register ? ~op_b_i : clip_lower);
  assign clip_op_b = clip_register ? op_b_i : ~clip_lower;

  // is 1 when NOT(rs1 >= 0 AND clip_op_b >= 0), i.e. at least one operand is negative
  assign clip_use_n_bound = op_a_i[Width-1] | clip_op_b[Width-1];

  // Select operand to use in comparison for clip operations: clips would need two comparisons
  // to clamp the result between the two bounds; but one comparison is enough if we select the
  // second operand basing on op_a and clip_op_b signs (i.e. rs1 and clip upper bound, being
  // either rs2 or 2^(imm5-1)-1)
  assign clip_comp = clip_use_n_bound ? clip_op_b_n : clip_op_b;

  // --------------------
  // Shared comparator
  // --------------------
  logic [Width-1:0] cmp_op_a, cmp_op_b;
  logic cmp_result;

  // Comparator operand A assignment
  assign cmp_op_a = op_a_i;
  // Comparator operand B assignment
  always_comb begin
    unique case (cmp_op_b_sel)
      Reg: cmp_op_b = op_b_i;
      Zero: cmp_op_b = '0;
      ClipBound: cmp_op_b = clip_comp;
      default: cmp_op_b = '0;
    endcase
  end

  // Instantiate comparator
  assign cmp_result = $signed({cmp_op_a[Width-1] & cmp_signed, cmp_op_a}) <=
    $signed({cmp_op_b[Width-1] & cmp_signed, cmp_op_b});

  // --------------------
  // Multiplier & acc
  // --------------------

  // 32x32 into 32 bits multiplier & accumulator
  logic [Width-1:0] mac_op_a;
  logic [2*Width-1:0] mul_result;
  logic [Width-1:0] mac_result;

  // op_a_i is sign-inverted if mac_msu=1, to have -op_a*op_b
  assign mac_op_a = mac_msu ? -mac_gated.op_a : mac_gated.op_a;

  // 32-bits input, 64-bits output multiplier
  assign mul_result = $signed({mac_op_a[Width-1] & mac_op_a_sign, mac_op_a}) *
    $signed({mac_gated.op_b[Width-1] & mac_op_b_sign, mac_gated.op_b});

  always_comb begin
    unique case (mac_op)
      MulLow: mac_result = mul_result[Width-1:0]; // mul, take lowest 32 bits
      MulHigh: mac_result = mul_result[2*Width-1:Width]; // mul high, take highest 32 bits
      MulMac: mac_result = mac_gated.op_c + mul_result[Width-1:0]; // accumulate
      default: mac_result = '0;
    endcase
  end

  // --------------------
  // SIMD operations
  // --------------------

  logic [3:0][7:0] simd_op_a, simd_op_b, simd_op_c;
  logic [1:0][7:0] simd_imm;
  logic [3:0][7:0] simd_result;

  // half-word and byte immediate extensions
  always_comb
    if(simd_signed) simd_imm = $signed(simd_gated.imm6);
    else simd_imm = $unsigned(simd_gated.imm6);

  // SIMD operands composition
  always_comb begin
    simd_op_a = 'b0;
    simd_op_b = 'b0;
    simd_op_c = 'b0;
    unique case (simd_size)
      // half-word granularity
      HalfWord:
        for (int i = 0; i < Width/16; i++) begin
          // operands A are the half-words of op_a_i
          simd_op_a[2*i +: 2] = simd_gated.op_a[16*i +: 16];
          // operands B are the half-words of op_b_i, replicated lowest half-word of op_b_i or
          // replicated 6-bit immediate
          simd_op_b[2*i +: 2] = ((simd_mode == Vect) || (simd_mode == High)) ?
            simd_gated.op_b[16*i +: 16] : ((simd_mode == Sc) ? simd_gated.op_b[15:0] : simd_imm);
          // operands C are the half-words of op_c_i
          simd_op_c[2*i +: 2] = simd_gated.op_c[16*i +: 16];
        end
      // byte granularity
      Byte:
        for (int i = 0; i < Width/8; i++) begin
          // operands A are the bytes of op_a_i
          simd_op_a[i] = simd_gated.op_a[8*i +: 8];
          // operands B are the bytes of op_b_i, replicated lowest byte of op_b_i or
          // replicated 6-bit immediate
          simd_op_b[i] = (simd_mode == Vect) ? simd_gated.op_b[8*i +: 8] :
            ((simd_mode == Sc) ? simd_gated.op_b[7:0] : simd_imm[0]);
          simd_op_c[i] = simd_gated.op_c[8*i +: 8]; // operands C are the bytes of op_c_i
        end
      default: ;
    endcase
  end

  // SIMD unit
  always_comb begin
    simd_result = 'b0;
    unique case (simd_size)
      // half-word granularity
      HalfWord: begin
        unique case (simd_op)
          SimdAdd:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) + $signed(simd_op_b[2*i +: 2]);
          SimdSub:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) - $signed(simd_op_b[2*i +: 2]);
          SimdAvg:
            for (int i = 0; i < Width/16; i++) begin
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) + $signed(simd_op_b[2*i +: 2]);
              simd_result[2*i +: 2] =
                {simd_result[2*i+1][7] & simd_signed, simd_result[2*i +: 2]} >> 1;
            end
          SimdMin:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] =
                $signed({simd_op_a[2*i+1][7] & simd_signed, simd_op_a[2*i +: 2]}) <=
                $signed({simd_op_b[2*i+1][7] & simd_signed, simd_op_b[2*i +: 2]}) ?
                simd_op_a[2*i +: 2] : simd_op_b[2*i +: 2];
          SimdMax:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] =
                $signed({simd_op_a[2*i+1][7] & simd_signed, simd_op_a[2*i +: 2]}) >
                $signed({simd_op_b[2*i+1][7] & simd_signed, simd_op_b[2*i +: 2]}) ?
                simd_op_a[2*i +: 2] : simd_op_b[2*i +: 2];
          SimdSrl:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $unsigned(simd_op_a[2*i +: 2]) >> simd_op_b[2*i][3:0];
          SimdSra:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) >>> simd_op_b[2*i][3:0];
          SimdSll:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $unsigned(simd_op_a[2*i +: 2]) << simd_op_b[2*i][3:0];
          SimdOr: simd_result = simd_op_a | simd_op_b;
          SimdXor: simd_result = simd_op_a ^ simd_op_b;
          SimdAnd: simd_result = simd_op_a & simd_op_b;
          SimdAbs:
            for (int i = 0; i < Width/16; i++)
              simd_result[2*i +: 2] = $signed(simd_op_a[2*i +: 2]) > 0 ?
                simd_op_a[2*i +: 2] : -$signed(simd_op_a[2*i +: 2]);
          SimdExt: begin
            simd_result[1:0] = simd_op_a[2*simd_gated.imm6[0] +: 2];
            // sign- or zero-extend
            simd_result[3:2] = {16{simd_op_a[2*simd_gated.imm6[0]+1][7] & simd_signed}};
          end
          SimdIns: begin
            simd_result = simd_gated.op_c;
            simd_result[2*simd_gated.imm6[0] +: 2] = simd_op_a[1:0];
          end
          SimdDotp: begin
            // accumulate on rd or start from zero
            simd_result = op_c_i & {(Width){simd_dotp_acc}};
            for (int i = 0; i < Width/16; i++) begin
              simd_result = $signed(simd_result) +
                $signed({simd_op_a[2*i+1][7] & simd_dotp_op_a_signed, simd_op_a[2*i +: 2]}) *
                $signed({simd_op_b[2*i+1][7] & simd_dotp_op_b_signed, simd_op_b[2*i +: 2]});
            end
          end
          SimdShuffle:
            for (int i = 0; i < Width/16; i++) begin
              simd_result[2*i +: 2] = simd_op_b[2*i][1] ?
                simd_op_a[2*simd_op_b[2*i][0] +: 2] : simd_op_c[2*simd_op_b[2*i][0] +: 2];
            end
          SimdPack: begin
            simd_result[3:2] = (simd_mode == High) ? simd_op_a[3:2] : simd_op_a[1:0];
            simd_result[1:0] = (simd_mode == High) ? simd_op_b[3:2] : simd_op_b[1:0];
          end
          default: ;
        endcase
      end
      // byte granularity
      Byte: begin
        unique case (simd_op)
          SimdAdd:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) + $signed(simd_op_b[i]);
          SimdSub:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) - $signed(simd_op_b[i]);
          SimdAvg:
            for (int i = 0; i < Width/8; i++) begin
              simd_result[i] = $signed(simd_op_a[i]) + $signed(simd_op_b[i]);
              simd_result[i] = {simd_result[i][7] & simd_signed, simd_result[i]} >> 1;
            end
          SimdMin:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed({simd_op_a[i][7] & simd_signed, simd_op_a[i]}) <=
                               $signed({simd_op_b[i][7] & simd_signed, simd_op_b[i]}) ?
                               simd_op_a[i] : simd_op_b[i];
          SimdMax:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed({simd_op_a[i][7] & simd_signed, simd_op_a[i]}) >
                               $signed({simd_op_b[i][7] & simd_signed, simd_op_b[i]}) ?
                               simd_op_a[i] : simd_op_b[i];
          SimdSrl:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $unsigned(simd_op_a[i]) >> simd_op_b[i][2:0];
          SimdSra:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) >>> simd_op_b[i][2:0];
          SimdSll:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $unsigned(simd_op_a[i]) << simd_op_b[i][2:0];
          SimdOr: simd_result = simd_op_a | simd_op_b;
          SimdXor: simd_result = simd_op_a ^ simd_op_b;
          SimdAnd: simd_result = simd_op_a & simd_op_b;
          SimdAbs:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = $signed(simd_op_a[i]) > 0 ? simd_op_a[i] : -$signed(simd_op_a[i]);
          SimdExt: begin
            simd_result[0] = simd_op_a[simd_gated.imm6[1:0]];
            // sign- or zero-extend
            simd_result[3:1] = {24{simd_op_a[simd_gated.imm6[1:0]][7] & simd_signed}};
          end
          SimdIns: begin
            simd_result = simd_gated.op_c;
            simd_result[simd_gated.imm6[1:0]] = simd_op_a[0];
          end
          SimdDotp: begin
            simd_result = simd_gated.op_c & {(Width){simd_dotp_acc}}; // accumulate on rd or start from zero
            for (int i = 0; i < Width/8; i++)
              simd_result = $signed(simd_result) +
                $signed({simd_op_a[i][7] & simd_dotp_op_a_signed, simd_op_a[i]}) *
                $signed({simd_op_b[i][7] & simd_dotp_op_b_signed, simd_op_b[i]});
          end
          SimdShuffle:
            for (int i = 0; i < Width/8; i++)
              simd_result[i] = simd_op_b[i][2] ? simd_op_a[simd_op_b[i][1:0]] : simd_op_c[simd_op_b[i][1:0]];
          default: ;
        endcase
      end
      default: ;
    endcase
  end

  // --------------------
  // Result generation
  // --------------------

  always_comb begin
    unique case (res_sel)
      Abs: result_o = cmp_result ? -$signed(op_a_i) : op_a_i;
      Sle: result_o = $unsigned(cmp_result);
      Min: result_o = cmp_result ? op_a_i : op_b_i;
      Max: result_o = ~cmp_result ? op_a_i : op_b_i;
      Exths: result_o = $signed(op_a_i[15:0]);
      Exthz: result_o = $unsigned(op_a_i[15:0]);
      Extbs: result_o = $signed(op_a_i[7:0]);
      Extbz: result_o = $unsigned(op_a_i[7:0]);
      // Select the clip output basing on the result of the comparison and on the signs of the
      // operands:
      // - if rs1 <= clip_comp (i.e. cmp_result = 1)
      //   * if clip_comp=clip_op_b_n (i.e. rs1<0 or clip_op_b<0): rs1 is below the lower bound
      //     and since this check has priority over the others, result_o is clipped to clip_op_b_n
      //   * if clip_comp=clip_op_b (i.e. rs1>=0 and clip_op_b>=0): since rs1<=clip_op_b, then it
      //     is clip_op_b_n < 0 <= rs1 <= clip_op_b thus rs1 is already within the clip bounds
      // - if rs1 > clip_comp (i.e. cmp_result = 0)
      //   * if rs1 < 0: clip_comp=clip_op_b_n because clip_use_n_bound=1; since rs1>clip_op_b_n
      //     and rs1<0 it is clip_op_b_n < rs1 < 0 <= clip_op_b, thus rs1 is already within the
      //     clip bounds
      //   * if rs1 >= 0: then clip_comp might be clip_op_b_n or clip_op_b basing on clip_op_b
      //     sign;
      //     + if clip_op_b < 0: clip_comp=clip_op_b_n, so rs1>clip_op_b_n but also rs1 >= 0, so
      //       it is clip_op_b < 0 <= clip_op_n <= rs1; then rs1 is not <= clip_ob_n but it is
      //       >= clip_op_b, so result_o is clipped to clip_op_b
      //     + if clip_op_b >= 0: clip_comp=clip_op_b (i.e. rs1>=0 and clip_op_b>=0) and the
      //       result must be clipped to the upper bound since rs1 > clip_op_b
      Clip: result_o = cmp_result ? (clip_use_n_bound ? clip_op_b_n : op_a_i) :
        (op_a_i[Width-1] ? op_a_i : clip_op_b);
      Mac: result_o = mac_result;
      Simd: result_o = simd_result;
      default: result_o = '0;
    endcase
  end

endmodule
