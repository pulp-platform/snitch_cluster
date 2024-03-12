// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Viviane Potocnik <vivianep@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "blas.h"
#include "snrt.h"

/**
 * @struct flashattention_2_layer_t
 * @brief This structure contains all parameters necessary
 *        for computing a FlashAttention-2 layer. Refer to
 *        "FlashAttention-2: Faster Attention with Better
 *        Parallelism and Work Partitioning" for more info
 * @var flashattention_2_layer_t::N
 * Sequence length in number of tokens
 * @var flashattention_2_layer_t::d
 * Head dimension
 * @var flashattention_2_layer_t::Q
 * Pointer to query tensor
 * @var flashattention_2_layer_t::K
 * Pointer to key tensor
 * @var flashattention_2_layer_t::V
 * Pointer to value tensor
 * @var flashattention_2_layer_t::O
 * Pointer to output tensor
 */
typedef struct {
    uint32_t N;
    uint32_t d;
    uint32_t B_r;
    uint32_t B_c;
    void *Q;
    void *K;
    void *V;
    void *O;
    precision_t dtype;
    uint32_t baseline;
} flashattention_2_layer_t;

#include "flashattention_2_fp16.h"
#include "flashattention_2_fp32.h"

static inline void flashattention_2_layer(flashattention_2_layer_t layer) {
    switch (layer.dtype) {
        case FP32:
            flashattention_2_fp32(layer);
            break;
        case FP16:
            flashattention_2_fp16(layer);
            break;
        default:
            break;
    }
}
