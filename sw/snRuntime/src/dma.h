// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#define OP_CUSTOM1 0b0101011
#define XDMA_FUNCT3 0b000
#define DMSRC_FUNCT7 0b0000000
#define DMDST_FUNCT7 0b0000001
#define DMCPYI_FUNCT7 0b0000010
#define DMCPY_FUNCT7 0b0000011
#define DMSTATI_FUNCT7 0b0000100
#define DMSTAT_FUNCT7 0b0000101
#define DMSTR_FUNCT7 0b0000110
#define DMREP_FUNCT7 0b0000111

#define R_TYPE_ENCODE(funct7, rs2, rs1, funct3, rd, opcode)                    \
    ((funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | \
     (opcode))

/// A DMA transfer identifier.
typedef uint32_t snrt_dma_txid_t;

inline uint32_t snrt_dma_start_1d_wideptr(uint64_t dst, uint64_t src,
                                          size_t size) {
    register uint32_t reg_dst_low asm("a0") = dst >> 0;    // 10
    register uint32_t reg_dst_high asm("a1") = dst >> 32;  // 11
    register uint32_t reg_src_low asm("a2") = src >> 0;    // 12
    register uint32_t reg_src_high asm("a3") = src >> 32;  // 13
    register uint32_t reg_size asm("a4") = size;           // 14

    // dmsrc a2, a3
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMSRC_FUNCT7, 13, 12,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_src_high), "r"(reg_src_low));

    // dmdst a0, a1
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMDST_FUNCT7, 11, 10,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_dst_high), "r"(reg_dst_low));

    // dmcpyi a0, a4, 0b00
    register uint32_t reg_txid asm("a0");  // 10
    asm volatile(".word %1\n"
                 : "=r"(reg_txid)
                 : "i"(R_TYPE_ENCODE(DMCPYI_FUNCT7, 0b00000, 14, XDMA_FUNCT3,
                                     10, OP_CUSTOM1)),
                   "r"(reg_size));

    return reg_txid;
}

/// Initiate an asynchronous 1D DMA transfer.
inline snrt_dma_txid_t snrt_dma_start_1d(void *dst, const void *src,
                                         size_t size) {
    return snrt_dma_start_1d_wideptr((size_t)dst, (size_t)src, size);
}

/// Initiate an asynchronous 2D DMA transfer with wide 64-bit pointers.
inline snrt_dma_txid_t snrt_dma_start_2d_wideptr(uint64_t dst, uint64_t src,
                                                 size_t size, size_t dst_stride,
                                                 size_t src_stride,
                                                 size_t repeat) {
    register uint32_t reg_dst_low asm("a0") = dst >> 0;       // 10
    register uint32_t reg_dst_high asm("a1") = dst >> 32;     // 11
    register uint32_t reg_src_low asm("a2") = src >> 0;       // 12
    register uint32_t reg_src_high asm("a3") = src >> 32;     // 13
    register uint32_t reg_size asm("a4") = size;              // 14
    register uint32_t reg_dst_stride asm("a5") = dst_stride;  // 15
    register uint32_t reg_src_stride asm("a6") = src_stride;  // 16
    register uint32_t reg_repeat asm("a7") = repeat;          // 17

    // dmsrc a0, a1
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMSRC_FUNCT7, 13, 12,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_src_high), "r"(reg_src_low));

    // dmdst a0, a1
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMDST_FUNCT7, 11, 10,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_dst_high), "r"(reg_dst_low));

    // dmstr a5, a6
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMSTR_FUNCT7, 15, 16,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_src_stride), "r"(reg_dst_stride));

    // dmrep a7
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMREP_FUNCT7, 0, 17,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_repeat));

    // dmcpyi a0, a4, 0b10
    register uint32_t reg_txid asm("a0");  // 10
    asm volatile(".word %1\n"
                 : "=r"(reg_txid)
                 : "i"(R_TYPE_ENCODE(DMCPYI_FUNCT7, 0b00010, 14, XDMA_FUNCT3,
                                     10, OP_CUSTOM1)),
                   "r"(reg_size));

    return reg_txid;
}

/// Initiate an asynchronous 2D DMA transfer.
inline snrt_dma_txid_t snrt_dma_start_2d(void *dst, const void *src,
                                         size_t size, size_t dst_stride,
                                         size_t src_stride, size_t repeat) {
    return snrt_dma_start_2d_wideptr((size_t)dst, (size_t)src, size, dst_stride,
                                     src_stride, repeat);
}

/// Initiate an asynchronous 1D DMA transfer with wide 64-bit pointers and a
/// specific channel.
inline snrt_dma_txid_t snrt_dma_start_1d_channel_wideptr(uint64_t dst,
                                                         uint64_t src,
                                                         size_t size,
                                                         uint32_t channel) {
    register uint32_t reg_dst_low asm("a0") = dst >> 0;    // 10
    register uint32_t reg_dst_high asm("a1") = dst >> 32;  // 11
    register uint32_t reg_src_low asm("a2") = src >> 0;    // 12
    register uint32_t reg_src_high asm("a3") = src >> 32;  // 13
    register uint32_t reg_size asm("a4") = size;           // 14
    register uint32_t cfg asm("a5") = channel << 2;        // 15

    // dmsrc a2, a3
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMSRC_FUNCT7, 13, 12,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_src_high), "r"(reg_src_low));

    // dmdst a0, a1
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMDST_FUNCT7, 11, 10,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_dst_high), "r"(reg_dst_low));

    // dmcpy a0, a4, a5
    register uint32_t reg_txid asm("a0");  // 10
    asm volatile(
        ".word %1\n"
        : "=r"(reg_txid)
        : "i"(R_TYPE_ENCODE(DMCPY_FUNCT7, 15, 14, XDMA_FUNCT3, 10, OP_CUSTOM1)),
          "r"(reg_size), "r"(cfg));

    return reg_txid;
}

/// Initiate an asynchronous 1D DMA transfer and a specific channel.
inline snrt_dma_txid_t snrt_dma_start_1d_channel(void *dst, const void *src,
                                                 size_t size,
                                                 uint32_t channel) {
    return snrt_dma_start_1d_channel_wideptr((size_t)dst, (size_t)src, size,
                                             channel);
}

/// Initiate an asynchronous 1D DMA transfer with wide 64-bit pointers and a
/// specific channel.
inline snrt_dma_txid_t snrt_dma_start_2d_channel_wideptr(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat, uint32_t channel) {
    register uint32_t reg_dst_low asm("a0") = dst >> 0;       // 10
    register uint32_t reg_dst_high asm("a1") = dst >> 32;     // 11
    register uint32_t reg_src_low asm("a2") = src >> 0;       // 12
    register uint32_t reg_src_high asm("a3") = src >> 32;     // 13
    register uint32_t reg_size asm("a4") = size;              // 14
    register uint32_t reg_dst_stride asm("a5") = dst_stride;  // 15
    register uint32_t reg_src_stride asm("a6") = src_stride;  // 16
    register uint32_t reg_repeat asm("a7") = repeat;          // 17
    register uint32_t cfg asm("t2") = channel << 2 | 2;       // 7

    // dmsrc a0, a1
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMSRC_FUNCT7, 13, 12,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_src_high), "r"(reg_src_low));

    // dmdst a0, a1
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMDST_FUNCT7, 11, 10,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_dst_high), "r"(reg_dst_low));

    // dmstr a5, a6
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMSTR_FUNCT7, 15, 16,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_src_stride), "r"(reg_dst_stride));

    // dmrep a7
    asm volatile(".word %0\n" ::"i"(R_TYPE_ENCODE(DMREP_FUNCT7, 0, 17,
                                                  XDMA_FUNCT3, 0, OP_CUSTOM1)),
                 "r"(reg_repeat));

    // dmcpy a0, a4, t2
    register uint32_t reg_txid asm("a0");  // 10
    asm volatile(
        ".word %1\n"
        : "=r"(reg_txid)
        : "i"(R_TYPE_ENCODE(DMCPY_FUNCT7, 7, 14, XDMA_FUNCT3, 10, OP_CUSTOM1)), "r"(cfg),
          "r"(reg_size));

    return reg_txid;
}

/// Initiate an asynchronous 2D DMA transfer and a specific channel.
inline snrt_dma_txid_t snrt_dma_start_2d_channel(void *dst, const void *src,
                                                 size_t size, size_t dst_stride,
                                                 size_t src_stride,
                                                 size_t repeat,
                                                 uint32_t channel) {
    return snrt_dma_start_2d_channel_wideptr((size_t)dst, (size_t)src, size,
                                             dst_stride, src_stride, repeat,
                                             channel);
}

/// Block until a transfer finishes.
inline void snrt_dma_wait(snrt_dma_txid_t tid) {
    // dmstati t0, 0  # 0=status.completed_id
    asm volatile(
        "1: \n"
        ".word %0\n"
        "bltu t0, %1, 1b \n" ::"i"(
            R_TYPE_ENCODE(DMSTATI_FUNCT7, 0b00, 0, XDMA_FUNCT3, 5, OP_CUSTOM1)),
        "r"(tid)
        : "t0");
}

/// Block until a transfer finishes on a specific channel.
inline void snrt_dma_wait_channel(snrt_dma_txid_t tid, uint32_t channel) {
    // dmstati t0, 0  # 0=status.completed_id
    register uint32_t cfg asm("t1") = channel << 2;
    asm volatile(
        "1: \n"
        ".word %0\n"
        "sub t0, t0, %1 \n"
        "blez t0, 1b \n" ::"i"(
            R_TYPE_ENCODE(DMSTAT_FUNCT7, 6, 0, XDMA_FUNCT3, 5, OP_CUSTOM1)),
        "r"(tid), "r"(cfg)
        : "t0", "t1");
}

/// Block until all operation on the DMA ceases.
inline void snrt_dma_wait_all() {
    // dmstati t0, 2  # 2=status.busy
    asm volatile(
        "1: \n"
        ".word %0\n"
        "bne t0, zero, 1b \n" ::"i"(
            R_TYPE_ENCODE(DMSTATI_FUNCT7, 0b10, 0, XDMA_FUNCT3, 5, OP_CUSTOM1))
        : "t0");
}

/// Block until all operation on the DMA ceases on a specific channel.
inline void snrt_dma_wait_all_channel(uint32_t channel) {
    register uint32_t tmp;
    // dmstati t0, 2  # 2=status.busy
    register uint32_t cfg asm("t1") = channel << 2 | 2;
    asm volatile(
        "1: \n"
        ".word %0\n"
        "bne t0, zero, 1b \n" ::"i"(
            R_TYPE_ENCODE(DMSTAT_FUNCT7, 6, 0, XDMA_FUNCT3, 5, OP_CUSTOM1)),
        "r"(cfg)
        : "t0");
}

/// Wait until all channels are idle
inline void snrt_dma_wait_all_channels(uint32_t num_channels) {
    register uint32_t tmp;
    // dmstati t0, 2  # 2=status.busy
    for (int c = 0; c < num_channels; c++) {
        snrt_dma_wait_all_channel(c);
    }
}

/**
 * @brief start tracking of dma performance region. Does not have any
 * implications on the HW. Only injects a marker in the DMA traces that can be
 * analyzed
 *
 */
inline void snrt_dma_start_tracking() {
    // dmstati zero, 0
    asm volatile(".word %0\n" ::"i"(
        R_TYPE_ENCODE(DMSTATI_FUNCT7, 0b00, 0, XDMA_FUNCT3, 0, OP_CUSTOM1)));
}

/**
 * @brief stop tracking of dma performance region. Does not have any
 * implications on the HW. Only injects a marker in the DMA traces that can be
 * analyzed
 *
 */
inline void snrt_dma_stop_tracking() {
    asm volatile(".word %0\n" ::"i"(
        R_TYPE_ENCODE(DMSTATI_FUNCT7, 0b00, 0, XDMA_FUNCT3, 3, OP_CUSTOM1)));
}

/**
 * @brief fast memset function performed by DMA
 *
 * @param ptr pointer to the start of the region
 * @param value value to set
 * @param len number of bytes, must be multiple of DMA bus-width
 */
inline void snrt_dma_memset(void *ptr, uint8_t value, uint32_t len) {
    // set first 64bytes to value
    // memset(ptr, value, 64);
    uint8_t *p = ptr;
    uint32_t nbytes = 64;
    while (nbytes--) {
        *p++ = value;
    }

    // DMA copy the the rest
    snrt_dma_txid_t memset_txid =
        snrt_dma_start_2d(ptr, ptr, 64, 64, 0, len / 64);
    snrt_dma_wait_all();
}

/// Load a 1D-tile of size tile_size from a 1D array. The specific tile is
/// selected by tile_idx. Every element in the src and dst arrays has prec
/// bytes.
inline snrt_dma_txid_t snrt_dma_load_1d_tile(void *dst, void *src,
                                             size_t tile_idx, size_t tile_size,
                                             uint32_t prec) {
    size_t tile_nbytes = tile_size * prec;
    return snrt_dma_start_1d(dst, src + tile_idx * tile_nbytes, tile_nbytes);
}

/// Store a 1D-tile of size tile_size to a 1D array. The specific tile is
/// selected by tile_idx. Every element in the src and dst arrays has prec
/// bytes.
inline snrt_dma_txid_t snrt_dma_store_1d_tile(void *dst, void *src,
                                              size_t tile_idx, size_t tile_size,
                                              uint32_t prec) {
    size_t tile_nbytes = tile_size * prec;
    return snrt_dma_start_1d(dst + tile_idx * tile_nbytes, src, tile_nbytes);
}

/// Load a 2D-tile of shape (tile_x1_size, tile_x0_size) from the 2D array
/// of shape (full_x1_size, full_x0_size). The specific tile is selected
/// by the (tile_x1_idx, tile_x0_idx) tuple. Every element in the src and
/// destination arrays has prec bytes.
inline snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec) {
    size_t src_offset = 0;
    // Advance src array in x0 and x1 dimensions, and convert to byte offset
    src_offset += tile_x0_idx * tile_x0_size;
    src_offset += tile_x1_idx * tile_x1_size * full_x0_size;
    src_offset *= prec;
    // Initiate transfer
    return snrt_dma_start_2d(dst,                  // dst
                             src + src_offset,     // src
                             tile_x0_size * prec,  // size
                             tile_x0_size * prec,  // dst_stride
                             full_x0_size * prec,  // src_stride
                             tile_x1_size          // repeat
    );
}

/// Store a 2D-tile of shape (tile_x1_size, tile_x0_size) to the 2D array
/// of shape (full_x1_size, full_x0_size). The specific tile is selected
/// by the (tile_x1_idx, tile_x0_idx) tuple. Every element in the src and
/// destination arrays has prec bytes.
inline snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec) {
    size_t dst_offset = 0;
    // Advance dst array in x0 and x1 dimensions, and convert to byte offset
    dst_offset += tile_x0_idx * tile_x0_size;
    dst_offset += tile_x1_idx * tile_x1_size * full_x0_size;
    dst_offset *= prec;
    // Initiate transfer
    return snrt_dma_start_2d(dst + dst_offset,     // dst
                             src,                  // src
                             tile_x0_size * prec,  // size
                             full_x0_size * prec,  // dst_stride
                             tile_x0_size * prec,  // src_stride
                             tile_x1_size          // repeat
    );
}
