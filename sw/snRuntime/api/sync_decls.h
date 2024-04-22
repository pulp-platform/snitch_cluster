// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

typedef struct {
    uint32_t volatile cnt;
    uint32_t volatile iteration;
} snrt_barrier_t;

extern volatile uint32_t _snrt_mutex;
extern volatile snrt_barrier_t _snrt_barrier;
extern volatile uint32_t _reduction_result;

volatile uint32_t *snrt_mutex();

void snrt_mutex_acquire(volatile uint32_t *pmtx);

void snrt_mutex_ttas_acquire(volatile uint32_t *pmtx);

void snrt_mutex_release(volatile uint32_t *pmtx);

void snrt_cluster_hw_barrier();

void snrt_global_barrier();
