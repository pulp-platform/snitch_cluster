// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>
// Viviane Potocnik <vivianep@iis.ee.ethz.ch>

#include "snrt.h"

/**
 * @struct fused_concat_linear_layer_t
 * @brief This structure contains all parameters necessary
 *        for computing a Concat layer.
 * @var fused_concat_linear_layer_t::input_shape
 * Shape of the input tensors
 * @var fused_concat_linear_layer_t::num_inputs
 * Number of input tensors to concatenate
 * @var fused_concat_linear_layer_t::inputs
 * Pointer to an array of pointers to the individual tensors to concatenate
 * @var fused_concat_linear_layer_t::output
 * Pointer to the concatenated output tensor
 */
typedef struct {
    uint32_t num_inputs;
    uint32_t input_shape[2];
    uint32_t output_shape[2];
    void **inputs;
    void *weights;
    void *concat_output;
    void *linear_output;
    precision_t dtype;
    uint32_t baseline;
    void *gemm_implementation;
} fused_concat_linear_layer_t;

static inline int fused_concat_linear_baseline(fused_concat_linear_layer_t l) {
    // Concat layer
    concat_layer_t concat_layer_cfg = {
        .num_inputs = l.num_inputs,
        .input_shape = {l.input_shape[0], l.input_shape[1]},
        .inputs = l.inputs,
        .output = l.concat_output,
        .dtype = l.dtype};
    int nerr = concat_layer(concat_layer_cfg);

    // Linear layer
    uint32_t m = l.input_shape[0];
    uint32_t k = l.input_shape[1] * l.num_inputs;
    uint32_t n = l.output_shape[1];

    gemm_args_t gemm_args;
    gemm_args_t *local_args = (gemm_args_t *)&gemm_args;

    local_args->alpha = 1.0;
    local_args->prec = l.dtype;
    local_args->setup_ssr = 0;
    local_args->parallelize_m = 1;
    local_args->parallelize_k = 0;
    local_args->m_tiles = snrt_cluster_core_num();
    local_args->n_tiles = 1;
    local_args->k_tiles = 1;
    local_args->load_a = 0;
    local_args->load_b = 1;
    local_args->load_c = 1;
    local_args->transa = 0;
    local_args->transb = 0;
    local_args->M = m;
    local_args->N = n;
    local_args->K = k;
    local_args->a = l.concat_output;
    local_args->b = l.weights;
    local_args->beta = 0;
    local_args->c = l.linear_output;
    local_args->gemm_fp = l.gemm_implementation;

    gemm(&local_args);

    snrt_global_barrier();

    return nerr;
}

static inline int fused_concat_linear_optimized(fused_concat_linear_layer_t l) {
    uint32_t m = l.input_shape[0];
    uint32_t k = l.input_shape[1];
    uint32_t n = l.output_shape[1];
    uint32_t concat_k = k * l.num_inputs;

    size_t size_a = m * k * l.dtype;
    void *a = snrt_l1_next();

    if (snrt_is_dm_core()) {
        snrt_dma_load_2d_tile(a, l.inputs[snrt_cluster_idx()], 0, 0, m, k, k,
                              l.dtype);
        snrt_dma_wait_all();
        snrt_l1_update_next(a + size_a);
    }
    snrt_cluster_hw_barrier();

    gemm_args_t gemm_args;
    gemm_args_t *local_args = (gemm_args_t *)&gemm_args;

    local_args->alpha = 1.0;
    local_args->prec = l.dtype;
    local_args->setup_ssr = 0;
    local_args->parallelize_m = 0;
    local_args->parallelize_k = 1;
    local_args->m_tiles = 1;
    local_args->n_tiles = 1;
    local_args->k_tiles = l.num_inputs;
    local_args->load_a = 0;
    local_args->load_b = 1;
    local_args->load_c = 1;
    local_args->transa = 0;
    local_args->transb = 0;
    local_args->M = m;
    local_args->N = n;
    local_args->K = concat_k;
    local_args->a = a;
    local_args->b = l.weights;
    local_args->beta = 0;
    local_args->c = l.linear_output;
    local_args->gemm_fp = l.gemm_implementation;

    gemm(&local_args);

    snrt_global_barrier();

    return 0;
}

static inline int fused_concat_linear_layer(fused_concat_linear_layer_t l) {
    return fused_concat_linear_optimized(l);
}
