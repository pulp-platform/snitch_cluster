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

#include "snax-hypercorex-lib.h"
#include "streamer_csr_addr_map.h"

//-------------------------------
// Streamer functions
//-------------------------------
void hypercorex_set_streamer_lowdim_a(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1) {
    csrw_ss(BASE_PTR_READER_0_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_READER_0_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_READER_0_0, spat_stride);
    csrw_ss(T_BOUND_READER_0_0, loop_bound_0);
    csrw_ss(T_BOUND_READER_0_1, loop_bound_1);
    csrw_ss(T_STRIDE_READER_0_0, temp_stride_0);
    csrw_ss(T_STRIDE_READER_0_1, temp_stride_1);
    return;
};

void hypercorex_set_streamer_lowdim_b(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1) {
    csrw_ss(BASE_PTR_READER_1_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_READER_1_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_READER_1_0, spat_stride);
    csrw_ss(T_BOUND_READER_1_0, loop_bound_0);
    csrw_ss(T_BOUND_READER_1_1, loop_bound_1);
    csrw_ss(T_STRIDE_READER_1_0, temp_stride_0);
    csrw_ss(T_STRIDE_READER_1_1, temp_stride_1);
    return;
};

void hypercorex_set_streamer_highdim_a(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1) {
    csrw_ss(BASE_PTR_READER_2_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_READER_2_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_READER_2_0, spat_stride);
    csrw_ss(T_BOUND_READER_2_0, loop_bound_0);
    csrw_ss(T_BOUND_READER_2_1, loop_bound_1);
    csrw_ss(T_STRIDE_READER_2_0, temp_stride_0);
    csrw_ss(T_STRIDE_READER_2_1, temp_stride_1);
    return;
};

void hypercorex_set_streamer_highdim_b(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1) {
    csrw_ss(BASE_PTR_READER_3_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_READER_3_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_READER_3_0, spat_stride);
    csrw_ss(T_BOUND_READER_3_0, loop_bound_0);
    csrw_ss(T_BOUND_READER_3_1, loop_bound_1);
    csrw_ss(T_STRIDE_READER_3_0, temp_stride_0);
    csrw_ss(T_STRIDE_READER_3_1, temp_stride_1);
    return;
};

void hypercorex_set_streamer_highdim_am(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1) {
    csrw_ss(BASE_PTR_READER_4_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_READER_4_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_READER_4_0, spat_stride);
    csrw_ss(T_BOUND_READER_4_0, loop_bound_0);
    csrw_ss(T_BOUND_READER_4_1, loop_bound_1);
    csrw_ss(T_STRIDE_READER_4_0, temp_stride_0);
    csrw_ss(T_STRIDE_READER_4_1, temp_stride_1);
    return;
};

void hypercorex_set_streamer_lowdim_predict(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1) {
    csrw_ss(BASE_PTR_WRITER_0_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_WRITER_0_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_WRITER_0_0, spat_stride);
    csrw_ss(T_BOUND_WRITER_0_0, loop_bound_0);
    csrw_ss(T_BOUND_WRITER_0_1, loop_bound_1);
    csrw_ss(T_STRIDE_WRITER_0_0, temp_stride_0);
    csrw_ss(T_STRIDE_WRITER_0_1, temp_stride_1);
    return;
};

void hypercorex_set_streamer_highdim_qhv(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1) {
    csrw_ss(BASE_PTR_WRITER_1_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_WRITER_1_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_WRITER_1_0, spat_stride);
    csrw_ss(T_BOUND_WRITER_1_0, loop_bound_0);
    csrw_ss(T_BOUND_WRITER_1_1, loop_bound_1);
    csrw_ss(T_STRIDE_WRITER_1_0, temp_stride_0);
    csrw_ss(T_STRIDE_WRITER_1_1, temp_stride_1);
    return;
};

void hypercorex_start_streamer(void) {
    csrw_ss(STREAMER_START_CSR, 1);
    return;
};

uint32_t hypercorex_is_streamer_busy(void) {
    return csrr_ss(STREAMER_BUSY_CSR);
};

uint32_t hypercorex_read_perf_counter(void) {
    return csrr_ss(STREAMER_PERFORMANCE_COUNTER_CSR);
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

void hypercorex_start_core(void) {
    csrw_ss(HYPERCOREX_CORE_SET_REG_ADDR, 1);
    return;
};

uint32_t hypercorex_is_core_busy(void) {
    return csrr_ss(HYPERCOREX_CORE_SET_REG_ADDR);
};
