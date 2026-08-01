// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>
#include <stdint.h>

#define N 8

// Input data in off-chip memory (DRAM)
double a[N]
    __attribute__((aligned(4096))) = {3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0};
double b[N]
    __attribute__((aligned(4096))) = {2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0};

#ifndef SNRT_SUPPORTS_VECTOR
int main() { return 0; }
#else
int main() {
    // Allocate space for a, b, c in L1 (TCDM)
    double *local_a = (double *)snrt_l1_next();
    double *local_b = local_a + N;
    double *local_c = local_b + N;

    // DMA core moves data from DRAM to L1
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_a, a, N * sizeof(double));
        snrt_dma_start_1d(local_b, b, N * sizeof(double));
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        int errs = 0;
        unsigned int vl;

        asm volatile("vsetvli %0, %1, e64, m8, ta, ma"
                     : "=r"(vl)
                     : "r"((unsigned int)N));

        // Load a and b from L1, multiply, store result to L1
        asm volatile("vle64.v v0, (%0)" ::"r"(local_a));
        asm volatile("vle64.v v8, (%0)" ::"r"(local_b));
        asm volatile("vfmul.vv v8, v0, v8");
        asm volatile("vse64.v v8, (%0)" ::"r"(local_c));

        // Check results via volatile pointer to prevent auto-vectorization
        double *vc = (double *)local_c;
        for (int i = 0; i < N; i++) {
            if ((vc[i] - 6.0) > 0.01f) errs++;
        }

        return errs;
    }

    snrt_cluster_hw_barrier();

    return 0;
}
#endif
