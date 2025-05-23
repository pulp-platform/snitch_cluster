// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//================================================================================
// Data
//================================================================================

volatile uint32_t _snrt_mutex;
volatile snrt_barrier_t _snrt_barrier;
volatile uint32_t _reduction_result;

//================================================================================
// Functions
//================================================================================

extern volatile uint32_t *snrt_mutex();

extern void snrt_mutex_acquire(volatile uint32_t *pmtx);

extern void snrt_mutex_ttas_acquire(volatile uint32_t *pmtx);

extern void snrt_mutex_release(volatile uint32_t *pmtx);

extern void snrt_cluster_hw_barrier();

extern void snrt_global_barrier();

extern void snrt_partial_barrier(snrt_barrier_t *barr, uint32_t n);

extern void snrt_global_reduction_dma(double *dst_buffer, double *src_buffer,
                                      size_t len);

extern uint32_t snrt_global_all_to_all_reduction(uint32_t value);

extern void snrt_wait_writeback(uint32_t val);

extern void snrt_enable_multicast(uint32_t mask);

extern void snrt_disable_multicast();
