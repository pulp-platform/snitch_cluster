// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

inline void dotp_seq (uint32_t N, double *input_A, double *input_B, double *output) {
    // Start of SSR region.
    register volatile double ft0 asm("ft0");
    register volatile double ft1 asm("ft1");
    asm volatile(""
                 : "=f"(ft0), "=f"(ft1));

    snrt_ssr_loop_1d(SNRT_SSR_DM0, N, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, N, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, input_A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, input_B);

    register volatile double res_ssr asm("fs0") = 0;

    snrt_ssr_enable();

    const register uint32_t Nm1 asm("t0") = N - 1;
    asm volatile(
        "frep.o %[n_frep], 1, 0, 0 \n"
        "fmadd.d %0, ft0, ft1, %0"
        : "=f"(res_ssr)                                      /* output operands */
        : "f"(ft0), "f"(ft1), "0"(res_ssr), [n_frep]"r"(Nm1) /* input operands */
        :);

    // End of SSR region.
    snrt_fpu_fence();
    snrt_ssr_disable();
    asm volatile(""
                 :
                 : "f"(ft0), "f"(ft1));
    output[0] = res_ssr;
}

inline void dotp_seq_4_acc (uint32_t N, double *input_A, double *input_B, double *output) {
    // Start of SSR region.
    register volatile double ft0 asm("ft0");
    register volatile double ft1 asm("ft1");
    asm volatile(""
                 : "=f"(ft0), "=f"(ft1));

    snrt_ssr_loop_1d(SNRT_SSR_DM0, N, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, N, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, input_A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, input_B);

    register volatile double res_ssr_0 asm("fs0") = 0;
    register volatile double res_ssr_1 asm("fs1") = 0;
    register volatile double res_ssr_2 asm("fs2") = 0;
    register volatile double res_ssr_3 asm("fs3") = 0;

    snrt_ssr_enable();

    const register uint32_t Nm1 asm("t0") = (N >> 2) - 1;
    asm volatile(
        "frep.o %[n_frep], 4, 0, 0 \n"
        "fmadd.d %0, ft0, ft1, %0 \n"
        "fmadd.d %1, ft0, ft1, %1 \n"
        "fmadd.d %2, ft0, ft1, %2 \n"
        "fmadd.d %3, ft0, ft1, %3"
        : "=f"(res_ssr_0), "=f"(res_ssr_1), "=f"(res_ssr_2), "=f"(res_ssr_3) /* output operands */
        : "f"(ft0), "f"(ft1), "0"(res_ssr_0), "1"(res_ssr_1), "2"(res_ssr_2), "3"(res_ssr_3), [n_frep]"r"(Nm1)           /* input operands */
        :);

    // End of SSR region.
    snrt_fpu_fence();
    snrt_ssr_disable();

    asm volatile(
        "fadd.d %[res_ssr_0], %[res_ssr_0], %[res_ssr_1] \n"
        "fadd.d %[res_ssr_2], %[res_ssr_2], %[res_ssr_3] \n"
        "fadd.d %[res_ssr_0], %[res_ssr_0], %[res_ssr_2]"
        : [res_ssr_0]"=f"(res_ssr_0), [res_ssr_2]"=f"(res_ssr_2) /* output operands */
        : [res_ssr_1]"f"(res_ssr_1), [res_ssr_3]"f"(res_ssr_3)           /* input operands */
        :);

    asm volatile(""
                 :
                 : "f"(ft0), "f"(ft1));
    output[0] = res_ssr_0;
}
