// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Fanchen Kong <fanchen.kong@kuleuven.be>

#include "data.h"
#include "snax-xdma-lib.h"
#include "snrt.h"

int main() {
    // Set err value for checking
    int err = 0;
    // Obtain the start address of the TCDM memory
    uint32_t dma_load_input_start;
    uint32_t dma_load_input_end;
    uint32_t tcdm_baseaddress = snrt_cluster_base_addrl();
    // Put the input at the starting of tcdm
    uint8_t *tcdm_in = (uint8_t *)tcdm_baseaddress;
    // Put the output at the middle of tcdm
    uint8_t *tcdm_out = (uint8_t *)(tcdm_baseaddress + delta_local_out);

    if (snrt_is_dm_core()) {
        // The xdma core is the last compute core in the cluster
        uint32_t tstride_src[5] = {0};
        uint32_t tbound_src[5] = {0};
        uint32_t tstride_dst[3] = {0};
        uint32_t tbound_dst[3] = {0};

        // Load the CFG from data.h
        tstride_src[0] = tempStride0_in;
        tstride_src[1] = tempStride1_in;
        tstride_src[2] = tempStride2_in;
        tstride_src[3] = tempStride3_in;
        tstride_src[4] = tempStride4_in;
        tbound_src[0] = tempLoop0_in;
        tbound_src[1] = tempLoop1_in;
        tbound_src[2] = tempLoop2_in;
        tbound_src[3] = tempLoop3_in;
        tbound_src[4] = tempLoop4_in;
        tstride_dst[0] = tempStride0_out;
        tstride_dst[1] = tempStride1_out;
        tstride_dst[2] = tempStride2_out;
        tbound_dst[0] = tempLoop0_out;
        tbound_dst[1] = tempLoop1_out;
        tbound_dst[2] = tempLoop2_out;

        // First we need to transfer the input data from L3->TCDM
        snrt_dma_start_1d(tcdm_in, DataIn, input_data_len * sizeof(int8_t));
        snrt_dma_wait_all();

        // --------------------- Configure the Ext --------------------- //

        if (xdma_disable_dst_ext(0) != 0) {
            printf("Error in disabling xdma extension 0\n");
            err++;
        } else {
            printf("The xdma extension 0 is disabled\n");
        }

        uint32_t ext_param_maxpool_size[1] = {reduceLen};
        if (xdma_enable_dst_ext(1, ext_param_maxpool_size) != 0) {
            printf("Error in enabling xdma extension 1\n");
            err++;
        } else {
            printf("The xdma extension 1 is enabled\n");
        }

        if (xdma_disable_dst_ext(2) != 0) {
            printf("Error in disabling xdma extension 2\n");
            err++;
        } else {
            printf("The xdma extension 2 is disabled\n");
        }

        // --------------------- Configure the AGU --------------------- //
        xdma_memcpy_nd(tcdm_in, tcdm_out, spatialStride1_in, spatialStride1_out,
                       5, tstride_src, tbound_src, 3, tstride_dst, tbound_dst,
                       0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);
        int task_id = xdma_start();
        xdma_local_wait(task_id);

        // --------------------- Checking the Results --------------------- //
        for (int i = 0; i < output_data_len; i++) {
            if ((int8_t)tcdm_out[i] != C_golden[i]) {
                printf("The maxpool is incorrect!\n");
                printf("tcdm_out[%d]=%d, C_golden[%d]=%d", i,
                       (int8_t)tcdm_out[i], i, C_golden[i]);
            }
        }
        printf("Checking is done. All values are right\n");
    }

    return 0;
}
