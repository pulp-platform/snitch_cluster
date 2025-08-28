// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"

/**
 * @struct softmax_layer_struct
 * @brief This structure contains all parameters necessary
 *       for computing the Softmax activation function
 * @var softmax_layer_struct::batch_size
 * Size of each input sample
 * @var softmax_layer_struct::seq_len
 * Size of each output sample
 * @var softmax_layer_struct::input_samples
 * Number of input samples
 * @var softmax_layer_struct::reduce_dim
 * Along which dimension to reduce
 * @var softmax_layer_struct::ifmap
 * Pointer to input feature map
 * @var softmax_layer_struct::ofmap
 * Pointer to output feature map
 */
typedef struct softmax_layer_struct {
    uint32_t batch_size;
    uint32_t seq_len;
    uint32_t input_samples;
    int32_t reduce_dim;
    float *ifmap;
    float *ofmap;
    precision_t dtype;
} softmax_layer_t;

/**
 * Implementation of the SoftMax layer.
 */
static inline void softmax_fp32(float *input, float *output, int32_t ldI,
                                int32_t batch_offset, int32_t batch_size,
                                int32_t seq_len, int32_t input_samples) {
    float max_core = 0.0;  // max value of the current core
    float sum = 0.0;       // sum of the exp values of the current core

    for (int32_t b = 0; b < batch_size; b++) {
        for (int32_t s = 0; s < seq_len; s++) {
            max_core = -INFINITY;
            sum = 0.0;

            for (int32_t i = 0; i < input_samples; i++) {
                if (input[b * batch_offset + s * ldI + i] > max_core) {
                    max_core = input[b * batch_offset + s * ldI + i];
                }
            }

            // compute the shifted value of the current row
            for (int32_t i = 0; i < input_samples; i++) {
                output[b * batch_offset + s * ldI + i] =
                    expf(input[b * batch_offset + s * ldI + i] - max_core);
                sum += output[b * batch_offset + s * ldI + i];
            }

            // compute the softmax value of the current row
            for (int32_t i = 0; i < input_samples; i++) {
                output[b * batch_offset + s * ldI + i] /= sum;
            }
        }
    }

    snrt_cluster_hw_barrier();
}

/**
 * @brief  SoftMax layer
 *
 * @param l softmax_layer struct that holds addresses and parameters
 *
 */
static inline void softmax_layer(softmax_layer_t const l) {
    uint32_t cluster_num = snrt_cluster_num();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t compute_num = snrt_cluster_compute_core_num();
    uint32_t compute_id = snrt_global_core_idx();

    uint32_t ifmap_size = l.batch_size * l.seq_len * l.input_samples;
    uint32_t ofmap_size = ifmap_size;

    float *ptr = (float *)snrt_l1_next();
    float *ifmap = ptr;
    ptr += ifmap_size;
    float *ofmap = ptr;
    ptr += ofmap_size;

    // DMA transfer the ifmap into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_txid_t txid_ifmap = snrt_dma_start_2d(
            ifmap, l.ifmap, l.batch_size * sizeof(float),
            l.batch_size * sizeof(float), l.batch_size * sizeof(float),
            l.seq_len * l.input_samples * sizeof(float));

        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        // determine the row offset for each core
        int32_t row_offset = compute_id * l.input_samples;

        // determine the row stride of each matrix
        int32_t ldI = compute_num * l.input_samples;

        // determine the batch offset for each core
        int32_t batch_offset = l.seq_len * l.input_samples;

        // printf("row_offset: %d, ldI: %d\n", row_offset, ldI);
        softmax_fp32(&ifmap[row_offset], &ofmap[row_offset], ldI, batch_offset,
                     l.batch_size, l.seq_len / compute_num, l.input_samples);

    } else {
        snrt_cluster_hw_barrier();
    }

    // DMA transfer the ofmap to DRAM
    if (snrt_is_dm_core()) {
        snrt_dma_txid_t txid_ofmap = snrt_dma_start_2d(
            l.ofmap, ofmap, l.batch_size * sizeof(float),
            l.batch_size * sizeof(float), l.batch_size * sizeof(float),
            l.seq_len * l.input_samples * sizeof(float));

        snrt_dma_wait_all();
    }

    snrt_global_barrier();
}