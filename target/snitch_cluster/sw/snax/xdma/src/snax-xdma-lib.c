// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Yunhao Deng <yunhao.deng@kuleuven.be>

#include "snax-xdma-lib.h"
#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"

#define XDMA_DEBUG
#ifdef XDMA_DEBUG
#define XDMA_DEBUG_PRINT(...) printf(__VA_ARGS__)
#else
#define XDMA_DEBUG_PRINT(...)
#endif

int32_t xdma_memcpy_nd(uint8_t* src, uint8_t* dst, uint32_t* spatial_stride_src,
                       uint32_t* spatial_stride_dst, uint32_t temp_dim_src,
                       uint32_t* temp_stride_src, uint32_t* temp_bound_src,
                       uint32_t temp_dim_dst, uint32_t* temp_stride_dst,
                       uint32_t* temp_bound_dst, uint32_t enabled_chan_src,
                       uint32_t enabled_chan_dst, uint32_t enabled_byte_dst) {
    csrw_ss(XDMA_SRC_ADDR_PTR_LSB, (uint32_t)(uint64_t)src);
    csrw_ss(XDMA_SRC_ADDR_PTR_MSB, (uint32_t)((uint64_t)src >> 32));

    csrw_ss(XDMA_DST_ADDR_PTR_LSB, (uint32_t)(uint64_t)dst);
    csrw_ss(XDMA_DST_ADDR_PTR_MSB, (uint32_t)((uint64_t)dst >> 32));

    for (uint32_t i = 1; i < XDMA_MAX_DST_COUNT; i++) {
        csrw_ss(XDMA_DST_ADDR_PTR_LSB + i * 2, 0);
        csrw_ss(XDMA_DST_ADDR_PTR_MSB + i * 2, 0);
    }

    // Rule check
    // The enabled spatial bound for input should be equal to the enabled
    // Src frame count and dst frame count should be equal
    uint32_t src_size = 1;
    if (temp_dim_src > 0) {
        for (uint32_t i = 0; i < temp_dim_src; i++) {
            src_size *= temp_bound_src[i];
        }
    }
    uint32_t dst_size = 1;
    if (temp_dim_dst > 0) {
        for (uint32_t i = 0; i < temp_dim_dst; i++) {
            dst_size *= temp_bound_dst[i];
        }
    }
    if (src_size != dst_size) {
        XDMA_DEBUG_PRINT("src loop and dst loop is not equal\n");
        // return -3;
    }
    // Spatial Stride 0 to XDMA_SRC_SPATIAL_DIM at src
    for (uint32_t i = 0; i < XDMA_SRC_SPATIAL_DIM; i++) {
        csrw_ss(XDMA_SRC_SPATIAL_STRIDE_PTR + i, spatial_stride_src[i]);
    }
    // Spatial Stride 0 to XDMA_DST_SPATIAL_DIM at dst
    for (uint32_t i = 0; i < XDMA_DST_SPATIAL_DIM; i++) {
        csrw_ss(XDMA_DST_SPATIAL_STRIDE_PTR + i, spatial_stride_dst[i]);
    }
    // Temporal Dimension 0 to n at src
    for (uint32_t i = 0; i < temp_dim_src; i++) {
        if (i >= XDMA_SRC_TEMP_DIM) {
            XDMA_DEBUG_PRINT("Source dimension is too high for xdma\n");
            return -4;
        }
        csrw_ss(XDMA_SRC_TEMP_BOUND_PTR + i, temp_bound_src[i]);
        csrw_ss(XDMA_SRC_TEMP_STRIDE_PTR + i, temp_stride_src[i]);
    }
    // Dimension n to MAX at src
    for (uint32_t i = temp_dim_src; i < XDMA_SRC_TEMP_DIM; i++) {
        csrw_ss(XDMA_SRC_TEMP_BOUND_PTR + i, 1);
        csrw_ss(XDMA_SRC_TEMP_STRIDE_PTR + i, 0);
    }
    // Temporal Dimension 0 to n at dst
    for (uint32_t i = 0; i < temp_dim_dst; i++) {
        if (i >= XDMA_DST_TEMP_DIM) {
            XDMA_DEBUG_PRINT("Destination dimension is too high for xdma\n");
            return -4;
        }
        csrw_ss(XDMA_DST_TEMP_BOUND_PTR + i, temp_bound_dst[i]);
        csrw_ss(XDMA_DST_TEMP_STRIDE_PTR + i, temp_stride_dst[i]);
    }
    // Dimension n to MAX at dst
    for (uint32_t i = temp_dim_dst; i < XDMA_DST_TEMP_DIM; i++) {
        csrw_ss(XDMA_DST_TEMP_BOUND_PTR + i, 1);
        csrw_ss(XDMA_DST_TEMP_STRIDE_PTR + i, 0);
    }
    // Enabled channel at src
    csrw_ss(XDMA_SRC_ENABLED_CHAN_PTR, enabled_chan_src);
    // Enabled channel at dst
    csrw_ss(XDMA_DST_ENABLED_CHAN_PTR, enabled_chan_dst);
    // Enabled byte at dst
    csrw_ss(XDMA_DST_ENABLED_BYTE_PTR, enabled_byte_dst);
    return 0;
}

int32_t xdma_memcpy_1d(uint8_t* src, uint8_t* dst, uint32_t size) {
    if (size % XDMA_WIDTH != 0) {
        XDMA_DEBUG_PRINT("Size is not multiple of XDMA_WIDTH\n");
        return -1;
    }
    uint32_t spatial_stride[1] = {XDMA_WIDTH / XDMA_SPATIAL_CHAN};
    uint32_t temporal_stride[1] = {XDMA_WIDTH};
    uint32_t temporal_bound[1] = {size / XDMA_WIDTH};
    uint32_t bound[2] = {XDMA_SPATIAL_CHAN, size / XDMA_WIDTH};
    return xdma_memcpy_nd(src, dst, spatial_stride, spatial_stride, 2,
                          temporal_stride, temporal_bound, 2, temporal_stride,
                          temporal_bound, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);
}

// xdma extension interface
int32_t xdma_enable_src_ext(uint8_t ext, uint32_t* csr_value) {
    if (ext >= XDMA_SRC_EXT_NUM) {
        return -1;
    }
    uint8_t custom_csr_list[XDMA_SRC_EXT_NUM] = XDMA_SRC_EXT_CUSTOM_CSR_NUM;
    uint32_t csr_offset = XDMA_SRC_EXT_CSR_PTR;
    for (uint8_t i = 0; i < ext; i++) {
        csr_offset += custom_csr_list[i];
    }

    // Not bypass the xdma extension -> set the corresponding CSR bit to 0
    csrw_ss(XDMA_SRC_BYPASS_PTR, csrr_ss(XDMA_SRC_BYPASS_PTR) & ~(1 << ext));

    for (uint8_t i = 0; i < custom_csr_list[ext]; i++) {
        csrw_ss(csr_offset + i, csr_value[i]);
    }
    return 0;
}
int32_t xdma_enable_dst_ext(uint8_t ext, uint32_t* csr_value) {
    if (ext >= XDMA_DST_EXT_NUM) {
        return -1;
    }
    uint8_t custom_csr_list[XDMA_DST_EXT_NUM] = XDMA_DST_EXT_CUSTOM_CSR_NUM;
    uint32_t csr_offset = XDMA_DST_EXT_CSR_PTR;
    for (uint8_t i = 0; i < ext; i++) {
        csr_offset += custom_csr_list[i];
    }

    // Not bypass the xdma extension -> set the corresponding CSR bit to 0
    csrw_ss(XDMA_DST_BYPASS_PTR, csrr_ss(XDMA_DST_BYPASS_PTR) & ~(1 << ext));
    for (uint8_t i = 0; i < custom_csr_list[ext]; i++) {
        csrw_ss(csr_offset + i, csr_value[i]);
    }
    return 0;
}

int32_t xdma_disable_src_ext(uint8_t ext) {
    if (ext >= XDMA_SRC_EXT_NUM) {
        return 0;
    }
    // Bypass the xdma extension -> set the corresponding CSR bit to 1
    csrw_ss(XDMA_SRC_BYPASS_PTR, csrr_ss(XDMA_SRC_BYPASS_PTR) | (1 << ext));
    return 0;
}

int32_t xdma_disable_dst_ext(uint8_t ext) {
    if (ext >= XDMA_DST_EXT_NUM) {
        return 0;
    }
    // Bypass the xdma extension -> set the corresponding CSR bit to 1
    csrw_ss(XDMA_DST_BYPASS_PTR, csrr_ss(XDMA_DST_BYPASS_PTR) | (1 << ext));
    return 0;
}

// Start xdma
uint32_t xdma_start() {
    int ret = csrr_ss(XDMA_COMMIT_TASK_PTR);
    csrw_ss(XDMA_START_PTR, 1);
    while (csrr_ss(XDMA_COMMIT_TASK_PTR) == ret) {
        // Wait for xdma to start
    }
    return csrr_ss(XDMA_COMMIT_TASK_PTR);
}

// Check if xdma is finished
bool xdma_is_finished(uint32_t task_id) {
    return csrr_ss(XDMA_FINISH_TASK_PTR) >= task_id;
}

void xdma_wait(uint32_t task_id) {
    while (!xdma_is_finished(task_id)) {
        // Wait for xdma to finish
    }
}
