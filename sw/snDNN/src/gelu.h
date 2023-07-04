// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
// #include "printf.h"
#include "snrt.h"
#include "utils.h"

/**
 * Implementation of the GELU layer
 */

static inline void gelu_fp32(float *input, float *output, int32_t ldI,
                             uint32_t batch_size, uint32_t seq_len,
                             uint32_t hidden_nodes) {
    // uint32_t compute_id = snrt_cluster_compute_core_num();

    for (int s = 0; s < seq_len; s++) {
        for (int h = 0; h < hidden_nodes; h++) {
            // if (compute_id == 1) {
            //     printf("compute id: %d, input[%d][%d] = %f\n", compute_id, s,
            //     h,
            //         input[s * hidden_nodes + h]);
            // }
            float x = input[s * hidden_nodes + h];
            float y =
                0.5 * x *
                (1.0 + tanh(sqrt(2.0 / M_PI) * (x + 0.044715 * x * x * x)));
            output[s * hidden_nodes + h] = y;

            // if (compute_id == 1) {
            //     printf("compute id: %d, output[%d][%d] = %f\n", compute_id,
            //     s, h,
            //         output[s * hidden_nodes + h]);
            // }
        }
    }
}