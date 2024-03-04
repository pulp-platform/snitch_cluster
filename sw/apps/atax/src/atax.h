// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <stdint.h>
#include "snrt.h"

void kernel_atax(uint32_t M, uint32_t N, double *A, double *x, double *y,
                 double *tmp) {
    double tmp_fs;
    int core_range, core_offset;

    // tmp = A * x
    if (snrt_is_compute_core()) {
        core_range = M / snrt_cluster_compute_core_num();
        core_offset = snrt_cluster_core_idx() * core_range;
        for (int i1 = 0; i1 < core_range; i1++) {
            int i = core_offset + i1;
            tmp_fs = 0.0;
            for (int j = 0; j < N; j++) {
                tmp_fs += A[i * N + j] * x[j];
            }
            tmp[i] = tmp_fs;
        }
    }

    snrt_cluster_hw_barrier();

    // y = At * tmp
    if (snrt_is_compute_core()) {
        core_range = N / snrt_cluster_compute_core_num();
        core_offset = snrt_cluster_core_idx() * core_range;
        for (int j1 = 0; j1 < core_range; j1++) {
            int j = core_offset + j1;
            tmp_fs = 0.0;
            for (int i = 0; i < M; i++) {
                // The order of the for loops was exchanged, so that each loop
                // reduces in y at position j, iterating through the i
                // positions.
                tmp_fs += A[i * N + j] * tmp[i];
            }
            y[j] = tmp_fs;
        }
    }
}
