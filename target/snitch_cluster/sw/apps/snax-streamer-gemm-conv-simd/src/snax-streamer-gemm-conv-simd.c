// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "data.h"

#include "snax-gemm-lib.h"
#include "snax-gemm-params.h"

#include "snax-streamer-gemm-lib.h"
#include "snax-streamer-simd-lib.h"

#include "snax-streamer-gemm-conv-simd-lib.h"

// This is the main function for the SNAX GEMM for Conv2d
// We use several nested loops to iterate over the input data and weights,
// achieving implicit im2col
int main() {
    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    int8_t *local_a, *local_b;
    int32_t *local_c, *local_d32;
    int8_t *local_d8;

    // Allocate space in TCDM
    local_a = (int8_t *)(snrt_l1_next() + delta_local_a);
    local_b = (int8_t *)(snrt_l1_next() + delta_local_b);
    local_c = (int32_t *)(snrt_l1_next() + delta_local_c);
    local_d32 = (int32_t *)(snrt_l1_next() + delta_local_d32);
    local_d8 = (int8_t *)(snrt_l1_next() + delta_local_d8);

    // Transfer data from L3 to L1
    // Using DMA only
    if (snrt_is_dm_core()) {
        load_conv_input_data(Nbatch, H + 2 * pad_h, W + 2 * pad_w, Cin, local_a,
                             A);
        load_weight_data(Cout, Kh, Kw, Cin, local_b, B);
    }

    // Wait for DMA to finish
    snrt_cluster_hw_barrier();

    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_c, C,
                          M * N * meshRow * meshCol * sizeof(int32_t));
    }

    snrt_cluster_hw_barrier();

    if (snrt_global_core_idx() == 0) {
        // Set Streamer configuration CSR for conv2d
        set_gemmx_streamer_csr(
            Aslstride0, Aslstride1, Atlbound0, Atlstride0, Atlbound1,
            Atlstride1, Atlbound2, Atlstride2, Atlbound3, Atlstride3, Atlbound4,
            Atlstride4, Atlbound5, Atlstride5,

            Bslstride0, Bslstride1, Btlbound0, Btlstride0, Btlbound1,
            Btlstride1, Btlbound2, Btlstride2,

            D8slstride0, D8slstride1, D8tlbound0, D8tlstride0, D8tlbound1,
            D8tlstride1, D8tlbound2, D8tlstride2,

            Cslstride0, Cslstride1, Ctlbound0, Ctlstride0, Ctlbound1,
            Ctlstride1, Ctlbound2, Ctlstride2,

            D32slstride0, D32slstride1, D32tlbound0, D32tlstride0, D32tlbound1,
            D32tlstride1, D32tlbound2, D32tlstride2,

            delta_local_a, delta_local_b, delta_local_d8, delta_local_c,
            delta_local_d32, bypassSIMD);

        // Set CSR to start Streamer for conv2d
        set_gemmx_streamer_start();

        // Set GEMM configuration CSR
        uint32_t subtraction_setting =
            gen_subtraction_config(subtraction_a, subtraction_b);

        uint32_t csr0 =
            gen_csr0_config(input_zp_i, output_zp_i, shift_i, max_int_i);
        uint32_t csr1 = gen_csr1_config(min_int_i, double_round_i);
        uint32_t csr2 = gen_csr2_config(multiplier_i);

        set_gemmx_csr(K, N, M, subtraction_setting, csr0, csr1, csr2, M * N,
                      bypassSIMD);

        // Set CSR to start GEMM
        set_gemmx_start();

        // Poll until Streamer and GEMM accelerator finish
        wait_gemmx_and_streamer();

        // check the result of the implicit im2col convolution
        if (!bypassSIMD) {
            err +=
                check_gemmx_result_D8(local_d8, D8_direct_conv2d, Batch, M, N);
        } else {
            err += check_gemmx_result_D32(local_d32, D32_direct_conv2d, Batch,
                                          M, N);
        }
        printf("SNAX GEMM Conv2d: %s, err = %d . bypassSIMD = %d .\n",
               err ? "FAIL" : "PASS", err, bypassSIMD);
    };

    return err;
}
