// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "data.h"

#include "snax-gemm-lib.h"
#include "snax-gemm-params.h"

#include "snax-streamer-gemm-add-c-lib.h"

void load_C(uint8_t Batch, uint8_t M, uint8_t N, int32_t* local_c, int32_t* C,
            uint32_t strideInnermostC, uint32_t ldC, uint32_t strideC) {
    int32_t* addr_C;
    int32_t* addr_c;

    snrt_dma_start_1d(local_c, C, M * N * meshRow * meshCol * sizeof(int32_t));
}

int main() {
    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    int8_t *local_a, *local_b;
    int32_t *local_c, *local_d;

    // Allocate space in TCDM
    local_a = (int8_t*)(snrt_l1_next() + delta_local_a);
    local_b = (int8_t*)(snrt_l1_next() + delta_local_b);
    local_c = (int32_t*)(snrt_l1_next() + delta_local_c);
    local_d = (int32_t*)(snrt_l1_next() + delta_local_d);

    int8_t *cur_A, *cur_B;
    int32_t* cur_C;
    cur_A = A;
    cur_B = B;
    cur_C = C;

    for (int m = 0; m < M2; m++) {
        for (int n = 0; n < N2; n++) {
            for (int k = 0; k < K2; k++) {
                // Transfer data from L3 to L1
                // Using DMA only
                cur_A = A + m * K2 * M * K * meshRow * tileSize +
                        k * M * K * meshRow * tileSize;
                cur_B = B + n * K2 * N * K * tileSize * meshCol +
                        k * N * K * tileSize * meshCol;
                // attention! Continius data movement!
                // the strides must be set correctly!
                if (snrt_is_dm_core()) {
                    snrt_dma_start_1d(
                        local_a, cur_A,
                        M * K * meshRow * tileSize * sizeof(int8_t));
                    snrt_dma_start_1d(
                        local_b, cur_B,
                        N * K * tileSize * meshCol * sizeof(int8_t));
                }

                // Wait for DMA to finish
                snrt_cluster_hw_barrier();

                if (k == 0) {
                    if (snrt_is_dm_core()) {
                        // attention! Continius data movement!
                        // the strides must be set correctly!
                        snrt_dma_start_1d(
                            local_d, cur_C,
                            M * N * meshRow * meshCol * sizeof(int32_t));
                    }

                    // Wait for DMA to finish
                    snrt_cluster_hw_barrier();
                }

                snrt_cluster_hw_barrier();

                if (snrt_global_core_idx() == 0) {
                    // Set Streamer configuration CSR
                    set_streamer_csr(K, N, M, strideInnermostA, ldA, spatialA,
                                     strideInnermostB, ldB, spatialB,
                                     strideInnermostC, ldC, spatialC,
                                     delta_local_a, delta_local_b,
                                     delta_local_d, delta_local_d);
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
                };
            }

            snrt_cluster_hw_barrier();

            if (snrt_global_core_idx() == 0) {
                for (int i = 0; i < M * N * meshRow * meshCol; i++) {
                    if (local_d[i] !=
                        D_golden[i + m * N2 * M * N * meshRow * meshCol +
                                 n * M * N * meshRow * meshCol]) {
                        err++;
                    }
                }
                printf("GEMM on A * B + C finished. error: %d\n", err);
            }
        }
    }

    return err;
}
