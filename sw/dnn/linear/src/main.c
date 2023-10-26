// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// TODO(colluca): add IPC test and remove this flag
#define BIST

#include "dnn.h"

#include "data.h"

int main() {
    linear_layer(&layer);

#ifdef BIST
    // TODO: fix this, wrong values for ofmap printed
    if (snrt_global_core_idx() == 0) {
        // compare result with ofmap
        uint32_t n_results = layer.CH * layer.CO;
        uint32_t n_errors = n_results;
        float tolerance = 1e-6;
        for (int i = 0; i < layer.CH; i++) {
            for (int j = 0; j < layer.CO; j++) {
                if (golden[i * layer.CO + j] - ofmap[i * layer.CO + j] >
                    tolerance) {
                    printf(
                        "MISMATCH: golden[%d][%d] = %f, ofmap[%d][%d] = %f\n",
                        i, j, golden[i * layer.CO + j], i, j,
                        ofmap[i * layer.CO + j]);
                } else {
                    n_errors--;
                }
            }
        }
        printf("[%d/%d] mismatches\n", n_errors, n_results);
        return n_errors;
    }
#endif
}