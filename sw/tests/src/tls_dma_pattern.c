// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This test reproduces the exact DMA traffic pattern emitted by snrt_init_tls()
// when the program has a large .tdata section.

#include <snrt.h>
#include <stdint.h>
#include <string.h>

// Parameters are tuned on the exp kernel case.
#define TDATA_BYTES 536
#define TBSS_BYTES 72
#define TLS_SLOT 1032  // (1 << SNRT_LOG2_STACK_SIZE) + 8
#define N_COPIES 8     // snrt_cluster_core_num() - 1

// A fake L3 source: static array placed in BSS (0x80000000+).
static uint8_t l3_src[TDATA_BYTES];

int main() {
#ifdef SNRT_SUPPORTS_DMA
    if (!snrt_is_dm_core()) return 0;

    uint32_t errors = 0;

    // Allocate one big TCDM region: slot 0 is the "DM core TLS", slots 1..8
    // are the "other cores' TLS", matching the layout in snrt_init_tls().
    uint8_t *tcdm = (uint8_t *)snrt_l1_alloc((N_COPIES + 1) * TLS_SLOT);

    // Fill the fake L3 source with a known pattern.
    for (uint32_t i = 0; i < TDATA_BYTES; i++) l3_src[i] = (uint8_t)(0xAB ^ i);
    snrt_fence();

    // L3 -> TCDM[0].
    snrt_dma_start_1d(tcdm, l3_src, TDATA_BYTES, 0);
    snrt_dma_wait_all(0);

    // Queue N_COPIES TCDM->TCDM transfers without intermediate waits.
    for (uint32_t i = 1; i <= N_COPIES; i++)
        snrt_dma_start_1d(tcdm + i * TLS_SLOT, tcdm, TDATA_BYTES, 0);

    // CPU core-stores to the .tbss region of each slot
    for (uint32_t i = 0; i <= N_COPIES; i++)
        memset(tcdm + i * TLS_SLOT + TDATA_BYTES, 0, TBSS_BYTES);

    // Wait for all queued transfers.
    snrt_dma_wait_all(0);

    // Verify every slot received the correct .tdata pattern.
    for (uint32_t slot = 0; slot <= N_COPIES; slot++) {
        uint8_t *base = tcdm + slot * TLS_SLOT;
        for (uint32_t i = 0; i < TDATA_BYTES; i++)
            errors += (base[i] != (uint8_t)(0xAB ^ i));
        // .tbss must be zero.
        for (uint32_t i = 0; i < TBSS_BYTES; i++)
            errors += (base[TDATA_BYTES + i] != 0);
    }

    return errors;
#endif
}
