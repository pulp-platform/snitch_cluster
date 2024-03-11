// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "data.h"

#include "snax-gemm-lib.h"

#include "snax-streamer-gemm-lib.h"

int main() {
    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    int8_t *local_a, *local_b;
    int32_t* local_c;

    // Allocate space in TCDM
    local_a = (int8_t*)(snrt_l1_next() + delta_local_a);
    local_b = (int8_t*)(snrt_l1_next() + delta_local_b);
    local_c = (int32_t*)(snrt_l1_next() + delta_local_c);

    uint32_t dma_pre_load = snrt_mcycle();

    // Transfer data from L3 to L1
    // Using DMA only
    if (snrt_is_dm_core()) {
        load_input_data(Batch, M, K, N, local_a, local_b, A, B,
                        strideInnermostA, strideInnermostB, ldA, ldB, strideA,
                        strideB);
    }

    // Wait for DMA to finish
    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        uint32_t gemm_start = snrt_mcycle();

        // Set Streamer configuration CSR
        set_streamer_csr(K, N, M, strideInnermostA, ldA, strideInnermostB, ldB,
                         strideInnermostC, ldC, delta_local_a, delta_local_b,
                         delta_local_c);
        // Set CSR to start Streamer
        set_streamer_start();

        // Set GEMM configuration CSR
        uint32_t subtraction_setting =
            gen_subtraction_config(subtraction_a, subtraction_b);

        set_block_gemm_csr(K, N, M, subtraction_setting);
        // Set CSR to start GEMM
        set_block_gemm_start();

        // Poll until Streamer and GEMM accelerator finish
        wait_streamer_gemm();

        uint32_t gemm_end = snrt_mcycle();

        // Compare SNAX GEMM result with golden model
        err += check_result(local_c, C_golden, Batch, M, N, strideInnermostC,
                            ldC, strideC);
    };

    return err;
}
