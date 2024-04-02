// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>
#include <stddef.h>

// Initiate an asynchronous 1D DMA transfer with wide 64-bit pointers.
static inline uint32_t __rt_dma_start_1d_wideptr(uint64_t dst, uint64_t src,
                                          size_t size) {
    register uint32_t reg_txid;  // 10
    asm volatile("dmsrc   %[sl], %[sh]"     :: [sh]"r"(src >> 32), [sl]"r"(src));
    asm volatile("dmdst   %[dl], %[dh]"     :: [dh]"r"(dst >> 32), [dl]"r"(dst));
    asm volatile("dmcpyi  %[id], %[sz], 0"  : [id]"=r"(reg_txid) : [sz]"r"(size));
    return reg_txid;
}

// Initiate an asynchronous 2D DMA transfer with wide 64-bit pointers.
static inline uint32_t __rt_dma_start_2d_wideptr(uint64_t dst, uint64_t src,
                                          size_t size, size_t dst_stride,
                                          size_t src_stride, size_t repeat) {
    register uint32_t reg_txid;  // 10
    asm volatile("dmsrc   %[sl], %[sh]"     :: [sh]"r"(src >> 32), [sl]"r"(src));
    asm volatile("dmdst   %[dl], %[dh]"     :: [dh]"r"(dst >> 32), [dl]"r"(dst));
    asm volatile("dmstr   %[rd], %[rs]"     :: [rd]"r"(dst_stride), [rs]"r"(src_stride));
    asm volatile("dmrep   %[rp]"            :: [rp]"r"(repeat));
    asm volatile("dmcpyi  %[id], %[sz], 2"  : [id]"=r"(reg_txid) : [sz]"r"(size));
    return reg_txid;
}

// Initiate an asynchronous 1D DMA transfer.
static inline uint32_t __rt_dma_start_1d(void *dst, const void *src, size_t size) {
    return __rt_dma_start_1d_wideptr((size_t)dst, (size_t)src, size);
}

// Initiate an asynchronous 2D DMA transfer.
static inline uint32_t __rt_dma_start_2d(void *dst, const void *src, size_t size,
                                  size_t src_stride, size_t dst_stride,
                                  size_t repeat) {
    return __rt_dma_start_2d_wideptr((size_t)dst, (size_t)src, size, src_stride,
                                     dst_stride, repeat);
}

// Last completed ID
static inline volatile uint32_t __rt_dma_completed_id() {
    register uint32_t cid;
    asm volatile(
        "dmstati  %[cid], 0           \n " // 0=status.completed_id
        : [cid]"=&r"(cid) :: "memory"
      );
    // TODO: Fix off-by-one bug in DMA hardware!
    return cid+1;
}

// Block until a transfer finishes.
static inline void __rt_dma_wait(uint32_t tid) {
    register uint32_t tmp;
    // TODO: Fix off-by-one bug in DMA hardware!
    tid++;
    asm volatile(
        "1: \n"
        "dmstati  %[tmp], 0           \n " // 0=status.completed_id
        "bgt      %[tid], %[tmp], 1b  \n"  // branch back if ID to wait for > last completed ID
        : [tmp]"=&r"(tmp) : [tid]"r"(tid)
      );
}

// Block until all operation on the DMA ceases.
static inline void __rt_dma_wait_all() {
    register uint32_t tmp;
    asm volatile(
        "1: \n"
        "dmstati  %[tmp], 2           \n " // 2=status.busy
        "bne      %[tmp], zero, 1b    \n"
        : [tmp]"=&r"(tmp) :
      );
}
