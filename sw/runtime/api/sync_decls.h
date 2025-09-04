// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

typedef struct {
    uint32_t volatile cnt;
    uint32_t volatile iteration;
} snrt_barrier_t;

typedef struct {
    volatile uint32_t *barrier_ptr;
    uint32_t size;
    uint32_t is_participant;
} snrt_comm_info_t;

typedef snrt_comm_info_t *snrt_comm_t;

extern volatile uint32_t _snrt_mutex;
extern volatile snrt_barrier_t _snrt_barrier;
extern volatile uint32_t _reduction_result;

inline volatile uint32_t *snrt_mutex();

inline void snrt_mutex_acquire(volatile uint32_t *pmtx);

inline void snrt_mutex_ttas_acquire(volatile uint32_t *pmtx);

inline void snrt_mutex_release(volatile uint32_t *pmtx);

inline void snrt_cluster_hw_barrier();

inline void snrt_global_barrier(snrt_comm_t comm = NULL);

inline uint32_t snrt_global_all_to_all_reduction(uint32_t value);

inline void snrt_wait_writeback(uint32_t val);

inline void snrt_enable_multicast(uint32_t mask);

inline void snrt_disable_multicast();
