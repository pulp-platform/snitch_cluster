// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#include "data.h"

int main() {
    // Set err value for checking
    int err = 0;

    uint64_t *local_a, *local_b;
    uint64_t *local_o;

    // Allocate space in TCDM
    local_a = (uint64_t *)snrt_l1_next();
    local_b = local_a + VEC_LEN;
    local_o = local_b + VEC_LEN;

    uint32_t dma_pre_load = snrt_mcycle();

    // Use data mover core to bring data from L3 to TCDM
    if (snrt_is_dm_core()) {
        size_t vector_size = VEC_LEN * sizeof(uint64_t);
        snrt_dma_start_1d(local_a, A, vector_size);
        snrt_dma_start_1d(local_b, B, vector_size);
    }

    // Wait until DMA transfer is done
    snrt_cluster_hw_barrier();

    // Read the mcycle CSR (this is our way to mark/delimit a specific
    // code region for benchmarking)
    uint32_t pre_is_compute_core = snrt_mcycle();

    if (snrt_is_compute_core()) {
        // This marks the start of the accelerator style of MAC operation
        uint32_t csr_set = snrt_mcycle();

        // Set addresses
        write_csr(0x3d0, (uint64_t)local_a);
        write_csr(0x3d1, (uint64_t)local_b);
        write_csr(0x3d3, (uint64_t)local_o);

        // Set configs
        write_csr(0x3d4, 1);   // Number of iterations
        write_csr(0x3d5, 19);  // Vector length
        write_csr(0x3d6, 1);   // Set simple multiplication

        // Write start CSR to launch accelerator
        write_csr(0x3c0, 0);

        // Start of CSR start and poll until accelerator finishes
        uint32_t mac_start = snrt_mcycle();

        uint32_t break_poll;

        while (1) {
            // 0x3c3 is the CSR address for accelerator status
            break_poll = read_csr(0x3c3);
            if (break_poll == 0) {
                break;
            };
        };

        uint32_t mac_end = snrt_mcycle();
        uint64_t cpu_checker;

        for (uint64_t i = 0; i < (uint64_t)VEC_LEN; i++) {
            // Check if output is same as golden output
            if (*(local_o + i) != OUT[i]) {
                err++;
            };

            // Compute using CPU multiplier
            // Not the MAC output
            cpu_checker = (*(local_a + i)) * (*(local_b + i));

            // Compare if MAC output is same as CPU multiplier
            if (*(local_o + i) != cpu_checker) {
                err++;
            };
        };

        uint32_t end_of_check = snrt_mcycle();
    };

    return err;
}
