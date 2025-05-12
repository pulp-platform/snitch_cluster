// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#include "data.h"
#include "snax-alu-lib.h"
#include "streamer_csr_addr_map.h"

int main() {
    // Set err value for checking
    int err = 0;

    // Allocates space in TCDM
    uint64_t *local_a, *local_b, *local_o;

    local_a = (uint64_t *)snrt_l1_next();
    local_b = local_a + DATA_LEN;
    local_o = local_b + DATA_LEN;

    // Start of pre-loading data from L2 memory
    // towards the L1 TCDM memory
    // Use the Snitch core with a DMA
    // to move the data from L2 to L1
    if (snrt_is_dm_core()) {
        // This measures the start of cycle count
        // for preloading the data to the L1 memory
        uint32_t start_dma_load = snrt_mcycle();

        // The DATA_LEN is found in data.h
        size_t vector_size = DATA_LEN * sizeof(uint64_t);
        snrt_dma_start_1d(local_a, A, vector_size);
        snrt_dma_start_1d(local_b, B, vector_size);

        // Measure the end of the transfer process
        uint32_t end_dma_load = snrt_mcycle();
    }

    // Synchronize cores by setting up a
    // fence barrier for the DMA and accelerator core
    snrt_cluster_hw_barrier();

    // This assigns the tasks inside the condition
    // to the core controlling the accelerator
    if (snrt_is_compute_core()) {
        // Iterate 3 times for different accelerators
        for (uint32_t i = 0; i < 3; i++) {
            printf("Accelerator %d \n", i);

            uint32_t start_csr_setup = snrt_mcycle();

            // Configure MUX for the accelerator
            write_csr_multi_acc_mux(i);

            // Configure streamer settings
            configure_streamer_a((uint64_t)local_a, 0, 8, LOOP_ITER, 32);

            configure_streamer_b((uint64_t)local_b, 0, 8, LOOP_ITER, 32);

            configure_streamer_o((uint64_t)local_o, 0, 8, LOOP_ITER, 32);

            // Configure ALU settings
            configure_alu(MODE, LOOP_ITER);

            // Start streamer then start ALU
            start_streamer();
            start_alu();

            // Mark the end of the CSR setup cycles
            uint32_t end_csr_setup = snrt_mcycle();

            // Do this to poll the accelerator
            while (read_busy_alu()) {
            };

            // Do this to poll the streamer state
            while (read_busy_streamer()) {
            };

            // Compare results and check if the
            // accelerator returns correct answers
            // For every incorrect answer, increment err
            for (uint32_t i = 0; i < DATA_LEN; i++) {
                if (OUT[i] != *(local_o + i)) {
                    err++;
                }
            }

            // Read performance counter
            uint32_t perf_count = csrr_ss(ALU_RO_PERF_COUNT);

            printf("Accelerator Done! \n");
            printf("Accelerator Cycles: %d \n", perf_count);
            printf("Number of errors: %d \n", err);
        };
    };

    return err;
}
