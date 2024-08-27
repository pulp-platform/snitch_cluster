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
    uint32_t *tcdm_baseaddress = (uint32_t *)snrt_l1_next();
    // Put the input at the starting of tcdm
    uint8_t *tcdm_in = tcdm_baseaddress;
    // Put the output at the middle of tcdm
    uint8_t *tcdm_out = tcdm_in + 0x10000 * sizeof(uint8_t);

    if (snrt_is_dm_core()) {
        // The xdma core is the last compute core in the cluster
        uint32_t stride_src[3] = {8, 8, 512};
        uint32_t bound_src[3] = {8, 3, 3};
        uint32_t stride_dst[1] = {8};
        uint32_t bound_dst[1] = {8};

        // First we need to transfer the input data from L3->TCDM
        // Here we use the 2d iDMA transfer
        dma_load_input_start = snrt_mcycle();
        snrt_dma_start_2d(
            tcdm_in, padded_data_in, padded_W * Cin * sizeof(uint8_t),
            512 * sizeof(uint8_t), padded_W * Cin * sizeof(uint8_t),
            padded_H * sizeof(uint8_t));
        snrt_dma_wait_all();
        dma_load_input_end = snrt_mcycle();

        // --------------------- Configure the Ext --------------------- //

        // There are three extensions in xdma
        // VerilogMemset, Maxpool, Transposer
        // 0            , 1      , 2
        // We want to only use Maxpool
        // Hence we need to disable the 0 and 2
        // and we set the maxpool csr to 9 since we need 3x3 pooling
        if (xdma_disable_dst_ext(0) != 0) {
            printf("Error in disabling xdma extension 0\n");
            err++;
        } else {
            printf("The xdma extension 0 is disabled\n");
        }

        uint32_t ext_param_maxpool_size[1] = {9};
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
        uint8_t *local_src_pointer;
        uint8_t *local_dst_pointer;
        int task_id;
        for (int i = 0; i < out_H; i++) {
            for (int j = 0; j < out_W / 8; j++) {
                local_src_pointer = tcdm_in + j * 64 + i * 512;
                local_dst_pointer = tcdm_out + j * 64 + i * 256;
                if (xdma_memcpy_nd(local_src_pointer, local_dst_pointer, 3, 1,
                                   stride_src, stride_dst, bound_src, bound_dst,
                                   0xFF) != 0) {
                    printf("Error in xdma agu configuration\n");
                    err++;
                } else {
                    printf("The xdma agu is configured\n");
                }
                int task_id = xdma_start();
                xdma_wait(task_id);
                printf("i = %d, j = %d is done\n", i, j);
            }
        }

        // --------------------- Checking the Results --------------------- //
        printf("Checking the results\n");
        for (int i = 0; i < out_H * out_W * Cin; i++) {
            if ((int8_t)tcdm_out[i] != golden_data_out[i]) {
                printf("The maxpool is incorrect!\n");
                printf("tcdm_out[%d]=%d, golden_data_out[%d]=%d", i,
                       (int8_t)tcdm_out[i], i, golden_data_out[i]);
            }
        }
        printf("Checking is done. All values are right\n");
    }

    return 0;
}