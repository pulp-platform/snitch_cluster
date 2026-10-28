// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef PACE_SOFTMAX_H
#define PACE_SOFTMAX_H

#include <stdint.h>

#include "data.h"
#include "pace_elementwise.h"
#include "snrt.h"

#define INPUTS_LEN (Q_SIZE * K_SIZE)
#define OUTPUTS_LEN (Q_SIZE * K_SIZE)
#define FP32_NEG_INF_BITS 0xFF800000u
#define FP32_ZERO_BITS 0x00000000u
#define FP16_NEG_INF_BITS 0xFC00u
#define FP16_ZERO_BITS 0x0000u
#define FP16X4_NEG_INF_BITS 0xFC00FC00FC00FC00ULL
#define FP16X4_ZERO_BITS 0x0000000000000000ULL

#if defined(ENABLE_FP32)
#define PACE_NEG_INF_BITS FP32_NEG_INF_BITS
#define PACE_ZERO_BITS FP32_ZERO_BITS
typedef uint32_t raw_data_t;
#elif defined(ENABLE_FP16)
#define PACE_NEG_INF_BITS FP16_NEG_INF_BITS
#define PACE_ZERO_BITS FP16_ZERO_BITS
typedef uint16_t raw_data_t;
#else
#error "Unsupported precision configuration"
#endif

#if FPU_DATA_WIDTH == 64
#define PACE_SSR_STRIDE sizeof(double)
#elif FPU_DATA_WIDTH == 32
#define PACE_SSR_STRIDE sizeof(float)
#else
#error "Unsupported FPU_DATA_WIDTH configuration"
#endif

#if (PACE_LANES != 1) && (PACE_LANES != 2) && (PACE_LANES != 4)
#error "Unsupported PACE_LANES configuration"
#endif

#if (SOFTMAX_UNROLL != 3) && (SOFTMAX_UNROLL != 4) && (SOFTMAX_UNROLL != 8)
#error "SOFTMAX_UNROLL must be 3, 4 or 8"
#endif

#if defined(ENABLE_FP16) && (PACE_LANES == 4) && (FPU_DATA_WIDTH == 64) && \
    PACE_LAYOUT_COLUMN_MAJOR
#define PACE_ROW_INTERLEAVED 1
#define PACE_XMAX_ITERS (K_SIZE / 4)
#define PACE_EXP_ITERS (K_SIZE / SOFTMAX_UNROLL)
#define PACE_VEC_ITERS K_SIZE
#else
#define PACE_ROW_INTERLEAVED 0
#define PACE_XMAX_ITERS (K_SIZE / (4 * PACE_LANES))
#define PACE_EXP_ITERS (K_SIZE / (SOFTMAX_UNROLL * PACE_LANES))
#define PACE_VEC_ITERS (K_SIZE / PACE_LANES)
#endif

#if defined(ENABLE_FP16) && (PACE_LANES == 4) && (FPU_DATA_WIDTH == 64) && \
    !PACE_LAYOUT_COLUMN_MAJOR
#error "FP16x4 softmax currently requires column-major layout"
#endif

#if (K_SIZE % (4 * PACE_LANES)) != 0
#error "K_SIZE must be divisible by 4 * PACE_LANES"
#endif

#if PACE_ROW_INTERLEAVED
#if (K_SIZE % SOFTMAX_UNROLL) != 0
#error "K_SIZE must be divisible by SOFTMAX_UNROLL"
#endif
#else
#if (K_SIZE % (SOFTMAX_UNROLL * PACE_LANES)) != 0
#error "K_SIZE must be divisible by SOFTMAX_UNROLL * PACE_LANES"
#endif
#endif

typedef struct {
    uint32_t core_idx;
    uint32_t core_active;
    uint32_t row_start;
    uint32_t row_count;
    uint32_t input_offset;
    uint32_t denom_offset;
    uint32_t scratch_plane_size;
} pace_softmax_work_t;

typedef struct {
    raw_data_t *input_buf;
    raw_data_t *exp_buf;
    raw_data_t *softmax_buf;
    raw_data_t *denom_buf;
    raw_data_t *inv_denom_buf;
    raw_data_t *scratch_buf;
    raw_data_t *xmax_lane_buf;
    raw_data_t *denom_inv_src;
    raw_data_t *inv_mul_src;
    volatile raw_data_t *denom_write_ptr;
    volatile raw_data_t *denom_lane_buf;
    param_t *pace_mem;
} pace_softmax_buffers_t;

static inline int pace_softmax_init_work(pace_softmax_work_t *work) {
    const uint32_t runtime_compute_core_count = snrt_cluster_compute_core_num();
    const uint32_t core_idx = snrt_cluster_core_idx();
    const uint32_t active_compute_core_count = NUM_CORES;
    const uint32_t core_active =
        snrt_is_compute_core() && (core_idx < active_compute_core_count);

    if (runtime_compute_core_count < NUM_CORES) {
        if (core_idx == 0) {
            printf("pace_softmax core mismatch: runtime=%u configured=%u\n",
                   runtime_compute_core_count, NUM_CORES);
        }
        return 1;
    }

    const uint32_t work_items =
        PACE_ROW_INTERLEAVED ? (Q_SIZE / PACE_LANES) : Q_SIZE;
    const uint32_t rows_per_core = work_items / active_compute_core_count;
    const uint32_t extra_rows = work_items % active_compute_core_count;
    const uint32_t row_start = core_idx * rows_per_core +
                               (core_idx < extra_rows ? core_idx : extra_rows);
    const uint32_t row_count =
        core_active ? (rows_per_core + (core_idx < extra_rows ? 1u : 0u)) : 0u;
    const uint32_t input_span =
        PACE_ROW_INTERLEAVED ? (K_SIZE * PACE_LANES) : K_SIZE;

    work->core_idx = core_idx;
    work->core_active = core_active;
    work->row_start = row_start;
    work->row_count = row_count;
    work->input_offset = row_start * input_span;
    work->denom_offset = row_start * PACE_LANES;
    work->scratch_plane_size = active_compute_core_count * PACE_LANES;
    return 0;
}

static inline pace_softmax_buffers_t pace_softmax_init_buffers(
    const pace_softmax_work_t *work) {
    pace_softmax_buffers_t buffers;

    buffers.input_buf = (raw_data_t *)snrt_l1_next();
    buffers.exp_buf = buffers.input_buf + INPUTS_LEN;
    buffers.softmax_buf = buffers.exp_buf + OUTPUTS_LEN;
    buffers.denom_buf = buffers.softmax_buf + OUTPUTS_LEN;
    buffers.inv_denom_buf = buffers.denom_buf + DENO_LENGTH;
    buffers.scratch_buf = buffers.inv_denom_buf + DENO_LENGTH;
    buffers.xmax_lane_buf = buffers.scratch_buf + work->core_idx * PACE_LANES;
    buffers.denom_lane_buf = buffers.scratch_buf + work->scratch_plane_size +
                             work->core_idx * PACE_LANES;
    buffers.denom_write_ptr = buffers.denom_buf + work->denom_offset;
    buffers.denom_inv_src = buffers.denom_buf + work->denom_offset;
    buffers.inv_mul_src = buffers.inv_denom_buf + work->denom_offset;
    buffers.pace_mem = (param_t *)snrt_cluster()->pacemem.mem;
    return buffers;
}

static inline void pace_softmax_configure(const pace_softmax_work_t *work) {
    if (work->core_active) {
        asm volatile("csrw 0x7d2, %0" : : "rK"(PACE_DEGREE) : "memory");
        pace_configure_fmode();
    }
}

static inline void pace_softmax_load_exp_params_and_input(
    pace_softmax_buffers_t *buffers) {
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(buffers->pace_mem, exp_params,
                          EXP_PARAMS_LEN * sizeof(param_t));
        snrt_dma_wait_all();
        snrt_dma_start_1d(buffers->input_buf, &ifmap[0][0],
                          INPUTS_LEN * sizeof(raw_data_t));
        snrt_dma_wait_all();
    }
}

static inline void pace_softmax_load_inv_params(
    pace_softmax_buffers_t *buffers) {
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(buffers->pace_mem, inv_params,
                          INV_PARAMS_LEN * sizeof(param_t));
        snrt_dma_wait_all();
    }
}

static inline void pace_softmax_store_output(pace_softmax_buffers_t *buffers) {
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(&ofmap[0][0], buffers->softmax_buf,
                          OUTPUTS_LEN * sizeof(raw_data_t));
        snrt_dma_wait_all();
    }
}

static inline int pace_softmax_check_output(raw_data_t *actual,
                                            raw_data_t *expected, int len) {
    int errors = len;
    for (int i = 0; i < len; i++) {
        raw_data_t actual_data = actual[i];
        raw_data_t expected_data = expected[i];
        if (actual_data == expected_data) {
            errors--;
        } else {
            printf(
                "idx:%d, errors=%d, actual_data=%x, golden_data=%x, "
                "actual_ptr=%p, golden_ptr=%p\n",
                i, errors, actual_data, expected_data, &actual[i],
                &expected[i]);
        }
    }
    return errors;
}

#if PACE_ROW_INTERLEAVED
static inline void pace_softmax_xmax_fp16x4(raw_data_t *xmax_lane_buf,
                                            const uint64_t *neg_inf_vec) {
    __asm__ volatile(
        "fld ft3, 0(%[neg_inf])\n\t"
        "fmv.d ft4, ft3\n\t"
        "fmv.d ft5, ft3\n\t"
        "fmv.d ft6, ft3\n\t"
        "fmv.d ft7, ft3\n\t"
        "frep.o %[n], 4, 0, 0\n\t"
        "vfmax.h ft4, ft4, ft0\n\t"
        "vfmax.h ft5, ft5, ft0\n\t"
        "vfmax.h ft6, ft6, ft0\n\t"
        "vfmax.h ft7, ft7, ft0\n\t"
        "vfmax.h ft5, ft4, ft5\n\t"
        "vfmax.h ft6, ft6, ft7\n\t"
        "vfmax.h ft6, ft6, ft5\n\t"
        "fsd ft6, 0(%[max])\n\t"
        :
        : [ neg_inf ] "r"(neg_inf_vec), [ n ] "r"(PACE_XMAX_ITERS - 1),
          [ max ] "r"(xmax_lane_buf)
        : "ft3", "ft4", "ft5", "ft6", "ft7", "memory");
}

static inline void pace_softmax_exp_deno_fp16x4(raw_data_t *denom_lane_buf,
                                                raw_data_t *xmax_lane_buf,
                                                const uint64_t *zero_vec) {
    __asm__ volatile(
        "fld fs8, 0(%[zero])\n\t"
        "fmv.d fs9, fs8\n\t"
        "fmv.d fs10, fs8\n\t"
        "fmv.d fs11, fs8\n\t"
        "fld ft3, 0(%[xmax])\n\t"
        "frep.o %[n], 32, 0, 0\n\t"
        "vfsub.h ft4, ft1, ft3\n\t"
        "vfsub.h ft5, ft1, ft3\n\t"
        "vfsub.h ft6, ft1, ft3\n\t"
        "vfsub.h ft7, ft1, ft3\n\t"
        "vfsub.h fs0, ft1, ft3\n\t"
        "vfsub.h fs1, ft1, ft3\n\t"
        "vfsub.h fa0, ft1, ft3\n\t"
        "vfsub.h fa1, ft1, ft3\n\t"
        PACE_VPWPA_OP("ft4", "ft4", "ft0")
        PACE_VPWPA_OP("ft5", "ft5", "ft0")
        PACE_VPWPA_OP("ft6", "ft6", "ft0")
        PACE_VPWPA_OP("ft7", "ft7", "ft0")
        PACE_VPWPA_OP("fs0", "fs0", "ft0")
        PACE_VPWPA_OP("fs1", "fs1", "ft0")
        PACE_VPWPA_OP("fa0", "fa0", "ft0")
        PACE_VPWPA_OP("fa1", "fa1", "ft0")
        "fmv.d ft2, ft4\n\t"
        "fmv.d ft2, ft5\n\t"
        "fmv.d ft2, ft6\n\t"
        "fmv.d ft2, ft7\n\t"
        "fmv.d ft2, fs0\n\t"
        "fmv.d ft2, fs1\n\t"
        "fmv.d ft2, fa0\n\t"
        "fmv.d ft2, fa1\n\t"
        "vfadd.h fs4, ft5, ft4\n\t"
        "vfadd.h fs5, ft7, ft6\n\t"
        "vfadd.h fs6, fs1, fs0\n\t"
        "vfadd.h fs7, fa1, fa0\n\t"
        "vfadd.h fs8, fs8, fs4\n\t"
        "vfadd.h fs9, fs9, fs5\n\t"
        "vfadd.h fs10, fs10, fs6\n\t"
        "vfadd.h fs11, fs11, fs7\n\t"
        "vfadd.h fs8, fs9, fs8\n\t"
        "vfadd.h fs10, fs10, fs11\n\t"
        "vfadd.h fs8, fs10, fs8\n\t"
        "fsd fs8, 0(%[sum])\n\t"
        :
        : [zero] "r"(zero_vec), [n] "r"(PACE_EXP_ITERS - 1),
          [sum] "r"(denom_lane_buf), [xmax] "r"(xmax_lane_buf)
        : "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
          "fs0", "fs1", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9",
          "fs10", "fs11", "fa0", "fa1", "memory");
}

static inline void pace_softmax_store_deno_fp16x4(
    volatile raw_data_t **denom_write_ptr,
    volatile raw_data_t *denom_lane_buf) {
    __asm__ volatile(
        "fld ft3, 0(%[sum_src])\n\t"
        "fsd ft3, 0(%[sum_dst])\n\t"
        :
        : [ sum_src ] "r"(denom_lane_buf), [ sum_dst ] "r"(*denom_write_ptr)
        : "ft3", "memory");
    *denom_write_ptr += PACE_LANES;
}
#endif

static inline void pace_softmax_compute_xmax(raw_data_t *xmax_lane_buf) {
#if defined(ENABLE_FP16) && (PACE_LANES == 4)
    const uint64_t fp16x4_neg_inf = FP16X4_NEG_INF_BITS;
    pace_softmax_xmax_fp16x4(xmax_lane_buf, &fp16x4_neg_inf);
#elif PACE_LANES == 2
    __asm__ volatile(
        "fmv.s.x ft3, %[neg_inf]\n"
        "fmv.s.x ft4, %[neg_inf]\n"
        "vfcpka.s.s ft3, ft3, ft4\n"
        "fmv.d  ft4, ft3 \n\t"
        "fmv.d  ft5, ft3 \n\t"
        "fmv.d  ft6, ft3 \n\t"
        "fmv.d  ft7, ft3 \n\t"
        "frep.o  %[n], 4, 0, 0\n\t"
        "vfmax.s  ft4, ft4, ft0\n\t"
        "vfmax.s  ft5, ft5, ft0\n\t"
        "vfmax.s  ft6, ft6, ft0\n\t"
        "vfmax.s  ft7, ft7, ft0\n\t"
        "vfmax.s  ft5, ft4, ft5\n\t"
        "vfmax.s  ft6, ft6, ft7\n\t"
        "vfmax.s  ft6, ft6, ft5\n\t"
        "fsd ft6, 0(%[max]) \n\t"
        :
        : [ neg_inf ] "r"(PACE_NEG_INF_BITS), [ n ] "r"(PACE_XMAX_ITERS - 1),
          [ max ] "r"(xmax_lane_buf)
        : "ft3", "ft4", "ft5", "ft6", "ft7", "memory");
#else
    __asm__ volatile(
        "fmv.s.x ft4, %[neg_inf]\n"
        "fmv.s.x ft5, %[neg_inf]\n"
        "fmv.s.x ft6, %[neg_inf]\n"
        "fmv.s.x ft7, %[neg_inf]\n"
        "frep.o  %[n], 4, 0, 0\n\t"
        "vfmax.s  ft4, ft4, ft0\n\t"
        "vfmax.s  ft5, ft5, ft0\n\t"
        "vfmax.s  ft6, ft6, ft0\n\t"
        "vfmax.s  ft7, ft7, ft0\n\t"
        "fmax.s   ft5, ft4, ft5\n\t"
        "fmax.s   ft6, ft6, ft7\n\t"
        "fmax.s   ft3, ft6, ft5\n\t"
        "fsw ft3, 0(%[max]) \n\t"
        :
        : [ neg_inf ] "r"(PACE_NEG_INF_BITS), [ n ] "r"(PACE_XMAX_ITERS - 1),
          [ max ] "r"(xmax_lane_buf)
        : "ft3", "ft4", "ft5", "ft6", "ft7", "memory");
#endif
}

static inline void pace_softmax_exp_denom(raw_data_t *denom_lane_buf,
                                          raw_data_t *xmax_lane_buf) {
#if defined(ENABLE_FP16) && (PACE_LANES == 4)
    const uint64_t fp16x4_zero = FP16X4_ZERO_BITS;
    pace_softmax_exp_deno_fp16x4(denom_lane_buf, xmax_lane_buf, &fp16x4_zero);
#elif PACE_LANES == 2
    __asm__ volatile(
        "fmv.s.x fs8, %[zero]\n"
        "fmv.s.x fs9, %[zero]\n"
        "vfcpka.s.s fs8, fs9, fs8\n"
        "fmv.d  fs9, fs8 \n\t"
        "fmv.d  fs10, fs8 \n\t"
        "fmv.d  fs11, fs8 \n\t"
        "flw ft3, 0(%[xmax])\n\t"
        "flw ft4, 4(%[xmax])\n\t"
        "fmax.s ft4, ft3, ft4\n\t"
        "vfcpka.s.s ft3, ft4, ft4\n\t"
        "frep.o  %[n], 32, 0, 0\n\t"
        "vfsub.s  ft4, ft1, ft3\n\t"
        "vfsub.s  ft5, ft1, ft3\n\t"
        "vfsub.s  ft6, ft1, ft3\n\t"
        "vfsub.s  ft7, ft1, ft3\n\t"
        "vfsub.s  fs0, ft1, ft3\n\t"
        "vfsub.s  fs1, ft1, ft3\n\t"
        "vfsub.s  fa0, ft1, ft3\n\t"
        "vfsub.s  fa1, ft1, ft3\n\t"
        PACE_VPWPA_OP("ft4", "ft4", "ft0")
        PACE_VPWPA_OP("ft5", "ft5", "ft0")
        PACE_VPWPA_OP("ft6", "ft6", "ft0")
        PACE_VPWPA_OP("ft7", "ft7", "ft0")
        PACE_VPWPA_OP("fs0", "fs0", "ft0")
        PACE_VPWPA_OP("fs1", "fs1", "ft0")
        PACE_VPWPA_OP("fa0", "fa0", "ft0")
        PACE_VPWPA_OP("fa1", "fa1", "ft0")
        "fmv.d  ft2, ft4\n\t"
        "fmv.d  ft2, ft5\n\t"
        "fmv.d  ft2, ft6\n\t"
        "fmv.d  ft2, ft7\n\t"
        "fmv.d  ft2, fs0\n\t"
        "fmv.d  ft2, fs1\n\t"
        "fmv.d  ft2, fa0\n\t"
        "fmv.d  ft2, fa1\n\t"
        "vfadd.s  fs4, ft5, ft4\n\t"
        "vfadd.s  fs5, ft7, ft6\n\t"
        "vfadd.s  fs6, fs1, fs0\n\t"
        "vfadd.s  fs7, fa1, fa0\n\t"
        "vfadd.s  fs8, fs8, fs4\n\t"
        "vfadd.s  fs9, fs9, fs5\n\t"
        "vfadd.s  fs10, fs10, fs6\n\t"
        "vfadd.s  fs11, fs11, fs7\n\t"
        "vfadd.s  fs8, fs9, fs8\n\t"
        "vfadd.s  fs10, fs10, fs11\n\t"
        "vfadd.s  fs8, fs10, fs8\n\t"
        "fsd fs8, 0(%[sum]) \n\t"
        :
        : [zero] "r"(PACE_ZERO_BITS), [n] "r"(PACE_EXP_ITERS - 1),
          [sum] "r"(denom_lane_buf), [xmax] "r"(xmax_lane_buf)
        : "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
          "fs0", "fs1", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9",
          "fs10", "fs11", "fa0", "fa1", "memory");
#else
    __asm__ volatile(
        "fmv.s.x fs8, %[zero]\n"
        "fmv.s.x fs9, %[zero]\n"
        "fmv.s.x fs10, %[zero]\n"
        "fmv.s.x fs11, %[zero]\n"
        "flw ft3, 0(%[xmax])\n\t"
        "frep.o  %[n], 32, 0, 0\n\t"
        "vfsub.s  ft4, ft1, ft3\n\t"
        "vfsub.s  ft5, ft1, ft3\n\t"
        "vfsub.s  ft6, ft1, ft3\n\t"
        "vfsub.s  ft7, ft1, ft3\n\t"
        "vfsub.s  fs0, ft1, ft3\n\t"
        "vfsub.s  fs1, ft1, ft3\n\t"
        "vfsub.s  fa0, ft1, ft3\n\t"
        "vfsub.s  fa1, ft1, ft3\n\t"
        PACE_VPWPA_OP("ft4", "ft4", "ft0")
        PACE_VPWPA_OP("ft5", "ft5", "ft0")
        PACE_VPWPA_OP("ft6", "ft6", "ft0")
        PACE_VPWPA_OP("ft7", "ft7", "ft0")
        PACE_VPWPA_OP("fs0", "fs0", "ft0")
        PACE_VPWPA_OP("fs1", "fs1", "ft0")
        PACE_VPWPA_OP("fa0", "fa0", "ft0")
        PACE_VPWPA_OP("fa1", "fa1", "ft0")
        "fmv.s  ft2, ft4\n\t"
        "fmv.s  ft2, ft5\n\t"
        "fmv.s  ft2, ft6\n\t"
        "fmv.s  ft2, ft7\n\t"
        "fmv.s  ft2, fs0\n\t"
        "fmv.s  ft2, fs1\n\t"
        "fmv.s  ft2, fa0\n\t"
        "vfadd.s  fs4, ft5, ft4\n\t"
        "vfadd.s  fs5, ft7, ft6\n\t"
        "vfadd.s  fs6, fs1, fs0\n\t"
        "vfadd.s  fs7, fa1, fa0\n\t"
        "vfadd.s  fs8, fs8, fs4\n\t"
        "vfadd.s  fs9, fs9, fs5\n\t"
        "vfadd.s  fs10, fs10, fs6\n\t"
        "vfadd.s  fs11, fs11, fs7\n\t"
        "vfadd.s  fs8, fs9, fs8\n\t"
        "vfadd.s  fs10, fs10, fs11\n\t"
        "vfadd.s  fs8, fs10, fs8\n\t"
        "fsw fs8, 0(%[sum]) \n\t"
        :
        : [zero] "r"(PACE_ZERO_BITS), [n] "r"(PACE_EXP_ITERS - 1),
          [sum] "r"(denom_lane_buf), [xmax] "r"(xmax_lane_buf)
        : "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
          "fs0", "fs1", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9",
          "fs10", "fs11", "fa0", "fa1", "memory");
#endif
}

static inline void pace_softmax_store_denom(
    volatile raw_data_t **denom_write_ptr,
    volatile raw_data_t *denom_lane_buf) {
#if defined(ENABLE_FP16) && (PACE_LANES == 4)
    pace_softmax_store_deno_fp16x4(denom_write_ptr, denom_lane_buf);
#elif PACE_LANES == 2
    __asm__ volatile(
        "flw ft3, %1\n\t"
        "flw ft4, %2\n\t"
        "fadd.s ft4, ft3, ft4\n\t"
        "vfcpka.s.s ft3, ft4, ft4\n\t"
        "fsd ft3, %0\n\t"
        : "=m"(*(volatile double *)*denom_write_ptr)
        : "m"(denom_lane_buf[0]), "m"(denom_lane_buf[1])
        : "ft3", "ft4", "memory");
    *denom_write_ptr += 2;
#else
    __asm__ volatile(
        "flw ft3, 0(%[sum_src])\n\t"
        "fsw ft3, 0(%[sum_dst])\n\t"
        "addi %[sum_dst], %[sum_dst], 4\t\n"
        : [ sum_dst ] "+r"(*denom_write_ptr)
        : [ sum_src ] "r"(denom_lane_buf)
        : "ft3", "memory");
#endif
}

static inline void pace_softmax_compute_exp_stage(
    const pace_softmax_work_t *work, pace_softmax_buffers_t *buffers) {
    if (!work->core_active || work->row_count == 0) {
        return;
    }

    snrt_ssr_loop_1d(SNRT_SSR_DM0, PACE_VEC_ITERS * work->row_count,
                     PACE_SSR_STRIDE);
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D,
                  buffers->input_buf + work->input_offset);
    snrt_ssr_loop_1d(SNRT_SSR_DM1, PACE_VEC_ITERS * work->row_count,
                     PACE_SSR_STRIDE);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D,
                  buffers->input_buf + work->input_offset);
    snrt_ssr_loop_1d(SNRT_SSR_DM2, PACE_VEC_ITERS * work->row_count,
                     PACE_SSR_STRIDE);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D,
                   buffers->exp_buf + work->input_offset);
    snrt_ssr_enable();

    for (uint32_t row = 0; row < work->row_count; row++) {
        pace_softmax_compute_xmax(buffers->xmax_lane_buf);
        pace_softmax_exp_denom((raw_data_t *)buffers->denom_lane_buf,
                               buffers->xmax_lane_buf);
        pace_softmax_store_denom(&buffers->denom_write_ptr,
                                 buffers->denom_lane_buf);
    }

    snrt_fpu_fence();
    snrt_ssr_disable();
}

static inline void pace_softmax_compute_inv_denom(
    const pace_softmax_work_t *work, pace_softmax_buffers_t *buffers) {
    snrt_ssr_loop_1d(SNRT_SSR_DM0, work->row_count, PACE_SSR_STRIDE);
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, buffers->denom_inv_src);
    snrt_ssr_loop_1d(SNRT_SSR_DM2, work->row_count, PACE_SSR_STRIDE);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D,
                   buffers->inv_denom_buf + work->denom_offset);
    snrt_ssr_enable();
#if PACE_LANES > 1
    __asm__ volatile(
        "frep.o  %[n], 1, 0, 0\n\t" PACE_VINV_OP("ft2", "ft0", "ft0")
        :
        : [ n ] "r"(work->row_count - 1)
        : "ft0", "ft2", "memory");
#else
    __asm__ volatile("frep.o  %[n], 1, 0, 0\n\t" PACE_INV_OP("ft1", "ft0")
                     :
                     : [ n ] "r"(work->row_count - 1)
                     : "ft0", "ft1", "memory");
#endif
    snrt_fpu_fence();
    snrt_ssr_disable();
}

static inline void pace_softmax_apply_inv_denom(
    const pace_softmax_work_t *work, pace_softmax_buffers_t *buffers) {
    snrt_ssr_loop_1d(SNRT_SSR_DM0, work->row_count * PACE_VEC_ITERS,
                     PACE_SSR_STRIDE);
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D,
                  buffers->exp_buf + work->input_offset);
    snrt_ssr_loop_1d(SNRT_SSR_DM2, work->row_count * PACE_VEC_ITERS,
                     PACE_SSR_STRIDE);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D,
                   buffers->softmax_buf + work->input_offset);
    snrt_ssr_enable();

    for (uint32_t row = 0; row < work->row_count; row++) {
#if defined(ENABLE_FP16) && (PACE_LANES == 4)
        __asm__ volatile(
            "fld ft3, 0(%[inv])\n\t"
            "frep.o  %[n], 1, 0, 0\n\t"
            "vfmul.h  ft2, ft3, ft0\n\t"
            :
            : [ inv ] "r"(buffers->inv_mul_src), [ n ] "r"(PACE_VEC_ITERS - 1)
            : "ft0", "ft2", "memory");
#elif PACE_LANES == 2
        __asm__ volatile(
            "fld ft3, 0(%[inv])\n\t"
            "frep.o  %[n], 1, 0, 0\n\t"
            "vfmul.s  ft2, ft3, ft0\n\t"
            :
            : [ inv ] "r"(buffers->inv_mul_src), [ n ] "r"(PACE_VEC_ITERS - 1)
            : "ft0", "ft2", "memory");
#else
        __asm__ volatile(
            "flw ft3, 0(%[inv])\n\t"
            "frep.o  %[n], 1, 0, 0\n\t"
            "vfmul.s  ft2, ft3, ft0\n\t"
            :
            : [ inv ] "r"(buffers->inv_mul_src), [ n ] "r"(PACE_VEC_ITERS - 1)
            : "ft0", "ft2", "memory");
#endif
        buffers->inv_mul_src += PACE_LANES;
    }

    snrt_fpu_fence();
    snrt_ssr_disable();
}

static inline void pace_softmax_compute_output_stage(
    const pace_softmax_work_t *work, pace_softmax_buffers_t *buffers) {
    if (!work->core_active || work->row_count == 0) {
        return;
    }

    pace_softmax_compute_inv_denom(work, buffers);
    pace_softmax_apply_inv_denom(work, buffers);
}

static inline void pace_softmax_check(void) {
    if (snrt_cluster_core_idx() == 0) {
        int errors =
            pace_softmax_check_output((raw_data_t *)&ofmap[0][0],
                                      (raw_data_t *)&golden[0][0], OUTPUTS_LEN);
        printf("attn_oup_errors = %d\n", errors);
    }
}

#endif
