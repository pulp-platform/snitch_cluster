// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stddef.h>
#include <stdint.h>

typedef struct {
    // Base address from where allocation starts
    uint64_t base;
    // End address up to which allocation is allowed
    uint64_t end;
    // Address of the next allocated block
    uint64_t next;
} snrt_allocator_t;

inline void *snrt_l1_next();

inline void *snrt_l3_next();

inline void *snrt_l1_alloc(size_t size);

inline void snrt_l1_update_next(void *next);

inline void *snrt_l3_alloc(size_t size);

inline void snrt_alloc_init();
