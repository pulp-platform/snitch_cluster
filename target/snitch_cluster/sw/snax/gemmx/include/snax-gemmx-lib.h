// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"
#include "streamer_csr_addr_map.h"

#pragma once

#define GEMMX_CSR_ADDR_BASE (STREAMER_PERFORMANCE_COUNTER_CSR + 1)
#define T_BOUND_K (GEMMX_CSR_ADDR_BASE)
#define T_BOUND_N (T_BOUND_K + 1)
#define T_BOUND_M (T_BOUND_N + 1)

#define SUBTRACTIONS (T_BOUND_M + 1)

#define SIMD_CSR0 (SUBTRACTIONS + 1)
#define SIMD_CSR1 (SIMD_CSR0 + 1)

#define SIMD_SHARED_BITPACKED_SHIFT0 (SIMD_CSR1 + 1)
#define SIMD_SHARED_BITPACKED_SHIFT1 (SIMD_SHARED_BITPACKED_SHIFT0 + 1)

#define SIMD_SHARED_MULTIPLIER0 (SIMD_SHARED_BITPACKED_SHIFT1 + 1)
#define SIMD_SHARED_MULTIPLIER1 (SIMD_SHARED_MULTIPLIER0 + 1)
#define SIMD_SHARED_MULTIPLIER2 (SIMD_SHARED_MULTIPLIER1 + 1)
#define SIMD_SHARED_MULTIPLIER3 (SIMD_SHARED_MULTIPLIER2 + 1)
#define SIMD_SHARED_MULTIPLIER4 (SIMD_SHARED_MULTIPLIER3 + 1)
#define SIMD_SHARED_MULTIPLIER5 (SIMD_SHARED_MULTIPLIER4 + 1)
#define SIMD_SHARED_MULTIPLIER6 (SIMD_SHARED_MULTIPLIER5 + 1)
#define SIMD_SHARED_MULTIPLIER7 (SIMD_SHARED_MULTIPLIER6 + 1)

#define TEMPORAL_LOOP_BOUND (SIMD_SHARED_MULTIPLIER7 + 1)
#define BYPASS_SIMD (TEMPORAL_LOOP_BOUND + 1)

#define GEMMX_START (BYPASS_SIMD + 1)
#define GEMMX_BUSY (GEMMX_START + 1)
#define GEMMX_PERFORMANCE_COUNTER (GEMMX_BUSY + 1)

// Pack matrix size setting to one CSR
int32_t gen_size_config(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N);

// Pack two subtraction values to one CSR
int32_t gen_subtraction_config(int8_t subtraction_a, int8_t subtraction_b);

// generate the configuration for CSR0
int32_t gen_csr0_config(uint8_t input_zp_i, uint8_t output_zp_i,
                        uint8_t max_int_i, uint8_t min_int_i);

// generate the configuration for CSR1
int32_t gen_csr1_config(bool double_round_i);

// Set STREAMER configuration CSR
void set_gemmx_streamer_csr(
    int Aslstride0, int Aslstride1, int Atlbound0, int Atlstride0,
    int Atlbound1, int Atlstride1, int Atlbound2, int Atlstride2, int Atlbound3,
    int Atlstride3, int Atlbound4, int Atlstride4, int Atlbound5,
    int Atlstride5, int set_addr_remap_index_A,

    int Bslstride0, int Bslstride1, int Btlbound0, int Btlstride0,
    int Btlbound1, int Btlstride1, int Btlbound2, int Btlstride2,
    int set_addr_remap_index_B,

    int D8slstride0, int D8slstride1, int D8tlbound0, int D8tlstride0,
    int D8tlbound1, int D8tlstride1, int D8tlbound2, int D8tlstride2,
    int set_addr_remap_index_D8,

    int Cslstride0, int Cslstride1, int Ctlbound0, int Ctlstride0,
    int Ctlbound1, int Ctlstride1, int Ctlbound2, int Ctlstride2,
    int set_addr_remap_index_C,

    int D32slstride0, int D32slstride1, int D32tlbound0, int D32tlstride0,
    int D32tlbound1, int D32tlstride1, int D32tlbound2, int D32tlstride2,
    int set_addr_remap_index_D32,

    int delta_local_a, int delta_local_b, int delta_local_d8, int delta_local_c,
    int delta_local_d32, int bypassSIMD, int32_t transpose_A,
    int32_t transpose_B, int32_t channel_en_C, int32_t broadcast_C);

// Set CSR to start STREAMER
inline void set_gemmx_streamer_start() { csrw_ss(STREAMER_START_CSR, 1); }

// Set GEMM configuration CSR
void set_gemmx_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                   int subtractions, uint32_t csr0, uint32_t csr1,
                   int shared_bitpacked_shift0, int shared_bitpacked_shift1,
                   int shared_multiplier0, int shared_multiplier1,
                   int shared_multiplier2, int shared_multiplier3,
                   int shared_multiplier4, int shared_multiplier5,
                   int shared_multiplier6, int shared_multiplier7,
                   uint32_t temporal_loop_bound, uint32_t bypassSIMD);

// Set CSR to start GEMM
inline void set_gemmx_start() { csrw_ss(GEMMX_START, 1); }

// Poll until Streamer and GEMM accelerator finish
void wait_gemmx_and_streamer();

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_gemmx_streamer_perf_counter();

// Read performance counter of GEMM, a read-only CSR
uint32_t read_gemmx_perf_counter();

// Check the result of the implicit im2col convolution
uint32_t check_gemmx_result_D8(int8_t* output, int8_t* output_golden,
                               int32_t Batch, int32_t M, int32_t N,
                               bool banked_data_layout);

uint32_t check_gemmx_result_D32(int32_t* output, int32_t* output_golden,
                                int32_t Batch, int32_t M, int32_t N,
                                bool banked_data_layout);
