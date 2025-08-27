// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

/**
 * @file
 * @brief This file provides functions to program the Snitch DMA.
 */

#pragma once

#include <math.h>

/// A DMA transfer identifier.
typedef uint32_t snrt_dma_txid_t;

/**
 * @brief Start an asynchronous 1D DMA transfer with 64-bit wide pointers on a
 *        specific DMA channel.
 * @param dst The destination address.
 * @param src The source address.
 * @param size The size of the transfer in bytes.
 * @param channel The index of the channel.
 * @return The DMA transfer ID.
 * @note The function passes the @p channel argument as an immediate,
 *       thus this must be known at compile time. As a consequence, the
 *       function must use internal linkage (`static` keyword) and must be
 *       always inlined. This is true also for all functions invoking this
 *       function, and passing down an argument to @p channel.
 */
static inline uint32_t snrt_dma_start_1d(uint64_t dst, uint64_t src,
                                         size_t size,
                                         const uint32_t channel = 0) {
    uint32_t dst_lo = dst & 0xFFFFFFFF;
    uint32_t dst_hi = dst >> 32;
    uint32_t src_lo = src & 0xFFFFFFFF;
    uint32_t src_hi = src >> 32;
    uint32_t txid;

    asm volatile(
        "dmsrc %[src_lo], %[src_hi] \n"
        "dmdst %[dst_lo], %[dst_hi] \n"
        "dmcpyi %[txid], %[size], (%[channel] << 2) | 0b00 \n"
        : [ txid ] "=r"(txid)
        : [ src_lo ] "r"(src_lo), [ src_hi ] "r"(src_hi),
          [ dst_lo ] "r"(dst_lo), [ dst_hi ] "r"(dst_hi), [ size ] "r"(size),
          [ channel ] "i"(channel));

    return txid;
}

/**
 * @brief Start an asynchronous 1D DMA transfer using native-size pointers.
 *
 * This is a convenience overload of snrt_dma_start_1d(uint64_t, uint64_t, size_t, uint32_t)
 * using `void*` pointers.
 */
static inline uint32_t snrt_dma_start_1d(volatile void *dst, volatile void *src,
                                         size_t size,
                                         const uint32_t channel = 0) {
    return snrt_dma_start_1d((uint64_t)dst, (uint64_t)src, size, channel);
}

/**
 * @brief Enable multicast for successive transfers.
 * @param mask Multicast mask applied to successive transfers.
 */
inline void snrt_dma_enable_mcast(uint32_t mask) {
    asm volatile("dmuser %[mask], zero \n" : : [ mask ] "r"(mask));
}

/**
 * @brief Disable multicast for successive transfers.
 * @details Resets the multicast mask to zero.
 */
inline void snrt_dma_disable_mcast() { asm volatile("dmuser zero, zero \n"); }

/**
 * @brief Start an asynchronous multicast 1D DMA transfer with 64-bit wide
 * pointers.
 * @param mask Multicast mask applied on the destination address.
 * @see snrt_dma_start_1d(uint64_t, uint64_t, size_t, uint32_t) for a
 *      description of the other parameters.
 */
static inline uint32_t snrt_dma_start_1d_mcast(uint64_t dst, uint64_t src,
                                               size_t size, uint32_t mask,
                                               const uint32_t channel = 0) {
    snrt_dma_enable_mcast(mask);
    uint32_t txid = snrt_dma_start_1d(dst, src, size, channel);
    snrt_dma_disable_mcast();
    return txid;
}

/**
 * @brief Start an asynchronous multicast 1D DMA transfer using native-size
 * pointers.
 *
 * This is a convenience overload of
 * snrt_dma_start_1d_mcast(uint64_t, uint64_t, size_t, uint32_t, uint32_t)
 * using `void*` pointers.
 */
static inline uint32_t snrt_dma_start_1d_mcast(volatile void *dst,
                                               volatile void *src, size_t size,
                                               uint32_t mask,
                                               const uint32_t channel = 0) {
    return snrt_dma_start_1d_mcast((uint64_t)dst, (uint64_t)src, size, mask,
                                   channel);
}

/**
 * @brief Start an asynchronous 2D DMA transfer with 64-bit wide pointers.
 * @param dst The destination address.
 * @param src The source address.
 * @param size The size of every 1D transfer within the 2D transfer in bytes.
 * @param dst_stride The offset between consecutive 1D transfers at the
 *                   destination, in bytes.
 * @param src_stride The offset between consecutive 1D transfers at the
 *                   source, in bytes.
 * @param repeat The number of 1D transfers composing the 2D transfer.
 * @param channel The index of the channel.
 * @return The DMA transfer ID.
 * @note The function passes the @p channel argument as an immediate,
 *       thus this must be known at compile time. As a consequence, the
 *       function must use internal linkage (`static` keyword) and must be
 *       always inlined. This is true also for all functions invoking this
 *       function, and passing down an argument to @p channel.
 */
static inline snrt_dma_txid_t snrt_dma_start_2d(uint64_t dst, uint64_t src,
                                                size_t size, size_t dst_stride,
                                                size_t src_stride,
                                                size_t repeat,
                                                const uint32_t channel = 0) {
    uint32_t dst_lo = dst & 0xFFFFFFFF;
    uint32_t dst_hi = dst >> 32;
    uint32_t src_lo = src & 0xFFFFFFFF;
    uint32_t src_hi = src >> 32;
    uint32_t txid;

    asm volatile(
        "dmsrc %[src_lo], %[src_hi] \n"
        "dmdst %[dst_lo], %[dst_hi] \n"
        "dmstr %[src_stride], %[dst_stride] \n"
        "dmrep %[repeat] \n"
        "dmcpyi %[txid], %[size], (%[channel] << 2) | 0b10 \n"
        : [ txid ] "=r"(txid)
        : [ src_lo ] "r"(src_lo), [ src_hi ] "r"(src_hi),
          [ dst_lo ] "r"(dst_lo), [ dst_hi ] "r"(dst_hi),
          [ dst_stride ] "r"(dst_stride), [ src_stride ] "r"(src_stride),
          [ repeat ] "r"(repeat), [ size ] "r"(size), [ channel ] "i"(channel));

    return txid;
}

/**
 * @brief Start an asynchronous 2D DMA transfer using native-size pointers.
 *
 * This is a convenience overload of
 * snrt_dma_start_2d(uint64_t, uint64_t, size_t, size_t, size_t, size_t, uint32_t)
 * using `void*` pointers.
 */
static inline uint32_t snrt_dma_start_2d(volatile void *dst, volatile void *src,
                                         size_t size, size_t dst_stride,
                                         size_t src_stride, size_t repeat,
                                         const uint32_t channel = 0) {
    return snrt_dma_start_2d((uint64_t)dst, (uint64_t)src, size, dst_stride,
                             src_stride, repeat, channel);
}

/**
 * @brief Start an asynchronous, multicast 2D DMA transfer with 64-bit wide
 * pointers.
 *
 * @param mask Multicast mask.
 *
 * @see snrt_dma_start_2d(uint64_t, uint64_t, size_t, size_t, size_t, size_t, uint32_t)
 *      for a description of the other parameters.
 */
static inline uint32_t snrt_dma_start_2d_mcast(uint64_t dst, uint64_t src,
                                               size_t size, size_t dst_stride,
                                               size_t src_stride, size_t repeat,
                                               uint32_t mask,
                                               const uint32_t channel = 0) {
    snrt_dma_enable_mcast(mask);
    uint32_t txid = snrt_dma_start_2d(dst, src, size, dst_stride, src_stride,
                                      repeat, channel);
    snrt_dma_disable_mcast();
    return txid;
}

/**
 * @brief Start an asynchronous, multicast 2D DMA transfer using native-size
 * pointers.
 *
 * This is a convenience overload of
 * snrt_dma_start_2d_mcast(uint64_t, uint64_t, size_t, size_t, size_t, size_t, uint32_t, uint32_t)
 * using `void*` pointers.
 */
static inline uint32_t snrt_dma_start_2d_mcast(volatile void *dst,
                                               volatile void *src, size_t size,
                                               size_t dst_stride,
                                               size_t src_stride, size_t repeat,
                                               uint32_t mask,
                                               const uint32_t channel = 0) {
    return snrt_dma_start_2d_mcast((uint64_t)dst, (uint64_t)src, size,
                                   dst_stride, src_stride, repeat, mask,
                                   channel);
}

/**
 * @brief Block until a DMA transfer finishes on a specific DMA channel.
 * @param txid The DMA transfer's ID.
 * @param channel The index of the channel.
 * @note The function passes the @p channel argument as an immediate,
 *       thus this must be known at compile time. As a consequence, the
 *       function must use internal linkage (`static` keyword) and must be
 *       always inlined. This is true also for all functions invoking this
 *       function, and passing down an argument to @p channel.
 */
static inline void snrt_dma_wait(snrt_dma_txid_t txid,
                                 const uint32_t channel = 0) {
    asm volatile(
        "1: \n"
        "dmstati t0, (%[channel] << 2) | 0 \n"
        "bltu t0, %[txid], 1b \n"
        :
        : [ txid ] "r"(txid), [ channel ] "i"(channel)
        : "t0");
}

/**
 * @brief Block until a specific DMA channel is idle.
 * @param channel The index of the channel.
 * @note The function passes the @p channel argument as an immediate,
 *       thus this must be known at compile time. As a consequence, the
 *       function must use internal linkage (`static` keyword) and must be
 *       always inlined. This is true also for all functions invoking this
 *       function, and passing down an argument to @p channel.
 */
static inline void snrt_dma_wait_all(const uint32_t channel = 0) {
    uint32_t busy;
    asm volatile(
        "1: \n"
        "dmstati %[busy], (%[channel] << 2) | 2 \n"
        "bne %[busy], zero, 1b \n"
        : [ busy ] "=r"(busy)
        : [ channel ] "i"(channel));
}

/**
 * @brief Block until the first @p num_channels channels are idle.
 * @param num_channels The number of channels to wait on.
 */
inline void snrt_dma_wait_all_channels(uint32_t num_channels) {
    for (int c = 0; c < num_channels; c++) {
        snrt_dma_wait_all(c);
    }
}

/**
 * @brief Start tracking of dma performance region. Does not have any
 * implications on the HW. Only injects a marker in the DMA traces that can be
 * analyzed.
 * @deprecated
 */
inline void snrt_dma_start_tracking() { asm volatile("dmstati zero, 0 \n"); }

/**
 * @brief Stop tracking of dma performance region. Does not have any
 * implications on the HW. Only injects a marker in the DMA traces that can be
 * analyzed.
 * @deprecated
 */
inline void snrt_dma_stop_tracking() { asm volatile("dmstati zero, 0 \n"); }

/**
 * @brief Fast memset function performed by DMA.
 * @param ptr Pointer to the start of the region.
 * @param value Value to set.
 * @param len Number of bytes, must be a multiple of the DMA bus width to use
 *            the DMA.
 */
inline void snrt_dma_memset(void *ptr, uint8_t value, uint32_t len) {
    // We set the first 64 bytes to the value, and then we use the DMA to copy
    // these into the remaining memory region. DMA is used only if len is
    // larger than 64 bytes, and an integer multiple of 64 bytes.
    size_t n_1d_transfers = len / 64;
    size_t use_dma = (len % 64) == 0 && len > 64;
    uint8_t *p = (uint8_t *)ptr;

    uint32_t nbytes = len < 64 || !use_dma ? len : 64;
    while (nbytes--) {
        *p++ = value;
    }

    if (use_dma) {
        snrt_dma_start_2d(ptr, ptr, 64, 64, 0, n_1d_transfers);
        snrt_dma_wait_all();
    }
}

/**
 * @brief Load a tile of a 1D array.
 * @param dst Pointer to the tile destination.
 * @param src Pointer to the source array.
 * @param tile_idx Index of the tile in the 1D array.
 * @param tile_size Number of elements within a tile of the 1D array.
 * @param prec Number of bytes of each element in the 1D array.
 */
inline snrt_dma_txid_t snrt_dma_load_1d_tile(volatile void *dst,
                                             volatile void *src,
                                             size_t tile_idx, size_t tile_size,
                                             uint32_t prec) {
    size_t tile_nbytes = tile_size * prec;
    return snrt_dma_start_1d(
        (uint64_t)dst, (uint64_t)src + tile_idx * tile_nbytes, tile_nbytes);
}

/**
 * @brief Load a tile of a 1D array.
 * @param dst Pointer to the tile destination.
 * @param src Pointer to the source array.
 * @param tile_idx Index of the tile in the 1D array.
 * @param tile_size Number of elements within a tile of the 1D array.
 * @param prec Number of bytes of each element in the 1D array.
 * @param mcast Multicast mask applied on the destination address.
 */
inline snrt_dma_txid_t snrt_dma_load_1d_tile_mcast(void *dst, void *src,
                                                   size_t tile_idx,
                                                   size_t tile_size,
                                                   uint32_t prec,
                                                   uint32_t mcast) {
    size_t tile_nbytes = tile_size * prec;
    return snrt_dma_start_1d_mcast((uintptr_t)dst,
                                   (uintptr_t)src + tile_idx * tile_nbytes,
                                   tile_nbytes, mcast);
}

/**
 * @brief Transfer and reshape a 1D array into a 2D array.
 * @param dst Pointer to the destination array.
 * @param src Pointer to the source array.
 * @param size Number of bytes to transfer.
 * @param row_size Size of a row in the 2D array, in bytes.
 * @param stride Stride between successive rows in the 2D array, in bytes.
 */
inline snrt_dma_txid_t snrt_dma_1d_to_2d(volatile void *dst, volatile void *src,
                                         size_t size, size_t row_size,
                                         size_t stride) {
    return snrt_dma_start_2d(dst, src, row_size, stride, row_size,
                             size / row_size);
}

/**
 * @brief Transfer and reshape a 2D array into a 1D array.
 * @param dst Pointer to the destination array.
 * @param src Pointer to the source array.
 * @param size Number of bytes to transfer.
 * @param row_size Size of a row in the 2D array, in bytes.
 * @param stride Stride between successive rows in the 2D array, in bytes.
 */
inline snrt_dma_txid_t snrt_dma_2d_to_1d(volatile void *dst, volatile void *src,
                                         size_t size, size_t row_size,
                                         size_t stride) {
    return snrt_dma_start_2d(dst, src, row_size, row_size, stride,
                             size / row_size);
}

/**
 * @brief Store a tile to a 1D array.
 * @param dst Pointer to the destination array.
 * @param src Pointer to the source tile.
 * @param tile_idx Index of the tile in the 1D array.
 * @param tile_size Number of elements within a tile of the 1D array.
 * @param prec Number of bytes of each element in the 1D array.
 */
inline snrt_dma_txid_t snrt_dma_store_1d_tile(void *dst, void *src,
                                              size_t tile_idx, size_t tile_size,
                                              uint32_t prec) {
    size_t tile_nbytes = tile_size * prec;
    return snrt_dma_start_1d((uint64_t)dst + tile_idx * tile_nbytes,
                             (uint64_t)src, tile_nbytes);
}

/**
 * @brief Load a 2D tile of a 2D array.
 * @param dst Pointer to the tile destination.
 * @param src Pointer to the source array.
 * @param tile_x1_idx Outermost coordinate of the tile in the 2D array.
 * @param tile_x0_idx Innermost coordinate of the tile in the 2D array.
 * @param tile_x1_size Number of elements in the outermost dimension of the
 *                     tile.
 * @param tile_x0_size Number of elements in the innermost dimension of the
 *                     tile.
 * @param full_x0_size Number of elements in the innermost dimension of the
 *                     array.
 * @param prec Number of bytes of each element in the 2D array.
 * @param tile_ld Leading dimension of the tile, in bytes.
 */
inline snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld) {
    size_t src_offset = 0;
    // Advance src array in x0 and x1 dimensions, and convert to byte offset
    src_offset += tile_x0_idx * tile_x0_size;
    src_offset += tile_x1_idx * tile_x1_size * full_x0_size;
    src_offset *= prec;
    // Initiate transfer
    return snrt_dma_start_2d((uint64_t)dst,               // dst
                             (uint64_t)src + src_offset,  // src
                             tile_x0_size * prec,         // size
                             tile_ld,                     // dst_stride
                             full_x0_size * prec,         // src_stride
                             tile_x1_size                 // repeat
    );
}

/**
 * @brief Load a 2D tile of a 2D array.
 *
 * The stride in the destination tile is assumed to be that of a 1D tile,
 * effectively. In other words, this is the same as snrt_dma_2d_to_1d().
 *
 * @see snrt_dma_load_2d_tile(void *, void *, size_t, size_t, size_t, size_t, size_t, uint32_t, size_t)
 *      for a detailed description of the parameters.
 */
inline snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec) {
    return snrt_dma_load_2d_tile(dst, src, tile_x1_idx, tile_x0_idx,
                                 tile_x1_size, tile_x0_size, full_x0_size, prec,
                                 tile_x0_size * prec);
}

/**
 * @brief Load a 2D tile of a 2D array using multicast.
 * @param mask Multicast mask.
 *
 * @see snrt_dma_load_2d_tile(void *, void *, size_t, size_t, size_t, size_t, size_t, uint32_t, size_t)
 *      for a description of the other parameters.
 */
inline snrt_dma_txid_t snrt_dma_load_2d_tile_mcast(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld, uint32_t mask) {
    size_t src_offset = 0;
    // Advance src array in x0 and x1 dimensions, and convert to byte offset
    src_offset += tile_x0_idx * tile_x0_size;
    src_offset += tile_x1_idx * tile_x1_size * full_x0_size;
    src_offset *= prec;
    // Initiate transfer
    return snrt_dma_start_2d_mcast((uint64_t)dst,               // dst
                                   (uint64_t)src + src_offset,  // src
                                   tile_x0_size * prec,         // size
                                   tile_ld,                     // dst_stride
                                   full_x0_size * prec,         // src_stride
                                   tile_x1_size,                // repeat
                                   mask                         // mask
    );
}

/**
 * @brief Load a 2D tile of a 2D array.
 *
 * The stride in the destination tile is assumed to be that of a 1D tile,
 * effectively. In other words, this is similar to snrt_dma_2d_to_1d().
 *
 * @see snrt_dma_load_2d_tile_mcast(void *, void *, size_t, size_t, size_t, size_t, size_t, uint32_t, size_t, uint32_t)
 *      for a detailed description of the parameters.
 */
inline snrt_dma_txid_t snrt_dma_load_2d_tile_mcast(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, uint32_t mask) {
    return snrt_dma_load_2d_tile_mcast(dst, src, tile_x1_idx, tile_x0_idx,
                                       tile_x1_size, tile_x0_size, full_x0_size,
                                       prec, tile_x0_size * prec, mask);
}

/**
 * @brief Load a 2D tile of a 2D array and reshape it to occupy a subset of
 *        TCDM banks.
 * @param dst Pointer to the tile destination.
 * @param src Pointer to the source array.
 * @param tile_x1_idx Outermost coordinate of the tile in the 2D array.
 * @param tile_x0_idx Innermost coordinate of the tile in the 2D array.
 * @param tile_x1_size Number of elements in the outermost dimension of the
 *                     tile.
 * @param tile_x0_size Number of elements in the innermost dimension of the
 *                     tile.
 * @param full_x0_size Number of elements in the innermost dimension of the
 *                     array.
 * @param prec Number of bytes of each element in the 2D array.
 * @param num_banks Number of banks to reshape the tile into.
 */
inline snrt_dma_txid_t snrt_dma_load_2d_tile_in_banks(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t num_banks) {
    // Calculate new tile size after reshaping the tile in the selected banks
    size_t tile_x0_size_in_banks = (num_banks * SNRT_TCDM_BANK_WIDTH) / prec;
    size_t tile_x1_size_in_banks =
        ceil((tile_x1_size * tile_x0_size) / (double)tile_x0_size_in_banks);
    size_t tile_ld = SNRT_TCDM_HYPERBANK_WIDTH;
    return snrt_dma_load_2d_tile(dst, src, tile_x1_idx, tile_x0_idx,
                                 tile_x1_size_in_banks, tile_x0_size_in_banks,
                                 full_x0_size, prec, tile_ld);
}

/**
 * @brief Store a 2D tile to a 2D array.
 * @param dst Pointer to the destination array.
 * @param src Pointer to the source tile.
 * @param tile_x1_idx Outermost coordinate of the tile in the 2D array.
 * @param tile_x0_idx Innermost coordinate of the tile in the 2D array.
 * @param tile_x1_size Number of elements in the outermost dimension of the
 *                     tile.
 * @param tile_x0_size Number of elements in the innermost dimension of the
 *                     tile.
 * @param full_x0_size Number of elements in the innermost dimension of the
 *                     array.
 * @param prec Number of bytes of each element in the 2D array.
 * @param tile_ld Leading dimension of the tile, in bytes.
 */
inline snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld) {
    size_t dst_offset = 0;
    // Advance dst array in x0 and x1 dimensions, and convert to byte offset
    dst_offset += tile_x0_idx * tile_x0_size;
    dst_offset += tile_x1_idx * tile_x1_size * full_x0_size;
    dst_offset *= prec;
    // Initiate transfer
    return snrt_dma_start_2d((uint64_t)dst + dst_offset,  // dst
                             (uint64_t)src,               // src
                             tile_x0_size * prec,         // size
                             full_x0_size * prec,         // dst_stride
                             tile_ld,                     // src_stride
                             tile_x1_size                 // repeat
    );
}

/**
 * @brief Store a 2D tile of a 2D array.
 *
 * @details The stride in the source tile is assumed to be that of a 1D tile,
 * effectively. In other words, this is the same as snrt_dma_1d_to_2d().
 *
 * @see snrt_dma_store_2d_tile(void *, void *, size_t, size_t, size_t, size_t, size_t, uint32_t, size_t)
 *      for a detailed description of the parameters.
 */
inline snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec) {
    return snrt_dma_store_2d_tile(dst, src, tile_x1_idx, tile_x0_idx,
                                  tile_x1_size, tile_x0_size, full_x0_size,
                                  prec, tile_x0_size * prec);
}

/**
 * @brief Store a 2D tile of a 2D array from a 1D layout occupying a subset of
 *        TCDM banks.
 * @param dst Pointer to the destination array.
 * @param src Pointer to the source tile.
 * @param tile_x1_idx Outermost coordinate of the tile in the 2D array.
 * @param tile_x0_idx Innermost coordinate of the tile in the 2D array.
 * @param tile_x1_size Number of elements in the outermost dimension of the
 *                     tile.
 * @param tile_x0_size Number of elements in the innermost dimension of the
 *                     tile.
 * @param full_x0_size Number of elements in the innermost dimension of the
 *                     array.
 * @param prec Number of bytes of each element in the 2D array.
 * @param num_banks Number of banks the tile is stored in.
 */
inline snrt_dma_txid_t snrt_dma_store_2d_tile_from_banks(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t num_banks) {
    // Calculate new tile size after reshaping the tile in the selected banks
    size_t tile_x0_size_in_banks = (num_banks * SNRT_TCDM_BANK_WIDTH) / prec;
    size_t tile_x1_size_in_banks =
        ceil((tile_x1_size * tile_x0_size) / (double)tile_x0_size_in_banks);
    size_t tile_ld = SNRT_TCDM_HYPERBANK_WIDTH;
    return snrt_dma_store_2d_tile(dst, src, tile_x1_idx, tile_x0_idx,
                                  tile_x1_size_in_banks, tile_x0_size_in_banks,
                                  full_x0_size, prec, tile_ld);
}
