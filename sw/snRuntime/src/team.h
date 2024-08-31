// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

inline uint32_t __attribute__((const)) snrt_hartid() {
    uint32_t hartid;
    asm("csrr %0, mhartid" : "=r"(hartid));
    return hartid;
}

inline uint64_t __attribute__((const)) snrt_cluster_base_addr() {
    uint32_t base_address_l, base_address_h;
    asm("csrr %0, 0xbc1" : "=r"(base_address_l));
    asm("csrr %0, 0xbc2" : "=r"(base_address_h));
    return ((uint64_t)base_address_h << 32) | base_address_l;
}

inline uint32_t __attribute__((const)) snrt_cluster_base_addrl() {
    uint32_t base_address_l;
    asm("csrr %0, 0xbc1" : "=r"(base_address_l));
    return base_address_l;
}

inline uint32_t __attribute__((const)) snrt_cluster_base_addrh() {
    uint32_t base_address_h;
    asm("csrr %0, 0xbc2" : "=r"(base_address_h));
    return base_address_h;
}

// snrt_cluster_num() is depricated, may not return the correct value
inline uint32_t __attribute__((const)) snrt_cluster_num() {
    return SNRT_CLUSTER_NUM;
}

inline uint32_t __attribute__((const)) snrt_cluster_core_num() {
    // return SNRT_CLUSTER_CORE_NUM;
    uint32_t cluster_core_id;
    asm("csrr %0, 0xbc3" : "=r"(cluster_core_id));
    return cluster_core_id >> 16;
}

inline uint32_t __attribute__((const)) snrt_global_core_base_hartid() {
    return SNRT_BASE_HARTID;
}

// snrt_global_core_num() is depricated, may not return the correct value
inline uint32_t __attribute__((const)) snrt_global_core_num() {
    return snrt_cluster_num() * snrt_cluster_core_num();
}

inline uint32_t __attribute__((const)) snrt_global_core_idx() {
    return snrt_hartid() - snrt_global_core_base_hartid();
}

// snrt_global_compute_core_idx() is depricated, may not return the correct
// value
inline uint32_t __attribute__((const)) snrt_global_compute_core_idx() {
    return snrt_cluster_idx() * snrt_cluster_compute_core_num() +
           snrt_cluster_core_idx();
}

inline uint32_t __attribute__((const)) snrt_cluster_idx() {
    // return snrt_global_core_idx() / snrt_cluster_core_num();
    // occamy assign 16MB cluster memory
    // Hence we need the lower 22bit for cluster address
    // We add 2 bits for future use
    // Hence we mask the lower 24bits for cluster address
    return (snrt_cluster_base_addrl() & 0x00FFFFFF) >> CLUSTER_ADDRWIDTH;
}

inline uint32_t __attribute__((const)) snrt_cluster_core_idx() {
    // return snrt_global_core_idx() % snrt_cluster_core_num();
    uint32_t cluster_core_id;
    asm("csrr %0, 0xbc3" : "=r"(cluster_core_id));
    return cluster_core_id & 0xffff;
}

inline uint32_t __attribute__((const)) snrt_cluster_dm_core_num() {
    return SNRT_CLUSTER_DM_CORE_NUM;
}

inline uint32_t __attribute__((const)) snrt_cluster_compute_core_num() {
    return snrt_cluster_core_num() - snrt_cluster_dm_core_num();
}

inline int __attribute__((const)) snrt_is_compute_core() {
    return snrt_cluster_core_idx() < snrt_cluster_compute_core_num();
}

inline int __attribute__((const)) snrt_is_dm_core() {
    return !snrt_is_compute_core();
}
