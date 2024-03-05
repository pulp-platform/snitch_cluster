// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "atax.h"
#include "data.h"

#define MAX_ERROR 1e-10

int main() {
    uint32_t nerr = 0;
    double *local_A;
    double *local_x;
    double *local_y;
    double *local_tmp;

    // Allocate local variables
    local_A = snrt_l1_next();
    local_x = local_A + M * N;
    local_y = local_x + N;
    local_tmp = local_y + N;

    // Initialize input matrices
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_A, A, sizeof(double) * M * N);
        snrt_dma_start_1d(local_x, x, sizeof(double) * N);
        snrt_dma_start_1d(local_y, (void *)snrt_zero_memory_ptr(),
                          sizeof(double) * N);
        snrt_dma_start_1d(local_tmp, (void *)snrt_zero_memory_ptr(),
                          sizeof(double) * M);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    // Compute
    kernel_atax(M, N, local_A, local_x, local_y, local_tmp);
    snrt_cluster_hw_barrier();

    // Writeback results
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(y, local_y, sizeof(double) * N);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

// Check computation is correct
#ifdef BIST
    if (snrt_cluster_core_idx() == 0) {
        // Check y
        for (int i = 0; i < N; i++) {
            double diff = fabs(golden[i] - local_y[i]);
            if (diff > MAX_ERROR) {
                nerr++;
            }
        }
    }
#endif

    return nerr;
}
