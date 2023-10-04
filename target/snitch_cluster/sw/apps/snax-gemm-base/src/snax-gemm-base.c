
// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "data.h"
#include "snrt.h"

int main() {
    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    uint8_t *local_a, *local_b;
    uint32_t *local_c;

    uint32_t tic, toc;

    // Allocate space in TCDM
    local_a = (uint8_t *)snrt_l1_next();
    local_b = local_a + m * k * sizeof(uint8_t);
    local_c = (uint32_t *)(local_b + n * k * sizeof(uint8_t));

    // Transfer data from L3 to L1
    // Using DMA only
    if (snrt_is_dm_core()) {
        tic = snrt_mcycle();
        tic = snrt_mcycle();

        snrt_dma_start_1d(local_a, A, m * k * sizeof(uint8_t));
        snrt_dma_start_1d(local_b, B, n * k * sizeof(uint8_t));

        toc = snrt_mcycle();

        printf("DMA transfer cycles: %d \n", toc - tic);
    }

    // Wait for DMA to finish
    snrt_cluster_hw_barrier();

    // Base MM calculation
    if (snrt_is_compute_core()) {
        tic = snrt_mcycle();
        uint32_t temp_accumulator;

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                temp_accumulator = 0;
                for (int s = 0; s < k; s++) {
                    temp_accumulator += (uint32_t)(*(local_a + i * k + s)) *
                                        (uint32_t)(*(local_b + s + j * k));
                }
                *(local_c + i * k + j) = temp_accumulator;
            }
        }

        toc = snrt_mcycle();

        printf("Cycles: %d \n", toc - tic);

        // Check if result is not equal to golden result
        for (uint32_t i = 0; i < m; i++) {
            for (uint32_t j = 0; j < n; j++) {
                if (C_golden[i * n + j] != *(local_c + (i * n + j))) {
                    err += 1;
                };
            }
        }
    };

    return err;
}
