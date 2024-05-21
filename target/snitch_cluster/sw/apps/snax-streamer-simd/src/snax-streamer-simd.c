// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "data.h"

#include "snax-streamer-simd-lib.h"

int main() {
    // Compute golden data from post-processing c spec
    if (snrt_is_compute_core()) {
        for (int loop1 = 0; loop1 < tempLoop1; loop1++) {
            for (int loop0 = 0; loop0 < tempLoop0; loop0++) {
                for (int i = 0; i < VEC_LEN; i++) {
                    C_golden_c_spec[loop1 * tempLoop0 * VEC_LEN +
                                    loop0 * VEC_LEN + i] =
                        scale_quant_clamp_c_spec(
                            DataIn[loop1 * tempLoop0 * VEC_LEN +
                                   loop0 * VEC_LEN + i],
                            input_zp_i, output_zp_i, multiplier_i, shift_i,
                            max_int_i, min_int_i, double_round_i);
                }
            }
        }
    }

    snrt_cluster_hw_barrier();

    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    int8_t* local_out;
    int32_t* local_in;

    // Allocate space in TCDM
    local_in = (int32_t*)(snrt_l1_next() + delta_local_in);
    local_out = (int8_t*)(snrt_l1_next() + delta_local_out);

    uint32_t dma_pre_load = snrt_mcycle();

    // Transfer data from L3 to L1
    // Using DMA only
    if (snrt_is_dm_core()) {
        load_simd_test_data(tempLoop0, tempLoop1, tempStride0_in,
                            tempStride1_in, local_in, DataIn);
    }

    // Wait for DMA to finish
    snrt_cluster_hw_barrier();

    uint32_t dma_post_load = snrt_mcycle();

    // using compute core to run the streamer-simd accelerator
    if (snrt_global_core_idx() == 0) {
        uint32_t simd_start = snrt_mcycle();

        // Set Streamer configuration CSR
        set_streamer_simd_csr(tempLoop0, tempLoop1, tempStride0_in,
                              tempStride1_in, tempStride0_out, tempStride1_out,
                              (int32_t)delta_local_in,
                              (int32_t)delta_local_out);

        // Set CSR to start Streamer
        start_streamer_simd();

        // Set simd configuration CSR
        uint32_t csr0 =
            gen_csr0_config(input_zp_i, output_zp_i, shift_i, max_int_i);
        uint32_t csr1 = gen_csr1_config(min_int_i, double_round_i);
        uint32_t csr2 = gen_csr2_config(multiplier_i);

        set_simd_csr(csr0, csr1, csr2, tempLoop0 * tempLoop1);

        // Set CSR to start simd
        start_simd();

        // Wait until Streamer and simd accelerator finish
        wait_streamer_simd();

        uint32_t simd_end = snrt_mcycle();

        // Compare SNAX streamer-simd result with golden python model
        err += check_simd_result(tempLoop0, tempLoop1, tempStride0_out,
                                 tempStride1_out, local_out, C_golden);
    };

    return err;
}
