// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

extern void snrt_dma_enable_mcast(uint32_t mask);

extern void snrt_dma_disable_mcast();

extern void snrt_dma_wait_all_channels(uint32_t num_channels);

extern void snrt_dma_start_tracking();

extern void snrt_dma_stop_tracking();

extern void snrt_dma_memset(void *ptr, uint8_t value, uint32_t len);

extern snrt_dma_txid_t snrt_dma_load_1d_tile(void *dst, void *src,
                                             size_t tile_idx, size_t tile_size,
                                             uint32_t prec);

extern snrt_dma_txid_t snrt_dma_load_1d_tile_mcast(void *dst, void *src,
                                                   size_t tile_idx,
                                                   size_t tile_size,
                                                   uint32_t prec);

extern snrt_dma_txid_t snrt_dma_1d_to_2d(volatile void *dst, volatile void *src,
                                         size_t size, size_t row_size,
                                         size_t stride);

extern snrt_dma_txid_t snrt_dma_2d_to_1d(volatile void *dst, volatile void *src,
                                         size_t size, size_t row_size,
                                         size_t stride);

extern snrt_dma_txid_t snrt_dma_store_1d_tile(void *dst, void *src,
                                              size_t tile_idx, size_t tile_size,
                                              uint32_t prec);

extern snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld);

extern snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec);

extern snrt_dma_txid_t snrt_dma_load_2d_tile_mcast(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld, uint32_t mask);

extern snrt_dma_txid_t snrt_dma_load_2d_tile_mcast(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, uint32_t mask);

extern snrt_dma_txid_t snrt_dma_load_2d_tile_in_banks(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t num_banks);

extern snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t tile_ld);

extern snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec);

extern snrt_dma_txid_t snrt_dma_store_2d_tile_from_banks(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec, size_t num_banks);
