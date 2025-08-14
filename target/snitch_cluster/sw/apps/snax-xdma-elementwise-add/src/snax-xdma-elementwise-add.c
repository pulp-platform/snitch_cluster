// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Jonas Crols <jonas.crols@student.kuleuven.be>

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
    // Put the first input at the starting of tcdm
    void *tcdm_in1 = (void *)tcdm_baseaddress;
    // Put the second input at the end of tcdm
    void *tcdm_in2 =
        (void *)(tcdm_baseaddress +
                 (matrix1_size * sizeof(input_matrix1[0]) * 8 + 7) / 8);

    // Put the output at the middle of tcdm
    void *tcdm_out =
        (void *)(tcdm_baseaddress +
                 (matrix1_size * sizeof(input_matrix1[0]) * 8 + 7) / 8 +
                 (matrix2_size * sizeof(input_matrix2[0]) * 8 + 7) / 8);

    printf("tcdm_out: %p\n", tcdm_out);

    if (snrt_is_dm_core()) {
        // First we need to transfer the input data from L3->TCDM
        snrt_dma_start_1d(tcdm_in1, input_matrix1,
                          matrix1_size * sizeof(input_matrix1[0]));
        snrt_dma_wait_all();

        snrt_dma_start_1d(tcdm_in2, input_matrix2,
                          matrix2_size * sizeof(input_matrix2[0]));
        snrt_dma_wait_all();

        // --------------------- Configure the Ext --------------------- //
        uint32_t xdma_csr_amount_of_tensors = 2;
        uint32_t ext_param[1] = {xdma_csr_amount_of_tensors};
        if (xdma_disable_src_ext(0) != 0) {
            printf("Error in disabling reader xdma extension 0\n");
            err++;
        }

        if (xdma_enable_src_ext(1, ext_param) != 0) {
            printf("Error in enabling reader xdma extension 1\n");
            err++;
        }

        if (xdma_disable_src_ext(2) != 0) {
            printf("Error in disabling reader xdma extension 2\n");
            err++;
        }

        if (xdma_disable_src_ext(3) != 0) {
            printf("Error in disabling reader xdma extension 3\n");
            err++;
        }

        if (xdma_disable_src_ext(4) != 0) {
            printf("Error in disabling reader xdma extension 4\n");
            err++;
        }

        if (xdma_disable_dst_ext(0) != 0) {
            printf("Error in disabling writer xdma extension 0\n");
            err++;
        }

        if (xdma_disable_dst_ext(1) != 0) {
            printf("Error in disabling writer xdma extension 1\n");
            err++;
        }

        // --------------------- Configure the AGU --------------------- //
        xdma_memcpy_nd(tcdm_in1, tcdm_out, spatial_stride_src,
                       spatial_stride_dst, temporal_dimension_src,
                       temporal_strides_src, temporal_bounds_src,
                       temporal_dimension_dst, temporal_strides_dst,
                       temporal_bounds_dst, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);
        printf("xdma_memcpy_nd done\n");
        int task_id = xdma_start();
        printf("got out of xdma_start, csr address: %d\n", task_id);
        xdma_local_wait(task_id);
        printf("xdma task %d is done in %d cycles\n", task_id,
               xdma_last_task_cycle());

        // --------------------- Checking the Results --------------------- //
        uint16_t *golden_result = (uint16_t *)golden_output_matrix;
        uint16_t *tcdm_result = (uint16_t *)tcdm_out;
        uint16_t *tcdm_src1 = (uint16_t *)tcdm_in1;
        uint16_t *tcdm_src2 = (uint16_t *)tcdm_in2;

        for (int i = 0; i < matrix1_size * sizeof(input_matrix1[0]) / 2; i++) {
            if (tcdm_result[i] != golden_result[i]) {
                printf("The sum is incorrect at byte %d! \n", i << 2);
            }
        }
        printf("Checking is done. All values are right\n");
    }

    return 0;
}
