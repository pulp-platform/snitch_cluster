// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>

// Allocate a buffer in the main memory which we will use to copy data around
// with the DMA.
uint32_t buffer[32];

int main() {
    if (snrt_global_core_idx() != 8) return 0;  // only DMA core
    uint32_t errors = 0;

    // Populate buffers.
    uint32_t buffer_src[32], buffer_dst[32];
    for (uint32_t i = 0; i < 32; i++) {
        buffer[i] = 0xAAAAAAAA;
        buffer_dst[i] = 0x55555555;
        buffer_src[i] = 0x55555555;
    }

    uint8_t byte = 0x11;
    // Write data to main memory.
    snrt_dma_txid_t id =
        snrt_dma_memset_init_1d((uint64_t)buffer, 0x55, sizeof(buffer), 0);
    snrt_dma_wait_all_channels(0);

    // Check that the main memory buffer contains the correct data.
    for (uint32_t i = 0; i < 32; i++) {
        errors += (buffer[i] != buffer_src[i]);
    }

    // Write data to L1.
    id = snrt_dma_memset_init_1d((uint64_t)buffer_dst, 0xff, sizeof(buffer), 0);
    snrt_dma_wait_all_channels(0);

    // Check that the L1 buffer contains the correct data.
    for (uint32_t i = 0; i < 32; i++) {
        errors += (buffer_dst[i] != 0xffffffff);
    }

    return errors;
}
