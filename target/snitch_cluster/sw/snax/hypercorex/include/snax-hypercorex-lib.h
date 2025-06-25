// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Header file for functions in snax-hypercorex-lib.c
//-------------------------------

#include "snrt.h"

#include <stdbool.h>
#include "stdint.h"

//-------------------------------
// HyperCoreX accelerator register s
//-------------------------------
#define HYPERCOREX_CSR_OFFSET 1012
#define HYPERCOREX_CORE_SET_REG_ADDR (HYPERCOREX_CSR_OFFSET + 0)
#define HYPERCOREX_AM_NUM_PREDICT_REG_ADDR (HYPERCOREX_CSR_OFFSET + 1)
#define HYPERCOREX_AM_PREDICT_REG_ADDR (HYPERCOREX_CSR_OFFSET + 2)
#define HYPERCOREX_INST_CTRL_REG_ADDR (HYPERCOREX_CSR_OFFSET + 3)
#define HYPERCOREX_INST_WRITE_ADDR_REG_ADDR (HYPERCOREX_CSR_OFFSET + 4)
#define HYPERCOREX_INST_WRITE_DATA_REG_ADDR (HYPERCOREX_CSR_OFFSET + 5)
#define HYPERCOREX_INST_RDDBG_ADDR_REG_ADDR (HYPERCOREX_CSR_OFFSET + 6)
#define HYPERCOREX_INST_PC_ADDR_REG_ADDR (HYPERCOREX_CSR_OFFSET + 7)
#define HYPERCOREX_INST_INST_AT_ADDR_ADDR_REG_ADDR (HYPERCOREX_CSR_OFFSET + 8)
#define HYPERCOREX_INST_LOOP_CTRL_REG_ADDR (HYPERCOREX_CSR_OFFSET + 9)
#define HYPERCOREX_INST_LOOP_JUMP_ADDR_REG_ADDR (HYPERCOREX_CSR_OFFSET + 10)
#define HYPERCOREX_INST_LOOP_END_ADDR_REG_ADDR (HYPERCOREX_CSR_OFFSET + 11)
#define HYPERCOREX_INST_LOOP_COUNT_REG_ADDR (HYPERCOREX_CSR_OFFSET + 12)
#define HYPERCOREX_DATA_SLICE_CTRL (HYPERCOREX_CSR_OFFSET + 13)
#define HYPERCOREX_DATA_SLICE_NUM_ELEM_A (HYPERCOREX_CSR_OFFSET + 14)
#define HYPERCOREX_DATA_SLICE_NUM_ELEM_B (HYPERCOREX_CSR_OFFSET + 15)
#define HYPERCOREX_AUTO_COUNTER_START_A (HYPERCOREX_CSR_OFFSET + 16)
#define HYPERCOREX_AUTO_COUNTER_START_B (HYPERCOREX_CSR_OFFSET + 17)
#define HYPERCOREX_AUTO_COUNTER_NUM_A (HYPERCOREX_CSR_OFFSET + 18)
#define HYPERCOREX_AUTO_COUNTER_NUM_B (HYPERCOREX_CSR_OFFSET + 19)

//-------------------------------
// Streamer functions
//-------------------------------
void hypercorex_set_streamer_lowdim_a(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1);

void hypercorex_set_streamer_lowdim_b(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1);

void hypercorex_set_streamer_highdim_a(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1);

void hypercorex_set_streamer_highdim_b(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1);

void hypercorex_set_streamer_highdim_am(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1);

void hypercorex_set_streamer_lowdim_predict(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1);

void hypercorex_set_streamer_highdim_qhv(
    uint32_t base_ptr_low, uint32_t base_ptr_high, uint32_t spat_stride,
    uint32_t loop_bound_0, uint32_t loop_bound_1, uint32_t temp_stride_0,
    uint32_t temp_stride_1);

void hypercorex_start_streamer(void);

uint32_t hypercorex_is_streamer_busy(void);

uint32_t hypercorex_read_perf_counter(void);

//-------------------------------
// HyperCoreX accelerator functions
//-------------------------------

void hypercorex_load_inst(uint32_t inst_size, uint32_t start_addr,
                          uint32_t* inst_list);

void hypercorex_set_inst_loop_jump_addr(uint8_t config1, uint8_t config2,
                                        uint8_t config3);

void hypercorex_set_inst_loop_end_addr(uint8_t config1, uint8_t config2,
                                       uint8_t config3);

void hypercorex_set_inst_loop_count(uint32_t config1, uint32_t config2,
                                    uint32_t config3);

void hypercorex_set_data_slice_ctrl(uint8_t slice_ctrl_a, uint8_t slice_ctrl_b,
                                    uint8_t slice_src_a, uint8_t slice_src_b);

void hypercorex_set_data_slice_num_elem_a(uint32_t num_elem);

void hypercorex_set_data_slice_num_elem_b(uint32_t num_elem);

void hypercorex_set_auto_counter_start_a(uint32_t start_counter);

void hypercorex_set_auto_counter_start_b(uint32_t start_counter);

void hypercorex_set_auto_counter_num_a(uint32_t num_counter);

void hypercorex_set_auto_counter_num_b(uint32_t num_counter);

void hypercorex_start_core(void);

uint32_t hypercorex_is_core_busy(void);
