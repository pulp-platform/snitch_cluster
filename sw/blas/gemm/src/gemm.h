// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <stdint.h>

#include "snrt.h"

// Guard to avoid conflict with DNN header file
// TODO: move this definition to Snitch math library to solve problem
#ifndef PRECISION_T
#define PRECISION_T
typedef enum { FP64 = 8, FP32 = 4, FP16 = 2, FP8 = 1 } precision_t;

typedef float v2f32 __attribute__((vector_size(8)));
typedef __fp16 v4f16 __attribute__((vector_size(8)));
typedef char v8f8 __attribute__((vector_size(8)));
#endif

void gemm_fp64_baseline(uint32_t M, uint32_t N, uint32_t K, double* A,
                        uint32_t ldA, uint32_t ta, double* B, uint32_t ldB,
                        uint32_t tb, double* C, uint32_t ldC, double BETA) {
    if (!ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                register double c0 = BETA * C[m * ldC + n];
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k + m * ldA] * B[k * ldB + n];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else if (ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                register double c0 = BETA * C[m * ldC + n];
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * ldA + m * ldA] * B[k * ldB + n];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else if (!ta && tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                register double c0 = BETA * C[m * ldC + n];
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k + m * ldA] * B[k + n * ldB];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                register double c0 = BETA * C[m * ldC + n];
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * ldA + m * ldA] * B[k + n * ldB];
                }
                C[m * ldC + n] = c0;
            }
        }
    }
}

void gemm_fp64_opt(uint32_t M, uint32_t N, uint32_t K, double* A, uint32_t ldA,
                   uint32_t ta, double* B, uint32_t ldB, uint32_t tb, double* C,
                   uint32_t ldC, const uint32_t* BETA, uint32_t setup_SSR) {
    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // SSR strides and bounds only have to be configured
    // once in the beginning
    if (setup_SSR) {
        // First matrix is stored in transposed format
        if (ta) {
            const uint32_t ssr0_b[4] = {unroll, K, N / unroll, M};
            const uint32_t ssr0_i[4] = {0, 8 * ldA, 0, 8 * 8};

            snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                             ssr0_i[1], ssr0_i[2], ssr0_i[3]);
            snrt_ssr_repeat(SNRT_SSR_DM0, unroll);
        } else {
            const uint32_t ssr0_b[4] = {unroll, K, N / unroll, M};
            const uint32_t ssr0_i[4] = {0, 8, 0, 8 * ldA};

            snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                             ssr0_i[1], ssr0_i[2], ssr0_i[3]);
            snrt_ssr_repeat(SNRT_SSR_DM0, unroll);
        }

        // Second matrix is stored in transposed format
        if (tb) {
            const uint32_t ssr1_b[4] = {unroll, K, N / unroll, M};
            const uint32_t ssr1_i[4] = {8 * ldB, 8, 8 * ldB * unroll, 0};

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2],
                             ssr1_i[3]);
        } else {
            const uint32_t ssr1_b[4] = {unroll, K, N / unroll, M};
            const uint32_t ssr1_i[4] = {8, 8 * ldB, 8 * unroll, 0};

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2],
                             ssr1_i[3]);
        }
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
    snrt_ssr_enable();

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            double c[unroll];

            // Load intermediate result
            if (*BETA) {
                c[0] = C[m * ldC + n + 0];
                c[1] = C[m * ldC + n + 1];
                c[2] = C[m * ldC + n + 2];
                c[3] = C[m * ldC + n + 3];
                c[4] = C[m * ldC + n + 4];
                c[5] = C[m * ldC + n + 5];
                c[6] = C[m * ldC + n + 6];
                c[7] = C[m * ldC + n + 7];
            } else {
                c[0] = 0.0;
                c[1] = 0.0;
                c[2] = 0.0;
                c[3] = 0.0;
                c[4] = 0.0;
                c[5] = 0.0;
                c[6] = 0.0;
                c[7] = 0.0;
            }

            asm volatile(
                "frep.o %[n_frep], 8, 0, 0 \n"
                "fmadd.d %[c0], ft0, ft1, %[c0] \n"
                "fmadd.d %[c1], ft0, ft1, %[c1] \n"
                "fmadd.d %[c2], ft0, ft1, %[c2] \n"
                "fmadd.d %[c3], ft0, ft1, %[c3] \n"
                "fmadd.d %[c4], ft0, ft1, %[c4] \n"
                "fmadd.d %[c5], ft0, ft1, %[c5] \n"
                "fmadd.d %[c6], ft0, ft1, %[c6] \n"
                "fmadd.d %[c7], ft0, ft1, %[c7] \n"
                : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                  [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                  [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7])
                : [ n_frep ] "r"(K - 1)
                : "ft0", "ft1", "ft2");

            // Store results back
            C[m * ldC + n + 0] = c[0];
            C[m * ldC + n + 1] = c[1];
            C[m * ldC + n + 2] = c[2];
            C[m * ldC + n + 3] = c[3];
            C[m * ldC + n + 4] = c[4];
            C[m * ldC + n + 5] = c[5];
            C[m * ldC + n + 6] = c[6];
            C[m * ldC + n + 7] = c[7];
            n += unroll;
        }

        // Clean up of leftover columns
        snrt_ssr_disable();

        for (; n < N; n++) {
            double c;
            if (*BETA) {
                c = C[m * ldC + n];
            } else {
                c = 0.0;
            }
            for (uint32_t k = 0; k < K; k++) {
                c += A[k + m * ldA] * B[k + n * ldB];
            }
            C[m * ldC + n] = c;
        }

        snrt_ssr_enable();
    }

    snrt_ssr_disable();
}

void gemm_fp32_opt(const uint32_t M, const uint32_t N, const uint32_t K,
                   float* A, const uint32_t ldA, float* B, const uint32_t ldB,
                   float* C, const uint32_t ldC, const uint32_t* BETA,
                   const uint32_t setup_SSR) {
    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // SSR strides and bounds only have to be configured
    // once in the beginning
    if (setup_SSR) {
        uint32_t ssr0_b[4] = {unroll, K / 2, N / unroll, M};
        uint32_t ssr0_i[4] = {0, sizeof(float) * 2, 0, sizeof(float) * ldA};

        uint32_t ssr1_b[4] = {unroll, K / 2, N / unroll, M};
        uint32_t ssr1_i[4] = {sizeof(float) * ldB, sizeof(float) * 2,
                              sizeof(float) * unroll * ldB, 0};

        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
    snrt_ssr_enable();

    // Kernel progresses by 2 values each step
    const uint32_t n_frep = K / 2 - 1;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            float* _C = &C[m * ldC + n / 2];
            const register float zero = 0.0;
            v2f32 c[unroll], reduce_reg[unroll];

            asm volatile(
                "lw      t0, 0(%[BETA]) \n"
                "beqz    t0, 1f \n"
                // Load intermediate results
                "flw %[reduce_reg0], 0(%[C]) \n"
                "flw %[reduce_reg1], 4(%[C]) \n"
                "flw %[reduce_reg2], 8(%[C]) \n"
                "flw %[reduce_reg3], 12(%[C]) \n"
                "flw %[reduce_reg4], 16(%[C]) \n"
                "flw %[reduce_reg5], 20(%[C]) \n"
                "flw %[reduce_reg6], 24(%[C]) \n"
                "flw %[reduce_reg7], 28(%[C]) \n"
                // Pack intermediate results into SIMD vector
                "vfcpka.s.s %[reduce_reg0], %[reduce_reg0], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[reduce_reg1], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[reduce_reg2], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[reduce_reg3], %[zero]\n"
                "vfcpka.s.s %[reduce_reg4], %[reduce_reg4], %[zero]\n"
                "vfcpka.s.s %[reduce_reg5], %[reduce_reg5], %[zero]\n"
                "vfcpka.s.s %[reduce_reg6], %[reduce_reg6], %[zero]\n"
                "vfcpka.s.s %[reduce_reg7], %[reduce_reg7], %[zero]\n"
                "j 2f \n"
                "1: \n"
                // Initialize SIMD vector with zeros
                "vfcpka.s.s %[reduce_reg0], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg4], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg5], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg6], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg7], %[zero], %[zero]\n"

                "2: \n"
                // Don't accumulate in first iteration
                "vfmul.s %[c0], ft1, ft0 \n"
                "vfmul.s %[c1], ft1, ft0 \n"
                "vfmul.s %[c2], ft1, ft0 \n"
                "vfmul.s %[c3], ft1, ft0 \n"
                "vfmul.s %[c4], ft1, ft0 \n"
                "vfmul.s %[c5], ft1, ft0 \n"
                "vfmul.s %[c6], ft1, ft0 \n"
                "vfmul.s %[c7], ft1, ft0 \n"
                // frep over MACs
                "frep.o  %[n_frep], 8, 0, 0 \n"
                "vfmac.s %[c0], ft1, ft0 \n"
                "vfmac.s %[c1], ft1, ft0 \n"
                "vfmac.s %[c2], ft1, ft0 \n"
                "vfmac.s %[c3], ft1, ft0 \n"
                "vfmac.s %[c4], ft1, ft0 \n"
                "vfmac.s %[c5], ft1, ft0 \n"
                "vfmac.s %[c6], ft1, ft0 \n"
                "vfmac.s %[c7], ft1, ft0 \n"
                // Sum-reduce vector
                "vfsum.s %[reduce_reg0], %[c0] \n"
                "vfsum.s %[reduce_reg1], %[c1] \n"
                "vfsum.s %[reduce_reg2], %[c2] \n"
                "vfsum.s %[reduce_reg3], %[c3] \n"
                "vfsum.s %[reduce_reg4], %[c4] \n"
                "vfsum.s %[reduce_reg5], %[c5] \n"
                "vfsum.s %[reduce_reg6], %[c6] \n"
                "vfsum.s %[reduce_reg7], %[c7] \n"
                // Pack results together again into vectors
                "vfcpka.s.s %[c0], %[reduce_reg0], %[reduce_reg1] \n"
                "vfcpka.s.s %[c1], %[reduce_reg2], %[reduce_reg3] \n"
                "vfcpka.s.s %[c2], %[reduce_reg4], %[reduce_reg5] \n"
                "vfcpka.s.s %[c3], %[reduce_reg6], %[reduce_reg7] \n"
                : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                  [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                  [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7]),
                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                  [ reduce_reg4 ] "+f"(reduce_reg[4]),
                  [ reduce_reg5 ] "+f"(reduce_reg[5]),
                  [ reduce_reg6 ] "+f"(reduce_reg[6]),
                  [ reduce_reg7 ] "+f"(reduce_reg[7])
                : [ C ] "r"(_C), [ zero ] "f"(zero), [ n_frep ] "r"(n_frep - 1),
                  [ BETA ] "r"(BETA)
                : "ft0", "ft1", "ft2");

            // Store results
            ((v2f32*)_C)[0] = c[0];
            ((v2f32*)_C)[1] = c[1];
            ((v2f32*)_C)[2] = c[2];
            ((v2f32*)_C)[3] = c[3];

            // progress by 2 columns each iteration of the loop
            n += unroll * 2;
        }

        // Clean up of leftover columns
        snrt_ssr_disable();

        for (; n < N; n++) {
            float c = (*BETA) ? C[m * ldC + n] : 0.0;
            for (uint32_t k = 0; k < K; k++) {
                c += A[k + m * ldA] * B[k + n * ldB];
            }
            C[m * ldC + n] = c;
        }

        snrt_ssr_enable();
    }

    snrt_ssr_disable();
}

void gemm_fp16_opt(uint32_t M, uint32_t N, uint32_t K, __fp16* A, uint32_t ldA,
                   __fp16* B, uint32_t ldB, __fp16* C, uint32_t ldC,
                   const uint32_t* BETA, uint32_t setup_SSR) {
    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // SSR strides and bounds only have to be configured
    // once in the beginning
    if (setup_SSR) {
        uint32_t ssr0_b[4] = {unroll, K / 4, N / unroll, M};
        uint32_t ssr0_i[4] = {0, sizeof(__fp16) * 4, 0, sizeof(__fp16) * ldA};

        uint32_t ssr1_b[4] = {unroll, K / 4, N / unroll, M};
        uint32_t ssr1_i[4] = {sizeof(__fp16) * ldB, sizeof(__fp16) * 4,
                              sizeof(__fp16) * unroll * ldB, 0};

        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
    snrt_ssr_enable();

    // Kernel progresses by 4 values each step
    const uint32_t n_frep = K / 4 - 1;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            __fp16* _C = &C[m * ldC + n];
            const register float zero = 0.0;
            v4f16 c[unroll];
            v2f32 reduce_reg[unroll];
            uint32_t beta;

            asm volatile(
                "lw      %[beta], 0(%[BETA]) \n"
                "beqz    %[beta], 1f \n"
                // Load intermediate results
                "flh %[reduce_reg0], 0(%[C]) \n"
                "flh %[reduce_reg1], 2(%[C]) \n"
                "flh %[reduce_reg2], 4(%[C]) \n"
                "flh %[reduce_reg3], 6(%[C]) \n"
                "flh %[reduce_reg4], 8(%[C]) \n"
                "flh %[reduce_reg5], 10(%[C]) \n"
                "flh %[reduce_reg6], 12(%[C]) \n"
                "flh %[reduce_reg7], 14(%[C]) \n"
                // Convert intermediate results before packing
                "vfcvt.s.h %[reduce_reg0], %[reduce_reg0]\n"
                "vfcvt.s.h %[reduce_reg1], %[reduce_reg1]\n"
                "vfcvt.s.h %[reduce_reg2], %[reduce_reg2]\n"
                "vfcvt.s.h %[reduce_reg3], %[reduce_reg3]\n"
                "vfcvt.s.h %[reduce_reg4], %[reduce_reg4]\n"
                "vfcvt.s.h %[reduce_reg5], %[reduce_reg5]\n"
                "vfcvt.s.h %[reduce_reg6], %[reduce_reg6]\n"
                "vfcvt.s.h %[reduce_reg7], %[reduce_reg7]\n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                // Pack intermediate results into SIMD vector
                "vfcpka.h.s %[c0], %[reduce_reg0], %[zero]\n"
                "vfcpka.h.s %[c1], %[reduce_reg1], %[zero]\n"
                "vfcpka.h.s %[c2], %[reduce_reg2], %[zero]\n"
                "vfcpka.h.s %[c3], %[reduce_reg3], %[zero]\n"
                "vfcpka.h.s %[c4], %[reduce_reg4], %[zero]\n"
                "vfcpka.h.s %[c5], %[reduce_reg5], %[zero]\n"
                "vfcpka.h.s %[c6], %[reduce_reg6], %[zero]\n"
                "vfcpka.h.s %[c7], %[reduce_reg7], %[zero]\n"
                "j 2f \n"
                "1: \n"
                // Initialize SIMD vector with zeros
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                "2: \n"
                // Perform non-expanding MACs
                "frep.o  %[n_frep], 8, 0, 0 \n"
                "vfmac.h %[c0], ft1, ft0 \n"
                "vfmac.h %[c1], ft1, ft0 \n"
                "vfmac.h %[c2], ft1, ft0 \n"
                "vfmac.h %[c3], ft1, ft0 \n"
                "vfmac.h %[c4], ft1, ft0 \n"
                "vfmac.h %[c5], ft1, ft0 \n"
                "vfmac.h %[c6], ft1, ft0 \n"
                "vfmac.h %[c7], ft1, ft0 \n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[reduce_reg0], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg4], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg5], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg6], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg7], %[zero], %[zero]\n"
                // Sum-reduce vector
                // EXVSUM is used for the sake of packing afterwards
                "vfsumex.s.h %[reduce_reg0], %[c0] \n"
                "vfsumex.s.h %[reduce_reg1], %[c1] \n"
                "vfsumex.s.h %[reduce_reg2], %[c2] \n"
                "vfsumex.s.h %[reduce_reg3], %[c3] \n"
                "vfsumex.s.h %[reduce_reg4], %[c4] \n"
                "vfsumex.s.h %[reduce_reg5], %[c5] \n"
                "vfsumex.s.h %[reduce_reg6], %[c6] \n"
                "vfsumex.s.h %[reduce_reg7], %[c7] \n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[c0], %[zero], %[zero] \n"
                "vfcpka.s.s %[c1], %[zero], %[zero] \n"
                "vfcpka.s.s %[c2], %[zero], %[zero] \n"
                "vfcpka.s.s %[c3], %[zero], %[zero] \n"
                "vfcpka.s.s %[c4], %[zero], %[zero] \n"
                "vfcpka.s.s %[c5], %[zero], %[zero] \n"
                "vfcpka.s.s %[c6], %[zero], %[zero] \n"
                "vfcpka.s.s %[c7], %[zero], %[zero] \n"
                // Sum-reduce vector
                "vfsum.s %[c0], %[reduce_reg0] \n"
                "vfsum.s %[c1], %[reduce_reg1] \n"
                "vfsum.s %[c2], %[reduce_reg2] \n"
                "vfsum.s %[c3], %[reduce_reg3] \n"
                "vfsum.s %[c4], %[reduce_reg4] \n"
                "vfsum.s %[c5], %[reduce_reg5] \n"
                "vfsum.s %[c6], %[reduce_reg6] \n"
                "vfsum.s %[c7], %[reduce_reg7] \n"
                // Pack results to FP16 vectors
                "vfcpka.h.s %[c0], %[c0], %[c1] \n"
                "vfcpkb.h.s %[c0], %[c2], %[c3] \n"
                "vfcpka.h.s %[c1], %[c4], %[c5] \n"
                "vfcpkb.h.s %[c1], %[c6], %[c7] \n"
                : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                  [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                  [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7]), [ beta ] "=r"(beta),
                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                  [ reduce_reg4 ] "+f"(reduce_reg[4]),
                  [ reduce_reg5 ] "+f"(reduce_reg[5]),
                  [ reduce_reg6 ] "+f"(reduce_reg[6]),
                  [ reduce_reg7 ] "+f"(reduce_reg[7])
                : [ C ] "r"(_C), [ zero ] "f"(zero), [ n_frep ] "r"(n_frep),
                  [ BETA ] "r"(BETA)
                : "ft0", "ft1", "ft2");

            // Store results back
            ((v4f16*)_C)[0] = c[0];
            ((v4f16*)_C)[1] = c[1];
            n += unroll;
        }

        // Clean up left over column
        // snrt_ssr_disable();

        // for (; n < N; n++) {
        //     __fp16 c = (*BETA) ? C[m * ldC + n] : 0.0;
        //     for (uint32_t k = 0; k < K; k++) {
        //         c += A[k + m * ldA] * B[k + n * ldB];
        //     }
        //     C[m * ldC + n] = c;
        // }

        // snrt_ssr_enable();
    }

    snrt_ssr_disable();
}

void gemm_fp16_ex_opt(uint32_t M, uint32_t N, uint32_t K, __fp16* A,
                      uint32_t ldA, __fp16* B, uint32_t ldB, __fp16* C,
                      uint32_t ldC, const uint32_t* BETA, uint32_t setup_SSR) {
    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // SSR strides and bounds only have to be configured
    // once in the beginning
    if (setup_SSR) {
        uint32_t ssr0_b[4] = {unroll, K / 4, N / unroll, M};
        uint32_t ssr0_i[4] = {0, sizeof(__fp16) * 4, 0, sizeof(__fp16) * ldA};

        uint32_t ssr1_b[4] = {unroll, K / 4, N / unroll, M};
        uint32_t ssr1_i[4] = {sizeof(__fp16) * ldB, sizeof(__fp16) * 4,
                              sizeof(__fp16) * unroll * ldB, 0};

        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
    snrt_ssr_enable();

    // Kernel progresses by 4 values each step
    const uint32_t n_frep = K / 4 - 1;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            __fp16* _C = &C[m * ldC + n];
            const register float zero = 0.0;
            v4f16 c[unroll];
            v2f32 reduce_reg[unroll];
            uint32_t beta;

            asm volatile(
                "lw      %[beta], 0(%[BETA]) \n"
                "beqz    %[beta], 1f \n"
                "flh %[reduce_reg0], 0(%[C]) \n"
                "flh %[reduce_reg1], 2(%[C]) \n"
                "flh %[reduce_reg2], 4(%[C]) \n"
                "flh %[reduce_reg3], 6(%[C]) \n"
                "flh %[reduce_reg4], 8(%[C]) \n"
                "flh %[reduce_reg5], 10(%[C]) \n"
                "flh %[reduce_reg6], 12(%[C]) \n"
                "flh %[reduce_reg7], 14(%[C]) \n"
                // Convert intermediate results before packing
                "vfcvt.s.h %[reduce_reg0], %[reduce_reg0]\n"
                "vfcvt.s.h %[reduce_reg1], %[reduce_reg1]\n"
                "vfcvt.s.h %[reduce_reg2], %[reduce_reg2]\n"
                "vfcvt.s.h %[reduce_reg3], %[reduce_reg3]\n"
                "vfcvt.s.h %[reduce_reg4], %[reduce_reg4]\n"
                "vfcvt.s.h %[reduce_reg5], %[reduce_reg5]\n"
                "vfcvt.s.h %[reduce_reg6], %[reduce_reg6]\n"
                "vfcvt.s.h %[reduce_reg7], %[reduce_reg7]\n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                // Pack intermediate results into SIMD vector
                "vfcpka.s.s %[c0], %[reduce_reg0], %[zero]\n"
                "vfcpka.s.s %[c1], %[reduce_reg1], %[zero]\n"
                "vfcpka.s.s %[c2], %[reduce_reg2], %[zero]\n"
                "vfcpka.s.s %[c3], %[reduce_reg3], %[zero]\n"
                "vfcpka.s.s %[c4], %[reduce_reg4], %[zero]\n"
                "vfcpka.s.s %[c5], %[reduce_reg5], %[zero]\n"
                "vfcpka.s.s %[c6], %[reduce_reg6], %[zero]\n"
                "vfcpka.s.s %[c7], %[reduce_reg7], %[zero]\n"
                "j 2f \n"
                "1: \n"
                // Initialize SIMD vector with zeros
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                "2: \n"
                // Perform expanding sum-dotproducts
                "frep.o  %[n_frep], 8, 0, 0 \n"
                "vfdotpex.s.h %[c0], ft1, ft0 \n"
                "vfdotpex.s.h %[c1], ft1, ft0 \n"
                "vfdotpex.s.h %[c2], ft1, ft0 \n"
                "vfdotpex.s.h %[c3], ft1, ft0 \n"
                "vfdotpex.s.h %[c4], ft1, ft0 \n"
                "vfdotpex.s.h %[c5], ft1, ft0 \n"
                "vfdotpex.s.h %[c6], ft1, ft0 \n"
                "vfdotpex.s.h %[c7], ft1, ft0 \n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[reduce_reg0], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg4], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg5], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg6], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg7], %[zero], %[zero]\n"
                // Sum-reduce vector
                "vfsum.s %[reduce_reg0], %[c0] \n"
                "vfsum.s %[reduce_reg1], %[c1] \n"
                "vfsum.s %[reduce_reg2], %[c2] \n"
                "vfsum.s %[reduce_reg3], %[c3] \n"
                "vfsum.s %[reduce_reg4], %[c4] \n"
                "vfsum.s %[reduce_reg5], %[c5] \n"
                "vfsum.s %[reduce_reg6], %[c6] \n"
                "vfsum.s %[reduce_reg7], %[c7] \n"
                // Pack and convert results to FP16 vectors
                "vfcpka.h.s %[c0], %[reduce_reg0], %[reduce_reg1] \n"
                "vfcpkb.h.s %[c0], %[reduce_reg2], %[reduce_reg3] \n"
                "vfcpka.h.s %[c1], %[reduce_reg4], %[reduce_reg5] \n"
                "vfcpkb.h.s %[c1], %[reduce_reg6], %[reduce_reg7] \n"
                : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                  [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                  [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7]), [ beta ] "=r"(beta),
                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                  [ reduce_reg4 ] "+f"(reduce_reg[4]),
                  [ reduce_reg5 ] "+f"(reduce_reg[5]),
                  [ reduce_reg6 ] "+f"(reduce_reg[6]),
                  [ reduce_reg7 ] "+f"(reduce_reg[7])
                : [ C ] "r"(_C), [ zero ] "f"(zero), [ n_frep ] "r"(n_frep),
                  [ BETA ] "r"(BETA)
                : "ft0", "ft1", "ft2");

            // Store results back
            ((v4f16*)_C)[0] = c[0];
            ((v4f16*)_C)[1] = c[1];
            n += unroll;
        }

        // Clean up left over column
        // snrt_ssr_disable();

        // for (; n < N; n++) {
        //     __fp16 c = (*BETA) ? C[m * ldC + n] : 0.0;
        //     for (uint32_t k = 0; k < K; k++) {
        //         c += A[k + m * ldA] * B[k + n * ldB];
        //     }
        //     C[m * ldC + n] = c;
        // }

        // snrt_ssr_enable();
    }

    snrt_ssr_disable();
}

void gemm_fp8_ex_opt(uint32_t M, uint32_t N, uint32_t K, char* A, uint32_t ldA,
                     char* B, uint32_t ldB, char* C, uint32_t ldC,
                     const uint32_t* BETA, uint32_t setup_SSR) {
    // Accumulating currently not implemented
    if (*BETA != 0) return;

    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // SSR strides and bounds only have to be configured
    // once in the beginning
    if (setup_SSR) {
        uint32_t ssr0_b[4] = {unroll, K / 8, N / unroll, M};
        uint32_t ssr0_i[4] = {0, sizeof(char) * 8, 0, sizeof(char) * ldA};

        uint32_t ssr1_b[4] = {unroll, K / 8, N / unroll, M};
        uint32_t ssr1_i[4] = {sizeof(char) * ldB, sizeof(char) * 8,
                              sizeof(char) * unroll * ldB, 0};

        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
    snrt_ssr_enable();

    // Kernel progresses by 8 values each step
    const uint32_t n_frep = K / 8 - 1;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            char* _C = &C[m * ldC + n];
            const register float zero = 0.0;
            v8f8 c[unroll];
            v4f16 reduce_reg[unroll];
            uint32_t beta;

            asm volatile(
                "lw      %[beta], 0(%[BETA]) \n"
                "beqz    %[beta], 1f \n"
                "flb %[reduce_reg0], 0(%[C]) \n"
                "flb %[reduce_reg1], 1(%[C]) \n"
                "flb %[reduce_reg2], 2(%[C]) \n"
                "flb %[reduce_reg3], 3(%[C]) \n"
                "flb %[reduce_reg4], 4(%[C]) \n"
                "flb %[reduce_reg5], 5(%[C]) \n"
                "flb %[reduce_reg6], 6(%[C]) \n"
                "flb %[reduce_reg7], 7(%[C]) \n"
                // Convert intermediate results before packing
                "vfcvt.s.b %[reduce_reg0], %[reduce_reg0]\n"
                "vfcvt.s.b %[reduce_reg1], %[reduce_reg1]\n"
                "vfcvt.s.b %[reduce_reg2], %[reduce_reg2]\n"
                "vfcvt.s.b %[reduce_reg3], %[reduce_reg3]\n"
                "vfcvt.s.b %[reduce_reg4], %[reduce_reg4]\n"
                "vfcvt.s.b %[reduce_reg5], %[reduce_reg5]\n"
                "vfcvt.s.b %[reduce_reg6], %[reduce_reg6]\n"
                "vfcvt.s.b %[reduce_reg7], %[reduce_reg7]\n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                // Pack intermediate results into SIMD vector
                "vfcpka.h.s %[c0], %[reduce_reg0], %[zero]\n"
                "vfcpka.h.s %[c1], %[reduce_reg1], %[zero]\n"
                "vfcpka.h.s %[c2], %[reduce_reg2], %[zero]\n"
                "vfcpka.h.s %[c3], %[reduce_reg3], %[zero]\n"
                "vfcpka.h.s %[c4], %[reduce_reg4], %[zero]\n"
                "vfcpka.h.s %[c5], %[reduce_reg5], %[zero]\n"
                "vfcpka.h.s %[c6], %[reduce_reg6], %[zero]\n"
                "vfcpka.h.s %[c7], %[reduce_reg7], %[zero]\n"
                "j 2f \n"
                "1: \n"
                // Initialize SIMD vector with zeros
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                "2: \n"
                // Perform expanding sum-dotproducts
                "frep.o  %[n_frep], 8, 0, 0 \n"
                "vfdotpex.h.b %[c0], ft1, ft0 \n"
                "vfdotpex.h.b %[c1], ft1, ft0 \n"
                "vfdotpex.h.b %[c2], ft1, ft0 \n"
                "vfdotpex.h.b %[c3], ft1, ft0 \n"
                "vfdotpex.h.b %[c4], ft1, ft0 \n"
                "vfdotpex.h.b %[c5], ft1, ft0 \n"
                "vfdotpex.h.b %[c6], ft1, ft0 \n"
                "vfdotpex.h.b %[c7], ft1, ft0 \n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[reduce_reg0], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg4], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg5], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg6], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg7], %[zero], %[zero]\n"
                // Sum-reduce vector
                "vfsumex.s.h %[reduce_reg0], %[c0] \n"
                "vfsumex.s.h %[reduce_reg1], %[c1] \n"
                "vfsumex.s.h %[reduce_reg2], %[c2] \n"
                "vfsumex.s.h %[reduce_reg3], %[c3] \n"
                "vfsumex.s.h %[reduce_reg4], %[c4] \n"
                "vfsumex.s.h %[reduce_reg5], %[c5] \n"
                "vfsumex.s.h %[reduce_reg6], %[c6] \n"
                "vfsumex.s.h %[reduce_reg7], %[c7] \n"
                //
                // Initialize reduce register to zero
                "vfcpka.s.s %[c0], %[zero], %[zero] \n"
                "vfcpka.s.s %[c1], %[zero], %[zero] \n"
                "vfcpka.s.s %[c2], %[zero], %[zero] \n"
                "vfcpka.s.s %[c3], %[zero], %[zero] \n"
                "vfcpka.s.s %[c4], %[zero], %[zero] \n"
                "vfcpka.s.s %[c5], %[zero], %[zero] \n"
                "vfcpka.s.s %[c6], %[zero], %[zero] \n"
                "vfcpka.s.s %[c7], %[zero], %[zero] \n"
                // Sum-reduce vector
                "vfsum.s %[c0], %[reduce_reg0] \n"
                "vfsum.s %[c1], %[reduce_reg1] \n"
                "vfsum.s %[c2], %[reduce_reg2] \n"
                "vfsum.s %[c3], %[reduce_reg3] \n"
                "vfsum.s %[c4], %[reduce_reg4] \n"
                "vfsum.s %[c5], %[reduce_reg5] \n"
                "vfsum.s %[c6], %[reduce_reg6] \n"
                "vfsum.s %[c7], %[reduce_reg7] \n"
                // Pack and convert results to FP8 vectors
                "vfcpka.b.s %[c0], %[c0], %[c1] \n"
                "vfcpkb.b.s %[c0], %[c2], %[c3] \n"
                "vfcpkc.b.s %[c0], %[c4], %[c5] \n"
                "vfcpkd.b.s %[c0], %[c6], %[c7] \n"
                // // // Pack and convert results to FP8 vectors
                // "vfcpka.b.s %[c0], %[reduce_reg0], %[reduce_reg1] \n"
                // "vfcpkb.b.s %[c0], %[reduce_reg2], %[reduce_reg3] \n"
                // "vfcpkc.b.s %[c0], %[reduce_reg4], %[reduce_reg5] \n"
                // "vfcpkd.b.s %[c0], %[reduce_reg6], %[reduce_reg7] \n"
                : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                  [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                  [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7]), [ beta ] "=r"(beta),
                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                  [ reduce_reg4 ] "+f"(reduce_reg[4]),
                  [ reduce_reg5 ] "+f"(reduce_reg[5]),
                  [ reduce_reg6 ] "+f"(reduce_reg[6]),
                  [ reduce_reg7 ] "+f"(reduce_reg[7])
                : [ C ] "r"(_C), [ n_frep ] "r"(n_frep), [ BETA ] "r"(BETA),
                  [ zero ] "f"(zero)
                : "ft0", "ft1", "ft2");

            // Store results back
            ((v8f8*)_C)[0] = c[0];
            n += unroll;
        }

        // Clean up left over column
        // snrt_ssr_disable();

        // for (; n < N; n++) {
        //     char c = (*BETA) ? C[m * ldC + n] : 0.0;
        //     for (uint32_t k = 0; k < K; k++) {
        //         c += A[k + m * ldA] * B[k + n * ldB];
        //     }
        //     C[m * ldC + n] = c;
        // }

        // snrt_ssr_enable();
    }

    snrt_ssr_disable();
}

void gemm_fp8_ex32_opt(uint32_t M, uint32_t N, uint32_t K, char* A, uint32_t ldA,
                       char* B, uint32_t ldB, char* C, uint32_t ldC,
                       const uint32_t* BETA, uint32_t setup_SSR) {
    // Accumulating currently not implemented
    if (*BETA != 0) return;

    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA/DOTP delay
    // for maximum utilization
    const uint32_t unroll = 8;
    const uint32_t double_unroll = 16;

    // SSR strides and bounds only have to be configured
    // once in the beginning
    if (setup_SSR) {
        uint32_t ssr0_b[4] = {unroll, K / 8, N / unroll, M};
        uint32_t ssr0_i[4] = {0, sizeof(char) * 8, 0, sizeof(char) * ldA};

        uint32_t ssr1_b[4] = {unroll, K / 8, N / unroll, M};
        uint32_t ssr1_i[4] = {sizeof(char) * ldB, sizeof(char) * 8,
                              sizeof(char) * unroll * ldB, 0};

        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);

        // fp8 -> fp32 (wrt fp8->fp16 kernel, it needs two fp8->fp32 instructions per fp8->fp16 instruction)
        snrt_ssr_repeat(SNRT_SSR_DM0, unroll*2);
        snrt_ssr_repeat(SNRT_SSR_DM1, 2);

        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
    snrt_ssr_enable();

    // Kernel progresses by 8 values each step
    const uint32_t n_frep = K / 8 - 1;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            char* _C = &C[m * ldC + n];
            const register float zero = 0.0;
            register v8f8 c[double_unroll];
            register v4f16 reduce_reg[unroll];
            uint32_t beta;

            asm volatile(
                "lw         %[beta], 0(%[BETA]) \n"
                "beqz       %[beta], 1f \n"
                "flb %[reduce_reg0], 0(%[C]) \n"
                "flb %[reduce_reg1], 1(%[C]) \n"
                "flb %[reduce_reg2], 2(%[C]) \n"
                "flb %[reduce_reg3], 3(%[C]) \n"
                "flb %[reduce_reg4], 4(%[C]) \n"
                "flb %[reduce_reg5], 5(%[C]) \n"
                "flb %[reduce_reg6], 6(%[C]) \n"
                "flb %[reduce_reg7], 7(%[C]) \n"\
                // Initialize reduce register to zero
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                "vfcpka.s.s %[c8], %[zero], %[zero]\n"
                "vfcpka.s.s %[c9], %[zero], %[zero]\n"
                "vfcpka.s.s %[c10], %[zero], %[zero]\n"
                "vfcpka.s.s %[c11], %[zero], %[zero]\n"
                "vfcpka.s.s %[c12], %[zero], %[zero]\n"
                "vfcpka.s.s %[c13], %[zero], %[zero]\n"
                "vfcpka.s.s %[c14], %[zero], %[zero]\n"
                "vfcpka.s.s %[c15], %[zero], %[zero]\n"
                // Convert intermediate results before packing
                "vfcvt.s.b %[reduce_reg0], %[reduce_reg0]\n"
                "vfcvt.s.b %[reduce_reg1], %[reduce_reg1]\n"
                "vfcvt.s.b %[reduce_reg2], %[reduce_reg2]\n"
                "vfcvt.s.b %[reduce_reg3], %[reduce_reg3]\n"
                "vfcvt.s.b %[reduce_reg4], %[reduce_reg4]\n"
                "vfcvt.s.b %[reduce_reg5], %[reduce_reg5]\n"
                "vfcvt.s.b %[reduce_reg6], %[reduce_reg6]\n"
                "vfcvt.s.b %[reduce_reg7], %[reduce_reg7]\n"
                // Pack intermediate results into SIMD vector
                "vfcpka.s.s %[c0], %[reduce_reg0], %[zero]\n"
                "vfcpka.s.s %[c2], %[reduce_reg1], %[zero]\n"
                "vfcpka.s.s %[c4], %[reduce_reg2], %[zero]\n"
                "vfcpka.s.s %[c6], %[reduce_reg3], %[zero]\n"
                "vfcpka.s.s %[c8], %[reduce_reg4], %[zero]\n"
                "vfcpka.s.s %[c10], %[reduce_reg5], %[zero]\n"
                "vfcpka.s.s %[c12], %[reduce_reg6], %[zero]\n"
                "vfcpka.s.s %[c14], %[reduce_reg7], %[zero]\n"
                "j 2f \n"
                "1: \n"
                // Initialize SIMD vector with zeros
                "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                "vfcpka.s.s %[c8], %[zero], %[zero]\n"
                "vfcpka.s.s %[c9], %[zero], %[zero]\n"
                "vfcpka.s.s %[c10], %[zero], %[zero]\n"
                "vfcpka.s.s %[c11], %[zero], %[zero]\n"
                "vfcpka.s.s %[c12], %[zero], %[zero]\n"
                "vfcpka.s.s %[c13], %[zero], %[zero]\n"
                "vfcpka.s.s %[c14], %[zero], %[zero]\n"
                "vfcpka.s.s %[c15], %[zero], %[zero]\n"
                "2: \n"
                // Perform expanding sum-dotproducts
                "frep.o  %[n_frep], 16, 0, 0 \n"
                "vfdotpexa.s.b %[c0], ft1, ft0 \n"
                "vfdotpexb.s.b %[c1], ft1, ft0 \n"
                "vfdotpexa.s.b %[c2], ft1, ft0 \n"
                "vfdotpexb.s.b %[c3], ft1, ft0 \n"
                "vfdotpexa.s.b %[c4], ft1, ft0 \n"
                "vfdotpexb.s.b %[c5], ft1, ft0 \n"
                "vfdotpexa.s.b %[c6], ft1, ft0 \n"
                "vfdotpexb.s.b %[c7], ft1, ft0 \n"
                "vfdotpexa.s.b %[c8], ft1, ft0 \n"
                "vfdotpexb.s.b %[c9], ft1, ft0 \n"
                "vfdotpexa.s.b %[c10], ft1, ft0 \n"
                "vfdotpexb.s.b %[c11], ft1, ft0 \n"
                "vfdotpexa.s.b %[c12], ft1, ft0 \n"
                "vfdotpexb.s.b %[c13], ft1, ft0 \n"
                "vfdotpexa.s.b %[c14], ft1, ft0 \n"
                "vfdotpexb.s.b %[c15], ft1, ft0 \n"
                // Reduce double accumulator due to unbalanced wdotp8to32
                "vfadd.s %[c0], %[c0], %[c1] \n"
                "vfadd.s %[c1], %[c2], %[c3] \n"
                "vfadd.s %[c2], %[c4], %[c5] \n"
                "vfadd.s %[c3], %[c6], %[c7] \n"
                "vfadd.s %[c4], %[c8], %[c9] \n"
                "vfadd.s %[c5], %[c10], %[c11] \n"
                "vfadd.s %[c6], %[c12], %[c13] \n"
                "vfadd.s %[c7], %[c14], %[c15] \n"
                // Initialize reduce register to zero
                "vfcpka.s.s %[reduce_reg0], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg4], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg5], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg6], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg7], %[zero], %[zero]\n"
                // Sum-reduce vector
                "vfsum.s %[reduce_reg0], %[c0] \n"
                "vfsum.s %[reduce_reg1], %[c1] \n"
                "vfsum.s %[reduce_reg2], %[c2] \n"
                "vfsum.s %[reduce_reg3], %[c3] \n"
                "vfsum.s %[reduce_reg4], %[c4] \n"
                "vfsum.s %[reduce_reg5], %[c5] \n"
                "vfsum.s %[reduce_reg6], %[c6] \n"
                "vfsum.s %[reduce_reg7], %[c7] \n"
                // Pack and convert results to FP8 vectors
                "vfcpka.b.s %[c0], %[reduce_reg0], %[reduce_reg1] \n"
                "vfcpkb.b.s %[c0], %[reduce_reg2], %[reduce_reg3] \n"
                "vfcpkc.b.s %[c0], %[reduce_reg4], %[reduce_reg5] \n"
                "vfcpkd.b.s %[c0], %[reduce_reg6], %[reduce_reg7] \n"
                : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                  [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                  [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7]),
                  [ c8 ] "+f"(c[8]), [ c9 ] "+f"(c[9]), [ c10 ] "+f"(c[10]),
                  [ c11 ] "+f"(c[11]), [ c12 ] "+f"(c[12]), [ c13 ] "+f"(c[13]),
                  [ c14 ] "+f"(c[14]), [ c15 ] "+f"(c[15]), [ beta ] "=r"(beta),
                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                  [ reduce_reg4 ] "+f"(reduce_reg[4]),
                  [ reduce_reg5 ] "+f"(reduce_reg[5]),
                  [ reduce_reg6 ] "+f"(reduce_reg[6]),
                  [ reduce_reg7 ] "+f"(reduce_reg[7])
                : [ C ] "r"(_C), [ n_frep ] "r"(n_frep), [ BETA ] "r"(BETA),
                  [ zero ] "f"(zero)
                : "ft0", "ft1", "ft2");

            // Store results back
            ((v8f8*)_C)[0] = c[0];
            n += unroll;
        }
    }

    snrt_ssr_disable();
}

void gemm_fp8_ex16_intermediate_and_final_ov_rec(uint32_t M, uint32_t N, uint32_t K, char* A, uint32_t ldA,
                       char* B, uint32_t ldB, char* C, uint32_t ldC,
                       const uint32_t* BETA, uint32_t setup_SSR, uint32_t A_offset, uint32_t compute_num, uint32_t* overflow_final, char* D) {
    char* _C = C;
    // Accumulating currently not implemented
    if (*BETA != 0) return;

    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;
    const uint32_t double_unroll = 16;

    const uint32_t compute_id = snrt_cluster_core_idx();

    // SSR strides and bounds only have to be configured
    // once in the beginning
    if (setup_SSR) {
        uint32_t ssr0_b[4] = {unroll, K / 8, N / unroll, M};
        uint32_t ssr0_i[4] = {0, sizeof(char) * 8, 0, sizeof(char) * ldA};

        uint32_t ssr1_b[4] = {unroll, K / 8, N / unroll, M};
        uint32_t ssr1_i[4] = {sizeof(char) * ldB, sizeof(char) * 8,
                              sizeof(char) * unroll * ldB, 0};

        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);

        snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
    snrt_ssr_enable();

    // Kernel progresses by 8 values each step
    const uint32_t n_frep = K / 8 - 1;

    uint32_t exit = 0;
    uint32_t index_m = 0;
    uint32_t index_n = 0;
    uint32_t overflow_signalling = 1;

return_recovery:
    if (exit) {
        exit = 0;

        snrt_fpu_fence();

        snrt_ssr_flush(SNRT_SSR_DM0, 1); // flush
        snrt_ssr_flush(SNRT_SSR_DM1, 1); // flush
        snrt_ssr_flush(SNRT_SSR_DM2, 1); // flush

        write_csr(1, 0); // clear flags

        snrt_ssr_flush(SNRT_SSR_DM0, 0); // flush
        snrt_ssr_flush(SNRT_SSR_DM1, 0); // flush
        snrt_ssr_flush(SNRT_SSR_DM2, 0); // flush

        // SSR strides and bounds only have to be configured
        // once in the beginning
        if (setup_SSR) {
            uint32_t ssr0_b[4] = {unroll, K / 8, N / unroll, M};
            uint32_t ssr0_i[4] = {0, sizeof(char) * 8, 0, sizeof(char) * ldA};

            uint32_t ssr1_b[4] = {unroll, K / 8, N / unroll, M};
            uint32_t ssr1_i[4] = {sizeof(char) * ldB, sizeof(char) * 8,
                                  sizeof(char) * unroll * ldB, 0};

            uint32_t index = index_m * (N / unroll) + index_n;

            uint32_t index_rem_0 = index % ssr0_b[2];
            uint32_t index_div_0 = index / ssr0_b[2];

            snrt_ssr_idx_ab(SNRT_SSR_DM0, 0, index_rem_0);
            snrt_ssr_idx_cd(SNRT_SSR_DM0, index_div_0, 0);
            snrt_ssr_ptr(SNRT_SSR_DM0, index_rem_0*ssr0_i[2] + index_div_0*ssr0_i[3] + A_offset);

            snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                             ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

            uint32_t index_rem_1 = index % ssr1_b[2];
            uint32_t index_div_1 = index / ssr1_b[2];

            snrt_ssr_idx_ab(SNRT_SSR_DM1, 0, 0);
            snrt_ssr_idx_cd(SNRT_SSR_DM1, index_rem_1, index_div_1);
            snrt_ssr_ptr(SNRT_SSR_DM1, M*compute_num*K*sizeof(char) + index_rem_1*ssr1_i[2] + index_div_1*ssr1_i[3]);

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
        }

        // SSR start address need to be configured each time
        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
        snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
        snrt_ssr_enable();
    }

    for (uint32_t m = index_m; m < M; m++) {
        uint32_t n = 0;
        uint32_t n0 = 0;
        if ((n0 == 0) && (m == index_m)) {
            n0 = index_n;
            n  = n0 * unroll;
        }
        _C = &C[m * ldC + n];
        const register float zero = 0.0;
        register v8f8 c[unroll];
        register v4f16 reduce_reg[unroll];
        uint32_t beta;

        asm volatile(
            "lw         %[beta], 0(%[BETA]) \n"
            "beqz       %[beta], 1f \n"
            "flb fa3, 0(%[C]) \n"
            "flb fa4, 1(%[C]) \n"
            "flb fa5, 2(%[C]) \n"
            "flb fa6, 3(%[C]) \n"
            "flb fa7, 4(%[C]) \n"
            "flb ft8, 5(%[C]) \n"
            "flb ft9, 6(%[C]) \n"
            "flb ft10, 7(%[C]) \n"
            // Convert intermediate results before packing
            "vfcvt.s.b fa3, fa3\n"
            "vfcvt.s.b fa4, fa4\n"
            "vfcvt.s.b fa5, fa5\n"
            "vfcvt.s.b fa6, fa6\n"
            "vfcvt.s.b fa7, fa7\n"
            "vfcvt.s.b ft8, ft8\n"
            "vfcvt.s.b ft9, ft9\n"
            "vfcvt.s.b ft10, ft10\n"
            // Initialize reduce register to zero
            "vfcpka.s.s ft3, %[zero], %[zero]\n"
            "vfcpka.s.s ft4, %[zero], %[zero]\n"
            "vfcpka.s.s ft5, %[zero], %[zero]\n"
            "vfcpka.s.s ft6, %[zero], %[zero]\n"
            "vfcpka.s.s ft7, %[zero], %[zero]\n"
            "vfcpka.s.s fa0, %[zero], %[zero]\n"
            "vfcpka.s.s fa1, %[zero], %[zero]\n"
            "vfcpka.s.s fa2, %[zero], %[zero]\n"
            // Pack intermediate results into SIMD vector
            "vfcpka.h.s ft3, fa3, %[zero]\n"
            "vfcpka.h.s ft4, fa4, %[zero]\n"
            "vfcpka.h.s ft5, fa5, %[zero]\n"
            "vfcpka.h.s ft6, fa6, %[zero]\n"
            "vfcpka.h.s ft7, fa7, %[zero]\n"
            "vfcpka.h.s fa0, ft8, %[zero]\n"
            "vfcpka.h.s fa1, ft9, %[zero]\n"
            "vfcpka.h.s fa2, ft10, %[zero]\n"
            "j 2f \n"
            "1: \n"
            // Initialize SIMD vector with zeros
            "vfcpka.s.s ft3, %[zero], %[zero]\n"
            "vfcpka.s.s ft4, %[zero], %[zero]\n"
            "vfcpka.s.s ft5, %[zero], %[zero]\n"
            "vfcpka.s.s ft6, %[zero], %[zero]\n"
            "vfcpka.s.s ft7, %[zero], %[zero]\n"
            "vfcpka.s.s fa0, %[zero], %[zero]\n"
            "vfcpka.s.s fa1, %[zero], %[zero]\n"
            "vfcpka.s.s fa2, %[zero], %[zero]\n"
            "2: \n"
            // Perform expanding sum-dotproducts
            "3: \n"
            "frep.o  %[n_frep], 8, 0, 0 \n"
            "vfdotpex.h.b ft3, ft1, ft0 \n"
            "vfdotpex.h.b ft4, ft1, ft0 \n"
            "vfdotpex.h.b ft5, ft1, ft0 \n"
            "vfdotpex.h.b ft6, ft1, ft0 \n"
            "vfdotpex.h.b ft7, ft1, ft0 \n"
            "vfdotpex.h.b fa0, ft1, ft0 \n"
            "vfdotpex.h.b fa1, ft1, ft0 \n"
            "vfdotpex.h.b fa2, ft1, ft0 \n"
            // Initialize reduce register to zero
            "vfcpka.s.s fa3, %[zero], %[zero]\n"
            "vfcpka.s.s fa4, %[zero], %[zero]\n"
            "vfcpka.s.s fa5, %[zero], %[zero]\n"
            "vfcpka.s.s fa6, %[zero], %[zero]\n"
            "vfcpka.s.s fa7, %[zero], %[zero]\n"
            "vfcpka.s.s ft8, %[zero], %[zero]\n"
            "vfcpka.s.s ft9, %[zero], %[zero]\n"
            "vfcpka.s.s ft10, %[zero], %[zero]\n"
            // Sum-reduce vector
            "vfsumex.s.h fa3, ft3 \n"
            "vfsumex.s.h fa4, ft4 \n"
            "vfsumex.s.h fa5, ft5 \n"
            "vfsumex.s.h fa6, ft6 \n"
            "vfsumex.s.h fa7, ft7 \n"
            "vfsumex.s.h ft8, fa0 \n"
            "vfsumex.s.h ft9, fa1 \n"
            "vfsumex.s.h ft10, fa2 \n"
            // Initialize reduce register to zero
            "vfcpka.s.s ft3, %[zero], %[zero] \n"
            "vfcpka.s.s ft4, %[zero], %[zero] \n"
            "vfcpka.s.s ft5, %[zero], %[zero] \n"
            "vfcpka.s.s ft6, %[zero], %[zero] \n"
            "vfcpka.s.s ft7, %[zero], %[zero] \n"
            "vfcpka.s.s fa0, %[zero], %[zero] \n"
            "vfcpka.s.s fa1, %[zero], %[zero] \n"
            "vfcpka.s.s fa2, %[zero], %[zero] \n"
            // Sum-reduce vector
            "vfsum.s ft3, fa3 \n"
            "vfsum.s ft4, fa4 \n"
            "vfsum.s ft5, fa5 \n"
            "vfsum.s ft6, fa6 \n"
            "vfsum.s ft7, fa7 \n"
            "vfsum.s fa0, ft8 \n"
            "vfsum.s fa1, ft9 \n"
            "vfsum.s fa2, ft10 \n"
            // Pack and convert results to FP8 vectors
            "vfcpka.b.s ft3, ft3, ft4 \n"
            "vfcpkb.b.s ft3, ft5, ft6 \n"
            "vfcpkc.b.s ft3, ft7, fa0 \n"
            "vfcpkd.b.s ft3, fa1, fa2 \n"
            // ((v8f8*)_C)[0] = c[0];
            "fsd  ft3, 0(%[C]) \n"
            // _C = &C[m * ldC + n];
            "add  %[C], %[C], %[unroll] \n"
            // n += unroll;
            "add  %[n], %[n], %[unroll] \n"
            // n0 += 1;
            "addi %[n0], %[n0], 1 \n"
            // RE-initiliaze
            "lw         %[beta], 0(%[BETA]) \n"
            "beqz       %[beta], 4f \n"
            "flb fa3, 0(%[C]) \n"
            "flb fa4, 1(%[C]) \n"
            "flb fa5, 2(%[C]) \n"
            "flb fa6, 3(%[C]) \n"
            "flb fa7, 4(%[C]) \n"
            "flb ft8, 5(%[C]) \n"
            "flb ft9, 6(%[C]) \n"
            "flb ft10, 7(%[C]) \n"
            // Convert intermediate results before packing
            "vfcvt.s.b fa3, fa3\n"
            "vfcvt.s.b fa4, fa4\n"
            "vfcvt.s.b fa5, fa5\n"
            "vfcvt.s.b fa6, fa6\n"
            "vfcvt.s.b fa7, fa7\n"
            "vfcvt.s.b ft8, ft8\n"
            "vfcvt.s.b ft9, ft9\n"
            "vfcvt.s.b ft10, ft10\n"
            // Initialize reduce register to zero
            "vfcpka.s.s ft3, %[zero], %[zero]\n"
            "vfcpka.s.s ft4, %[zero], %[zero]\n"
            "vfcpka.s.s ft5, %[zero], %[zero]\n"
            "vfcpka.s.s ft6, %[zero], %[zero]\n"
            "vfcpka.s.s ft7, %[zero], %[zero]\n"
            "vfcpka.s.s fa0, %[zero], %[zero]\n"
            "vfcpka.s.s fa1, %[zero], %[zero]\n"
            "vfcpka.s.s fa2, %[zero], %[zero]\n"
            // Pack intermediate results into SIMD vector
            "vfcpka.h.s ft3, fa3, %[zero]\n"
            "vfcpka.h.s ft4, fa4, %[zero]\n"
            "vfcpka.h.s ft5, fa5, %[zero]\n"
            "vfcpka.h.s ft6, fa6, %[zero]\n"
            "vfcpka.h.s ft7, fa7, %[zero]\n"
            "vfcpka.h.s fa0, ft8, %[zero]\n"
            "vfcpka.h.s fa1, ft9, %[zero]\n"
            "vfcpka.h.s fa2, ft10, %[zero]\n"
            "j 5f \n"
            "4: \n"
            // Initialize SIMD vector with zeros
            "vfcpka.s.s ft3, %[zero], %[zero]\n"
            "vfcpka.s.s ft4, %[zero], %[zero]\n"
            "vfcpka.s.s ft5, %[zero], %[zero]\n"
            "vfcpka.s.s ft6, %[zero], %[zero]\n"
            "vfcpka.s.s ft7, %[zero], %[zero]\n"
            "vfcpka.s.s fa0, %[zero], %[zero]\n"
            "vfcpka.s.s fa1, %[zero], %[zero]\n"
            "vfcpka.s.s fa2, %[zero], %[zero]\n"
            "5: \n"
            "bneov        %[n0], %[n_unroll], 3b\n"
            : [ n ] "+r"(n), [ C ] "+r"(_C),
              [ n0 ] "+r"(n0),
              [ beta ] "=r"(beta)
            : [ unroll ] "r"(unroll), [ n_unroll ] "r"(N/unroll),
              // [ n0 ] "r"(n0),
              [ n_frep ] "r"(n_frep), [ BETA ] "r"(BETA),
              [ zero ] "f"(zero)
            : "fa0", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6", "fa7",
              "ft8", "ft9", "ft10", "ft3", "ft4", "ft5", "ft6", "ft7",
              "ft0", "ft1", "ft2");

        unsigned int csr = read_csr(3);
        if (csr & 4) {
            exit = 1;
            index_m = m;
            index_n = n0 - 1;
            goto recovery;
        }
    }
    if (exit == 0){
        unsigned int csr = read_csr(3);
        if (csr & 4) { // (csr & 4) -> OF
            exit = 1;
            index_m = M - 1;
            index_n = (N / unroll) -1;
        }
    }

recovery:
    if (exit) {
        exit = 0;

        snrt_fpu_fence();

        snrt_ssr_flush(SNRT_SSR_DM0, 1); // flush
        snrt_ssr_flush(SNRT_SSR_DM1, 1); // flush
        snrt_ssr_flush(SNRT_SSR_DM2, 1); // flush

        write_csr(1, 0); // clear flags

        snrt_ssr_flush(SNRT_SSR_DM0, 0); // flush
        snrt_ssr_flush(SNRT_SSR_DM1, 0); // flush
        snrt_ssr_flush(SNRT_SSR_DM2, 0); // flush

        // SSR strides and bounds only have to be configured
        // once in the beginning
        if (setup_SSR) {
            uint32_t ssr0_b[4] = {unroll, K / 8, N / unroll, M};
            uint32_t ssr0_i[4] = {0, sizeof(char) * 8, 0, sizeof(char) * ldA};

            uint32_t ssr1_b[4] = {unroll, K / 8, N / unroll, M};
            uint32_t ssr1_i[4] = {sizeof(char) * ldB, sizeof(char) * 8,
                                  sizeof(char) * unroll * ldB, 0};

            uint32_t index = index_m * (N / unroll) + index_n;

            uint32_t index_rem_0 = index % ssr0_b[2];
            uint32_t index_div_0 = index / ssr0_b[2];

            snrt_ssr_idx_ab(SNRT_SSR_DM0, 0, index_rem_0);
            snrt_ssr_idx_cd(SNRT_SSR_DM0, index_div_0, 0);
            snrt_ssr_ptr(SNRT_SSR_DM0, index_rem_0*ssr0_i[2] + index_div_0*ssr0_i[3] + A_offset);

            snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                             ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_repeat(SNRT_SSR_DM0, unroll*2);
            snrt_ssr_repeat(SNRT_SSR_DM1, 2);

            uint32_t index_rem_1 = index % ssr1_b[2];
            uint32_t index_div_1 = index / ssr1_b[2];

            snrt_ssr_idx_ab(SNRT_SSR_DM1, 0, 0);
            snrt_ssr_idx_cd(SNRT_SSR_DM1, index_rem_1, index_div_1);
            snrt_ssr_ptr(SNRT_SSR_DM1, M*compute_num*K*sizeof(char) + index_rem_1*ssr1_i[2] + index_div_1*ssr1_i[3]);

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
        }

        // SSR start address need to be configured each time
        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
        snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
        snrt_ssr_enable();

        for (uint32_t m = index_m; m < M; m++) {
            uint32_t n = 0;
            for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
                if ((n0 == 0) && (m == index_m)) {
                    n0 = index_n;
                    n  = n0 * unroll;
                } else {
                        index_m = m;
                        index_n = n0;
                        exit = 1;
                        goto return_recovery;
                }
                char* _C = &C[m * ldC + n];
                char* _C_new = &D[m * ldC + n];
                const register float zero = 0.0;
                register v8f8 c[double_unroll];
                register v4f16 reduce_reg[unroll];
                uint32_t beta;

                asm volatile(
                    "lw         %[beta], 0(%[BETA]) \n"
                    "beqz       %[beta], 1f \n"
                    "flb %[reduce_reg0], 0(%[C]) \n"
                    "flb %[reduce_reg1], 1(%[C]) \n"
                    "flb %[reduce_reg2], 2(%[C]) \n"
                    "flb %[reduce_reg3], 3(%[C]) \n"
                    "flb %[reduce_reg4], 4(%[C]) \n"
                    "flb %[reduce_reg5], 5(%[C]) \n"
                    "flb %[reduce_reg6], 6(%[C]) \n"
                    "flb %[reduce_reg7], 7(%[C]) \n"
                    // Initialize reduce register to zero
                    "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c8], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c9], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c10], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c11], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c12], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c13], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c14], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c15], %[zero], %[zero]\n"
                    // Convert intermediate results before packing
                    "vfcvt.s.b %[reduce_reg0], %[reduce_reg0]\n"
                    "vfcvt.s.b %[reduce_reg1], %[reduce_reg1]\n"
                    "vfcvt.s.b %[reduce_reg2], %[reduce_reg2]\n"
                    "vfcvt.s.b %[reduce_reg3], %[reduce_reg3]\n"
                    "vfcvt.s.b %[reduce_reg4], %[reduce_reg4]\n"
                    "vfcvt.s.b %[reduce_reg5], %[reduce_reg5]\n"
                    "vfcvt.s.b %[reduce_reg6], %[reduce_reg6]\n"
                    "vfcvt.s.b %[reduce_reg7], %[reduce_reg7]\n"
                    // Pack intermediate results into SIMD vector
                    "vfcpka.s.s %[c0], %[reduce_reg0], %[zero]\n"
                    "vfcpka.s.s %[c2], %[reduce_reg1], %[zero]\n"
                    "vfcpka.s.s %[c4], %[reduce_reg2], %[zero]\n"
                    "vfcpka.s.s %[c6], %[reduce_reg3], %[zero]\n"
                    "vfcpka.s.s %[c8], %[reduce_reg4], %[zero]\n"
                    "vfcpka.s.s %[c10], %[reduce_reg5], %[zero]\n"
                    "vfcpka.s.s %[c12], %[reduce_reg6], %[zero]\n"
                    "vfcpka.s.s %[c14], %[reduce_reg7], %[zero]\n"
                    "j 2f \n"
                    "1: \n"
                    // Initialize SIMD vector with zeros
                    "vfcpka.s.s %[c0], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c1], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c2], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c3], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c4], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c5], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c6], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c7], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c8], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c9], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c10], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c11], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c12], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c13], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c14], %[zero], %[zero]\n"
                    "vfcpka.s.s %[c15], %[zero], %[zero]\n"
                    "2: \n"
                    // Perform expanding sum-dotproducts
                    "frep.o  %[n_frep], 16, 0, 0 \n"
                    "vfdotpexa.s.b %[c0], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c1], ft1, ft0 \n"
                    "vfdotpexa.s.b %[c2], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c3], ft1, ft0 \n"
                    "vfdotpexa.s.b %[c4], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c5], ft1, ft0 \n"
                    "vfdotpexa.s.b %[c6], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c7], ft1, ft0 \n"
                    "vfdotpexa.s.b %[c8], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c9], ft1, ft0 \n"
                    "vfdotpexa.s.b %[c10], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c11], ft1, ft0 \n"
                    "vfdotpexa.s.b %[c12], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c13], ft1, ft0 \n"
                    "vfdotpexa.s.b %[c14], ft1, ft0 \n"
                    "vfdotpexb.s.b %[c15], ft1, ft0 \n"
                    // Reduce double accumulator due to unbalanced sdotp8to32
                    "vfadd.s %[c0], %[c0], %[c1] \n"
                    "vfadd.s %[c1], %[c2], %[c3] \n"
                    "vfadd.s %[c2], %[c4], %[c5] \n"
                    "vfadd.s %[c3], %[c6], %[c7] \n"
                    "vfadd.s %[c4], %[c8], %[c9] \n"
                    "vfadd.s %[c5], %[c10], %[c11] \n"
                    "vfadd.s %[c6], %[c12], %[c13] \n"
                    "vfadd.s %[c7], %[c14], %[c15] \n"
                    // Initialize reduce register to zero
                    "vfcpka.s.s %[reduce_reg0], %[zero], %[zero]\n"
                    "vfcpka.s.s %[reduce_reg1], %[zero], %[zero]\n"
                    "vfcpka.s.s %[reduce_reg2], %[zero], %[zero]\n"
                    "vfcpka.s.s %[reduce_reg3], %[zero], %[zero]\n"
                    "vfcpka.s.s %[reduce_reg4], %[zero], %[zero]\n"
                    "vfcpka.s.s %[reduce_reg5], %[zero], %[zero]\n"
                    "vfcpka.s.s %[reduce_reg6], %[zero], %[zero]\n"
                    "vfcpka.s.s %[reduce_reg7], %[zero], %[zero]\n"
                    // Sum-reduce vector
                    "vfsum.s %[reduce_reg0], %[c0] \n"
                    "vfsum.s %[reduce_reg1], %[c1] \n"
                    "vfsum.s %[reduce_reg2], %[c2] \n"
                    "vfsum.s %[reduce_reg3], %[c3] \n"
                    "vfsum.s %[reduce_reg4], %[c4] \n"
                    "vfsum.s %[reduce_reg5], %[c5] \n"
                    "vfsum.s %[reduce_reg6], %[c6] \n"
                    "vfsum.s %[reduce_reg7], %[c7] \n"
                    // Pack and convert results to FP8 vectors
                    "vfcpka.b.s %[c0], %[reduce_reg0], %[reduce_reg1] \n"
                    "vfcpkb.b.s %[c0], %[reduce_reg2], %[reduce_reg3] \n"
                    "vfcpkc.b.s %[c0], %[reduce_reg4], %[reduce_reg5] \n"
                    "vfcpkd.b.s %[c0], %[reduce_reg6], %[reduce_reg7] \n"
                    // Pack and convert results to FP16alt vectors
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "fsd     %[c0], 0(%[C]) \n"
                    "csrwi    2048, 1 \n"
                    "vfcpka.ah.s %[c2], %[reduce_reg0], %[reduce_reg1] \n"
                    "vfcpkb.ah.s %[c2], %[reduce_reg2], %[reduce_reg3] \n"
                    "vfcpka.ah.s %[c3], %[reduce_reg4], %[reduce_reg5] \n"
                    "vfcpkb.ah.s %[c3], %[reduce_reg6], %[reduce_reg7] \n"
                    // Integer core waits for FP datapath to complete all calculations before checking the FCSR
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "nop \n"
                    "beqov   x0, x0, 3f \n"
                    "fsd     %[c2], 0(%[C_new]) \n"
                    "fsd     %[c3], 8(%[C_new]) \n"
                    // Record that a final overflow occurred
                    "sw      %[overflow_signalling], 0(%[overflow_final]) \n"
                    "3: \n"
                    "csrwi    2048, 0 \n"
                    : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                      [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                      [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7]),
                      [ c8 ] "+f"(c[8]), [ c9 ] "+f"(c[9]), [ c10 ] "+f"(c[10]),
                      [ c11 ] "+f"(c[11]), [ c12 ] "+f"(c[12]), [ c13 ] "+f"(c[13]),
                      [ c14 ] "+f"(c[14]), [ c15 ] "+f"(c[15]), [ beta ] "=r"(beta),
                      [ reduce_reg0 ] "+f"(reduce_reg[0]),
                      [ reduce_reg1 ] "+f"(reduce_reg[1]),
                      [ reduce_reg2 ] "+f"(reduce_reg[2]),
                      [ reduce_reg3 ] "+f"(reduce_reg[3]),
                      [ reduce_reg4 ] "+f"(reduce_reg[4]),
                      [ reduce_reg5 ] "+f"(reduce_reg[5]),
                      [ reduce_reg6 ] "+f"(reduce_reg[6]),
                      [ reduce_reg7 ] "+f"(reduce_reg[7])
                    : [ C ] "r"(_C), [ C_new ] "r"(_C_new), [ n_frep ] "r"(n_frep), [ BETA ] "r"(BETA),
                      [overflow_final] "r" (overflow_final), [overflow_signalling] "r" (overflow_signalling),
                      [ zero ] "f"(zero)
                    : "ft0", "ft1", "ft2", "a1", "a2");

                n += unroll;
            }
        }
    }

quit:
    snrt_ssr_disable();
}

// BLAS compliant GEMM kernel, with some additional arguments at the beginning
// to specify Snitch implementation details. Matrix sizes and pointers are for
// the whole cluster computation
// TODO: beta (and alpha) should be of floating-point type (same precision as
// operands)
void gemm(precision_t prec, uint32_t expand, uint32_t expand_to_fp32, uint32_t overflow_recovery,
          uint32_t setup_ssr, uint32_t transa, uint32_t transb, uint32_t m, uint32_t n, uint32_t k,
          double alpha, void* a, uint32_t lda, void* b, uint32_t ldb,
          uint32_t beta, void* c, uint32_t ldc, uint32_t* overflow_final, void* d) {
    const uint32_t compute_num = snrt_cluster_compute_core_num();
    const uint32_t compute_id = snrt_cluster_core_idx();

    // Compute cores work not on contiguous blocks but on strided rows
    uint32_t lda_strided = compute_num * lda;
    uint32_t ldc_strided = compute_num * ldc;

    // Compute cores access A and C at offsets of one row from each other
    uint32_t offsetA = compute_id * lda;
    uint32_t offsetC = compute_id * ldc;

    // Compute fraction of C rows every core computes
    uint32_t frac_m = m / compute_num;

    switch (prec) {
        case FP64:
            gemm_fp64_opt(frac_m, n, k, (double*)a + offsetA, lda_strided,
                          transa, (double*)b, ldb, transb, (double*)c + offsetC,
                          ldc_strided, &beta, setup_ssr);
            break;
        case FP32:
            gemm_fp32_opt(frac_m, n, k, (float*)a + offsetA, lda_strided,
                          (float*)b, ldb, (float*)c + offsetC, ldc_strided,
                          &beta, setup_ssr);
            break;
        case FP16:
            if (expand || expand_to_fp32) {
                gemm_fp16_ex_opt(
                    frac_m, n, k, (__fp16*)a + offsetA, lda_strided, (__fp16*)b,
                    ldb, (__fp16*)c + offsetC, ldc_strided, &beta, setup_ssr);
            } else {
                gemm_fp16_opt(frac_m, n, k, (__fp16*)a + offsetA, lda_strided,
                              (__fp16*)b, ldb, (__fp16*)c + offsetC,
                              ldc_strided, &beta, setup_ssr);
            }
            break;
        case FP8:
            if (overflow_recovery) {
                gemm_fp8_ex16_intermediate_and_final_ov_rec(frac_m, n, k, (char*)a + offsetA, lda_strided,
                                (char*)b, ldb, (char*)c + offsetC, ldc_strided, &beta,
                                setup_ssr, offsetA, compute_num, overflow_final, (char*)d);
            } else if (expand_to_fp32) {
                gemm_fp8_ex32_opt(frac_m, n, k, (char*)a + offsetA, lda_strided,
                                (char*)b, ldb, (char*)c + offsetC, ldc_strided,
                                &beta, setup_ssr);
            } else if (expand) {
                gemm_fp8_ex_opt(frac_m, n, k, (char*)a + offsetA, lda_strided,
                                (char*)b, ldb, (char*)c + offsetC, ldc_strided,
                                &beta, setup_ssr);
            }
            break;
    }
}
