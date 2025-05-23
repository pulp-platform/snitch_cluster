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
 * @var gelu_layer_struct::size
 * Size of the feature map
 * @var gelu_layer_struct::ifmap
 * Pointer to input feature map
 * @var gelu_layer_struct::ofmap
 * Pointer to output feature map
 */
typedef struct gelu_layer_struct {
    uint32_t size;
    double *ifmap;
    double *ofmap;
    precision_t dtype;
} gelu_layer_t;

// tanh based approximation of the GeLU activation function
static inline double gelu_activation_fp64(double x) {
    return 0.5 * x *
           (1.0 + tanh(sqrt(2.0 / M_PI) * (x + 0.044715 * x * x * x)));
}

// Sigmoid based approximation of the GeLU activation function
// adapted from i-BERT (https://arxiv.org/pdf/2101.01321.pdf)
static inline double sigmoid_gelu_fp64(double x, float a, float b) {
    // L(x) = sgn(x) [a(clip(|x|, max = −b) + b)^2 + 1]
    // a = -0.2888, b = -1.769
    double sign = x > 0.0 ? 1.0 : -1.0;
    // double arg = clip(fabs(x), -b);
    double sqrt2_inv = 1 / 1.4142135623730951;
    double x_scaled = sqrt2_inv * x;
    double arg = fabs(x_scaled) > -b ? -b : fabs(x_scaled);
    double l = sign * (a * arg * arg + 1.0);
    return x * 0.5 * (1 + l);
}

// Single-cluster GeLU
static inline void gelu_fp64(double *input, double *output, uint32_t size) {
    if (snrt_is_compute_core()) {
        for (uint32_t i = 0; i < size; i++) {
            snrt_mcycle();
            // output[i] = sigmoid_gelu_fp64(input[i], -0.2888, -1.769);
            output[i] = gelu_activation_fp64(input[i]);
        }
    }
}

// Parallel GeLU layer with DMA transfers
static inline void gelu_layer(const gelu_layer_t l) {
    // Parallelize the computation over clusters
    uint32_t cluster_fmap_size = l.size / snrt_cluster_num();
    uint32_t cluster_fmap_bytes = cluster_fmap_size * sizeof(double);

    // Allocate memory in TCDM
    double *ptr = (double *)snrt_l1_next();
    double *l1_ifmap = ptr;
    ptr += cluster_fmap_size;
    double *l1_ofmap = ptr;
    ptr += cluster_fmap_size;

    // Get pointer to feature maps in L3
    uint32_t cluster_offset = cluster_fmap_size * snrt_cluster_idx();
    double *l3_ifmap = l.ifmap + cluster_offset;
    double *l3_ofmap = l.ofmap + cluster_offset;

    // DMA transfer the ifmap into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(l1_ifmap, l3_ifmap, cluster_fmap_bytes);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    // Cluster computation
    gelu_fp64(l1_ifmap, l1_ofmap, cluster_fmap_size);

    snrt_cluster_hw_barrier();

    // DMA transfer the ofmap to DRAM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(l3_ofmap, l1_ofmap, cluster_fmap_bytes);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();
}
