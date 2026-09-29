// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <limits.h>
#include <stdint.h>

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

// NOTE: these numeric values must match FlooNoC's encoding
typedef enum {
    SNRT_COLLECTIVE_UNICAST = 0,
    SNRT_COLLECTIVE_MULTICAST = 1,
    SNRT_REDUCTION_BARRIER = 2,
    SNRT_NUM_BUILTIN_COLLECTIVE_OPS = 6,
    // Other reduction opcodes are generated through snrt_reduction_op()
} snrt_collective_opcode_t;

typedef enum {
    SNRT_REDUCTION_MAX = 0,
    SNRT_REDUCTION_MIN = 1,
    SNRT_REDUCTION_SUM = 2,
    SNRT_REDUCTION_PROD = 3,
} snrt_reduction_op_type_t;

typedef enum {
    SNRT_REDUCTION_FP8 = 0,
    SNRT_REDUCTION_FP16 = 1,
    SNRT_REDUCTION_FP16ALT = 2,
    SNRT_REDUCTION_FP32 = 3,
    SNRT_REDUCTION_FP64 = 4,
    SNRT_NUM_REDUCTION_DATA_TYPES = 5,
} snrt_reduction_data_type_t;

// Minimum number of bits required to encode a reduction data type
#define SNRT_REDUCTION_DATA_TYPE_BITS         \
    ((int)(sizeof(unsigned int) * CHAR_BIT) - \
     __builtin_clz(SNRT_NUM_REDUCTION_DATA_TYPES - 1))

typedef union {
    struct __attribute__((__packed__)) {
        snrt_collective_opcode_t opcode : SNRT_COLLECTIVE_OPCODE_WIDTH;
        uint64_t mask : (64 - SNRT_COLLECTIVE_OPCODE_WIDTH);
    } f;
    uint64_t w;
} snrt_collective_t;

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

inline snrt_collective_opcode_t snrt_reduction_op(
    snrt_reduction_op_type_t op, snrt_reduction_data_type_t type);

inline void snrt_enable_reduction(uint64_t mask,
                                  snrt_collective_opcode_t collective_opcode);

inline void snrt_enable_reduction(uint64_t mask, snrt_reduction_op_type_t op,
                                  snrt_reduction_data_type_t type);

inline void snrt_disable_reduction();
