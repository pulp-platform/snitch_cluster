// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//================================================================================
// Data
//================================================================================

__thread snrt_allocator_t l1_allocator_v2;

__thread snrt_allocator_t l3_allocator_v2;

//================================================================================
// Functions
//================================================================================

extern snrt_allocator_t *snrt_l1_allocator_v2();

extern snrt_allocator_t *snrt_l3_allocator_v2();

extern void *snrt_l1_next_v2();

extern void *snrt_l3_next_v2();

extern void *snrt_l1_alloc_cluster_local(size_t size, size_t alignment);

extern void *snrt_l1_alloc_compute_core_local(size_t size, size_t alignment);

extern void *snrt_l3_alloc_v2(size_t size, size_t alignment);

extern void *snrt_remote_l1_ptr(void *ptr, uint32_t src_cluster_idx,
                                uint32_t dst_cluster_idx);

extern void snrt_l1_init();

extern void snrt_l3_init();
