// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

#define SNRT_COLLECTIVE_MASK_WIDTH \
    (64 - SNRT_REDUCTION_OPCODE_WIDTH - SNRT_COLLECTIVE_OPCODE_WIDTH)

typedef struct {
    uint32_t volatile cnt;
    uint32_t volatile iteration;
} snrt_barrier_t;

typedef struct {
    volatile uint32_t *barrier_ptr;
    uint32_t size;
    uint32_t mask;
    uint32_t base;
    uint32_t is_participant;
} snrt_comm_info_t;

typedef snrt_comm_info_t *snrt_comm_t;

typedef enum {
    SNRT_COLLECTIVE_UNICAST = 0,
    SNRT_COLLECTIVE_MULTICAST = 1,
    SNRT_REDUCTION_BARRIER = 2,
    SNRT_REDUCTION_FADD = 4,
    SNRT_REDUCTION_FMUL = 5,
    SNRT_REDUCTION_FMIN = 6,
    SNRT_REDUCTION_FMAX = 7,
    SNRT_REDUCTION_ADD = 8,
    SNRT_REDUCTION_MUL = 9,
    SNRT_REDUCTION_MIN = 10,
    SNRT_REDUCTION_MAX = 11,
    SNRT_REDUCTION_MINU = 14,
    SNRT_REDUCTION_MAXU = 15
} snrt_collective_opcode_t;

typedef union {
    struct __attribute__((__packed__)) {
        snrt_collective_opcode_t collective_op
            : SNRT_COLLECTIVE_OPCODE_WIDTH;
        uint64_t mask : (64 - SNRT_COLLECTIVE_OPCODE_WIDTH);
    } f;
    uint64_t w;
} snrt_collective_op_t;

extern volatile uint32_t _snrt_mutex;
extern volatile snrt_barrier_t _snrt_barrier;
extern volatile uint32_t _reduction_result;

inline volatile uint32_t *snrt_mutex();

inline void snrt_mutex_acquire(volatile uint32_t *pmtx);

inline void snrt_mutex_ttas_acquire(volatile uint32_t *pmtx);

inline void snrt_mutex_release(volatile uint32_t *pmtx);

inline void snrt_cluster_hw_barrier();

inline void snrt_global_sw_barrier(snrt_comm_t comm = NULL);

inline void snrt_global_barrier(snrt_comm_t comm = NULL);

inline uint32_t snrt_global_all_to_all_reduction(uint32_t value);

inline void snrt_wait_writeback(uint32_t val);

inline uint64_t snrt_get_collective_mask(snrt_comm_t comm);

inline void snrt_enable_multicast(uint64_t mask);

inline void snrt_disable_multicast();

inline void snrt_enable_reduction(uint64_t mask,
                                  snrt_collective_opcode_t reduction);

inline void snrt_disable_reduction();
