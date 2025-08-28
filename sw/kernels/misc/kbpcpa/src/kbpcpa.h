// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Jayanth Jonnalagadda <jjonnalagadd@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

// #define C_BASE
// #define ASM_BASE
// #define SSR_BASE
// #define SSR_UNROLL
#define SCSSR

// The Kernel
inline void kbpcpa(uint32_t l, double k, double* a, double* b, double* c) {
#ifdef C_BASE
    snrt_mcycle();
    for (int i = 0; i < l; i++) {
        a[i] = (k * (b[i] + c[i]));
    }
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(ASM_BASE)
    snrt_mcycle();
    for (int i = 0; i < l; i++) {
        asm volatile(
            "fld ft1, 0(%[b]) \n"       // ft1 <-- b
            "fld ft2, 0(%[c]) \n"       // ft2 <-- c
            "fadd.d ft3, ft1, ft2 \n"   // ft3 <-- d = b + c
            "fmul.d ft0, %[k], ft3 \n"  // ft0 <-- a = k * (b + c)
            "fsd ft0, 0(%[a]) \n"       // ft0 --> a
            "add %[b], %[b], 8 \n"
            "add %[c], %[c], 8 \n"
            "add %[a], %[a], 8 \n"
            : [ a ] "+r"(a)
            : [ b ] "r"(b), [ c ] "r"(c), [ k ] "f"(k)
            : "ft0", "ft1", "ft2", "ft3");
    }
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SSR_BASE)
    snrt_mcycle();
    snrt_ssr_loop_1d(SNRT_SSR_DM0, l, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, l, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM2, l, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, b);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, c);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, a);

    snrt_ssr_enable();

    asm volatile(
        "frep.o %[n_frep], 2, 0, 0 \n"
        "fadd.d ft3, ft0, ft1 \n"   // ft3 <-- d = b + c
        "fmul.d ft2, %[k], ft3 \n"  //  ft0 <-- a = k * (b + c)
        :
        : [ n_frep ] "r"(l - 1), [ k ] "f"(k)
        : "ft0", "ft1", "ft2", "ft3", "memory");
    snrt_fpu_fence();
    snrt_ssr_disable();
    snrt_mcycle();

#elif defined(SSR_UNROLL)
    snrt_mcycle();
    snrt_ssr_loop_1d(SNRT_SSR_DM0, l, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, l, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM2, l, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, b);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, c);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, a);

    snrt_ssr_enable();

    asm volatile(
        "frep.o %[n_frep], 8, 0, 0 \n"
        "fadd.d ft3, ft0, ft1 \n"   // ft3 <-- d = b + c
        "fadd.d ft4, ft0, ft1 \n"   // ft4 <-- d = b + c
        "fadd.d ft5, ft0, ft1 \n"   // ft5 <-- d = b + c
        "fadd.d ft6, ft0, ft1 \n"   // ft6 <-- d = b + c
        "fmul.d ft2, %[k], ft3 \n"  //  ft0 <-- a = k * (b + c)
        "fmul.d ft2, %[k], ft4 \n"  //  ft0 <-- a = k * (b + c)
        "fmul.d ft2, %[k], ft5 \n"  //  ft0 <-- a = k * (b + c)
        "fmul.d ft2, %[k], ft6 \n"  //  ft0 <-- a = k * (b + c)
        :
        : [ n_frep ] "r"(l / 4 - 1), [ k ] "f"(k)
        : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "memory");
    snrt_fpu_fence();
    snrt_ssr_disable();
    snrt_mcycle();

#elif defined(SCSSR)
    snrt_mcycle();
    snrt_ssr_loop_1d(SNRT_SSR_DM0, l, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, l, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM2, l, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, b);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, c);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, a);

    snrt_ssr_enable();

    uint32_t mask = 0x00000008;
    snrt_sc_enable(mask);

    asm volatile(
        "fence \n"
        "frep.o %[n_frep], 8, 0, 0 \n"
        "fadd.d ft3, ft0, ft1 \n"   // ft3 <-- d = b + c
        "fadd.d ft3, ft0, ft1 \n"   // ft3 <-- d = b + c
        "fadd.d ft3, ft0, ft1 \n"   // ft3 <-- d = b + c
        "fadd.d ft3, ft0, ft1 \n"   // ft3 <-- d = b + c
        "fmul.d ft2, %[k], ft3 \n"  //  ft0 <-- a = k * (b + c)
        "fmul.d ft2, %[k], ft3 \n"  //  ft0 <-- a = k * (b + c)
        "fmul.d ft2, %[k], ft3 \n"  //  ft0 <-- a = k * (b + c)
        "fmul.d ft2, %[k], ft3 \n"  //  ft0 <-- a = k * (b + c)
        :
        : [ n_frep ] "r"(l / 4 - 1), [ k ] "f"(k)
        : "ft0", "ft1", "ft2", "ft3", "memory");
    snrt_fpu_fence();
    snrt_sc_disable(mask);
    snrt_ssr_disable();
    snrt_mcycle();

#else
    snrt_mcycle();
    for (int i = 0; i < l; i++) {
        a[i] = (k * (b[i] + c[i]));
    }
    snrt_fpu_fence();
    snrt_mcycle();
#endif
}