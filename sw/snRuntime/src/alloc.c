// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

snrt_allocator_t l3_allocator;

extern volatile uint32_t* snrt_zero_memory_ptr();

extern void *snrt_l1_next();
extern void *snrt_l3_next();

extern uint32_t snrt_l1_start_addr();
extern uint32_t snrt_l1_end_addr();

extern void *snrt_l1alloc(size_t size);
extern void *snrt_l3alloc(size_t size);

extern snrt_allocator_t *snrt_l1_allocator();
extern snrt_allocator_t *snrt_l3_allocator();

extern void snrt_l1_update_next(void *next);

extern void snrt_alloc_init();
