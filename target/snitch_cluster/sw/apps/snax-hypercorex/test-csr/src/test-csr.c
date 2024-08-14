// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Author: Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Program: Hypercorex Test CSRs
//
// This program is to test the capabilities
// of the HyperCoreX accelerator's CSRs so the test is
// to check if registers are working as intended.
//
// This includes checking for RW, RO, and WO registers.
//-------------------------------

#include "data.h"
#include "snax-hypercorex-lib.h"
#include "snrt.h"

int main() {
    // Set err value for checking
    int err = 0;

    if (snrt_is_compute_core()) {
        //-------------------------------
        // Write to several registers
        //-------------------------------

        // Write to core configurations
        csrw_ss(HYPERCOREX_CORE_SET_REG_ADDR, test_core_config);
        csrw_ss(HYPERCOREX_AM_NUM_PREDICT_REG_ADDR, test_am_num_predict);
        csrw_ss(HYPERCOREX_AM_PREDICT_REG_ADDR, test_am_predict);

        // Write to instruction control configurations
        csrw_ss(HYPERCOREX_INST_CTRL_REG_ADDR, test_inst_ctrl);
        csrw_ss(HYPERCOREX_INST_WRITE_ADDR_REG_ADDR, test_inst_write_addr);
        csrw_ss(HYPERCOREX_INST_WRITE_DATA_REG_ADDR, test_inst_write_data);
        csrw_ss(HYPERCOREX_INST_RDDBG_ADDR_REG_ADDR, test_inst_rddbg_addr);
        csrw_ss(HYPERCOREX_INST_PC_ADDR_REG_ADDR, test_inst_pc_addr);
        csrw_ss(HYPERCOREX_INST_INST_AT_ADDR_ADDR_REG_ADDR,
                test_inst_inst_at_addr);

        // Write to instruction loop configurations
        csrw_ss(HYPERCOREX_INST_LOOP_CTRL_REG_ADDR, test_inst_loop_ctrl);

        hypercorex_set_inst_loop_jump_addr(test_inst_loop_jump_addr1,
                                           test_inst_loop_jump_addr2,
                                           test_inst_loop_jump_addr3);

        hypercorex_set_inst_loop_end_addr(test_inst_loop_end_addr1,
                                          test_inst_loop_end_addr2,
                                          test_inst_loop_end_addr3);

        hypercorex_set_inst_loop_count(test_inst_loop_count1,
                                       test_inst_loop_count2,
                                       test_inst_loop_count3);

        // Write to seed configurations
        csrw_ss(HYPERCOREX_CIM_SEED_REG_ADDR, test_seed_cim);

        hypercorex_set_im_base_seed(0, test_seed_ortho_0);
        hypercorex_set_im_base_seed(1, test_seed_ortho_1);
        hypercorex_set_im_base_seed(2, test_seed_ortho_2);
        hypercorex_set_im_base_seed(3, test_seed_ortho_3);
        hypercorex_set_im_base_seed(4, test_seed_ortho_4);
        hypercorex_set_im_base_seed(5, test_seed_ortho_5);
        hypercorex_set_im_base_seed(6, test_seed_ortho_6);
        hypercorex_set_im_base_seed(7, test_seed_ortho_7);

        //-------------------------------
        // Read from registers if they have correct values
        // All golden values are synthetic just to see
        // if the settings are correct or not.
        //
        // This tests all RW, RO, and WO registers
        // but of course, according to how the accelerator was built
        //-------------------------------
        if (csrr_ss(HYPERCOREX_CORE_SET_REG_ADDR) != golden_core_config) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_AM_NUM_PREDICT_REG_ADDR) !=
            golden_am_num_predict) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_AM_PREDICT_REG_ADDR) != golden_am_predict) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_CTRL_REG_ADDR) != golden_inst_ctrl) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_WRITE_ADDR_REG_ADDR) !=
            golden_inst_write_addr) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_WRITE_DATA_REG_ADDR) !=
            golden_inst_write_data) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_RDDBG_ADDR_REG_ADDR) !=
            golden_inst_rddbg_addr) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_PC_ADDR_REG_ADDR) != golden_inst_pc_addr) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_INST_AT_ADDR_ADDR_REG_ADDR) !=
            golden_inst_at_addr) {
            err = 1;
        };

        if (csrr_ss(HYPERCOREX_INST_LOOP_CTRL_REG_ADDR) !=
            golden_inst_loop_ctrl) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_LOOP_JUMP_ADDR_REG_ADDR) !=
            golden_inst_loop_jump_addr) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_LOOP_END_ADDR_REG_ADDR) !=
            golden_inst_loop_end_addr) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_INST_LOOP_COUNT_REG_ADDR) !=
            golden_inst_loop_count) {
            err += 1;
        }

        if (csrr_ss(HYPERCOREX_CIM_SEED_REG_ADDR) != golden_seed_cim) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR) != golden_seed_ortho_0) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + 1) !=
            golden_seed_ortho_1) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + 2) !=
            golden_seed_ortho_2) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + 3) !=
            golden_seed_ortho_3) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + 4) !=
            golden_seed_ortho_4) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + 5) !=
            golden_seed_ortho_5) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + 6) !=
            golden_seed_ortho_6) {
            err += 1;
        };

        if (csrr_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + 7) !=
            golden_seed_ortho_7) {
            err += 1;
        };
    };

    return err;
}
