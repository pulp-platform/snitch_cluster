// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "data.h"

#include "snax-gemm-lib.h"

#include "snax-gemm-params.h"

// This tests the following:
// 1) Generate random data with gendata.py
// 2) Allocate space in TCDM
// 3) Write data from L3 to TCDM
// 4) Configure the csrs for performing a block GEMM
// 5) Launch the accelerator
// 6) Wait until the accelerator finishes
// 7) Check the result of the CPU and the accelerator vs the golden model
// (gendata.py)

int main() {
    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    int8_t *local_a, *local_b;
    int32_t* local_c;

    // Allocate space in TCDM
    local_a = (int8_t*)snrt_l1_next();
    local_b = local_a + delta_local_a * sizeof(int8_t);
    local_c = (int32_t*)(local_b + delta_local_b * sizeof(int8_t));

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
        // Pack matrix size setting to one CSR
        uint32_t size_setting = gen_size_config(Batch, M, K, N);

        uint32_t gemm_start = snrt_mcycle();

        // Set GEMM configuration CSR
        set_batch_gemm(size_setting, local_a, local_b, local_c,
                       strideInnermostA, strideInnermostB, strideInnermostC,
                       ldA, ldB, ldC, strideA, strideB, strideC);

        // Set CSR to start GEMM and poll until GEMM accelerator finishes
        start_batch_gemm();
        wait_batch_gemm();

        uint32_t gemm_end = snrt_mcycle();

        // Compare SNAX GEMM result with golden model
        err += check_result(local_c, C_golden, Batch, M, N, strideInnermostC,
                            ldC, strideC);
    };

    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        // Also perform calculation on CPU

        // Read the mcycle CSR (this is our way to mark/delimit a specific code
        // region for benchmarking)
        uint32_t start_cycle = snrt_mcycle();

        batch_gemm_cpu(Batch, M, K, N, local_a, local_b, C_cpu,
                       strideInnermostA, strideInnermostB, strideInnermostC,
                       ldA, ldB, ldC, strideA, strideB, strideC);

        // Read the mcycle CSR
        uint32_t end_cycle = snrt_mcycle();
        // Compare CPU result with golden model
        err += check_result(C_cpu, C_golden, Batch, M, N, strideInnermostC, ldC,
                            strideC);
    }

    return err;
}
