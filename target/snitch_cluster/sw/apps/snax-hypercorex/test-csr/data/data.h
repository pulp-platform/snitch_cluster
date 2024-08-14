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

uint32_t test_seed_cim = 0x1234abcd;
uint32_t test_seed_ortho_0 = 0xffffffff;
uint32_t test_seed_ortho_1 = 0x01010101;
uint32_t test_seed_ortho_2 = 0xabcd1234;
uint32_t test_seed_ortho_3 = 0xaaaabbbb;
uint32_t test_seed_ortho_4 = 0x99999999;
uint32_t test_seed_ortho_5 = 0xc0debeef;
uint32_t test_seed_ortho_6 = 0xbebebaba;
uint32_t test_seed_ortho_7 = 0x12345678;

//-------------------------------
// Golden values
//-------------------------------

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

uint32_t golden_seed_cim = 0x1234abcd;
uint32_t golden_seed_ortho_0 = 0xffffffff;
uint32_t golden_seed_ortho_1 = 0x01010101;
uint32_t golden_seed_ortho_2 = 0xabcd1234;
uint32_t golden_seed_ortho_3 = 0xaaaabbbb;
uint32_t golden_seed_ortho_4 = 0x99999999;
uint32_t golden_seed_ortho_5 = 0xc0debeef;
uint32_t golden_seed_ortho_6 = 0xbebebaba;
uint32_t golden_seed_ortho_7 = 0x12345678;
