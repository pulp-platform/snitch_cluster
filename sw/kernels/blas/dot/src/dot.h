// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

inline void dot_seq(uint32_t n, double *x, double *y, double *output) {
    // Start of SSR region.
    register volatile double ft0 asm("ft0");
    register volatile double ft1 asm("ft1");
    asm volatile("" : "=f"(ft0), "=f"(ft1));

    snrt_ssr_loop_1d(SNRT_SSR_DM0, n, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, n, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, x);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, y);

    register volatile double res_ssr asm("fs0") = 0;

    snrt_ssr_enable();

    const register uint32_t Nm1 asm("t0") = n - 1;
    asm volatile(
        "frep.o %[n_frep], 1, 0, 0 \n"
        "fmadd.d %0, ft0, ft1, %0"
        : "=f"(res_ssr) /* output operands */
        : "f"(ft0), "f"(ft1), "0"(res_ssr),
          [ n_frep ] "r"(Nm1) /* input operands */
        :);

    // End of SSR region.
    snrt_fpu_fence();
    snrt_ssr_disable();
    asm volatile("" : : "f"(ft0), "f"(ft1));
    output[0] = res_ssr;
}

inline void dot_seq_4_acc(uint32_t n, double *x, double *y, double *output) {
    // Start of SSR region.
    register volatile double ft0 asm("ft0");
    register volatile double ft1 asm("ft1");
    asm volatile("" : "=f"(ft0), "=f"(ft1));

    snrt_ssr_loop_1d(SNRT_SSR_DM0, n, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, n, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, x);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, y);

    register volatile double res_ssr_0 asm("fs0") = 0;
    register volatile double res_ssr_1 asm("fs1") = 0;
    register volatile double res_ssr_2 asm("fs2") = 0;
    register volatile double res_ssr_3 asm("fs3") = 0;

    snrt_ssr_enable();

    const register uint32_t Nm1 asm("t0") = (n >> 2) - 1;
    asm volatile(
        "frep.o %[n_frep], 4, 0, 0 \n"
        "fmadd.d %0, ft0, ft1, %0 \n"
        "fmadd.d %1, ft0, ft1, %1 \n"
        "fmadd.d %2, ft0, ft1, %2 \n"
        "fmadd.d %3, ft0, ft1, %3"
        : "=f"(res_ssr_0), "=f"(res_ssr_1), "=f"(res_ssr_2),
          "=f"(res_ssr_3) /* output operands */
        : "f"(ft0), "f"(ft1), "0"(res_ssr_0), "1"(res_ssr_1), "2"(res_ssr_2),
          "3"(res_ssr_3), [ n_frep ] "r"(Nm1) /* input operands */
        :);

    // End of SSR region.
    snrt_ssr_disable();

    asm volatile(
        "fadd.d %[res_ssr_0], %[res_ssr_0], %[res_ssr_1] \n"
        "fadd.d %[res_ssr_2], %[res_ssr_2], %[res_ssr_3] \n"
        "fadd.d %[res_ssr_0], %[res_ssr_0], %[res_ssr_2]"
        : [ res_ssr_0 ] "=f"(res_ssr_0),
          [ res_ssr_2 ] "=f"(res_ssr_2) /* output operands */
        : [ res_ssr_1 ] "f"(res_ssr_1),
          [ res_ssr_3 ] "f"(res_ssr_3) /* input operands */
        :);

    snrt_fpu_fence();

    asm volatile("" : : "f"(ft0), "f"(ft1));
    output[0] = res_ssr_0;
}

static inline void dot(uint32_t n, double *x, double *y, double *result) {
    double *local_x, *local_y, *partial_sums;

    uint32_t start_cycle, end_cycle;

    // Allocate space in TCDM
    local_x = (double *)snrt_l1_next();
    local_y = local_x + n;
    partial_sums = local_y + n;

    // Copy data in TCDM
    if (snrt_is_dm_core()) {
        size_t size = n * sizeof(double);
        snrt_dma_start_1d(local_x, x, size);
        snrt_dma_start_1d(local_y, y, size);
        snrt_dma_wait_all();
    }

    // Calculate size and pointers for each core
    int core_idx = snrt_cluster_core_idx();
    int frac_core = n / snrt_cluster_compute_core_num();
    int offset_core = core_idx * frac_core;
    local_x += offset_core;
    local_y += offset_core;

    snrt_cluster_hw_barrier();

    start_cycle = snrt_mcycle();

    // Compute partial sums
    if (snrt_is_compute_core()) {
        dot_seq_4_acc(frac_core, local_x, local_y, &partial_sums[core_idx]);
    }

    snrt_cluster_hw_barrier();

    // Reduce partial sums on core 0
#ifndef _DOTP_EXCLUDE_FINAL_SYNC_
    if (snrt_cluster_core_idx() == 0) {
        for (uint32_t i = 1; i < snrt_cluster_compute_core_num(); i++) {
            partial_sums[0] += partial_sums[i];
        }
        snrt_fpu_fence();
    }
#endif

    end_cycle = snrt_mcycle();

    snrt_cluster_hw_barrier();

    // Copy data out of TCDM
    if (snrt_is_dm_core()) {
        *result = partial_sums[0];
    }

    snrt_cluster_hw_barrier();
}
