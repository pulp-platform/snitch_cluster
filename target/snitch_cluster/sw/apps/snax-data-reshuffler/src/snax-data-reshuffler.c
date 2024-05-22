// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Xiaoling Yi <xiaoling.yi@esat.kuleuven.be>

#include "data.h"
#include "printf.h"

#include "snax-data-reshuffler-lib.h"

int main() {
    uint32_t CORE_IDX = snrt_cluster_core_idx();

    // Set err value for checking
    int err = 0;

    // Prepare addresses in TCDM
    int8_t* local_in;
    int8_t* local_out;

    // Allocate space in TCDM
    local_in = (int8_t*)(snrt_l1_next() + delta_local_in);
    local_out = (int8_t*)(snrt_l1_next() + delta_local_out);

    // uint32_t dma_pre_load = snrt_mcycle();

    // Transfer data from L3 to L1
    // Using DMA only
    if (snrt_is_dm_core()) {
        load_data_reshuffler_test_data(tempLoop0, tempLoop1, DMAtempStride0_in,
                                       DMAtempStride1_in, DMAspatialStride1_in,
                                       local_in, DataIn);
    }

    // Wait for DMA to finish
    snrt_cluster_hw_barrier();

    uint32_t data_reshuffler_cycle;

    if (CORE_IDX == 0) {
        // Set data-reshuffler configuration CSR
        set_data_reshuffler_csr(tempLoop0, tempLoop1, tempStride0_in,
                                tempStride1_in, spatialStride1_in,
                                tempStride0_out, tempStride1_out,
                                spatialStride1_out, (int32_t)delta_local_in,
                                (int32_t)delta_local_out, transpose);

        // Set CSR to start data-reshuffler
        start_data_reshuffler();
        start_streamer();

        // Wait for data-reshuffler to finish
        wait_data_reshuffler();
        wait_streamer();

        // Compare SNAX data-reshuffler result with golden python model
        err += check_data_reshuffler_result(
            tempLoop0, tempLoop1, tempStride0_out, tempStride1_out,
            spatialStride1_out, local_out, C_golden);
    };

    return err;
}
