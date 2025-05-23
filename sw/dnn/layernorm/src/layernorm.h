// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "dnn.h"
#include "math.h"
#include "snrt.h"

#include "layernorm_fp16.h"
#include "layernorm_fp32.h"
#include "layernorm_fp8.h"

typedef enum { NAIVE, OPT } implementation_t;

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
    implementation_t implementation;
    float eps;
    void *ifmap;
    void *ofmap;
    precision_t dtype;
} layernorm_layer_t;

// Tiles the seq_len axis (assumes seq_len is an integer multiple of n_tiles)
// Distributes tiles to clusters (assumes n_tiles is an integer multiple of
// the number of clusters)
static inline void layernorm_layer(layernorm_layer_t l) {
    uint32_t data_type_size = l.dtype;

    snrt_mcycle();

    // Compute the tiling parameters
    uint32_t n_tiles = l.n_tiles;
    uint32_t n_tiles_per_cluster = l.n_tiles / snrt_cluster_num();
    uint32_t tile_seq_len = l.seq_len / n_tiles;
    uint32_t tile_size =
        l.batch_size * tile_seq_len * l.embeddings * data_type_size;
    uint32_t tile_offset = tile_seq_len * l.embeddings * data_type_size;

    // Allocate space for arrays in TCDM
    char *local_itile;
    char *local_otile;
    char *remote_ifmap;
    char *remote_ofmap;

    local_itile = (char *)snrt_l1_next();
    local_otile = local_itile + tile_size;
    remote_ifmap = (char *)l.ifmap;
    remote_ofmap = (char *)l.ofmap;

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

        switch (l.dtype) {
            case FP32:
                switch (l.implementation) {
                    case NAIVE:
                        layernorm_naive<float>(
                            (float *)local_itile, (float *)local_otile,
                            l.batch_size, tile_seq_len, l.embeddings, l.eps);
                        break;
                    case OPT:
                        layernorm_fp32_opt((float *)local_itile,
                                           (float *)local_otile, l.batch_size,
                                           tile_seq_len, l.embeddings, l.eps);
                        break;
                }
                break;
            case FP16:
                switch (l.implementation) {
                    case NAIVE:
                        layernorm_naive<__fp16>(
                            (__fp16 *)local_itile, (__fp16 *)local_otile,
                            l.batch_size, tile_seq_len, l.embeddings, l.eps);
                        break;
                    case OPT:
                        layernorm_fp16_opt((__fp16 *)local_itile,
                                           (__fp16 *)local_otile, l.batch_size,
                                           tile_seq_len, l.embeddings, l.eps);
                        break;
                }
                break;
            case FP8:
                switch (l.implementation) {
                    case NAIVE:
                        return;
                    case OPT:
                        layernorm_fp8_opt(local_itile, local_otile,
                                          l.batch_size, tile_seq_len,
                                          l.embeddings, l.eps);
                        break;
                }
                break;
            default:
                return;
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
