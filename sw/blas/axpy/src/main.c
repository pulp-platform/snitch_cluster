// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#define XSSR
#include "axpy.h"
#include "data.h"

int main() {
    double *local_x, *local_y, *local_z;
    double *remote_x, *remote_y, *remote_z;

    // Calculate size and pointers for each cluster
    uint32_t frac = n / snrt_cluster_num();
    uint32_t offset = frac * snrt_cluster_idx();
    remote_x = x + offset;
    remote_y = y + offset;
    remote_z = z + offset;

    // Allocate space in TCDM
    local_x = (double *)snrt_l1_next();
    local_y = local_x + frac;
    local_z = local_y + frac;

    // Copy data in TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac * sizeof(double);
        snrt_dma_start_1d(local_x, remote_x, size);
        snrt_dma_start_1d(local_y, remote_y, size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    // Compute
    if (!snrt_is_dm_core()) {
        uint32_t start_cycle = snrt_mcycle();
        axpy(frac, a, local_x, local_y, local_z);
        uint32_t end_cycle = snrt_mcycle();
    }

    snrt_cluster_hw_barrier();

    // Copy data out of TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac * sizeof(double);
        snrt_dma_start_1d(remote_z, local_z, size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

// TODO: currently only works for single cluster otherwise need to
//       synchronize all cores here
#ifdef BIST
    uint32_t nerr = n;

    // Check computation is correct
    if (snrt_global_core_idx() == 0) {
        for (int i = 0; i < n; i++) {
            if (local_z[i] == g[i]) nerr--;
            printf("%d %d\n", local_z[i], g[i]);
        }
    }

    return nerr;
#endif

    return 0;
}
