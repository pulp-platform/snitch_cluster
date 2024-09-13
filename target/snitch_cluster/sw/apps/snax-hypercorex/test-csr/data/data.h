// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Author: Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Program: Hypercorex Test CSRs Header File
//
// This program is to test the capabilities
// of the HyperCoreX accelerator's CSRs so the test is
// to check if registers are working as intended.
//
// This includes checking for RW, RO, and WO registers.
//-------------------------------

#include "snax-hypercorex-lib.h"
#include "snrt.h"

//-------------------------------
// Test values
//-------------------------------

// Test values for streamer RW
uint32_t test_streamer_test_val1 = 0xffffffff;
uint32_t test_streamer_test_val2 = 0x1234abcd;
uint32_t test_streamer_test_val3 = 0xdeadbeef;
uint32_t test_streamer_test_val4 = 0x01010101;
uint32_t test_streamer_test_val5 = 0x55551111;
uint32_t test_streamer_test_val6 = 0x7189cdef;
uint32_t test_streamer_test_val7 = 0x1f9d39a0;

// Need to leave core_config LSB as 0
// Since it starts the core
// All the rest should be okay
uint32_t test_core_config = 0xfffffffe;
uint32_t test_am_num_predict = 0xffffffff;
uint32_t test_am_predict = 0xffffffff;
uint32_t test_inst_ctrl = 0xffffffff;

uint32_t test_inst_write_addr = 0xffffffff;
uint32_t test_inst_write_data = 0xffffffff;
uint32_t test_inst_rddbg_addr = 0xffffffff;
uint32_t test_inst_pc_addr = 0xffffffff;
uint32_t test_inst_inst_at_addr = 0xffffffff;

uint32_t test_inst_loop_ctrl = 0xffffffff;
uint32_t test_inst_loop_jump_addr1 = 0xff;
uint32_t test_inst_loop_jump_addr2 = 0xff;
uint32_t test_inst_loop_jump_addr3 = 0xff;
uint32_t test_inst_loop_end_addr1 = 0xff;
uint32_t test_inst_loop_end_addr2 = 0xff;
uint32_t test_inst_loop_end_addr3 = 0xff;
uint32_t test_inst_loop_count1 = 0xff;
uint32_t test_inst_loop_count2 = 0xff;
uint32_t test_inst_loop_count3 = 0xff;

//-------------------------------
// Golden values
//-------------------------------

// Test values for streamer RW
uint32_t golden_streamer_test_val1 = 0xffffffff;
uint32_t golden_streamer_test_val2 = 0x1234abcd;
uint32_t golden_streamer_test_val3 = 0xdeadbeef;
uint32_t golden_streamer_test_val4 = 0x01010101;
uint32_t golden_streamer_test_val5 = 0x55551111;
uint32_t golden_streamer_test_val6 = 0x7189cdef;
uint32_t golden_streamer_test_val7 = 0x1f9d39a0;

uint32_t golden_core_config = 0x0000003c;
uint32_t golden_am_num_predict = 0xffffffff;
uint32_t golden_am_predict = 0x00000000;
uint32_t golden_inst_ctrl = 0x00000003;

uint32_t golden_inst_write_addr = 0x00000000;
uint32_t golden_inst_write_data = 0x00000000;
uint32_t golden_inst_rddbg_addr = 0xffffffff;
uint32_t golden_inst_pc_addr = 0x00000000;
uint32_t golden_inst_at_addr = 0xffffffff;

uint32_t golden_inst_loop_ctrl = 0x00000003;
uint32_t golden_inst_loop_jump_addr = 0x001fffff;
uint32_t golden_inst_loop_end_addr = 0x001fffff;
uint32_t golden_inst_loop_count = 0x001fffff;
