// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include <stdbool.h>
#include "simd_csr_addr_map.h"
#include "snrt.h"
#include "stdint.h"
#include "streamer_csr_addr_map.h"

#pragma once

#define GEMMX_CSR_ADDR_BASE (STREAMER_PERFORMANCE_COUNTER_CSR + 1)
// GeMM CSR = 4
#define T_BOUND_K (GEMMX_CSR_ADDR_BASE)
#define T_BOUND_N (T_BOUND_K + 1)
#define T_BOUND_M (T_BOUND_N + 1)

#define SUBTRACTIONS (T_BOUND_M + 1)

// GeMMX CSR
#define BYPASS_SIMD (TEMPORAL_LOOP_BOUND + 1)
#define GEMMX_START (BYPASS_SIMD + 1)

// GeMMX read-only CSR
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
void set_gemmx_streamer_csr(int32_t* Aslstride, int32_t* Atlbound,
                            int32_t* Atlstride, int32_t set_addr_remap_index_A,

                            int32_t* Bslstride, int32_t* Btlbound,
                            int32_t* Btlstride, int32_t set_addr_remap_index_B,

                            int32_t* D8slstride, int32_t* D8tlbound,
                            int32_t* D8tlstride,
                            int32_t set_addr_remap_index_D8,

                            int32_t* Cslstride, int32_t* Ctlbound,
                            int32_t* Ctlstride, int32_t set_addr_remap_index_C,

                            int32_t* D32slstride, int32_t* D32tlbound,
                            int32_t* D32tlstride,
                            int32_t set_addr_remap_index_D32,

                            int32_t delta_local_a, int32_t delta_local_b,
                            int32_t delta_local_d8, int32_t delta_local_c,
                            int32_t delta_local_d32, int32_t bypassSIMD,
                            int32_t transpose_A, int32_t transpose_B,
                            int32_t* channel_en_C, int32_t broadcast_C);

// Set CSR to start STREAMER
inline void set_gemmx_streamer_start() { csrw_ss(STREAMER_START_CSR, 1); }

// Set GEMM configuration CSR
void set_gemmx_csr(int32_t tempLoop0, int32_t tempLoop1, int32_t tempLoop2,
                   int32_t subtractions, uint32_t csr0, uint32_t csr1,
                   int32_t* shared_bitpacked_shift, int32_t* shared_multiplier,
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
