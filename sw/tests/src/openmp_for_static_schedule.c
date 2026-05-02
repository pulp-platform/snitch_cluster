// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#define AXPY_N 64

unsigned __attribute__((noinline)) static_schedule(void) {
#ifdef SNRT_SUPPORTS_SSR
    static double *data_x, *data_y, data_a;

    // Allocate AXPY input vectors
    data_x = (double *)snrt_l1_alloc(sizeof(double) * AXPY_N);
    data_y = (double *)snrt_l1_alloc(sizeof(double) * AXPY_N);

    // Initialize AXPY input vectors
    data_a = 10.0;
    for (unsigned i = 0; i < AXPY_N; i++) {
        data_x[i] = (double)(i);
        data_y[i] = (double)(i + 1);
    }

    // Compute AXPY
#pragma omp parallel firstprivate(data_a, data_x, data_y)
    {
        int nthreads = omp_get_num_threads();
        snrt_ssr_loop_1d(SNRT_SSR_DM0, AXPY_N / nthreads, sizeof(double));
        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D,
                      &data_x[AXPY_N / nthreads * omp_get_thread_num()]);
        snrt_ssr_loop_1d(SNRT_SSR_DM1, AXPY_N / nthreads, sizeof(double));
        snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D,
                      &data_y[AXPY_N / nthreads * omp_get_thread_num()]);
        snrt_ssr_loop_1d(SNRT_SSR_DM2, AXPY_N / nthreads, sizeof(double));
        snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D,
                       &data_y[AXPY_N / nthreads * omp_get_thread_num()]);
        snrt_ssr_enable();
#pragma omp for schedule(static)
        for (unsigned i = 0; i < AXPY_N; i++) {
            asm volatile("fmadd.d ft2, %[a], ft0, ft1\n"
                         :
                         : [ a ] "f"(data_a)
                         : "ft0", "ft1", "ft2", "memory");
        }
        snrt_ssr_disable();
    }

    // check data
    unsigned errs = 0;
    double gold;
    for (unsigned i = 0; i < AXPY_N; i++) {
        gold = 10.0 * (double)(i) + (double)(i + 1);
        if ((gold - data_y[i]) * (gold - data_y[i]) > 0.01) errs++;
    }

    if (errs) printf("Error [static_schedule]: %d mismatches\n", errs);
    return errs ? 1 : 0;
#else
    return 0;
#endif
}

int main() {
#ifdef SNRT_SUPPORTS_SSR
    unsigned core_idx = snrt_cluster_core_idx();
    unsigned core_num = snrt_cluster_core_num();
    unsigned err = 0;

    // Only core 0 executes the statements below this function
    __snrt_omp_bootstrap(core_idx);

    printf("Static schedule test\n");
    err = static_schedule();
    OMP_PROF(omp_print_prof());

    // exit
    __snrt_omp_destroy(core_idx);
    return err;
#endif
}
