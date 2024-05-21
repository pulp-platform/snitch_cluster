// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"

#pragma once

// the spatial unrolling of simd
#define VEC_LEN 64

// generate the configuration for CSR0
int32_t gen_csr0_config(uint8_t input_zp_i, uint8_t output_zp_i,
                        uint8_t shift_i, uint8_t max_int_i);

// generate the configuration for CSR1
int32_t gen_csr1_config(uint8_t min_int_i, bool double_round_i);

// generate the configuration for CSR2
int32_t gen_csr2_config(uint32_t multiplier_i);

// set the configuration for the streamer
void set_streamer_simd_csr(int tempLoop0, int tempLoop1, int tempStride0_in,
                           int tempStride1_in, int tempStride0_out,
                           int tempStride1_out, int32_t delta_local_in,
                           int32_t delta_local_out);

// start the streamer
void start_streamer_simd();

// set the configuration for the SIMD
void set_simd_csr(uint32_t csr0, uint32_t csr1, uint32_t csr2,
                  uint32_t temporal_loop_bound);

// start the SIMD
void start_simd();

// wait for the streamer to finish
void wait_streamer_simd();

// Read performance counter of streamer for SIMD, a read-only CSR
uint32_t read_simd_streamer_perf_counter();

// Read status of SIMD, a read-only CSR. If this resgiter is one, the SIMD is
// still working
uint32_t read_simd_state();

// Read performance counter of SIMD, a read-only CSR
uint32_t read_simd_perf_counter();

// load the test data into TCDM
void load_simd_test_data(int tempLoop0, int tempLoop1, int tempStride0,
                         int tempStride1, int32_t* base_ptr_local,
                         int32_t* base_ptr_l2);

// c specification of the post processing
int8_t scale_quant_clamp_c_spec(int32_t input, int8_t input_zp,
                                int8_t output_zp, int32_t multiplier,
                                int8_t shift,  // values between 0-63
                                int8_t max_int, int8_t min_int,
                                bool double_round);

// check the result of the SIMD
uint32_t check_simd_result(int tempLoop0, int tempLoop1, int tempStride0,
                           int tempStride1, int8_t* base_ptr_local,
                           int8_t* base_ptr_l2);
