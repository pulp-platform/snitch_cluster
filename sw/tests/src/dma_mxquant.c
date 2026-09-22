// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// DMOPC MX quant/dequant round trip; requires a cfg with dma_enable_compute.
//  1. MX quant (0x20): FP32 (L3) -> 33 B/block MXFP8 (L1).
//  2. MX dequant (0x21): MXFP8 (L1) -> FP32 (L1).
// The inputs are exactly representable in E5M2 under the common block scale,
// so the round trip must reproduce the original bit patterns exactly.
// Alignment: quant length a multiple of 128 B, dequant input a whole number
// of bus beats, all addresses beat-aligned.

#include <snrt.h>

// Dequant input is 33 B/block, so the block count must be a multiple of the
// beat width in bytes: 64 blocks at 512 bit, 128 blocks at 1024 bit.
#define NUM_BLOCKS SNRT_DMA_BYTES_PER_BEAT
#define BLOCK_ELEMS 32
#define NUM_ELEMS (NUM_BLOCKS * BLOCK_ELEMS)
#define SRC_BYTES (NUM_ELEMS * 4)
#define MX_BYTES (NUM_BLOCKS * 33)
#define MX_BYTES_PADDED ((MX_BYTES + 63) & ~63u)

int main() {
    if (!snrt_is_dm_core()) {
        snrt_cluster_hw_barrier();
        return 0;
    }

    uint32_t *l3_src = (uint32_t *)snrt_l3_alloc_v2(SRC_BYTES, 128);
    volatile uint8_t *l1_mx =
        (volatile uint8_t *)snrt_l1_alloc_cluster_local(MX_BYTES_PADDED, 128);
    volatile uint32_t *l1_out =
        (volatile uint32_t *)snrt_l1_alloc_cluster_local(SRC_BYTES, 128);
    volatile uint32_t *l1_src =
        (volatile uint32_t *)snrt_l1_alloc_cluster_local(SRC_BYTES, 128);

    // 1.m * 2^e with m in {0,.25,.5,.75} and e in 0..7: exact in E5M2
    for (size_t i = 0; i < NUM_ELEMS; i++) {
        uint32_t m = i % 4;
        uint32_t e = (i / 4) % 8;
        l1_src[i] = ((127u + e) << 23) | (m << 21);
    }
    for (size_t i = 0; i < MX_BYTES_PADDED; i++) l1_mx[i] = 0;
    for (size_t i = 0; i < NUM_ELEMS; i++) l1_out[i] = 0;

    // Stage the FP32 source to L3
    snrt_dma_set_opcode(SNRT_DMA_OPCODE_PASSTHROUGH);
    snrt_dma_start_1d((volatile void *)l3_src, (volatile void *)l1_src,
                      SRC_BYTES);
    snrt_dma_wait_all();

    // 1: quant L3 FP32 -> L1 MXFP8
    snrt_dma_set_opcode(SNRT_DMA_OPCODE_MX_QUANT);
    uint32_t c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)l1_mx, (volatile void *)l3_src,
                      SRC_BYTES);
    snrt_dma_wait_all();
    uint32_t c1 = snrt_mcycle();
    printf("[dma_mxquant] quant %d B -> %d B: %d cycles\n", SRC_BYTES, MX_BYTES,
           c1 - c0);

    // 2: dequant L1 MXFP8 -> L1 FP32
    snrt_dma_set_opcode(SNRT_DMA_OPCODE_MX_DEQUANT);
    c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)l1_out, (volatile void *)l1_mx,
                      MX_BYTES);
    snrt_dma_wait_all();
    c1 = snrt_mcycle();
    printf("[dma_mxquant] dequant %d B -> %d B: %d cycles\n", MX_BYTES,
           SRC_BYTES, c1 - c0);

    // The round trip must be bit-exact for these values
    uint32_t errors = 0;
    for (size_t i = 0; i < NUM_ELEMS; i++) {
        if (l1_out[i] != l1_src[i]) {
            if (errors < 8) {
                printf("[dma_mxquant] mismatch at %d: exp %x got %x\n", (int)i,
                       (unsigned)l1_src[i], (unsigned)l1_out[i]);
            }
            errors++;
        }
    }
    printf("[dma_mxquant] fp32 %s (%u errors)\n", errors ? "FAIL" : "ok",
           errors);

#if SNRT_DMA_BYTES_PER_BEAT <= 64
    // FP16 element format (0x22 quant / 0x23 dequant), buses up to 512 bit
    volatile uint16_t *l1_src16 =
        (volatile uint16_t *)snrt_l1_alloc_cluster_local(NUM_ELEMS * 2, 128);
    volatile uint16_t *l1_out16 =
        (volatile uint16_t *)snrt_l1_alloc_cluster_local(NUM_ELEMS * 2, 128);
    uint16_t *l3_src16 = (uint16_t *)snrt_l3_alloc_v2(NUM_ELEMS * 2, 128);

    for (size_t i = 0; i < NUM_ELEMS; i++) {
        uint32_t m = i % 4;
        uint32_t e = (i / 4) % 8;
        l1_src16[i] = (uint16_t)(((15u + e) << 10) | (m << 8));
    }
    for (size_t i = 0; i < MX_BYTES_PADDED; i++) l1_mx[i] = 0;
    for (size_t i = 0; i < NUM_ELEMS; i++) l1_out16[i] = 0;

    snrt_dma_set_opcode(SNRT_DMA_OPCODE_PASSTHROUGH);
    snrt_dma_start_1d((volatile void *)l3_src16, (volatile void *)l1_src16,
                      NUM_ELEMS * 2);
    snrt_dma_wait_all();

    snrt_dma_set_opcode(SNRT_DMA_OPCODE_MX_QUANT_FP16);
    c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)l1_mx, (volatile void *)l3_src16,
                      NUM_ELEMS * 2);
    snrt_dma_wait_all();
    c1 = snrt_mcycle();
    printf("[dma_mxquant] fp16 quant %d B -> %d B: %d cycles\n", NUM_ELEMS * 2,
           MX_BYTES, c1 - c0);

    snrt_dma_set_opcode(SNRT_DMA_OPCODE_MX_DEQUANT_FP16);
    c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)l1_out16, (volatile void *)l1_mx,
                      MX_BYTES);
    snrt_dma_wait_all();
    c1 = snrt_mcycle();
    printf("[dma_mxquant] fp16 dequant %d B -> %d B: %d cycles\n", MX_BYTES,
           NUM_ELEMS * 2, c1 - c0);

    uint32_t errors16 = 0;
    for (size_t i = 0; i < NUM_ELEMS; i++) {
        if (l1_out16[i] != l1_src16[i]) {
            if (errors16 < 8) {
                printf("[dma_mxquant] fp16 mismatch at %d: exp %x got %x\n",
                       (int)i, (unsigned)l1_src16[i], (unsigned)l1_out16[i]);
            }
            errors16++;
        }
    }
    printf("[dma_mxquant] fp16 %s (%u errors)\n", errors16 ? "FAIL" : "ok",
           errors16);
    errors += errors16;
#endif

    snrt_dma_set_opcode(SNRT_DMA_OPCODE_PASSTHROUGH);

    snrt_cluster_hw_barrier();
    return errors ? 1 : 0;
}
