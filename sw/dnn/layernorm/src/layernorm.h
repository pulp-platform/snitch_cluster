// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "dnn.h"
#include "math.h"
#include "snrt.h"

#define UNROLL 4

/**
 * @struct layernorm_layer_struct
 * @brief This structure contains all parameters necessary
 *        for computing the LayerNorm activation function
 * @var layernorm_layer_struct::batch_size
 * Size of each input sample
 * @var layernorm_layer_struct::seq_len
 * Size of each output sample
 * @var layernorm_layer_struct::embeddings
 * Number of hidden dimensions
 * @var layernorm_layer_struct::n_tiles
 * Number of tiles to split the data into
 * @var layernorm_layer_struct::ifmap
 * Pointer to input feature map
 * @var layernorm_layer_struct::ofmap
 * Pointer to output feature map
 */
typedef struct layernorm_layer_struct {
    uint32_t batch_size;
    uint32_t seq_len;
    uint32_t embeddings;
    uint32_t n_tiles;
    uint32_t baseline;
    float eps;
    void *ifmap;
    void *ofmap;
    precision_t dtype;
} layernorm_layer_t;

/**
 * Single-cluster implementation of a layernorm tile (data assumed in TCDM)
 */
static inline void layernorm_fp32_naive(float *input, float *output,
                                        int32_t batch_size, int32_t seq_len,
                                        int32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        // Get parameters for every core's tile
        // cores access rows in interleaved fashion
        // offset: offset between data accessed by every core (for
        //         corresponding iterations)
        // stride: offset between data accessed by the same core in
        //         consecutive iterations
        // tile_seq_len: fraction of the sequence assigned to each core
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        float *core_itile = input + offset;
        float *core_otile = output + offset;

        // get derived layernorm quantities
        uint32_t batch_offset = seq_len * embeddings;

        // compute the mean and variance along the last dimension
        float mean = 0.0;  // max value of the current core
        float var = 0.0;   // sum of the exp values of the current core
        for (int32_t b = 0; b < batch_size; b++) {
            for (int32_t s = 0; s < tile_seq_len; s++) {
                mean = 0.0;
                var = 0.0;

                for (int32_t i = 0; i < embeddings; i++) {
                    mean += core_itile[b * batch_offset + s * stride + i];
                }
                mean /= embeddings;

                for (int32_t i = 0; i < embeddings; i++) {
                    var +=
                        (core_itile[b * batch_offset + s * stride + i] - mean) *
                        (core_itile[b * batch_offset + s * stride + i] - mean);
                }
                var /= embeddings;
                var = sqrtf(var + eps);

                // compute the shifted value of the current row
                for (int32_t i = 0; i < embeddings; i++) {
                    core_otile[b * batch_offset + s * stride + i] =
                        (core_itile[b * batch_offset + s * stride + i] - mean) /
                        var;
                }
            }
        }

        snrt_fpu_fence();
    }
}

static inline void layernorm_fp32_opt(float *input, float *output,
                                      int32_t batch_size, int32_t seq_len,
                                      int32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        float *core_itile = input + offset;
        float *core_otile = output + offset;

        uint32_t batch_offset = seq_len * embeddings;

        // compute the mean and variance along the last dimension
        float mean_tot = 0.0;  // max value of the current core
        float var_tot = 0.0;   // sum of the exp values of the current core
        v2f32 mean_reg = {0.0, 0.0};
        int num_elems_per_vector = sizeof(double) / sizeof(float);
        for (int32_t b = 0; b < batch_size; b++) {
            const uint32_t ssr0_b[4] = {
                UNROLL, embeddings / (UNROLL * num_elems_per_vector), 2,
                tile_seq_len};
            const uint32_t ssr0_i[4] = {sizeof(double), UNROLL * sizeof(double),
                                        0, stride * sizeof(float)};

            const uint32_t ssr1_b[2] = {
                UNROLL, embeddings / (UNROLL * num_elems_per_vector)};
            const uint32_t ssr1_i[2] = {sizeof(double),
                                        UNROLL * sizeof(double)};

            snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_2d(SNRT_SSR_DM2, ssr1_b[0], ssr1_b[1], ssr1_i[0],
                             ssr1_i[1]);

            snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D,
                          &core_itile[b * batch_offset]);
            snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_4D,
                           &core_otile[b * batch_offset]);

            // kernel progresses two values in each iteration
            const uint32_t n_frep =
                embeddings / (UNROLL * num_elems_per_vector);

            for (int32_t s = 0; s < tile_seq_len; s++) {
                float mean[UNROLL] = {0.0, 0.0};
                float var[UNROLL] = {0.0, 0.0};
                mean_tot = 0.0;
                var_tot = 0.0;
                v2f32 var_reg[UNROLL];
                v2f32 pow[UNROLL];
                v2f32 one_reg = {1.0f, 1.0f};

                var_tot = 0.0;
                snrt_ssr_enable();
                // Computation of the row mean
                asm volatile(
                    "vfcpka.s.s %[mean0], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean1], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean2], %[zero], %[zero] \n"
                    "vfcpka.s.s %[mean3], %[zero], %[zero] \n"
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfsum.s %[mean0], ft0 \n"
                    "vfsum.s %[mean1], ft0 \n"
                    "vfsum.s %[mean2], ft0 \n"
                    "vfsum.s %[mean3], ft0 \n"
                    "fadd.s %[mean0], %[mean0], %[mean1] \n"
                    "fadd.s %[mean2], %[mean2], %[mean3] \n"
                    "fadd.s %[mean_tot], %[mean0], %[mean2] \n"
                    "fdiv.s %[mean_tot], %[mean_tot], %[embeddings] \n"
                    : [ mean0 ] "+f"(mean[0]), [ mean1 ] "+f"(mean[1]),
                      [ mean2 ] "+f"(mean[2]), [ mean3 ] "+f"(mean[3]),
                      [ mean_tot ] "+f"(mean_tot)
                    : [ n_frep ] "r"(n_frep - 1), [ zero ] "f"(0.0),
                      [ embeddings ] "f"((float)embeddings)
                    : "ft0", "ft1", "ft2");

                snrt_fpu_fence();

                // Computation of the row variance
                asm volatile(
                    "vfcpka.s.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    "frep.o  %[n_frep], 16, 0, 0 \n"
                    "vfsub.s %[var_reg0], ft0, %[mean_reg] \n"
                    "vfsub.s %[var_reg1], ft0, %[mean_reg] \n"
                    "vfsub.s %[var_reg2], ft0, %[mean_reg] \n"
                    "vfsub.s %[var_reg3], ft0, %[mean_reg] \n"
                    "vfadd.s ft1, %[var_reg0], %[zero] \n"
                    "vfadd.s ft1, %[var_reg1], %[zero] \n"
                    "vfadd.s ft1, %[var_reg2], %[zero] \n"
                    "vfadd.s ft1, %[var_reg3], %[zero] \n"
                    "vfmul.s %[pow0], %[var_reg0], %[var_reg0] \n"
                    "vfmul.s %[pow1], %[var_reg1], %[var_reg1] \n"
                    "vfmul.s %[pow2], %[var_reg2], %[var_reg2] \n"
                    "vfmul.s %[pow3], %[var_reg3], %[var_reg3] \n"
                    "vfsum.s %[var0], %[pow0] \n"
                    "vfsum.s %[var1], %[pow1] \n"
                    "vfsum.s %[var2], %[pow2] \n"
                    "vfsum.s %[var3], %[pow3] \n"
                    "fadd.s %[var0], %[var0], %[var1] \n"
                    "fadd.s %[var2], %[var2], %[var3] \n"
                    "fadd.s %[var_tot], %[var0], %[var2] \n"
                    "fdiv.s %[var_tot], %[var_tot], %[embeddings] \n"
                    "fadd.s %[var_tot], %[var_tot], %[eps] \n"
                    "fsqrt.s %[var_tot], %[var_tot] \n"
                    "fdiv.s %[var_tot], %[one_reg], %[var_tot] \n"
                    "vfcpka.s.s %[mean_reg], %[var_tot], %[var_tot] \n"

                    : [ var_reg0 ] "+f"(var_reg[0]),
                      [ var_reg1 ] "+f"(var_reg[1]),
                      [ var_reg2 ] "+f"(var_reg[2]),
                      [ var_reg3 ] "+f"(var_reg[3]), [ pow0 ] "+f"(pow[0]),
                      [ pow1 ] "+f"(pow[1]), [ pow2 ] "+f"(pow[2]),
                      [ pow3 ] "+f"(pow[3]), [ var0 ] "+f"(var[0]),
                      [ var1 ] "+f"(var[1]), [ var2 ] "+f"(var[2]),
                      [ var3 ] "+f"(var[3]), [ var_tot ] "+f"(var_tot),
                      [ mean_reg ] "+f"(mean_reg)
                    : [ n_frep ] "r"(n_frep - 1), [ mean_tot ] "f"(mean_tot),
                      [ embeddings ] "f"((float)embeddings),
                      [ eps ] "f"((float)eps), [ zero ] "f"(0.0),
                      [ one_reg ] "f"(one_reg)
                    : "ft0", "ft1", "ft2"

                );

                snrt_fpu_fence();

                snrt_ssr_read(SNRT_SSR_DM2, SNRT_SSR_2D,
                              &core_otile[b * batch_offset + s * stride]);
                // Normalization of the row
                asm volatile(
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    : [ mean_reg ] "+f"(mean_reg)
                    : [ n_frep ] "r"(n_frep - 1)
                    : "ft0", "ft1", "ft2"

                );
                snrt_ssr_disable();
            }
        }

        snrt_fpu_fence();
    }
}

static inline void layernorm_fp16_naive(__fp16 *input, __fp16 *output,
                                        int32_t batch_size, int32_t seq_len,
                                        int32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        // Get parameters for every core's tile
        // cores access rows in interleaved fashion
        // offset: offset between data accessed by every core (for
        //         corresponding iterations)
        // stride: offset between data accessed by the same core in
        //         consecutive iterations
        // tile_seq_len: fraction of the sequence assigned to each core
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        __fp16 *core_itile = input + offset;
        __fp16 *core_otile = output + offset;

        // get derived layernorm quantities
        uint32_t batch_offset = seq_len * embeddings;

        // compute the mean and variance along the last dimension
        float mean = 0.0;  // max value of the current core
        float var = 0.0;   // sum of the exp values of the current core
        for (int32_t b = 0; b < batch_size; b++) {
            for (int32_t s = 0; s < tile_seq_len; s++) {
                mean = 0.0;
                var = 0.0;

                for (int32_t i = 0; i < embeddings; i++) {
                    mean += core_itile[b * batch_offset + s * stride + i];
                }
                mean /= embeddings;

                for (int32_t i = 0; i < embeddings; i++) {
                    var +=
                        (core_itile[b * batch_offset + s * stride + i] - mean) *
                        (core_itile[b * batch_offset + s * stride + i] - mean);
                }
                var /= embeddings;
                var = sqrtf(var + eps);

                // compute the shifted value of the current row
                for (int32_t i = 0; i < embeddings; i++) {
                    core_otile[b * batch_offset + s * stride + i] =
                        (core_itile[b * batch_offset + s * stride + i] - mean) /
                        var;
                }
            }
        }

        snrt_fpu_fence();
    }
}

static inline void layernorm_fp16_opt(__fp16 *input, __fp16 *output,
                                      int32_t batch_size, int32_t seq_len,
                                      int32_t embeddings, int32_t eps) {
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

        int num_elems_per_vector = sizeof(double) / sizeof(__fp16);

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

static inline void layernorm_fp8_opt(char *input, char *output,
                                      int32_t batch_size, int32_t seq_len,
                                      int32_t embeddings, int32_t eps) {
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

        int num_elems_per_vector = sizeof(double) / sizeof(char);

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
                     :  [ zero ] "f"(0.0f), [ n_frep ] "r"(n_frep - 1),
                        [ embeddings ] "f"((float)embeddings), [ eps ] "f"((float)eps),
                        [ one ] "f"(1.0f)
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
// Tiles the seq_len axis (assumes seq_len is an integer multiple of n_tiles)
// Distributes tiles to clusters (assumes n_tiles is an integer multiple of
// the number of clusters)
static inline void layernorm_layer(layernorm_layer_t l) {
    uint32_t data_type_size;
    if (l.dtype == FP32) {
        data_type_size = sizeof(float);
    } else if (l.dtype == FP16) {
        data_type_size = sizeof(__fp16);
    } else if (l.dtype == FP8) {
        data_type_size = sizeof(char);
    } else {
        printf("Unsupported data type\n");
    }
    snrt_mcycle();

    // Compute the tiling parameters
    uint32_t n_tiles = l.n_tiles;
    uint32_t n_tiles_per_cluster = l.n_tiles / snrt_cluster_num();
    uint32_t tile_seq_len = l.seq_len / n_tiles;
    uint32_t tile_size =
        l.batch_size * tile_seq_len * l.embeddings * data_type_size;
    uint32_t tile_offset = tile_seq_len * l.embeddings * data_type_size;

    // Allocate space for arrays in TCDM
    void *local_itile;
    void *local_otile;
    void *remote_ifmap;
    void *remote_ofmap;

    if (l.dtype == FP32) {
        // cast local_itile and local_otile to float*
        local_itile = (float *)snrt_l1_next();
        local_otile = local_itile + tile_size;
        remote_ifmap = (float *)l.ifmap;
        remote_ofmap = (float *)l.ofmap;
    } else if (l.dtype == FP16) {
        local_itile = (__fp16 *)snrt_l1_next();
        local_otile = local_itile + tile_size;
        remote_ifmap = (__fp16 *)l.ifmap;
        remote_ofmap = (__fp16 *)l.ofmap;
    } else if (l.dtype == FP8) {
        local_itile = (char *)snrt_l1_next();
        local_otile = local_itile + tile_size;
        remote_ifmap = (char *)l.ifmap;
        remote_ofmap = (char *)l.ofmap;
    } else {
        printf("Unsupported data type\n");
    
    }

    // Iterate tiles
    snrt_mcycle();
    for (uint32_t cluster_tile_idx = 0; cluster_tile_idx < n_tiles_per_cluster;
         cluster_tile_idx++) {
        // Calculate absolute tile index
        uint32_t tile_idx =
            snrt_cluster_idx() * n_tiles_per_cluster + cluster_tile_idx;
        // Copy input tile
        if (snrt_is_dm_core()) {
            void *remote_itile = remote_ifmap + tile_idx * tile_offset;
            snrt_dma_txid_t txid_ifmap = snrt_dma_start_2d(
                local_itile,                                  /* dst */
                remote_itile,                                 /* src */
                tile_seq_len * l.embeddings * data_type_size, /* size */
                tile_seq_len * l.embeddings * data_type_size, /* dst_stride */
                l.seq_len * l.embeddings * data_type_size,    /* src_stride */
                l.batch_size                                  /* repetitions */
            );
            snrt_dma_wait_all();
            snrt_mcycle();
        }

        snrt_cluster_hw_barrier();

        // Compute layernorm tile
        if (snrt_is_compute_core()) snrt_mcycle();
        if (l.baseline == 1) {
            if (l.dtype == FP32)
                layernorm_fp32_naive(local_itile, local_otile, l.batch_size,
                                     tile_seq_len, l.embeddings, l.eps);
            else if (l.dtype == FP16)
                layernorm_fp16_naive(local_itile, local_otile, l.batch_size,
                                     tile_seq_len, l.embeddings, l.eps);
        } else {
            if (l.dtype == FP32) {
                layernorm_fp32_opt(local_itile, local_otile, l.batch_size,
                                   tile_seq_len, l.embeddings, l.eps);
            } else if (l.dtype == FP16) {
                layernorm_fp16_opt(local_itile, local_otile, l.batch_size,
                                   tile_seq_len, l.embeddings, l.eps);
            } else if (l.dtype == FP8) {
                layernorm_fp8_opt(local_itile, local_otile, l.batch_size,
                                  tile_seq_len, l.embeddings, l.eps);
            } else {
                printf("Unsupported data type\n");
            }
        }
        if (snrt_is_compute_core()) snrt_mcycle();

        snrt_cluster_hw_barrier();

        // DMA transfer the ofmap to DRAM
        if (snrt_is_dm_core()) {
            snrt_mcycle();
            void *remote_otile = remote_ofmap + tile_idx * tile_offset;
            snrt_dma_txid_t txid_ofmap = snrt_dma_start_2d(
                remote_otile,                                 /* dst */
                local_otile,                                  /* src */
                tile_seq_len * l.embeddings * data_type_size, /* size */
                l.seq_len * l.embeddings * data_type_size,    /* dst_stride */
                tile_seq_len * l.embeddings * data_type_size, /* src_stride */
                l.batch_size                                  /* repetitions */
            );
            snrt_dma_wait_all();
            snrt_mcycle();
        }
    }

    snrt_global_barrier();
}
