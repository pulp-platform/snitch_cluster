// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#define FCMP_FUNCT5 0b10100
#define FCVT_D_INT_FUNCT5 0b11010

#define OP_FP_FMT_D 0b01

#define FLT_FUNCT3 0b001

#define FCVT_D_WU_RS2 0b00001

#define FLT_D_SSR(rd, rs1, rs2)                                               \
    R_TYPE_ENCODE((FCMP_FUNCT5 << 2 | OP_FP_FMT_D), rs2, rs1, FLT_FUNCT3, rd, \
                  OP_CUSTOM1)

#define FCVT_D_WU_SSR(rd, rs1)                                                \
    R_TYPE_ENCODE((FCVT_D_INT_FUNCT5 << 2 | OP_FP_FMT_D), FCVT_D_WU_RS2, rs1, \
                  0b000, rd, OP_CUSTOM1)

/**
 * @brief FLT comparison with writeback to SSR 2.
 * @param lval The left-hand-side value in the comparison.
 * @param rval The right-hand-side value in the comparison.
 */
inline void snrt_ssr_flt(double lval, double rval) {
    register double reg_lval asm("fa0") = lval;  // 10
    register double reg_rval asm("fa1") = rval;  // 11

    // flt.d.copift ft2, lval, rval
    asm volatile(".word %[insn]\n"
                 :
                 : [ insn ] "i"(FLT_D_SSR(2, 10, 11)), "f"(lval), "f"(rval));
}

/**
 * @brief Convert an unsigned integer from SSR 0 to a double.
 * @return The value converted to double.
 */
inline double snrt_ssr_fcvt() {
    register double reg_result asm("fa0");  // 10

    // fcvt.d.wu fa0, ft0
    asm volatile(".word %[insn]\n"
                 : "=f"(reg_result)
                 : [ insn ] "i"(FCVT_D_WU_SSR(10, 0)));

    return reg_result;
}
