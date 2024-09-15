// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-streamer-gemm-conv-simd-lib.h"
#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"
#include "streamer_csr_addr_map.h"

int32_t gen_size_config(uint8_t Batch, uint8_t M, uint8_t K, uint8_t N) {
    return ((int32_t)Batch << 24) | ((int32_t)M << 16) | ((int32_t)K << 8) |
           (int32_t)N;
}

int32_t gen_subtraction_config(int8_t subtraction_a, int8_t subtraction_b) {
    return ((uint8_t)subtraction_b << 8) | (uint8_t)subtraction_a;
}

int32_t gen_csr0_config(uint8_t input_zp_i, uint8_t output_zp_i,
                        uint8_t shift_i, uint8_t max_int_i) {
    // encode the configuration into a single 32-bit integer
    return ((int32_t)max_int_i << 24) | ((int32_t)shift_i << 16) |
           ((int32_t)output_zp_i << 8) | (int32_t)input_zp_i;
}

int32_t gen_csr1_config(uint8_t min_int_i, bool double_round_i) {
    // encode the configuration into a single 32-bit integer
    return ((uint8_t)double_round_i << 8) | (uint8_t)min_int_i;
}

int32_t gen_csr2_config(uint32_t multiplier_i) { return multiplier_i; }

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
    int delta_local_d32, int bypassSIMD, int32_t transpose_A,
    int32_t transpose_B) {
    // base ptr for A
    csrw_ss(BASE_PTR_READER_0_LOW, (uint32_t)(delta_local_a + snrt_l1_next()));

    // spatial strides for A
    csrw_ss(S_STRIDE_READER_0_0, Aslstride1);

    // loop bounds, from innermost to outermost, for data mover A
    csrw_ss(T_BOUND_READER_0_0, Atlbound0);
    csrw_ss(T_BOUND_READER_0_1, Atlbound1);
    csrw_ss(T_BOUND_READER_0_2, Atlbound2);
    csrw_ss(T_BOUND_READER_0_3, Atlbound3);
    csrw_ss(T_BOUND_READER_0_4, Atlbound4);
    csrw_ss(T_BOUND_READER_0_5, Atlbound5);

    // temporal strides for A
    csrw_ss(T_STRIDE_READER_0_0, Atlstride0);
    csrw_ss(T_STRIDE_READER_0_1, Atlstride1);
    csrw_ss(T_STRIDE_READER_0_2, Atlstride2);
    csrw_ss(T_STRIDE_READER_0_3, Atlstride3);
    csrw_ss(T_STRIDE_READER_0_4, Atlstride4);
    csrw_ss(T_STRIDE_READER_0_5, Atlstride5);

    // base ptr for B
    csrw_ss(BASE_PTR_READER_1_LOW, (uint32_t)(delta_local_b + snrt_l1_next()));

    // spatial strides for B
    csrw_ss(S_STRIDE_READER_1_0, Bslstride1);

    // loop bounds, from innermost to outermost, for data mover B
    csrw_ss(T_BOUND_READER_1_0, Btlbound0);
    csrw_ss(T_BOUND_READER_1_1, Btlbound1);
    csrw_ss(T_BOUND_READER_1_2, Btlbound2);

    // temporal strides for B
    csrw_ss(T_STRIDE_READER_1_0, Btlstride0);
    csrw_ss(T_STRIDE_READER_1_1, Btlstride1);
    csrw_ss(T_STRIDE_READER_1_2, Btlstride2);

    // base ptr for D8
    csrw_ss(BASE_PTR_WRITER_0_LOW, (uint32_t)(delta_local_d8 + snrt_l1_next()));

    // spatial strides for D8
    csrw_ss(S_STRIDE_WRITER_0_0, D8slstride1);

    // for D8, from N to M
    if (bypassSIMD == 0) {
        csrw_ss(T_BOUND_WRITER_0_0, D8tlbound0);
        csrw_ss(T_BOUND_WRITER_0_1, D8tlbound1);
        csrw_ss(T_BOUND_WRITER_0_2, D8tlbound2);
    } else {
        csrw_ss(T_BOUND_WRITER_0_0, 0);
        csrw_ss(T_BOUND_WRITER_0_1, 0);
        csrw_ss(T_BOUND_WRITER_0_2, 0);
    }

    // temporal strides for D8
    csrw_ss(T_STRIDE_WRITER_0_0, D8tlstride0);
    csrw_ss(T_STRIDE_WRITER_0_1, D8tlstride1);
    csrw_ss(T_STRIDE_WRITER_0_2, D8tlstride2);

    // base ptr for C
    csrw_ss(BASE_PTR_READER_WRITER_0_LOW,
            (uint32_t)(delta_local_c + snrt_l1_next()));

    // spatial strides for C
    csrw_ss(S_STRIDE_READER_WRITER_0_0, Cslstride1);

    // loop bounds, from innermost to outermost, for data mover C
    csrw_ss(T_BOUND_READER_WRITER_0_0, Ctlbound0);
    csrw_ss(T_BOUND_READER_WRITER_0_1, Ctlbound1);
    csrw_ss(T_BOUND_READER_WRITER_0_2, Ctlbound2);

    // temporal strides for C
    csrw_ss(T_STRIDE_READER_WRITER_0_0, Ctlstride0);
    csrw_ss(T_STRIDE_READER_WRITER_0_1, Ctlstride1);
    csrw_ss(T_STRIDE_READER_WRITER_0_2, Ctlstride2);

    // base ptr for D32
    csrw_ss(BASE_PTR_READER_WRITER_1_LOW,
            (uint32_t)(delta_local_d32 + snrt_l1_next()));

    // spatial strides for D32
    csrw_ss(S_STRIDE_READER_WRITER_1_0, D32slstride1);

    // for D32, from N to M
    if (bypassSIMD == 0) {
        csrw_ss(T_BOUND_READER_WRITER_1_0, 0);
        csrw_ss(T_BOUND_READER_WRITER_1_1, 0);
        csrw_ss(T_BOUND_READER_WRITER_1_2, 0);
    } else {
        csrw_ss(T_BOUND_READER_WRITER_1_0, D32tlbound0);
        csrw_ss(T_BOUND_READER_WRITER_1_1, D32tlbound1);
        csrw_ss(T_BOUND_READER_WRITER_1_2, D32tlbound2);
    }

    // temporal strides for D32
    csrw_ss(T_STRIDE_READER_WRITER_1_0, D32tlstride0);
    csrw_ss(T_STRIDE_READER_WRITER_1_1, D32tlstride1);
    csrw_ss(T_STRIDE_READER_WRITER_1_2, D32tlstride2);

    // set the transpose
    csrw_ss(TRANSPOSE_CSR_READER_0, transpose_A == 0 ? 1 : 0);
    csrw_ss(TRANSPOSE_CSR_READER_0, transpose_B == 0 ? 1 : 0);
}

// Set CSR to start STREAMER
void set_gemmx_streamer_start() { csrw_ss(STREAMER_START_CSR, 1); }

#define GEMMX_CSR_ADDR_BASE (STREAMER_PERFORMANCE_COUNTER_CSR + 1)
#define T_BOUND_K (GEMMX_CSR_ADDR_BASE + 0)
#define T_BOUND_N (GEMMX_CSR_ADDR_BASE + 1)
#define T_BOUND_M (GEMMX_CSR_ADDR_BASE + 2)

#define SUBTRACTIONS (GEMMX_CSR_ADDR_BASE + 3)

#define SIMD_CSR0 (GEMMX_CSR_ADDR_BASE + 4)
#define SIMD_CSR1 (GEMMX_CSR_ADDR_BASE + 5)
#define SIMD_CSR2 (GEMMX_CSR_ADDR_BASE + 6)

#define TEMPORAL_LOOP_BOUND (GEMMX_CSR_ADDR_BASE + 7)
#define BYPASS_SIMD (GEMMX_CSR_ADDR_BASE + 8)

#define GEMMX_START (GEMMX_CSR_ADDR_BASE + 9)
#define GEMMX_BUSY (GEMMX_CSR_ADDR_BASE + 10)
#define GEMMX_PERFORMANCE_COUNTER (GEMMX_CSR_ADDR_BASE + 11)

// Set GEMM configuration CSR
void set_gemmx_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                   int subtractions, uint32_t csr0, uint32_t csr1,
                   uint32_t csr2, uint32_t temporal_loop_bound,
                   uint32_t bypassSIMD) {
    // set loop bounds, from innermost to outermost, aka from K to N to M
    csrw_ss(T_BOUND_K, tempLoop0);
    csrw_ss(T_BOUND_N, tempLoop1);
    csrw_ss(T_BOUND_M, tempLoop2);

    // set subtraction a and b
    csrw_ss(SUBTRACTIONS, subtractions);

    // set the constants for the SIMD unit
    csrw_ss(SIMD_CSR0, csr0);
    csrw_ss(SIMD_CSR1, csr1);
    csrw_ss(SIMD_CSR2, csr2);

    // set the temporal loop bound
    csrw_ss(TEMPORAL_LOOP_BOUND, temporal_loop_bound);
    csrw_ss(BYPASS_SIMD, bypassSIMD);
}

// Set CSR to start GEMM
void set_gemmx_start() { csrw_ss(GEMMX_START, 1); }

// Stall until Streamer and GEMM accelerator finish
void wait_gemmx_and_streamer() {
    csrw_ss(STREAMER_START_CSR, 0);
    csrw_ss(STREAMER_START_CSR, 0);
    while (csrr_ss(GEMMX_BUSY)) {
    }
    while (csrr_ss(STREAMER_BUSY_CSR)) {
    }
    csrw_ss(GEMMX_START, 0);
}

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_gemmx_streamer_perf_counter() {
    uint32_t perf_counter = csrr_ss(STREAMER_PERFORMANCE_COUNTER_CSR);
    return perf_counter;
}

// Read performance counter of GEMM, a read-only CSR
uint32_t read_gemmx_perf_counter() {
    uint32_t perf_counter = csrr_ss(GEMMX_PERFORMANCE_COUNTER);
    return perf_counter;
}

uint32_t check_gemmx_result_D8(int8_t* output, int8_t* output_golden,
                               int32_t Batch, int32_t M, int32_t N) {
    uint32_t err = 0;
    uint32_t size = 0;
    size = Batch * M * N * 8 * 8;

    for (int i = 0; i < size; i++) {
        if (output[i] != output_golden[i]) {
            err++;
        }
    }
    return err;
}

uint32_t check_gemmx_result_D32(int32_t* output, int32_t* output_golden,
                                int32_t Batch, int32_t M, int32_t N) {
    uint32_t err = 0;
    uint32_t size = 0;
    size = Batch * M * N * 8 * 8;

    for (int i = 0; i < size; i++) {
        if (output[i] != output_golden[i]) {
            err++;
        }
    }
    return err;
}
