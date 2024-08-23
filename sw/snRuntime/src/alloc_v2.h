// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

extern __thread snrt_allocator_t l1_allocator_v2;

inline snrt_allocator_t *snrt_l1_allocator_v2() { return &l1_allocator_v2; }

inline void *snrt_l1_next_v2() { return (void *)snrt_l1_allocator_v2()->next; }

/**
 * @brief Override the L1 allocator next pointer
 */
inline void snrt_l1_update_next_v2(void *next) {
    snrt_l1_allocator_v2()->next = (uint32_t)next;
}

// Check that allocation doesn't exceed allocator bounds, and raise an
// exception otherwise
inline void snrt_l1_alloc_check_bounds() {
    if (snrt_l1_allocator_v2()->next > snrt_l1_allocator_v2()->end)
        asm volatile("ecall \n");
}

// Dynamically allocate space for a variable of size `size` in the cluster's L1
// memory. This function should be invoked by every core in a cluster. Every
// core receives a pointer to the allocated variable.
inline void *snrt_l1_alloc_cluster_local(size_t size, const size_t alignment) {
    snrt_l1_allocator_v2()->next =
        ALIGN_UP(snrt_l1_allocator_v2()->next, alignment);
    void *retval = snrt_l1_next_v2();
    snrt_l1_allocator_v2()->next += size;
    snrt_l1_alloc_check_bounds();
    return retval;
}

// Dynamically allocate space for N variables of size `size` in the cluster's
// L1 memory, N being the number of compute cores in the cluster. This function
// should be invoked by every core in a cluster. Every compute core receives a
// pointer to a unique variable among the N which have been allocated. The
// return value for the DM core is undefined.
inline void *snrt_l1_alloc_compute_core_local(size_t size,
                                              const size_t alignment) {
    snrt_l1_allocator_v2()->next =
        ALIGN_UP(snrt_l1_allocator_v2()->next, alignment);
    void *retval = snrt_l1_next_v2() + size * snrt_cluster_core_idx();
    snrt_l1_allocator_v2()->next += size * snrt_cluster_compute_core_num();
    snrt_l1_alloc_check_bounds();
    return retval;
}

// Takes a pointer to a variable allocated using
// `snrt_l1_alloc_compute_core_local` and returns a pointer to the same
// variable allocated by another core, as specified by `core_idx`.
// The `size` argument should be the same used during allocation.
inline void *snrt_compute_core_local_ptr(void *ptr, uint32_t core_idx,
                                         size_t size) {
    size_t offset = (core_idx - snrt_cluster_core_idx()) * size;
    return (void *)((uintptr_t)ptr + offset);
}

// Takes a pointer to a variable in the source cluster's L1 memory and returns
// a pointer to the same offset in the destination cluster's L1 memory.
inline void *snrt_remote_l1_ptr(void *ptr, uint32_t src_cluster_idx,
                                uint32_t dst_cluster_idx) {
    return (void *)((uintptr_t)ptr +
                    (dst_cluster_idx - src_cluster_idx) * SNRT_CLUSTER_OFFSET);
}

inline void snrt_alloc_init_v2() {
    // Calculate end address of the heap. The top of the TCDM address space is
    // reserved for the cluster-local storage (CLS) and the stack of every
    // core. We further provision a safety margin of 128B. The rest of the
    // TCDM is reserved for the heap.
    uint32_t heap_end_addr = snrt_cls_base_addr();
    heap_end_addr -= (1 << SNRT_LOG2_STACK_SIZE) * snrt_cluster_core_num();
    heap_end_addr -= 128;
    // Initialize L1 allocator
    snrt_l1_allocator_v2()->base =
        ALIGN_UP(snrt_l1_start_addr(), MIN_CHUNK_SIZE);
    snrt_l1_allocator_v2()->end = heap_end_addr;
    snrt_l1_allocator_v2()->next = snrt_l1_allocator_v2()->base;
}
