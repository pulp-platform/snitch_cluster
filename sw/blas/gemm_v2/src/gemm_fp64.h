// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

void gemm_fp64_naive(uint32_t M, uint32_t N, uint32_t K, void* A_p,
                     uint32_t ldA, uint32_t ta, void* B_p, uint32_t ldB,
                     uint32_t tb, void* C_p, uint32_t ldC, uint32_t BETA,
                     uint32_t setup_SSR) {
    double* A = (double*)A_p;
    double* B = (double*)B_p;
    double* C = (double*)C_p;

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
                    c0 += A[k + m * ldA] * B[k + n * ldB];
                }
                C[m * ldC + n] = c0;
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

void gemm_fp64_baseline(uint32_t M, uint32_t N, uint32_t K, void* A_p,
                        uint32_t ldA, uint32_t ta, void* B_p, uint32_t ldB,
                        uint32_t tb, void* C_p, uint32_t ldC, uint32_t BETA,
                        uint32_t setup_SSR) {
    double* A = (double*)A_p;
    double* B = (double*)B_p;
    double* C = (double*)C_p;

    // Unrolling factors
    // Note: changes must be reflected in the inline assembly code
    //       and datagen script
    const uint32_t unroll1 = 4;
    const uint32_t unroll0 = 4;

    if (!ta && tb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n += unroll1) {

                double acc[4];
                acc[0] = multiply_opt(C[m * ldC + n + 0], BETA);
                acc[1] = multiply_opt(C[m * ldC + n + 1], BETA);
                acc[2] = multiply_opt(C[m * ldC + n + 2], BETA);
                acc[3] = multiply_opt(C[m * ldC + n + 3], BETA);

                for (uint32_t k = 0; k < K; k += unroll0) {
                    asm volatile(
                        "fmadd.d %[acc0], %[A0], %[B0], %[acc0] \n"
                        "fmadd.d %[acc1], %[A0], %[B1], %[acc1] \n"
                        "fmadd.d %[acc2], %[A0], %[B2], %[acc2] \n"
                        "fmadd.d %[acc3], %[A0], %[B3], %[acc3] \n"
                        "fmadd.d %[acc0], %[A1], %[B4], %[acc0] \n"
                        "fmadd.d %[acc1], %[A1], %[B5], %[acc1] \n"
                        "fmadd.d %[acc2], %[A1], %[B6], %[acc2] \n"
                        "fmadd.d %[acc3], %[A1], %[B7], %[acc3] \n"
                        "fmadd.d %[acc0], %[A2], %[B8], %[acc0] \n"
                        "fmadd.d %[acc1], %[A2], %[B9], %[acc1] \n"
                        "fmadd.d %[acc2], %[A2], %[B10], %[acc2] \n"
                        "fmadd.d %[acc3], %[A2], %[B11], %[acc3] \n"
                        "fmadd.d %[acc0], %[A3], %[B12], %[acc0] \n"
                        "fmadd.d %[acc1], %[A3], %[B13], %[acc1] \n"
                        "fmadd.d %[acc2], %[A3], %[B14], %[acc2] \n"
                        "fmadd.d %[acc3], %[A3], %[B15], %[acc3] \n"
                        : [ acc0 ] "+f"(acc[0]), [ acc1 ] "+f"(acc[1]),
                        [ acc2 ] "+f"(acc[2]), [ acc3 ] "+f"(acc[3])
                        :
                        [ A0 ] "f"(A[m * ldA + k + 0]), [ A1 ] "f"(A[m * ldA + k + 1]),
                        [ A2 ] "f"(A[m * ldA + k + 2]), [ A3 ] "f"(A[m * ldA + k + 3]),
                        [ B0 ] "f"(B[(n + 0) * ldB + k]),
                        [ B1 ] "f"(B[(n + 1) * ldB + k]),
                        [ B2 ] "f"(B[(n + 2) * ldB + k]),
                        [ B3 ] "f"(B[(n + 3) * ldB + k]),
                        [ B4 ] "f"(B[(n + 0) * ldB + k + 1]),
                        [ B5 ] "f"(B[(n + 1) * ldB + k + 1]),
                        [ B6 ] "f"(B[(n + 2) * ldB + k + 1]),
                        [ B7 ] "f"(B[(n + 3) * ldB + k + 1]),
                        [ B8 ] "f"(B[(n + 0) * ldB + k + 2]),
                        [ B9 ] "f"(B[(n + 1) * ldB + k + 2]),
                        [ B10 ] "f"(B[(n + 2) * ldB + k + 2]),
                        [ B11 ] "f"(B[(n + 3) * ldB + k + 2]),
                        [ B12 ] "f"(B[(n + 0) * ldB + k + 3]),
                        [ B13 ] "f"(B[(n + 1) * ldB + k + 3]),
                        [ B14 ] "f"(B[(n + 2) * ldB + k + 3]),
                        [ B15 ] "f"(B[(n + 3) * ldB + k + 3])
                        :);
                }

                C[m * ldC + n + 0] = acc[0];
                C[m * ldC + n + 1] = acc[1];
                C[m * ldC + n + 2] = acc[2];
                C[m * ldC + n + 3] = acc[3];
            }
        }
    }
}

void gemm_fp64_opt(uint32_t M, uint32_t N, uint32_t K, void* A_p, uint32_t ldA,
                   uint32_t ta, void* B_p, uint32_t ldB, uint32_t tb, void* C_p,
                   uint32_t ldC, uint32_t BETA, uint32_t setup_SSR) {
    double* A = (double*)A_p;
    double* B = (double*)B_p;
    double* C = (double*)C_p;

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
            if (BETA != 0) {
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
                "frep.o %[n_frep], %[unroll], 0, 0 \n"
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
                : [ n_frep ] "r"(K - 1), [ unroll ] "i"(unroll)
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
            if (BETA != 0) {
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
