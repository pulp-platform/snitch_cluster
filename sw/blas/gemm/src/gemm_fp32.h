// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

void gemm_fp32_naive(uint32_t M, uint32_t N, uint32_t K, float* A, uint32_t ldA,
                     uint32_t ta, float* B, uint32_t ldB, uint32_t tb, float* C,
                     uint32_t ldC, float BETA) {
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

void gemm_fp32_naive_unrolled(uint32_t M, uint32_t N, uint32_t K, float* A,
                              uint32_t ldA, uint32_t ta, float* B, uint32_t ldB,
                              uint32_t tb, float* C, uint32_t ldC, float BETA) {
    float c0 = 0.0f;
    float c1 = 0.0f;
    float c2 = 0.0f;
    float c3 = 0.0f;
    if (!ta && !tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
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
                if (BETA == 0.0f) {
                    c0 = 0.0f;
                } else {
                    c0 = BETA * C[m * ldC + n];
                }
                c1 = 0.0f;
                c2 = 0.0f;
                c3 = 0.0f;
                for (uint32_t k = 0; k < K; k += 4) {
                    c0 += A[(k + 0) + m * ldA] * B[(k + 0) + n * ldB];
                    c1 += A[(k + 1) + m * ldA] * B[(k + 1) + n * ldB];
                    c2 += A[(k + 2) + m * ldA] * B[(k + 2) + n * ldB];
                    c3 += A[(k + 3) + m * ldA] * B[(k + 3) + n * ldB];
                }
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

void gemm_fp32_baseline(const uint32_t M, const uint32_t N, const uint32_t K,
                        float* A, const uint32_t ldA, float* B,
                        const uint32_t ldB, float* C, const uint32_t ldC,
                        const uint32_t BETA) {
    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (; n < N; n++) {
            volatile register v2f32 *a_ptr, *b_ptr;
            register v2f32 a, b;
            volatile float* c_ptr;
            const register float zero = 0.0;
            double c = 0.0;
            v2f32 reduce_reg;

            a_ptr = (v2f32*)(&A[m * ldA]);
            b_ptr = (v2f32*)(&B[n * ldB]);
            c_ptr = &C[m * ldC + n];
            // Don't accumulate in first iteration
            asm volatile(
                "beqz    %[BETA], 1f \n"
                // Load intermediate results
                "flw ft2, 0(%[C]) \n"
                "vfcpka.s.s ft2, ft2, %[zero]\n"
                // or initialize with zero
                "j 2f \n"
                "1: \n"
                "vfcpka.s.s ft2, %[zero], %[zero]\n"
                // Don't accumulate in first iteration
                "2: \n"
                "fld ft0, 0(%[a_ptr]) \n"
                "fld ft1, 0(%[b_ptr]) \n"
                "add %[a_ptr], %[a_ptr], 8 \n"
                "add %[b_ptr], %[b_ptr], 8 \n"
                "vfmul.s ft3, ft0, ft1 \n"
                // loop over the MACs
                "li     t0, 2 \n"
                "3: \n"
                "fld ft0, 0(%[a_ptr]) \n"
                "fld ft1, 0(%[b_ptr]) \n"
                "vfmac.s ft3, ft0, ft1 \n"
                "add %[a_ptr], %[a_ptr], 8 \n"
                "add %[b_ptr], %[b_ptr], 8 \n"
                "addi  t0, t0, 2 \n"
                "blt   t0, %[K], 3b \n"
                // Sum reduce vector
                "vfsum.s ft2, ft3 \n"
                // Store results
                "fsw ft2, 0(%[C]) \n"
                : [ a_ptr ] "+r"(a_ptr), [ b_ptr ] "+r"(b_ptr)
                : [ c ] "f"(c), [ reduce_reg ] "f"(reduce_reg),
                  [ C ] "r"(c_ptr), [ BETA ] "r"(BETA), [ K ] "r"(K),
                  [ zero ] "f"(zero)
                : "ft0", "ft1", "ft2", "ft3", "ft4", "t0");
        }
    }
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
                "frep.o  %[n_frep], %[unroll], 0, 0 \n"
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
                  [ unroll ] "i"(unroll), [ BETA ] "r"(BETA)
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
