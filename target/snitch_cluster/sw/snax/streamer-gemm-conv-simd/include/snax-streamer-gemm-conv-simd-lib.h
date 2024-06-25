// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"

#pragma once

// load input data from L3 to L1
void load_conv_input_data(int N, int H, int W, int C, int8_t* base_ptr_local,
                          int8_t* base_ptr_l2);

void load_weight_data(int K, int Fy, int Fx, int C, int8_t* base_ptr_local,
                      int8_t* base_ptr_l2);

// Set STREAMER configuration CSR
void set_gemmx_streamer_csr(
    int Aslstride0, int Aslstride1, int Atlbound0, int Atlstride0,
    int Atlbound1, int Atlstride1, int Atlbound2, int Atlstride2, int Atlbound3,
    int Atlstride3, int Atlbound4, int Atlstride4, int Atlbound5,
    int Atlstride5,

    int Bslstride0, int Bslstride1, int Btlbound0, int Btlstride0,
    int Btlbound1, int Btlstride1, int Btlbound2, int Btlstride2,

    int D8slstride0, int D8slstride1, int D8tlbound0, int D8tlstride0,
    int D8tlbound1, int D8tlstride1, int D8tlbound2, int D8tlstride2,

    int Cslstride0, int Cslstride1, int Ctlbound0, int Ctlstride0,
    int Ctlbound1, int Ctlstride1, int Ctlbound2, int Ctlstride2,

    int D32slstride0, int D32slstride1, int D32tlbound0, int D32tlstride0,
    int D32tlbound1, int D32tlstride1, int D32tlbound2, int D32tlstride2,

    int delta_local_a, int delta_local_b, int delta_local_d8, int delta_local_c,
    int delta_local_d32, int bypassSIMD);

// Set CSR to start STREAMER
void set_gemmx_streamer_start();

// Set GEMM configuration CSR
void set_gemmx_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                   int subtractions, uint32_t csr0, uint32_t csr1,
                   uint32_t csr2, uint32_t temporal_loop_bound,
                   uint32_t bypassSIMD);

// Set CSR to start GEMM
void set_gemmx_start();

// Poll until Streamer and GEMM accelerator finish
void wait_gemmx_and_streamer();

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_gemmx_streamer_perf_counter();

// Read performance counter of GEMM, a read-only CSR
uint32_t read_gemmx_perf_counter();

// Check the result of the implicit im2col convolution
uint32_t check_gemmx_result_D8(int8_t* output, int8_t* output_golden,
                               int32_t Batch, int32_t M, int32_t N);

uint32_t check_gemmx_result_D32(int32_t* output, int32_t* output_golden,
                                int32_t Batch, int32_t M, int32_t N);
