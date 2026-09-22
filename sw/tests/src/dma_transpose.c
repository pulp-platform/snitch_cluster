// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// DMOPC on-the-fly transpose (0x50); requires a cfg with dma_enable_compute.
//
// Geometry, derived from idma_otf_transpose.sv and idma_transpose_midend.sv:
//  - The element size is 1 << mode bytes and the engine works on NE x NE
//    element tiles, NE = beat bytes / element bytes.
//  - ComputeTransposeShape accepts one whole padded tile in a single burst
//    (length == NE beats, M and N <= NE) to a beat-aligned destination, so the
//    source rows sit at a beat pitch and one 1D transfer carries the tile.
//  - The engine reads the full tile and masks the padding with its output
//    strobe, so no byte outside the TP_N x TP_M result may be written.
//
// Source and result: NE rows of NE elements, row pitch NE.
//         out[c][r] == in[r][c] for r < TP_M, c < TP_N; every other element
//         must still hold the poison value.

#include <snrt.h>

// Deliberately not square: a frontend that swapped tensor_m and tensor_n would
// mask a 8x4 result instead of a 4x8 one and fail the poison check.
#define TP_M 4
#define TP_N 8

/// Transpose one TP_M x TP_N tile of `T` elements and check every result byte.
template <typename T>
static uint32_t run_transpose(uint32_t mode) {
    const uint32_t ne = SNRT_DMA_BYTES_PER_BEAT / sizeof(T);
    const size_t elems = (size_t)ne * ne;
    const T poison = (T)0xA5A5A5A5u;

    volatile T *src = (volatile T *)snrt_l1_alloc_cluster_local(
        elems * sizeof(T), SNRT_DMA_BYTES_PER_BEAT);
    volatile T *dst = (volatile T *)snrt_l1_alloc_cluster_local(
        elems * sizeof(T), SNRT_DMA_BYTES_PER_BEAT);

    // in[r][c] = r * 100 + c: every element is recoverable from its position,
    // and the transpose of this matrix is nowhere equal to the matrix itself.
    for (size_t i = 0; i < elems; i++) src[i] = poison;
    for (uint32_t r = 0; r < ne; r++)
        for (uint32_t c = 0; c < TP_N; c++) src[r * ne + c] = (T)(r * 100 + c);
    for (size_t i = 0; i < elems; i++) dst[i] = poison;

    snrt_dma_set_transpose(mode, TP_M, TP_N);
    uint32_t c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)dst, (volatile void *)src,
                      (size_t)ne * SNRT_DMA_BYTES_PER_BEAT);
    snrt_dma_wait_all();
    uint32_t c1 = snrt_mcycle();
    snrt_dma_clear_opcode();

    uint32_t errors = 0;
    uint32_t differ = 0;
    for (uint32_t c = 0; c < ne; c++) {
        for (uint32_t r = 0; r < ne; r++) {
            T got = dst[c * ne + r];
            T exp = (c < TP_N && r < TP_M) ? src[r * ne + c] : poison;
            if (got != exp) {
                if (errors < 8)
                    printf("[dma_transpose] out[%u][%u]: exp %u got %u\n", c, r,
                           (unsigned)exp, (unsigned)got);
                errors++;
            }
            // A plain copy would leave src[c * ne + r], i.e. c * 100 + r
            if (c < TP_N && r < TP_M && got != src[c * ne + r]) differ++;
        }
    }

    // r * 100 + c differs from c * 100 + r everywhere but the diagonal.
    const uint32_t exp_differ = TP_M * TP_N - TP_M;
    if (differ != exp_differ) {
        printf(
            "[dma_transpose] %u of %u elements differ from a plain copy, "
            "expected %u\n",
            differ, TP_M * TP_N, exp_differ);
        errors++;
    }

    printf(
        "[dma_transpose] mode %u (%u B elems, %ux%u tile): %ux%u -> %ux%u, %u "
        "cycles, %s\n",
        mode, (unsigned)sizeof(T), ne, ne, TP_M, TP_N, TP_N, TP_M, c1 - c0,
        errors ? "FAIL" : "ok");
    return errors;
}

int main() {
    if (!snrt_is_dm_core()) {
        snrt_cluster_hw_barrier();
        return 0;
    }

    // Two cases, one per DMOPC operand: the element-size mode rides rs1, the
    // tensor dimensions ride rs2.
    uint32_t errors = run_transpose<uint32_t>(2);
    errors += run_transpose<uint16_t>(1);

    printf("[dma_transpose] %s (%u errors)\n", errors ? "FAIL" : "PASS",
           errors);

    snrt_cluster_hw_barrier();
    return errors ? 1 : 0;
}
