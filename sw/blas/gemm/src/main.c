// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <math.h>
#include <stdint.h>

#include "data.h"
#include "gemm.h"
#include "snrt.h"

int main() {
    void *local_a, *local_b, *local_c;
    void *remote_a, *remote_b, *remote_c;

    // Calculate size and pointers for each cluster
    uint32_t frac_m = M / snrt_cluster_num();
    uint32_t frac_a = frac_m * K;
    uint32_t frac_c = frac_m * N;
    uint32_t size_frac_a = frac_a * dtype_size;
    uint32_t size_b = K * N * dtype_size;
    uint32_t size_frac_c = frac_c * dtype_size;
    uint32_t offset_a = frac_a * snrt_cluster_idx();
    uint32_t offset_c = frac_c * snrt_cluster_idx();
    remote_a = a + offset_a;
    remote_b = b;
    remote_c = c + offset_c;

    // Allocate space in TCDM
    local_a = (void *)snrt_l1_next();
    local_b = local_a + size_frac_a;
    local_c = local_b + size_b;

    // Copy data in TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_a, remote_a, size_frac_a);
        snrt_dma_start_1d(local_b, remote_b, size_b);
        snrt_dma_start_1d(local_c, remote_c, size_frac_c);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    // Compute
    if (!snrt_is_dm_core()) {
        const uint32_t setup_ssr = 1;
        uint32_t start_cycle = snrt_mcycle();

        volatile uint32_t lda = K;
        volatile uint32_t ldb = N;
        volatile uint32_t ldc = N;

        // Transpose of A unsopported
        if (TA) return -1;
        if (TB) {
            // Transpose of B supported only in FP64
            if (dtype_size != FP64) return -1;
            ldb = K;
        }

        gemm(dtype_size, expand, setup_ssr, TA, TB, frac_m, N, K, 1, local_a,
             lda, local_b, ldb, BETA, local_c, ldc);

        uint32_t end_cycle = snrt_mcycle();
    }

    snrt_cluster_hw_barrier();

    // Copy data out of TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(remote_c, local_c, size_frac_c);
        snrt_dma_wait_all();
    }

// TODO: currently only works for single cluster otherwise need to
//       synchronize all cores here
#ifdef BIST
    uint32_t errors = M * N;

    if (snrt_cluster_core_idx() == 0) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                uint32_t idx = m * N + n;
                switch (dtype_size) {
                    case FP64:
                        if (fabs(result[idx] - ((double *)local_c)[idx]) >
                            0.001)
                            errors--;
                        break;
                    case FP32:
                        if (fabs(result[idx] - ((float *)local_c)[idx]) > 0.001)
                            errors--;
                        break;
                    case FP16:
                        if (fabs(result[idx] - ((__fp16 *)local_c)[idx]) >
                            0.001)
                            errors--;
                        break;
                    case FP8:
                        printf("No golden model yet for fp8!\n");
                        return -1;
                        break;
                }
            }
        }
        printf("%d/%d Errors\n", errors, M * N);
    }

    return errors;
#endif

    return 0;
}
