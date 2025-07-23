// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

// #include "blas.h"
// #include "snrt.h"

/**
 * @struct mha_layer_t
 * @brief This structure contains all parameters necessary
 *        for computing a Multihead attention layer using FlashAttention-2.
 *        Refer to
 *        "FlashAttention-2: Faster Attention with Better
 *        Parallelism and Work Partitioning" for more info.
 *        The FlashAttention-2 paper refers to a single sequence
 *        length N. To support auto-regressive inference we
 *        define two separate parameters L and S, following the
 *        PyTorch naming scheme.
 * @var mha_layer_t::L
 * Target sequence length
 * @var mha_layer_t::S
 * Source sequence length
 * @var mha_layer_t::d
 * Head dimension
 * @var mha_layer_t::Q
 * Pointer to query tensor
 * @var mha_layer_t::K
 * Pointer to key tensor
 * @var mha_layer_t::V
 * Pointer to value tensor
 * @var mha_layer_t::head_outputs
 * Pointer to output tensor of each head
 * @var mha_layer_t::O
 * Pointer to output tensor
 */
typedef struct {
    uint32_t num_heads;
    uint32_t L;
    uint32_t S;
    uint32_t d;
    uint32_t B_r;
    uint32_t B_c;
    precision_t dtype;
    uint32_t baseline;
    gemm_fp_t gemm_implementation;
    void **Q;
    void **K;
    void **V;
    void *W;
    void **head_outputs;
    void *O;
} mha_layer_t;

#include "../mha/src/mha_fp32.h"

static inline void mha_layer(mha_layer_t layer) { mha_fp32(layer); }