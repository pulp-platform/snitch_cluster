// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

#include "snrt.h"

#include <stdbool.h>
#include "stdint.h"

// Accelerator Register Addresses
#define ALU_RW_MODE 978
#define ALU_RW_DATALEN 979
#define ALU_RW_START 980
#define ALU_RO_BUSY 981
#define ALU_RO_PERF_COUNT 982

// Streamer functions
void configure_streamer_a(uint32_t base_ptr_low, uint32_t base_ptr_high,
                          uint32_t spatial_stride, uint32_t temporal_bound,
                          uint32_t temporal_stride);

void configure_streamer_b(uint32_t base_ptr_low, uint32_t base_ptr_high,
                          uint32_t spatial_stride, uint32_t temporal_bound,
                          uint32_t temporal_stride);

void configure_streamer_o(uint32_t base_ptr_low, uint32_t base_ptr_high,
                          uint32_t spatial_stride, uint32_t temporal_bound,
                          uint32_t temporal_stride);

void start_streamer(void);

uint32_t read_busy_streamer(void);

// Accelerator functions
void configure_alu(uint32_t mode, uint32_t data_len);

void start_alu(void);

uint32_t read_busy_alu(void);
