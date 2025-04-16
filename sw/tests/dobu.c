// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

// Test TCDM alignment functions

#include "snrt.h"

#define LEN 32

#define ALIGN_NEXT_FROM_BASE(addr, base, size) \
    (((((addr) - (base)) + (size)-1) / (size)) * (size) + (base))

#define BANK_SIZE (4 * 1024)

#define NR_BANK_PER_HYPERBANK 24
#define NR_HYPERBANK 2

#define BANK_ALIGNMENT 8
#define TCDM_ALIGNMENT (NR_HYPERBANK * NR_BANK_PER_HYPERBANK * BANK_ALIGNMENT)
#define ALIGN_UP_TCDM(addr) \
    ALIGN_NEXT_FROM_BASE(addr, SNRT_TCDM_START_ADDR, TCDM_ALIGNMENT)

int main() {
    int n_errors = 0;

    double zero = 0.0;
    double *bank0 = (double *)snrt_l1_next();
    double *bank1 = bank0 + 1;
    double *bank2 = bank1 + 1;
    double *bank24 =
        (double *)((uintptr_t)bank0 + NR_BANK_PER_HYPERBANK * BANK_SIZE);

    // Core 0 initializes bank 0 and 24 with data
    if (snrt_cluster_core_idx() == 0) {
        for (int i = 0; i < LEN; i++) {
            bank0[i * NR_BANK_PER_HYPERBANK] = 1;
            // *((uint64_t *)(bank0 + i * NR_BANK_PER_HYPERBANK)) =
            // 0xAAAAAAAAAAAAAAAA;
        }
        for (int i = 0; i < LEN; i++) {
            bank24[i * NR_BANK_PER_HYPERBANK] = 2;
            // *((uint64_t *)(bank24 + i * NR_BANK_PER_HYPERBANK)) =
            // 0xBBBBBBBBBBBBBBBB;
        }
    }

    // Only cores 0 and 1 perform the test
    if (snrt_cluster_core_idx() <= 1) {
        // Core 0 reads from bank 24 and writes to bank 1,
        // core 1 reads from bank 0 and writes to bank 2
        double *src = snrt_cluster_core_idx() == 0 ? bank24 : bank0;
        double *dst = snrt_cluster_core_idx() == 0 ? bank1 : bank2;

        // Stride makes sure that accesses from an SSR are within same bank
        size_t stride = NR_BANK_PER_HYPERBANK * sizeof(double);
        snrt_ssr_loop_1d(SNRT_SSR_DM0, LEN, stride);
        snrt_ssr_loop_1d(SNRT_SSR_DM2, LEN, stride);

        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, src);
        snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, dst);
    }

    // Synchronize cores 0 and 1 to start reading at the same time
    snrt_cluster_hw_barrier();

    if (snrt_cluster_core_idx() <= 1) {
        snrt_ssr_enable();
        asm volatile(
            "frep.o %[len], 1, 0, 0 \n"
            "fadd.d ft2, ft0, %[zero] \n"
            :
            : [ len ] "r"(LEN - 1), [ zero ] "f"(zero)
            : "ft0", "ft1", "ft2", "memory");
        snrt_fpu_fence();
        snrt_ssr_disable();
    }

    // Synchronize cores 0 and 1 to wait for both cores to finish writing
    snrt_cluster_hw_barrier();

    // Core 0 checks all results
    if (snrt_cluster_core_idx() == 0) {
        n_errors = LEN * 2;
        for (int i = 0; i < LEN; i++) {
            if (bank2[i * NR_BANK_PER_HYPERBANK] == 1) {
                // if (*((uint64_t *)(bank2 + i * NR_BANK_PER_HYPERBANK)) ==
                // 0xAAAAAAAAAAAAAAAA) {
                n_errors--;
            }
        }
        for (int i = 0; i < LEN; i++) {
            if (bank24[i * NR_BANK_PER_HYPERBANK] == 2) {
                // if (*((uint64_t *)(bank1 + i * NR_BANK_PER_HYPERBANK)) ==
                // 0xBBBBBBBBBBBBBBBB) {
                n_errors--;
            }
        }
    }

    return n_errors;
}
