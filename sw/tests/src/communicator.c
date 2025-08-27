// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

int main() {
    // Communicator will include the first two clusters if any, otherwise a
    // single cluster.
    uint32_t size = 2;
    if (snrt_cluster_num() < size) size = snrt_cluster_num();

    // Create the communicator.
    snrt_comm_t comm;
    snrt_comm_create(size, &comm);

    // Synchronize the clusters in the communicator.
    snrt_global_barrier(comm);

    // All clusters will synchronize on a global barrier in the exit routine.
    // The test terminates only if the global barrier and the communicator
    // barrier did not interfere, as desired.
    return 0;
}
