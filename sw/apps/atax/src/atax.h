// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <stdint.h>
#include "args.h"
#include "blas.h"
#include "snrt.h"

static inline void atax(uint32_t M, uint32_t N, double *A, double *x, double *y,
                        double *tmp) {
    double tmp_fs;
    int core_range, core_offset, cluster_core_offset;

    // tmp = A * x
    if (snrt_is_compute_core()) {
        snrt_mcycle();
        gemv(0, M, N, 1, A, x, 1, tmp);
        snrt_mcycle();
    }

    snrt_cluster_hw_barrier();

    // y = At * tmp
    if (snrt_is_compute_core()) {
        snrt_mcycle();
        core_range = N / snrt_global_compute_core_num();
        core_offset = snrt_global_compute_core_idx() * core_range;
        cluster_core_offset = snrt_cluster_core_idx() * core_range;
        for (int j1 = 0; j1 < core_range; j1++) {
            int j = core_offset + j1;
            int cluster_j = cluster_core_offset + j1;
            tmp_fs = 0.0;
            for (int i = 0; i < M; i++) {
                // The order of the for loops was exchanged, so that each loop
                // reduces in y at position j, iterating through the i
                // positions.
                tmp_fs += A[i * N + j] * tmp[i];
            }
            y[cluster_j] = tmp_fs;
        }
        snrt_fpu_fence();
        snrt_mcycle();
    }
}

void atax_job(void *args) {
    double *local_A;
    double *local_x;
    double *local_y;
    double *local_tmp;
    atax_args_t *local_args;

#ifndef JOB_ARGS_PRELOADED
    // Allocate space for job arguments in TCDM
    local_args = (atax_args_t *)snrt_l1_alloc_cluster_local(sizeof(atax_args_t),
                                                            sizeof(double));

    // Copy job arguments to TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_args, args, sizeof(atax_args_t));
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();
#else
    local_args = (atax_args_t *)args;
#endif

    // Aliases
    uint32_t M = local_args->M;
    uint32_t N = local_args->N;
    double *A = (double *)(local_args->A_addr);
    double *x = (double *)(local_args->x_addr);
    double *y = (double *)(local_args->y_addr);

    // Allocate local variables
    size_t size_A = M * N * sizeof(double);
    size_t size_x = N * sizeof(double);
    size_t size_y = N * sizeof(double);
    size_t size_tmp = M * sizeof(double);
    size_t size_y_tile = size_y / snrt_cluster_num();
    local_A = (double *)snrt_l1_alloc_cluster_local(size_A, sizeof(double));
    local_x = (double *)snrt_l1_alloc_cluster_local(size_x, sizeof(double));
    local_y =
        (double *)snrt_l1_alloc_cluster_local(size_y_tile, sizeof(double));
    local_tmp = (double *)snrt_l1_alloc_cluster_local(size_tmp, sizeof(double));

    // Initialize input matrices
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_A, A, size_A);
        snrt_dma_start_1d(local_x, x, size_x);
        snrt_dma_wait_all();
    }
    snrt_mcycle();
    snrt_cluster_hw_barrier();

    // Compute
    atax(M, N, local_A, local_x, local_y, local_tmp);
    snrt_cluster_hw_barrier();
    snrt_mcycle();

    // Writeback results
    if (snrt_is_dm_core()) {
        snrt_dma_store_1d_tile(y, local_y, snrt_cluster_idx(),
                               N / snrt_cluster_num(), sizeof(double));
        snrt_dma_wait_all();
        snrt_mcycle();
    }
    snrt_cluster_hw_barrier();

    // Free memory
#ifndef JOB_ARGS_PRELOADED
    snrt_l1_update_next_v2(local_args);
#else
    snrt_l1_update_next_v2(local_A);
#endif
}
