// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Viviane Potocnik <vivianep@iis.ee.ethz.ch>

#define UNROLL 4

static inline void layernorm_fp8_opt(char *input, char *output,
                                     uint32_t batch_size, uint32_t seq_len,
                                     uint32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        char *core_itile = input + offset;
        char *core_otile = output + offset;

        uint32_t batch_offset = seq_len * embeddings;

        float mean_tot = 0.0;  // max value of the current core
        float var_tot = 0.0;   // sum of the exp values of the current core
        v8s mean_reg;
        v4s mean_v4[UNROLL];
        v2s mean_v2[UNROLL];
        float mean_reduce[UNROLL];

        v8s var_v8[UNROLL];
        v8s pow_v8[UNROLL];
        v2s var_v2[UNROLL];
        float var_reduce[UNROLL];

        const int num_elems_per_vector = sizeof(double) / sizeof(char);

        const uint32_t ssr0_b[4] = {
            UNROLL, embeddings / (UNROLL * num_elems_per_vector), 2,
            tile_seq_len};

        const uint32_t ssr0_i[4] = {sizeof(double), UNROLL * sizeof(double), 0,
                                    stride * sizeof(char)};

        const uint32_t ssr1_b[2] = {
            UNROLL, embeddings / (UNROLL * num_elems_per_vector)};
        const uint32_t ssr1_i[2] = {sizeof(double), UNROLL * sizeof(double)};

        snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                         ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                         ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_loop_2d(SNRT_SSR_DM2, ssr1_b[0], ssr1_b[1], ssr1_i[0],
                         ssr1_i[1]);

        // kernel progresses eight values in each iteration
        const uint32_t n_frep = embeddings / (UNROLL * num_elems_per_vector);

        for (int32_t b = 0; b < batch_size; b++) {
            snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D,
                          &core_itile[b * batch_offset]);
            snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_4D,
                           &core_otile[b * batch_offset]);

            for (int32_t s = 0; s < tile_seq_len; s++) {
                mean_tot = 0.0;

                snrt_ssr_enable();

                asm volatile(
                    "vfcpka.s.s %[mean_v4_0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v4_1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v4_2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v4_3], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v2_0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v2_1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v2_2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v2_3], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_reduce3], %[zero], %[zero] \n"
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfsumex.h.b %[mean_v4_0], ft0 \n"
                    "vfsumex.h.b %[mean_v4_1], ft0 \n"
                    "vfsumex.h.b %[mean_v4_2], ft0 \n"
                    "vfsumex.h.b %[mean_v4_3], ft0 \n"
                    "vfsumex.s.h %[mean_v2_0], %[mean_v4_0] \n"
                    "vfsumex.s.h %[mean_v2_1], %[mean_v4_1] \n"
                    "vfsumex.s.h %[mean_v2_2], %[mean_v4_2] \n"
                    "vfsumex.s.h %[mean_v2_3], %[mean_v4_3] \n"
                    "vfsum.s %[mean_reduce0], %[mean_v2_0] \n"
                    "vfsum.s %[mean_reduce1], %[mean_v2_1] \n"
                    "vfsum.s %[mean_reduce2], %[mean_v2_2] \n"
                    "vfsum.s %[mean_reduce3], %[mean_v2_3] \n"
                    "fadd.s %[mean_reduce0], %[mean_reduce0], %[mean_reduce1] "
                    "\n"
                    "fadd.s %[mean_reduce2], %[mean_reduce2], %[mean_reduce3] "
                    "\n"
                    "fadd.s %[mean_tot], %[mean_reduce0], %[mean_reduce2] \n"
                    "fdiv.s %[mean_tot], %[mean_tot], %[embeddings] \n"
                    "vfcpka.b.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    "vfcpkb.b.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    "vfcpkc.b.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    "vfcpkd.b.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    : [ mean_reg ] "+f"(mean_reg.f64),
                      [ mean_v4_0 ] "+f"(mean_v4[0].f64),
                      [ mean_v4_1 ] "+f"(mean_v4[1].f64),
                      [ mean_v4_2 ] "+f"(mean_v4[2].f64),
                      [ mean_v4_3 ] "+f"(mean_v4[3].f64),
                      [ mean_v2_0 ] "+f"(mean_v2[0].f64),
                      [ mean_v2_1 ] "+f"(mean_v2[1].f64),
                      [ mean_v2_2 ] "+f"(mean_v2[2].f64),
                      [ mean_v2_3 ] "+f"(mean_v2[3].f64),
                      [ mean_tot ] "+f"(mean_tot),
                      [ mean_reduce0 ] "+f"(mean_reduce[0]),
                      [ mean_reduce1 ] "+f"(mean_reduce[1]),
                      [ mean_reduce2 ] "+f"(mean_reduce[2]),
                      [ mean_reduce3 ] "+f"(mean_reduce[3])
                    : [ n_frep ] "r"(n_frep - 1), [ zero ] "f"(0.0f),
                      [ embeddings ] "f"((float)embeddings)
                    : "ft0", "ft1", "ft2");

                snrt_fpu_fence();

                asm volatile(
                    "vfcpka.s.s %[mean_v4_0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v4_1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v4_2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean_v4_3], %[zero], %[zero] \n"
                    "vfcpka.s.s %[var_v2_0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[var_v2_1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[var_v2_2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[var_v2_3], %[zero], %[zero] \n"
                    "frep.o  %[n_frep], 12, 0, 0 \n"
                    "vfsub.h %[var_v8_0], ft0, %[mean_reg] \n"
                    "vfsub.h %[var_v8_1], ft0, %[mean_reg] \n"
                    "vfsub.h %[var_v8_2], ft0, %[mean_reg] \n"
                    "vfsub.h %[var_v8_3], ft0, %[mean_reg] \n"
                    "vfadd.h ft1, %[var_v8_0], %[zero] \n"
                    "vfadd.h ft1, %[var_v8_1], %[zero] \n"
                    "vfadd.h ft1, %[var_v8_2], %[zero] \n"
                    "vfadd.h ft1, %[var_v8_3], %[zero] \n"
                    "vfmul.h %[pow_v8_0], %[var_v8_0], %[var_v8_0] \n"
                    "vfmul.h %[pow_v8_1], %[var_v8_1], %[var_v8_1] \n"
                    "vfmul.h %[pow_v8_2], %[var_v8_2], %[var_v8_2] \n"
                    "vfmul.h %[pow_v8_3], %[var_v8_3], %[var_v8_3] \n"
                    "vfsumex.h.b %[mean_v4_0], %[pow_v8_0] \n"
                    "vfsumex.h.b %[mean_v4_1], %[pow_v8_1] \n"
                    "vfsumex.h.b %[mean_v4_2], %[pow_v8_2] \n"
                    "vfsumex.h.b %[mean_v4_3], %[pow_v8_3] \n"
                    "vfsumex.s.h %[var_v2_0], %[mean_v4_0] \n"
                    "vfsumex.s.h %[var_v2_1], %[mean_v4_1] \n"
                    "vfsumex.s.h %[var_v2_2], %[mean_v4_2] \n"
                    "vfsumex.s.h %[var_v2_3], %[mean_v4_3] \n"
                    "vfsum.s %[var_v2_0], %[var_v2_0] \n"
                    "vfsum.s %[var_v2_1], %[var_v2_1] \n"
                    "vfsum.s %[var_v2_2], %[var_v2_2] \n"
                    "vfsum.s %[var_v2_3], %[var_v2_3] \n"
                    "fadd.s %[var_v2_0], %[var_v2_0], %[var_v2_1] \n"
                    "fadd.s %[var_v2_2], %[var_v2_2], %[var_v2_3] \n"
                    "fadd.s %[var_v2_0], %[var_v2_0], %[var_v2_2] \n"
                    "fdiv.s %[var_v2_0], %[var_v2_0], %[embeddings] \n"
                    "fadd.s %[var_v2_0], %[var_v2_0], %[eps] \n"
                    "fsqrt.s %[var_v2_0], %[var_v2_0] \n"
                    "fdiv.s %[var_v2_0], %[one], %[var_v2_0] \n"
                    "vfcpka.b.s %[mean_reg], %[var_v2_0], %[var_v2_0] \n"
                    "vfcpkb.b.s %[mean_reg], %[var_v2_0], %[var_v2_0] \n"
                    "vfcpkc.b.s %[mean_reg], %[var_v2_0], %[var_v2_0] \n"
                    "vfcpkd.b.s %[mean_reg], %[var_v2_0], %[var_v2_0] \n"
                    : [ mean_v2_0 ] "+f"(mean_v2[0].f64),
                      [ mean_v2_1 ] "+f"(mean_v2[1].f64),
                      [ mean_v2_2 ] "+f"(mean_v2[2].f64),
                      [ mean_v2_3 ] "+f"(mean_v2[3].f64),
                      [ mean_v4_0 ] "+f"(mean_v4[0].f64),
                      [ mean_v4_1 ] "+f"(mean_v4[1].f64),
                      [ mean_v4_2 ] "+f"(mean_v4[2].f64),
                      [ mean_v4_3 ] "+f"(mean_v4[3].f64),
                      [ var_v8_0 ] "+f"(var_v8[0].f64),
                      [ var_v8_1 ] "+f"(var_v8[1].f64),
                      [ var_v8_2 ] "+f"(var_v8[2].f64),
                      [ var_v8_3 ] "+f"(var_v8[3].f64),
                      [ mean_reg ] "+f"(mean_reg.f64),
                      [ pow_v8_0 ] "+f"(pow_v8[0].f64),
                      [ pow_v8_1 ] "+f"(pow_v8[1].f64),
                      [ pow_v8_2 ] "+f"(pow_v8[2].f64),
                      [ pow_v8_3 ] "+f"(pow_v8[3].f64),
                      [ var_v2_0 ] "+f"(var_v2[0].f64),
                      [ var_v2_1 ] "+f"(var_v2[1].f64),
                      [ var_v2_2 ] "+f"(var_v2[2].f64),
                      [ var_v2_3 ] "+f"(var_v2[3].f64)
                    : [ zero ] "f"(0.0f), [ n_frep ] "r"(n_frep - 1),
                      [ embeddings ] "f"((float)embeddings),
                      [ eps ] "f"((float)eps), [ one ] "f"(1.0f)
                    : "ft0", "ft1", "ft2");

                snrt_fpu_fence();

                snrt_ssr_read(SNRT_SSR_DM2, SNRT_SSR_2D,
                              &core_otile[b * batch_offset + s * stride]);

                asm volatile(
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfmul.b ft1, ft2, %[mean_reg] \n"
                    "vfmul.b ft1, ft2, %[mean_reg] \n"
                    "vfmul.b ft1, ft2, %[mean_reg] \n"
                    "vfmul.b ft1, ft2, %[mean_reg] \n"
                    : [ mean_reg ] "+f"(mean_reg.f64)
                    : [ n_frep ] "r"(n_frep - 1)
                    : "ft0", "ft1", "ft2");
                snrt_ssr_disable();
            }
        }
    }
}