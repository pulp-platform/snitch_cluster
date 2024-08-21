// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Author: Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Library: Functions for Setting Hypecorex CSRs
//
// This pre-built library contains functions to set
// the HyperCoreX accelerator's CSRs.
//-------------------------------

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
                                      uint32_t spat_stride, uint32_t base_ptr) {
    csrw_ss(HYPERCOREX_LOOP_BOUND0_LOWDIM_A, loop_bound_0);
    csrw_ss(HYPERCOREX_LOOP_BOUND1_LOWDIM_A, loop_bound_1);
    csrw_ss(HYPERCOREX_TEMP_STRIDE0_LOWDIM_A, temp_stride_0);
    csrw_ss(HYPERCOREX_TEMP_STRIDE1_LOWDIM_A, temp_stride_1);
    csrw_ss(HYPERCOREX_SPAT_STRIDE_LOWDIM_A, spat_stride);
    csrw_ss(HYPERCOREX_BASE_PTR_LOWDIM_A, base_ptr);
    return;
};

void hypercorex_set_streamer_lowdim_b(uint32_t loop_bound_0,
                                      uint32_t loop_bound_1,
                                      uint32_t temp_stride_0,
                                      uint32_t temp_stride_1,
                                      uint32_t spat_stride, uint32_t base_ptr) {
    csrw_ss(HYPERCOREX_LOOP_BOUND0_LOWDIM_B, loop_bound_0);
    csrw_ss(HYPERCOREX_LOOP_BOUND1_LOWDIM_B, loop_bound_1);
    csrw_ss(HYPERCOREX_TEMP_STRIDE0_LOWDIM_B, temp_stride_0);
    csrw_ss(HYPERCOREX_TEMP_STRIDE1_LOWDIM_B, temp_stride_1);
    csrw_ss(HYPERCOREX_SPAT_STRIDE_LOWDIM_B, spat_stride);
    csrw_ss(HYPERCOREX_BASE_PTR_LOWDIM_B, base_ptr);
    return;
};

void hypercorex_set_streamer_highdim_a(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr) {
    csrw_ss(HYPERCOREX_LOOP_BOUND0_HIGHDIM_A, loop_bound_0);
    csrw_ss(HYPERCOREX_LOOP_BOUND1_HIGHDIM_A, loop_bound_1);
    csrw_ss(HYPERCOREX_TEMP_STRIDE0_HIGHDIM_A, temp_stride_0);
    csrw_ss(HYPERCOREX_TEMP_STRIDE1_HIGHDIM_A, temp_stride_1);
    csrw_ss(HYPERCOREX_SPAT_STRIDE_HIGHDIM_A, spat_stride);
    csrw_ss(HYPERCOREX_BASE_PTR_HIGHDIM_A, base_ptr);
    return;
};

void hypercorex_set_streamer_highdim_b(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr) {
    csrw_ss(HYPERCOREX_LOOP_BOUND0_HIGHDIM_B, loop_bound_0);
    csrw_ss(HYPERCOREX_LOOP_BOUND1_HIGHDIM_B, loop_bound_1);
    csrw_ss(HYPERCOREX_TEMP_STRIDE0_HIGHDIM_B, temp_stride_0);
    csrw_ss(HYPERCOREX_TEMP_STRIDE1_HIGHDIM_B, temp_stride_1);
    csrw_ss(HYPERCOREX_SPAT_STRIDE_HIGHDIM_B, spat_stride);
    csrw_ss(HYPERCOREX_BASE_PTR_HIGHDIM_B, base_ptr);
    return;
};

void hypercorex_set_streamer_highdim_am(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr) {
    csrw_ss(HYPERCOREX_LOOP_BOUND0_HIGHDIM_AM, loop_bound_0);
    csrw_ss(HYPERCOREX_LOOP_BOUND1_HIGHDIM_AM, loop_bound_1);
    csrw_ss(HYPERCOREX_TEMP_STRIDE0_HIGHDIM_AM, temp_stride_0);
    csrw_ss(HYPERCOREX_TEMP_STRIDE1_HIGHDIM_AM, temp_stride_1);
    csrw_ss(HYPERCOREX_SPAT_STRIDE_HIGHDIM_AM, spat_stride);
    csrw_ss(HYPERCOREX_BASE_PTR_HIGHDIM_AM, base_ptr);
    return;
};

void hypercorex_set_streamer_lowdim_predict(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr) {
    csrw_ss(HYPERCOREX_LOOP_BOUND0_LOWDIM_PREDICT, loop_bound_0);
    csrw_ss(HYPERCOREX_LOOP_BOUND1_LOWDIM_PREDICT, loop_bound_1);
    csrw_ss(HYPERCOREX_TEMP_STRIDE0_LOWDIM_PREDICT, temp_stride_0);
    csrw_ss(HYPERCOREX_TEMP_STRIDE1_LOWDIM_PREDICT, temp_stride_1);
    csrw_ss(HYPERCOREX_SPAT_STRIDE_LOWDIM_PREDICT, spat_stride);
    csrw_ss(HYPERCOREX_BASE_PTR_LOWDIM_PREDICT, base_ptr);
    return;
};

void hypercorex_set_streamer_highdim_qhv(
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1, uint32_t spat_stride, uint32_t base_ptr) {
    csrw_ss(HYPERCOREX_LOOP_BOUND0_HIGHDIM_QHV, loop_bound_0);
    csrw_ss(HYPERCOREX_LOOP_BOUND1_HIGHDIM_QHV, loop_bound_1);
    csrw_ss(HYPERCOREX_TEMP_STRIDE0_HIGHDIM_QHV, temp_stride_0);
    csrw_ss(HYPERCOREX_TEMP_STRIDE1_HIGHDIM_QHV, temp_stride_1);
    csrw_ss(HYPERCOREX_SPAT_STRIDE_HIGHDIM_QHV, spat_stride);
    csrw_ss(HYPERCOREX_BASE_PTR_HIGHDIM_QHV, base_ptr);
    return;
};

void hypercorex_start_streamer(void) {
    csrw_ss(HYPERCORES_STREAMER_START, 1);
    return;
};

uint32_t hypercorex_read_perf_counter(void) {
    return csrr_ss(HYPERCORES_STREAMER_PERF_COUNTER);
};

uint32_t hypercorex_is_streamer_busy(void) {
    return csrr_ss(HYPERCORES_STREAMER_BUSY);
};

//-------------------------------
// Instruction loading functions
//-------------------------------

void hypercorex_load_inst(uint32_t inst_size, uint32_t start_addr,
                          uint32_t* inst_list) {
    // First enable instruction write mode
    csrw_ss(HYPERCOREX_INST_CTRL_REG_ADDR, 0x00000001);

    // Set starting address
    csrw_ss(HYPERCOREX_INST_WRITE_ADDR_REG_ADDR, start_addr);

    // Load all instructions
    for (uint32_t i = 0; i < inst_size; i++) {
        csrw_ss(HYPERCOREX_INST_WRITE_DATA_REG_ADDR, inst_list[i]);
    };

    // Disable instruction write mode and reset PC
    csrw_ss(HYPERCOREX_INST_CTRL_REG_ADDR, 0x00000004);

    return;
};

//-------------------------------
// Instruction loop control functions
//
// These isntructions take in 7 bits per configuration
// and packs them into one 32-bit register
// Upper MSBs are tied to 0s
//
// Note: This is a parameter that changes
// depending on how large the instruction memory is
//-------------------------------

void hypercorex_set_inst_loop_jump_addr(uint8_t config1, uint8_t config2,
                                        uint8_t config3) {
    uint32_t config =
        ((config3 & 0x7f) << 14) | ((config2 & 0x7f) << 7) | (config1 & 0x7f);

    csrw_ss(HYPERCOREX_INST_LOOP_JUMP_ADDR_REG_ADDR, config);
    return;
};

void hypercorex_set_inst_loop_end_addr(uint8_t config1, uint8_t config2,
                                       uint8_t config3) {
    uint32_t config =
        ((config3 & 0x7f) << 14) | ((config2 & 0x7f) << 7) | (config1 & 0x7f);

    csrw_ss(HYPERCOREX_INST_LOOP_END_ADDR_REG_ADDR, config);
    return;
};

void hypercorex_set_inst_loop_count(uint8_t config1, uint8_t config2,
                                    uint8_t config3) {
    uint32_t config =
        ((config3 & 0x7f) << 14) | ((config2 & 0x7f) << 7) | (config1 & 0x7f);

    csrw_ss(HYPERCOREX_INST_LOOP_COUNT_REG_ADDR, config);
    return;
};

//-------------------------------
// Writing to orthogonal IM seeds
//-------------------------------
void hypercorex_set_im_base_seed(uint32_t im_idx, uint32_t config) {
    csrw_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + im_idx, config);
    return;
};
