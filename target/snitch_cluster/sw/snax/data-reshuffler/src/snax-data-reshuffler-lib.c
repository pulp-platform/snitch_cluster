// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-data-reshuffler-lib.h"

// Set STREAMER configuration CSR
void set_data_reshuffler_csr(int tempLoop0_in, int tempLoop1_in,
                             int tempLoop2_in, int tempLoop3_in,
                             int tempLoop4_in, int tempStride0_in,
                             int tempStride1_in, int tempStride2_in,
                             int tempStride3_in, int tempStride4_in,
                             int spatialStride1_in, int tempLoop0_out,
                             int tempLoop1_out, int tempLoop2_out,
                             int tempStride0_out, int tempStride1_out,
                             int tempStride2_out, int spatialStride1_out,
                             int32_t delta_local_in, int32_t delta_local_out) {
    // temporal loop bounds, from innermost to outermost for data reader (In)
    write_csr(960, tempLoop0_in);
    write_csr(961, tempLoop1_in);
    write_csr(962, tempLoop2_in);
    write_csr(963, tempLoop3_in);
    write_csr(964, tempLoop4_in);

    // temporal loop bounds, from innermost to outermost for data writer (Out)
    write_csr(965, tempLoop0_out);
    write_csr(966, tempLoop1_out);
    write_csr(967, tempLoop2_out);

    // temporal strides for data reader (In)
    write_csr(968, tempStride0_in);
    write_csr(969, tempStride1_in);
    write_csr(970, tempStride2_in);
    write_csr(971, tempStride3_in);
    write_csr(972, tempStride4_in);

    // temporal strides for data writer (Out)
    write_csr(973, tempStride0_out);
    write_csr(974, tempStride1_out);
    write_csr(975, tempStride2_out);

    // fixed spatial strides for data reader (In)
    write_csr(976, spatialStride1_in);

    // fixed spatial strides for data writer (Out)
    write_csr(977, spatialStride1_out);

    // base ptr for data reader (In)
    write_csr(978, (uint32_t)(delta_local_in + snrt_l1_next()));

    // base ptr for data writer (Out)
    write_csr(979, (uint32_t)(delta_local_out + snrt_l1_next()));
}

// Set CSR to start STREAMER
void start_streamer() { write_csr(980, 1); }

void wait_streamer() { write_csr(980, 0); }

void set_data_reshuffler(int T2Len, int reduceLen, int opcode) {
    // set transpose or not
    uint32_t csr0 = ((uint32_t)T2Len << 7) | ((uint32_t)reduceLen << 2) |
                    ((uint32_t)opcode);
    write_csr(983, csr0);
}

void start_data_reshuffler() { write_csr(984, 1); }

void wait_data_reshuffler() { write_csr(984, 0); }

uint32_t read_data_reshuffler_perf_counter() {
    uint32_t perf_counter = read_csr(982);
    return perf_counter;
}

void load_data_reshuffler_test_data(int tempLoop0, int tempLoop1,
                                    int tempStride0, int tempStride1,
                                    int spatialStride1, int8_t* base_ptr_local,
                                    int8_t* base_ptr_l2) {
    int8_t* addr_in;
    int8_t* addr_In;

    for (int loop1 = 0; loop1 < tempLoop1; loop1++) {
        for (int loop0 = 0; loop0 < tempLoop0; loop0++) {
            for (int spatial_i_1 = 0; spatial_i_1 < spatial_len_1;
                 spatial_i_1++) {
                addr_in = base_ptr_local + loop1 * tempStride1 +
                          loop0 * tempStride0 + spatial_i_1 * spatialStride1;
                addr_In = base_ptr_l2 + loop1 * tempLoop0 * spatial_len +
                          loop0 * spatial_len + spatial_i_1 * spatial_len_1;
                snrt_dma_start_1d(addr_in, addr_In,
                                  spatial_len_0 * sizeof(int8_t));
            }
        }
    }
}

uint32_t check_data_reshuffler_result(int tempLoop0, int tempLoop1,
                                      int tempStride0, int tempStride1,
                                      int spatialStride1,
                                      int8_t* base_ptr_local,
                                      int8_t* base_ptr_l2) {
    int8_t* addr_out;
    int8_t* addr_Out;
    uint32_t error = 0;

    for (int loop1 = 0; loop1 < tempLoop1; loop1++) {
        for (int loop0 = 0; loop0 < tempLoop0; loop0++) {
            for (int spatial_i_1 = 0; spatial_i_1 < spatial_len_1;
                 spatial_i_1++) {
                for (int spatial_i_0 = 0; spatial_i_0 < spatial_len_0;
                     spatial_i_0++) {
                    addr_out = base_ptr_local + loop1 * tempStride1 +
                               loop0 * tempStride0 +
                               spatial_i_1 * spatialStride1 + spatial_i_0;
                    addr_Out = base_ptr_l2 + loop1 * tempLoop0 * spatial_len +
                               loop0 * spatial_len +
                               spatial_i_1 * spatial_len_1 + spatial_i_0;
                    if ((int8_t)*addr_out != (int8_t)*addr_Out) {
                        printf(
                            "Error: after reshuffle addr_out = %d at address "
                            "%x, golden addr_Out = %d at address %x \n",
                            (int8_t)*addr_out, addr_out, (int8_t)*addr_Out,
                            addr_Out);
                        error++;
                    }
                }
            }
        }
    }

    return error;
}

void load_a_chrunk_of_data(int8_t* base_ptr_local, int8_t* base_ptr_l2,
                           int len) {
    snrt_dma_start_1d(base_ptr_local, base_ptr_l2, len * sizeof(int8_t));
}

uint32_t test_a_chrunk_of_data(int8_t* base_ptr_local, int8_t* base_ptr_l2,
                               int len) {
    uint32_t error = 0;
    for (int i = 0; i < len; i++) {
        if ((int8_t)base_ptr_local[i] != (int8_t)base_ptr_l2[i]) {
            printf(
                "Error: after reshuffle base_ptr_local[%d] = %d, golden "
                "base_ptr_l2[%d] = %d \n",
                i, (int8_t)base_ptr_local[i], i, (int8_t)base_ptr_l2[i]);
            error++;
        }
    }
    return error;
}
