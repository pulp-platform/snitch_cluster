// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-streamer-gemm-conv-simd-lib.h"
#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"

// load input data from L3 to L1
void load_conv_input_data(int N, int H, int W, int C, int8_t* base_ptr_local,
                          int8_t* base_ptr_l2) {
    snrt_dma_start_1d(base_ptr_local, base_ptr_l2,
                      N * H * W * C * sizeof(int8_t));
}

void load_weight_data(int K, int Fy, int Fx, int C, int8_t* base_ptr_local,
                      int8_t* base_ptr_l2) {
    snrt_dma_start_1d(base_ptr_local, base_ptr_l2,
                      K * Fy * Fx * C * sizeof(int8_t));
}

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
    int delta_local_d32, int bypassSIMD) {
    // loop bounds, from innermost to outermost, for data mover A
    write_csr(960, Atlbound0);
    write_csr(961, Atlbound1);
    write_csr(962, Atlbound2);
    write_csr(963, Atlbound3);
    write_csr(964, Atlbound4);
    write_csr(965, Atlbound5);

    // loop bounds, from innermost to outermost, for data mover B
    write_csr(966, Btlbound0);
    write_csr(967, Btlbound1);
    write_csr(968, Btlbound2);

    // for D8, from N to M
    if (bypassSIMD == 0) {
        write_csr(969, D8tlbound0);
        write_csr(970, D8tlbound1);
        write_csr(971, D8tlbound2);
    } else {
        write_csr(969, 0);
        write_csr(970, 0);
        write_csr(971, 0);
    }

    // loop bounds, from innermost to outermost, for data mover C
    write_csr(972, Ctlbound0);
    write_csr(973, Ctlbound1);
    write_csr(974, Ctlbound2);

    // for D32, from N to M
    if (bypassSIMD == 0) {
        write_csr(975, 0);
        write_csr(976, 0);
        write_csr(977, 0);
    } else {
        write_csr(975, D32tlbound0);
        write_csr(976, D32tlbound1);
        write_csr(977, D32tlbound2);
    }

    // temporal strides for A
    write_csr(978, Atlstride0);
    write_csr(979, Atlstride1);
    write_csr(980, Atlstride2);
    write_csr(981, Atlstride3);
    write_csr(982, Atlstride4);
    write_csr(983, Atlstride5);

    // temporal strides for B
    write_csr(984, Btlstride0);
    write_csr(985, Btlstride1);
    write_csr(986, Btlstride2);

    // temporal strides for D8
    write_csr(987, D8tlstride0);
    write_csr(988, D8tlstride1);
    write_csr(989, D8tlstride2);

    // temporal strides for C
    write_csr(990, Ctlstride0);
    write_csr(991, Ctlstride1);
    write_csr(992, Ctlstride2);

    // temporal strides for D32
    write_csr(993, D32tlstride0);
    write_csr(994, D32tlstride1);
    write_csr(995, D32tlstride2);

    // spatial strides for A
    write_csr(996, Aslstride0);
    write_csr(997, Aslstride1);

    // spatial strides for B
    write_csr(998, Bslstride0);
    write_csr(999, Bslstride1);

    // spatial strides for D8
    write_csr(1000, D8slstride0);
    write_csr(1001, D8slstride1);

    // spatial strides for C
    write_csr(1002, Cslstride0);
    write_csr(1003, Cslstride1);

    // spatial strides for D32
    write_csr(1004, D32slstride0);
    write_csr(1005, D32slstride1);

    // base ptr for A
    write_csr(1006, (uint32_t)(delta_local_a + snrt_l1_next()));

    // base ptr for B
    write_csr(1007, (uint32_t)(delta_local_b + snrt_l1_next()));

    // base ptr for D8
    write_csr(1008, (uint32_t)(delta_local_d8 + snrt_l1_next()));

    // base ptr for C
    write_csr(1009, (uint32_t)(delta_local_c + snrt_l1_next()));

    // base ptr for D32
    write_csr(1010, (uint32_t)(delta_local_d32 + snrt_l1_next()));
}

// Set CSR to start STREAMER
void set_gemmx_streamer_start() { write_csr(1011, 1); }

// Set GEMM configuration CSR
void set_gemmx_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                   int subtractions, uint32_t csr0, uint32_t csr1,
                   uint32_t csr2, uint32_t temporal_loop_bound,
                   uint32_t bypassSIMD) {
    // set loop bounds, from innermost to outermost, aka from K to N to M
    write_csr(1014, tempLoop0);
    write_csr(1015, tempLoop1);
    write_csr(1016, tempLoop2);

    // set subtraction a and b
    write_csr(1017, subtractions);

    // set the constants for the SIMD unit
    write_csr(1018, csr0);
    write_csr(1019, csr1);
    write_csr(1020, csr2);

    // set the temporal loop bound
    write_csr(1021, temporal_loop_bound);
    write_csr(1022, bypassSIMD);
}

// Set CSR to start GEMM
void set_gemmx_start() { write_csr(1023, 1); }

// Stall until Streamer and GEMM accelerator finish
void wait_gemmx_and_streamer() {
    write_csr(1011, 0);
    write_csr(1011, 0);
    write_csr(1023, 0);
}

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_gemmx_streamer_perf_counter() {
    uint32_t perf_counter = read_csr(1013);
    return perf_counter;
}

// Read performance counter of GEMM, a read-only CSR
uint32_t read_gemmx_perf_counter() {
    uint32_t perf_counter = read_csr(1025);
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
