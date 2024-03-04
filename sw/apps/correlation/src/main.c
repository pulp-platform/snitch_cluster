// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "correlation.h"
#include "data.h"

#define MAX_ERROR 1e-10

int main() {
    uint32_t nerr = 0;
    double *local_mean;
    double *local_corr;
    double *local_stddev;
    double *local_data;
    double diff;

    local_data = snrt_l1_next();
    local_corr = local_data + N * M;
    local_stddev = local_corr + M * M;

    // Initialize input matrix
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_data, data, sizeof(double) * N * M);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    // Perform Computations
    kernel_correlation(N, M, local_data, local_stddev, local_corr);
    snrt_cluster_hw_barrier();

    // Writeback outputs
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(corr, local_corr, sizeof(double) * M * M);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

#ifdef BIST
    // Check computation is correct
    if (snrt_cluster_core_idx() == 0) {
        for (int i = 0; i < M; i++) {
            for (int j = 0; j < M; j++) {
                diff = fabs(golden[i * M + j] - local_corr[i * M + j]);
                if (diff > MAX_ERROR) {
                    nerr++;
                }
            }
        }
    }
#endif

    return nerr;
}
