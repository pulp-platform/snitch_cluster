// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-streamer-gemm-lib.h"

// Set STREAMER configuration CSR
void set_streamer_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                      int tempStride0A, int tempStride2A, int spatialStride1A,
                      int tempStride0B, int tempStride1B, int spatialStride1B,
                      int tempStride1C, int tempStride2C, int spatialStride1C,
                      int delta_local_a, int delta_local_b, int delta_local_c) {
    // loop bounds, from innermost to outermost, from K to N to M
    write_csr(960, tempLoop0);
    write_csr(961, tempLoop1);
    write_csr(962, tempLoop2);

    // temporal strides for A
    write_csr(963, tempStride0A);
    write_csr(964, 0);
    write_csr(965, tempStride2A);

    // temporal strides for B
    write_csr(966, tempStride0B);
    write_csr(967, tempStride1B);
    write_csr(968, 0);

    // temporal strides for C
    write_csr(969, 0);
    write_csr(970, tempStride1C);
    write_csr(971, tempStride2C);

    // spatial strides for A
    write_csr(972, 1);
    write_csr(973, spatialStride1A);

    // spatial strides for B
    write_csr(974, 1);
    write_csr(975, spatialStride1B);

    // spatial strides for C
    write_csr(976, 4);
    write_csr(977, spatialStride1C);

    // base ptr for A
    write_csr(978, (uint32_t)(delta_local_a + snrt_l1_next()));

    // base ptr for B
    write_csr(979, (uint32_t)(delta_local_b + snrt_l1_next()));

    // base ptr for C
    write_csr(980, (uint32_t)(delta_local_c + snrt_l1_next()));
}

// Set CSR to start STREAMER
void set_streamer_start() { write_csr(981, 1); }

// Set GEMM configuration CSR
void set_block_gemm_csr(int tempLoop0, int tempLoop1, int tempLoop2,
                        int subtractions) {
    // set loop bounds, from innermost to outermost, aka from K to N to M
    write_csr(983, tempLoop0);
    write_csr(984, tempLoop1);
    write_csr(985, tempLoop2);

    // set subtraction a and b
    write_csr(986, subtractions);
}

// Set CSR to start GEMM
void set_block_gemm_start() { write_csr(987, 1); }

// Poll until Streamer and GEMM accelerator finish
void wait_streamer_gemm() {
    write_csr(987, 0);
    write_csr(987, 0);
    write_csr(981, 0);
}

// Read performance counter of the Streamer, a read-only CSR
uint32_t read_gemm_streamer_perf_counter() {
    uint32_t perf_counter = read_csr(982);
    return perf_counter;
}

// Read performance counter of GEMM, a read-only CSR
uint32_t read_gemm_perf_counter() {
    uint32_t perf_counter = read_csr(989);
    return perf_counter;
}
