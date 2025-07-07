// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#define SNRT_NUM_PERF_CNTS \
    (sizeof(((perf_regs_t){}).perf_cnt) / sizeof(((perf_regs_t){}).perf_cnt[0]))

/**
 * @brief Structure representing the performance counters.
 *
 * This structure defines the memory layout of the performance counters
 * configuration register, as they are defined in
 * `snitch_cluster_peripheral_reg.rdl`.
 */
typedef snitch_cluster_peripheral_reg__perf_regs_t perf_regs_t;

/**
 * @brief Get the pointer to the performance counter registers
 *
 * @return perf_regs_t* Pointer to the performance counter registers
 */
inline volatile perf_regs_t* snrt_perf_counters() {
    return &(snrt_cluster()->peripheral_reg.perf_regs);
}

/**
 * @brief Configures the performance counter for a specific metric and hart.
 *
 * @param perf_cnt The index of the performance counter to configure.
 * @param metric The metric value to set for the performance counter.
 * @param hart The hart value to set for the performance counter.
 */
inline void snrt_cfg_perf_counter(uint32_t perf_cnt, uint16_t metric,
                                  uint16_t hart) {
    snrt_perf_counters()->perf_cnt_sel[perf_cnt].f.hart = hart;
    snrt_perf_counters()->perf_cnt_sel[perf_cnt].f.metric = metric;
}

/**
 * @brief Starts a performance counter.
 *
 * @param perf_cnt The index of the performance counter to start.
 */
inline void snrt_start_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->perf_cnt_en[perf_cnt].f.enable = 0x1;
}

/**
 * @brief Stops a performance counter.
 *
 * @param perf_cnt The index of the performance counter to stop.
 */
inline void snrt_stop_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->perf_cnt_en[perf_cnt].f.enable = 0x0;
}

/**
 * @brief Reset the value of a performance counter.
 *
 * @param perf_cnt The index of the performance counter to reset.
 */
inline void snrt_reset_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->perf_cnt[perf_cnt].f.perf_counter = 0x0;
}

/**
 * @brief Retrieves the value of a performance counter.
 *
 * @param perf_cnt The index of the performance counter to retrieve the value
 * from.
 * @return The value of the specified performance counter.
 */
inline uint32_t snrt_get_perf_counter(uint32_t perf_cnt) {
    return snrt_perf_counters()->perf_cnt[perf_cnt].f.perf_counter;
}
