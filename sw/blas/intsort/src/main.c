// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Nico Canzani <ncanzani@ethz.ch>
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

#include "data.h"
#include "intsort.h"

// Define Number of Buckets, use multiple of 8
#define N_BUCKETS 8

int main() {
    int32_t *local_x;
    int32_t *remote_x, *remote_z;

    // Calculate size and pointers for each cluster
    uint32_t frac = n / snrt_cluster_num();
    uint32_t offset = frac * snrt_cluster_idx();
    remote_x = x + offset;
    remote_z = z + offset;

    // Allocate space in TCDM
    local_x = (int32_t *)snrt_l1_next();

    // Copy data in TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac * sizeof(int32_t);
        snrt_dma_start_1d(local_x, remote_x, size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    // Compute
    bucketSort(local_x, n, N_BUCKETS, max, min);

    snrt_cluster_hw_barrier();

    // Copy data out of TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac * sizeof(int32_t);
        snrt_dma_start_1d(remote_z, local_x, size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    return 0;
}
