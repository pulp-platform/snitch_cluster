// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"
// #include "printf.h"
#include "utils.h"

/**
 * Implementation of the SoftMax layer.
 */

static inline void softmax_fp32(float *input, float *output, int32_t ldI,
                                int32_t batch_offset, int32_t batch_size,
                                int32_t seq_len, int32_t input_samples) {
    float max_core = 0.0;  // max value of the current core
    float sum = 0.0;       // sum of the exp values of the current core

    // uint32_t compute_id = snrt_global_core_idx();
    // uint32_t num_cores = snrt_cluster_compute_core_num();

    for (int32_t b = 0; b < batch_size; b++) {
        for (int32_t s = 0; s < seq_len; s++) {
            max_core = -INFINITY;
            sum = 0.0;

            for (int32_t i = 0; i < input_samples; i++) {
                if (input[b * batch_offset + s * ldI + i] > max_core) {
                    max_core = input[b * batch_offset + s * ldI + i];
                }
            }

            // compute the shifted value of the current row
            for (int32_t i = 0; i < input_samples; i++) {
                output[b * batch_offset + s * ldI + i] =
                    // FIXME: Below code is erroring due to the standard math
                    // lib conflict
                    // TODO: Try out with musl lib
                    // expf(input[b * batch_offset + s * ldI + i] - max_core);
                    // FIXME: actually there should be an exponentiation
                    input[b * batch_offset + s * ldI + i] - max_core;
                sum += output[b * batch_offset + s * ldI + i];
            }

            // compute the softmax value of the current row
            for (int32_t i = 0; i < input_samples; i++) {
                // INFO: DIVSQRT unit MUST be activated in the cluster
                // configuration
                output[b * batch_offset + s * ldI + i] /= sum;
                // printf("output[%d] = %f\n", compute_id * input_samples + b *
                // batch_offset + s * ldI + i,
                //        output[b * batch_offset + s * ldI + i]);
            }
        }
    }

    snrt_cluster_hw_barrier();
}