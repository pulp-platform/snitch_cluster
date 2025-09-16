// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//================================================================================
// Data
//================================================================================

volatile uint32_t _snrt_mutex;
volatile snrt_barrier_t _snrt_barrier;
volatile uint32_t _reduction_result;

// TODO(colluca): to optimize storage we could put these in CLS
__thread snrt_comm_info_t snrt_comm_world_info = {
    .barrier_ptr = &(_snrt_barrier.cnt),
    .size = SNRT_CLUSTER_NUM,
    .is_participant = 1};
__thread snrt_comm_t snrt_comm_world;

//================================================================================
// Communicator functions
//================================================================================

extern void snrt_comm_init();

extern void snrt_comm_create(uint32_t size, snrt_comm_t *communicator);

//================================================================================
// Functions
//================================================================================

extern volatile uint32_t *snrt_mutex();

extern void snrt_mutex_acquire(volatile uint32_t *pmtx);

extern void snrt_mutex_ttas_acquire(volatile uint32_t *pmtx);

extern void snrt_mutex_release(volatile uint32_t *pmtx);

extern void snrt_cluster_hw_barrier();

extern void snrt_global_barrier(snrt_comm_t comm);

extern void snrt_partial_barrier(snrt_barrier_t *barr, uint32_t n);

extern void snrt_global_reduction_dma(double *dst_buffer, double *src_buffer,
                                      size_t len, snrt_comm_t comm);

extern uint32_t snrt_global_all_to_all_reduction(uint32_t value);

extern void snrt_wait_writeback(uint32_t val);

extern void snrt_enable_multicast(uint32_t mask);

extern void snrt_disable_multicast();
