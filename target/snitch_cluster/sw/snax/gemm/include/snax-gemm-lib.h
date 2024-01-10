// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"

#pragma once

// Pack matrix size setting to one CSR
int32_t gen_size_config(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N);

// Pack two subtraction values to one CSR
int32_t gen_subtraction_config(int8_t subtraction_a, int8_t subtraction_b);

// Performance counter for GEMM busy cycles
uint32_t read_performance_counter();

// Golden model for base gemm
void base_gemm(uint8_t m, uint8_t k, uint8_t n, int8_t* A, int8_t* B,
               int8_t subtraction_a, int8_t subtraction_b, int32_t* C_cpu,
               bool new_batch);

// Golden model for batch gemm
void batch_gemm_cpu(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N, int8_t* A,
                    int8_t* B, int8_t subtraction_a, int8_t subtraction_b,
                    int32_t* C, uint32_t strideInnermostA,
                    uint32_t strideInnermostB, uint32_t strideInnermostC,
                    uint32_t ldA, uint32_t ldB, uint32_t ldC, uint32_t strideA,
                    uint32_t strideB, uint32_t strideC);

// Load input matrix data from L3 to TCDM
void load_input_data(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N,
                     int8_t* local_a, int8_t* local_b, int8_t* A, int8_t* B,
                     uint32_t strideInnermostA, uint32_t strideInnermostB,
                     uint32_t ldA, uint32_t ldB, uint32_t strideA,
                     uint32_t strideB);

// Set GEMM configuration CSR
void set_batch_gemm(uint32_t size_setting, int8_t* local_a, int8_t* local_b,
                    int32_t subtractions, int32_t* local_c,
                    uint32_t strideInnermostA, uint32_t strideInnermostB,
                    uint32_t strideInnermostC, uint32_t ldA, uint32_t ldB,
                    uint32_t ldC, uint32_t strideA, uint32_t strideB,
                    uint32_t strideC);

// Set CSR to start GEMM
void start_batch_gemm();

// Poll until GEMM accelerator finishes
void wait_batch_gemm();

// Check if output is same as golden output
uint32_t check_result(int32_t* output, int32_t* output_golden, uint8_t Batch,
                      uint8_t M, uint8_t N, uint32_t strideInnermostC,
                      uint32_t ldC, uint32_t strideC);
