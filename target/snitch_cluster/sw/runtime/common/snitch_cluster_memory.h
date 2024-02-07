// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdint.h>

//===============================================================
// Constants
//===============================================================

#define CLUSTER_CLINT_SET_ADDR  \
    (CLUSTER_PERIPH_BASE_ADDR + \
     SNITCH_CLUSTER_PERIPHERAL_CL_CLINT_SET_REG_OFFSET)
#define CLUSTER_CLINT_CLR_ADDR  \
    (CLUSTER_PERIPH_BASE_ADDR + \
     SNITCH_CLUSTER_PERIPHERAL_CL_CLINT_CLEAR_REG_OFFSET)

#define CLUSTER_HW_BARRIER_ADDR \
    (CLUSTER_PERIPH_BASE_ADDR + SNITCH_CLUSTER_PERIPHERAL_HW_BARRIER_REG_OFFSET)

#define CLUSTER_PERF_COUNTER_ADDR \
    (CLUSTER_PERIPH_BASE_ADDR +   \
     SNITCH_CLUSTER_PERIPHERAL_PERF_COUNTER_ENABLE_0_REG_OFFSET)

#define CLUSTER_TCDM_START_ADDR CLUSTER_TCDM_BASE_ADDR

#define CLUSTER_TCDM_END_ADDR CLUSTER_PERIPH_BASE_ADDR

//===============================================================
// snRuntime interface functions
//===============================================================


inline uint32_t cluster_base_offset(uint32_t cluster_idx) {
    return cluster_idx * SNRT_CLUSTER_OFFSET;
}

inline uint32_t snrt_l1_start_addr(uint32_t cluster_idx) {
    return CLUSTER_TCDM_BASE_ADDR + cluster_base_offset(cluster_idx);
}

inline uint32_t snrt_l1_end_addr(uint32_t cluster_idx) {
    return CLUSTER_PERIPH_BASE_ADDR + cluster_base_offset(cluster_idx);
}

inline volatile uint32_t* snrt_cluster_clint_set_ptr(uint32_t cluster_idx) {
    return (uint32_t*)(CLUSTER_CLINT_SET_ADDR + cluster_base_offset(cluster_idx));
}

inline volatile uint32_t* snrt_cluster_clint_clr_ptr(uint32_t cluster_idx) {
    return (uint32_t*)(CLUSTER_CLINT_CLR_ADDR + cluster_base_offset(cluster_idx));
}

inline uint32_t snrt_cluster_hw_barrier_addr(uint32_t cluster_idx) {
    return CLUSTER_HW_BARRIER_ADDR + cluster_base_offset(cluster_idx);
}

inline uint32_t snrt_cluster_perf_counters_addr(uint32_t cluster_idx) {
    return CLUSTER_PERF_COUNTER_ADDR + cluster_base_offset(cluster_idx);
}

inline volatile uint32_t* snrt_zero_memory_ptr(uint32_t cluster_idx) {
    return (uint32_t*)(CLUSTER_ZERO_MEM_START_ADDR + cluster_base_offset(cluster_idx));
}
