// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
// #include "printf.h"
#include "snrt.h"
#include "utils.h"

/**
 * Implementation of the linear layer
 */

static inline void linear_fp32(float *input, int32_t ldI, float *weights,
                               int32_t ldW, float *bias, int32_t ldB,
                               float *output, int32_t ldO, int in_ch,
                               int out_ch, int ch) {
    uint32_t compute_id = snrt_cluster_compute_core_num();
    for (int c = 0; c < ch; c++) {
        for (int o = 0; o < out_ch; o++) {
            float sum = 0;
            for (int i = 0; i < in_ch; i++) {
                sum += input[c * in_ch + i] * weights[o * in_ch * ldB + i];
            }
            output[c * out_ch + o * ldB] = sum + bias[o * ldB];
            printf("output[%d][%d] = %f\n", c, compute_id + o * ldB,
                   output[c * out_ch + o * ldB]);
        }
    }

    snrt_cluster_hw_barrier();
}