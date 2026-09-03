// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// L1->L1 iDMA copy between two clusters across a range of sizes.

#include <snrt.h>

#define MAXN 256

int main() {
#ifdef SNRT_SUPPORTS_DMA
    if (!snrt_is_dm_core()) return 0;
    if (snrt_cluster_num() < 2) return 0;
    uint32_t errors = 0;

    // Local cluster buffer. Access it via OBI.
    uint32_t *local = (uint32_t *)snrt_l1_alloc(MAXN * sizeof(uint32_t));

    // Remote cluster buffer. Use same offset in the neighbouring cluster's TCDM.
    // Accesses to this address leave the cluster via AXI.
    uint32_t remote_cluster_idx = (snrt_cluster_idx() + 1) % snrt_cluster_num();
    uint32_t *remote = (uint32_t *)snrt_remote_l1_ptr(local, snrt_cluster_idx(),
                                                      remote_cluster_idx);

    const uint32_t sizes[] = {1, 2, 4, 8, 16, 32, 64, 128, 256};

    // -----------------------------------------------------------------------
    // local L1 -> remote L1
    // -----------------------------------------------------------------------
    for (uint32_t s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
        uint32_t n = sizes[s];

        for (uint32_t i = 0; i < n; i++) {
            local[i] = 0xC0DE0000u | i;
            remote[i] = 0xDEAD0000u | i;
        }
        snrt_fence();

        snrt_dma_start_1d(remote, local, n * sizeof(uint32_t), 0);
        snrt_dma_wait_all(0);

        for (uint32_t i = 0; i < n; i++)
            errors += (remote[i] != (0xC0DE0000u | i));
    }

    // -----------------------------------------------------------------------
    // remote L1 -> local L1
    // -----------------------------------------------------------------------
    for (uint32_t s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
        uint32_t n = sizes[s];

        for (uint32_t i = 0; i < n; i++) {
            remote[i] = 0xABCD0000u | i;
            local[i] = 0xDEAD0000u | i;
        }
        snrt_fence();

        snrt_dma_start_1d(local, remote, n * sizeof(uint32_t), 0);
        snrt_dma_wait_all(0);

        for (uint32_t i = 0; i < n; i++)
            errors += (local[i] != (0xABCD0000u | i));
    }

    return errors;
#endif
}
