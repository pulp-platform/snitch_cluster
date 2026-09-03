// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>

// Allocate a buffer in the main memory which we will use to copy data around
// with the DMA.
uint32_t buffer[32];

int main() {
    if (!snrt_is_dm_core()) return 0;
    uint32_t errors = 0;

    // Populate buffers.
    uint32_t buffer_src[32], buffer_dst[32];
    for (uint32_t i = 0; i < 32; i++) {
        buffer[i] = 0xAAAAAAAA;
        buffer_dst[i] = 0x55555555;
        buffer_src[i] = 0x55555555;
    }

    snrt_fence();

    // Write data to main memory.
    snrt_dma_memset((uint64_t)buffer, 0x55, sizeof(buffer), 0);

    // Check that the main memory buffer contains the correct data.
    for (uint32_t i = 0; i < 32; i++) {
        errors += (buffer[i] != buffer_src[i]);
    }

    // Write data to L1.
    snrt_fence();
    snrt_dma_memset((uint64_t)buffer_dst, 0xff, sizeof(buffer), 0);

    // Check that the L1 buffer contains the correct data.
    for (uint32_t i = 0; i < 32; i++) {
        errors += (buffer_dst[i] != 0xffffffff);
    }

    return errors;
}
