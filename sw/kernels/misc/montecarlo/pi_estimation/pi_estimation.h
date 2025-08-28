// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

// clang-format off
#define ASM_LCG_OUTPUTS                                           \
    [ int_x0 ] "+r"(lcg_state_x0), [ int_y0 ] "+r"(lcg_state_y0), \
    [ int_x1 ] "+r"(lcg_state_x1), [ int_y1 ] "+r"(lcg_state_y1), \
    [ int_x2 ] "+r"(lcg_state_x2), [ int_y2 ] "+r"(lcg_state_y2), \
    [ int_x3 ] "+r"(lcg_state_x3), [ int_y3 ] "+r"(lcg_state_y3)

#define ASM_LCG_INPUTS [ Ap ] "r"(lcg_Ap), [ Cp ] "r"(lcg_Cp)

#define ASM_XOSHIRO128P_OUTPUTS        \
    [ s_0 ] "+r"(xoshiro128p_state_0), \
    [ s_1 ] "+r"(xoshiro128p_state_1), \
    [ s_2 ] "+r"(xoshiro128p_state_2), \
    [ s_3 ] "+r"(xoshiro128p_state_3)

#define ASM_XOSHIRO128P_INPUTS [ t ] "r"(xoshiro128p_tmp)

#define EVAL_LCG_UNROLL4                 \
    "mul %[int_x0], %[int_x0], %[Ap] \n" \
    "mul %[int_x1], %[int_x1], %[Ap] \n" \
    "mul %[int_x2], %[int_x2], %[Ap] \n" \
    "mul %[int_x3], %[int_x3], %[Ap] \n" \
    "add %[int_x0], %[int_x0], %[Cp] \n" \
    "mul %[int_y0], %[int_y0], %[Ap] \n" \
    "add %[int_x1], %[int_x1], %[Cp] \n" \
    "mul %[int_y1], %[int_y1], %[Ap] \n" \
    "add %[int_x2], %[int_x2], %[Cp] \n" \
    "mul %[int_y2], %[int_y2], %[Ap] \n" \
    "add %[int_x3], %[int_x3], %[Cp] \n" \
    "mul %[int_y3], %[int_y3], %[Ap] \n" \
    "add %[int_y0], %[int_y0], %[Cp] \n" \
    "add %[int_y1], %[int_y1], %[Cp] \n" \
    "add %[int_y2], %[int_y2], %[Cp] \n" \
    "add %[int_y3], %[int_y3], %[Cp] \n"

#define EVAL_XOSHIRO128P_UNROLL4       \
    "add t0, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n" \
    "add t1, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n" \
    "add t2, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n" \
    "add t3, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n" \
    "add a0, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n" \
    "add a1, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n" \
    "add a2, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n" \
    "add a3, %[s_0], %[s_3] \n"        \
    "sll %[t], %[s_1], 9           \n" \
    "xor %[s_2], %[s_2], %[s_0]    \n" \
    "xor %[s_3], %[s_3], %[s_1]    \n" \
    "xor %[s_1],%[s_1], %[s_2]     \n" \
    "xor %[s_0],%[s_0], %[s_3]     \n" \
    "xor %[s_2], %[s_2], %[t]      \n" \
    "sll %[t], %[s_3], 11          \n" \
    "srl %[s_3], %[s_3], 21        \n" \
    "or %[s_3], %[s_3], %[t]       \n"

#define FCVT_UNROLL_8(in0, in1, in2, in3, in4, in5, in6, in7,         \
                      out0, out1, out2, out3, out4, out5, out6, out7) \
    "fcvt.d.wu " #out0 ", " #in0 " \n"                                \
    "fcvt.d.wu " #out1 ", " #in1 " \n"                                \
    "fcvt.d.wu " #out2 ", " #in2 " \n"                                \
    "fcvt.d.wu " #out3 ", " #in3 " \n"                                \
    "fcvt.d.wu " #out4 ", " #in4 " \n"                                \
    "fcvt.d.wu " #out5 ", " #in5 " \n"                                \
    "fcvt.d.wu " #out6 ", " #in6 " \n"                                \
    "fcvt.d.wu " #out7 ", " #in7 " \n"

#define SW_UNROLL_8(word0, word1, word2, word3, word4, word5, word6, word7, \
                    offs0, offs1, offs2, offs3, offs4, offs5, offs6, offs7, \
                    addr0, addr1, addr2, addr3, addr4, addr5, addr6, addr7) \
    "sw " #word0 ", " #offs0 "(" #addr0 ") \n"                              \
    "sw " #word1 ", " #offs1 "(" #addr1 ") \n"                              \
    "sw " #word2 ", " #offs2 "(" #addr2 ") \n"                              \
    "sw " #word3 ", " #offs3 "(" #addr3 ") \n"                              \
    "sw " #word4 ", " #offs4 "(" #addr4 ") \n"                              \
    "sw " #word5 ", " #offs5 "(" #addr5 ") \n"                              \
    "sw " #word6 ", " #offs6 "(" #addr6 ") \n"                              \
    "sw " #word7 ", " #offs7 "(" #addr7 ") \n"


#define ASM_PI_CONSTANTS(k_one) \
    [ one ] "f"(k_one)
#define ASM_POLY_CONSTANTS(k_two, k_three) \
    [ two ] "f"(k_two), [ three ] "f"(k_three)

#define ASM_POLY_CLOBBERS "ft4", "ft5", "ft6", "ft7"

#define EVAL_X2_PLUS_Y2_UNROLL2(x0, x1, y0, y1, out0, out1) \
    /* x^2 */                                               \
    "fmul.d " #x0 ", " #x0 ", " #x0 " \n"                   \
    "fmul.d " #x1 ", " #x1 ", " #x1 " \n"                   \
    /* x^2 + y^2 */                                         \
    "fmadd.d " #out0 ", " #y0 ", " #y0 ", " #x0 " \n"       \
    "fmadd.d " #out1 ", " #y1 ", " #y1 ", " #x1 " \n"

#define EVAL_X2_PLUS_Y2_UNROLL4(x0, x1, x2, x3, y0, y1, y2, y3, out0, out1, \
                                out2, out3)                                 \
    /* x^2 */                                                               \
    "fmul.d " #x0 ", " #x0 ", " #x0 " \n"                                   \
    "fmul.d " #x1 ", " #x1 ", " #x1 " \n"                                   \
    "fmul.d " #x2 ", " #x2 ", " #x2 " \n"                                   \
    "fmul.d " #x3 ", " #x3 ", " #x3 " \n"                                   \
    /* x^2 + y^2 */                                                         \
    "fmadd.d " #out0 ", " #y0 ", " #y0 ", " #x0 " \n"                       \
    "fmadd.d " #out1 ", " #y1 ", " #y1 ", " #x1 " \n"                       \
    "fmadd.d " #out2 ", " #y2 ", " #y2 ", " #x2 " \n"                       \
    "fmadd.d " #out3 ", " #y3 ", " #y3 ", " #x3 " \n"

#define EVAL_POLY_UNROLL2(x0, x1, y0, y1, tmp0, tmp1, out0, out1) \
    /* scale y to [0,3] */                                        \
    "fmul.d " #y0 ", " #y0 ", %[three] \n"                        \
    "fmul.d " #y1 ", " #y1 ", %[three] \n"                        \
    /* x^2 */                                                     \
    "fmul.d " #tmp0 ", " #x0 ", " #x0 " \n"                       \
    "fmul.d " #tmp1 ", " #x1 ", " #x1 " \n"                       \
    /* x^3 + x^2 */                                               \
    "fmadd.d " #tmp0 ", " #tmp0 ", " #x0 ", " #tmp0 " \n"         \
    "fmadd.d " #tmp1 ", " #tmp1 ", " #x1 ", " #tmp1 " \n"         \
    /* x^3 + x^2 - x */                                           \
    "fsub.d " #out0 ", " #tmp0 ", " #x0 " \n"                     \
    "fsub.d " #out1 ", " #tmp1 ", " #x1 " \n"                     \
    /* x^3 + x^2 - x + 2 */                                       \
    "fadd.d " #out0 ", " #out0 ", %[two] \n"                      \
    "fadd.d " #out1 ", " #out1 ", %[two] \n"                      \

#define EVAL_POLY_UNROLL4(x0, x1, x2, x3, y0, y1, y2, y3, tmp0, tmp1, tmp2, \
                          tmp3, out0, out1, out2, out3)                     \
    /* scale y to [0,3] */                                                  \
    "fmul.d " #y0 ", " #y0 ", %[three] \n"                                  \
    "fmul.d " #y1 ", " #y1 ", %[three] \n"                                  \
    "fmul.d " #y2 ", " #y2 ", %[three] \n"                                  \
    "fmul.d " #y3 ", " #y3 ", %[three] \n"                                  \
    /* x^2 */                                                               \
    "fmul.d " #tmp0 ", " #x0 ", " #x0 " \n"                                 \
    "fmul.d " #tmp1 ", " #x1 ", " #x1 " \n"                                 \
    "fmul.d " #tmp2 ", " #x2 ", " #x2 " \n"                                 \
    "fmul.d " #tmp3 ", " #x3 ", " #x3 " \n"                                 \
    /* x^3 + x^2 */                                                         \
    "fmadd.d " #tmp0 ", " #tmp0 ", " #x0 ", " #tmp0 " \n"                   \
    "fmadd.d " #tmp1 ", " #tmp1 ", " #x1 ", " #tmp1 " \n"                   \
    "fmadd.d " #tmp2 ", " #tmp2 ", " #x2 ", " #tmp2 " \n"                   \
    "fmadd.d " #tmp3 ", " #tmp3 ", " #x3 ", " #tmp3 " \n"                   \
    /* x^3 + x^2 - x */                                                     \
    "fsub.d " #out0 ", " #tmp0 ", " #x0 " \n"                               \
    "fsub.d " #out1 ", " #tmp1 ", " #x1 " \n"                               \
    "fsub.d " #out2 ", " #tmp2 ", " #x2 " \n"                               \
    "fsub.d " #out3 ", " #tmp3 ", " #x3 " \n"                               \
    /* x^3 + x^2 - x + 2 */                                                 \
    "fadd.d " #out0 ", " #out0 ", %[two] \n"                                \
    "fadd.d " #out1 ", " #out1 ", %[two] \n"                                \
    "fadd.d " #out2 ", " #out2 ", %[two] \n"                                \
    "fadd.d " #out3 ", " #out3 ", %[two] \n"

#define FLT_UNROLL_4(lhs0, lhs1, lhs2, lhs3, rhs0, rhs1, rhs2, rhs3, out0, \
                     out1, out2, out3)                                     \
    "flt.d " #out0 ", " #lhs0 ", " #rhs0 " \n"                             \
    "flt.d " #out1 ", " #lhs1 ", " #rhs1 " \n"                             \
    "flt.d " #out2 ", " #lhs2 ", " #rhs2 " \n"                             \
    "flt.d " #out3 ", " #lhs3 ", " #rhs3 " \n"

#define FLT_SSR_UNROLL_2(lhs0, lhs1, rhs0, rhs1, out0, out1) \
    "flt.d.copift " #out0 ", " #lhs0 ", " #rhs0 " \n"        \
    "flt.d.copift " #out1 ", " #lhs1 ", " #rhs1 " \n"

#define FLT_SSR_UNROLL_4(lhs0, lhs1, lhs2, lhs3, rhs0, rhs1, rhs2, rhs3, \
                         out0, out1, out2, out3)                         \
    "flt.d.copift " #out0 ", " #lhs0 ", " #rhs0 " \n"                    \
    "flt.d.copift " #out1 ", " #lhs1 ", " #rhs1 " \n"                    \
    "flt.d.copift " #out2 ", " #lhs2 ", " #rhs2 " \n"                    \
    "flt.d.copift " #out3 ", " #lhs3 ", " #rhs3 " \n"
// clang-format on
