// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>

// Allocate a buffer in the main memory which we will use to copy data around
// with the DMA.
uint32_t buffer[32];

int main() {
    if (snrt_global_core_idx() != 8) return 0;  // only DMA core

    // Populate source buffer.
    uint32_t buffer_src[32];
    for (uint32_t i = 0; i < 32; i++) {
        buffer_src[i] = i + 1;
    }

    // Start a DMA transfer of zero size.
    snrt_dma_txid_t id = snrt_dma_start_1d(buffer, buffer_src, 0);
    snrt_dma_wait(id);

    // Test is successful if the previous transfer doesn't block.
}
