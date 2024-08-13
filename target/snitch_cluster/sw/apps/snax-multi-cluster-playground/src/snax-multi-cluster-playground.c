// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Yunhao Deng <yunhao.deng@kuleuven.be>

#include <stdint.h>
#include "snrt.h"

int32_t main() {
    uint32_t hartid = snrt_hartid();
    uint32_t core_idx = snrt_cluster_core_idx();
    uint32_t current_mcycle = snrt_mcycle();
    while (current_mcycle + 50000 * hartid > snrt_mcycle()) {
    };
    printf("Core %d is wake up\n", hartid);
    printf("Hello from core %d in cluster %d\n", snrt_cluster_core_idx(),
           snrt_cluster_idx());
    printf("There are totally %d cores in this cluster\n",
           snrt_cluster_core_num());
    uint64_t base_addr = snrt_cluster_base_addr();
    printf("The LSB of base address of the cluster is 0x%x\n",
           (uint32_t)base_addr);
    printf("The MSB of base address of the cluster is 0x%x\n",
           (uint32_t)(base_addr >> 32));
    if (snrt_is_dm_core()) {
        printf("I am DM core\n");
    } else {
        printf("I am compute core\n");
    }
    return 0;
}
