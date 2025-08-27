// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stddef.h>
#include <stdint.h>

// Must return a pointer to the snitch_cluster_t struct
// of the cluster alias.
inline volatile snitch_cluster_t* snrt_cluster_alias() {
    return &(snitch_cluster_addrmap.cluster_alias);
}

// Must return a pointer to the snitch_cluster_t struct
// of the cluster selected by cluster_idx.
inline volatile snitch_cluster_t* snrt_cluster(int cluster_idx) {
    return &(snitch_cluster_addrmap.cluster) + cluster_idx;
}

// Must return a pointer to the snitch_cluster_t struct
// of the cluster invoking the function.
inline volatile snitch_cluster_t* snrt_cluster() {
    return &(snitch_cluster_addrmap.cluster) + snrt_cluster_idx();
}
