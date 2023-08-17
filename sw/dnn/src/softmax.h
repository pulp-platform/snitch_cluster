// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"
// #include "printf.h"
#include "utils.h"

/**
 * @struct softmax_layer_struct
 * @brief This structure contains all parameters necessary
 *       for computing the Softmax activation function
 * @var softmax_layer_struct::BATCH_SIZE
 * Size of each input sample
 * @var softmax_layer_struct::SEQ_LEN
 * Size of each output sample
 * @var softmax_layer_struct::INPUT_SAMPLES
 * Number of input samples
 * @var softmax_layer_struct::REDUCE_DIM
 * Along which dimension to reduce
 * @var softmax_layer_struct::ifmap
 * Pointer to input feature map
 * @var softmax_layer_struct::ofmap
 * Pointer to output feature map
 * @var softmax_layer_struct::result
 * Pointer to the golden model output
 */
typedef struct softmax_layer_struct {
    uint32_t BATCH_SIZE;
    uint32_t SEQ_LEN;
    uint32_t INPUT_SAMPLES;
    uint32_t REDUCE_DIM;

    float *ifmap;
    float *ofmap;
    float *result;

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

    // uint32_t compute_id = snrt_global_core_idx();
    // uint32_t num_cores = snrt_cluster_compute_core_num();

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
                    // FIXME: Below code is erroring due to the standard math
                    // lib conflict
                    // TODO: Try out with musl lib
                    // expf(input[b * batch_offset + s * ldI + i] - max_core);
                    // FIXME: actually there should be an exponentiation
                    input[b * batch_offset + s * ldI + i] - max_core;
                sum += output[b * batch_offset + s * ldI + i];
            }

            // compute the softmax value of the current row
            for (int32_t i = 0; i < input_samples; i++) {
                // INFO: DIVSQRT unit MUST be activated in the cluster
                // configuration
                output[b * batch_offset + s * ldI + i] /= sum;
                // printf("output[%d] = %f\n", compute_id * input_samples + b *
                // batch_offset + s * ldI + i,
                //        output[b * batch_offset + s * ldI + i]);
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
static inline void softmax_layer(softmax_layer_t *const l) {
    uint32_t cluster_num = snrt_cluster_num();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t compute_num = snrt_cluster_compute_core_num();
    uint32_t compute_id = snrt_global_core_idx();

    uint32_t ifmap_size =
        l->BATCH_SIZE * l->SEQ_LEN * l->INPUT_SAMPLES * sizeof(float);
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
            l->SEQ_LEN * l->INPUT_SAMPLES * sizeof(float));

        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        // determine the row offset for each core
        int32_t row_offset = compute_id * l->INPUT_SAMPLES;

        // determine the row stride of each matrix
        int32_t ldI = compute_num * l->INPUT_SAMPLES;

        // determine the batch offset for each core
        int32_t batch_offset = l->SEQ_LEN * l->INPUT_SAMPLES;

        // printf("row_offset: %d, ldI: %d\n", row_offset, ldI);
        softmax_fp32(&ifmap[row_offset], &ofmap[row_offset], ldI, batch_offset,
                     l->BATCH_SIZE, l->SEQ_LEN / 8, l->INPUT_SAMPLES);

    } else {
        snrt_cluster_hw_barrier();
    }

    snrt_global_barrier();
}