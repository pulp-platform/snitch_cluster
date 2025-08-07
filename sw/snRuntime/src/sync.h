// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>
// Viviane Potocnik <vivianep@iis.ee.ethz.ch>

/**
 * @file
 * @brief This file provides functions to synchronize Snitch cores.
 */

#pragma once

#include "../../deps/riscv-opcodes/encoding.h"

#include <math.h>

#define SNRT_BROADCAST_MASK ((SNRT_CLUSTER_NUM - 1) * SNRT_CLUSTER_OFFSET)

//================================================================================
// Communicator functions
//================================================================================

extern __thread snrt_comm_info_t snrt_comm_world_info;
extern __thread snrt_comm_t snrt_comm_world;

/**
 * @brief Initialize the communicator functions.
 *
 * This function initializes the L1 allocator by calculating the end address
 * of the heap and setting the base, end, and next pointers of the allocator.
 *
 * @note This function should be called before using any of the allocation
 *       functions.
 */
inline void snrt_comm_init() { snrt_comm_world = &snrt_comm_world_info; }

/**
 * @brief Creates a communicator object.
 *
 * The newly created communicator object includes the first \p size clusters.
 * All clusters, even those which are not part of the communicator, must invoke
 * this function.
 *
 * @param size The number of clusters to include in the communicator.
 * @param communicator Pointer to the communicator object to be created.
 */
inline void snrt_comm_create(uint32_t size, snrt_comm_t *communicator) {
    // Allocate communicator struct in L1 and point to it.
    *communicator =
        (snrt_comm_t)snrt_l1_alloc_cluster_local(sizeof(snrt_comm_info_t));

    // Allocate barrier counter in L3 and initialize to 0. Every core invokes
    // the allocation function to update its allocator, but only one core
    // initializes it. A global barrier is then used to ensure all cores "see"
    // the initialized value.
    uint32_t *barrier_ptr = (uint32_t *)snrt_l3_alloc_v2(sizeof(uint32_t));
    if (snrt_global_core_idx() == 0) *barrier_ptr = 0;
    snrt_global_barrier();

    // Initialize communicator, pointing to the newly-allocated barrier
    // counter in L3.
    (*communicator)->size = size;
    (*communicator)->barrier_ptr = barrier_ptr;
    (*communicator)->is_participant = snrt_cluster_idx() < size;
}

//================================================================================
// Mutex functions
//================================================================================

/**
 * @brief Get a pointer to a mutex variable.
 */
inline volatile uint32_t *snrt_mutex() { return &_snrt_mutex; }

/**
 * @brief Acquire a mutex, blocking.
 * @details Test-and-set (TAS) implementation of a lock.
 * @param pmtx A pointer to a variable which can be used as a mutex, i.e. to
 *             which all cores have a reference and at a memory location to
 *             which atomic accesses can be made. This can be declared e.g. as
 *             `static volatile uint32_t mtx = 0;`.
 */
inline void snrt_mutex_acquire(volatile uint32_t *pmtx) {
    asm volatile(
        "li            t0,1          # t0 = 1\n"
        "1:\n"
        "  amoswap.w.aq  t0,t0,(%0)   # t0 = oldlock & lock = 1\n"
        "  bnez          t0,1b      # Retry if previously set)\n"
        : "+r"(pmtx)
        :
        : "t0");
}

/**
 * @brief Acquire a mutex, blocking.
 * @details Same as @ref snrt_mutex_acquire but acquires the lock using a test
 *          and test-and-set (TTAS) strategy.
 */
inline void snrt_mutex_ttas_acquire(volatile uint32_t *pmtx) {
    asm volatile(
        "1:\n"
        "  lw t0, 0(%0)\n"
        "  bnez t0, 1b\n"
        "  li t0,1          # t0 = 1\n"
        "2:\n"
        "  amoswap.w.aq  t0,t0,(%0)   # t0 = oldlock & lock = 1\n"
        "  bnez          t0,2b      # Retry if previously set)\n"
        : "+r"(pmtx)
        :
        : "t0");
}

/**
 * @brief Release a previously-acquired mutex.
 */
inline void snrt_mutex_release(volatile uint32_t *pmtx) {
    asm volatile("amoswap.w.rl  x0,x0,(%0)   # Release lock by storing 0\n"
                 : "+r"(pmtx));
}

//================================================================================
// Barrier functions
//================================================================================

/**
 * @brief Wake the clusters belonging to a given communicator.
 * @param comm The communicator determining which clusters to wake up.
 */
inline void snrt_wake_clusters(uint32_t core_mask, snrt_comm_t comm = NULL) {
    // If no communicator is given, world communicator is used as default.
    if (comm == NULL) comm = snrt_comm_world;

#ifdef SNRT_SUPPORTS_MULTICAST
    // Multicast cluster interrupt to every other cluster's core
    // Note: we need to address another cluster's address space
    //       because the cluster XBAR has not been extended to support
    //       multicast yet. We address the second cluster, if we are the
    //       first cluster, and the first cluster otherwise.
    if (snrt_cluster_num() > 0) {
        volatile snitch_cluster_t *cluster;
        if (snrt_cluster_idx() == 0)
            cluster = snrt_cluster(1);
        else
            cluster = snrt_cluster(0);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Waddress-of-packed-member"
        uint32_t *addr = (uint32_t *)&(cluster->peripheral_reg.cl_clint_set.w);
#pragma clang diagnostic pop
        uint32_t mcast_mask = ((comm->size) - 1) * SNRT_CLUSTER_OFFSET;
        snrt_enable_multicast(mcast_mask);
        *addr = core_mask;
        snrt_disable_multicast();
    }
#else
    // Wake clusters sequentially
    for (int i = 0; i < comm->size; i++) {
        if (snrt_cluster_idx() != i) {
            snrt_cluster(i)->peripheral_reg.cl_clint_set.f.cl_clint_set =
                core_mask;
        }
    }
#endif
}

/**
 * @brief Synchronize cores in a cluster with a hardware barrier, blocking.
 * @note Synchronizes all (both DM and compute) cores. All cores must invoke
 *       this function, or the calling cores will stall indefinitely.
 */
inline void snrt_cluster_hw_barrier() {
    asm volatile("csrr x0, 0x7C2" ::: "memory");
}

/**
 * @brief Synchronize one core from every cluster with the others.
 * @param comm The communicator determining which clusters synchronize.
 * @details Implemented as a software barrier.
 * @note One core per cluster participating in the barrier must invoke this
 *       function, or the calling cores will stall indefinitely.
 */
static inline void snrt_inter_cluster_barrier(snrt_comm_t comm = NULL) {
    // If no communicator is given, world communicator is used as default.
    if (comm == NULL) comm = snrt_comm_world;

    // If the current cluster is not a participant, return immediately.
    if (!comm->is_participant) return;

    // Clusters participating in the barrier increment a shared counter.
    uint32_t cnt = __atomic_add_fetch(comm->barrier_ptr, 1, __ATOMIC_RELAXED);

    // All but the last cluster arriving on the barrier enter WFI. The last
    // cluster resets the counter for the next barrier (if any) and multicasts
    // an interrupt to wake up the other clusters.
    if (cnt == comm->size) {
        *(comm->barrier_ptr) = 0;
        snrt_wake_clusters(1 << snrt_cluster_core_idx(), comm);
    } else {
        snrt_wfi();
        // Clear interrupt for next barrier
        snrt_int_clr_mcip();
    }
}

/**
 * @brief Synchronize all Snitch cores.
 * @details Synchronization is performed hierarchically. Within a cluster,
 *          cores are synchronized through a hardware barrier (see
 *          @ref snrt_cluster_hw_barrier). Clusters are synchronized through
 *          a software barrier (see @ref snrt_inter_cluster_barrier).
 * @param comm The communicator determining which clusters synchronize.
 * @note Every Snitch core must invoke this function, or the calling cores
 *       will stall indefinitely.
 */
inline void snrt_global_barrier(snrt_comm_t comm) {
    snrt_cluster_hw_barrier();

    // Synchronize all DM cores in software
    if (snrt_is_dm_core()) {
        snrt_inter_cluster_barrier(comm);
    }
    // Synchronize cores in a cluster with the HW barrier
    snrt_cluster_hw_barrier();
}

/**
 * @brief Generic software barrier.
 * @param barr pointer to a barrier variable.
 * @param n number of harts that have to enter before released.
 * @note Exactly the specified number of harts must invoke this function, or
 *       the calling cores will stall indefinitely.
 */
inline void snrt_partial_barrier(snrt_barrier_t *barr, uint32_t n) {
    // Remember previous iteration
    uint32_t prev_it = barr->iteration;
    uint32_t cnt = __atomic_add_fetch(&barr->cnt, 1, __ATOMIC_RELAXED);

    // Increment the barrier counter
    if (cnt == n) {
        barr->cnt = 0;
        __atomic_add_fetch(&barr->iteration, 1, __ATOMIC_RELAXED);
    } else {
        // Some threads have not reached the barrier --> Let's wait
        while (prev_it == barr->iteration)
            ;
    }
}

//================================================================================
// Reduction functions
//================================================================================

/**
 * @brief Perform a global sum reduction, blocking.
 * @details All cores participate in the reduction and synchronize globally
 *          to wait for the reduction to complete.
 *          The synchronization is performed via @ref snrt_global_barrier.
 * @param value The value to be summed.
 * @return The result of the sum reduction.
 * @note Every Snitch core must invoke this function, or the calling cores
 *       will stall indefinitely.
 */
inline uint32_t snrt_global_all_to_all_reduction(uint32_t value) {
    // Reduce cores within cluster in TCDM
    uint32_t *cluster_result = &(cls()->reduction);
    uint32_t tmp = __atomic_fetch_add(cluster_result, value, __ATOMIC_RELAXED);

    // Wait for writeback to ensure AMO is seen by all cores after barrier
    snrt_wait_writeback(tmp);
    snrt_cluster_hw_barrier();

    // Reduce DM cores across clusters in global memory
    if (snrt_is_dm_core()) {
        __atomic_add_fetch(&_reduction_result, *cluster_result,
                           __ATOMIC_RELAXED);
        snrt_inter_cluster_barrier();
        *cluster_result = _reduction_result;
    }
    snrt_cluster_hw_barrier();
    return *cluster_result;
}

/**
 * @brief Perform a sum reduction among clusters, blocking.
 * @details The reduction is performed in a logarithmic fashion. Half of the
 *          clusters active in every level of the binary-tree participate as
 *          as senders, the other half as receivers. Senders use the DMA to
 *          send their data to the respective receiver's destination buffer.
 *          The receiver then reduces each element in its destination buffer
 *          with the respective element in its source buffer. The result is
 *          stored in the source buffer. It then proceeds to the next level in
 *          the binary tree.
 * @param dst_buffer The pointer to the calling cluster's destination buffer.
 * @param src_buffer The pointer to the calling cluster's source buffer.
 * @param len The amount of data in each buffer. Only integer multiples of the
 *            number of compute cores are supported at the moment.
 * @param comm The communicator determining which clusters participate in the
 *             reduction.
 * @note The destination buffers must lie at the same offset in every cluster's
 *       TCDM.
 */
template <typename T>
inline void snrt_global_reduction_dma(T *dst_buffer, T *src_buffer, size_t len,
                                      snrt_comm_t comm = NULL) {
    // If no communicator is given, world communicator is used as default.
    if (comm == NULL) comm = snrt_comm_world;

    // If we have a single cluster, no reduction has to be done
    if (comm->size > 1) {
        // DMA core will send compute cores' data, so it must wait on it
        // to be available
        snrt_fpu_fence();
        snrt_cluster_hw_barrier();

        // Iterate levels in the binary reduction tree
        int num_levels = ceil(log2(comm->size));
        for (unsigned int level = 0; level < num_levels; level++) {
            // Determine whether the current cluster is an active cluster.
            // An active cluster is a cluster that participates in the current
            // level of the reduction tree. Every second cluster among the
            // active ones is a sender.
            uint32_t is_active = (snrt_cluster_idx() % (1 << level)) == 0;
            uint32_t is_sender = (snrt_cluster_idx() % (1 << (level + 1))) != 0;

            // If the cluster is a sender, it sends the data in its source
            // buffer to the respective receiver's destination buffer
            if (is_active && is_sender) {
                if (!snrt_is_compute_core()) {
                    uint64_t dst = (uint64_t)dst_buffer -
                                   (1 << level) * SNRT_CLUSTER_OFFSET;
                    snrt_dma_start_1d(dst, (uint64_t)src_buffer,
                                      len * sizeof(T));
                    snrt_dma_wait_all();
                }
            }

            // Synchronize senders and receivers
            snrt_global_barrier(comm);

            // Every cluster which is not a sender performs the reduction
            if (is_active && !is_sender) {
                // Computation is parallelized over the compute cores
                if (snrt_is_compute_core()) {
                    uint32_t items_per_core =
                        len / snrt_cluster_compute_core_num();
                    uint32_t core_offset =
                        snrt_cluster_core_idx() * items_per_core;
                    for (uint32_t i = 0; i < items_per_core; i++) {
                        uint32_t abs_i = core_offset + i;
                        src_buffer[abs_i] += dst_buffer[abs_i];
                    }
                }
            }

            // Synchronize compute and DM cores for next tree level
            snrt_fpu_fence();
            snrt_cluster_hw_barrier();
        }
    }
}

//================================================================================
// Memory consistency
//================================================================================

/**
 * @brief Ensure value is written back to the register file.
 * @details This function introduces a RAW dependency on val to stall the
 *          core until val is written back to the register file.
 * @param val The variable we want to wait on.
 */
inline void snrt_wait_writeback(uint32_t val) {
    asm volatile("mv %0, %0" : "+r"(val)::);
}

//================================================================================
// Multicast functions
//================================================================================

/**
 * @brief Enable LSU multicast
 * @details All stores performed after this call will be multicast to all
 *          addresses specified by the address and mask pair.
 *
 * @param mask Multicast mask value
 */
inline void snrt_enable_multicast(uint32_t mask) { write_csr(0x7c4, mask); }

/**
 * @brief Disable LSU multicast
 */
inline void snrt_disable_multicast() { write_csr(0x7c4, 0); }
