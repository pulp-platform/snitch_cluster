// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"

/**
 * @struct gelu_layer_struct
 * @brief This structure contains all parameters necessary
 *        for computing the GELU activation function
 * @var gelu_layer_struct::batch_size
 * Size of each input sample
 * @var gelu_layer_struct::seq_len
 * Size of each output sample
 * @var gelu_layer_struct::hidden_nodes
 * Number of hidden dimensions
 * @var gelu_layer_struct::ifmap
 * Pointer to input feature map
 * @var gelu_layer_struct::ofmap
 * Pointer to output feature map
 */
typedef struct gelu_layer_struct {
    uint32_t batch_size;
    uint32_t seq_len;
    uint32_t hidden_nodes;
    float *ifmap;
    float *ofmap;
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
 * @param l gelu_layer_t struct that holds addresses and parameters
 *
 */
static inline void gelu_layer(const gelu_layer_t *l) {
    uint32_t cluster_num = snrt_cluster_num();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t compute_num = snrt_cluster_compute_core_num();
    uint32_t compute_id = snrt_cluster_compute_core_num();

    uint32_t ifmap_size =
        l->batch_size * l->seq_len * l->hidden_nodes * sizeof(float);
    uint32_t ofmap_size = ifmap_size;

    void *ptr = (float *)snrt_l1_next();
    float *ifmap = ptr;
    ptr += ifmap_size;
    float *ofmap = ptr;
    ptr += ofmap_size;

    // DMA transfer the ifmap into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_txid_t txid_ifmap = snrt_dma_start_2d(
            ifmap, l->ifmap, l->batch_size * sizeof(float),
            l->batch_size * sizeof(float), l->batch_size * sizeof(float),
            l->seq_len * l->hidden_nodes * sizeof(float));

        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        // determine the row offset for each core
        int32_t row_offset = compute_id * l->hidden_nodes;

        // determine the row stride of each matrix
        int32_t ldI = compute_num * l->hidden_nodes;

        // determine the batch offset for each core
        int32_t batch_offset = l->seq_len * l->hidden_nodes;

        // printf("row_offset: %d, ldI: %d\n", row_offset, ldI);

        for (int b = 0; b < l->batch_size; b++) {
            // if (compute_id == 1) {
            //     printf("BATCH: %d\n", b);
            // }
            gelu_fp32(&ifmap[row_offset + b * batch_offset],
                      &ofmap[row_offset + b * batch_offset], ldI, l->batch_size,
                      l->seq_len / 8, l->hidden_nodes);
        }

        snrt_cluster_hw_barrier();

    } else {
        snrt_cluster_hw_barrier();
    }

    snrt_global_barrier();
}