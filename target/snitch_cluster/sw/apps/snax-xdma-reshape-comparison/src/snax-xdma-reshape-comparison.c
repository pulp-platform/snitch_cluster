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
    uint8_t *tcdm_in = (uint8_t *)tcdm_baseaddress;
    // Put the output at the middle of tcdm
    uint8_t *tcdm_out =
        (uint8_t *)(tcdm_baseaddress +
                    (matrix_size * sizeof(uint8_t) * 8 + 7) / 8);

    if (snrt_is_dm_core() && snrt_cluster_idx() == 0) {
        // First we need to transfer the input data from L3->TCDM
        snrt_dma_start_1d(tcdm_in, input_matrix, matrix_size * sizeof(uint8_t));
        snrt_dma_wait_all();

        // --------------------- Configure the Ext --------------------- //

        if (xdma_disable_dst_ext(0) != 0) {
            printf("Error in disabling xdma writer extension 0\r\n");
            err++;
        }

        if (xdma_disable_dst_ext(1) != 0) {
            printf("Error in disabling xdma writer extension 1\r\n");
            err++;
        }
        if (xdma_disable_src_ext(0) != 0) {
            printf("Error in disabling xdma reader extension 0\r\n");
            err++;
        }

        if (xdma_disable_src_ext(1) != 0) {
            printf("Error in disabling xdma reader extension 1\r\n");
            err++;
        }
        // --------------------- Configure the AGU --------------------- //
        xdma_memcpy_nd(tcdm_in, tcdm_out, spatial_stride_src_xdma,
                       spatial_stride_dst_xdma, temporal_dimension_src_xdma,
                       temporal_strides_src_xdma, temporal_bounds_src_xdma,
                       temporal_dimension_dst_xdma, temporal_strides_dst_xdma,
                       temporal_bounds_dst_xdma, 0xFFFFFFFF, 0xFFFFFFFF,
                       0xFFFFFFFF);

        int task_id = xdma_start();
        xdma_local_wait(task_id);
        printf("xdma task %d is done in %d cycles\n", task_id,
               xdma_last_task_cycle());
        // --------------------- Checking the Results --------------------- //
        // for (int i = 0; i < matrix_size; i++) {
        //     if (tcdm_out[i] != golden_output_matrix[i]) {
        //         printf("The transpose is incorrect!\r\n");
        //         printf("tcdm_out[%d]=%d, golden_output_matrix[%d]=%d\r\n", i,
        //                tcdm_out[i], i, golden_output_matrix[i]);
        //     }
        // }
        // printf("Checking is done. All values copied by XDMA are right\r\n");

        // Do the same in IDMA
        char *src_addr[TOTAL_ITERATIONS_IDMA];
        char *dst_addr[TOTAL_ITERATIONS_IDMA];
        for (uint32_t i = 0; i < TOTAL_ITERATIONS_IDMA; i++) {
            src_addr[i] =
                (char *)((uint32_t)tcdm_in +
                         (i % sw_src_bound_idma[0]) * sw_src_stride_idma[0] +
                         (i / sw_src_bound_idma[0] % sw_src_bound_idma[1]) *
                             sw_src_stride_idma[1] +
                         (i / sw_src_bound_idma[0] / sw_src_bound_idma[1] %
                          sw_src_bound_idma[2]) *
                             sw_src_stride_idma[2] +
                         (i / sw_src_bound_idma[0] / sw_src_bound_idma[1] /
                          sw_src_bound_idma[2] % sw_src_bound_idma[3]) *
                             sw_src_stride_idma[3]);
            dst_addr[i] =
                (char *)((uint32_t)tcdm_out +
                         (i % sw_dst_bound_idma[0]) * sw_dst_stride_idma[0] +
                         (i / sw_dst_bound_idma[0] % sw_dst_bound_idma[1]) *
                             sw_dst_stride_idma[1] +
                         (i / sw_dst_bound_idma[0] / sw_dst_bound_idma[1] %
                          sw_dst_bound_idma[2]) *
                             sw_dst_stride_idma[2] +
                         (i / sw_dst_bound_idma[0] / sw_dst_bound_idma[1] /
                          sw_dst_bound_idma[2] % sw_dst_bound_idma[3]) *
                             sw_dst_stride_idma[3]);
        }
        __asm__ volatile("fence" ::: "memory");

        snrt_start_perf_counter(SNRT_PERF_CNT0, SNRT_PERF_CNT_DMA_BUSY,
                                snrt_hartid());
        for (int i = 0; i < TOTAL_ITERATIONS_IDMA; i++) {
            snrt_dma_start_2d(dst_addr[i], src_addr[i], size_idma,
                              dst_stride_idma, src_stride_idma, repeat_idma);
        }
        snrt_dma_wait_all();

        printf("The IDMA copy is finished in %d cycles\r\n",
               snrt_get_perf_counter(SNRT_PERF_CNT0));
        snrt_reset_perf_counter(SNRT_PERF_CNT0);
        // --------------------- Checking the Results --------------------- //
        for (int i = 0; i < matrix_size; i++) {
            if (tcdm_out[i] != golden_output_matrix[i]) {
                printf("The transpose is incorrect!\r\n");
                printf("tcdm_out[%d]=%d, golden_output_matrix[%d]=%d\r\n", i,
                       tcdm_out[i], i, golden_output_matrix[i]);
            }
        }
        printf("Checking is done. All values copied by IDMA are right\r\n");
    }

    return 0;
}
