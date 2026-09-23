// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// DMOPC MX quant/dequant round trip; needs dma_enable_compute in the cluster
// cfg. FP32 or FP16 in L3 -> 33 B/block MXFP8 in L1 -> back to FP32 or FP16.
// The inputs are exactly representable in E5M2 under the common block scale,
// so the round trip must reproduce the original bit patterns exactly.

#include <snrt.h>

// Dequant input is 33 B/block, so the block count must be a multiple of the
// beat width in bytes: 64 blocks at 512 bit, 128 blocks at 1024 bit.
#define NUM_BLOCKS SNRT_DMA_BYTES_PER_BEAT
#define BLOCK_ELEMS 32
#define NUM_ELEMS (NUM_BLOCKS * BLOCK_ELEMS)
#define MX_BYTES (NUM_BLOCKS * 33)
#define MX_BYTES_PADDED ((MX_BYTES + 63) & ~63u)

// Quantize NUM_ELEMS elements of T from L3 into `mx`, dequantize back into L1
// and compare. `exp_bias` and `mant_shift` place the exponent and the top two
// mantissa bits of T, so both formats get the same 1.m * 2^e values.
template <typename T>
static uint32_t run_roundtrip(const char *name, uint32_t quant_op,
                              uint32_t dequant_op, uint32_t exp_bias,
                              uint32_t mant_shift, volatile uint8_t *mx) {
    const size_t bytes = (size_t)NUM_ELEMS * sizeof(T);

    T *l3 = (T *)snrt_l3_alloc_v2(bytes, 128);
    volatile T *src = (volatile T *)snrt_l1_alloc_cluster_local(bytes, 128);
    volatile T *out = (volatile T *)snrt_l1_alloc_cluster_local(bytes, 128);

    // 1.m * 2^e with m in {0,.25,.5,.75} and e in 0..7: exact in E5M2
    for (size_t i = 0; i < NUM_ELEMS; i++) {
        uint32_t m = i % 4, e = (i / 4) % 8;
        src[i] = (T)(((exp_bias + e) << (mant_shift + 2)) | (m << mant_shift));
    }
    for (size_t i = 0; i < MX_BYTES_PADDED; i++) mx[i] = 0;
    for (size_t i = 0; i < NUM_ELEMS; i++) out[i] = 0;

    // Stage the source to L3
    snrt_dma_set_opcode(SNRT_DMA_OPCODE_PASSTHROUGH);
    snrt_dma_start_1d((volatile void *)l3, (volatile void *)src, bytes);
    snrt_dma_wait_all();

    snrt_dma_set_opcode(quant_op);
    uint32_t c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)mx, (volatile void *)l3, bytes);
    snrt_dma_wait_all();
    uint32_t quant_cycles = snrt_mcycle() - c0;

    snrt_dma_set_opcode(dequant_op);
    c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)out, (volatile void *)mx, MX_BYTES);
    snrt_dma_wait_all();
    uint32_t dequant_cycles = snrt_mcycle() - c0;

    uint32_t errors = 0;
    for (size_t i = 0; i < NUM_ELEMS; i++) {
        if (out[i] != src[i]) {
            if (errors < 8)
                printf("%s mismatch at %u: exp %x got %x\n", name, (unsigned)i,
                       (unsigned)src[i], (unsigned)out[i]);
            errors++;
        }
    }

    printf("%s: quant %u B -> %u B in %u cycles, dequant back in %u, %s\n",
           name, (unsigned)bytes, (unsigned)MX_BYTES, quant_cycles,
           dequant_cycles, errors ? "FAIL" : "ok");
    return errors;
}

int main() {
    if (!snrt_is_dm_core()) {
        snrt_cluster_hw_barrier();
        return 0;
    }

    volatile uint8_t *mx =
        (volatile uint8_t *)snrt_l1_alloc_cluster_local(MX_BYTES_PADDED, 128);

    uint32_t errors =
        run_roundtrip<uint32_t>("fp32", SNRT_DMA_OPCODE_MX_QUANT,
                                SNRT_DMA_OPCODE_MX_DEQUANT, 127u, 21u, mx);

#if SNRT_DMA_BYTES_PER_BEAT <= 64
    // The FP16 element format exists on buses up to 512 bit
    errors +=
        run_roundtrip<uint16_t>("fp16", SNRT_DMA_OPCODE_MX_QUANT_FP16,
                                SNRT_DMA_OPCODE_MX_DEQUANT_FP16, 15u, 8u, mx);
#endif

    snrt_dma_set_opcode(SNRT_DMA_OPCODE_PASSTHROUGH);

    printf("[dma_mxquant] %s (%u errors)\n", errors ? "FAIL" : "PASS", errors);

    snrt_cluster_hw_barrier();
    return errors ? 1 : 0;
}
