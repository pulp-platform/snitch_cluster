// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Authors: Lannan Jiang <jiangl@student.ethz.ch>
//          Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

#define LENGTH 64

int main() {
    // Only compute cores proceed
    if (snrt_is_dm_core()) return 0;

    // Allocate input and output arrays
    uint64_t *input = (uint64_t *)snrt_l1_alloc_compute_core_local(
        LENGTH * sizeof(uint32_t), sizeof(uint32_t));
    double *golden_output = (double *)snrt_l1_alloc_compute_core_local(
        LENGTH * sizeof(double), sizeof(double));
    double *actual_output = (double *)snrt_l1_alloc_compute_core_local(
        LENGTH * sizeof(double), sizeof(double));

    // Initialize first half of input array with positive numbers
    for (int i = 0; i < LENGTH / 2; i++) {
        input[i] = snrt_cluster_core_idx() * (LENGTH / 2) + i;
    }

    // Initialize second half of input array with negative numbers
    for (int i = LENGTH / 2; i < LENGTH; i++) {
        input[i] = -(snrt_cluster_core_idx() * (LENGTH / 2) + i);
    }

    // Calculate golden outputs using reference flt.d instruction
    for (int i = 0; i < LENGTH; i++) {
        asm volatile("fcvt.d.w %[out], %[in] \n"
                     : [ out ] "=f"(golden_output[i])
                     : [ in ] "r"((uint32_t)input[i])
                     :);
    }
    snrt_fpu_fence();

    // Configure SSRs
    snrt_ssr_loop_1d(SNRT_SSR_DM0, LENGTH, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM2, LENGTH, sizeof(double));
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, input);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, actual_output);

    // Calculate outputs using flt.d.copift instruction
    snrt_ssr_enable();
    asm volatile(
        "frep.o  %[n_frep], 1, 0, 0 \n"
        "fcvt.d.w.copift ft2, ft0 \n"
        :
        : [ n_frep ] "r"(LENGTH - 1)
        : "ft0", "ft1", "ft2", "ft3", "memory");
    snrt_ssr_disable();
    snrt_fpu_fence();

    // Compare results
    uint32_t n_errors = LENGTH;
    for (int i = 0; i < LENGTH; i++) {
        if (golden_output[i] == actual_output[i]) n_errors--;
    }
    return n_errors;
}
