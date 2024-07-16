// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#define SNRT_NUM_PERF_CNTS SNITCH_CLUSTER_PERIPHERAL_PARAM_NUM_PERF_COUNTERS

typedef struct {
    uint16_t hart;
    uint16_t metric;
} perf_cnt_cfg_t;

typedef union {
    uint32_t value __attribute__((aligned(8)));
    perf_cnt_cfg_t cfg __attribute__((aligned(8)));
} perf_reg32_t;

typedef struct {
    volatile perf_reg32_t enable[SNRT_NUM_PERF_CNTS];
    volatile perf_reg32_t select[SNRT_NUM_PERF_CNTS];
    volatile perf_reg32_t perf_counter[SNRT_NUM_PERF_CNTS];
} perf_regs_t;

// Return the pointer to the perf_counters
inline perf_regs_t* snrt_perf_counters() {
    return (perf_regs_t*)snrt_cluster_perf_counters_addr();
}

// Configure a specific perf_counter
inline void snrt_cfg_perf_counter(uint32_t perf_cnt, uint16_t metric,
                                  uint16_t hart) {
    // Make sure the configuration is written in a single write
    perf_reg32_t cfg_reg;
    cfg_reg.cfg = (perf_cnt_cfg_t){.metric = metric, .hart = hart};
    snrt_perf_counters()->select[perf_cnt].value = cfg_reg.value;
}

// Enable a specific perf_counter
inline void snrt_start_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->enable[perf_cnt].value = 0x1;
}

// Stops the counter but does not reset it
inline void snrt_stop_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->enable[perf_cnt].value = 0x0;
}

// Resets the counter completely
inline void snrt_reset_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->perf_counter[perf_cnt].value = 0x0;
}

// Get counter of specified perf_counter
inline uint32_t snrt_get_perf_counter(uint32_t perf_cnt) {
    return snrt_perf_counters()->perf_counter[perf_cnt].value;
}
