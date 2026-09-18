// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"
#include "fastexpf.h"

/**
 * @struct gelu_layer_struct
 * @brief This structure contains all parameters necessary
 *        for computing the GELU activation function
 * @var gelu_layer_struct::size
 * Size of the feature map
 * @var gelu_layer_struct::ifmap
 * Pointer to input feature map
 * @var gelu_layer_struct::ofmap
 * Pointer to output feature map
 */
typedef struct gelu_layer_struct {
    uint32_t size;
    float *ifmap;
    float *ofmap;
    precision_t dtype;
} gelu_layer_t;

// Fast approximation of the exponential function for single-precision floats
// used to avoid built int expf
float fp32_tanh(float x) {
    float ex  = fast_expf(x);
    float enx = fast_expf(-x);
    return (ex - enx) / (ex + enx);
}

// tanh based approximation of the GeLU activation function
static inline float gelu_activation_fp32(float x) {
    return 0.5f * x *
           (1.0f + fp32_tanh(sqrtf(2.0f / (float)M_PI) * (x + 0.044715f * x * x * x)));
}

// Sigmoid based approximation of the GeLU activation function
// adapted from i-BERT (https://arxiv.org/pdf/2101.01321.pdf)
static inline float sigmoid_gelu_fp32(float x, float a, float b) {
    // L(x) = sgn(x) [a(clip(|x|, max = −b) + b)^2 + 1]
    // a = -0.2888, b = -1.769
    float sign = x > 0.0f ? 1.0f : -1.0f;
    // float arg = clip(fabs(x), -b);
    float sqrt2_inv = 1 / 1.4142135623730951f;
    float x_scaled = sqrt2_inv * x;
    float arg = fabsf(x_scaled) > -b ? -b : fabsf(x_scaled);
    float l = sign * (a * arg * arg + 1.0f);
    return x * 0.5f * (1.0f + l);
}

// Single-cluster GeLU
static inline void gelu_fp32(float *input, float *output, uint32_t size) {
    
    if (snrt_is_compute_core()) {
        for (uint32_t i = 0; i < size; i++) {
            // output[i] = sigmoid_gelu_fp32(input[i], -0.2888, -1.769);
            output[i] = gelu_activation_fp32(input[i]);
        }
    }
    
}

// Parallel GeLU layer with DMA transfers
static inline void gelu_layer(const gelu_layer_t l) {
    // Parallelize the computation over clusters
    uint32_t cluster_fmap_size = l.size / snrt_cluster_num();
    uint32_t cluster_fmap_bytes = cluster_fmap_size * sizeof(float);

    // Allocate memory in TCDM
    float *ptr = (float *)snrt_l1_next();
    float *l1_ifmap = ptr;
    ptr += cluster_fmap_size;
    float *l1_ofmap = ptr;
    ptr += cluster_fmap_size;

    // Get pointer to feature maps in L3
    uint32_t cluster_offset = cluster_fmap_size * snrt_cluster_idx();
    float *l3_ifmap = l.ifmap + cluster_offset;
    float *l3_ofmap = l.ofmap + cluster_offset;

    // DMA transfer the ifmap into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(l1_ifmap, l3_ifmap, cluster_fmap_bytes);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();
    snrt_mcycle();
    // Cluster computation
    gelu_fp32(l1_ifmap, l1_ofmap, cluster_fmap_size);

    snrt_cluster_hw_barrier();
    snrt_mcycle();

    // DMA transfer the ofmap to DRAM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(l3_ofmap, l1_ofmap, cluster_fmap_bytes);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();
}
