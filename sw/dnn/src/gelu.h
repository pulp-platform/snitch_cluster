// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

// #include "printf.h"
#include "snrt.h"
#include "utils.h"

/**
 * @struct gelu_layer_struct
 * @brief This structure contains all parameters necessary
 *        for computing the GELU activation function
 * @var gelu_layer_struct::BATCH_SIZE
 * Size of each input sample
 * @var gelu_layer_struct::SEQ_LEN
 * Size of each output sample
 * @var gelu_layer_struct::HIDDEN_NODES
 * Number of hidden dimensions
 * @var gelu_layer_struct::ifmap
 * Pointer to input feature map
 * @var gelu_layer_struct::ofmap
 * Pointer to output feature map
 * @var gelu_layer_struct::result
 * Pointer to the golden model output
 */
typedef struct gelu_layer_struct {
    uint32_t BATCH_SIZE;
    uint32_t SEQ_LEN;
    uint32_t HIDDEN_NODES;

    float *ifmap;
    float *ofmap;
    float *result;

    precision_t dtype;
} gelu_layer_t;


/**
 * Implementation of the GELU layer
 */
static inline void gelu_fp32(float *input, float *output, int32_t ldI,
                             uint32_t batch_size, uint32_t seq_len,
                             uint32_t hidden_nodes) {
    // uint32_t compute_id = snrt_cluster_compute_core_num();

    for (int s = 0; s < seq_len; s++) {
        for (int h = 0; h < hidden_nodes; h++) {
            // if (compute_id == 1) {
            //     printf("compute id: %d, input[%d][%d] = %f\n", compute_id, s,
            //     h,
            //         input[s * hidden_nodes + h]);
            // }
            float x = input[s * hidden_nodes + h];
            float y =
                0.5 * x *
                (1.0 + tanh(sqrt(2.0 / M_PI) * (x + 0.044715 * x * x * x)));
            output[s * hidden_nodes + h] = y;

            // if (compute_id == 1) {
            //     printf("compute id: %d, output[%d][%d] = %f\n", compute_id,
            //     s, h,
            //         output[s * hidden_nodes + h]);
            // }
        }
    }
}

/**
 * @brief  GELU layer
 *
 * @param l gelu_layer struct that holds addresses and parameters
 *
 */
static inline void gelu_layer(const gelu_layer_t *l) {
    uint32_t cluster_num = snrt_cluster_num();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t compute_num = snrt_cluster_compute_core_num();
    uint32_t compute_id = snrt_cluster_compute_core_num();

    uint32_t ifmap_size =
        l->BATCH_SIZE * l->SEQ_LEN * l->HIDDEN_NODES * sizeof(float);
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
            l->SEQ_LEN * l->HIDDEN_NODES * sizeof(float));

        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core() &&
        snrt_cluster_compute_core_num() < compute_num) {
        // determine the row offset for each core
        int32_t row_offset = compute_id * l->HIDDEN_NODES;

        // determine the row stride of each matrix
        int32_t ldI = compute_num * l->HIDDEN_NODES;

        // determine the batch offset for each core
        int32_t batch_offset = l->SEQ_LEN * l->HIDDEN_NODES;

        // printf("row_offset: %d, ldI: %d\n", row_offset, ldI);

        for (int b = 0; b < l->BATCH_SIZE; b++) {
            // if (compute_id == 1) {
            //     printf("BATCH: %d\n", b);
            // }
            gelu_fp32(&ifmap[row_offset + b * batch_offset],
                      &ofmap[row_offset + b * batch_offset], ldI, l->BATCH_SIZE,
                      l->SEQ_LEN / 8, l->HIDDEN_NODES);
        }

        snrt_cluster_hw_barrier();

    } else {
        snrt_cluster_hw_barrier();
    }

    snrt_global_barrier();
}