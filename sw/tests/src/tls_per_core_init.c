// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// This test assesses that snrt_init_tls() correctly initializes a separate TLS
// block for every core in the cluster via the DM core's DMA loop.

#include <snrt.h>

__thread int tdata_a = 0xAA;
__thread int tdata_b = 0xBB;
__thread int tbss_x = 0;

int main() {
    int errors = 0;
    int my_idx = (int)snrt_cluster_core_idx();

    // Initial-value check.
    errors += (tdata_a != 0xAA);
    errors += (tdata_b != 0xBB);
    errors += (tbss_x != 0);

    // Per-core isolation: write a core-unique value, sync, read back.
    tdata_a = 0x1000 + my_idx;
    tdata_b = 0x2000 + my_idx;

    snrt_cluster_hw_barrier();

    errors += (tdata_a != 0x1000 + my_idx);
    errors += (tdata_b != 0x2000 + my_idx);

    snrt_cluster_hw_barrier();

    return errors;
}
