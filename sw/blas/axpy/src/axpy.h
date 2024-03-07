// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

inline void axpy(uint32_t n, double a, double* x, double* y, double* z) {
    int core_idx = snrt_cluster_core_idx();
    int frac = n / snrt_cluster_compute_core_num();
    int offset = core_idx * frac;

#ifndef XSSR

    for (int i = 0; i < frac; i++) {
        z[offset] = a * x[offset] + y[offset];
        offset++;
    }
    snrt_fpu_fence();

#else

    // TODO(colluca): revert once Banshee supports SNRT_SSR_DM_ALL
    // snrt_ssr_loop_1d(SNRT_SSR_DM_ALL, frac, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM0, frac, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM1, frac, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM2, frac, sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, x + offset);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, y + offset);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, z + offset);

    snrt_ssr_enable();

    asm volatile(
        "frep.o %[n_frep], 1, 0, 0 \n"
        "fmadd.d ft2, %[a], ft0, ft1\n"
        :
        : [ n_frep ] "r"(frac - 1), [ a ] "f"(a)
        : "ft0", "ft1", "ft2", "memory");

    snrt_fpu_fence();
    snrt_ssr_disable();

#endif
}
