// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// DMOPC transpose whose destination leaves the cluster; requires a cfg with
// dma_enable_compute. Same tile geometry and checking discipline as
// dma_transpose.c, but the write path is the wide crossbar's default master
// port instead of the local TCDM slave.
//
// Routing, from snitch_cluster.sv (dma_xbar_rules, dma_xbar_default_rule):
// the wide crossbar only keeps TCDM, bootrom, zero memory and their aliases
// inside the cluster; everything else takes the default port SoCDMAOut and
// leaves over wide_out. The addresses below are read off the generated
// address map, snitch_cluster_raw_addrmap.h and snitch_cluster_cfg.h.
//
// This does NOT prove cluster-to-cluster transfer. The testbench instantiates
// one cluster, so a neighbour L1 address is answered by tb_memory_axi, which
// never stalls the W channel; real TCDM bank-conflict backpressure is untested
// here and belongs on a multi-cluster platform.
//
// ComputeTransposeShape in the legalizer accepts a multi-beat transpose burst
// only as one whole padded tile to a beat-aligned destination, so every
// destination here is aligned to at least SNRT_DMA_BYTES_PER_BEAT.

#include <snrt.h>

// Deliberately not square: a frontend that swapped tensor_m and tensor_n would
// mask a 8x4 result instead of a 4x8 one and fail the poison check.
#define TP_M 4
#define TP_N 8

// Cluster footprint and stride, as the RDL address map declares them.
#define CLUSTER_BASE SNITCH_CLUSTER_ADDRMAP_CLUSTER_BASE_ADDR
#define CLUSTER_STRIDE SNITCH_CLUSTER_ADDRMAP_CLUSTER_SIZE

// L1 of the cluster two strides up. Index 1 starts at the cluster's own 1 kiB
// ext_mem window, which the narrow crossbar keeps inside the cluster and the
// testbench ties off, so the readback would never return.
#define NEIGHBOUR_L1_BASE (CLUSTER_BASE + 2 * CLUSTER_STRIDE)

// The AXI write port legalizes bursts against a 4 kiB page.
#define AXI_PAGE_SIZE 4096

// Bump allocator over the neighbour L1 window.
static uintptr_t neighbour_next = NEIGHBOUR_L1_BASE;

/// Transpose one TP_M x TP_N tile of `T` elements into `dst` and check every
/// result byte. `dst` must hold ne * ne elements.
template <typename T>
static uint32_t run_transpose(const char *where, uint32_t mode,
                              volatile T *dst) {
    const uint32_t ne = SNRT_DMA_BYTES_PER_BEAT / sizeof(T);
    const size_t elems = (size_t)ne * ne;
    const T poison = (T)0xA5A5A5A5u;

    volatile T *src = (volatile T *)snrt_l1_alloc_cluster_local(
        elems * sizeof(T), SNRT_DMA_BYTES_PER_BEAT);

    uint32_t errors = 0;
    if ((uintptr_t)dst % SNRT_DMA_BYTES_PER_BEAT) {
        printf("[dma_transpose_remote] %s: dst %p is not beat-aligned\n", where,
               (void *)dst);
        errors++;
    }

    // in[r][c] = r * 100 + c: every element is recoverable from its position,
    // and the transpose of this matrix is nowhere equal to the matrix itself.
    for (size_t i = 0; i < elems; i++) src[i] = poison;
    for (uint32_t r = 0; r < ne; r++)
        for (uint32_t c = 0; c < TP_N; c++) src[r * ne + c] = (T)(r * 100 + c);
    for (size_t i = 0; i < elems; i++) dst[i] = poison;
    // The poison stores are posted; retire them before the DMA writes the tile.
    snrt_fence();

    snrt_dma_set_transpose(mode, TP_M, TP_N);
    uint32_t c0 = snrt_mcycle();
    snrt_dma_start_1d((volatile void *)dst, (volatile void *)src,
                      (size_t)ne * SNRT_DMA_BYTES_PER_BEAT);
    snrt_dma_wait_all();
    uint32_t c1 = snrt_mcycle();
    snrt_dma_clear_opcode();

    uint32_t differ = 0;
    for (uint32_t c = 0; c < ne; c++) {
        for (uint32_t r = 0; r < ne; r++) {
            T got = dst[c * ne + r];
            T exp = (c < TP_N && r < TP_M) ? src[r * ne + c] : poison;
            if (got != exp) {
                if (errors < 8)
                    printf(
                        "[dma_transpose_remote] %s out[%u][%u]: exp %u got "
                        "%u\n",
                        where, c, r, (unsigned)exp, (unsigned)got);
                errors++;
            }
            // A plain copy would leave src[c * ne + r], i.e. c * 100 + r
            if (c < TP_N && r < TP_M && got != src[c * ne + r]) differ++;
        }
    }

    // r * 100 + c differs from c * 100 + r everywhere but the diagonal.
    const uint32_t exp_differ = TP_M * TP_N - TP_M;
    if (differ != exp_differ) {
        printf(
            "[dma_transpose_remote] %s: %u of %u elements differ from a "
            "plain copy, expected %u\n",
            where, differ, TP_M * TP_N, exp_differ);
        errors++;
    }

    printf(
        "[dma_transpose_remote] %s mode %u (%u B elems): %ux%u -> %ux%u at "
        "%p, %u cycles, %s\n",
        where, mode, (unsigned)sizeof(T), TP_M, TP_N, TP_N, TP_M, (void *)dst,
        c1 - c0, errors ? "FAIL" : "ok");
    return errors;
}

/// Run the three remote destination classes for one element size.
template <typename T>
static uint32_t run_all_destinations(uint32_t mode) {
    const uint32_t ne = SNRT_DMA_BYTES_PER_BEAT / sizeof(T);
    const size_t tile_bytes = (size_t)ne * SNRT_DMA_BYTES_PER_BEAT;
    uint32_t errors = 0;

    // SoC-side memory: the default port, terminated by the simulation memory.
    errors += run_transpose<T>(
        "l3", mode, (volatile T *)snrt_l3_alloc_v2(tile_bytes, tile_bytes));

    // The window a second cluster's L1 would answer; same default port, but an
    // address the local TCDM and alias rules must not claim.
    volatile T *neighbour = (volatile T *)neighbour_next;
    neighbour_next += tile_bytes;
    errors += run_transpose<T>("neighbour-l1", mode, neighbour);

    // Beat-aligned but straddling a 4 kiB page, so the legalizer must split the
    // tile across two write bursts.
    uintptr_t split =
        (uintptr_t)snrt_l3_alloc_v2(AXI_PAGE_SIZE + tile_bytes, AXI_PAGE_SIZE);
    split += AXI_PAGE_SIZE - tile_bytes / 2;
    errors += run_transpose<T>("l3-page-split", mode, (volatile T *)split);

    return errors;
}

int main() {
    if (!snrt_is_dm_core()) {
        snrt_cluster_hw_barrier();
        return 0;
    }

    uint32_t errors = run_all_destinations<uint32_t>(2);
    errors += run_all_destinations<uint16_t>(1);

    printf("[dma_transpose_remote] %s (%u errors)\n", errors ? "FAIL" : "PASS",
           errors);

    snrt_cluster_hw_barrier();
    return errors ? 1 : 0;
}
