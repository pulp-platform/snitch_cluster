// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Authors: Lannan Jiang <jiangl@student.ethz.ch>
//          Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

#define LENGTH 8

int main() {
    // Only compute cores proceed
    if (snrt_is_dm_core()) return 0;

    // Allocate input and output arrays
    double *input = (double *)snrt_l1_alloc_compute_core_local(
        LENGTH * sizeof(double), sizeof(double));
    uint32_t *golden_output = (uint32_t *)snrt_l1_alloc_compute_core_local(
        LENGTH * sizeof(uint32_t), sizeof(uint32_t));
    uint64_t *actual_output = (uint64_t *)snrt_l1_alloc_compute_core_local(
        LENGTH * sizeof(uint64_t), sizeof(uint64_t));

    // Initialize input array
    input[0] = 0.1;
    input[1] = 0.2;
    input[2] = 1.3;
    input[3] = 1.4;
    input[4] = 0.8;
    input[5] = 0.99;
    input[6] = 1.8;
    input[7] = 1.1;

    // Calculate golden outputs using reference flt.d instruction
    for (int i = 0; i < LENGTH; i++) {
        asm volatile("flt.d %[out], %[in], %[one] \n"
                     : [ out ] "+r"(golden_output[i])
                     : [ one ] "f"(1.0), [ in ] "f"(input[i])
                     :);
    }
    snrt_fpu_fence();

    // Configure SSRs
    snrt_ssr_loop_1d(SNRT_SSR_DM0, LENGTH, sizeof(double));
    snrt_ssr_loop_1d(SNRT_SSR_DM2, LENGTH, sizeof(double));
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, input);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, actual_output);

    // Calculate outputs using flt.d.copift instruction
    register double reg_one asm("ft3") = 1.0;  // 3
    snrt_ssr_enable();
    asm volatile(
        "frep.o  %[n_frep], 1, 0, 0 \n"
        "flt.d.copift ft2, ft0, ft3 \n"
        :
        : [ n_frep ] "r"(LENGTH - 1), "f"(reg_one)
        : "ft0", "ft1", "ft2", "ft3", "memory");
    snrt_ssr_disable();
    snrt_fpu_fence();

    // Compare results
    uint32_t n_errors = LENGTH;
    for (int i = 0; i < LENGTH; i++) {
        if (golden_output[i] == (uint32_t)actual_output[i]) n_errors--;
    }
    return n_errors;
}
