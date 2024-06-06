// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

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
void set_conv_streamer_csr(
    int Aslstride0, int Aslstride1, int Atlbound0, int Atlstride0,
    int Atlbound1, int Atlstride1, int Atlbound2, int Atlstride2, int Atlbound3,
    int Atlstride3, int Atlbound4, int Atlstride4, int Atlbound5,
    int Atlstride5, int Bslstride0, int Bslstride1, int Btlbound0,
    int Btlstride0, int Btlbound1, int Btlstride1, int Btlbound2,
    int Btlstride2, int Cslstride0, int Cslstride1, int Ctlbound0,
    int Ctlstride0, int Ctlbound1, int Ctlstride1, int Ctlbound2,
    int Ctlstride2, int delta_local_a, int delta_local_b, int delta_local_c) {
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

    // loop bounds, from innermost to outermost, for data mover C
    write_csr(969, Ctlbound0);
    write_csr(970, Ctlbound1);
    write_csr(971, Ctlbound2);

    // temporal strides for A
    write_csr(972, Atlstride0);
    write_csr(973, Atlstride1);
    write_csr(974, Atlstride2);
    write_csr(975, Atlstride3);
    write_csr(976, Atlstride4);
    write_csr(977, Atlstride5);

    // temporal strides for B
    write_csr(978, Btlstride0);
    write_csr(979, Btlstride1);
    write_csr(980, Btlstride2);

    // temporal strides for C
    write_csr(981, Ctlstride0);
    write_csr(982, Ctlstride1);
    write_csr(983, Ctlstride2);

    // spatial strides for A
    write_csr(984, Aslstride0);
    write_csr(985, Aslstride1);

    // spatial strides for B
    write_csr(986, Bslstride0);
    write_csr(987, Bslstride1);

    // spatial strides for C
    write_csr(988, Cslstride0);
    write_csr(989, Cslstride1);

    // base ptr for A
    write_csr(990, (uint32_t)(delta_local_a + snrt_l1_next()));

    // base ptr for B
    write_csr(991, (uint32_t)(delta_local_b + snrt_l1_next()));

    // base ptr for C
    write_csr(992, (uint32_t)(delta_local_c + snrt_l1_next()));
}

// Set CSR to start STREAMER
void set_conv_streamer_start() { write_csr(993, 1); }

// Set GEMM configuration CSR
void set_conv_block_gemm_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                             int subtractions) {
    // set loop bounds, from innermost to outermost, aka from K to N to M
    write_csr(995, tempLoop0);
    write_csr(996, tempLoop1);
    write_csr(997, tempLoop2);

    // set subtraction a and b
    write_csr(998, subtractions);
}

// Set CSR to start GEMM
void set_conv_block_gemm_start() { write_csr(999, 1); }

// Stall until Streamer and GEMM accelerator finish
void wait_conv_streamer_gemm() {
    write_csr(999, 0);
    write_csr(999, 0);
    write_csr(993, 0);
}

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_conv_gemm_streamer_perf_counter() {
    uint32_t perf_counter = read_csr(994);
    return perf_counter;
}

// Read performance counter of GEMM, a read-only CSR
uint32_t read_conv_gemm_perf_counter() {
    uint32_t perf_counter = read_csr(1000);
    return perf_counter;
}

// Check the result of the implicit im2col convolution
uint32_t check_conv_result(int32_t* output, int32_t* output_golden,
                           int32_t Batch, int32_t M, int32_t N) {
    uint32_t err = 0;
    for (int i = 0; i < Batch * M * N * 8 * 8; i++) {
        if (output[i] != output_golden[i]) {
            err++;
        }
    }
    return err;
}
