// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Lucia Luzi <luzil@student.ethz.ch>

#include "transpose_shuffle.h"


int main() {
    // Read the mcycle CSR (this is our way to mark/delimit a specific code region for benchmarking)
    uint32_t start_cycle = snrt_mcycle();

    transpose_shuffle(input, output, M, N, dtype, baseline, opt_ssr);

    // Read the mcycle CSR
    uint32_t end_cycle = snrt_mcycle();

    snrt_cluster_hw_barrier();

    return 0;
}