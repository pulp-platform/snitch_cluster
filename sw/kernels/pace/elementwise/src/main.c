// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

#include "data.h"
#include "pace_elementwise.h"
#include "snrt.h"

#ifndef PACE_EXEC_VECTOR
#define PACE_EXEC_VECTOR 1
#endif

#ifndef PACE_EXEC_SCALAR
#define PACE_EXEC_SCALAR 0
#endif

#if PACE_EXEC_VECTOR == PACE_EXEC_SCALAR
#error "Select exactly one elementwise execution mode"
#endif

#if FPU_DATA_WIDTH == 64
#define PACE_SSR_STRIDE sizeof(double)
#elif FPU_DATA_WIDTH == 32
#define PACE_SSR_STRIDE sizeof(float)
#else
#error "Unsupported FPU_DATA_WIDTH configuration"
#endif

#if PACE_EXEC_SCALAR
#if defined(ENABLE_FP16)
typedef __fp16 pace_scalar_t;
typedef union {
    pace_scalar_t f;
    uint16_t u;
} pace_scalar_bits_t;
#elif defined(ENABLE_FP32)
typedef float pace_scalar_t;
typedef union {
    pace_scalar_t f;
    uint32_t u;
} pace_scalar_bits_t;
#else
#error "Unsupported precision configuration"
#endif

#endif

static int check_output(const data_t *actual, const data_t *expected, int len) {
    int errors = len;

    for (int i = 0; i < len; i++) {
        data_t actual_data = actual[i];
        data_t expected_data = expected[i];
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

int main() {
    const uint32_t compute_core_count = snrt_cluster_compute_core_num();
    const uint32_t core_idx = snrt_cluster_core_idx();
    const uint32_t inputs_len_per_core = INPUTS_LEN / compute_core_count;

    data_t *local_x = (data_t *)snrt_l1_next();
    data_t *local_y = local_x + INPUTS_LEN;
    param_t *local_param = (param_t *)(local_y + INPUTS_LEN);
    data_t *core_local_x = local_x + core_idx * inputs_len_per_core;
    data_t *core_local_y = local_y + core_idx * inputs_len_per_core;
    param_t *pace_mem = (param_t *)snrt_cluster()->pacemem.mem;

    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_x, ifmap, INPUTS_LEN * sizeof(data_t));
        snrt_dma_wait_all();
        snrt_dma_start_1d(local_param, params, PARAMS_LEN * sizeof(param_t));
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        asm volatile("csrw 0x7d2, %0" : : "rK"(PACE_DEGREE) : "memory");
        pace_configure_fmode();
    }

    snrt_cluster_hw_barrier();

    int32_t dma_pace_start_cycle = snrt_mcycle();
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(pace_mem, local_param, PARAMS_LEN * sizeof(param_t));
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    int32_t dma_pace_end_cycle = snrt_mcycle();
    int32_t start_cycle = snrt_mcycle();
    int32_t pace_start_cycle = 0;
    int32_t pace_end_cycle = 0;

    if (snrt_is_compute_core()) {
#if PACE_EXEC_VECTOR
        snrt_ssr_loop_1d(SNRT_SSR_DM0, inputs_len_per_core / PACE_LANES,
                         PACE_SSR_STRIDE);
        snrt_ssr_loop_1d(SNRT_SSR_DM1, inputs_len_per_core / PACE_LANES,
                         PACE_SSR_STRIDE);
        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, core_local_x);
        snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_1D, core_local_y);

        snrt_ssr_enable();
        pace_start_cycle = snrt_mcycle();
        pace_vector_ssr(inputs_len_per_core / PACE_LANES - 1);
        snrt_fpu_fence();
        pace_end_cycle = snrt_mcycle();
        snrt_ssr_disable();
#else
        pace_start_cycle = snrt_mcycle();
        for (uint32_t i = 0; i < inputs_len_per_core; i++) {
            pace_scalar_bits_t pace_in_bits;
            pace_in_bits.u = core_local_x[i];
            register pace_scalar_t pace_in asm("ft0") = pace_in_bits.f;
            register pace_scalar_t pace_out asm("ft1");
            pace_scalar_bits_t pace_out_bits;

            __asm__ volatile("" : : "f"(pace_in));
            __asm__ volatile(PACE_SCALAR_OP("ft1", "ft0")
                             : "=f"(pace_out)
                             :
                             : "memory");
            pace_out_bits.f = pace_out;
            core_local_y[i] = pace_out_bits.u;
        }
        snrt_fpu_fence();
        pace_end_cycle = snrt_mcycle();
#endif
    }

    snrt_cluster_hw_barrier();

    int32_t end_cycle = snrt_mcycle();
    if (core_idx == 0) {
        printf("start cycle: %d, end_cycle: %d, diff_cycle:%d\n", start_cycle,
               end_cycle, end_cycle - start_cycle);
        printf("pace start cycle: %d, pace end_cycle: %d, pace diff_cycle:%d\n",
               pace_start_cycle, pace_end_cycle,
               pace_end_cycle - pace_start_cycle);
        printf("dma start cycle: %d, dma end_cycle: %d, dma diff_cycle:%d\n",
               dma_pace_start_cycle, dma_pace_end_cycle,
               dma_pace_end_cycle - dma_pace_start_cycle);
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(ofmap, local_y, INPUTS_LEN * sizeof(data_t));
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (core_idx == 0) {
        int errors = check_output(ofmap, golden, INPUTS_LEN);
        printf("errors = %d\n", errors);
    }

    snrt_cluster_hw_barrier();

    return 0;
}
