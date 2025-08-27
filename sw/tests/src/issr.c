// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

#define LEN 2048

int main() {
    // Only core 0 performs the test
    if (snrt_cluster_core_idx() > 0) return 0;

    // Allocate data, index and result arrays
    double *data = (double *)snrt_l1_alloc_cluster_local(LEN * sizeof(double),
                                                         sizeof(double));
    double *result = (double *)snrt_l1_alloc_cluster_local(LEN * sizeof(double),
                                                           sizeof(double));
    uint16_t *idcs = (uint16_t *)snrt_l1_alloc_cluster_local(
        LEN * sizeof(uint16_t), sizeof(uint16_t));

    // Initialize data and indirection indices arrays
    for (int i = 0; i < LEN; i++) {
        data[i] = (double)i;
        idcs[i] = (i * 7) % LEN;
    }

    // Configure ISSR
    snrt_issr_read(SNRT_SSR_DM0, data, idcs, LEN, SNRT_SSR_IDXSIZE_U16);

    // Configure SSR for writeback
    snrt_ssr_loop_1d(SNRT_SSR_DM2, LEN, sizeof(double));
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, result);

    // Read values using ISSR
    snrt_ssr_enable();
    asm volatile(
        "frep.o %[n_frep], 1, 0, 0 \n"
        "fmv.d   ft2, ft0 \n"
        :
        : [ n_frep ] "r"(LEN - 1)
        : "memory", "ft0", "ft1", "ft2");
    snrt_ssr_disable();
    snrt_fpu_fence();

    // Check results
    int n_err = LEN;
    for (int i = 0; i < LEN; i++)
        if (result[i] == data[idcs[i]]) n_err--;

    return n_err;
}
