// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// DMOPC transpose to destinations outside the cluster; needs dma_enable_compute
// in the cluster cfg. Same tile geometry and checks as dma_transpose.c, but the
// wide crossbar routes these addresses out over its default port instead of
// into the local TCDM.
//
// Caveat: the testbench instantiates one cluster, so the neighbour-L1 address
// is answered by tb_memory_axi, which never stalls W. Real TCDM bank-conflict
// backpressure needs a multi-cluster platform and is not covered here.

#include <snrt.h>

// Deliberately not square, so a swapped tensor_m/tensor_n fails the poison check
#define TP_M 4
#define TP_N 8

// L1 of the cluster two strides up. Index 1 is the cluster's own ext_mem
// window, which stays inside the cluster and is tied off in the testbench.
#define NEIGHBOUR_L1_BASE                       \
    (SNITCH_CLUSTER_ADDRMAP_CLUSTER_BASE_ADDR + \
     2 * SNITCH_CLUSTER_ADDRMAP_CLUSTER_SIZE)

// The AXI write port legalizes bursts against a 4 kiB page
#define AXI_PAGE_SIZE 4096

#ifdef SNRT_SUPPORTS_DMA_COMPUTE

// Bump allocator over the neighbour L1 window
static uintptr_t neighbour_next = NEIGHBOUR_L1_BASE;

// Transpose one TP_M x TP_N tile of T elements into dst, which must hold
// ne * ne elements, and check every result element
template <typename T>
static uint32_t run_transpose(uint32_t mode, volatile T *dst) {
    const uint32_t ne = SNRT_DMA_BYTES_PER_BEAT / sizeof(T);
    const size_t elems = (size_t)ne * ne;
    const T poison = (T)0xA5A5A5A5u;

    volatile T *src = (volatile T *)snrt_l1_alloc_cluster_local(
        elems * sizeof(T), SNRT_DMA_BYTES_PER_BEAT);

    uint32_t errors = ((uintptr_t)dst % SNRT_DMA_BYTES_PER_BEAT) ? 1 : 0;

    // Position-coded: in[r][c] = r * 100 + c is nowhere equal to its transpose
    for (size_t i = 0; i < elems; i++) src[i] = poison;
    for (uint32_t r = 0; r < ne; r++)
        for (uint32_t c = 0; c < TP_N; c++) src[r * ne + c] = (T)(r * 100 + c);
    for (size_t i = 0; i < elems; i++) dst[i] = poison;
    // The poison stores are posted; retire them before the DMA writes the tile
    snrt_fence();

    snrt_dma_start_transpose((volatile void *)dst, (volatile void *)src,
                             (size_t)ne * SNRT_DMA_BYTES_PER_BEAT, mode, TP_M,
                             TP_N);
    snrt_dma_wait_all();

    uint32_t differ = 0;
    for (uint32_t c = 0; c < ne; c++) {
        for (uint32_t r = 0; r < ne; r++) {
            T got = dst[c * ne + r];
            T exp = (c < TP_N && r < TP_M) ? src[r * ne + c] : poison;
            if (got != exp) errors++;
            // A plain copy would leave src[c][r], i.e. c * 100 + r
            if (c < TP_N && r < TP_M && got != src[c * ne + r]) differ++;
        }
    }

    // Catches a DMOPC that never latched: passthrough leaves differ == 0
    if (differ != TP_M * TP_N - TP_M) errors++;
    return errors;
}

// Run the three remote destination classes for one element size
template <typename T>
static uint32_t run_all_destinations(uint32_t mode) {
    const uint32_t ne = SNRT_DMA_BYTES_PER_BEAT / sizeof(T);
    const size_t tile_bytes = (size_t)ne * SNRT_DMA_BYTES_PER_BEAT;
    uint32_t errors = 0;

    // SoC-side memory: the default port, terminated by the simulation memory
    errors += run_transpose<T>(
        mode, (volatile T *)snrt_l3_alloc_v2(tile_bytes, tile_bytes));

    // The window a second cluster's L1 would answer: same default port, but an
    // address the local TCDM and alias rules must not claim
    volatile T *neighbour = (volatile T *)neighbour_next;
    neighbour_next += tile_bytes;
    errors += run_transpose<T>(mode, neighbour);

    // Beat-aligned but straddling a 4 kiB page, so the legalizer must split the
    // tile across two write bursts
    uintptr_t split =
        (uintptr_t)snrt_l3_alloc_v2(AXI_PAGE_SIZE + tile_bytes, AXI_PAGE_SIZE);
    split += AXI_PAGE_SIZE - tile_bytes / 2;
    errors += run_transpose<T>(mode, (volatile T *)split);

    return errors;
}

#endif

int main() {
#ifdef SNRT_SUPPORTS_DMA_COMPUTE
    if (!snrt_is_dm_core()) {
        snrt_cluster_hw_barrier();
        return 0;
    }

    uint32_t errors = run_all_destinations<uint32_t>(2);
    errors += run_all_destinations<uint16_t>(1);

    snrt_cluster_hw_barrier();
    return errors ? 1 : 0;
#endif
}
