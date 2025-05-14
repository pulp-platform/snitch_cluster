// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

extern snrt_dma_txid_t snrt_dma_start_1d_wideptr(uint64_t dst, uint64_t src,
                                                 size_t size);

extern snrt_dma_txid_t snrt_dma_start_1d(void *dst, const void *src,
                                         size_t size);

extern snrt_dma_txid_t snrt_dma_start_2d_wideptr(uint64_t dst, uint64_t src,
                                                 size_t size, size_t dst_stride,
                                                 size_t src_stride,
                                                 size_t repeat);

extern snrt_dma_txid_t snrt_dma_start_2d(void *dst, const void *src,
                                         size_t size, size_t dst_stride,
                                         size_t src_stride, size_t repeat);

extern snrt_dma_txid_t snrt_dma_start_1d_channel_wideptr(uint64_t dst,
                                                         uint64_t src,
                                                         size_t size,
                                                         uint32_t channel);

extern snrt_dma_txid_t snrt_dma_start_1d_channel(void *dst, const void *src,
                                                 size_t size, uint32_t channel);

extern snrt_dma_txid_t snrt_dma_start_2d_channel_wideptr(
    uint64_t dst, uint64_t src, size_t size, size_t dst_stride,
    size_t src_stride, size_t repeat, uint32_t channel);

extern snrt_dma_txid_t snrt_dma_start_2d_channel(void *dst, const void *src,
                                                 size_t size, size_t dst_stride,
                                                 size_t src_stride,
                                                 size_t repeat,
                                                 uint32_t channel);

extern void snrt_dma_wait(snrt_dma_txid_t tid);

extern void snrt_dma_wait_channel(snrt_dma_txid_t tid, uint32_t channel);

extern void snrt_dma_wait_all();

extern void snrt_dma_wait_all_channel(uint32_t channel);

extern void snrt_dma_wait_all_channels(uint32_t num_channels);

extern void snrt_dma_start_tracking();

extern void snrt_dma_stop_tracking();

extern void snrt_dma_memset(void *ptr, uint8_t value, uint32_t len);

extern snrt_dma_txid_t snrt_dma_load_1d_tile(void *dst, void *src,
                                             size_t tile_idx, size_t tile_size,
                                             uint32_t prec);

extern snrt_dma_txid_t snrt_dma_store_1d_tile(void *dst, void *src,
                                              size_t tile_idx, size_t tile_size,
                                              uint32_t prec);

extern snrt_dma_txid_t snrt_dma_load_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec);

extern snrt_dma_txid_t snrt_dma_store_2d_tile(
    void *dst, void *src, size_t tile_x1_idx, size_t tile_x0_idx,
    size_t tile_x1_size, size_t tile_x0_size, size_t full_x0_size,
    uint32_t prec);
