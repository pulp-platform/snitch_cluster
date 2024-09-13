// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Ryan Antonio <ryan.antonio@esat.kuleuven.be>

#include "snax-alu-lib.h"
#include "streamer_csr_addr_map.h"

//-----------------------
// Streamer functions
//-----------------------
void configure_streamer_a(uint32_t base_ptr_low, uint32_t base_ptr_high,
                          uint32_t spatial_stride, uint32_t temporal_bound,
                          uint32_t temporal_stride) {
    csrw_ss(BASE_PTR_READER_0_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_READER_0_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_READER_0_0, spatial_stride);
    csrw_ss(T_BOUND_READER_0_0, temporal_bound);
    csrw_ss(T_STRIDE_READER_0_0, temporal_stride);
    return;
};

void configure_streamer_b(uint32_t base_ptr_low, uint32_t base_ptr_high,
                          uint32_t spatial_stride, uint32_t temporal_bound,
                          uint32_t temporal_stride) {
    csrw_ss(BASE_PTR_READER_1_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_READER_1_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_READER_1_0, spatial_stride);
    csrw_ss(T_BOUND_READER_1_0, temporal_bound);
    csrw_ss(T_STRIDE_READER_1_0, temporal_stride);
    return;
};

void configure_streamer_o(uint32_t base_ptr_low, uint32_t base_ptr_high,
                          uint32_t spatial_stride, uint32_t temporal_bound,
                          uint32_t temporal_stride) {
    csrw_ss(BASE_PTR_WRITER_0_LOW, base_ptr_low);
    csrw_ss(BASE_PTR_WRITER_0_HIGH, base_ptr_high);
    csrw_ss(S_STRIDE_WRITER_0_0, spatial_stride);
    csrw_ss(T_BOUND_WRITER_0_0, temporal_bound);
    csrw_ss(T_STRIDE_WRITER_0_0, temporal_stride);
    return;
};

void start_streamer(void) {
    csrw_ss(STREAMER_START_CSR, 1);
    return;
};

uint32_t read_busy_streamer(void) { return csrr_ss(STREAMER_BUSY_CSR); };

//-----------------------
// Accelerator functions
//-----------------------
void configure_alu(uint32_t mode, uint32_t data_len) {
    csrw_ss(ALU_RW_MODE, mode);
    csrw_ss(ALU_RW_DATALEN, data_len);
    return;
};

void start_alu(void) {
    csrw_ss(ALU_RW_START, 1);
    return;
};

uint32_t read_busy_alu(void) { return csrr_ss(ALU_RO_BUSY); };
