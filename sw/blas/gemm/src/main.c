// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

#include <math.h>
#include <stdint.h>

#include "data.h"
#include "gemm.h"
#include "snrt.h"

int main() {
    int retcode =
        gemm(dtype_size, expand, 1, parallelize_m, parallelize_k, m_tiles,
             n_tiles, k_tiles, 1, 1, 1, TA, TB, M, N, K, 1, a, b, BETA, c);

    snrt_cluster_hw_barrier();

// TODO: currently only works for single cluster otherwise need to
//       synchronize all cores here
#ifdef BIST
    void *local_a, *local_b, *local_c;
    void *remote_a, *remote_b, *remote_c;

    // Allocate space in TCDM
    local_a = (void *)snrt_l1_next();
    local_b = local_a + size_frac_a;
    local_c = local_b + size_b;

    uint32_t errors = M * N;

    if (snrt_cluster_core_idx() == 0) {
        for (uint32_t m = 0; m < M; m++) {
            for (uint32_t n = 0; n < N; n++) {
                uint32_t idx = m * N + n;
                switch (dtype_size) {
                    case FP64:
                        if (fabs(result[idx] - ((double *)local_c)[idx]) <
                            fabs(result[idx] * 0.00001))
                            errors--;
                        break;
                    case FP32:
                        if (fabs(result[idx] - ((float *)local_c)[idx]) <
                            fabs(result[idx] * 0.0001))
                            errors--;
                        break;
                    case FP16:
                        if (fabs(result[idx] - ((__fp16 *)local_c)[idx]) <
                            fabs(result[idx] * 0.005))
                            errors--;
                    case FP8:
                        printf("No golden model yet for fp8!\n");
                        return -1;
                        break;
                }
            }
        }
        printf("%d/%d Errors\n", errors, M * N);
    }

    return errors;
#endif

    return retcode;
}
