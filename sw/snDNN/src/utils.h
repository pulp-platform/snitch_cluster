// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "layer.h"
#include "snrt.h"

typedef float v2f32 __attribute__((vector_size(8)));
typedef __fp16 v4f16 __attribute__((vector_size(8)));
typedef char v8f8 __attribute__((vector_size(8)));

typedef union {
    double f64;
    v2f32 vec;
} v2s;
typedef union {
    double f64;
    v4f16 vec;
} v4s;
typedef union {
    double f64;
    v8f8 vec;
} v8s;

#define M_PI 3.14159265358979323846
#define INFINITY 0x7f800000

/**
 * @brief returns cycle number and injects marker
 * to track performance
 *
 * @return uint32_t
 */
inline uint32_t benchmark_get_cycle();

/**
 * @brief start tracking of dma performance region. Does not have any
 * implications on the HW. Only injects a marker in the DMA traces that can be
 * analyzed
 *
 */
inline void snrt_dma_start_tracking();

/**
 * @brief stop tracking of dma performance region. Does not have any
 * implications on the HW. Only injects a marker in the DMA traces that can be
 * analyzed
 *
 */
inline void snrt_dma_stop_tracking();

/**
 * @brief checks correctness of feature map
 *
 * @param l layer struct (Conv2d, BatchNorm, Maxpool)
 * @param checksum checksum to compare against, reduced over input channels
 * @return uint32_t
 */
inline uint32_t check_layer(const conv_layer* l, double* checksum);

/**
 * @brief fast memset function performed by DMA
 *
 * @param ptr pointer to the start of the region
 * @param value value to set
 * @param len number of bytes, must be multiple of DMA bus-width
 */
inline void dma_memset(void* ptr, uint8_t value, uint32_t len);
