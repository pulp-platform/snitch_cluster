// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

void gemm_fp16_naive(uint32_t setup_ssr, uint32_t partition_banks,
                     uint32_t transa, uint32_t transb, uint32_t M, uint32_t N,
                     uint32_t K, void* A_p, uint32_t lda, void* B_p,
                     uint32_t ldb, uint32_t beta, void* C_p, uint32_t ldc) {
    __fp16* A = (__fp16*)A_p;
    __fp16* B = (__fp16*)B_p;
    __fp16* C = (__fp16*)C_p;
    __fp16 beta_fp = (__fp16)beta;

    for (uint32_t m = 0; m < M; m++) {
        for (uint32_t n = 0; n < N; n++) {
            __fp16 c;
            if (beta_fp != 0) {
                c = C[m * ldc + n] * beta_fp;
            } else {
                c = 0.0;
            }
            for (uint32_t k = 0; k < K; k++) {
                __fp16 a = A[m * lda + k];
                __fp16 b;
                if (transb)
                    b = B[n * ldb + k];
                else
                    b = B[k * ldb + n];
                asm volatile(
                    "fmv.h.x ft3, %[a]\n"
                    "fmv.h.x ft4, %[b]\n"
                    "fmv.h.x ft5, %[c]\n"
                    "fmul.h ft6, ft3, ft4 \n"
                    "fadd.h ft5, ft5, ft6 \n"
                    "fmv.x.h %[c], ft5\n"
                    : [ c ] "+r"(c)
                    : [ a ] "r"(a), [ b ] "r"(b));
            }
            C[m * ldc + n] = c;
        }
    }
}

void gemm_fp16_baseline(uint32_t setup_ssr, uint32_t transa, uint32_t transb,
                        uint32_t M, uint32_t N, uint32_t K, void* A_p,
                        uint32_t lda, void* B_p, uint32_t ldb, uint32_t beta,
                        void* C_p, uint32_t ldc) {
    __fp16* A = (__fp16*)A_p;
    __fp16* B = (__fp16*)B_p;
    __fp16* C = (__fp16*)C_p;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (; n < N; n++) {
            volatile v4f16 *a_ptr, *b_ptr;
            v4f16 a, b;
            volatile __fp16* c_ptr;
            const float zero = 0.0;
            double c = 0.0;
            v4f16 reduce_reg;

            a_ptr = (v4f16*)(&A[m * lda]);
            b_ptr = (v4f16*)(&B[n * ldb]);
            c_ptr = &C[m * ldc + n];
            // Don't accumulate in first iteration
            asm volatile(
                "beqz %[beta], 1f \n"
                // Load intermediate results
                "flh ft2, 0(%[C]) \n"
                "vfcvt.s.h ft2, ft2\n"
                "vfcpka.s.s ft2, ft2, %[zero]\n"
                // or initialize with zero
                "j 2f \n"
                "1: \n"
                "vfcpka.s.s ft2, %[zero], %[zero]\n"
                "2: \n"
                // loop over the MACs
                "li     t0, 0 \n"
                "3: \n"
                "fld ft0, 0(%[a_ptr]) \n"
                "fld ft1, 0(%[b_ptr]) \n"
                "add %[a_ptr], %[a_ptr], 8 \n"
                "add %[b_ptr], %[b_ptr], 8 \n"
                "vfdotpex.s.h ft2, ft0, ft1 \n"
                "addi  t0, t0, 4 \n"
                "blt   t0, %[K], 3b \n"
                // Sum reduce vector
                "vfcpka.s.s ft3, %[zero], %[zero]\n"
                "vfsum.s ft3, ft2 \n"
                "vfcvt.h.s ft3, ft3\n"
                // Store results
                "fsh ft3, 0(%[C]) \n"
                : [ a_ptr ] "+r"(a_ptr), [ b_ptr ] "+r"(b_ptr)
                : [ c ] "f"(c), [ reduce_reg ] "f"(reduce_reg),
                  [ C ] "r"(c_ptr), [ beta ] "r"(beta), [ K ] "r"(K),
                  [ zero ] "f"(zero)
                : "ft0", "ft1", "ft2", "ft3", "ft4", "t0");
        }
    }
}

void gemm_fp16_opt(uint32_t setup_ssr, uint32_t partition_banks,
                   uint32_t transa, uint32_t transb, uint32_t M, uint32_t N,
                   uint32_t K, void* A_p, uint32_t lda, void* B_p, uint32_t ldb,
                   uint32_t beta, void* C_p, uint32_t ldc) {
    __fp16* A = (__fp16*)A_p;
    __fp16* B = (__fp16*)B_p;
    __fp16* C = (__fp16*)C_p;

    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // Don't enable the SSRs if the stream won't be used
    if (N >= unroll) {
        // SSR strides and bounds only have to be configured
        // once in the beginning
        if (setup_ssr) {
            uint32_t ssr0_b[4] = {unroll, K / 4, N / unroll, M};
            uint32_t ssr0_i[4] = {0, sizeof(__fp16) * 4, 0,
                                  sizeof(__fp16) * lda};

            uint32_t ssr1_b[4] = {unroll, K / 4, N / unroll, M};
            uint32_t ssr1_i[4] = {sizeof(__fp16) * ldb, sizeof(__fp16) * 4,
                                  sizeof(__fp16) * unroll * ldb, 0};

            snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                             ssr0_i[1], ssr0_i[2], ssr0_i[3]);
            snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2],
                             ssr1_i[3]);
        }

        // SSR start address need to be configured each time
        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
        snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
        snrt_ssr_enable();
    }

    // Kernel progresses by 4 values each step
    const uint32_t n_frep = K / 4 - 1;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            __fp16* _C = &C[m * ldc + n];
            const float zero = 0.0;
            v4f16 c[unroll];
            v2f32 reduce_reg[unroll];

            asm volatile(
                "beqz %[beta], 1f \n"
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
                // Store results
                "fsd %[c0],  0(%[C]) \n"
                "fsd %[c1],  8(%[C]) \n"
                : [ c0 ] "=f"(c[0]), [ c1 ] "=f"(c[1]), [ c2 ] "=f"(c[2]),
                  [ c3 ] "=f"(c[3]), [ c4 ] "=f"(c[4]), [ c5 ] "=f"(c[5]),
                  [ c6 ] "=f"(c[6]), [ c7 ] "=f"(c[7]),
                  [ reduce_reg0 ] "=f"(reduce_reg[0]),
                  [ reduce_reg1 ] "=f"(reduce_reg[1]),
                  [ reduce_reg2 ] "=f"(reduce_reg[2]),
                  [ reduce_reg3 ] "=f"(reduce_reg[3]),
                  [ reduce_reg4 ] "=f"(reduce_reg[4]),
                  [ reduce_reg5 ] "=f"(reduce_reg[5]),
                  [ reduce_reg6 ] "=f"(reduce_reg[6]),
                  [ reduce_reg7 ] "=f"(reduce_reg[7])
                : [ C ] "r"(_C), [ zero ] "f"(zero), [ n_frep ] "r"(n_frep),
                  [ beta ] "r"(beta)
                : "ft0", "ft1", "ft2");

            n += unroll;
        }

        // Clean up left over column
        // snrt_ssr_disable();

        // for (; n < N; n++) {
        //     __fp16 c = (*beta) ? C[m * ldc + n] : 0.0;
        //     for (uint32_t k = 0; k < K; k++) {
        //         c += A[k + m * lda] * B[k + n * ldb];
        //     }
        //     C[m * ldc + n] = c;
        // }

        // snrt_ssr_enable();
    }

    snrt_ssr_disable();
}

void gemm_fp16_opt_ex(uint32_t setup_ssr, uint32_t partition_banks,
                      uint32_t transa, uint32_t transb, uint32_t M, uint32_t N,
                      uint32_t K, void* A_p, uint32_t lda, void* B_p,
                      uint32_t ldb, uint32_t beta, void* C_p, uint32_t ldc) {
    __fp16* A = (__fp16*)A_p;
    __fp16* B = (__fp16*)B_p;
    __fp16* C = (__fp16*)C_p;

    // Unrolling factor of most inner loop.
    // Should be at least as high as the FMA delay
    // for maximum utilization
    const uint32_t unroll = 8;

    // Don't enable the SSRs if the stream won't be used
    if (N >= unroll) {
        // SSR strides and bounds only have to be configured
        // once in the beginning
        if (setup_ssr) {
            uint32_t ssr0_b[4] = {unroll, K / 4, N / unroll, M};
            uint32_t ssr0_i[4] = {0, sizeof(__fp16) * 4, 0,
                                  sizeof(__fp16) * lda};

            uint32_t ssr1_b[4] = {unroll, K / 4, N / unroll, M};
            uint32_t ssr1_i[4] = {sizeof(__fp16) * ldb, sizeof(__fp16) * 4,
                                  sizeof(__fp16) * unroll * ldb, 0};

            snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                             ssr0_i[1], ssr0_i[2], ssr0_i[3]);
            snrt_ssr_repeat(SNRT_SSR_DM0, unroll);

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2],
                             ssr1_i[3]);
        }

        // SSR start address need to be configured each time
        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A);
        snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, B);
        snrt_ssr_enable();
    }

    // Kernel progresses by 4 values each step
    const uint32_t n_frep = K / 4 - 1;

    for (uint32_t m = 0; m < M; m++) {
        uint32_t n = 0;
        for (uint32_t n0 = 0; n0 < N / unroll; n0++) {
            __fp16* _C = &C[m * ldc + n];
            const float zero = 0.0;
            v4f16 c[unroll];
            v2f32 reduce_reg[unroll];

            asm volatile(
                "beqz %[beta], 1f \n"
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
                // Store results
                "fsd %[c0],  0(%[C]) \n"
                "fsd %[c1],  8(%[C]) \n"
                : [ c0 ] "=f"(c[0]), [ c1 ] "=f"(c[1]), [ c2 ] "=f"(c[2]),
                  [ c3 ] "=f"(c[3]), [ c4 ] "=f"(c[4]), [ c5 ] "=f"(c[5]),
                  [ c6 ] "=f"(c[6]), [ c7 ] "=f"(c[7]),
                  [ reduce_reg0 ] "=f"(reduce_reg[0]),
                  [ reduce_reg1 ] "=f"(reduce_reg[1]),
                  [ reduce_reg2 ] "=f"(reduce_reg[2]),
                  [ reduce_reg3 ] "=f"(reduce_reg[3]),
                  [ reduce_reg4 ] "=f"(reduce_reg[4]),
                  [ reduce_reg5 ] "=f"(reduce_reg[5]),
                  [ reduce_reg6 ] "=f"(reduce_reg[6]),
                  [ reduce_reg7 ] "=f"(reduce_reg[7])
                : [ C ] "r"(_C), [ zero ] "f"(zero), [ n_frep ] "r"(n_frep),
                  [ unroll ] "i"(unroll), [ beta ] "r"(beta)
                : "ft0", "ft1", "ft2");

            n += unroll;
        }

        // Clean up left over column
        // snrt_ssr_disable();

        // for (; n < N; n++) {
        //     __fp16 c = (*beta) ? C[m * ldc + n] : 0.0;
        //     for (uint32_t k = 0; k < K; k++) {
        //         c += A[k + m * lda] * B[k + n * ldb];
        //     }
        //     C[m * ldc + n] = c;
        // }

        // snrt_ssr_enable();
    }

    snrt_ssr_disable();
}
