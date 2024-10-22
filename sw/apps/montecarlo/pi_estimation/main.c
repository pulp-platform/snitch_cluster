// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Fabio Cappellini <fcappellini@student.ethz.ch>
// Hakim Filali <hfilali@student.ee.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>
// Lannan Jiang <jiangl@student.ethz.ch>

#include "math.h"
#include "pi_estimation.h"
#include "prng.h"
#include "snrt.h"

#ifndef N_SAMPLES
#define N_SAMPLES 1024
#endif

#ifndef FUNC_PTR
#define FUNC_PTR calculate_psum_optimized
#endif

#ifndef N_CORES
#define N_CORES snrt_cluster_compute_core_num()
#endif

#ifndef BATCH_SIZE
#define BATCH_SIZE 64
#endif

#define APPLICATION_PI 0
#define APPLICATION_POLY 1

#ifndef APPLICATION
#define APPLICATION APPLICATION_PI
#endif

#define PRNG_LCG 0
#define PRNG_XOSHIRO128P 1

#ifndef PRNG
#define PRNG PRNG_LCG
#endif

#if PRNG == PRNG_LCG
#define PRNG_T lcg_t
#define PRNG_INIT_N lcg_init_n_default
#define PRNG_NEXT lcg_next
#elif PRNG == PRNG_XOSHIRO128P
#define PRNG_T xoshiro128p_t
#define PRNG_INIT_N xoshiro128p_init_n
#define PRNG_NEXT xoshiro128p_next
#endif

__thread double one = 1.0;
__thread double two = 2.0;
__thread double three = 3.0;

static inline uint32_t calculate_psum_naive(PRNG_T *prng,
                                            unsigned int n_samples) {
    // Only compute cores follow
    if (snrt_cluster_core_idx() >= N_CORES) return 0;

    uint32_t int_x, int_y;
    double x, y;
    unsigned int hit = 0;
    unsigned int result = 0;

    snrt_mcycle();
    for (unsigned int i = 0; i < n_samples; i++) {
        int_x = PRNG_NEXT(prng);
        int_y = PRNG_NEXT(prng);
        x = rand_int_to_unit_double(int_x);
        y = rand_int_to_unit_double(int_y);

#if APPLICATION == APPLICATION_PI
        hit = (x * x + y * y) < one;
#elif APPLICATION == APPLICATION_POLY
        hit = (y * 3) < (x * x * x + x * x - x + 2);
#endif

        if (hit) result++;
    }
    snrt_mcycle();

    return result;
}

static inline uint32_t calculate_psum_baseline(PRNG_T *prngs,
                                               unsigned int n_samples) {
    if (snrt_cluster_core_idx() < N_CORES) {
        int result = 0;
        int n_iter = n_samples / 4;

#if PRNG == PRNG_LCG
        // LCG state
        uint32_t lcg_state_x0 = prngs[0].state;
        uint32_t lcg_state_x1 = prngs[1].state;
        uint32_t lcg_state_x2 = prngs[2].state;
        uint32_t lcg_state_x3 = prngs[3].state;
        uint32_t lcg_state_y0 = prngs[4].state;
        uint32_t lcg_state_y1 = prngs[5].state;
        uint32_t lcg_state_y2 = prngs[6].state;
        uint32_t lcg_state_y3 = prngs[7].state;
        uint32_t lcg_Ap = prngs->A;
        uint32_t lcg_Cp = prngs->C;
#elif PRNG == PRNG_XOSHIRO128P
        // xoshiro128p state
        uint32_t xoshiro128p_state_0 = prngs->s[0];
        uint32_t xoshiro128p_state_1 = prngs->s[1];
        uint32_t xoshiro128p_state_2 = prngs->s[2];
        uint32_t xoshiro128p_state_3 = prngs->s[3];
        uint32_t xoshiro128p_tmp;
#endif

        // clang-format off
        asm volatile(
            "1:"
            "csrr t4, mcycle \n"
            // Generate next 4 pseudo-random integer (X,Y) pairs
            // and convert to doubles
#if PRNG == PRNG_LCG
            EVAL_LCG_UNROLL4
            FCVT_UNROLL_8(%[int_x0], %[int_y0], %[int_x1], %[int_y1],
                          %[int_x2], %[int_y2], %[int_x3], %[int_y3],
                          ft0, fa0, ft1, fa1, ft2, fa2, ft3, fa3)
#elif PRNG == PRNG_XOSHIRO128P
            EVAL_XOSHIRO128P_UNROLL4
            FCVT_UNROLL_8(t0, t1, t2, t3, a0, a1, a2, a3,
                          ft0, ft1, ft2, ft3, fa0, fa1, fa2, fa3)
#endif

            // Normalize PRNs to [0, 1] range
            "fmul.d ft0, ft0, %[div] \n"
            "fmul.d ft1, ft1, %[div] \n"
            "fmul.d ft2, ft2, %[div] \n"
            "fmul.d ft3, ft3, %[div] \n"
            "fmul.d fa0, fa0, %[div] \n"
            "fmul.d fa1, fa1, %[div] \n"
            "fmul.d fa2, fa2, %[div] \n"
            "fmul.d fa3, fa3, %[div] \n"

#if APPLICATION == APPLICATION_PI
            // x^2 + y^2
            EVAL_X2_PLUS_Y2_UNROLL4(ft0, ft1, ft2, ft3, fa0, fa1, fa2, fa3,
                                    ft0, ft1, ft2, ft3)
            // (x^2 + y^2) < 1
            FLT_UNROLL_4(ft0, ft1, ft2, ft3, %[one], %[one], %[one], %[one],
                         a0, a1, a2, a3)
#elif APPLICATION == APPLICATION_POLY
            // y * 3
            // x^3 + x^2 - x + 2
            EVAL_POLY_UNROLL4(ft0, ft1, ft2, ft3, fa0, fa1, fa2, fa3, ft4, ft5,
                              ft6, ft7, ft0, ft1, ft2, ft3)
            // y * 3 < x^3 + x^2 - x + 2
            FLT_UNROLL_4(fa0, fa1, fa2, fa3, ft0, ft1, ft2, ft3, a0, a1, a2,
                         a3)
#endif

            // Count points in circle
            "add %[result], %[result], a0 \n"
            "add %[result], %[result], a1 \n"
            "add %[result], %[result], a2 \n"
            "add %[result], %[result], a3 \n"

            // Loop over batches
            "addi %[n_iter], %[n_iter], -1 \n"
            "bnez %[n_iter], 1b            \n"

            : [ result ] "+r"(result), [ n_iter ] "+r"(n_iter)
#if PRNG == PRNG_LCG
              , ASM_LCG_OUTPUTS
#elif PRNG == PRNG_XOSHIRO128P
              , ASM_XOSHIRO128P_OUTPUTS
#endif
            : [ div ] "f"(max_uint_plus_1_inverse)
#if PRNG == PRNG_LCG
              , ASM_LCG_INPUTS
#elif PRNG == PRNG_XOSHIRO128P
              , ASM_XOSHIRO128P_INPUTS
#endif
#if APPLICATION == APPLICATION_PI
              , ASM_PI_CONSTANTS(one)
#elif APPLICATION == APPLICATION_POLY
              , ASM_POLY_CONSTANTS(two, three)
#endif
            : "ft0", "ft1", "ft2", "ft3",
              "fa0", "fa1", "fa2", "fa3",
              "t0", "t1", "t2", "t3",
              "a0", "a1", "a2", "a3",
              "memory"
#if APPLICATION == APPLICATION_POLY
              , ASM_POLY_CLOBBERS
#endif
        );
        // clang-format on
        snrt_fpu_fence();

        return result;
    }

    return 0;
}

static inline uint32_t calculate_psum_optimized(PRNG_T *prngs,
                                                unsigned int n_samples) {
    // Derived parameters
    uint32_t n_batches = n_samples / BATCH_SIZE;
    uint32_t n_iterations = n_batches + 2;

    // Allocate memory on TCDM
    unsigned int result = 0;
    double *rng_x_all[2];
    double *rng_y_all[2];
    double *rng_z_all[2];

    // Allocate (double) buffers for communication between integer and FP
    // threads in memory
    rng_x_all[0] = (double *)snrt_l1_alloc_cluster_local(
        BATCH_SIZE * N_CORES * sizeof(double), sizeof(double));
    rng_y_all[0] = (double *)snrt_l1_alloc_cluster_local(
        BATCH_SIZE * N_CORES * sizeof(double), sizeof(double));
    rng_z_all[0] = (double *)snrt_l1_alloc_cluster_local(
        BATCH_SIZE * N_CORES * sizeof(double), sizeof(double));
    rng_x_all[1] = (double *)snrt_l1_alloc_cluster_local(
        BATCH_SIZE * N_CORES * sizeof(double), sizeof(double));
    rng_y_all[1] = (double *)snrt_l1_alloc_cluster_local(
        BATCH_SIZE * N_CORES * sizeof(double), sizeof(double));
    rng_z_all[1] = (double *)snrt_l1_alloc_cluster_local(
        BATCH_SIZE * N_CORES * sizeof(double), sizeof(double));

    // Point each core to its own section of the buffers
    if (snrt_is_compute_core()) {
        unsigned int offset = snrt_cluster_core_idx() * BATCH_SIZE;
        rng_x_all[0] += offset;
        rng_y_all[0] += offset;
        rng_z_all[0] += offset;
        rng_x_all[1] += offset;
        rng_y_all[1] += offset;
        rng_z_all[1] += offset;
    }

    // Clear buffers. This is necessary since the PRNG generates 32-bit
    // integers, but the fcvt.d.wu.copift instruction expects 64-bit integers.
    // Zero-padding is sufficient to encode a 64-bit unsigned integer from
    // a 32-bit integer. Thus, if the buffers are zero-initialized, storing the
    // 32-bit integers with a 64-bit stride is sufficient.
    if (snrt_is_dm_core()) {
        snrt_dma_memset(rng_x_all[0], 0, sizeof(double) * BATCH_SIZE * N_CORES);
        snrt_dma_memset(rng_y_all[0], 0, sizeof(double) * BATCH_SIZE * N_CORES);
        snrt_dma_memset(rng_z_all[0], 0, sizeof(double) * BATCH_SIZE * N_CORES);
        snrt_dma_memset(rng_x_all[1], 0, sizeof(double) * BATCH_SIZE * N_CORES);
        snrt_dma_memset(rng_y_all[1], 0, sizeof(double) * BATCH_SIZE * N_CORES);
        snrt_dma_memset(rng_z_all[1], 0, sizeof(double) * BATCH_SIZE * N_CORES);
    }
    snrt_cluster_hw_barrier();

    // Pointers to current set of buffers
    unsigned int fp_xyz_idx = 0;
    unsigned int int_xy_idx = 0;
    unsigned int int_z_idx = 0;
    double *fp_x_ptr = rng_x_all[fp_xyz_idx];
    double *fp_y_ptr = rng_y_all[fp_xyz_idx];
    double *fp_z_ptr = rng_z_all[fp_xyz_idx];
    double *int_x_ptr = rng_x_all[int_xy_idx];
    double *int_y_ptr = rng_y_all[int_xy_idx];
    double *int_z_ptr = rng_z_all[int_z_idx];

    // Accumulators for partial sums
    int temp0 = 0;
    int temp1 = 0;
    int temp2 = 0;
    int temp3 = 0;
    int temp4 = 0;
    int temp5 = 0;
    int temp6 = 0;
    int temp7 = 0;

#if PRNG == PRNG_LCG
    // LCG state
    uint32_t lcg_state_x0 = prngs[0].state;
    uint32_t lcg_state_x1 = prngs[1].state;
    uint32_t lcg_state_x2 = prngs[2].state;
    uint32_t lcg_state_x3 = prngs[3].state;
    uint32_t lcg_state_y0 = prngs[4].state;
    uint32_t lcg_state_y1 = prngs[5].state;
    uint32_t lcg_state_y2 = prngs[6].state;
    uint32_t lcg_state_y3 = prngs[7].state;
    uint32_t lcg_Ap = prngs->A;
    uint32_t lcg_Cp = prngs->C;
#elif PRNG == PRNG_XOSHIRO128P
    // xoshiro128p state
    uint32_t xoshiro128p_state_0 = prngs->s[0];
    uint32_t xoshiro128p_state_1 = prngs->s[1];
    uint32_t xoshiro128p_state_2 = prngs->s[2];
    uint32_t xoshiro128p_state_3 = prngs->s[3];
    uint32_t xoshiro128p_tmp;
#endif

    if (snrt_cluster_core_idx() < N_CORES) {
        // Set up SSRs
        snrt_ssr_loop_1d(SNRT_SSR_DM_ALL, BATCH_SIZE, sizeof(double));

        // Batch iterations
        for (int iteration = 0; iteration < n_iterations; iteration++) {
            snrt_mcycle();

            // Floating-point thread works on all but first and last iterations
            if (iteration > 0 && iteration < n_iterations - 1) {
                // Switch buffers for floating-point thread
                fp_xyz_idx ^= 1;
                fp_x_ptr = rng_x_all[fp_xyz_idx];
                fp_y_ptr = rng_y_all[fp_xyz_idx];
                fp_z_ptr = rng_z_all[fp_xyz_idx];

                // Point SSRs to current buffers
                snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, fp_x_ptr);
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, fp_y_ptr);
                snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, fp_z_ptr);

                // Fix register used by 1.0 constant
                register double reg_one asm("ft8") = one;
                register double reg_two asm("ft9") = two;
                register double reg_three asm("ft10") = three;

                // Enable SSRs
                snrt_ssr_enable();

                // Floating-point thread
                // clang-format off
                asm volatile(
                    // Unrolled by 4
#if APPLICATION == APPLICATION_PI
                    "frep.o %[n_frep], 28, 0, 0 \n"
#elif APPLICATION == APPLICATION_POLY
                    "frep.o %[n_frep], 40, 0, 0 \n"
#endif

                    // Convert integer PRNs to doubles
                    "fcvt.d.wu.copift fa0, ft0 \n"
                    "fcvt.d.wu.copift fa1, ft1 \n"
                    "fcvt.d.wu.copift fa2, ft0 \n"
                    "fcvt.d.wu.copift fa3, ft1 \n"
                    "fcvt.d.wu.copift fa4, ft0 \n"
                    "fcvt.d.wu.copift fa5, ft1 \n"
                    "fcvt.d.wu.copift fa6, ft0 \n"
                    "fcvt.d.wu.copift fa7, ft1 \n"

                    // Normalize PRNs to [0, 1] range
                    "fmul.d fa0, fa0, %[div] \n"
                    "fmul.d fa2, fa2, %[div] \n"
                    "fmul.d fa4, fa4, %[div] \n"
                    "fmul.d fa6, fa6, %[div] \n"
                    "fmul.d fa1, fa1, %[div] \n"
                    "fmul.d fa3, fa3, %[div] \n"
                    "fmul.d fa5, fa5, %[div] \n"
                    "fmul.d fa7, fa7, %[div] \n"

#if APPLICATION == APPLICATION_PI
                    // x^2 + y^2
                    EVAL_X2_PLUS_Y2_UNROLL4(fa0, fa2, fa4, fa6, fa1, fa3, fa5,
                                            fa7, fa1, fa3, fa5, fa7)
                    // (x^2 + y^2) < 1
                    FLT_SSR_UNROLL_4(fa1, fa3, fa5, fa7, ft8, ft8, ft8, ft8,
                                     ft2, ft2, ft2, ft2)
#elif APPLICATION == APPLICATION_POLY
                    // y * 3
                    // x^3 + x^2 - x + 2
                    EVAL_POLY_UNROLL4(fa0, fa2, fa4, fa6, fa1, fa3, fa5, fa7,
                                      ft3, ft4, ft5, ft6, fa0, fa2, fa4, fa6)
                    // y * 3 < x^3 + x^2 - x + 2
                    FLT_SSR_UNROLL_4(fa1, fa3, fa5, fa7, fa0, fa2, fa4, fa6,
                                     ft2, ft2, ft2, ft2)
#endif
                    :
                    : [ n_frep ] "r"(BATCH_SIZE / 4 - 1),
                      [ div ] "f"(max_uint_plus_1_inverse)
#if APPLICATION == APPLICATION_PI
                      , ASM_PI_CONSTANTS(reg_one)
#elif APPLICATION == APPLICATION_POLY
                      , ASM_POLY_CONSTANTS(reg_two, reg_three)
#endif
                    : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft8",
                      "fa0", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6", "fa7",
                      "memory"
                );
                // clang-format on
            }

            // Integer thread produces PRNs in all but last two iterations
            if (iteration < n_iterations - 2) {
                // Switch X, Y buffers for integer generation thread
                int_xy_idx ^= 1;
                int_x_ptr = rng_x_all[int_xy_idx];
                int_y_ptr = rng_y_all[int_xy_idx];

                // Unrolled by 4
                uint32_t n_iter = BATCH_SIZE / 4;
                // clang-format off
                asm volatile(
                    "1:"

                    // Compute and store 4 integer PRN (X, Y) pairs for
                    // iteration i+2, zero-padded to 64-bit unsigned
                    // integers
#if PRNG == PRNG_LCG
                    EVAL_LCG_UNROLL4
                    SW_UNROLL_8(%[int_x0], %[int_y0], %[int_x1], %[int_y1],
                                %[int_x2], %[int_y2], %[int_x3], %[int_y3],
                                0, 0, 8, 8, 16, 16, 24, 24,
                                %[rng_x], %[rng_y], %[rng_x], %[rng_y],
                                %[rng_x], %[rng_y], %[rng_x], %[rng_y])
#elif PRNG == PRNG_XOSHIRO128P
                    EVAL_XOSHIRO128P_UNROLL4
                    SW_UNROLL_8(t0, a0, t1, a1, t2, a2, t3, a3,
                                0, 0, 8, 8, 16, 16, 24, 24,
                                %[rng_x], %[rng_y], %[rng_x], %[rng_y],
                                %[rng_x], %[rng_y], %[rng_x], %[rng_y])
#endif

                    // Loop over batches
                    "addi %[n_iter], %[n_iter], -1 \n"
                    "addi %[rng_x], %[rng_x], 32   \n"
                    "addi %[rng_y], %[rng_y], 32   \n"
                    "bnez %[n_iter], 1b            \n"
                    : [ n_iter ] "+r"(n_iter)
#if PRNG == PRNG_LCG
                      , ASM_LCG_OUTPUTS
#elif PRNG == PRNG_XOSHIRO128P
                      , ASM_XOSHIRO128P_OUTPUTS
#endif
                    : [ rng_x ] "r"(int_x_ptr),
                      [ rng_y ] "r"(int_y_ptr)
#if PRNG == PRNG_LCG
                      , ASM_LCG_INPUTS
#elif PRNG == PRNG_XOSHIRO128P
                      , ASM_XOSHIRO128P_INPUTS
#endif
                    : "t0", "a0", "t1", "a1", "t2", "a2", "t3", "a3",
                      "memory"
                );
                // clang-format on
            }

            // Integer thread accumulates the comparison results in all
            // iterations after the second
            if (iteration > 1) {
                // Switch Z buffers for integer accumulation thread
                int_z_idx ^= 1;
                int_z_ptr = rng_z_all[int_z_idx];

                // Unrolled by 8
                for (int j = 0; j < BATCH_SIZE; j += 8) {
                    asm volatile(
                        "lw  a0,  0(%[rng_z])       \n"
                        "lw  a1,  8(%[rng_z])       \n"
                        "lw  a2, 16(%[rng_z])       \n"
                        "lw  a3, 24(%[rng_z])       \n"
                        "add %[temp0], %[temp0], a0 \n"
                        "lw  a4, 32(%[rng_z])       \n"
                        "add %[temp1], %[temp1], a1 \n"
                        "lw  a5, 40(%[rng_z])       \n"
                        "add %[temp2], %[temp2], a2 \n"
                        "lw  a6, 48(%[rng_z])       \n"
                        "add %[temp3], %[temp3], a3 \n"
                        "lw  a7, 56(%[rng_z])       \n"
                        "add %[temp4], %[temp4], a4 \n"
                        "add %[temp5], %[temp5], a5 \n"
                        "add %[temp6], %[temp6], a6 \n"
                        "add %[temp7], %[temp7], a7 \n"
                        : [ temp0 ] "+r"(temp0), [ temp1 ] "+r"(temp1),
                          [ temp2 ] "+r"(temp2), [ temp3 ] "+r"(temp3),
                          [ temp4 ] "+r"(temp4), [ temp5 ] "+r"(temp5),
                          [ temp6 ] "+r"(temp6), [ temp7 ] "+r"(temp7)
                        : [ rng_z ] "r"(&int_z_ptr[j])
                        : "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7",
                          "memory");
                }
            }

            // Synchronize FP and integer threads and disable SSRs
            snrt_fpu_fence();
            snrt_ssr_disable();
        }

        // Reduce partial sums
        result += temp0;
        result += temp1;
        result += temp2;
        result += temp3;
        result += temp4;
        result += temp5;
        result += temp6;
        result += temp7;
        return result;
    }

    return 0;
}

int main() {
    uint32_t n_seq_per_core, n_seq;

    // Define number of independent subsequences required for parallelization
    // or simply to have independent states, allowing to avoid RAW stalls
    n_seq_per_core = 1;
    if (PRNG == PRNG_LCG) {
        if (FUNC_PTR != calculate_psum_naive) n_seq_per_core = 4 * 2;
    }
    // Every core gets independent subsequences which to calculate in parallel
    n_seq = n_seq_per_core * N_CORES;

    // Initialize the PRNGs for parallel Monte Carlo.
    PRNG_T *prngs = (PRNG_T *)snrt_l1_alloc_cluster_local(
        sizeof(PRNG_T) * n_seq, sizeof(PRNG_T));
    if (snrt_cluster_core_idx() == 0) {
        PRNG_INIT_N(42, n_seq, prngs);
    }
    snrt_cluster_hw_barrier();

    // Store partial sum array at first free address in TCDM
    uint32_t *reduction_array = (uint32_t *)snrt_l1_alloc_cluster_local(
        sizeof(uint32_t) * N_CORES, sizeof(uint32_t));

    // Calculate partial sums
    if (snrt_is_compute_core()) snrt_mcycle();
    uint32_t n_samples_per_core = N_SAMPLES / N_CORES;
    int result = FUNC_PTR(prngs + snrt_cluster_core_idx() * n_seq_per_core,
                          n_samples_per_core);
    if (snrt_is_compute_core()) {
        reduction_array[snrt_cluster_core_idx()] = result;
        snrt_mcycle();
    }

    // Synchronize cores
    snrt_cluster_hw_barrier();

    // First core in cluster performs the final calculation
    if (snrt_cluster_core_idx() == 0) {
        // Reduce partial sums
        uint32_t hit = 0;
        for (int i = 0; i < N_CORES; i++) {
            hit += reduction_array[i];
        }

        // Estimate final result and calculate error
        double actual_result;
        double golden_result;
#if APPLICATION == APPLICATION_PI
        actual_result = (double)(4 * hit) / (double)N_SAMPLES;
        golden_result = M_PI;
#elif APPLICATION == APPLICATION_POLY
        actual_result = 3 * (double)hit / (double)N_SAMPLES;
        golden_result = 2.083333333;
#endif

        // Check result
        double err = fabs(actual_result - golden_result);
        if (err > 0.1) return 1;
    }

    return 0;
}
