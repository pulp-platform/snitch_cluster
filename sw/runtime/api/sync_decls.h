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
    uint32_t mask;
    uint32_t base;
    uint32_t is_participant;
} snrt_comm_info_t;

typedef snrt_comm_info_t *snrt_comm_t;

// NOTE: these numeric values must match floo_pkg.sv's `collect_op_e` encoding
// (working_dir/floo_noc/hw/floo_pkg.sv): reserved ops 0-5, then narrow (ALU)
// ops, then wide (FPU) ops starting at NumReservedCollectOps + NumNarrowSeqOps
// -- currently NumNarrowSeqOps=0 (narrow reduction disabled in
// cfg/gwaihir_noc.yml), so wide ops start at 6. This duplication is a known,
// explicitly deferred fragility -- see plans/floonoc-op-agnostic-plan.md.
typedef enum {
    SNRT_COLLECTIVE_UNICAST = 0,
    SNRT_COLLECTIVE_MULTICAST = 1,
    SNRT_REDUCTION_BARRIER = 2,
    SNRT_REDUCTION_FADD = 6,
    SNRT_REDUCTION_FMUL = 7,
    SNRT_REDUCTION_FMIN = 8,
    SNRT_REDUCTION_FMAX = 9,
    SNRT_REDUCTION_FADD32 = 10,
    SNRT_REDUCTION_FADD16 = 11,
    SNRT_REDUCTION_FADD8 = 12,
    SNRT_REDUCTION_FMAX32 = 13,
    SNRT_REDUCTION_FMAX16 = 14,
    SNRT_REDUCTION_FMAX8 = 15
} snrt_collective_opcode_t;

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

inline void snrt_enable_reduction(uint64_t mask,
                                  snrt_collective_opcode_t reduction);

inline void snrt_disable_reduction();
