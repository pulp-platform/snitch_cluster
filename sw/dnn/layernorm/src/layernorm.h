// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"
// #include "printf.h"
#include "dnn.h"

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

                // compute the shifted value of the current row
                for (int32_t i = 0; i < embeddings; i++) {
                    core_otile[b * batch_offset + s * stride + i] =
                        (core_itile[b * batch_offset + s * stride + i] - mean) /
                        sqrtf(var + eps);
                }
            }
        }

        snrt_fpu_fence();
    }
}

// /**
//  * Implementation of the LayerNorm layer for the Transformer model for FP64.
//  */
// static inline void transformer_layernorm_fp64(double *input, int32_t ldI,
//                                               int32_t seq_len, int32_t
//                                               embeddings, int32_t eps) {
//     layernorm_fp64(input, input, ldI, 0, 1, seq_len, embeddings, eps);
// }

// /**
//  * Implementation of the LayerNorm layer for the Transformer model for FP32.
//  */
// static inline void transformer_layernorm_fp32(float *input, int32_t ldI,
//                                               int32_t seq_len, int32_t
//                                               embeddings, int32_t eps) {
//     layernorm_fp32(input, input, ldI, 0, 1, seq_len, embeddings, eps);
// }

// Tiles the seq_len axis
static inline void layernorm_layer(layernorm_layer_t l) {
    snrt_mcycle();

    // Compute the tiling parameters
    uint32_t n_tiles = l.n_tiles;
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
    for (int tile_idx = 0; tile_idx < n_tiles; tile_idx++) {
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
        layernorm_fp32(local_itile, local_otile, l.batch_size, tile_seq_len,
                       l.embeddings, l.eps);
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
