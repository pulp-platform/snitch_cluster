// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"
// #include "printf.h"
#include "utils.h"

/**
 * @struct layernorm_layer_struct
 * @brief This structure contains all parameters necessary
 *        for computing the LayerNorm activation function
 * @var layernorm_layer_struct::BATCH_SIZE
 * Size of each input sample
 * @var layernorm_layer_struct::SEQ_LEN
 * Size of each output sample
 * @var layernorm_layer_struct::EMBEDDINGS
 * Number of hidden dimensions
 * @var layernorm_layer_struct::ifmap
 * Pointer to input feature map
 * @var layernorm_layer_struct::ofmap
 * Pointer to output feature map
 * @var layernorm_layer_struct::result
 * Pointer to the golden model output
 */
typedef struct layernorm_layer_struct {
    uint32_t BATCH_SIZE;
    uint32_t SEQ_LEN;
    uint32_t EMBEDDINGS;
    uint32_t EPS;

    float *ifmap;
    float *ofmap;
    float *result;

    precision_t dtype;
} layernorm_layer_t;

/**
 * Implementation of the LayerNorm layer.
 */
static inline void layernorm_fp32(float *input, float *output, int32_t ldI,
                                  int32_t batch_offset, int32_t batch_size,
                                  int32_t seq_len, int32_t embeddings,
                                  int32_t eps) {
    float mean = 0.0;  // max value of the current core
    float var = 0.0;   // sum of the exp values of the current core

    uint32_t compute_id = snrt_global_core_idx();
    uint32_t num_cores = snrt_cluster_compute_core_num();

    // compute the mean and variance along the last dimension
    for (int32_t b = 0; b < batch_size; b++) {
        for (int32_t s = 0; s < seq_len; s++) {
            mean = 0.0;
            var = 0.0;

            for (int32_t i = 0; i < embeddings; i++) {
                mean += input[b * batch_offset + s * ldI + i];
            }
            mean /= embeddings;

            // printf("mean[%d] = %f\n", b, mean);

            for (int32_t i = 0; i < embeddings; i++) {
                var += (input[b * batch_offset + s * ldI + i] - mean) *
                       (input[b * batch_offset + s * ldI + i] - mean);
            }
            var /= embeddings;

            // printf("var[%d] = %f\n", b, var);

            // compute the shifted value of the current row
            for (int32_t i = 0; i < embeddings; i++) {
                output[b * batch_offset + s * ldI + i] =
                    (input[b * batch_offset + s * ldI + i] - mean) /
                    sqrtf(var + eps);
                // printf("output[%d][%d][%d] = %f\n", b, s + compute_id, i,
                //        output[b * batch_offset + s * ldI + i]);
            }
        }
    }

    snrt_cluster_hw_barrier();
}

/**
 * @brief  layernorm layer
 *
 * @param l layernorm_layer struct that holds addresses and parameters
 *
 */
static inline void layernorm_layer(const layernorm_layer_t *l) {
    uint32_t cluster_num = snrt_cluster_num();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t compute_num = snrt_cluster_compute_core_num();
    uint32_t compute_id = snrt_global_core_idx();

    uint32_t ifmap_size =
        l->BATCH_SIZE * l->SEQ_LEN * l->EMBEDDINGS * sizeof(float);
    uint32_t ofmap_size = ifmap_size;

    void *ptr = (float *)snrt_l1_next();
    float *ifmap = ptr;
    ptr += ifmap_size;
    float *ofmap = ptr;
    ptr += ofmap_size;

    // DMA transfer the ifmap into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_txid_t txid_ifmap = snrt_dma_start_2d(
            ifmap, l->ifmap, l->BATCH_SIZE * sizeof(float),
            l->BATCH_SIZE * sizeof(float), l->BATCH_SIZE * sizeof(float),
            l->SEQ_LEN * l->EMBEDDINGS * sizeof(float));

        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        // determine the row offset for each core
        int32_t row_offset = compute_id * l->EMBEDDINGS;

        // determine the row stride of each matrix
        int32_t ldI = compute_num * l->EMBEDDINGS;

        // determine the batch offset for each core
        int32_t batch_offset = l->SEQ_LEN * l->EMBEDDINGS;

        // printf("row_offset: %d, ldI: %d\n", row_offset, ldI);
        layernorm_fp32(&ifmap[row_offset], &ofmap[row_offset], ldI,
                       batch_offset, l->BATCH_SIZE, l->SEQ_LEN / 8,
                       l->EMBEDDINGS, l->EPS);

    } else {
        snrt_cluster_hw_barrier();
    }

    snrt_global_barrier();
}