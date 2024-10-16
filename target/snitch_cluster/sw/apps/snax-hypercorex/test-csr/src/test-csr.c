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

#include "snrt.h"

#include "data.h"
#include "snax-hypercorex-lib.h"
#include "streamer_csr_addr_map.h"

int main() {
    // Set err value for checking
    int err = 0;

    if (snrt_is_compute_core()) {
        //-------------------------------
        // Set streamer registers
        //-------------------------------
        hypercorex_set_streamer_lowdim_a(
            test_streamer_test_val1, test_streamer_test_val2,
            test_streamer_test_val3, test_streamer_test_val4,
            test_streamer_test_val5, test_streamer_test_val6,
            test_streamer_test_val7);

        hypercorex_set_streamer_lowdim_b(
            test_streamer_test_val1, test_streamer_test_val2,
            test_streamer_test_val3, test_streamer_test_val4,
            test_streamer_test_val5, test_streamer_test_val6,
            test_streamer_test_val7);

        hypercorex_set_streamer_highdim_a(
            test_streamer_test_val1, test_streamer_test_val2,
            test_streamer_test_val3, test_streamer_test_val4,
            test_streamer_test_val5, test_streamer_test_val6,
            test_streamer_test_val7);

        hypercorex_set_streamer_highdim_b(
            test_streamer_test_val1, test_streamer_test_val2,
            test_streamer_test_val3, test_streamer_test_val4,
            test_streamer_test_val5, test_streamer_test_val6,
            test_streamer_test_val7);

        hypercorex_set_streamer_highdim_am(
            test_streamer_test_val1, test_streamer_test_val2,
            test_streamer_test_val3, test_streamer_test_val4,
            test_streamer_test_val5, test_streamer_test_val6,
            test_streamer_test_val7);

        hypercorex_set_streamer_lowdim_predict(
            test_streamer_test_val1, test_streamer_test_val2,
            test_streamer_test_val3, test_streamer_test_val4,
            test_streamer_test_val5, test_streamer_test_val6,
            test_streamer_test_val7);

        hypercorex_set_streamer_highdim_qhv(
            test_streamer_test_val1, test_streamer_test_val2,
            test_streamer_test_val3, test_streamer_test_val4,
            test_streamer_test_val5, test_streamer_test_val6,
            test_streamer_test_val7);

        // Write to observable CSR for visibile state
        write_csr_obs(0x001);

        //-------------------------------
        // Read from streamer RW registers
        //-------------------------------

        // Lowdim A
        if (csrr_ss(BASE_PTR_READER_0_LOW) != golden_streamer_test_val1) {
            err += 1;
        };

        if (csrr_ss(BASE_PTR_READER_0_HIGH) != golden_streamer_test_val2) {
            err += 1;
        };

        if (csrr_ss(S_STRIDE_READER_0_0) != golden_streamer_test_val3) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_0_0) != golden_streamer_test_val4) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_0_1) != golden_streamer_test_val5) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_0_0) != golden_streamer_test_val6) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_0_1) != golden_streamer_test_val7) {
            err += 1;
        };

        // Lowdim B
        if (csrr_ss(BASE_PTR_READER_1_LOW) != golden_streamer_test_val1) {
            err += 1;
        };

        if (csrr_ss(BASE_PTR_READER_1_HIGH) != golden_streamer_test_val2) {
            err += 1;
        };

        if (csrr_ss(S_STRIDE_READER_1_0) != golden_streamer_test_val3) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_1_0) != golden_streamer_test_val4) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_1_1) != golden_streamer_test_val5) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_1_0) != golden_streamer_test_val6) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_1_1) != golden_streamer_test_val7) {
            err += 1;
        };

        // Highdim A
        if (csrr_ss(BASE_PTR_READER_2_LOW) != golden_streamer_test_val1) {
            err += 1;
        };

        if (csrr_ss(BASE_PTR_READER_2_HIGH) != golden_streamer_test_val2) {
            err += 1;
        };

        if (csrr_ss(S_STRIDE_READER_2_0) != golden_streamer_test_val3) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_2_0) != golden_streamer_test_val4) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_2_1) != golden_streamer_test_val5) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_2_0) != golden_streamer_test_val6) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_2_1) != golden_streamer_test_val7) {
            err += 1;
        };

        // Highdim B
        if (csrr_ss(BASE_PTR_READER_3_LOW) != golden_streamer_test_val1) {
            err += 1;
        };

        if (csrr_ss(BASE_PTR_READER_3_HIGH) != golden_streamer_test_val2) {
            err += 1;
        };

        if (csrr_ss(S_STRIDE_READER_3_0) != golden_streamer_test_val3) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_3_0) != golden_streamer_test_val4) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_3_1) != golden_streamer_test_val5) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_3_0) != golden_streamer_test_val6) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_3_1) != golden_streamer_test_val7) {
            err += 1;
        };

        // Highdim AM
        if (csrr_ss(BASE_PTR_READER_4_LOW) != golden_streamer_test_val1) {
            err += 1;
        };

        if (csrr_ss(BASE_PTR_READER_4_HIGH) != golden_streamer_test_val2) {
            err += 1;
        };

        if (csrr_ss(S_STRIDE_READER_4_0) != golden_streamer_test_val3) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_4_0) != golden_streamer_test_val4) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_READER_4_1) != golden_streamer_test_val5) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_4_0) != golden_streamer_test_val6) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_READER_4_1) != golden_streamer_test_val7) {
            err += 1;
        };

        // Lowdim Predict
        if (csrr_ss(BASE_PTR_WRITER_0_LOW) != golden_streamer_test_val1) {
            err += 1;
        };

        if (csrr_ss(BASE_PTR_WRITER_0_HIGH) != golden_streamer_test_val2) {
            err += 1;
        };

        if (csrr_ss(S_STRIDE_WRITER_0_0) != golden_streamer_test_val3) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_WRITER_0_0) != golden_streamer_test_val4) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_WRITER_0_1) != golden_streamer_test_val5) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_WRITER_0_0) != golden_streamer_test_val6) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_WRITER_0_1) != golden_streamer_test_val7) {
            err += 1;
        };

        // Highdim QHV
        if (csrr_ss(BASE_PTR_WRITER_1_LOW) != golden_streamer_test_val1) {
            err += 1;
        };

        if (csrr_ss(BASE_PTR_WRITER_1_HIGH) != golden_streamer_test_val2) {
            err += 1;
        };

        if (csrr_ss(S_STRIDE_WRITER_1_0) != golden_streamer_test_val3) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_WRITER_1_0) != golden_streamer_test_val4) {
            err += 1;
        };

        if (csrr_ss(T_BOUND_WRITER_1_1) != golden_streamer_test_val5) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_WRITER_1_0) != golden_streamer_test_val6) {
            err += 1;
        };

        if (csrr_ss(T_STRIDE_WRITER_1_1) != golden_streamer_test_val7) {
            err += 1;
        };

        // Need to check if performance counters are 0
        if (hypercorex_read_perf_counter() != 0) {
            err += 1;
        };

        // Need to check if streamer is busy
        if (hypercorex_is_streamer_busy() != 0) {
            err += 1;
        };

        // Write to observable CSR for visibile state
        write_csr_obs(0x002);

        //-------------------------------
        // Write to several Hypercorex registers
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

        // Write to observable CSR for visibile state
        write_csr_obs(0x003);

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

        // Write to observable CSR for visibile state
        write_csr_obs(0x004);
    };

    return err;
}
