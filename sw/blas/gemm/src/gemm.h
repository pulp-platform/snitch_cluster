// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

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

// Floating-point multiplications by zero cannot be optimized as in some
// edge cases they do not yield zero:
// - 0f * NaN = NaN
// - 0f * INFINITY == NaN
// Thus in order to optimize it, we need to test for zero. You can use this
// function for free when `multiplier` is a constant.
static inline double multiply_opt(double multiplicand, double multiplier) {
    if (multiplier)
        return multiplicand * multiplier;
    else
        return 0;
}

void gemm_fp32_baseline(uint32_t M, uint32_t N, uint32_t K, float* A,
                        uint32_t ldA, uint32_t ta, float* B, uint32_t ldB,
                        uint32_t tb, float* C, uint32_t ldC, float BETA) {
    if (!ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                float c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k + m * ldA] * B[k * ldB + n];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else if (ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                float c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * ldA + m * ldA] * B[k * ldB + n];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else if (!ta && tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                float c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k + m * ldA] * B[k + n * ldB];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                float c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * ldA + m * ldA] * B[k + n * ldB];
                }
                C[m * ldC + n] = c0;
            }
        }
    }
}

void gemm_fp64_baseline(uint32_t M, uint32_t N, uint32_t K, double* A,
                        uint32_t ldA, uint32_t ta, double* B, uint32_t ldB,
                        uint32_t tb, double* C, uint32_t ldC, double* BETA) {
    if (!ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                double c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k + m * ldA] * B[k * ldB + n];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else if (ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                double c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * ldA + m * ldA] * B[k * ldB + n];
                }
                C[m * ldC + n] = c0;
            }
        }
    } else if (!ta && tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                double c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    // dump_index(k + m * ldA);
                    // dump_gemm(A[k + m * ldA]);
                    // dump_gemm(B[k + n * ldB]);
                    c0 += A[k + m * ldA] * B[k + n * ldB];
                }
                C[m * ldC + n] = c0;
                // dump_gemm(C[m * ldC + n]);
            }
        }
    } else {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                double c0 = multiply_opt(C[m * ldC + n], BETA);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * ldA + m * ldA] * B[k + n * ldB];
                }
                C[m * ldC + n] = c0;
            }
        }
    }
}

/* params:
 * M: number of rows of A and C
 * N: number of columns of B and C
 * K: number of columns of A and rows of B
 * A: pointer to matrix A
 * ldA: row stride of A
 * ta: transpose A
 * B: pointer to matrix B
 * ldB: row stride of B
 * tb: transpose B
 * C: pointer to matrix C
 * ldC: row stride of C
 * BETA: scalar beta
 * A is MxK, B is KxN, C is MxN
 */
void gemm_fp32_baseline_unrolled(uint32_t M, uint32_t N, uint32_t K, float* A,
                                 uint32_t ldA, uint32_t ta, float* B,
                                 uint32_t ldB, uint32_t tb, float* C,
                                 uint32_t ldC, float BETA) {
    // float c0, c1, c2, c3 = 0;
    float c0 = 0.0f;
    float c1 = 0.0f;
    float c2 = 0.0f;
    float c3 = 0.0f;
    if (!ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                // register float c0 = BETA * C[m * ldC + n];
                // c0, c1, c2, c3 = 0;
                if (BETA == 0.0f) {
                    c0 = 0.0f;
                } else {
                    c0 = BETA * C[m * ldC + n];
                }
                c1 = 0.0f;
                c2 = 0.0f;
                c3 = 0.0f;
                for (uint32_t k = 0; k < K; k += 4) {
                    c0 += A[(k + 0) + m * ldA] * B[(k + 0) * ldB + n];
                    c1 += A[(k + 1) + m * ldA] * B[(k + 1) * ldB + n];
                    c2 += A[(k + 2) + m * ldA] * B[(k + 2) * ldB + n];
                    c3 += A[(k + 3) + m * ldA] * B[(k + 3) * ldB + n];
                }
                C[m * ldC + n] = c0 + c1 + c2 + c3;
            }
        }
    } else if (ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                // register float c0 = BETA * C[m * ldC + n];
                if (BETA == 0.0f) {
                    c0 = 0.0f;
                } else {
                    c0 = BETA * C[m * ldC + n];
                }
                c1 = 0.0f;
                c2 = 0.0f;
                c3 = 0.0f;
                for (uint32_t k = 0; k < K; k += 4) {
                    c0 += A[(k + 0) * M * ldA + m * ldA] * B[(k + 0) * ldB + n];
                    c1 += A[(k + 1) * M * ldA + m * ldA] * B[(k + 1) * ldB + n];
                    c2 += A[(k + 2) * M * ldA + m * ldA] * B[(k + 2) * ldB + n];
                    c3 += A[(k + 3) * M * ldA + m * ldA] * B[(k + 3) * ldB + n];
                }
                C[m * ldC + n] = c0 + c1 + c2 + c3;
            }
        }
    } else if (!ta && tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                // register float c0 = BETA * C[m * ldC + n];
                if (BETA == 0.0f) {
                    c0 = 0.0f;
                } else {
                    c0 = BETA * C[m * ldC + n];
                }
                c1 = 0.0f;
                c2 = 0.0f;
                c3 = 0.0f;
                for (uint32_t k = 0; k < K; k += 4) {
                    // c0 += A[k + m * ldA] * B[k + n * ldB];
                    c0 += A[(k + 0) + m * ldA] * B[(k + 0) + n * ldB];
                    c1 += A[(k + 1) + m * ldA] * B[(k + 1) + n * ldB];
                    c2 += A[(k + 2) + m * ldA] * B[(k + 2) + n * ldB];
                    c3 += A[(k + 3) + m * ldA] * B[(k + 3) + n * ldB];
                }
                // C[m * ldC + n] = c0;
                C[m * ldC + n] = c0 + c1 + c2 + c3;
            }
        }
    } else {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                register float c0 = BETA * C[m * ldC + n];
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
    // const uint32_t unroll = 8;
    const uint32_t unroll = 4;

    // A is of size MxK, B is of size KxN, C is of size MxN
    // for (uint32_t m = 0; m < M; m++) {
    //     for (uint32_t n = 0; n < N / unroll; n++) {
    //         double c0 = BETA * C[m * ldC + n];
    //         for (uint32_t k = 0; k < K; k++) {
    //             for (uint32_t j = 0; j < unroll; j++) {
    //                 c0 += A[k +  m * ldA] * B[k + (n + j) * ldB];
    //             }
    //         }
    //         C[m * ldC + n] = c0;
    //     }
    // }
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

            // A[k + unroll * m * ldA]
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

            // B[k + unroll * n * ldB]
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
                // c[4] = C[m * ldC + n + 4];
                // c[5] = C[m * ldC + n + 5];
                // c[6] = C[m * ldC + n + 6];
                // c[7] = C[m * ldC + n + 7];
            } else {
                c[0] = 0.0;
                c[1] = 0.0;
                c[2] = 0.0;
                c[3] = 0.0;
                // c[4] = 0.0;
                // c[5] = 0.0;
                // c[6] = 0.0;
                // c[7] = 0.0;
            }
            asm volatile(
                "frep.o %[n_frep], %[unroll], 0, 0 \n"
                "fmadd.d %[c0], ft0, ft1, %[c0] \n"
                "fmadd.d %[c1], ft0, ft1, %[c1] \n"
                "fmadd.d %[c2], ft0, ft1, %[c2] \n"
                "fmadd.d %[c3], ft0, ft1, %[c3] \n"
                // "fmadd.d %[c4], ft0, ft1, %[c4] \n"
                // "fmadd.d %[c5], ft0, ft1, %[c5] \n"
                // "fmadd.d %[c6], ft0, ft1, %[c6] \n"
                // "fmadd.d %[c7], ft0, ft1, %[c7] \n"
                : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
                  [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
                  [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7])
                : [ n_frep ] "r"(K - 1), [ unroll ] "i"(unroll)
                : "ft0", "ft1", "ft2");

            // Store results back
            C[m * ldC + n + 0] = c[0];
            C[m * ldC + n + 1] = c[1];
            C[m * ldC + n + 2] = c[2];
            C[m * ldC + n + 3] = c[3];
            // C[m * ldC + n + 4] = c[4];
            // C[m * ldC + n + 5] = c[5];
            // C[m * ldC + n + 6] = c[6];
            // C[m * ldC + n + 7] = c[7];
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
    // const uint32_t unroll = 8;
    const uint32_t unroll = 4;

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
                // "flw %[reduce_reg4], 16(%[C]) \n"
                // "flw %[reduce_reg5], 20(%[C]) \n"
                // "flw %[reduce_reg6], 24(%[C]) \n"
                // "flw %[reduce_reg7], 28(%[C]) \n"
                // Pack intermediate results into SIMD vector
                "vfcpka.s.s %[reduce_reg0], %[reduce_reg0], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[reduce_reg1], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[reduce_reg2], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[reduce_reg3], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg4], %[reduce_reg4], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg5], %[reduce_reg5], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg6], %[reduce_reg6], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg7], %[reduce_reg7], %[zero]\n"
                "j 2f \n"
                "1: \n"
                // Initialize SIMD vector with zeros
                "vfcpka.s.s %[reduce_reg0], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg1], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg2], %[zero], %[zero]\n"
                "vfcpka.s.s %[reduce_reg3], %[zero], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg4], %[zero], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg5], %[zero], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg6], %[zero], %[zero]\n"
                // "vfcpka.s.s %[reduce_reg7], %[zero], %[zero]\n"

                "2: \n"
                // Don't accumulate in first iteration
                "vfmul.s %[c0], ft1, ft0 \n"
                "vfmul.s %[c1], ft1, ft0 \n"
                "vfmul.s %[c2], ft1, ft0 \n"
                "vfmul.s %[c3], ft1, ft0 \n"
                // "vfmul.s %[c4], ft1, ft0 \n"
                // "vfmul.s %[c5], ft1, ft0 \n"
                // "vfmul.s %[c6], ft1, ft0 \n"
                // "vfmul.s %[c7], ft1, ft0 \n"
                // frep over MACs
                "frep.o  %[n_frep], %[unroll], 0, 0 \n"
                "vfmac.s %[c0], ft1, ft0 \n"
                "vfmac.s %[c1], ft1, ft0 \n"
                "vfmac.s %[c2], ft1, ft0 \n"
                "vfmac.s %[c3], ft1, ft0 \n"
                // "vfmac.s %[c4], ft1, ft0 \n"
                // "vfmac.s %[c5], ft1, ft0 \n"
                // "vfmac.s %[c6], ft1, ft0 \n"
                // "vfmac.s %[c7], ft1, ft0 \n"
                // Sum-reduce vector
                "vfsum.s %[reduce_reg0], %[c0] \n"
                "vfsum.s %[reduce_reg1], %[c1] \n"
                "vfsum.s %[reduce_reg2], %[c2] \n"
                "vfsum.s %[reduce_reg3], %[c3] \n"
                // "vfsum.s %[reduce_reg4], %[c4] \n"
                // "vfsum.s %[reduce_reg5], %[c5] \n"
                // "vfsum.s %[reduce_reg6], %[c6] \n"
                // "vfsum.s %[reduce_reg7], %[c7] \n"
                // Pack results together again into vectors
                "vfcpka.s.s %[c0], %[reduce_reg0], %[reduce_reg1] \n"
                "vfcpka.s.s %[c1], %[reduce_reg2], %[reduce_reg3] \n"
                // "vfcpka.s.s %[c2], %[reduce_reg4], %[reduce_reg5] \n"
                // "vfcpka.s.s %[c3], %[reduce_reg6], %[reduce_reg7] \n"
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
                  [ unroll ] "i"(unroll), [ BETA ] "r"(BETA)
                : "ft0", "ft1", "ft2");

            // Store results
            ((v2f32*)_C)[0] = c[0];
            ((v2f32*)_C)[1] = c[1];
            // ((v2f32*)_C)[2] = c[2];
            // ((v2f32*)_C)[3] = c[3];

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
                "frep.o  %[n_frep], %[unroll], 0, 0 \n"
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
                  [ unroll ] "i"(unroll), [ BETA ] "r"(BETA)
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
                "frep.o  %[n_frep], %[unroll], 0, 0 \n"
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
                  [ unroll ] "i"(unroll), [ zero ] "f"(zero)
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

// BLAS compliant single-cluster single-tile GEMM kernel, with some additional
// arguments at the beginning to specify Snitch implementation details. Matrix
// sizes and pointers are for the whole cluster computation. Within a cluster
// the computation is parallelized by assigning distinct output rows to
// distinct cores.
// TODO: beta (and alpha) should be of floating-point type (same precision as
// operands)
void sc_st_gemm(precision_t prec, uint32_t expand, uint32_t setup_ssr,
                uint32_t transa, uint32_t transb, uint32_t m, uint32_t n,
                uint32_t k, double alpha, void* a, uint32_t lda, void* b,
                uint32_t ldb, uint32_t beta, void* c, uint32_t ldc) {
    if (snrt_is_compute_core()) {
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
                // gemm_fp64_opt(frac_m, n, k, (double*)a + offsetA,
                // lda_strided,
                //               transa, (double*)b, ldb, transb, (double*)c +
                //               offsetC, ldc_strided, &beta, setup_ssr);
                gemm_fp64_baseline(frac_m, n, k, (double*)a + offsetA,
                                   lda_strided, transa, (double*)b, ldb, transb,
                                   (double*)c + offsetC, ldc_strided,
                                   (double)beta);
                break;
            case FP32:
                gemm_fp32_baseline(frac_m, n, k, (float*)a + offsetA,
                                   lda_strided, transa, (float*)b, ldb, transb,
                                   (float*)c + offsetC, ldc_strided,
                                   (float)beta);
                // gemm_fp32_opt(frac_m, n, k, (float*)a + offsetA, lda_strided,
                //             (float*)b, ldb, (float*)c + offsetC, ldc_strided,
                //             &beta, setup_ssr);
                break;
            case FP16:
                if (expand) {
                    gemm_fp16_ex_opt(frac_m, n, k, (__fp16*)a + offsetA,
                                     lda_strided, (__fp16*)b, ldb,
                                     (__fp16*)c + offsetC, ldc_strided, &beta,
                                     setup_ssr);
                } else {
                    gemm_fp16_opt(frac_m, n, k, (__fp16*)a + offsetA,
                                  lda_strided, (__fp16*)b, ldb,
                                  (__fp16*)c + offsetC, ldc_strided, &beta,
                                  setup_ssr);
                }
                break;
            case FP8:
                gemm_fp8_ex_opt(frac_m, n, k, (char*)a + offsetA, lda, (char*)b,
                                ldb, (char*)c + offsetC, ldc_strided, &beta,
                                setup_ssr);
                break;
        }
    }
}

// Multiple-cluster multiple-tile GEMM implementation.
// If parallelize_m, assigns a distinct subset of M-tiles to distinct clusters.
// If parallelize_k, then K-tiles are distributed to distinct clusters; a
// binary reduction tree is implemented to accumulate these tiles together.
// Note: in the current implementation, parallelize_m and parallelize_k
// should be mutually-exclusive. The load_* options allow to bypass the DMA
// transfers and operate directly on the a, b and c inputs.
// m_tiles: number of tiles in M dimension
// k_tiles: number of tiles in K dimension
// n_tiles: number of tiles in N dimension
int gemm(precision_t prec, uint32_t expand, uint32_t setup_ssr,
         uint32_t parallelize_m, uint32_t parallelize_k,
         uint32_t m_tiles, uint32_t n_tiles, uint32_t k_tiles,
         uint32_t load_a, uint32_t load_b, uint32_t load_c,
         uint32_t transa, uint32_t transb, uint32_t m,
         uint32_t n, uint32_t k, double alpha, void* a, void* b, uint32_t beta,
         void* c) {
    // Calculate tile sizes
    uint32_t frac_m = m / m_tiles;
    uint32_t frac_n = n / n_tiles;
    uint32_t frac_k = k / k_tiles;
    uint32_t frac_a = frac_m * frac_k;
    uint32_t frac_c = frac_m * frac_n;
    uint32_t size_frac_a = frac_a * prec;
    uint32_t size_frac_b = frac_k * frac_n * prec;
    uint32_t size_frac_c = frac_c * prec;

    // Allocate space in TCDM
    void *local_a, *local_b, *local_c_partial, *local_c;
    void *heap_ptr = (void*)snrt_l1_next();
    if (load_a) {
        local_a = heap_ptr;
        heap_ptr += size_frac_a;
    } else local_a = a;
    if (load_b) {
        local_b = heap_ptr;
        heap_ptr += size_frac_b;
    } else local_b = b;
    if (load_c) {
        local_c_partial = heap_ptr;
        heap_ptr += size_frac_c;
    } else local_c_partial = c;
    local_c = parallelize_k ? heap_ptr : local_c_partial;

    // Assign m and k tiles to clusters
    uint32_t m_tiles_per_cluster = parallelize_m ?
        m_tiles / snrt_cluster_num() : m_tiles;
    uint32_t k_tiles_per_cluster = parallelize_k ?
        k_tiles / snrt_cluster_num() : k_tiles;
    
    // Every cluster iterates over its subset of m tiles
    for (uint32_t m_tile = 0; m_tile < m_tiles_per_cluster; m_tile++) {
        for (uint32_t n_tile = 0; n_tile < n_tiles; n_tile++) {

            // Calculate absolute m tile index for the current cluster
            uint32_t abs_m_tile_idx = !parallelize_m ? m_tile :
                snrt_cluster_idx() * m_tiles_per_cluster + m_tile;

            // k accumulation loop
            for (uint32_t k_tile = 0; k_tile < k_tiles_per_cluster; k_tile++) {

                // Calculate absolute k tile index for the current cluster
                uint32_t abs_k_tile_idx = !parallelize_k ? k_tile :
                    snrt_cluster_idx() * k_tiles_per_cluster + k_tile;

                // Copy data in TCDM
                if (snrt_is_dm_core()) {
                    if (load_a) {
                        snrt_dma_load_2d_tile(local_a, a,
                                              abs_m_tile_idx, abs_k_tile_idx,
                                              frac_m, frac_k, k, prec);
                    }
                    if (load_b) {
                        snrt_dma_load_2d_tile(local_b, b,
                                              abs_k_tile_idx, n_tile,
                                              frac_k, frac_n, n, prec);
                    }
                    // C tile is loaded only upon first iteration, then the C
                    // array will contain the partial results from the
                    // previous iteration
                    if (load_c) {
                        if (abs_k_tile_idx == 0) {
                            snrt_dma_load_2d_tile(local_c_partial, c,
                                                  abs_m_tile_idx, n_tile,
                                                  frac_m, frac_n, n, prec);
                        } else if (k_tile == 0) {
                            snrt_dma_start_1d(local_c_partial,
                                              (void *)snrt_zero_memory_ptr(),
                                              frac_m * frac_n * prec);
                        }
                    }
                    snrt_dma_wait_all();
                }

                snrt_cluster_hw_barrier();

                // Compute
                if (!snrt_is_dm_core()) {
                    uint32_t start_cycle = snrt_mcycle();

                    volatile uint32_t lda = frac_k;
                    volatile uint32_t ldb = frac_n;
                    volatile uint32_t ldc = frac_n;

                    // Transpose of A unsupported
                    if (transa) return -1;
                    if (transb) {
                        // Transpose of B supported only in FP64
                        if (prec != FP64) return -1;
                        ldb = frac_k;
                    }

                    // In the first K iteration we accumulate with the C matrix
                    // scaled by beta, in successive iterations we accumulate
                    // the previous partial result for the tile
                    uint32_t beta_k;
                    if (abs_k_tile_idx == 0) {
                        beta_k = beta;
                    } else {
                        beta_k = 1;
                    }

                    sc_st_gemm(prec, expand, setup_ssr, transa, transb, frac_m,
                               frac_n, frac_k, 1, local_a, lda, local_b, ldb,
                               beta_k, local_c_partial, ldc);

                    uint32_t end_cycle = snrt_mcycle();
                }

                snrt_cluster_hw_barrier();
            }

            // Add the partial results from the various clusters together in a
            // logarithmic reduction fashion
            if (parallelize_k) {
                snrt_global_reduction_dma((double *)local_c, (double *)local_c_partial,
                    frac_m * frac_n);
            }

            // Copy data out of TCDM
            if (snrt_is_dm_core()) {
                // If parallelize_k, then only cluster 0 must writeback
                if ((snrt_cluster_idx() == 0) || !parallelize_k) {
                    snrt_dma_store_2d_tile(c, local_c,
                                        abs_m_tile_idx, n_tile,
                                        frac_m, frac_n, n, prec);
                    snrt_dma_wait_all();
                }
            }
        }
    }

    return 0;
}
