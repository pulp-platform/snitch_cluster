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

void hypercorex_set_inst_loop_count(uint8_t config1, uint8_t config2,
                                    uint8_t config3);

void hypercorex_start_core(void);

uint32_t hypercorex_is_core_busy(void);
