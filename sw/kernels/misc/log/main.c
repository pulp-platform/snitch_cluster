// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "math.h"
#include "snrt.h"

#include "vlogf.h"

float a[LEN];
double b_golden[LEN], b_actual[LEN];

int main() {
    uint32_t tstart, tend;

    // Initialize input array
    if (snrt_cluster_core_idx() == 0)
        for (int i = 0; i < LEN; i++) a[i] = (float)(i + 1) / LEN;

    // Calculate logarithm of input array using reference implementation
    if (snrt_cluster_core_idx() == 0) {
        for (int i = 0; i < LEN; i++) {
            b_golden[i] = (double)logf(a[i]);
        }
    }

    // Synchronize cores
    snrt_cluster_hw_barrier();

    // Calculate logarithm of input array using vectorized implementation
    vlogf_kernel(a, b_actual);

    // Check if the results are correct
    if (snrt_cluster_core_idx() == 0) {
        uint32_t n_err = LEN;
        for (int i = 0; i < LEN; i++) {
            if ((float)b_golden[i] != (float)b_actual[i])
                printf("Error: b_golden[%d] = %f, b_actual[%d] = %f\n", i,
                       (float)b_golden[i], i, (float)b_actual[i]);
            else
                n_err--;
        }
        return n_err;
    } else
        return 0;
}
