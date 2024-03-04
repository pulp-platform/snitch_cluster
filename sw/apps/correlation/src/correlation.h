// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <math.h>
#include <stdint.h>
#include "snrt.h"

void kernel_correlation(uint32_t N, uint32_t M, double *data, double *stddev,
                        double *corr) {
    int i1, i, j, k;
    int core_range, core_offset;

    // Compute deviations
    if (snrt_is_compute_core()) {
        // Distribute different attributes to the different cores
        core_range = M / snrt_cluster_compute_core_num();
        core_offset = snrt_cluster_core_idx() * core_range;
        for (i1 = 0; i1 < core_range; i1++) {
            i = core_offset + i1;

            // Compute mean
            double mean = 0.0;
            for (k = 0; k < N; k++) {
                mean += data[k * M + i];
            }
            mean = mean / N;

            // Compute standard deviation
            double accum = 0.0;
            for (k = 0; k < N; k++) {
                accum += (data[k * M + i] - mean) * (data[k * M + i] - mean);
            }
            stddev[i] = sqrt(accum / N);

            // Standardize data to zero mean
            for (k = 0; k < N; k++) {
                data[k * M + i] -= mean;
            }
        }
    }

    snrt_cluster_hw_barrier();

    // Compute correlation
    if (snrt_is_compute_core()) {
        for (i1 = 0; i1 < core_range; i1++) {
            i = core_offset + i1;
            for (j = 0; j <= i; j++) {
                double tmp = 0.0;
                for (k = 0; k < N; k++) {
                    tmp += data[k * M + i] * data[k * M + j];
                }
                corr[i * M + j] = tmp / (N * stddev[i] * stddev[j]);
                corr[j * M + i] = corr[i * M + j];
            }
        }
    }
}
