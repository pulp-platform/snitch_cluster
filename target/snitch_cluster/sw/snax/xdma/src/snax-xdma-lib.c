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

int32_t xdma_memcpy_nd(uint8_t* src, uint8_t* dst, uint32_t unit_size_src,
                       uint32_t unit_size_dst, uint32_t dim_src,
                       uint32_t dim_dst, uint32_t* stride_src,
                       uint32_t* stride_dst, uint32_t* bound_src,
                       uint32_t* bound_dst) {
    csrw_ss(XDMA_SRC_ADDR_PTR_LSB, (uint32_t)(uint64_t)src);
    csrw_ss(XDMA_SRC_ADDR_PTR_MSB, (uint32_t)((uint64_t)src >> 32));

    csrw_ss(XDMA_DST_ADDR_PTR_LSB, (uint32_t)(uint64_t)dst);
    csrw_ss(XDMA_DST_ADDR_PTR_MSB, (uint32_t)((uint64_t)dst >> 32));
    // Rule check
    // unit size only support 8 bytes or n * 64 bytes
    XDMA_DEBUG_PRINT("unit size src: %d\n", unit_size_src);
    XDMA_DEBUG_PRINT("unit size dst: %d\n", unit_size_dst);

    if ((unit_size_src % 64 != 0) && (unit_size_src != 8)) {
        XDMA_DEBUG_PRINT("unit size src error\n");
        return -1;
    }
    if ((unit_size_dst % 64 != 0) && (unit_size_dst != 8)) {
        XDMA_DEBUG_PRINT("unit size dst error\n");
        return -2;
    }
    // Src size and dst size should be equal
    uint32_t src_size = unit_size_src;
    for (uint32_t i = 0; i < dim_src - 1; i++) {
        src_size *= bound_src[i];
    }
    uint32_t dst_size = unit_size_dst;
    for (uint32_t i = 0; i < dim_dst - 1; i++) {
        dst_size *= bound_dst[i];
    }
    if (src_size != dst_size) {
        XDMA_DEBUG_PRINT("src size and dst size not equal\n");
        return -3;
    }

    // Dimension 1 at src
    uint32_t i = 0;
    if (unit_size_src % 64 == 0) {
        csrw_ss(XDMA_SRC_STRIDE_PTR + i, 8);
        csrw_ss(XDMA_SRC_BOUND_PTR + i, unit_size_src >> 3);
        i++;
    }
    // Dimension 2 to n at src
    for (uint32_t j = 0; j < dim_src - 1; j++) {
        if (i + j >= XDMA_SRC_DIM) {
            XDMA_DEBUG_PRINT("Source dimension is too high for xdma\n");
            return -4;
        }
        csrw_ss(XDMA_SRC_BOUND_PTR + i + j, bound_src[j]);
        csrw_ss(XDMA_SRC_STRIDE_PTR + i + j, stride_src[j]);
    }
    // Dimension n to MAX at src
    for (uint32_t j = dim_src - 1; (i + j) < XDMA_SRC_DIM; j++) {
        csrw_ss(XDMA_SRC_BOUND_PTR + i + j, 1);
        csrw_ss(XDMA_SRC_STRIDE_PTR + i + j, 0);
    }

    // Dimension 1 at dst
    i = 0;
    if (unit_size_dst % 64 == 0) {
        csrw_ss(XDMA_DST_STRIDE_PTR + i, 8);
        csrw_ss(XDMA_DST_BOUND_PTR + i, unit_size_dst >> 3);
        i++;
    }
    // Dimension 2 to n at dst
    for (uint32_t j = 0; j < dim_dst - 1; j++) {
        if (i + j >= XDMA_DST_DIM) {
            XDMA_DEBUG_PRINT("Destination dimension is too high for xdma\n");
            return -5;
        }
        csrw_ss(XDMA_DST_BOUND_PTR + i + j, bound_dst[j]);
        csrw_ss(XDMA_DST_STRIDE_PTR + i + j, stride_dst[j]);
    }
    // Dimension n to MAX at dst
    for (uint32_t j = dim_dst - 1; (i + j) < XDMA_DST_DIM; j++) {
        csrw_ss(XDMA_DST_BOUND_PTR + i + j, 1);
        csrw_ss(XDMA_DST_STRIDE_PTR + i + j, 0);
    }
    return 0;
}

int32_t xdma_memcpy_1d(uint8_t* src, uint8_t* dst, uint32_t size) {
    return xdma_memcpy_nd(src, dst, size, size, 1, 1, (uint32_t*)NULL,
                          (uint32_t*)NULL, (uint32_t*)NULL, (uint32_t*)NULL);
}

// xdma extension interface
int32_t xdma_enable_src_ext(uint8_t ext, uint32_t* csr_value) {
    if (ext >= XDMA_SRC_EXT_NUM) {
        return -1;
    }
    uint8_t custom_csr_list[XDMA_SRC_EXT_NUM] = XDMA_SRC_EXT_CUSTOM_CSR_NUM;
    uint32_t csr_offset = XDMA_SRC_EXT_CSR_PTR;
    for (uint8_t i = 0; i < ext; i++) {
        csr_offset += custom_csr_list[i] + 1;
    }

    // Not bypass the xdma extension -> set the first CSR to 0
    csrw_ss(csr_offset, 0);
    csr_offset++;
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
        csr_offset += custom_csr_list[i] + 1;
    }

    // Not bypass the xdma extension -> set the first CSR to 0
    csrw_ss(csr_offset, 0);
    csr_offset++;
    for (uint8_t i = 0; i < custom_csr_list[ext]; i++) {
        csrw_ss(csr_offset + i, csr_value[i]);
    }
    return 0;
}

int32_t xdma_disable_src_ext(uint8_t ext) {
    if (ext >= XDMA_SRC_EXT_NUM) {
        return -1;
    }
    uint8_t custom_csr_list[XDMA_SRC_EXT_NUM] = XDMA_SRC_EXT_CUSTOM_CSR_NUM;
    uint32_t csr_offset = XDMA_SRC_EXT_CSR_PTR;
    for (uint8_t i = 0; i < ext; i++) {
        csr_offset += custom_csr_list[i] + 1;
    }

    // Bypass the xdma extension -> set the first CSR to 1
    csrw_ss(csr_offset, 1);
    return 0;
}

int32_t xdma_disable_dst_ext(uint8_t ext) {
    if (ext >= XDMA_DST_EXT_NUM) {
        return -1;
    }
    uint8_t custom_csr_list[XDMA_DST_EXT_NUM] = XDMA_DST_EXT_CUSTOM_CSR_NUM;
    uint32_t csr_offset = XDMA_DST_EXT_CSR_PTR;
    for (uint8_t i = 0; i < ext; i++) {
        csr_offset += custom_csr_list[i] + 1;
    }

    // Bypass the xdma extension -> set the first CSR to 1
    csrw_ss(csr_offset, 1);
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
