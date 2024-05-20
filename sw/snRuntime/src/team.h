// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * @file
 * @brief This file contains functions and macros related to Snitch team
 * management.
 *
 * The functions in this file provide information about the Snitch hardware
 * configuration, such as the number of clusters, cores per cluster, and the
 * current core's index within the system. These functions can be used for team
 * management and core-specific operations.
 */

#pragma once

/**
 * @brief Get the RISC-V hardware thread ID (hartid).
 *
 * @return The hardware thread ID.
 */
inline uint32_t __attribute__((const)) snrt_hartid() {
    uint32_t hartid;
    asm("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

/**
 * @brief Get the number of Snitch clusters in the system.
 *
 * @return The number of clusters.
 */
inline uint32_t __attribute__((const)) snrt_cluster_num() {
    return SNRT_CLUSTER_NUM;
}

/**
 * @brief Get the number of cores per cluster.
 *
 * @return The number of cores per cluster.
 */
inline uint32_t __attribute__((const)) snrt_cluster_core_num() {
    return SNRT_CLUSTER_CORE_NUM;
}

/**
 * @brief Get the hartid of the first Snitch core in the system.
 *
 * @return The hartid of the first Snitch core in the system.
 */
inline uint32_t __attribute__((const)) snrt_global_core_base_hartid() {
    return SNRT_BASE_HARTID;
}

/**
 * @brief Get the total number of Snitch cores in the system.
 *
 * @return The total number of cores.
 */
inline uint32_t __attribute__((const)) snrt_global_core_num() {
    return snrt_cluster_num() * snrt_cluster_core_num();
}

/**
 * @brief Get the total number of Snitch compute cores in the system.
 *
 * @return The total number of compute cores.
 */
inline uint32_t __attribute__((const)) snrt_global_compute_core_num() {
    return snrt_cluster_num() * snrt_cluster_compute_core_num();
}

/**
 * @brief Get the index (!= hartid) of the current Snitch core in the system.
 *
 * @return The index of the current Snitch core.
 */
inline uint32_t __attribute__((const)) snrt_global_core_idx() {
    return snrt_hartid() - snrt_global_core_base_hartid();
}

/**
 * @brief Get the index of the current Snitch compute core in the system.
 *
 * @return The index of the current Snitch compute core.
 */
inline uint32_t __attribute__((const)) snrt_global_compute_core_idx() {
    return snrt_cluster_idx() * snrt_cluster_compute_core_num() +
           snrt_cluster_core_idx();
}

/**
 * @brief Get the index of the current Snitch cluster in the system.
 *
 * @return The index of the current cluster.
 */
inline uint32_t __attribute__((const)) snrt_cluster_idx() {
    return snrt_global_core_idx() / snrt_cluster_core_num();
}

/**
 * @brief Get the index of the current Snitch core within the cluster.
 *
 * @return The index of the current core within the cluster.
 */
inline uint32_t __attribute__((const)) snrt_cluster_core_idx() {
    return snrt_global_core_idx() % snrt_cluster_core_num();
}

/**
 * @brief Get the number of data mover (DM) cores per cluster.
 *
 * @return The number of DM cores per cluster.
 */
inline uint32_t __attribute__((const)) snrt_cluster_dm_core_num() {
    return SNRT_CLUSTER_DM_CORE_NUM;
}

/**
 * @brief Get the number of compute cores per cluster.
 *
 * @return The number of compute cores per cluster.
 */
inline uint32_t __attribute__((const)) snrt_cluster_compute_core_num() {
    return snrt_cluster_core_num() - snrt_cluster_dm_core_num();
}

/**
 * @brief Check if the current core is a compute core.
 *
 * @return True if the current core is a compute core, false otherwise.
 */
inline int __attribute__((const)) snrt_is_compute_core() {
    return snrt_cluster_core_idx() < snrt_cluster_compute_core_num();
}

/**
 * @brief Check if the current core is the last compute core in the cluster.
 *
 * @return True if the current core is the last compute core, false otherwise.
 */
inline int __attribute__((const)) snrt_cluster_is_last_compute_core() {
    return snrt_cluster_core_idx() == (snrt_cluster_compute_core_num() - 1);
}

/**
 * @brief Check if the current core is a data mover (DM) core.
 *
 * @return True if the current core is a DM core, false otherwise.
 */
inline int __attribute__((const)) snrt_is_dm_core() {
    return !snrt_is_compute_core();
}
