// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Exercises PACE (piecewise polynomial approximation): loads a degree-2
// polynomial (a=1, b=0, c=0, identical across all partitions) into the FPU's
// PACE coefficient memory, then issues a plain vfmul.vv (reinterpreted as
// PWPA while PACE is enabled) and checks the result against x*x.

#include <snrt.h>
#include <stdint.h>
#include <stdio.h>

// CSR_PACE = 0xba0. write_csr() stringifies its register argument via the
// preprocessor's # operator, which does not macro-expand its operand, so the
// address must be passed as a literal at the call site rather than through
// a #define.

// pace_mode_t = {extend:1, enable:1, degree[2:0]} packed MSB-first.
#define PACE_MODE(extend, enable, degree) \
    (((extend) << 4) | ((enable) << 3) | ((degree) & 0x7))

// Coefficient memory layout (degree-major, partition-minor), matching
// PaceDegree=2, PaceParts=16, PaceEps=1, PaceDataWidth=32 (PaceParamWidth =
// 2080 bits = 65 words). Padded to 80 words = 5 beats of N_FU*ELEN=512 bits.
#define PACE_NUM_PARTS 16
#define PACE_COEFF_WORDS 65
#define PACE_LOAD_WORDS 80

// Under DOUBLE_BW, pace_mem only captures VLSU interface 0; loads at or
// under SpatzMemBytes/2 (64B here) bypass interface 1 entirely, so prime
// pace_mem one 64-byte beat at a time instead of one big load.
#define PACE_CHUNK_WORDS 16
#define PACE_NUM_CHUNKS (PACE_LOAD_WORDS / PACE_CHUNK_WORDS)

#define FP32_ONE 0x3F800000u
#define FP32_ZERO 0x00000000u
#define FP32_INF 0x7F800000u

uint32_t pace_coeffs[PACE_LOAD_WORDS] __attribute__((aligned(4096))) = {
    // a (deg 0, leading coeff) x16 partitions
    FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE,
    FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE, FP32_ONE,
    FP32_ONE, FP32_ONE,
    // b (deg 1) x16 partitions
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    // c (deg 2, constant) x16 partitions
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    // 15 boundary values (identical -> BST comparator outcome irrelevant)
    FP32_INF, FP32_INF, FP32_INF, FP32_INF, FP32_INF, FP32_INF, FP32_INF,
    FP32_INF, FP32_INF, FP32_INF, FP32_INF, FP32_INF, FP32_INF, FP32_INF,
    FP32_INF,
    // eps threshold, eps_out (unused by plain PWPA)
    FP32_ZERO, FP32_ZERO,
    // padding to fill out the 5th write beat (words 65..79)
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO, FP32_ZERO,
    FP32_ZERO, FP32_ZERO, FP32_ZERO,
};

#define N_X 8
float x[N_X] __attribute__((aligned(4096))) = {0.0f,  1.0f, 2.0f, 3.5f,
                                                -4.0f, 0.5f, -1.5f, 10.0f};

#ifndef SNRT_SUPPORTS_VECTOR
int main() { return 0; }
#else
uint32_t *local_coeffs;
float *local_x;
float *local_y;

int main() {
    // DM core: allocate L1 buffers and DMA data from DRAM
    if (snrt_is_dm_core()) {
        local_coeffs =
            (uint32_t *)snrt_l1_alloc(PACE_LOAD_WORDS * sizeof(uint32_t));
        local_x = (float *)snrt_l1_alloc(N_X * sizeof(float));
        local_y = (float *)snrt_l1_alloc(N_X * sizeof(float));

        printf(
            "[dm] local_coeffs=%p local_x=%p local_y=%p (dram src "
            "pace_coeffs=%p x=%p)\n",
            (void *)local_coeffs, (void *)local_x, (void *)local_y,
            (void *)pace_coeffs, (void *)x);

        snrt_dma_start_1d(local_coeffs, pace_coeffs,
                           PACE_LOAD_WORDS * sizeof(uint32_t));
        snrt_dma_start_1d(local_x, x, N_X * sizeof(float));
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        int errs = 0;
        size_t gvl;

        printf(
            "[cc%u] local_coeffs=%p local_x=%p local_y=%p PACE_LOAD_WORDS=%d "
            "N_X=%d\n",
            snrt_cluster_core_idx(), (void *)local_coeffs, (void *)local_x,
            (void *)local_y, PACE_LOAD_WORDS, N_X);

        // Enable PACE (degree 2) -- this also starts gating VLSU writes
        // into pace_mem instead of the VRF until it's fully primed.
        write_csr(0xba0, PACE_MODE(0, 1, 2));

        // Prime pace_mem one beat at a time; each load's VRF write is
        // redirected into the coefficient memory instead of the VRF.
        asm volatile("vsetvli %[gvl], %[vl], e32, m8, ta, ma"
                     : [ gvl ] "=r"(gvl)
                     : [ vl ] "r"((unsigned int)PACE_CHUNK_WORDS));
        for (int chunk = 0; chunk < PACE_NUM_CHUNKS; chunk++) {
            uint32_t *chunk_ptr = local_coeffs + chunk * PACE_CHUNK_WORDS;
            printf("[cc%u] vle32.v coeff chunk %d: addr=%p vl=%lu\n",
                   snrt_cluster_core_idx(), chunk, (void *)chunk_ptr,
                   (unsigned long)gvl);
            asm volatile("vle32.v v0, (%0);" ::"r"(chunk_ptr));
        }

        // Give pace_mem_init_done a few cycles to latch before the next
        // load's writes are allowed to reach the VRF normally again.
        asm volatile("nop");
        asm volatile("nop");
        asm volatile("nop");
        asm volatile("nop");
        asm volatile("nop");
        asm volatile("nop");
        asm volatile("nop");

        // Compute: vfmul.vv is reinterpreted as PWPA while PACE is enabled.
        asm volatile("vsetvli %[gvl], %[vl], e32, m8, ta, ma"
                     : [ gvl ] "=r"(gvl)
                     : [ vl ] "r"((unsigned int)N_X));
        printf("[cc%u] vle32.v data load: addr=%p vl=%lu\n",
               snrt_cluster_core_idx(), (void *)local_x, (unsigned long)gvl);
        asm volatile("vle32.v v8, (%0);" ::"r"(local_x));
        asm volatile("vfmul.vv v8, v8, v8");
        asm volatile("vse32.v v8, (%0);" ::"r"(local_y));
        printf("[cc%u] vse32.v store: addr=%p\n", snrt_cluster_core_idx(),
               (void *)local_y);

        // Check results via volatile pointer to prevent auto-vectorization.
        volatile float *vy = (volatile float *)local_y;
        for (int i = 0; i < N_X; i++) {
            float expected = x[i] * x[i];
            float diff = vy[i] - expected;
            if (diff < 0.0f) diff = -diff;
            if (diff > 0.01f) errs++;
        }

        return errs;
    }

    snrt_cluster_hw_barrier();

    return 0;
}
#endif
