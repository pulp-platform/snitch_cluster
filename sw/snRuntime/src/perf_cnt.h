// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// #define SNRT_NUM_PERF_CNTS SNITCH_CLUSTER_PERIPHERAL_PARAM_NUM_PERF_COUNTERS

// /**
//  * @brief Union representing a 32-bit performance counter register, with 8-byte
//  * alignment.
//  */
// typedef union {
//     uint32_t value __attribute__((aligned(8)));
// } perf_reg32_t;

/**
 * @brief Structure representing the performance counters.
 *
 * This structure defines the memory layout of the performance counters
 * configuration register, as they are defined in
 * `snitch_cluster_peripheral.hjson`.
 */
typedef snitch_cluster_peripheral_regs__PERF_REGS_t perf_regs_t;

/**
 * @brief Get the pointer to the performance counter registers
 *
 * @return perf_regs_t* Pointer to the performance counter registers
 */
inline perf_regs_t* snrt_perf_counters() {
    return (perf_regs_t*)snrt_cluster_perf_counters_addr();
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
    snrt_perf_counters()->PERF_CNT_SEL[perf_cnt] = (metric << 16) | hart;
}

/**
 * @brief Starts a performance counter.
 *
 * @param perf_cnt The index of the performance counter to start.
 */
inline void snrt_start_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->PERF_CNT_EN[perf_cnt] = 0x1;
}

/**
 * @brief Stops a performance counter.
 *
 * @param perf_cnt The index of the performance counter to stop.
 */
inline void snrt_stop_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->PERF_CNT_EN[perf_cnt] = 0x0;
}

/**
 * @brief Reset the value of a performance counter.
 *
 * @param perf_cnt The index of the performance counter to reset.
 */
inline void snrt_reset_perf_counter(uint32_t perf_cnt) {
    snrt_perf_counters()->PERF_CNT[perf_cnt] = 0x0;
}

/**
 * @brief Retrieves the value of a performance counter.
 *
 * @param perf_cnt The index of the performance counter to retrieve the value
 * from.
 * @return The value of the specified performance counter.
 */
inline uint32_t snrt_get_perf_counter(uint32_t perf_cnt) {
    return snrt_perf_counters()->PERF_CNT[perf_cnt];
}
