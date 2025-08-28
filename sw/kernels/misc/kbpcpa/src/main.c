// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Jayanth Jonnalagadda <jjonnalagadd@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

#include "data.h"
#include "kbpcpa.h"

int main() {
    double *local_a, *local_b, *local_c;
    double *remote_a, *remote_b, *remote_c;

    remote_b = b;
    remote_c = c;
    remote_a = a;

    // Allocate space in TCDM
    local_b = (double *)snrt_l1_next();
    local_c = local_b + L;
    local_a = local_c + L;

    // Copy data in TCDM
    if (snrt_is_dm_core()) {
        size_t size = L * sizeof(double);
        snrt_dma_start_1d(local_b, remote_b, size);
        snrt_dma_start_1d(local_c, remote_c, size);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    // Compute
    if (snrt_cluster_core_idx() == 0) {
        kbpcpa(L, k, local_a, local_b, local_c);
    }
    snrt_cluster_hw_barrier();

    // Copy data out of TCDM
    if (snrt_is_dm_core()) {
        size_t size = L * sizeof(double);
        snrt_dma_start_1d(remote_a, local_a, size);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    return 0;
}