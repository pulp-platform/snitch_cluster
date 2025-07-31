// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * @file
 * @brief Defines functions to dynamically allocate the cluster's L1 memory.
 *
 * This file provides functions to dynamically allocate the cluster's L1
 * memory. It includes functions for allocating memory for cluster-local
 * variables, compute core-local variables, and for manipulating pointers to
 * variables allocated by different cores or clusters.
 */

//================================================================================
// L1 allocation
//================================================================================

extern __thread snrt_allocator_t l1_allocator_v2;

/**
 * @brief Get a pointer to the L1 allocator.
 *
 * @return Pointer to the L1 allocator.
 */
inline snrt_allocator_t *snrt_l1_allocator_v2() { return &l1_allocator_v2; }

/**
 * @brief Get the next pointer of the L1 allocator.
 *
 * @return The next pointer of the L1 allocator.
 */
inline void *snrt_l1_next_v2() { return (void *)snrt_l1_allocator_v2()->next; }

/**
 * @brief Override the L1 allocator next pointer.
 *
 * @param next The new value for the next pointer.
 */
inline void snrt_l1_update_next_v2(void *next) {
    snrt_l1_allocator_v2()->next = (uint32_t)next;
}

/**
 * @brief Check if the allocation exceeds the allocator bounds and raise an
 *        exception if it does.
 */
static inline void snrt_l1_alloc_check_bounds() {
    if (snrt_l1_allocator_v2()->next > snrt_l1_allocator_v2()->end)
        asm volatile("ecall \n");
}

/**
 * @brief Allocate space for a variable in the cluster's L1 memory.
 *
 * This function dynamically allocates space for a variable of size \p size in
 * the cluster's L1 memory.
 * The allocation is aligned to the specified \p alignment.
 *
 * @param size The size of the variable to allocate.
 * @param alignment The alignment of the allocation. An alignment of 1 (byte)
 *        is equivalent to no alignment (in a byte-addressable system).
 * @return Pointer to the allocated variable.
 */
inline void *snrt_l1_alloc_cluster_local(size_t size,
                                         const size_t alignment = 1) {
    snrt_l1_allocator_v2()->next =
        snrt_align_up(snrt_l1_allocator_v2()->next, alignment);
    void *retval = snrt_l1_next_v2();
    snrt_l1_allocator_v2()->next += size;
    snrt_l1_alloc_check_bounds();
    return retval;
}

/**
 * @brief Allocate space for N variables in the cluster's L1 memory.
 *
 * This function dynamically allocates space for N variables of size \p size in
 * the cluster's L1 memory, where N is the number of compute cores in the
 * cluster. The variables are allocated in a contiguous block of memory.
 * The whole block is aligned to the specified \p alignment.
 *
 * @param size The size of each variable to allocate.
 * @param alignment The alignment of the allocation.
 * @return Pointer to the allocated variable for each compute core.
 *         The return value for the DM core is undefined.
 */
inline void *snrt_l1_alloc_compute_core_local(size_t size,
                                              const size_t alignment = 1) {
    snrt_l1_allocator_v2()->next =
        snrt_align_up(snrt_l1_allocator_v2()->next, alignment);
    void *retval =
        ((uint8_t *)snrt_l1_next_v2()) + size * snrt_cluster_core_idx();
    snrt_l1_allocator_v2()->next += size * snrt_cluster_compute_core_num();
    snrt_l1_alloc_check_bounds();
    return retval;
}

/**
 * @brief Initialize the L1 allocator.
 *
 * This function initializes the L1 allocator by calculating the end address
 * of the heap and setting the base, end, and next pointers of the allocator.
 *
 * @note This function should be called before using any of the allocation
 *       functions.
 */
inline void snrt_l1_init() {
    // Calculate end address of the heap. The top of the TCDM address space is
    // reserved for the cluster-local storage (CLS) and the stack of every
    // core. We further provision a safety margin of 128B. The rest of the
    // TCDM is reserved for the heap.
    uint32_t heap_end_addr = snrt_cls_base_addr();
    heap_end_addr -= (1 << SNRT_LOG2_STACK_SIZE) * snrt_cluster_core_num();
    heap_end_addr -= 128;
    // Initialize L1 allocator
    uintptr_t l1_start_addr = (uintptr_t)(snrt_cluster()->tcdm.mem);
    snrt_l1_allocator_v2()->base = snrt_align_up(l1_start_addr, MIN_CHUNK_SIZE);
    snrt_l1_allocator_v2()->end = heap_end_addr;
    snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
}

//================================================================================
// L3 allocation
//================================================================================

extern __thread snrt_allocator_t l3_allocator_v2;

/**
 * @brief Get a pointer to the L3 allocator.
 *
 * @return Pointer to the L3 allocator.
 */
inline snrt_allocator_t *snrt_l3_allocator_v2() { return &l3_allocator_v2; }

/**
 * @brief Get the next pointer of the L3 allocator.
 *
 * @return The next pointer of the L3 allocator.
 */
inline void *snrt_l3_next_v2() { return (void *)snrt_l3_allocator_v2()->next; }

/**
 * @brief Check if the allocation exceeds the allocator bounds and raise an
 *        exception if it does.
 */
static inline void snrt_l3_alloc_check_bounds() {
    if (snrt_l3_allocator_v2()->next >= snrt_l3_allocator_v2()->end)
        asm volatile("ecall \n");
}

/**
 * @brief Allocate space for a variable in L3 memory.
 *
 * This function dynamically allocates space for a variable of size \p size in
 * L3 memory.
 * The allocation is aligned to the specified \p alignment.
 *
 * @param size The size of the variable to allocate.
 * @param alignment The alignment of the allocation. An alignment of 1 (byte)
 *        is equivalent to no alignment (in a byte-addressable system).
 * @return Pointer to the allocated variable.
 */
inline void *snrt_l3_alloc_v2(size_t size, const size_t alignment = 1) {
    snrt_l3_allocator_v2()->next =
        snrt_align_up(snrt_l3_allocator_v2()->next, alignment);
    void *retval = snrt_l3_next_v2();
    snrt_l3_allocator_v2()->next += size;
    snrt_l3_alloc_check_bounds();
    return retval;
}

/**
 * @brief Initialize the L3 allocator.
 *
 * This function initializes the L3 allocator, starting at the _edram symbol.
 * See linker script for definition of said symbol.
 *
 * @note This function should be called before using any of the allocation
 *       functions.
 */
inline void snrt_l3_init() {
    extern uint32_t _edram;
    snrt_l3_allocator_v2()->base =
        snrt_align_up((uint32_t)&_edram, MIN_CHUNK_SIZE);
    snrt_l3_allocator_v2()->end = SNRT_L3_END_ADDR;
    snrt_l3_allocator_v2()->next = snrt_l3_allocator_v2()->base;
}

//================================================================================
// Pointer translation functions
//================================================================================

/**
 * @brief Get a pointer to the same variable allocated by another core.
 *
 * This function takes a pointer to a variable allocated using
 * \ref snrt_l1_alloc_compute_core_local(size_t, const size_t) and returns a
 * pointer to the same variable allocated by another core, as specified by
 * \p core_idx. The \p size argument should be the same used during allocation.
 *
 * @param ptr Pointer to the variable allocated by the current core.
 * @param core_idx Index of the core that allocated the variable.
 * @param size The size of the variable.
 * @return Pointer to the same variable allocated by the specified core.
 */
inline void *snrt_compute_core_local_ptr(void *ptr, uint32_t core_idx,
                                         size_t size) {
    size_t offset = (core_idx - snrt_cluster_core_idx()) * size;
    return (void *)((uintptr_t)ptr + offset);
}

/**
 * @brief Get a pointer to the same offset in another cluster's L1 memory.
 *
 * This function takes a pointer to a variable in the calling (source)
 * cluster's L1 memory and returns a pointer to the same offset in the target
 * (destination) cluster's L1 memory.
 *
 * @param ptr Pointer to the variable in the source cluster's L1 memory.
 * @param src_cluster_idx Index of the source cluster.
 * @param dst_cluster_idx Index of the destination cluster.
 * @return Pointer to the same offset in the destination cluster's L1 memory.
 */
inline void *snrt_remote_l1_ptr(void *ptr, uint32_t src_cluster_idx,
                                uint32_t dst_cluster_idx) {
    return (void *)((uintptr_t)ptr +
                    (dst_cluster_idx - src_cluster_idx) * SNRT_CLUSTER_OFFSET);
}
