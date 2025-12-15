// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

#define LEN 32

int main() {
    int n_errors = 0;

#if SNRT_TCDM_HYPERBANK_NUM != 1
#ifdef SNRT_SUPPORTS_FREP
    // TODO(colluca): currently only works with a bank width of 64 bits
    double zero = 0.0;
    double *bank0 = (double *)snrt_l1_next_aligned_hyperbank();
    double *bank1 = bank0 + 1;
    double *bank2 = bank1 + 1;
    double *bank24 = (double *)((uintptr_t)bank0 + SNRT_TCDM_HYPERBANK_SIZE);

    // Core 0 initializes bank 0 and 24 with data
    if (snrt_cluster_core_idx() == 0) {
        for (int i = 0; i < LEN; i++) {
            bank0[i * SNRT_TCDM_BANK_PER_HYPERBANK_NUM] = 1;
        }
        for (int i = 0; i < LEN; i++) {
            bank24[i * SNRT_TCDM_BANK_PER_HYPERBANK_NUM] = 2;
        }
    }
    snrt_cluster_hw_barrier();

    // Only cores 0 and 1 perform the test
    if (snrt_cluster_core_idx() <= 1) {
        // Core 0 reads from bank 24 and writes to bank 1,
        // core 1 reads from bank 0 and writes to bank 2
        double *src = snrt_cluster_core_idx() == 0 ? bank24 : bank0;
        double *dst = snrt_cluster_core_idx() == 0 ? bank1 : bank2;

        // Stride makes sure that accesses from an SSR are within same bank
        size_t stride = SNRT_TCDM_BANK_PER_HYPERBANK_NUM * sizeof(double);
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
            if (bank2[i * SNRT_TCDM_BANK_PER_HYPERBANK_NUM] == 1) {
                n_errors--;
            }
        }
        for (int i = 0; i < LEN; i++) {
            if (bank24[i * SNRT_TCDM_BANK_PER_HYPERBANK_NUM] == 2) {
                n_errors--;
            }
        }
    }
#endif
#endif

    return n_errors;
}
