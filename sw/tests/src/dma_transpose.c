// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// DMOPC on-the-fly transpose into local TCDM; needs dma_enable_compute in the
// cluster cfg. One transfer carries one padded NE x NE tile, NE = beat bytes /
// element bytes; idma_otf_transpose.sv holds the shape contract.

#include <snrt.h>

// Deliberately not square, so a swapped tensor_m/tensor_n fails the poison check
#define TP_M 4
#define TP_N 8

#ifdef SNRT_SUPPORTS_DMA_COMPUTE

// Transpose one TP_M x TP_N tile of T elements and check every result element
template <typename T>
static uint32_t run_transpose(uint32_t mode) {
    const uint32_t ne = SNRT_DMA_BYTES_PER_BEAT / sizeof(T);
    const size_t elems = (size_t)ne * ne;
    const T poison = (T)0xA5A5A5A5u;

    volatile T *src = (volatile T *)snrt_l1_alloc_cluster_local(
        elems * sizeof(T), SNRT_DMA_BYTES_PER_BEAT);
    volatile T *dst = (volatile T *)snrt_l1_alloc_cluster_local(
        elems * sizeof(T), SNRT_DMA_BYTES_PER_BEAT);

    // Position-coded: in[r][c] = r * 100 + c is nowhere equal to its transpose
    for (size_t i = 0; i < elems; i++) src[i] = poison;
    for (uint32_t r = 0; r < ne; r++)
        for (uint32_t c = 0; c < TP_N; c++) src[r * ne + c] = (T)(r * 100 + c);
    for (size_t i = 0; i < elems; i++) dst[i] = poison;

    uint32_t c0 = snrt_mcycle();
    snrt_dma_start_1d_transpose((volatile void *)dst, (volatile void *)src,
                                (size_t)ne * SNRT_DMA_BYTES_PER_BEAT, mode,
                                TP_M, TP_N);
    snrt_dma_wait_all();
    uint32_t cycles = snrt_mcycle() - c0;

    uint32_t errors = 0, differ = 0;
    for (uint32_t c = 0; c < ne; c++) {
        for (uint32_t r = 0; r < ne; r++) {
            T got = dst[c * ne + r];
            T exp = (c < TP_N && r < TP_M) ? src[r * ne + c] : poison;
            if (got != exp) {
                if (errors < 8)
                    printf("out[%u][%u]: exp %u got %u\n", c, r, (unsigned)exp,
                           (unsigned)got);
                errors++;
            }
            // A plain copy would leave src[c][r], i.e. c * 100 + r
            if (c < TP_N && r < TP_M && got != src[c * ne + r]) differ++;
        }
    }

    // Catches a DMOPC that never latched: passthrough leaves differ == 0
    if (differ != TP_M * TP_N - TP_M) {
        printf("%u of %u tile elements differ from a plain copy\n", differ,
               TP_M * TP_N);
        errors++;
    }

    printf("mode %u (%u B elems): %ux%u -> %ux%u, %u cycles, %s\n", mode,
           (unsigned)sizeof(T), TP_M, TP_N, TP_N, TP_M, cycles,
           errors ? "FAIL" : "ok");
    return errors;
}

#endif

int main() {
#ifdef SNRT_SUPPORTS_DMA_COMPUTE
    if (!snrt_is_dm_core()) {
        snrt_cluster_hw_barrier();
        return 0;
    }

    // One case per DMOPC operand: the mode rides rs1, the dimensions rs2
    uint32_t errors = run_transpose<uint32_t>(2);
    errors += run_transpose<uint16_t>(1);

    printf("[dma_transpose] %s (%u errors)\n", errors ? "FAIL" : "PASS",
           errors);

    snrt_cluster_hw_barrier();
    return errors ? 1 : 0;
#endif
}
