// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

//================================================================================
// Alignment
//================================================================================

#define MIN_CHUNK_SIZE 8

/**
 * @brief Align to next multiple of size from a given base.
 * @details This macro aligns the address to the next alignment boundary
 *          specified by \p size and \p base. Alignment boundaries are defined
 *          by summing integer multiples of \p size to the base address.
 * @param addr Address to be aligned
 * @param size Alignment size in bytes
 * @param base Base address for the alignment boundaries
 * @return pointer to the allocated memory
 */
inline uintptr_t snrt_align_up(uintptr_t addr, size_t size,
                               uintptr_t base = 0) {
    return (((addr - base) + size - 1) / size) * size + base;
}

inline void *snrt_align_up(void *addr, size_t size, void *base = 0) {
    return (void *)snrt_align_up((uintptr_t)addr, size, (uintptr_t)base);
}

inline uintptr_t snrt_align_up_hyperbank(uintptr_t addr) {
    return snrt_align_up(addr, SNRT_TCDM_HYPERBANK_WIDTH, SNRT_TCDM_START_ADDR);
}

inline void *snrt_align_up_hyperbank(void *addr) {
    return (void *)snrt_align_up_hyperbank((uintptr_t)addr);
}

//================================================================================
// Allocation
//================================================================================

extern snrt_allocator_t l3_allocator;

inline snrt_allocator_t *snrt_l1_allocator() {
    return (snrt_allocator_t *)&(cls()->l1_allocator);
}

inline snrt_allocator_t *snrt_l3_allocator() { return &l3_allocator; }

inline void *snrt_l1_next() { return (void *)snrt_l1_allocator()->next; }

inline void *snrt_l3_next() { return (void *)snrt_l3_allocator()->next; }

/**
 * @brief Allocate a chunk of memory in the L1 memory
 * @details This currently does not support free-ing of memory
 *
 * @param size number of bytes to allocate
 * @return pointer to the allocated memory
 */
inline void *snrt_l1_alloc(size_t size) {
    snrt_allocator_t *alloc = snrt_l1_allocator();

    // TODO colluca: do we need this? What does it imply?
    //               one more instruction, TCDM consumption...
    size = snrt_align_up(size, MIN_CHUNK_SIZE);

    // TODO colluca
    // if (alloc->next + size > alloc->base + alloc->size) {
    //     snrt_trace(
    //         SNRT_TRACE_ALLOC,
    //         "Not enough memory to allocate: base %#x size %#x next %#x\n",
    //         alloc->base, alloc->size, alloc->next);
    //     return 0;
    // }

    void *ret = (void *)alloc->next;
    alloc->next += size;
    return ret;
}

/**
 * @brief Override the L1 allocator next pointer
 */
inline void snrt_l1_update_next(void *next) {
    snrt_allocator_t *alloc = snrt_l1_allocator();
    alloc->next = (uint32_t)next;
}

/**
 * @brief Allocate a chunk of memory in the L3 memory
 * @details This currently does not support free-ing of memory
 *
 * @param size number of bytes to allocate
 * @return pointer to the allocated memory
 */
inline void *snrt_l3_alloc(size_t size) {
    snrt_allocator_t *alloc = snrt_l3_allocator();

    size = snrt_align_up(size, MIN_CHUNK_SIZE);

    // TODO: L3 alloc size check

    void *ret = (void *)alloc->next;
    alloc->next += size;
    return ret;
}

inline void snrt_alloc_init() {
    // Only one core per cluster has to initialize the L1 allocator
    if (snrt_is_dm_core()) {
        // Initialize L1 allocator
        // Note: at the moment the allocator assumes all of the TCDM is
        // available for allocation. However, the CLS, TLS and stack already
        // occupy a possibly significant portion.
        uintptr_t l1_start_addr = (uintptr_t)(snrt_cluster()->tcdm.mem);
        snrt_l1_allocator()->base =
            snrt_align_up(l1_start_addr, MIN_CHUNK_SIZE);
        snrt_l1_allocator()->end = l1_start_addr + SNRT_TCDM_SIZE;
        snrt_l1_allocator()->next = snrt_l1_allocator()->base;
        // Initialize L3 allocator
        extern uint32_t _edram;
        snrt_l3_allocator()->base =
            snrt_align_up((uint32_t)&_edram, MIN_CHUNK_SIZE);
        snrt_l3_allocator()->end = snrt_l3_allocator()->base;
        snrt_l3_allocator()->next = snrt_l3_allocator()->base;
    }
    // Synchronize with other cores
    snrt_cluster_hw_barrier();
}
