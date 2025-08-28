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
    uint32_t dtype;
    gemm_fp_t gemm_implementation;
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

    gemm_args_t gemm_args = {.m_tiles = snrt_cluster_num(),
                             .n_tiles = 1,
                             .k_tiles = 1,
                             .parallelize_m = 1,
                             .parallelize_k = 0,
                             .load_a = 0,
                             .load_b = 1,
                             .load_c = 1,
                             .double_buffer = 0,
                             .gemm_fp = l.gemm_implementation,
                             .prec = l.dtype,
                             .setup_ssr = 1,
                             .transa = 0,
                             .transb = 0,
                             .m = m,
                             .n = n,
                             .k = k,
                             .alpha = 1.0,
                             .a = l.concat_output,
                             .lda = k,
                             .b = l.weights,
                             .ldb = n,
                             .beta = 0,
                             .c = l.linear_output,
                             .ldc = n};

    gemm(&gemm_args);

    snrt_global_barrier();

    return nerr;
}

static inline int fused_concat_linear_optimized(fused_concat_linear_layer_t l) {
    uint32_t m = l.input_shape[0];
    uint32_t k = l.input_shape[1];
    uint32_t n = l.output_shape[1];
    uint32_t concat_k = k * l.num_inputs;

    size_t size_a = m * k * l.dtype;
    void *a = snrt_l1_alloc_cluster_local(size_a, l.dtype);

    if (snrt_is_dm_core() && (snrt_cluster_idx() < l.num_inputs)) {
        snrt_dma_load_2d_tile(a, l.inputs[snrt_cluster_idx()], 0, 0, m, k, k,
                              l.dtype);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    gemm_args_t gemm_args = {
        .m_tiles = 1,
        .n_tiles = 1,
        .k_tiles = l.num_inputs,
        .parallelize_m = 0,
        .parallelize_k = 1,
        .load_a = 0,
        .load_b = 1,
        .load_c = 1,
        .double_buffer = 0,
        .gemm_fp = l.gemm_implementation,
        .prec = l.dtype,
        .setup_ssr = 1,
        .transa = 0,
        .transb = 0,
        .m = m,
        .n = n,
        .k = concat_k,
        .alpha = 1.0,
        .a = a,
        .lda = concat_k,
        .b = l.weights,
        .ldb = n,
        .beta = 0,
        .c = l.linear_output,
        .ldc = n,
    };

    gemm(&gemm_args);

    snrt_global_barrier();

    return 0;
}

static inline int fused_concat_linear_layer(fused_concat_linear_layer_t l) {
    return fused_concat_linear_optimized(l);
}
