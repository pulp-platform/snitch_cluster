// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Fabio Cappellini <fcappellini@student.ethz.ch>
// Hakim Filali <hfilali@student.ee.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "lcg.h"
#include "math.h"
#include "pi_estimation.h"
#include "snrt.h"

#define N_SAMPLES 1024

__thread uint32_t seed0, seed1, Ap, Cp;

double pi_estimate;

inline void mc_init() {
    // Double the sequences as each core produces two random numbers
    unsigned int num_sequences = 2 * snrt_cluster_compute_core_num();
    init_2d_lcg_params(num_sequences, 0, LCG_A, LCG_C, &seed0, &seed1, &Ap,
                       &Cp);
}

int main() {
    // Initialize the PRNGs for parallel Monte Carlo
    if (snrt_is_compute_core()) mc_init();

    // Store partial sum array at first free address in TCDM
    uint32_t* reduction_array = (uint32_t*)snrt_l1_next();

    // Calculate partial sums
    uint32_t n_samples_per_core = N_SAMPLES / snrt_cluster_compute_core_num();
    reduction_array[snrt_cluster_core_idx()] =
        calculate_partial_sum(seed0, seed1, Ap, Cp, n_samples_per_core);

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
        pi_estimate = estimate_pi(sum, N_SAMPLES);

        // Check result
        double err = fabs(pi_estimate - M_PI);
        if (err > 0.05) return 1;
    }

    return 0;
}
