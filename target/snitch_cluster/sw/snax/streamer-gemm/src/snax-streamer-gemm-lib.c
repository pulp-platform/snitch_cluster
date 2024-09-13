// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-streamer-gemm-lib.h"
#include "streamer_csr_addr_map.h"

// Set STREAMER configuration CSR
void set_streamer_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                      int tempStride0A, int tempStride2A, int spatialStride1A,
                      int tempStride0B, int tempStride1B, int spatialStride1B,
                      int tempStride1C, int tempStride2C, int spatialStride1C,
                      int delta_local_a, int delta_local_b, int delta_local_c) {
    // base ptr for A
    csrw_ss(BASE_PTR_READER_0_LOW, (uint32_t)(delta_local_a + snrt_l1_next()));

    // spatial strides for A
    csrw_ss(S_STRIDE_READER_0_0, spatialStride1A);

    // loop bounds, from innermost to outermost, from K to N to M
    csrw_ss(T_BOUND_READER_0_0, tempLoop0);
    csrw_ss(T_BOUND_READER_0_1, tempLoop1);
    csrw_ss(T_BOUND_READER_0_2, tempLoop2);

    // temporal strides for A
    csrw_ss(T_STRIDE_READER_0_0, tempStride0A);
    csrw_ss(T_STRIDE_READER_0_1, 0);
    csrw_ss(T_STRIDE_READER_0_2, tempStride2A);

    // base ptr for B
    csrw_ss(BASE_PTR_READER_1_LOW, (uint32_t)(delta_local_b + snrt_l1_next()));

    // spatial strides for B
    csrw_ss(S_STRIDE_READER_1_0, spatialStride1B);

    // loop bounds, from innermost to outermost, from K to N to M
    csrw_ss(T_BOUND_READER_1_0, tempLoop0);
    csrw_ss(T_BOUND_READER_1_1, tempLoop1);
    csrw_ss(T_BOUND_READER_1_2, tempLoop2);

    // temporal strides for B
    csrw_ss(T_STRIDE_READER_1_0, tempStride0B);
    csrw_ss(T_STRIDE_READER_1_1, tempStride1B);
    csrw_ss(T_STRIDE_READER_1_2, 0);

    // base ptr for C
    csrw_ss(BASE_PTR_WRITER_0_LOW, (uint32_t)(delta_local_c + snrt_l1_next()));

    // spatial strides for C
    csrw_ss(S_STRIDE_WRITER_0_0, spatialStride1C);

    // loop bounds, from innermost to outermost, from K to N to M
    csrw_ss(T_BOUND_WRITER_0_0, tempLoop0);
    csrw_ss(T_BOUND_WRITER_0_1, tempLoop1);
    csrw_ss(T_BOUND_WRITER_0_2, tempLoop2);

    // temporal strides for C
    csrw_ss(T_STRIDE_WRITER_0_0, 0);
    csrw_ss(T_STRIDE_WRITER_0_1, tempStride1C);
    csrw_ss(T_STRIDE_WRITER_0_2, tempStride2C);
}

// Set CSR to start STREAMER
void set_streamer_start() { csrw_ss(STREAMER_START_CSR, 1); }

#define GEMM_CSR_ADDR_BASE (STREAMER_PERFORMANCE_COUNTER_CSR + 1)
#define T_BOUND_K (GEMM_CSR_ADDR_BASE + 0)
#define T_BOUND_N (GEMM_CSR_ADDR_BASE + 1)
#define T_BOUND_M (GEMM_CSR_ADDR_BASE + 2)
#define GEMM_SUBTRACTIONS (GEMM_CSR_ADDR_BASE + 3)
#define GEMM_START (GEMM_CSR_ADDR_BASE + 4)
#define GEMM_BUSY (GEMM_CSR_ADDR_BASE + 5)
#define GEMM_PERFORMANCE_COUNTER (GEMM_CSR_ADDR_BASE + 6)

// Set GEMM configuration CSR
void set_block_gemm_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                        int subtractions) {
    // set loop bounds, from innermost to outermost, aka from K to N to M
    csrw_ss(T_BOUND_K, tempLoop0);
    csrw_ss(T_BOUND_N, tempLoop1);
    csrw_ss(T_BOUND_M, tempLoop2);

    // set subtraction a and b
    csrw_ss(GEMM_SUBTRACTIONS, subtractions);
}

// Set CSR to start GEMM
void set_block_gemm_start() { csrw_ss(GEMM_START, 1); }

// Poll until Streamer and GEMM accelerator finish
void wait_streamer_gemm() {
    csrw_ss(GEMM_START, 0);
    csrw_ss(GEMM_START, 0);
    csrw_ss(STREAMER_START_CSR, 0);
}

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_gemm_streamer_perf_counter() {
    uint32_t perf_counter = csrr_ss(STREAMER_PERFORMANCE_COUNTER_CSR);
    return perf_counter;
}

// Read performance counter of GEMM, a read-only CSR
uint32_t read_gemm_perf_counter() {
    uint32_t perf_counter = csrr_ss(GEMM_PERFORMANCE_COUNTER);
    return perf_counter;
}
