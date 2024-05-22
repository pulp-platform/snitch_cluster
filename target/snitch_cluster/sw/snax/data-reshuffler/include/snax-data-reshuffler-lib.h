// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include <stdbool.h>
#include "snrt.h"
#include "stdint.h"

#pragma once

#define spatial_len_0 8
#define spatial_len_1 8
#define spatial_len (spatial_len_0 * spatial_len_1)

// Set STREAMER configuration CSR
void set_data_reshuffler_csr(int tempLoop0, int tempLoop1, int tempStride0_in,
                             int tempStride1_in, int spatialStride1_in,
                             int tempStride0_out, int tempStride1_out,
                             int spatialStride1_out, int32_t delta_local_in,
                             int32_t delta_local_out, bool transpose);

// Set CSR to start STREAMER
void start_streamer();

void wait_streamer();

void start_data_reshuffler();

void wait_data_reshuffler();

uint32_t read_data_reshuffler_perf_counter();

void load_data_reshuffler_test_data(int tempLoop0, int tempLoop1,
                                    int tempStride0, int tempStride1,
                                    int spatialStride1, int8_t* base_ptr_local,
                                    int8_t* base_ptr_l2);

uint32_t check_data_reshuffler_result(int tempLoop0, int tempLoop1,
                                      int tempStride0, int tempStride1,
                                      int spatialStride1,
                                      int8_t* base_ptr_local,
                                      int8_t* base_ptr_l2);
