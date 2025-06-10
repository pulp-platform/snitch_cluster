// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Viviane Potocnik <vivianep@iis.ee.ethz.ch>

#define UNROLL 4

static inline void layernorm_fp16_opt(__fp16 *input, __fp16 *output,
                                      uint32_t batch_size, uint32_t seq_len,
                                      const uint32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        __fp16 *core_itile = input + offset;
        __fp16 *core_otile = output + offset;

        uint32_t batch_offset = seq_len * embeddings;

        // compute the mean and variance along the last dimension
        float mean_tot = 0.0;  // max value of the current core
        float var_tot = 0.0;   // sum of the exp values of the current core
        v4s mean_reg;
        v2s mean[UNROLL];
        float var_reduce[UNROLL];
        float mean_reduce[UNROLL];
        v4s var_reg[UNROLL];
        v4s pow[UNROLL];
        v4s one_reg;

        const int num_elems_per_vector = sizeof(double) / sizeof(__fp16);

        const uint32_t ssr0_b[4] = {
            UNROLL, embeddings / (UNROLL * num_elems_per_vector), 2,
            tile_seq_len};
        const uint32_t ssr0_i[4] = {sizeof(double), UNROLL * sizeof(double), 0,
                                    stride * sizeof(__fp16)};
        const uint32_t ssr1_b[2] = {
            UNROLL, embeddings / (UNROLL * num_elems_per_vector)};
        const uint32_t ssr1_i[2] = {sizeof(double), UNROLL * sizeof(double)};
        snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                         ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                         ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_loop_2d(SNRT_SSR_DM2, ssr1_b[0], ssr1_b[1], ssr1_i[0],
                         ssr1_i[1]);

        // kernel progresses four values in each iteration
        const uint32_t n_frep = embeddings / (UNROLL * num_elems_per_vector);

        for (int32_t b = 0; b < batch_size; b++) {
            snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D,
                          &core_itile[b * batch_offset]);
            snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_4D,
                           &core_otile[b * batch_offset]);

            for (int32_t s = 0; s < tile_seq_len; s++) {
                mean_tot = 0.0;
                var_tot = 0.0;

                snrt_ssr_enable();

                asm volatile(
                    "vfcpka.s.s %[mean0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean3], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce3], %[zero], %[zero] \n"
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfsumex.s.h %[mean0], ft0 \n"
                    "vfsumex.s.h %[mean1], ft0 \n"
                    "vfsumex.s.h %[mean2], ft0 \n"
                    "vfsumex.s.h %[mean3], ft0 \n"
                    "vfsum.s %[mean_reduce0], %[mean0] \n"
                    "vfsum.s %[mean_reduce1], %[mean1] \n"
                    "vfsum.s %[mean_reduce2], %[mean2] \n"
                    "vfsum.s %[mean_reduce3], %[mean3] \n"
                    "fadd.s %[mean_reduce0], %[mean_reduce0], %[mean_reduce1] "
                    "\n"
                    "fadd.s %[mean_reduce2], %[mean_reduce2], %[mean_reduce3] "
                    "\n"
                    "fadd.s %[mean_tot], %[mean_reduce0], %[mean_reduce2] \n"
                    "fdiv.s %[mean_tot], %[mean_tot], %[embeddings] \n"
                    "vfcpka.h.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    "vfcpkb.h.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    : [ mean_reg ] "+f"(mean_reg.f64),
                      [ mean0 ] "+f"(mean[0].f64), [ mean1 ] "+f"(mean[1].f64),
                      [ mean2 ] "+f"(mean[2].f64), [ mean3 ] "+f"(mean[3].f64),
                      [ mean_tot ] "+f"(mean_tot),
                      [ mean_reduce0 ] "+f"(mean_reduce[0]),
                      [ mean_reduce1 ] "+f"(mean_reduce[1]),
                      [ mean_reduce2 ] "+f"(mean_reduce[2]),
                      [ mean_reduce3 ] "+f"(mean_reduce[3])
                    : [ n_frep ] "r"(n_frep - 1), [ zero ] "f"(0.0f),
                      [ embeddings ] "f"((float)embeddings),
                      [ op1 ] "f"(-0.875f), [ op2 ] "f"(-1.9163818f)
                    : "ft0", "ft1", "ft2");

                snrt_fpu_fence();

                // DUMP(mean_tot);

                // Computation of the row variance
                asm volatile(
                    "vfcpka.s.s %[mean0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean3], %[zero], %[zero] \n"
                    "frep.o  %[n_frep], 16, 0, 0 \n"
                    "vfsub.h %[var_reg0], ft0, %[mean_reg] \n"
                    "vfsub.h %[var_reg1], ft0, %[mean_reg] \n"
                    "vfsub.h %[var_reg2], ft0, %[mean_reg] \n"
                    "vfsub.h %[var_reg3], ft0, %[mean_reg] \n"
                    "vfadd.h ft1, %[var_reg0], %[zero] \n"
                    "vfadd.h ft1, %[var_reg1], %[zero] \n"
                    "vfadd.h ft1, %[var_reg2], %[zero] \n"
                    "vfadd.h ft1, %[var_reg3], %[zero] \n"
                    "vfmul.h %[pow0], %[var_reg0], %[var_reg0] \n"
                    "vfmul.h %[pow1], %[var_reg1], %[var_reg1] \n"
                    "vfmul.h %[pow2], %[var_reg2], %[var_reg2] \n"
                    "vfmul.h %[pow3], %[var_reg3], %[var_reg3] \n"
                    "vfsumex.s.h %[mean0], %[pow0] \n"
                    "vfsumex.s.h %[mean1], %[pow1] \n"
                    "vfsumex.s.h %[mean2], %[pow2] \n"
                    "vfsumex.s.h %[mean3], %[pow3] \n"
                    "vfsum.s %[var_reduce0], %[mean0] \n"
                    "vfsum.s %[var_reduce1], %[mean1] \n"
                    "vfsum.s %[var_reduce2], %[mean2] \n"
                    "vfsum.s %[var_reduce3], %[mean3] \n"
                    "fadd.s %[var_reduce0], %[var_reduce0], %[var_reduce1] \n"
                    "fadd.s %[var_reduce2], %[var_reduce2], %[var_reduce3] \n"
                    "fadd.s %[mean_reduce0], %[var_reduce0], %[var_reduce2] \n"
                    "fdiv.s %[mean_reduce0], %[mean_reduce0], %[embeddings] \n"
                    "fadd.s %[mean_reduce0], %[mean_reduce0], %[eps] \n"
                    "fsqrt.s %[mean_reduce0], %[mean_reduce0] \n"
                    "fdiv.s %[mean_reduce0], %[one], %[mean_reduce0] \n"
                    "vfcpka.h.s %[mean_reg], %[mean_reduce0], %[mean_reduce0] "
                    "\n"
                    "vfcpkb.h.s %[mean_reg], %[mean_reduce0], %[mean_reduce0] "
                    "\n"
                    : [ mean_reg ] "+f"(mean_reg.f64),
                      [ var_reg0 ] "+f"(var_reg[0].f64),
                      [ var_reg1 ] "+f"(var_reg[1].f64),
                      [ var_reg2 ] "+f"(var_reg[2].f64),
                      [ var_reg3 ] "+f"(var_reg[3].f64),
                      [ pow0 ] "+f"(pow[0].f64), [ pow1 ] "+f"(pow[1].f64),
                      [ pow2 ] "+f"(pow[2].f64), [ pow3 ] "+f"(pow[3].f64),
                      [ mean0 ] "+f"(mean[0].f64), [ mean1 ] "+f"(mean[1].f64),
                      [ mean2 ] "+f"(mean[2].f64), [ mean3 ] "+f"(mean[3].f64),
                      [ var_reduce0 ] "+f"(var_reduce[0]),
                      [ var_reduce1 ] "+f"(var_reduce[1]),
                      [ var_reduce2 ] "+f"(var_reduce[2]),
                      [ var_reduce3 ] "+f"(var_reduce[3]),
                      [ mean_reduce0 ] "+f"(mean_reduce[0])
                    : [ var_tot ] "f"(var_tot), [ n_frep ] "r"(n_frep - 1),
                      [ zero ] "f"(0.0), [ one ] "f"(1.0f),
                      [ embeddings ] "f"((float)embeddings),
                      [ eps ] "f"((float)eps)
                    : "ft0", "ft1", "ft2", "ft10");

                snrt_fpu_fence();

                snrt_ssr_read(SNRT_SSR_DM2, SNRT_SSR_2D,
                              &core_otile[b * batch_offset + s * stride]);

                // Normalization of the row
                asm volatile(
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfmul.h ft1, ft2, %[mean_reg] \n"
                    "vfmul.h ft1, ft2, %[mean_reg] \n"
                    "vfmul.h ft1, ft2, %[mean_reg] \n"
                    "vfmul.h ft1, ft2, %[mean_reg] \n"
                    : [ mean_reg ] "+f"(mean_reg.f64)
                    : [ n_frep ] "r"(n_frep - 1)
                    : "ft0", "ft1", "ft2");

                snrt_ssr_disable();
            }
        }

        snrt_fpu_fence();
    }
}