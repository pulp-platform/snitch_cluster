// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// DMOPC MX quant/dequant round trip; needs dma_enable_compute in the cluster
// cfg. FP32 or FP16 in L3 -> MXFP8 data plane + E8M0 scale plane in L1 ->
// back to FP32 or FP16. The inputs are exact in E5M2 and E4M3 under their
// block scale, so the round trip must reproduce the original bit patterns.

#include <snrt.h>

#define BLOCK_ELEMS 32
#define MX_DATA_BLOCK_BYTES 32
#define MX_SCALE_LINE 64
#define MX_ELEM_E5M2 0
#define MX_ELEM_E4M3 1
#define MX_GROUP_G64 0
#define MX_GROUP_G32 1
#define SCALE_SENTINEL 0xA5

#ifdef SNRT_SUPPORTS_DMA_COMPUTE

// Block b holds +-1.m * 2^(e + b % 8 - 4), m in {0,.25,.5,.75}, e in 0..7
static inline uint32_t stim_exp(size_t i) {
    return (i / 4) % 8 + (i / BLOCK_ELEMS) % 8;
}

static inline uint8_t expected_scale(size_t blk, uint32_t elem_fmt) {
    // floor(log2(amax)) - emax: (3 + b % 8) - (15 E5M2, 8 E4M3), biased by 127
    return (uint8_t)(127 + 3 + blk % 8 - (elem_fmt == MX_ELEM_E4M3 ? 8 : 15));
}

static uint32_t mx_copy(volatile void *dst, volatile void *src, size_t size,
                        size_t dst_stride, size_t src_stride, size_t rows) {
    if (rows == 1) return snrt_dma_start_1d(dst, src, size);
    return snrt_dma_start_2d(dst, src, size, dst_stride, src_stride, rows);
}

// Quantize `rows` rows of `row_blocks` blocks of T from L3, each row's scale
// bytes on their own 64 B line, dequantize back into L1 and compare.
// `exp_bias` and `mant_shift` place the exponent and top two mantissa bits.
template <typename T>
static uint32_t run_roundtrip(uint32_t quant_op, uint32_t dequant_op,
                              uint32_t elem_fmt, uint32_t group,
                              uint32_t exp_bias, uint32_t mant_shift,
                              uint32_t rows, uint32_t row_blocks) {
    const size_t row_elems = (size_t)row_blocks * BLOCK_ELEMS;
    const size_t row_bytes = row_elems * sizeof(T);
    const size_t row_data = (size_t)row_blocks * MX_DATA_BLOCK_BYTES;
    const size_t scale_stride =
        (row_blocks + MX_SCALE_LINE - 1) / MX_SCALE_LINE * MX_SCALE_LINE;
    const size_t elems = rows * row_elems;

    T *l3 = (T *)snrt_l3_alloc_v2(rows * row_bytes, 128);
    volatile T *src =
        (volatile T *)snrt_l1_alloc_cluster_local(rows * row_bytes, 128);
    volatile T *out =
        (volatile T *)snrt_l1_alloc_cluster_local(rows * row_bytes, 128);
    volatile uint8_t *data =
        (volatile uint8_t *)snrt_l1_alloc_cluster_local(rows * row_data, 128);
    volatile uint8_t *scale = (volatile uint8_t *)snrt_l1_alloc_cluster_local(
        rows * scale_stride, MX_SCALE_LINE);

    for (size_t i = 0; i < elems; i++) {
        uint32_t sign = (i / BLOCK_ELEMS) & 1u;
        src[i] = (T)((sign << (sizeof(T) * 8 - 1)) |
                     ((exp_bias - 4 + stim_exp(i)) << (mant_shift + 2)) |
                     ((i % 4) << mant_shift));
    }
    for (size_t i = 0; i < rows * row_data; i++) data[i] = 0;
    for (size_t i = 0; i < rows * scale_stride; i++) scale[i] = SCALE_SENTINEL;
    for (size_t i = 0; i < elems; i++) out[i] = 0;

    // Stage the source to L3
    snrt_dma_disable_compute();
    snrt_dma_start_1d((volatile void *)l3, (volatile void *)src,
                      rows * row_bytes);
    snrt_dma_wait_all();

    const uint32_t mx_opts = (elem_fmt << IDMA_DMOPC_RS1_MX_ELEM_FMT_SHIFT) |
                             (group << IDMA_DMOPC_RS1_MX_GROUP_SHIFT);
    snrt_dma_set_mx_scale_addr((uint32_t)scale);
    snrt_dma_set_mx_scale_stride(scale_stride);

    // A refused MX launch returns id 0
    uint32_t errors = 0;
    snrt_dma_set_opcode(quant_op | mx_opts);
    if (!mx_copy(data, l3, row_bytes, row_data, row_bytes, rows)) errors++;
    snrt_dma_wait_all();

    snrt_dma_set_opcode(dequant_op | mx_opts);
    if (!mx_copy(out, data, row_data, row_bytes, row_data, rows)) errors++;
    snrt_dma_wait_all();

    // Each row's scale bytes start on their own line; the rest stays intact
    for (size_t r = 0; r < rows; r++)
        for (size_t k = 0; k < scale_stride; k++) {
            uint8_t exp = k < row_blocks
                              ? expected_scale(r * row_blocks + k, elem_fmt)
                              : SCALE_SENTINEL;
            if (scale[r * scale_stride + k] != exp) errors++;
        }
    for (size_t i = 0; i < elems; i++)
        if (out[i] != src[i]) errors++;
    return errors;
}

#endif

int main() {
#ifdef SNRT_SUPPORTS_DMA_COMPUTE
    if (!snrt_is_dm_core()) {
        snrt_cluster_hw_barrier();
        return 0;
    }

    // 1D, two scale groups, the second partial
    uint32_t errors = run_roundtrip<uint32_t>(
        IDMA_DMOPC_OPC_MX_QUANT, IDMA_DMOPC_OPC_MX_DEQUANT, MX_ELEM_E5M2,
        MX_GROUP_G64, 127u, 21u, 1, 96);

    // 2D, scale plane stepped by the scale stride
    errors += run_roundtrip<uint16_t>(
        IDMA_DMOPC_OPC_MX_QUANT_FP16, IDMA_DMOPC_OPC_MX_DEQUANT_FP16,
        MX_ELEM_E4M3, MX_GROUP_G32, 15u, 8u, 2, 48);

    snrt_dma_disable_compute();

    snrt_cluster_hw_barrier();
    return errors ? 1 : 0;
#endif
}
