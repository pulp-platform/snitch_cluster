// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stddef.h>
#include <stdint.h>
#include "snitch_cluster_peripheral.h"

//===============================================================
// Constants
//===============================================================

#define CLUSTER_CLINT_SET_ADDR  \
    (CLUSTER_PERIPH_BASE_ADDR + \
     offsetof(snitch_cluster_peripheral_reg_t, cl_clint_set))
#define CLUSTER_CLINT_CLR_ADDR  \
    (CLUSTER_PERIPH_BASE_ADDR + \
     offsetof(snitch_cluster_peripheral_reg_t, cl_clint_clear))

#define CLUSTER_PERF_COUNTER_ADDR                           \
    (CLUSTER_PERIPH_BASE_ADDR +                             \
     offsetof(snitch_cluster_peripheral_reg_t, perf_regs) + \
     offsetof(snitch_cluster_peripheral_reg__perf_regs_t, perf_cnt_en[0]))

//===============================================================
// snRuntime interface functions
//===============================================================

inline uint32_t cluster_base_offset() {
    return snrt_cluster_idx() * SNRT_CLUSTER_OFFSET;
}

inline uint32_t snrt_l1_start_addr() {
    return SNRT_TCDM_START_ADDR + cluster_base_offset();
}

inline uint32_t snrt_l1_end_addr() {
    return SNRT_TCDM_START_ADDR + SNRT_TCDM_SIZE + cluster_base_offset();
}

inline volatile uint32_t* snrt_cluster_clint_set_ptr() {
    return (uint32_t*)(CLUSTER_CLINT_SET_ADDR + cluster_base_offset());
}

inline volatile uint32_t* snrt_cluster_clint_clr_ptr() {
    return (uint32_t*)(CLUSTER_CLINT_CLR_ADDR + cluster_base_offset());
}

inline uint32_t snrt_cluster_perf_counters_addr() {
    return CLUSTER_PERF_COUNTER_ADDR + cluster_base_offset();
}

inline volatile void* snrt_zero_memory_ptr() {
    return (void*)(CLUSTER_ZERO_MEM_START_ADDR + cluster_base_offset());
}
