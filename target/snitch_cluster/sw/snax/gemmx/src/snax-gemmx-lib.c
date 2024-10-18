// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-gemmx-lib.h"
#include <stdbool.h>
#include "snax-gemmx-params.h"
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
                        uint8_t max_int_i, uint8_t min_int_i) {
    // encode the configuration into a single 32-bit integer
    return ((int32_t)min_int_i << 24) | ((int32_t)max_int_i << 16) |
           ((int32_t)output_zp_i << 8) | (int32_t)input_zp_i;
}

int32_t gen_csr1_config(bool double_round_i) {
    // encode the configuration into a single 32-bit integer
    return (uint32_t)double_round_i;
}

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
    int32_t transpose_B, int32_t channel_en_C, int32_t broadcast_C) {
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

    // set the address remap index for A
    csrw_ss(ADDR_REMAP_INDEX_READER_0, set_addr_remap_index_A);

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

    // set the address remap index for B
    csrw_ss(ADDR_REMAP_INDEX_READER_1, set_addr_remap_index_B);

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

    // set the address remap index for D8
    csrw_ss(ADDR_REMAP_INDEX_WRITER_0, set_addr_remap_index_D8);

    // base ptr for C
    csrw_ss(BASE_PTR_READER_WRITER_0_LOW,
            (uint32_t)(delta_local_c + snrt_l1_next()));

    // spatial strides for C
    csrw_ss(S_STRIDE_READER_WRITER_0_0, Cslstride0);
    csrw_ss(S_STRIDE_READER_WRITER_0_1, Cslstride1);

    // loop bounds, from innermost to outermost, for data mover C
    csrw_ss(T_BOUND_READER_WRITER_0_0, Ctlbound0);
    csrw_ss(T_BOUND_READER_WRITER_0_1, Ctlbound1);
    csrw_ss(T_BOUND_READER_WRITER_0_2, Ctlbound2);

    // temporal strides for C
    csrw_ss(T_STRIDE_READER_WRITER_0_0, Ctlstride0);
    csrw_ss(T_STRIDE_READER_WRITER_0_1, Ctlstride1);
    csrw_ss(T_STRIDE_READER_WRITER_0_2, Ctlstride2);

    // set the address remap index for C
    csrw_ss(ADDR_REMAP_INDEX_READER_WRITER_0, set_addr_remap_index_C);

#ifdef ENABLED_CHANNEL_READER_WRITER_0
    csrw_ss(ENABLED_CHANNEL_READER_WRITER_0, channel_en_C);
#endif

#ifdef C_BROADCAST_EXTENSION_ENABLE
    csrw_ss(C_BROADCAST_CSR_READER_WRITER_0, broadcast_C == 1 ? 0 : 1);
#endif

    // base ptr for D32
    csrw_ss(BASE_PTR_READER_WRITER_1_LOW,
            (uint32_t)(delta_local_d32 + snrt_l1_next()));

    // spatial strides for D32
    csrw_ss(S_STRIDE_READER_WRITER_1_0, D32slstride0);
    csrw_ss(S_STRIDE_READER_WRITER_1_1, D32slstride1);

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

    // set the address remap index for D32
    csrw_ss(ADDR_REMAP_INDEX_READER_WRITER_1, set_addr_remap_index_D32);

    // set the transpose
#ifdef TRANSPOSE_EXTENSION_ENABLE
    csrw_ss(TRANSPOSE_CSR_READER_0, transpose_A == 0 ? 1 : 0);
    csrw_ss(TRANSPOSE_CSR_READER_1, transpose_B == 0 ? 1 : 0);
#endif
}

// Set GEMM configuration CSR
void set_gemmx_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                   int subtractions, uint32_t csr0, uint32_t csr1,
                   int shared_bitpacked_shift0, int shared_bitpacked_shift1,
                   int shared_multiplier0, int shared_multiplier1,
                   int shared_multiplier2, int shared_multiplier3,
                   int shared_multiplier4, int shared_multiplier5,
                   int shared_multiplier6, int shared_multiplier7,
                   uint32_t temporal_loop_bound, uint32_t bypassSIMD) {
    // set loop bounds, from innermost to outermost, aka from K to N to M
    csrw_ss(T_BOUND_K, tempLoop0);
    csrw_ss(T_BOUND_N, tempLoop1);
    csrw_ss(T_BOUND_M, tempLoop2);

    // set subtraction a and b
    csrw_ss(SUBTRACTIONS, subtractions);

    // set the constants for the SIMD unit
    csrw_ss(SIMD_CSR0, csr0);
    csrw_ss(SIMD_CSR1, csr1);

    // set the shared bitpacked shift
    csrw_ss(SIMD_SHARED_BITPACKED_SHIFT0, shared_bitpacked_shift0);
    csrw_ss(SIMD_SHARED_BITPACKED_SHIFT1, shared_bitpacked_shift1);

    // set the shared multipliers
    csrw_ss(SIMD_SHARED_MULTIPLIER0, shared_multiplier0);
    csrw_ss(SIMD_SHARED_MULTIPLIER1, shared_multiplier1);
    csrw_ss(SIMD_SHARED_MULTIPLIER2, shared_multiplier2);
    csrw_ss(SIMD_SHARED_MULTIPLIER3, shared_multiplier3);
    csrw_ss(SIMD_SHARED_MULTIPLIER4, shared_multiplier4);
    csrw_ss(SIMD_SHARED_MULTIPLIER5, shared_multiplier5);
    csrw_ss(SIMD_SHARED_MULTIPLIER6, shared_multiplier6);
    csrw_ss(SIMD_SHARED_MULTIPLIER7, shared_multiplier7);

    // set the temporal loop bound
    csrw_ss(TEMPORAL_LOOP_BOUND, temporal_loop_bound);

    csrw_ss(BYPASS_SIMD, bypassSIMD);
}

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
                               int32_t Batch, int32_t M, int32_t N,
                               bool banked_data_layout) {
    uint32_t err = 0;
    uint32_t size = 0;
    size = Batch * M * N * meshRow * meshCol;

    if (banked_data_layout) {
        for (int i = 0; i < size / 64; i += 1) {
            for (int j = 0; j < 64; j++) {
                if (*(output + i * 256 + j) != output_golden[i * 64 + j]) {
                    err++;
                }
            }
        }
    } else {
        for (int i = 0; i < size; i++) {
            if (output[i] != output_golden[i]) {
                err++;
            }
        }
    }

    return err;
}

uint32_t check_gemmx_result_D32(int32_t* output, int32_t* output_golden,
                                int32_t Batch, int32_t M, int32_t N,
                                bool banked_data_layout) {
    uint32_t err = 0;
    uint32_t size = 0;
    size = Batch * M * N * meshRow * meshCol;

    if (banked_data_layout) {
        for (int i = 0; i < size / 16; i += 1) {
            for (int j = 0; j < 16; j++) {
                if (*(output + i * (256 / 4) + j) !=
                    output_golden[i * 16 + j]) {
                    err++;
                }
            }
        }
    } else {
        for (int i = 0; i < size; i++) {
            if (output[i] != output_golden[i]) {
                err++;
            }
        }
    }

    return err;
}
