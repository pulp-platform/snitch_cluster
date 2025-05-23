// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>

#define TRANSFER_SIZE 64
#define TRANSFER_LEN TRANSFER_SIZE / sizeof(uint32_t)
#define TRANSFER_REP 64

uint32_t buffer_src_l3[TRANSFER_LEN * TRANSFER_REP];

int main() {
    if (!snrt_is_dm_core()) return 0;  // only DMA core
    uint32_t errors = 0;
    uint32_t buffer_src_l1[TRANSFER_LEN];
    uint32_t buffer_dst_l1_1[TRANSFER_LEN];
    uint32_t buffer_dst_l1_2[TRANSFER_LEN];

    // Populate buffers.
    for (uint32_t i = 0; i < TRANSFER_LEN; i++) {
        buffer_src_l1[i] = 0xAAAAAAAA;
        buffer_dst_l1_1[i] = 0x55555555;
        buffer_dst_l1_2[i] = 0xBBBBBBBB;
    }
    for (uint32_t i = 0; i < TRANSFER_LEN * TRANSFER_REP; i++) {
        buffer_src_l3[i] = i + 1;
    }

    // Start slow/large 2D transfer from L3 to L1 on channel 0.
    snrt_dma_start_2d(buffer_dst_l1_1, buffer_src_l3, TRANSFER_SIZE, 0,
                      TRANSFER_SIZE, TRANSFER_REP, 0);

    // Start fast/small 1D transfer from L1 to L1 on channel 1.
    snrt_dma_start_1d(buffer_dst_l1_2, buffer_src_l1, TRANSFER_SIZE, 1);

    // Check that the fast transfer can finish first.
    uint32_t busy_slow, busy_fast;
    do {
        asm volatile("dmstati %0, 2" : "=r"(busy_slow));
        asm volatile("dmstati %0, 6" : "=r"(busy_fast));
    } while (busy_fast);

    // Check that the fast transfer has finished first.
    if (!busy_slow) {
        errors++;
    }

    // Wait for the slow transfer to finish.
    snrt_dma_wait_all(0);

    // Check that the main memory buffer contains the correct data.
    for (uint32_t i = 0; i < TRANSFER_LEN; i++) {
        errors +=
            (buffer_dst_l1_1[i] != TRANSFER_LEN * (TRANSFER_REP - 1) + i + 1);
        errors += (buffer_dst_l1_2[i] != 0xAAAAAAAA);
    }

    return errors;
}
