// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Fabio Cappellini <fcappellini@student.ethz.ch>
// Hakim Filali <hfilali@student.ee.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "math.h"
#include "prng.h"
#include "snrt.h"

#define N_SAMPLES 1024

__thread double one = 1.0;

static inline uint32_t calculate_partial_sum(lcg_t lcg1, lcg_t lcg2,
                                             unsigned int n_samples) {
    uint32_t x1 = lcg_next(&lcg1);
    uint32_t x2 = lcg_next(&lcg2);
    double u1, u2;
    unsigned int result = 0;

    for (unsigned int i = 0; i < n_samples; i++) {
        u1 = rand_int_to_unit_double(x1);
        u2 = rand_int_to_unit_double(x2);
        x1 = lcg_next(&lcg1);
        x2 = lcg_next(&lcg2);

        if ((u1 * u1 + u2 * u2) < one) {
            result++;
        }
    }
    return result;
}

int main() {
    // Initialize the PRNGs for parallel Monte Carlo
    uint32_t n_seq = snrt_cluster_compute_core_num() * 2;
    lcg_t* prngs = (lcg_t*)snrt_l1_alloc_cluster_local(sizeof(lcg_t) * n_seq,
                                                       sizeof(lcg_t));
    if (snrt_cluster_core_idx() == 0) {
        lcg_init_n_default(0, n_seq, prngs);
    }
    snrt_cluster_hw_barrier();

    // Store partial sum array at first free address in TCDM
    uint32_t* reduction_array = (uint32_t*)snrt_l1_alloc_cluster_local(
        sizeof(uint32_t) * snrt_cluster_compute_core_num(), sizeof(uint32_t));

    // Calculate partial sums
    if (snrt_is_compute_core()) {
        uint32_t n_samples_per_core =
            N_SAMPLES / snrt_cluster_compute_core_num();
        lcg_t lcg1 = prngs[snrt_cluster_core_idx() * 2];
        lcg_t lcg2 = prngs[snrt_cluster_core_idx() * 2 + 1];
        reduction_array[snrt_cluster_core_idx()] =
            calculate_partial_sum(lcg1, lcg2, n_samples_per_core);
    }

    // Synchronize cores
    snrt_cluster_hw_barrier();

    // First core in cluster performs the final calculation
    if (snrt_cluster_core_idx() == 0) {
        // Reduce partial sums
        uint32_t sum = 0;
        for (int i = 0; i < snrt_cluster_compute_core_num(); i++) {
            sum += reduction_array[i];
        }

        // Estimate pi
        double pi = (double)(4 * sum) / (double)N_SAMPLES;

        // Check result
        double err = fabs(pi - M_PI);
        if (err > 0.05) return 1;
    }

    return 0;
}
