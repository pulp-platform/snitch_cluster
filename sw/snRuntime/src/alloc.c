// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

snrt_allocator_t l3_allocator;

extern uintptr_t snrt_align_up(uintptr_t addr, size_t size, uintptr_t base);
extern void *snrt_align_up(void *addr, size_t size, void *base);
extern uintptr_t snrt_align_up_hyperbank(uintptr_t addr);
extern void *snrt_align_up_hyperbank(void *addr);

extern void *snrt_l1_next();
extern void *snrt_l3_next();

extern uint32_t snrt_l1_start_addr();
extern uint32_t snrt_l1_end_addr();

extern void *snrt_l1_alloc(size_t size);
extern void *snrt_l3_alloc(size_t size);

extern snrt_allocator_t *snrt_l1_allocator();
extern snrt_allocator_t *snrt_l3_allocator();

extern void snrt_l1_update_next(void *next);

extern void snrt_alloc_init();
