// Copyright 2025 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include <stdbool.h>

#include "snrt.h"
#include "stdint.h"
#include "streamer_csr_addr_map.h"

#pragma once

// GeMM CSR = 4
#define GEMMX_CSR_ADDR_BASE (STREAMER_PERFORMANCE_COUNTER_CSR + 1)
#define T_BOUND_K (GEMMX_CSR_ADDR_BASE)
#define T_BOUND_N (T_BOUND_K + 1)
#define T_BOUND_M (T_BOUND_N + 1)

#define SUBTRACTIONS (T_BOUND_M + 1)

#define ARRAY_SHAPE_CFG (SUBTRACTIONS + 1)
#define DATA_TYPE_CFG (ARRAY_SHAPE_CFG + 1)

// GEMMX CSR
#define GEMMX_START (DATA_TYPE_CFG + 1)

// GeMMX read-only CSR
#define GEMMX_BUSY (GEMMX_START + 1)
#define GEMMX_PERFORMANCE_COUNTER (GEMMX_BUSY + 1)

// Pack two subtraction values to one CSR
int32_t gen_subtraction_config(int8_t subtraction_a, int8_t subtraction_b);

void set_versacore_streamer_csr(
    int32_t delta_local_a, int32_t* Aslstride, int32_t* Atlbound,
    int32_t* Atlstride, int32_t set_addr_remap_index_A, int32_t transpose_A,
    int32_t* channel_en_A,

    int32_t delta_local_b, int32_t* Bslstride, int32_t* Btlbound,
    int32_t* Btlstride, int32_t set_addr_remap_index_B, int32_t transpose_B,
    int32_t* channel_en_B,

    int32_t delta_local_c, int32_t* Cslstride, int32_t* Ctlbound,
    int32_t* Ctlstride, int32_t set_addr_remap_index_C, int32_t* channel_en_C,
    int32_t broadcast_C,

    int32_t delta_local_d32, int32_t* D32slstride, int32_t* D32tlbound,
    int32_t* D32tlstride, int32_t set_addr_remap_index_D32,
    int32_t* channel_en_D);

// Set CSR to start STREAMER
inline void set_versacore_streamer_start() { csrw_ss(STREAMER_START_CSR, 1); }

// Set GEMM configuration CSR
void set_versacore_csr(uint32_t tempLoop0, uint32_t tempLoop1,
                       uint32_t tempLoop2, uint32_t subtractions,
                       uint32_t array_shape, uint32_t data_type);

// Set CSR to start GEMM
inline void set_versacore_start() { csrw_ss(GEMMX_START, 1); }

// Poll until Streamer and GEMM accelerator finish
void wait_versacore_and_streamer();

void wait_versacore();

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_versacore_streamer_perf_counter();

// Read performance counter of GEMM, a read-only CSR
uint32_t read_versacore_perf_counter();

// Check the result of GEMMX
uint32_t check_versacore_result_D32(int8_t* output, int8_t* output_golden,
                                    int32_t data_length,
                                    bool banked_data_layout);
