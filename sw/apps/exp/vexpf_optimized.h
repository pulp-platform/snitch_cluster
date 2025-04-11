// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#define N_T_BUFFERS 2
#define N_W_BUFFERS 3

#include "vexpf_optimized_asm.h"

static inline void vexpf_optimized(double *a, double *b) {
    // Derived parameters
    unsigned int n_batches = LEN / BATCH_SIZE;
    unsigned int n_iterations = n_batches + 2 + 2;

    // Allocate buffers (ORDER IS IMPORTANT!)
    uint64_t *ki_buffers[N_W_BUFFERS];
    double *kd_buffers[N_W_BUFFERS];
    double *w_buffers[N_W_BUFFERS];
    double *b_buffers[N_W_BUFFERS];
    double *a_buffers[N_T_BUFFERS];
    uint64_t *t_buffers[N_T_BUFFERS];
    ki_buffers[0] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    ki_buffers[1] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    ki_buffers[2] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    kd_buffers[0] = (double *)ki_buffers[0];
    kd_buffers[1] = (double *)ki_buffers[1];
    kd_buffers[2] = (double *)ki_buffers[2];
    w_buffers[0] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    w_buffers[1] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    w_buffers[2] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    b_buffers[1] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    b_buffers[2] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    b_buffers[0] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    a_buffers[0] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    a_buffers[1] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    t_buffers[0] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    t_buffers[1] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);

    // Define buffer pointers for every phase (fp0, int and fp1)
    unsigned int dma_a_idx = 0;
    unsigned int dma_b_idx = 0;
    unsigned int fp0_a_idx = 0;
    unsigned int fp0_w_idx = 0;
    unsigned int int_ki_idx = 0;
    unsigned int int_t_idx = 0;
    unsigned int fp1_w_idx = 0;
    unsigned int fp1_t_idx = 0;
    double *dma_a_ptr;
    double *dma_b_ptr;
    double *fp0_a_ptr;
    double *fp0_kd_ptr;
    double *fp0_w_ptr;
    uint64_t *int_ki_ptr;
    uint64_t *int_t_ptr;
    uint64_t *fp1_t_ptr;
    double *fp1_w_ptr;
    double *fp1_b_ptr;

    // Exponential function constants
    uint32_t EXP2F_TABLE_BITS = 5;
    double N = 1 << EXP2F_TABLE_BITS;
    double InvLn2N = 0x1.71547652b82fep+0 * N;
    double SHIFT = 0x1.8p+52;
    double C[4] = {0x1.c6af84b912394p-5 / N / N / N,
                   0x1.ebfce50fac4f3p-3 / N / N, 0x1.62e42ff0c52d6p-1 / N, 1.0};

    snrt_cluster_hw_barrier();

    // Iterate over batches
    for (int iteration = 0; iteration < n_iterations; iteration++) {
        snrt_mcycle();

        // DMA cores
        if (snrt_is_dm_core()) {
            // DMA in phase
            if (iteration < n_iterations - 4) {
                // Index buffers
                dma_a_ptr = a_buffers[dma_a_idx];

                // DMA transfer
                snrt_dma_load_1d_tile(dma_a_ptr, a, iteration, BATCH_SIZE,
                                      sizeof(double));

                // Increment buffer index for next iteration
                dma_a_idx += 1;
                dma_a_idx %= N_T_BUFFERS;
            }

            // DMA out phase
            if (iteration > 3) {
                // Index buffers
                dma_b_ptr = b_buffers[dma_b_idx];

                // DMA transfer
                snrt_dma_store_1d_tile(b, dma_b_ptr, iteration - 4, BATCH_SIZE,
                                       sizeof(double));

                // Increment buffer index for next iteration
                dma_b_idx += 1;
                dma_b_idx %= N_W_BUFFERS;
            }

            snrt_dma_wait_all();
        }

        // Compute cores
        if (snrt_cluster_core_idx() == 0) {
            // FP0 phase
            if (iteration > 0 && iteration < 3 &&
                iteration < n_iterations - 3) {
                // Index buffers
                fp0_a_ptr = a_buffers[fp0_a_idx];
                fp0_kd_ptr = kd_buffers[fp0_w_idx];
                fp0_w_ptr = w_buffers[fp0_w_idx];

                // Configure SSRs
                snrt_ssr_loop_1d(SNRT_SSR_DM_ALL, BATCH_SIZE, sizeof(double));
                snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, fp0_a_ptr);
                snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_1D, fp0_kd_ptr);
                snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, fp0_w_ptr);
                snrt_ssr_enable();

                // FP0 computation
                int unroll_factor = 4;
                asm volatile("frep.o %[n_frep], 36, 0, 0 \n" FP0_ASM_BODY
                             :
                             : [ n_frep ] "r"(BATCH_SIZE / unroll_factor - 1),
                               [ InvLn2N ] "f"(InvLn2N), [ SHIFT ] "f"(SHIFT),
                               [ C0 ] "f"(C[0]), [ C1 ] "f"(C[1]),
                               [ C2 ] "f"(C[2]), [ C3 ] "f"(C[3])
                             : "memory", "ft0", "ft1", "ft2", "fa3", "ft3",
                               "ft4", "ft5", "fa1", "fa2", "fa3", "fa4", "fa5",
                               "fa6", "fa7", "ft3", "ft4", "ft5", "ft6", "ft7",
                               "ft8", "fs0", "fs1", "fs2", "ft0", "ft1", "ft2");

                // Increment buffer index for next iteration
                fp0_w_idx += 1;
                fp0_a_idx += 1;
                fp0_w_idx %= N_W_BUFFERS;
                fp0_a_idx %= N_T_BUFFERS;
            }

            // Both FP0 and FP1 phases
            if (iteration > 2 && iteration < n_iterations - 3) {
                // Index buffers
                fp0_a_ptr = a_buffers[fp0_a_idx];
                fp0_kd_ptr = kd_buffers[fp0_w_idx];
                fp1_w_ptr = w_buffers[fp1_w_idx];

                // Configure SSRs
                int unroll_factor = 4;
                if (iteration == 3) {
                    snrt_ssr_loop_3d(SNRT_SSR_DM0, unroll_factor, 2,
                                     BATCH_SIZE / unroll_factor, sizeof(double),
                                     N_T_BUFFERS * BATCH_SIZE * sizeof(double),
                                     sizeof(double) * unroll_factor);
                    snrt_ssr_loop_1d(SNRT_SSR_DM1, BATCH_SIZE, sizeof(double));
                    snrt_ssr_loop_3d(SNRT_SSR_DM2, unroll_factor, 3,
                                     BATCH_SIZE / unroll_factor, sizeof(double),
                                     N_W_BUFFERS * BATCH_SIZE * sizeof(double),
                                     sizeof(double) * unroll_factor);
                }
                snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_3D, fp0_a_ptr);
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, fp1_w_ptr);
                snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_3D, fp0_kd_ptr);
                snrt_ssr_enable();

                // FP0 and FP1 computation
                asm volatile("frep.o %[n_frep], 40, 0, 0 \n" FP0_FP1_ASM_BODY
                             :
                             : [ n_frep ] "r"(BATCH_SIZE / unroll_factor - 1),
                               [ InvLn2N ] "f"(InvLn2N), [ SHIFT ] "f"(SHIFT),
                               [ C0 ] "f"(C[0]), [ C1 ] "f"(C[1]),
                               [ C2 ] "f"(C[2]), [ C3 ] "f"(C[3])
                             : "memory", "ft0", "ft1", "ft2", "fa1", "fa2",
                               "fa3", "fa4", "fa5", "fa6", "fa7", "ft3", "ft4",
                               "ft5", "ft6", "ft7", "ft8", "fs0", "fs1", "fs2");

                // Increment buffer index for next iteration
                fp0_w_idx += 1;
                fp0_a_idx += 1;
                fp1_w_idx += 1;
                fp1_t_idx += 1;
                fp0_w_idx %= N_W_BUFFERS;
                fp0_a_idx %= N_T_BUFFERS;
                fp1_w_idx %= N_W_BUFFERS;
                fp1_t_idx %= N_T_BUFFERS;
            }

            // FP1 phase
            if (iteration > 2 && iteration >= n_iterations - 3 &&
                iteration < n_iterations - 1) {
                // Index buffers
                fp1_w_ptr = w_buffers[fp1_w_idx];
                fp1_t_ptr = t_buffers[fp1_t_idx];
                fp1_b_ptr = b_buffers[fp1_w_idx];

                // Configure SSRs
                int unroll_factor = 4;
                snrt_ssr_loop_1d(SNRT_SSR_DM_ALL, BATCH_SIZE, sizeof(double));
                snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, fp1_w_ptr);
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, fp1_t_ptr);
                snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, fp1_b_ptr);
                snrt_ssr_enable();

                // FP1 computation
                asm volatile("frep.o %[n_frep], 4, 0, 0 \n" FP1_ASM_BODY
                             :
                             : [ n_frep ] "r"(BATCH_SIZE / unroll_factor - 1)
                             : "memory", "ft0", "ft1", "ft2");

                // Increment buffer indices for next iteration
                fp1_w_idx += 1;
                fp1_t_idx += 1;
                fp1_w_idx %= N_W_BUFFERS;
                fp1_t_idx %= N_T_BUFFERS;
            }

            // INT phase
            if (iteration > 1 && iteration < n_iterations - 2) {
                // Index buffers
                int_ki_ptr = ki_buffers[int_ki_idx];
                int_t_ptr = t_buffers[int_t_idx];

                // INT computation
                // Avoid further unrolling by the compiler so that loop fits in
                // L0 cache
                int unroll_factor = 4;
#pragma nounroll
                for (int i = 0; i < BATCH_SIZE; i += unroll_factor) {
                    asm volatile(INT_ASM_BODY
                                 :
                                 : [ ki ] "r"(int_ki_ptr + i), [ T ] "r"(T),
                                   [ t ] "r"(int_t_ptr + i)
                                 : "memory", "a0", "a1", "a2", "a3", "a4", "a5",
                                   "a6", "a7", "t0", "t1", "t2", "t3");
                }

                // Increment buffer indices for next iteration
                int_ki_idx += 1;
                int_t_idx += 1;
                int_ki_idx %= N_W_BUFFERS;
                int_t_idx %= N_T_BUFFERS;
            }

            // Synchronize FP and integer threads
            snrt_ssr_disable();
            snrt_fpu_fence();
        }

        // Synchronize cores
        snrt_cluster_hw_barrier();
    }
}
