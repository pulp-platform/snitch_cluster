// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Yunhao Deng <yunhao.deng@kuleuven.be>

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
    void *tcdm_in = (void *)tcdm_baseaddress;
    // Put the output at the middle of tcdm
    void *tcdm_out =
        (void *)(tcdm_baseaddress +
                 (matrix_size * sizeof(input_matrix[0]) * 8 + 7) / 8);

    if (snrt_is_dm_core()) {
        // First we need to transfer the input data from L3->TCDM
        snrt_dma_start_1d(tcdm_in, input_matrix,
                          matrix_size * sizeof(input_matrix[0]));
        snrt_dma_wait_all();

        // --------------------- Configure the Ext --------------------- //

        if (xdma_disable_src_ext(0) != 0) {
            printf("Error in disabling reader xdma extension 0\n");
            err++;
        }

        if (xdma_disable_dst_ext(0) != 0) {
            printf("Error in disabling writer xdma extension 1\n");
            err++;
        }

        if (enable_transpose) {
            if (xdma_enable_dst_ext(1, (uint32_t *)transposer_param) != 0) {
                printf("Error in enabling xdma writer extension 1\n");
                err++;
            }
        } else {
            if (xdma_disable_dst_ext(1) != 0) {
                printf("Error in disabling xdma writer extension 1\n");
                err++;
            }
        }

        // --------------------- Configure the AGU --------------------- //
        xdma_memcpy_nd(tcdm_in, tcdm_out, spatial_stride_src,
                       spatial_stride_dst, temporal_dimension_src,
                       temporal_strides_src, temporal_bounds_src,
                       temporal_dimension_dst, temporal_strides_dst,
                       temporal_bounds_dst, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);

        uint32_t start_time;
        uint32_t end_time;

        __asm__ volatile("csrr %0, mcycle;" : "=r"(start_time));
        int task_id = xdma_start();
        xdma_local_wait(task_id);
        __asm__ volatile("csrr %0, mcycle;" : "=r"(end_time));
        printf("The XDMA copy is finished in %d cycles\r\n",
               end_time - start_time);

        // --------------------- Checking the Results --------------------- //
        uint32_t *golden_result = (uint32_t *)golden_output_matrix;
        uint32_t *tcdm_result = (uint32_t *)tcdm_out;

        for (int i = 0; i < matrix_size * sizeof(input_matrix[0]) / 4; i++) {
            if (tcdm_result[i] != golden_result[i]) {
                printf("The transpose is incorrect at byte %d! \n", i << 2);
            }
        }
        printf("Checking is done. All values are right\n");
    }

    return 0;
}
