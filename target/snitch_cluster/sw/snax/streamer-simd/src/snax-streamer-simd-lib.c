// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "snax-streamer-simd-lib.h"

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

void set_streamer_simd_csr(int tempLoop0, int tempLoop1, int tempStride0_in,
                           int tempStride1_in, int tempStride0_out,
                           int tempStride1_out, int32_t delta_local_in,
                           int32_t delta_local_out) {
    // temporal loop bounds, from innermost to outermost
    write_csr(960 + 0, tempLoop0);
    write_csr(960 + 1, tempLoop1);

    // temporal strides for data reader (In)
    write_csr(960 + 2, tempStride0_in);
    write_csr(960 + 3, tempStride1_in);

    // temporal strides for data writer (Out)
    write_csr(960 + 4, tempStride0_out);
    write_csr(960 + 5, tempStride1_out);

    // fixed spatial strides for data reader (In)
    write_csr(960 + 6, 4);
    write_csr(960 + 7, 32);

    // fixed spatial strides for data writer (Out)
    write_csr(960 + 8, 1);
    write_csr(960 + 9, 8);

    // base ptr for data reader (In)
    write_csr(960 + 10, (uint32_t)(delta_local_in + snrt_l1_next()));

    // base ptr for data writer (Out)
    write_csr(960 + 11, (uint32_t)(delta_local_out + snrt_l1_next()));
}

void start_streamer_simd() { write_csr(960 + 12, 1); }

void set_simd_csr(uint32_t csr0, uint32_t csr1, uint32_t csr2,
                  uint32_t temporal_loop_bound) {
    // set the constants for the SIMD unit
    write_csr(960 + 14, csr0);
    write_csr(960 + 15, csr1);
    write_csr(960 + 16, csr2);

    // set the temporal loop bound
    write_csr(960 + 17, temporal_loop_bound);
}

void start_simd() { write_csr(960 + 18, 1); }

void wait_streamer_simd() {
    write_csr(960 + 18, 0);
    write_csr(960 + 12, 0);
}

uint32_t read_simd_streamer_perf_counter() {
    uint32_t perf_counter = read_csr(960 + 13);
    return perf_counter;
}

// Read status of SIMD, a read-only CSR. If this resgiter is one, the SIMD is
// still working
uint32_t read_simd_state() {
    uint32_t status = read_csr(960 + 19);
    return status;
}

uint32_t read_simd_perf_counter() {
    uint32_t perf_counter = read_csr(960 + 20);
    return perf_counter;
}

void load_simd_test_data(int tempLoop0, int tempLoop1, int tempStride0,
                         int tempStride1, int32_t* base_ptr_local,
                         int32_t* base_ptr_l2) {
    int32_t* addr_in;
    int32_t* addr_In;

    for (int loop1 = 0; loop1 < tempLoop1; loop1++) {
        for (int loop0 = 0; loop0 < tempLoop0; loop0++) {
            addr_in =
                base_ptr_local +
                (loop1 * tempStride1 + loop0 * tempStride0) / sizeof(int32_t);
            addr_In =
                base_ptr_l2 + loop1 * tempLoop0 * VEC_LEN + loop0 * VEC_LEN;
            snrt_dma_start_1d(addr_in, addr_In, VEC_LEN * sizeof(int32_t));
        }
    }
}

int8_t scale_quant_clamp_c_spec(int32_t input, int8_t input_zp,
                                int8_t output_zp, int32_t multiplier,
                                int8_t shift,  // values between 0-63
                                int8_t max_int, int8_t min_int,
                                bool double_round) {
    // input zero-point adjustment
    input = input - input_zp;

    // multiplication
    int64_t var0 = (int64_t)input * (int64_t)multiplier;

    // shift & round
    int32_t var1 = var0 >> (shift - 1);

    if (double_round) {
        if (var1 >= 0)
            var1 += 1;
        else
            var1 -= 1;
    }
    var1 = var1 >> 1;

    // output zero-point adjustment
    var1 = var1 + output_zp;

    // clamping
    if (var1 > max_int) var1 = max_int;
    if (var1 < min_int) var1 = min_int;

    int8_t result = (int8_t)var1;
    return result;
}

uint32_t check_simd_result(int tempLoop0, int tempLoop1, int tempStride0,
                           int tempStride1, int8_t* base_ptr_local,
                           int8_t* base_ptr_l2) {
    int8_t* addr_out;
    int8_t* addr_Out;
    uint32_t error = 0;

    for (int loop1 = 0; loop1 < tempLoop1; loop1++) {
        for (int loop0 = 0; loop0 < tempLoop0; loop0++) {
            for (int i = 0; i < VEC_LEN; i++) {
                addr_out = base_ptr_local +
                           (loop1 * tempStride1 + loop0 * tempStride0) + i;
                addr_Out = base_ptr_l2 + loop1 * tempLoop0 * VEC_LEN +
                           loop0 * VEC_LEN + i;
                if ((int8_t)*addr_out != (int8_t)*addr_Out) {
                    error++;
                }
            }
        }
    }
    return error;
}
