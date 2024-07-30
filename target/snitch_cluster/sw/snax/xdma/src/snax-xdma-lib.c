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

int32_t xdma_memcpy_nd(uint8_t* src, uint8_t* dst, uint32_t dim_src,
                       uint32_t dim_dst, uint32_t* stride_src,
                       uint32_t* stride_dst, uint32_t* bound_src,
                       uint32_t* bound_dst, uint32_t byte_strobe) {
    csrw_ss(XDMA_SRC_ADDR_PTR_LSB, (uint32_t)(uint64_t)src);
    csrw_ss(XDMA_SRC_ADDR_PTR_MSB, (uint32_t)((uint64_t)src >> 32));

    csrw_ss(XDMA_DST_ADDR_PTR_LSB, (uint32_t)(uint64_t)dst);
    csrw_ss(XDMA_DST_ADDR_PTR_MSB, (uint32_t)((uint64_t)dst >> 32));
    // Rule check
    // The enabled spatial bound for input should be equal to the enabled
    // spatial bound for output
    if (bound_src[0] > XDMA_SPATIAL_CHAN) {
        XDMA_DEBUG_PRINT(
            "Innermost bound at src is larger than the # of channels\n");
        return -1;
    }

    // The innermost bound should be smaller than / equal to the # of channels
    if (bound_dst[0] > XDMA_SPATIAL_CHAN) {
        XDMA_DEBUG_PRINT(
            "Innermost bound at dst is larger than the # of channels\n");
        return -2;
    }

    // Src size and dst size should be equal
    uint32_t src_size = 1;
    for (uint32_t i = 1; i < dim_src - 1; i++) {
        src_size *= bound_src[i];
    }
    uint32_t dst_size = 1;
    for (uint32_t i = 1; i < dim_dst - 1; i++) {
        dst_size *= bound_dst[i];
    }
    if (src_size != dst_size) {
        XDMA_DEBUG_PRINT("src loop and dst loop is not equal\n");
        return -3;
    }

    // Dimension 0 to n at src
    for (uint32_t i = 0; i < dim_src; i++) {
        if (i >= XDMA_SRC_DIM) {
            XDMA_DEBUG_PRINT("Source dimension is too high for xdma\n");
            return -4;
        }
        csrw_ss(XDMA_SRC_BOUND_PTR + i, bound_src[i]);
        csrw_ss(XDMA_SRC_STRIDE_PTR + i, stride_src[i]);
    }
    // Dimension n to MAX at src
    for (uint32_t i = dim_src; i < XDMA_SRC_DIM; i++) {
        csrw_ss(XDMA_SRC_BOUND_PTR + i, 1);
        csrw_ss(XDMA_SRC_STRIDE_PTR + i, 0);
    }

    // Dimension 0 to n at dst
    for (uint32_t i = 0; i < dim_dst; i++) {
        if (i >= XDMA_DST_DIM) {
            XDMA_DEBUG_PRINT("Destination dimension is too high for xdma\n");
            return -4;
        }
        csrw_ss(XDMA_DST_BOUND_PTR + i, bound_dst[i]);
        csrw_ss(XDMA_DST_STRIDE_PTR + i, stride_dst[i]);
    }
    // Dimension n to MAX at dst
    for (uint32_t i = dim_dst; i < XDMA_DST_DIM; i++) {
        csrw_ss(XDMA_DST_BOUND_PTR + i, 1);
        csrw_ss(XDMA_DST_STRIDE_PTR + i, 0);
    }
    // Byte strb at dst
    csrw_ss(XDMA_DST_STRB_PTR, byte_strobe);
    return 0;
}

int32_t xdma_memcpy_1d(uint8_t* src, uint8_t* dst, uint32_t size) {
    if (size % XDMA_WIDTH != 0) {
        XDMA_DEBUG_PRINT("Size is not multiple of XDMA_WIDTH\n");
        return -1;
    }
    uint32_t stride[2] = {XDMA_WIDTH / XDMA_SPATIAL_CHAN, XDMA_WIDTH};
    uint32_t bound[2] = {XDMA_SPATIAL_CHAN, size / XDMA_WIDTH};
    return xdma_memcpy_nd(src, dst, 2, 2, stride, stride, bound, bound, 0xff);
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
