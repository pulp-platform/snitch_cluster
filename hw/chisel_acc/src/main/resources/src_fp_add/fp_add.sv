// Copyright 2019 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
// Author: Stefan Mach <smach@iis.ee.ethz.ch>

// Copyright 2025 KU Leuven
// Modified by: Man Shi <man.shi@kuleuven.be>
//              Robin Geens <robin.geens@kuleuven.be>
// Changes: allow for different a, b, and out data types; remove multiplier.

module fp_add #(
    parameter fpnew_pkg::fp_format_e FpFormat_a   = fpnew_pkg::fp_format_e'(0),
    parameter fpnew_pkg::fp_format_e FpFormat_b   = fpnew_pkg::fp_format_e'(0),
    parameter fpnew_pkg::fp_format_e FpFormat_out = fpnew_pkg::fp_format_e'(0),

    parameter int unsigned WIDTH_A   = fpnew_pkg::fp_width(FpFormat_a),
    parameter int unsigned WIDTH_B   = fpnew_pkg::fp_width(FpFormat_b),
    parameter int unsigned WIDTH_out = fpnew_pkg::fp_width(FpFormat_out)
) (
    input  logic [  WIDTH_A-1:0] operand_a_i,
    input  logic [  WIDTH_B-1:0] operand_b_i,
    output logic [WIDTH_out-1:0] result_o
);

  // ----------
  // Constants
  // ----------
  // for operand A
  localparam int unsigned EXP_BITS_A = fpnew_pkg::exp_bits(FpFormat_a);
  localparam int unsigned MAN_BITS_A = fpnew_pkg::man_bits(FpFormat_a);
  localparam int unsigned BIAS_A = fpnew_pkg::bias(FpFormat_a);
  // for operand B
  localparam int unsigned EXP_BITS_B = fpnew_pkg::exp_bits(FpFormat_b);
  localparam int unsigned MAN_BITS_B = fpnew_pkg::man_bits(FpFormat_b);
  localparam int unsigned BIAS_B = fpnew_pkg::bias(FpFormat_b);
  // for operand C and result
  localparam int unsigned EXP_BITS_C = fpnew_pkg::exp_bits(FpFormat_out);
  localparam int unsigned MAN_BITS_C = fpnew_pkg::man_bits(FpFormat_out);
  localparam int unsigned BIAS_C = fpnew_pkg::bias(FpFormat_out);

  localparam int unsigned PRECISION_BITS_A = MAN_BITS_A + 1;
  localparam int unsigned PRECISION_BITS_B = MAN_BITS_B + 1;
  localparam int unsigned PRECISION_BITS_C = MAN_BITS_C + 1;

  localparam int unsigned LOWER_SUM_WIDTH = (PRECISION_BITS_A + PRECISION_BITS_B > PRECISION_BITS_C) 
                                                ? (PRECISION_BITS_A + PRECISION_BITS_B) 
                                                : (PRECISION_BITS_C );

  localparam int unsigned SHIFT_AMOUNT_WIDTH = $clog2(LOWER_SUM_WIDTH + PRECISION_BITS_C);


  // ----------------
  // Type definition
  // ----------------
  typedef struct packed {
    logic                  sign;
    logic [EXP_BITS_A-1:0] exponent;
    logic [MAN_BITS_A-1:0] mantissa;
  } fp_a_t;

  typedef struct packed {
    logic                  sign;
    logic [EXP_BITS_B-1:0] exponent;
    logic [MAN_BITS_B-1:0] mantissa;
  } fp_b_t;

  typedef struct packed {
    logic                  sign;
    logic [EXP_BITS_C-1:0] exponent;
    logic [MAN_BITS_C-1:0] mantissa;
  } fp_t_out;


  // -----------------
  // Input processing
  // -----------------
  fpnew_pkg::fp_info_t [1:0] info_q;
  fp_a_t                     operand_a;
  fp_b_t                     operand_b;
  fpnew_pkg::fp_info_t info_a, info_b;


  // Classify input
  fpnew_classifier #(
      .FpFormat   (FpFormat_a),
      .NumOperands(1)
  ) i_class_inputs_a (
      .operands_i(operand_a_i),
      .is_boxed_i(1'b1),
      .info_o    (info_q[0])
  );

  fpnew_classifier #(
      .FpFormat   (FpFormat_b),
      .NumOperands(1)
  ) i_class_inputs_b (
      .operands_i(operand_b_i),
      .is_boxed_i(1'b1),
      .info_o    (info_q[1])
  );

  // Default assignments - packing-order-agnostic
  assign operand_a = operand_a_i;
  assign operand_b = operand_b_i;
  assign info_a    = info_q[0];
  assign info_b    = info_q[1];


  // Input classification
  // ---------------------
  logic any_operand_inf;
  logic any_operand_nan;
  logic signalling_nan;
  logic effective_subtraction;
  logic tentative_sign;

  // Reduction for special case handling
  assign any_operand_inf       = (|{info_a.is_inf, info_b.is_inf});
  assign any_operand_nan       = (|{info_a.is_nan, info_b.is_nan});
  assign signalling_nan        = (|{info_a.is_signalling, info_b.is_signalling});
  // Effective subtraction in FMA occurs when product and addend signs differ

  assign effective_subtraction = operand_a.sign ^ operand_b.sign;
  assign tentative_sign        = operand_a.sign;

  // ----------------------
  // Special case handling
  // ----------------------
  fp_t_out special_result;
  logic    result_is_special;

  always_comb begin : special_cases
    // Default assignments
    special_result = '{
        sign: 1'b0,
        exponent: '1,
        mantissa: 2 ** (MAN_BITS_C - 1)
    };  // canonical qNaN
    result_is_special = 1'b0;
    if (info_a.is_nan || info_b.is_nan) result_is_special = 1'b1;
    else if (info_a.is_zero || info_b.is_zero) begin
      result_is_special = 1'b1;
      if (info_a.is_zero && !info_b.is_zero) special_result = operand_b;
      else if (!info_a.is_zero && info_b.is_zero) special_result = operand_a;
      else if (info_a.is_zero && info_b.is_zero)  //missing code from fp16 to fp32 for special case
        special_result = 0;
    end else if (info_a.is_inf && info_b.is_inf && effective_subtraction) begin
      result_is_special = 1'b1;
    end else if (info_a.is_inf) begin
      result_is_special = 1'b1;
      special_result = '{
          sign: operand_a.sign,
          exponent: operand_a.exponent,
          mantissa: operand_a.mantissa
      };
    end else if (info_b.is_inf) begin
      result_is_special = 1'b1;
      special_result = '{
          sign: operand_b.sign,
          exponent: operand_b.exponent,
          mantissa: operand_b.mantissa
      };
    end
  end


  // ---------------------------
  // Initial exponent data path
  // ---------------------------
  logic signed [EXP_BITS_A:0] exponent_a;
  logic signed [EXP_BITS_B:0] exponent_b;
  logic signed [EXP_BITS_C:0] exponent_difference;
  logic signed [EXP_BITS_C:0] tentative_exponent;

  assign exponent_a = signed'({1'b0, operand_a.exponent});
  assign exponent_b = signed'({1'b0, operand_b.exponent});
  // exponent a - b；
  assign exponent_difference = (exponent_a -BIAS_A + BIAS_C + info_a.is_subnormal) - (exponent_b -BIAS_B + BIAS_C + info_b.is_subnormal);
  assign tentative_exponent = (exponent_difference >= 0 && info_a.is_normal) ? (exponent_a -BIAS_A + BIAS_C) :  (exponent_b - BIAS_B + BIAS_C );

  logic [SHIFT_AMOUNT_WIDTH-1:0] shamt_a, shamt_b;

  always_comb begin
    if (exponent_difference <= signed'(-PRECISION_BITS_C - 1)) begin  //b >> a, shift a to align b
      shamt_a = PRECISION_BITS_C + 1;
      shamt_b = 0;
    end else if (exponent_difference < 0) begin  //b > a, shift a to align b 
      shamt_a = unsigned'(-exponent_difference);
      shamt_b = 0;
    end else if (exponent_difference < PRECISION_BITS_C + 1) begin  //b<a, , shift b to align a
      shamt_a = 0;
      shamt_b = unsigned'(exponent_difference);
    end else begin  //b<<a, , shift b to align a
      shamt_a = 0;
      shamt_b = PRECISION_BITS_C + 1;
    end
  end

  // ------------------
  // mantissa data path
  // ------------------
  logic [PRECISION_BITS_A-1:0] mantissa_a;
  logic [PRECISION_BITS_B-1:0] mantissa_b;

  assign mantissa_a = {info_a.is_normal, operand_a.mantissa};
  assign mantissa_b = {info_b.is_normal, operand_b.mantissa};

  // -----------------
  // Add data path
  // -----------------
  // do the maximal shift
  logic [2*PRECISION_BITS_C+1:0] addend_a, addend_b;
  logic [2*PRECISION_BITS_C+1:0] shifted_b;
  logic [2*PRECISION_BITS_C+1:0] sum_raw;
  logic [2*PRECISION_BITS_C+1:0] sum;
  logic inject_carry_in;
  logic result_negative;
  logic operand_a_larger;
  logic final_sign;

  assign addend_a = (mantissa_a << (2 * PRECISION_BITS_C - (PRECISION_BITS_A - 1))) >> (shamt_a);
  assign addend_b = (mantissa_b << (2 * PRECISION_BITS_C - (PRECISION_BITS_B - 1))) >> (shamt_b);

  assign shifted_b = (effective_subtraction) ? ~addend_b : addend_b;
  assign inject_carry_in = effective_subtraction;

  assign sum_raw = addend_a + shifted_b + inject_carry_in;
  assign result_negative = (effective_subtraction && sum_raw[2*PRECISION_BITS_C+1]);
  assign sum = result_negative ? (~(sum_raw - 1)) : sum_raw;

  // The mantissa's can have different widths. Extend with 0 at LSB side for comparison
  localparam int unsigned PRECISION_BITS_IN = unsigned'(fpnew_pkg::maximum(
      PRECISION_BITS_A, PRECISION_BITS_B
  ));
  logic [PRECISION_BITS_IN-1:0] mantissa_a_ext, mantissa_b_ext;

  assign mantissa_a_ext = mantissa_a << (PRECISION_BITS_IN - PRECISION_BITS_A);
  assign mantissa_b_ext = mantissa_b << (PRECISION_BITS_IN - PRECISION_BITS_B);

  assign operand_a_larger = (exponent_difference > 0) ? 1'b1 :
                          (exponent_difference < 0) ? 1'b0 :
                          (mantissa_a_ext > mantissa_b_ext);

  assign final_sign = (effective_subtraction) ?
                    (operand_a_larger ? operand_a.sign : operand_b.sign) :
                    tentative_sign;

  // --------------
  // Normalization
  // --------------
  localparam int unsigned LZC_WIDTH = $clog2(2 * PRECISION_BITS_C + 2);
  logic [LZC_WIDTH-1:0] leading_zero_count;
  logic lzc_zeroes;

  lzc #(
      .WIDTH(2 * PRECISION_BITS_C + 2),
      .MODE (1)
  ) u_lzc (
      .in_i(sum),
      .cnt_o(leading_zero_count),
      .empty_o(lzc_zeroes)
  );

  logic signed [ LZC_WIDTH:0] leading_zero_count_sgn;
  logic signed [EXP_BITS_C:0] final_exponent;
  ;
  logic [LZC_WIDTH-1:0] norm_shamt;

  assign leading_zero_count_sgn = signed'({1'b0, leading_zero_count});

  always_comb begin
    if (tentative_exponent - leading_zero_count_sgn + 1 > 0 && !lzc_zeroes) begin
      final_exponent = tentative_exponent - leading_zero_count_sgn + 1;
      norm_shamt = leading_zero_count;
    end else if (tentative_exponent == 0) begin
      final_exponent = 0;
      norm_shamt = 1;
    end else begin
      final_exponent = 0;
      norm_shamt = unsigned'(tentative_exponent);
    end
  end

  logic [PRECISION_BITS_C:0] final_mantissa;
  logic [PRECISION_BITS_C:0] sticky_bits;
  logic sticky_after_norm;

  assign {final_mantissa, sticky_bits} = sum << norm_shamt;
  assign sticky_after_norm = |sticky_bits;

  // ----------------------------
  // Rounding and classification
  // ----------------------------
  logic pre_round_sign;
  logic [EXP_BITS_C-1:0] pre_round_exponent;
  logic [MAN_BITS_C-1:0] pre_round_mantissa;
  logic [EXP_BITS_C+MAN_BITS_C-1:0] pre_round_abs;

  logic of_before_round;  // overflow
  logic uf_before_round;  // underflow

  assign of_before_round = (final_exponent >= (2 ** EXP_BITS_C - 1));
  assign uf_before_round = (final_exponent == 0);

  assign pre_round_sign = final_sign;
  assign pre_round_exponent = (of_before_round) ? 2**EXP_BITS_C-2 : unsigned'(final_exponent[EXP_BITS_C-1:0]);
  assign pre_round_mantissa = (of_before_round) ? '1 : final_mantissa[MAN_BITS_C:1];
  assign pre_round_abs = {pre_round_exponent, pre_round_mantissa};

  logic rounded_sign;
  logic [EXP_BITS_C+MAN_BITS_C-1:0] rounded_abs;
  logic result_zero;
  logic [1:0] round_sticky_bits;

  assign round_sticky_bits = (of_before_round) ? 2'b11 : {final_mantissa[0], sticky_after_norm};

  // Perform the rounding
  fpnew_rounding #(
      .AbsWidth(EXP_BITS_C + MAN_BITS_C)
  ) u_fpnew_rounding (
      .abs_value_i(pre_round_abs),
      .sign_i(pre_round_sign),
      .round_sticky_bits_i(round_sticky_bits),
      .rnd_mode_i(fpnew_pkg::RNE),
      .effective_subtraction_i(1'b0),
      .abs_rounded_o(rounded_abs),
      .sign_o(rounded_sign),
      .exact_zero_o(result_zero)
  );

  // -----------------
  // Result selection
  // -----------------
  logic [WIDTH_out-1:0] regular_result;

  assign regular_result = {rounded_sign, rounded_abs};
  assign result_o = result_is_special ? special_result : regular_result;
endmodule
