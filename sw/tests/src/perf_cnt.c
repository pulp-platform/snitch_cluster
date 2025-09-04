// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "printf.h"
#include "snrt.h"

#define WIDE_WORD_SIZE 64

int main() {
    uint32_t errors = 0;
    uint32_t core_idx = snrt_cluster_core_idx();

    // Test 1: Check that the performance counters immediately
    // starts tracking `Cycle` and `RetiredInstr`
    if (core_idx == 0) {
        errors += (snrt_get_perf_counter(0) == 0);
        errors += (snrt_get_perf_counter(1) == 0);
    }

    // Test 2: Check that all performance counters can be reset
    if (core_idx == 0) {
        for (int i = 0; i < SNRT_NUM_PERF_CNTS; i++) {
            // Stop and reset the performance counter
            snrt_stop_perf_counter(i);
            snrt_reset_perf_counter(i);

            // Check that the performance counter is reset
            errors += (snrt_get_perf_counter(i) != 0);
        }
    }

    // Test 3: Check that the performance counters can be configured and started
    if (core_idx == 0) {
        for (int i = 0; i < SNRT_NUM_PERF_CNTS; i++) {
            // Configure and start the performance counter
            snrt_cfg_perf_counter(i, PERF_METRIC__CYCLE, 0);
            snrt_start_perf_counter(i);
        }

        // Wait for some cycles
        for (int i = 0; i < 100; i++) {
            asm volatile("nop");
        }

        for (int i = 0; i < SNRT_NUM_PERF_CNTS; i++) {
            // Stop the performance counter
            snrt_stop_perf_counter(i);

            // Check that the performance counter is started
            errors += (snrt_get_perf_counter(i) < 100);

            // Reset the performance counter again
            snrt_reset_perf_counter(i);
        }
    }

    snrt_cluster_hw_barrier();

    // Test 4: Check DMA performance with simple 1D test
    if (snrt_is_dm_core()) {
        // Configure performance counters to track DMA read and writes
        snrt_cfg_perf_counter(0, PERF_METRIC__DMA_AW_DONE, 0);
        snrt_cfg_perf_counter(1, PERF_METRIC__DMA_AR_DONE, 0);

        // Transfer around some data
        uint32_t *dst =
            (uint32_t *)snrt_align_up(snrt_l1_next(), WIDE_WORD_SIZE);
        uint32_t *src =
            (uint32_t *)snrt_align_up(snrt_l3_next(), WIDE_WORD_SIZE);

        // Start performance counters
        snrt_start_perf_counter(0);
        snrt_start_perf_counter(1);

        // Start DMA transfer and wait for completion
        snrt_dma_txid_t txid_1d = snrt_dma_start_1d(dst, src, WIDE_WORD_SIZE);
        snrt_dma_wait_all();

        // Stop performance counter
        snrt_stop_perf_counter(0);
        snrt_stop_perf_counter(1);

        // There should be one AR and one AW
        errors += (snrt_get_perf_counter(0) != 1);
        errors += (snrt_get_perf_counter(1) != 1);

        // Reset counter
        snrt_reset_perf_counter(0);
        snrt_reset_perf_counter(1);
    }
    // Test 5: Check DMA performance with misaligned 1D test
    if (snrt_is_dm_core()) {
        // Configure performance counters to track DMA read and write beats
        snrt_cfg_perf_counter(0, PERF_METRIC__DMA_W_DONE, 0);
        snrt_cfg_perf_counter(1, PERF_METRIC__DMA_R_DONE, 0);

        // Transfer around some data
        uint32_t *dst =
            (uint32_t *)snrt_align_up(snrt_l1_next(), WIDE_WORD_SIZE);
        uint32_t *src_misaligned =
            (uint32_t *)snrt_align_up(snrt_l3_next(), WIDE_WORD_SIZE) + 0x8;

        // Start performance counters
        snrt_start_perf_counter(0);
        snrt_start_perf_counter(1);

        // Start misaligned DMA transfer and wait for completion
        snrt_dma_txid_t txid_1d_misaligned =
            snrt_dma_start_1d(dst, src_misaligned, WIDE_WORD_SIZE);
        snrt_dma_wait_all();

        // Stop performance counter
        snrt_stop_perf_counter(0);
        snrt_stop_perf_counter(1);

        // There should be two R and one W beat from the DMA
        errors += (snrt_get_perf_counter(0) != 1);
        errors += (snrt_get_perf_counter(1) != 2);
    }

    return errors;
}
