// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "atax.h"
#include "data.h"

#define MAX_ERROR 1e-10

int main() {
    uint32_t nerr = 0;

    atax_args_t args = {M, N, (uint64_t)A, (uint64_t)x, (uint64_t)y};
    atax_job(&args);

// Check computation is correct
#ifdef BIST
    if (snrt_cluster_core_idx() == 0) {
        // Check y
        for (int i = 0; i < N; i++) {
            double diff = fabs(golden[i] - y[i]);
            if (diff > MAX_ERROR) {
                nerr++;
            }
        }
    }
#endif

    return nerr;
}
