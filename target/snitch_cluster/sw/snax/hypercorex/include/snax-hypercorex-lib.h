// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Header file for functions in snax-hypercorex-lib.c
//-------------------------------

#pragma once
#include <stdbool.h>
#include "snax-hypercorex-csr.h"
#include "snrt.h"
#include "stdint.h"

//-------------------------------
// Streamer functions
//-------------------------------
void hypercorex_set_streamer_lowdim_a(uint32_t loop_bound_0,
                                      uint32_t loop_bound_1,
                                      uint32_t temp_stride_0,
                                      uint32_t temp_stride_1,
                                      uint32_t spat_stride, uint32_t base_ptr);

void hypercorex_set_streamer_lowdim_b(uint32_t loop_bound_0,
                                      uint32_t loop_bound_1,
                                      uint32_t temp_stride_0,
                                      uint32_t temp_stride_1,
                                      uint32_t spat_stride, uint32_t base_ptr);

void hypercorex_set_streamer_highdim_a(uint32_t loop_bound_0,
                                       uint32_t loop_bound_1,
                                       uint32_t temp_stride_0,
                                       uint32_t temp_stride_1,
                                       uint32_t spat_stride, uint32_t base_ptr);

void hypercorex_set_streamer_highdim_b(uint32_t loop_bound_0,
                                       uint32_t loop_bound_1,
                                       uint32_t temp_stride_0,
                                       uint32_t temp_stride_1,
                                       uint32_t spat_stride, uint32_t base_ptr);

void hypercorex_set_streamer_highdim_am(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr);

void hypercorex_set_streamer_lowdim_predict(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr);

void hypercorex_set_streamer_highdim_qhv(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr);

void hypercorex_start_streamer(void);

uint32_t hypercorex_read_perf_counter(void);

uint32_t hypercorex_is_streamer_busy(void);

//-------------------------------
// HyperCoreX accelerator functions
//-------------------------------

void hypercorex_load_inst(uint32_t inst_size, uint32_t start_addr,
                          uint32_t* inst_list);

void hypercorex_set_inst_loop_jump_addr(uint8_t config1, uint8_t config2,
                                        uint8_t config3);

void hypercorex_set_inst_loop_end_addr(uint8_t config1, uint8_t config2,
                                       uint8_t config3);

void hypercorex_set_inst_loop_count(uint8_t config1, uint8_t config2,
                                    uint8_t config3);
