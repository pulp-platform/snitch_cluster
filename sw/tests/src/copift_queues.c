// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

// Move integer values from the integer RF to the FP RF and back
// passing through the i2f and f2i COPIFT queues.

#include "snrt.h"

#define N_ITERS 64
#define START_VAL 6

int main() {
    if (snrt_cluster_core_idx() > 0) return 0;

    uint32_t n_iters = N_ITERS;
    uint32_t val = START_VAL;
    uint32_t end_val = START_VAL + n_iters;
    uint32_t t6;
    uint32_t n_errs = 1 + n_iters * 2;

    uint32_t f2i[N_ITERS];
    double i2f[N_ITERS];

    snrt_ssr_loop_1d(SNRT_SSR_DM0, n_iters, sizeof(double));
    snrt_ssr_write(SNRT_SSR_DM0, SNRT_SSR_1D, i2f);
    snrt_ssr_enable();

    // We must perform one iteration of the integer loop before offloading the
    // FREP to make sure we can unblock it.
    asm volatile(
        "mv        t6, x0 \n"                 // Load 0 into t6
        "csrrsi    x0, 0x7C4, 0x1 \n"         // Enable queues
        "mv        t6, %[val] \n"             // Write val to i2f
        "frep.o    %[n_iters], 3, 0, 0 \n"    // FP loop
        "fcvt.d.wu ft3, t6 \n"                // Read val from i2f to ft3
        "fmv.d     ft0, ft3 \n"               // Write ft3 to i2f[]
        "fcvt.w.d  t6, ft3 \n"                // Write ft3 to f2i
        "mv        t0, t6\n"                  // Read from f2i into t0
        "sw        t0, 0(%[f2i]) \n"          // Store t0 into f2i[]
        "addi      %[f2i], %[f2i], 4 \n"      // Increment f2i pointer
        "addi      %[val], %[val], 1 \n"      // Increment val
        "loop: \n"                            // Start integer loop body
        "mv        t6, %[val] \n"             // Write val to i2f
        "mv        t0, t6\n"                  // Read from f2i into t0
        "sw        t0, 0(%[f2i]) \n"          // Store t0 into f2i[]
        "addi      %[f2i], %[f2i], 4 \n"      // Increment f2i pointer
        "addi      %[val], %[val], 1 \n"      // Increment val
        "bne       %[val], %[eval], loop \n"  // End integer loop body
        "csrrci    x0, 0x7C4, 0x1 \n"         // Disable queues
        "mv        %[t6], t6 \n"              // Read t6 into %[t6]
        : [ t6 ] "=r"(t6), [ val ] "+r"(val)
        : [ eval ] "r"(end_val), [ n_iters ] "r"(n_iters - 1), [ f2i ] "r"(f2i)
        : "ft0", "ft1", "ft2", "ft3", "t6", "memory");

    snrt_ssr_disable();

    // Test that value stored in t6 (aliased with i2f) is the same as was last
    // written before enabling the queues (i.e. 0).
    n_errs -= (t6 == 0);

    // Test that values read from i2f are the same as written into it.
    for (int i = 0; i < n_iters; i++)
        n_errs -= ((int)(i2f[i]) == (START_VAL + i));

    // Test that values read from f2i are the same as written into it.
    for (int i = 0; i < n_iters; i++) n_errs -= (f2i[i] == (START_VAL + i));

    return n_errs;
}