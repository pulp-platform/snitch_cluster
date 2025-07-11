// Copyright 2019 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
// Author: Stefan Mach <smach@iis.ee.ethz.ch>

// Copyright 2025 KU Leuven
// Modified by: Man Shi <man.shi@kuleuven.be>
//              Robin Geens <robin.geens@kuleuven.be>
// Changes: allow for different a, b, and out data types; remove adder.

module fp_mul #(
    parameter fpnew_pkg_snax::fp_format_e FpFormat_a   = fpnew_pkg_snax::fp_format_e'(2),  //FP16 
    parameter fpnew_pkg_snax::fp_format_e FpFormat_b   = fpnew_pkg_snax::fp_format_e'(2),  //FP16 
    parameter fpnew_pkg_snax::fp_format_e FpFormat_out = fpnew_pkg_snax::fp_format_e'(0),  //FP32

    // Do not change
    parameter int unsigned WIDTH_a   = fpnew_pkg_snax::fp_width(FpFormat_a),
    parameter int unsigned WIDTH_b   = fpnew_pkg_snax::fp_width(FpFormat_b),
    parameter int unsigned WIDTH_out = fpnew_pkg_snax::fp_width(FpFormat_out)
) (
    // Input signals
    input  logic [  WIDTH_a-1:0] operand_a_i,  // 3 operands
    input  logic [  WIDTH_b-1:0] operand_b_i,  // 3 operands
    // Output signals
    output logic [WIDTH_out-1:0] result_o

);

  // ----------
  // Constants
  // ----------
  // for operand A
  localparam int unsigned EXP_BITS_A = fpnew_pkg_snax::exp_bits(FpFormat_a);
  localparam int unsigned MAN_BITS_A = fpnew_pkg_snax::man_bits(FpFormat_a);
  localparam int unsigned BIAS_A = fpnew_pkg_snax::bias(FpFormat_a);
  // for operand B
  localparam int unsigned EXP_BITS_B = fpnew_pkg_snax::exp_bits(FpFormat_b);
  localparam int unsigned MAN_BITS_B = fpnew_pkg_snax::man_bits(FpFormat_b);
  localparam int unsigned BIAS_B = fpnew_pkg_snax::bias(FpFormat_b);
  // for operand C and result
  localparam int unsigned EXP_BITS_C = fpnew_pkg_snax::exp_bits(FpFormat_out);
  localparam int unsigned MAN_BITS_C = fpnew_pkg_snax::man_bits(FpFormat_out);
  localparam int unsigned BIAS_C = fpnew_pkg_snax::bias(FpFormat_out);

  localparam int unsigned PRECISION_BITS_A = MAN_BITS_A + 1;
  localparam int unsigned PRECISION_BITS_B = MAN_BITS_B + 1;
  localparam int unsigned PRECISION_BITS_C = MAN_BITS_C + 1;

  localparam int unsigned MUL_WIDTH = PRECISION_BITS_A + PRECISION_BITS_B;  // Same as LOWER_SUM_WIDTH in original
  localparam int unsigned LZC_RESULT_WIDTH = $clog2(MUL_WIDTH);
  localparam int unsigned EXP_WIDTH = unsigned'(fpnew_pkg_snax::maximum(
      EXP_BITS_C + 2, LZC_RESULT_WIDTH
  ));

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
  fpnew_pkg_snax::fp_info_t [1:0] info_q;
  fp_a_t                          operand_a;
  fp_b_t                          operand_b;
  fpnew_pkg_snax::fp_info_t info_a, info_b;


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
  assign any_operand_inf = (|{info_a.is_inf, info_b.is_inf});
  assign any_operand_nan = (|{info_a.is_nan, info_b.is_nan});
  assign signalling_nan  = (|{info_a.is_signalling, info_b.is_signalling});
  // Effective subtraction in FMA occurs when product and addend signs differ
  logic result_sign;

  assign result_sign = operand_a.sign ^ operand_b.sign;
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

    if ((info_a.is_inf && info_b.is_zero) || (info_a.is_zero && info_b.is_inf)) begin
      result_is_special = 1'b1;
      special_result = '{
          sign: operand_a.sign ^ operand_b.sign,
          exponent: '1,
          mantissa: 2 ** (MAN_BITS_C - 1)
      };
    end else if (any_operand_nan) begin
      result_is_special = 1'b1;
    end else if (any_operand_inf) begin
      result_is_special = 1'b1;
      if ((info_a.is_inf || info_b.is_inf) && effective_subtraction)
        special_result = '{sign: 1'b0, exponent: '1, mantissa: 2 ** (MAN_BITS_C - 1)};
      else if (info_a.is_inf || info_b.is_inf) begin
        special_result = '{sign: operand_a.sign ^ operand_b.sign, exponent: '1, mantissa: '0};
      end
    end
  end


  // ---------------------------
  // Initial exponent data path
  // ---------------------------
  logic signed [EXP_BITS_A-1:0] exponent_a;
  logic signed [EXP_BITS_B-1:0] exponent_b;
  logic signed [ EXP_WIDTH-1:0] exponent_product;


  assign exponent_a = signed'({1'b0, operand_a.exponent});
  assign exponent_b = signed'({1'b0, operand_b.exponent});

  assign exponent_product = (info_a.is_zero || info_b.is_zero) ? 2 - signed'(BIAS_C)  // [NOTE]
      : signed'(exponent_a + info_a.is_subnormal - signed'(BIAS_A)
                                        + exponent_b + info_b.is_subnormal - signed'(BIAS_B)
                                        + signed'(BIAS_C));


  // ------------------
  // Product data path
  // ------------------
  logic [PRECISION_BITS_A-1:0] mantissa_a;
  logic [PRECISION_BITS_B-1:0] mantissa_b;
  logic [MUL_WIDTH-1:0] product;

  // Add implicit bits to mantissa
  assign mantissa_a = {info_a.is_normal, operand_a.mantissa};
  assign mantissa_b = {info_b.is_normal, operand_b.mantissa};

  // Mantissa multiplier (a*b)
  assign product = mantissa_a * mantissa_b;

  // --------------
  // Normalization
  // --------------
  localparam int unsigned PRODUCT_SHIFTED_WIDTH = MUL_WIDTH + 1;  // Must have 1 bit more than product
  localparam int STICKY_BIT_WIDTH = PRODUCT_SHIFTED_WIDTH - (PRECISION_BITS_C + 1);
  localparam int unsigned PADDING_WIDTH = (STICKY_BIT_WIDTH <= 0) ? -STICKY_BIT_WIDTH : 0;

  logic        [     LZC_RESULT_WIDTH-1:0] leading_zero_count;  // the number of leading zeroes
  logic signed [       LZC_RESULT_WIDTH:0] leading_zero_count_sgn;  // signed leading-zero count
  logic                                    lzc_zeroes;

  logic signed [            EXP_WIDTH-1:0] normalized_exponent;
  logic signed [            EXP_WIDTH-1:0] final_exponent;
  logic        [PRODUCT_SHIFTED_WIDTH-1:0] product_shifted;
  logic        [       PRECISION_BITS_C:0] final_mantissa;
  /* verilator lint_off ASCRANGE */
  // When STICKY_BIT_WIDTH < 0, the range will be inverted, triggering an error, but the vector will not used
  logic        [     STICKY_BIT_WIDTH-1:0] sum_sticky_bits;
  /* verilator lint_on ASCRANGE */
  logic                                    sticky_after_norm;



  // For normal case, the mantissa's start with 1 (by definition) so the product has either 0 or 1 leading zero's
  // For subnormal case, any number of leading zero's is possible
  lzc_snax #(
      .WIDTH(MUL_WIDTH),
      .MODE (1)           // MODE = 1 counts leading zeroes
  ) i_lzc (
      .in_i   (product),
      .cnt_o  (leading_zero_count),
      .empty_o(lzc_zeroes)
  );
  assign leading_zero_count_sgn = signed'({1'b0, leading_zero_count});

  always_comb begin : norm_shift_amount
    if ((exponent_product - leading_zero_count_sgn + 1 > 0) && !lzc_zeroes) begin
      normalized_exponent = exponent_product - leading_zero_count_sgn + 1;  // Account for LZC shift
      // Account for 1 bit wider result. Cancel out leading zeros. Mantissa's hidden bit will now be at MSB
      product_shifted = product << (leading_zero_count + 1);
    end else begin
      // Subnormal result. Exponent is 0
      normalized_exponent = 0;
      // Align mantissa with minimum exponent. Mantissa MSB must not be discarded later: subnormals have no hidden bit
      product_shifted = product << 1 >> unsigned'(-exponent_product);
    end
  end


  always_comb begin : small_norm
    // If src is wider than dst: save LSBs in sticky bits
    if (STICKY_BIT_WIDTH > 0) {final_mantissa, sum_sticky_bits} = product_shifted;
    // If src is narrower than dst: append 0 at LSBs
    else
      final_mantissa = {product_shifted, {(PADDING_WIDTH) {1'b0}}};

    final_exponent = normalized_exponent;
  end

  // Update the sticky bit with the shifted-out bits
  assign sticky_after_norm = (|sum_sticky_bits);

  // ----------------------------
  // Rounding and classification
  // ----------------------------
  logic                             pre_round_sign;
  logic [           EXP_BITS_C-1:0] pre_round_exponent;
  logic [           MAN_BITS_C-1:0] pre_round_mantissa;
  logic [EXP_BITS_C+MAN_BITS_C-1:0] pre_round_abs;  // absolute value of result before rounding
  logic [                      1:0] round_sticky_bits;

  logic of_before_round, of_after_round;  // overflow
  logic uf_before_round, uf_after_round;  // underflow
  logic                             result_zero;

  logic                             rounded_sign;
  logic [EXP_BITS_C+MAN_BITS_C-1:0] rounded_abs;  // absolute value of result after rounding

  // Classification before round. RISC-V mandates checking underflow AFTER rounding!
  assign of_before_round = final_exponent >= 2 ** (EXP_BITS_C) - 1;  // infinity exponent is all ones
  assign uf_before_round = final_exponent == 0;  // exponent for subnormals capped to 0

  // Assemble result before rounding. In case of overflow, the largest normal value is set.
  assign pre_round_sign = result_sign;
  assign pre_round_exponent = (of_before_round) ? 2 ** EXP_BITS_C - 2 : unsigned'(final_exponent[EXP_BITS_C-1:0]);
  // Discard implicit leading bit. Bit 0 is R bit
  assign pre_round_mantissa = (of_before_round) ? '1 : final_mantissa[MAN_BITS_C:1];
  assign pre_round_abs = {pre_round_exponent, pre_round_mantissa};

  // In case of overflow, the round and sticky bits are set for proper rounding
  assign round_sticky_bits = (of_before_round) ? 2'b11 : {final_mantissa[0], sticky_after_norm};

  // Perform rounding
  fpnew_rounding #(
      .AbsWidth(EXP_BITS_C + MAN_BITS_C)
  ) i_fpnew_rounding (
      .abs_value_i            (pre_round_abs),
      .sign_i                 (pre_round_sign),
      .round_sticky_bits_i    (round_sticky_bits),
      .rnd_mode_i             (fpnew_pkg_snax::RNE),
      .effective_subtraction_i(1'b0),                 // pure mul, no subtraction
      .abs_rounded_o          (rounded_abs),
      .sign_o                 (rounded_sign),
      .exact_zero_o           (result_zero)
  );

  // -----------------
  // Result selection
  // -----------------
  logic [WIDTH_out-1:0] regular_result;

  assign regular_result    = {rounded_sign, rounded_abs};
  assign result_o = result_is_special ? special_result : regular_result;


endmodule
