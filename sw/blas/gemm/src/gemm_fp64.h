// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

static inline void gemm_fp64_naive(uint32_t setup_ssr, uint32_t partition_banks,
                                   uint32_t transa, uint32_t transb, uint32_t M,
                                   uint32_t N, uint32_t K, void* A_p,
                                   uint32_t lda, void* B_p, uint32_t ldb,
                                   uint32_t beta, void* C_p, uint32_t ldc) {
    double* A = (double*)A_p;
    double* B = (double*)B_p;
    double* C = (double*)C_p;

    uint32_t elems_per_line =
        (snrt_cluster_compute_core_num() * SNRT_TCDM_BANK_WIDTH) /
        sizeof(double);

    if (!transa && !transb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                uint32_t c_idx;
                uint32_t n_inner, n_outer, n_outer_stride;
                if (partition_banks) {
                    n_inner = n % elems_per_line;
                    n_outer = n / elems_per_line;
                    n_outer_stride = SNRT_TCDM_HYPERBANK_WIDTH / sizeof(double);
                    c_idx = m * ldc + n_outer * n_outer_stride + n_inner;
                } else {
                    c_idx = m * ldc + n;
                }
                double c0 = multiply_opt(C[c_idx], beta);
                for (uint32_t k = 0; k < K; k++) {
                    uint32_t a_idx, b_idx;
                    if (partition_banks) {
                        uint32_t k_inner = k % elems_per_line;
                        uint32_t k_outer = k / elems_per_line;
                        uint32_t k_outer_stride =
                            SNRT_TCDM_HYPERBANK_WIDTH / sizeof(double);
                        a_idx = m * lda + k_outer * k_outer_stride + k_inner;
                        b_idx = k * ldb + n_outer * n_outer_stride + n_inner;
                    } else {
                        a_idx = m * lda + k;
                        b_idx = k * ldb + n;
                    }
                    c0 += A[a_idx] * B[b_idx];
                }
                C[c_idx] = c0;
            }
        }
    } else if (transa && !transb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                double c0 = multiply_opt(C[m * ldc + n], beta);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * lda + m * lda] * B[k * ldb + n];
                }
                C[m * ldc + n] = c0;
            }
        }
    } else if (!transa && transb) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                double c0 = multiply_opt(C[m * ldc + n], beta);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[m * lda + k] * B[n * ldb + k];
                }
                C[m * ldc + n] = c0;
            }
        }
    } else {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                double c0 = multiply_opt(C[m * ldc + n], beta);
                for (uint32_t k = 0; k < K; k++) {
                    c0 += A[k * M * lda + m * lda] * B[k + n * ldb];
                }
                C[m * ldc + n] = c0;
            }
        }
    }
}

static inline void gemm_fp64_opt(uint32_t setup_ssr, uint32_t partition_banks,
                                 uint32_t transa, uint32_t transb, uint32_t M,
                                 uint32_t N, uint32_t K, void* A_p,
                                 uint32_t lda, void* B_p, uint32_t ldb,
                                 uint32_t beta, void* C_p, uint32_t ldc) {
    double* A = (double*)A_p;
    double* B = (double*)B_p;
    double* C = (double*)C_p;

    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // Don't enable the SSRs if the stream won't be used
    if (N >= unroll) {
        // SSR strides and bounds only have to be configured
        // once in the beginning
        if (setup_ssr) {
            // First matrix is stored in transposed format
            if (transa) {
                const uint32_t ssr0_b[4] = {unroll, K, N / unroll, M};
                const uint32_t ssr0_i[4] = {0, 8 * lda, 0, 8 * 8};

                snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                                 ssr0_i[1], ssr0_i[2], ssr0_i[3]);
                snrt_ssr_repeat(SNRT_SSR_DM0, unroll);
            } else {
                // A is layed out across a subset of banks (one per compute
                // core)
                if (partition_banks) {
                    uint32_t elems_per_line = (snrt_cluster_compute_core_num() *
                                               SNRT_TCDM_BANK_WIDTH) /
                                              sizeof(double);

                    const uint32_t ssr0_b[5] = {unroll, elems_per_line,
                                                K / elems_per_line, N / unroll,
                                                M};
                    const uint32_t ssr0_i[5] = {0, 8, SNRT_TCDM_HYPERBANK_WIDTH,
                                                0, 8 * lda};

                    snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2],
                                     ssr0_b[3], ssr0_b[4], ssr0_i[1], ssr0_i[2],
                                     ssr0_i[3], ssr0_i[4]);
                }
                // A is layed out across all banks
                else {
                    const uint32_t ssr0_b[4] = {unroll, K, N / unroll, M};
                    const uint32_t ssr0_i[4] = {0, 8, 0, 8 * lda};

                    snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2],
                                     ssr0_b[3], ssr0_i[1], ssr0_i[2],
                                     ssr0_i[3]);
                }
                snrt_ssr_repeat(SNRT_SSR_DM0, unroll);
            }

            // Second matrix is stored in transposed format
            if (transb) {
                const uint32_t ssr1_b[4] = {unroll, K, N / unroll, M};
                const uint32_t ssr1_i[4] = {8 * ldb, 8, 8 * ldb * unroll, 0};

                snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                                 ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2],
                                 ssr1_i[3]);
            } else {
                uint32_t n_outer_incr;
                if (partition_banks)
                    n_outer_incr = SNRT_TCDM_HYPERBANK_WIDTH;
                else
                    n_outer_incr = 8 * unroll;

                // Note: this works with the partitioned bank layout only
                // because the unroll factor is equal to the number of elements
                // per TCDM line. Otherwise we would need a 5D SSR.
                const uint32_t ssr1_b[4] = {unroll, K, N / unroll, M};
                const uint32_t ssr1_i[4] = {8, 8 * ldb, n_outer_incr, 0};

                snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                                 ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2],
                                 ssr1_i[3]);
            }

            // SSR 2 is used to writeback C matrix

            uint32_t n_outer_incr;
            if (partition_banks)
                n_outer_incr = SNRT_TCDM_HYPERBANK_WIDTH;
            else
                n_outer_incr = unroll * 8;

            const uint32_t ssr2_b[3] = {unroll, N / unroll, M};
            const uint32_t ssr2_i[3] = {8, n_outer_incr, ldc * 8};

            snrt_ssr_loop_3d(SNRT_SSR_DM2, ssr2_b[0], ssr2_b[1], ssr2_b[2],
                             ssr2_i[0], ssr2_i[1], ssr2_i[2]);
        }

        // SSR start address need to be configured each time
        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
        snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
        snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_3D, C);
        snrt_ssr_enable();
    }

    double c[unroll];
    snrt_mcycle();

    // If beta is not zero, we need to preload C into the accumulator,
    // and a different element of C needs to be preloaded in every (m, n)
    // iteration. These (integer) operations cannot be done in the FREP loop,
    // so we cannot map the `m` and `n` loops to an FREP loop.
    if (SNRT_NUM_SEQUENCER_LOOPS > 1 && SNRT_NUM_SEQUENCER_INSNS >= 24 &&
        beta == 0) {
        asm volatile(
            "frep.o %[n_frep1], %[n_inst1], 0, 0\n"
            "fmul.d %[c0], ft0, ft1 \n"
            "fmul.d %[c1], ft0, ft1 \n"
            "fmul.d %[c2], ft0, ft1 \n"
            "fmul.d %[c3], ft0, ft1 \n"
            "fmul.d %[c4], ft0, ft1 \n"
            "fmul.d %[c5], ft0, ft1 \n"
            "fmul.d %[c6], ft0, ft1 \n"
            "fmul.d %[c7], ft0, ft1 \n"
            "frep.o %[n_frep2], %[unroll], 0, 0 \n"
            "fmadd.d %[c0], ft0, ft1, %[c0] \n"
            "fmadd.d %[c1], ft0, ft1, %[c1] \n"
            "fmadd.d %[c2], ft0, ft1, %[c2] \n"
            "fmadd.d %[c3], ft0, ft1, %[c3] \n"
            "fmadd.d %[c4], ft0, ft1, %[c4] \n"
            "fmadd.d %[c5], ft0, ft1, %[c5] \n"
            "fmadd.d %[c6], ft0, ft1, %[c6] \n"
            "fmadd.d %[c7], ft0, ft1, %[c7] \n"
            "fmadd.d ft2, ft0, ft1, %[c0] \n"
            "fmadd.d ft2, ft0, ft1, %[c1] \n"
            "fmadd.d ft2, ft0, ft1, %[c2] \n"
            "fmadd.d ft2, ft0, ft1, %[c3] \n"
            "fmadd.d ft2, ft0, ft1, %[c4] \n"
            "fmadd.d ft2, ft0, ft1, %[c5] \n"
            "fmadd.d ft2, ft0, ft1, %[c6] \n"
            "fmadd.d ft2, ft0, ft1, %[c7] \n"

            : [ c0 ] "=f"(c[0]), [ c1 ] "=f"(c[1]), [ c2 ] "=f"(c[2]),
              [ c3 ] "=f"(c[3]), [ c4 ] "=f"(c[4]), [ c5 ] "=f"(c[5]),
              [ c6 ] "=f"(c[6]), [ c7 ] "=f"(c[7])
            : [ n_frep1 ] "r"((M * N / unroll) - 1), [ n_frep2 ] "r"(K - 3),
              [ n_inst1 ] "i"(24), [ unroll ] "i"(unroll)
            : "ft0", "ft1", "ft2");
    } else {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
                if (beta == 0) {
                    asm volatile(
                        "fmul.d %[c0], ft0, ft1 \n"
                        "fmul.d %[c1], ft0, ft1 \n"
                        "fmul.d %[c2], ft0, ft1 \n"
                        "fmul.d %[c3], ft0, ft1 \n"
                        "fmul.d %[c4], ft0, ft1 \n"
                        "fmul.d %[c5], ft0, ft1 \n"
                        "fmul.d %[c6], ft0, ft1 \n"
                        "fmul.d %[c7], ft0, ft1 \n"
                        : [ c0 ] "=f"(c[0]), [ c1 ] "=f"(c[1]),
                          [ c2 ] "=f"(c[2]), [ c3 ] "=f"(c[3]),
                          [ c4 ] "=f"(c[4]), [ c5 ] "=f"(c[5]),
                          [ c6 ] "=f"(c[6]), [ c7 ] "=f"(c[7])
                        :
                        : "ft0", "ft1", "ft2");
                } else {
                    asm volatile(
                        "fld     %[c0],  0(%[c]) \n"
                        "fld     %[c1],  8(%[c]) \n"
                        "fld     %[c2], 16(%[c]) \n"
                        "fld     %[c3], 24(%[c]) \n"
                        "fld     %[c4], 32(%[c]) \n"
                        "fld     %[c5], 40(%[c]) \n"
                        "fld     %[c6], 48(%[c]) \n"
                        "fld     %[c7], 56(%[c]) \n"
                        "fmadd.d %[c0], ft0, ft1, %[c0] \n"
                        "fmadd.d %[c1], ft0, ft1, %[c1] \n"
                        "fmadd.d %[c2], ft0, ft1, %[c2] \n"
                        "fmadd.d %[c3], ft0, ft1, %[c3] \n"
                        "fmadd.d %[c4], ft0, ft1, %[c4] \n"
                        "fmadd.d %[c5], ft0, ft1, %[c5] \n"
                        "fmadd.d %[c6], ft0, ft1, %[c6] \n"
                        "fmadd.d %[c7], ft0, ft1, %[c7] \n"
                        : [ c0 ] "=f"(c[0]), [ c1 ] "=f"(c[1]),
                          [ c2 ] "=f"(c[2]), [ c3 ] "=f"(c[3]),
                          [ c4 ] "=f"(c[4]), [ c5 ] "=f"(c[5]),
                          [ c6 ] "=f"(c[6]), [ c7 ] "=f"(c[7])
                        : [ c ] "=r"(&C[m * ldc + n0 * unroll])
                        : "ft0", "ft1", "ft2");
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
                    "fmadd.d ft2, ft0, ft1, %[c0] \n"
                    "fmadd.d ft2, ft0, ft1, %[c1] \n"
                    "fmadd.d ft2, ft0, ft1, %[c2] \n"
                    "fmadd.d ft2, ft0, ft1, %[c3] \n"
                    "fmadd.d ft2, ft0, ft1, %[c4] \n"
                    "fmadd.d ft2, ft0, ft1, %[c5] \n"
                    "fmadd.d ft2, ft0, ft1, %[c6] \n"
                    "fmadd.d ft2, ft0, ft1, %[c7] \n"
                    :
                    : [ c0 ] "f"(c[0]), [ c1 ] "f"(c[1]), [ c2 ] "f"(c[2]),
                      [ c3 ] "f"(c[3]), [ c4 ] "f"(c[4]), [ c5 ] "f"(c[5]),
                      [ c6 ] "f"(c[6]), [ c7 ] "f"(c[7]), [ n_frep ] "r"(K - 3),
                      [ unroll ] "i"(unroll)
                    : "ft0", "ft1", "ft2");
            }
        }
    }
    snrt_fpu_fence();
    snrt_mcycle();

    snrt_ssr_disable();
}
