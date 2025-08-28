// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "correlation.h"
#include "data.h"

#define MAX_ERROR 1e-10

int main() {
    uint32_t nerr = 0;

    correlation_args_t args = {N, M, (uint64_t)data, (uint64_t)corr};
    correlation_job(&args);

#ifdef BIST
    // Check computation is correct
    if (snrt_cluster_core_idx() == 0) {
        for (int i = 0; i < M; i++) {
            for (int j = 0; j < M; j++) {
                double diff = fabs(golden[i * M + j] - corr[i * M + j]);
                if (diff > MAX_ERROR) {
                    nerr++;
                }
            }
        }
    }
#endif

    return nerr;
}
