// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// L1->L1 (TCDM->TCDM) iDMA copy across a range of sizes.
//
// Both buffers are allocated in the cluster TCDM via snrt_l1_alloc(), so
// the iDMA address decoder routes source to an OBI read and destination to
// an OBI write -- they share the single OBI/TCDM manager port, exercising
// concurrent OBI read+write arbitration. snrt_fence() orders the CPU stores
// that fill the source buffer before the DMA reads it.

#include <snrt.h>

#define MAXN 1024  // words

int main() {
#ifdef SNRT_SUPPORTS_DMA
    if (!snrt_is_dm_core()) return 0;  // only the DMA core

    uint32_t *src = (uint32_t *)snrt_l1_alloc(MAXN * sizeof(uint32_t));
    uint32_t *dst = (uint32_t *)snrt_l1_alloc(MAXN * sizeof(uint32_t));
    uint32_t errors = 0;

    const uint32_t sizes[] = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024};

    for (uint32_t s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
        uint32_t n = sizes[s];
        for (uint32_t i = 0; i < n; i++) {
            src[i] = 0xC0DE0000u | i;
            dst[i] = 0xDEAD0000u | i;
        }
        snrt_fence();
        snrt_dma_start_1d(dst, src, n * sizeof(uint32_t), 0);
        snrt_dma_wait_all(0);
        for (uint32_t i = 0; i < n; i++)
            errors += (dst[i] != (0xC0DE0000u | i));
    }

    return errors;
#endif
}
