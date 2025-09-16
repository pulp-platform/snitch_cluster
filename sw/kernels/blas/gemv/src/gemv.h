// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <stdint.h>

#include "snrt.h"

#pragma once

typedef struct {
    double alpha;
    uint32_t trans;
    uint32_t m;
    uint32_t n;
    double *a;
    double *x;
    double *y;
} gemv_args_t;

static inline void single_core_gemv(uint32_t trans, uint32_t m, uint32_t n,
                                    double alpha, double *a, uint32_t lda,
                                    double *x, uint32_t incx, double *y) {
    // Configure SSR 0 to stream a
    uint32_t ssr0_b[2] = {n, m};
    if (trans) {
        uint32_t ssr0_i[2] = {lda * 8, 8};
        snrt_ssr_loop_2d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_i[0],
                         ssr0_i[1]);
    } else {
        uint32_t ssr0_i[2] = {8, lda * 8};
        snrt_ssr_loop_2d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_i[0],
                         ssr0_i[1]);
    }

    // Configure SSR 1 to stream x
    uint32_t ssr1_b[2] = {n, m};
    uint32_t ssr1_i[2] = {8 * incx, 0};
    snrt_ssr_loop_2d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_i[0], ssr1_i[1]);

    // Enable SSRs
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_2D, a);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_2D, x);
    snrt_ssr_enable();

    for (uint32_t i = 0; i < m; i++) {
        double acc = 0.0;

        asm volatile(
            "fld ft3, 0(%[alpha]) \n"
            "frep.o %[n_frep], 1, 0, 0 \n"
            "fmadd.d %[acc], ft0, ft1, %[acc] \n"
            "fmul.d %[acc], %[acc], ft3 \n"
            : [ acc ] "+f"(acc)
            : [ n_frep ] "r"(n - 1), [ alpha ] "r"(&alpha)
            : "ft0", "ft1", "ft2", "ft3", "memory");

        y[i] = acc;
    }
    snrt_ssr_disable();
    snrt_fpu_fence();
}

// In contrast with BLAS we accept incx==0, as could be used e.g.
// to compress vectors with a single value.
static inline void gemv(uint32_t trans, uint32_t m, uint32_t n, double alpha,
                        double *a, double *x, uint32_t incx, double *y) {
    uint32_t frac_m, rem_m, start_m, core_m, lda;
    double *core_a;

    // Distribute rows to cores in cluster.
    // Last core computes remainder rows
    frac_m = m / snrt_cluster_compute_core_num();
    rem_m = m % snrt_cluster_compute_core_num();
    start_m = snrt_cluster_core_idx() * frac_m;
    core_m = snrt_cluster_core_idx() == (snrt_cluster_compute_core_num() - 1)
                 ? frac_m + rem_m
                 : frac_m;
    if (trans) {
        lda = m;
        core_a = &a[start_m];
    } else {
        lda = n;
        core_a = &a[start_m * lda];
    }

    // Every core computes its portion of rows
    if (core_m > 0)
        single_core_gemv(trans, core_m, n, alpha, core_a, lda, x, incx,
                         &y[start_m]);
}
