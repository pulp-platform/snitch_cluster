// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

static inline void mha_fp32(mha_layer_t layer) {
    // Run FlashAttention only on clusters that are assigned heads
    if (snrt_cluster_idx() < layer.num_heads) {
        // Prepare arguments for FlashAttention-2
        flashattention_2_layer_t fa2_args;
        fa2_args.L = layer.L;
        fa2_args.S = layer.S;
        fa2_args.d = layer.d;
        fa2_args.B_r = layer.B_r;
        fa2_args.B_c = layer.B_c;
        fa2_args.Q = ((float **)layer.Q)[snrt_cluster_idx()];
        fa2_args.K = ((float **)layer.K)[snrt_cluster_idx()];
        fa2_args.V = ((float **)layer.V)[snrt_cluster_idx()];
        fa2_args.O = ((float **)layer.head_outputs)[snrt_cluster_idx()];
        fa2_args.dtype = layer.dtype;
        fa2_args.baseline = layer.baseline;
        fa2_args.gemm_implementation = layer.gemm_implementation;

        // Call FlashAttention-2
        flashattention_2_fp32(fa2_args);
    }

    snrt_fpu_fence();
    snrt_global_barrier();

    // Prepare arguments for the FusedConcatLinear layer
    fused_concat_linear_layer_t fcl_args;
    fcl_args.num_inputs = layer.num_heads;
    fcl_args.input_shape[0] = layer.L;
    fcl_args.input_shape[1] = layer.d;
    fcl_args.output_shape[0] = layer.L;
    fcl_args.output_shape[1] = layer.d;
    fcl_args.inputs = layer.head_outputs;
    fcl_args.weights = layer.W;
    fcl_args.concat_output = nullptr;
    fcl_args.linear_output = layer.O;
    fcl_args.dtype = layer.dtype;
    fcl_args.gemm_implementation = layer.gemm_implementation;

    // Call the FusedConcatLinear layer
    fused_concat_linear_layer(fcl_args);
}