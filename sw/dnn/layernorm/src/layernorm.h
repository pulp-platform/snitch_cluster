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
static inline void layernorm_fp32(float *input, float *output,
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

// Tiles the seq_len axis (assumes seq_len is an integer multiple of n_tiles)
// Distributes tiles to clusters (assumes n_tiles is an integer multiple of
// the number of clusters)
static inline void layernorm_layer(layernorm_layer_t l) {
    snrt_mcycle();

    // Compute the tiling parameters
    uint32_t n_tiles = l.n_tiles;
    uint32_t n_tiles_per_cluster = l.n_tiles / snrt_cluster_num();
    uint32_t tile_seq_len = l.seq_len / n_tiles;
    uint32_t tile_size = l.batch_size * tile_seq_len * l.embeddings;
    uint32_t tile_offset = tile_seq_len * l.embeddings;

    // Allocate space for arrays in TCDM
    float *local_itile = (float *)snrt_l1_next();
    float *local_otile = local_itile + tile_size;

    // Get pointers to arrays in DRAM
    float *remote_ifmap = (float *)l.ifmap;
    float *remote_ofmap = (float *)l.ofmap;

    // Iterate tiles
    snrt_mcycle();
    for (uint32_t cluster_tile_idx = 0; cluster_tile_idx < n_tiles_per_cluster;
         cluster_tile_idx++) {
        // Calculate absolute tile index
        uint32_t tile_idx =
            snrt_cluster_idx() * n_tiles_per_cluster + cluster_tile_idx;
        // Copy input tile
        if (snrt_is_dm_core()) {
            float *remote_itile = remote_ifmap + tile_idx * tile_offset;
            snrt_dma_txid_t txid_ifmap = snrt_dma_start_2d(
                local_itile,                                 /* dst */
                remote_itile,                                /* src */
                tile_seq_len * l.embeddings * sizeof(float), /* size */
                tile_seq_len * l.embeddings * sizeof(float), /* dst_stride */
                l.seq_len * l.embeddings * sizeof(float),    /* src_stride */
                l.batch_size                                 /* repetitions */
            );
            snrt_dma_wait_all();
            snrt_mcycle();
        }

        snrt_cluster_hw_barrier();

        // Compute layernorm tile
        if (snrt_is_compute_core()) snrt_mcycle();
        if (l.baseline == 1) {
            layernorm_fp32(local_itile, local_otile, l.batch_size, tile_seq_len,
                           l.embeddings, l.eps);
        } else {
            layernorm_fp32_opt(local_itile, local_otile, l.batch_size,
                               tile_seq_len, l.embeddings, l.eps);
        }
        if (snrt_is_compute_core()) snrt_mcycle();

        snrt_cluster_hw_barrier();

        // DMA transfer the ofmap to DRAM
        if (snrt_is_dm_core()) {
            snrt_mcycle();
            float *remote_otile = remote_ofmap + tile_idx * tile_offset;
            snrt_dma_txid_t txid_ofmap = snrt_dma_start_2d(
                remote_otile,                                /* dst */
                local_otile,                                 /* src */
                tile_seq_len * l.embeddings * sizeof(float), /* size */
                l.seq_len * l.embeddings * sizeof(float),    /* dst_stride */
                tile_seq_len * l.embeddings * sizeof(float), /* src_stride */
                l.batch_size                                 /* repetitions */
            );
            snrt_dma_wait_all();
            snrt_mcycle();
        }
    }

    snrt_global_barrier();
}
