// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#define N_BUFFERS 2

#include "vlogf_optimized_asm.h"

static inline void vlogf_optimized(float *a, double *b) {
    // Derived parameters
    unsigned int n_stages = 4;  // DMA in, INT, FP, DMA out
    unsigned int n_batches = LEN / BATCH_SIZE;
    unsigned int n_iterations = n_stages + n_batches - 1;

    // Allocate buffers (ORDER IS IMPORTANT!)
    float *a_buffers[N_BUFFERS];
    double *b_buffers[N_BUFFERS];
    uint64_t *z_buffers[N_BUFFERS];
    uint64_t *k_buffers[N_BUFFERS];
    uint64_t *invc_buffers[N_BUFFERS];
    uint64_t *logc_buffers[N_BUFFERS];
    uint8_t *idx_buffers[N_BUFFERS];
    a_buffers[0] = ALLOCATE_BUFFER(float, BATCH_SIZE);
    a_buffers[1] = ALLOCATE_BUFFER(float, BATCH_SIZE);
    b_buffers[0] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    b_buffers[1] = ALLOCATE_BUFFER(double, BATCH_SIZE);
    z_buffers[0] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    z_buffers[1] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    k_buffers[0] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    k_buffers[1] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
#if IMPL == IMPL_ISSR
    idx_buffers[0] = ALLOCATE_BUFFER(uint8_t, BATCH_SIZE * 2);
    idx_buffers[1] = ALLOCATE_BUFFER(uint8_t, BATCH_SIZE * 2);
#else
    invc_buffers[0] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    invc_buffers[1] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    logc_buffers[0] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
    logc_buffers[1] = ALLOCATE_BUFFER(uint64_t, BATCH_SIZE);
#endif

    // Define buffer pointers for every phase (int and fp)
    unsigned int dma_a_idx = 0;
    unsigned int dma_b_idx = 0;
    unsigned int int_buff_idx = 0;
    unsigned int fp_buff_idx = 0;
    float *dma_a_ptr;
    double *dma_b_ptr;
    float *int_a_ptr;
    uint64_t *int_z_ptr;
    uint64_t *int_k_ptr;
    uint64_t *int_invc_ptr;
    uint64_t *int_logc_ptr;
    uint8_t *int_idx_ptr;
    uint64_t *fp_z_ptr;
    uint64_t *fp_invc_ptr;
    uint8_t *fp_idx_ptr;
    double *fp_b_ptr;

    // NaN-box values in Z buffer, since conversion from single-precision
    // to double-precision floating-point assumes the single-precision values
    // are NaN-boxed.
    if (snrt_cluster_core_idx() == 0)
        for (int i = 0; i < BATCH_SIZE; i++) {
            z_buffers[0][i] = 0xffffffffffffffff;
            z_buffers[1][i] = 0xffffffffffffffff;
        }

    snrt_cluster_hw_barrier();

    // Iterate over batches
    for (int iteration = 0; iteration < n_iterations; iteration++) {
        snrt_mcycle();

        // DMA cores
        if (snrt_is_dm_core()) {
            // DMA in phase
            if (iteration < n_iterations - 3) {
                // Index buffers
                dma_a_ptr = a_buffers[dma_a_idx];

                // DMA transfer
                snrt_dma_load_1d_tile(dma_a_ptr, a, iteration, BATCH_SIZE,
                                      sizeof(float));

                // Increment buffer index for next iteration
                dma_a_idx += 1;
                dma_a_idx %= N_BUFFERS;
            }

            // DMA out phase
            if (iteration > 2) {
                // Index buffers
                dma_b_ptr = b_buffers[dma_b_idx];

                // DMA transfer
                snrt_dma_store_1d_tile(b, dma_b_ptr, iteration - 3, BATCH_SIZE,
                                       sizeof(double));

                // Increment buffer index for next iteration
                dma_b_idx += 1;
                dma_b_idx %= N_BUFFERS;
            }

            snrt_dma_wait_all();
        }

        // Compute cores
        if (snrt_cluster_core_idx() == 0) {
            // FP phase
            if (iteration > 1 && iteration < n_iterations - 1) {
                // Index buffers
                fp_z_ptr = z_buffers[fp_buff_idx];
                fp_invc_ptr = invc_buffers[fp_buff_idx];
                fp_idx_ptr = idx_buffers[fp_buff_idx];
                fp_b_ptr = b_buffers[fp_buff_idx];

                // Configure SSRs
                int unroll_factor = 4;
                if (iteration == 2) {
                    snrt_ssr_loop_3d(SNRT_SSR_DM0, unroll_factor, 2,
                                     BATCH_SIZE / unroll_factor,
                                     sizeof(uint64_t),
                                     N_BUFFERS * BATCH_SIZE * sizeof(uint64_t),
                                     sizeof(uint64_t) * unroll_factor);
                    snrt_ssr_loop_1d(SNRT_SSR_DM2, BATCH_SIZE, sizeof(double));
#if IMPL == IMPL_ISSR
                }
                // Load invc and logc using an ISSR
                snrt_issr_read(SNRT_SSR_DM1, (void *)T, fp_idx_ptr,
                               2 * BATCH_SIZE, SNRT_SSR_IDXSIZE_U8);
#else
                    snrt_ssr_loop_3d(SNRT_SSR_DM1, unroll_factor, 2,
                                     BATCH_SIZE / unroll_factor,
                                     sizeof(uint64_t),
                                     N_BUFFERS * BATCH_SIZE * sizeof(uint64_t),
                                     sizeof(uint64_t) * unroll_factor);
                }
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D, fp_invc_ptr);
#endif
                snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_3D, fp_z_ptr);
                snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, fp_b_ptr);
                snrt_ssr_enable();

                // FP computation
                asm volatile("frep.o %[n_frep], 36, 0, 0 \n" FP_ASM_BODY
                             :
                             : [ n_frep ] "r"(BATCH_SIZE / unroll_factor - 1),
                               [ A0 ] "f"(A[0]), [ A1 ] "f"(A[1]),
                               [ A2 ] "f"(A[2]), [ A3 ] "f"(A[3]),
                               [ Ln2 ] "f"(Ln2)
                             : "ft0", "ft1", "ft2", "fa0", "fa1", "fa2", "fa3",
                               "fa4", "fa5", "fa6", "fa7", "ft3", "ft4", "ft5",
                               "ft6", "ft7", "ft8", "ft9", "ft10", "memory");

                // Increment buffer indices for next iteration
                fp_buff_idx += 1;
                fp_buff_idx %= N_BUFFERS;
            }

            // INT phase
            if (iteration > 0 && iteration < n_iterations - 2) {
                // Index buffers
                int_a_ptr = a_buffers[int_buff_idx];
                int_z_ptr = z_buffers[int_buff_idx];
                int_invc_ptr = invc_buffers[int_buff_idx];
                int_k_ptr = k_buffers[int_buff_idx];
                int_logc_ptr = logc_buffers[int_buff_idx];
                int_idx_ptr = idx_buffers[int_buff_idx];

                // INT computation
                // Avoid further unrolling by the compiler so that loop fits in
                // L0 cache
                int unroll_factor = 4;
#pragma nounroll
                for (int i = 0; i < BATCH_SIZE; i += unroll_factor) {
                    asm volatile(INT_ASM_BODY
                                 :
                                 : [ a ] "r"(int_a_ptr + i), [ OFF ] "r"(OFF),
                                   [ T ] "r"(T), [ z ] "r"(int_z_ptr + i),
                                   [ k ] "r"(int_k_ptr + i),
#if IMPL == IMPL_ISSR
                                   [ idx ] "r"(int_idx_ptr + 2 * i)
#else
                                   [ invc ] "r"(int_invc_ptr + i),
                                   [ logc ] "r"(int_logc_ptr + i)
#endif
                                 : "a0", "a1", "a2", "a3", "a4", "a5", "a6",
                                   "a7", "t0", "t1", "t2", "t3", "t4", "t5",
                                   "t6", "s0", "memory");
                }

                // Increment buffer indices for next iteration
                int_buff_idx += 1;
                int_buff_idx %= N_BUFFERS;
            }

            // Synchronize FP and integer threads
            snrt_ssr_disable();
            snrt_fpu_fence();
        }

        // Synchronize cores
        snrt_cluster_hw_barrier();
    }
}
