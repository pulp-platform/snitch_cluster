// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

/**
 * @struct concat_layer_t
 * @brief This structure contains all parameters necessary
 *        for computing a Concat layer.
 * @var concat_layer_t::input_shape
 * Shape of the input tensors
 * @var concat_layer_t::num_inputs
 * Number of input tensors to concatenate
 * @var concat_layer_t::inputs
 * Pointer to an array of pointers to the individual tensors to concatenate
 * @var concat_layer_t::output
 * Pointer to the concatenated output tensor
 */
typedef struct {
    uint32_t num_inputs;
    uint32_t input_shape[2];
    void **inputs;
    void *output;
    uint32_t dtype;
} concat_layer_t;

// Concatenates a series of input tensors along the innermost axis.
// Every cluster stores one of the input tensors in the output tensor, all
// clusters operate in parallel.
// Note: currently requires that the number of inputs is smaller than the
// number of clusters in the system.
static inline int concat_layer(concat_layer_t l) {
    // Return error if number of input tensors is greater than number of
    // clusters
    if (l.num_inputs > snrt_cluster_num()) return 1;

    // Perform the concatenation
    if (snrt_is_dm_core()) {
        if (snrt_cluster_idx() < l.num_inputs) {
            size_t row_size = l.input_shape[1] * sizeof(double);
            size_t concatenated_row_size = row_size * l.num_inputs;
            uintptr_t input = (uintptr_t)l.inputs[snrt_cluster_idx()];
            uintptr_t output =
                (uintptr_t)l.output + snrt_cluster_idx() * row_size;
            snrt_dma_start_2d(output,                 // dst
                              input,                  // src
                              row_size,               // size
                              concatenated_row_size,  // dst_stride
                              row_size,               // src_stride
                              l.input_shape[0]        // repeat
            );
            snrt_dma_wait_all();
        }
    }

    snrt_global_barrier();
    return 0;
}
