// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "dnn.h"
#include "snrt.h"

#include "data.h"

void *share_ptr;

int main() {
    uint32_t ifmap_size =
        (layer.dim_in_x + layer.padding_x_left + layer.padding_x_right) *
        (layer.dim_in_y + layer.padding_y_top + layer.padding_y_bottom) *
        layer.ch_in;
    uint32_t weights_size =
        layer.dim_kernel_x * layer.dim_kernel_y * layer.ch_in * layer.ch_out;
    uint32_t ofmap_size = layer.dim_out_x * layer.dim_out_y * layer.ch_out;

    uint32_t total_size =
        ifmap_size + weights_size + layer.ch_out + layer.ch_out + ofmap_size;

    float *ptr;

    if (snrt_is_dm_core() == 0) {
        ptr = snrt_l1_alloc(total_size * sizeof(float));
        share_ptr = ptr;
    }

    snrt_cluster_hw_barrier();

    ptr = share_ptr;

    float *pInBuffer = ptr;
    ptr += ifmap_size;
    float *pWeight = ptr;
    ptr += weights_size;
    float *kappa = ptr;
    ptr += layer.ch_out;
    float *lambda = ptr;
    ptr += layer.ch_out;
    float *pOutBuffer = ptr;
    ptr += ofmap_size;

    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(pInBuffer, fusedconv_pInBuffer_dram,
                          ifmap_size * sizeof(float));
        snrt_dma_start_1d(pWeight, fusedconv_pWeight_dram,
                          weights_size * sizeof(float));
        snrt_dma_start_1d(pOutBuffer, fusedconv_pOutBuffer_dram,
                          ofmap_size * sizeof(float));
        snrt_dma_start_1d(kappa, fusedconv_kappa_dram,
                          sizeof(fusedconv_kappa_dram));
        snrt_dma_start_1d(lambda, fusedconv_lambda_dram,
                          sizeof(fusedconv_lambda_dram));
        snrt_dma_wait_all();
    }

    layer.pInBuffer = pInBuffer;
    layer.pWeight = pWeight;
    layer.pOutBuffer = pOutBuffer;
    layer.kappa = kappa;
    layer.lambda = lambda;

    snrt_cluster_hw_barrier();

    for (int i = 0; i < 1; i++) {
        if (snrt_is_compute_core() || (snrt_cluster_core_num() == 1)) {
            if (dw) {
                snrt_mcycle();
                conv2d_dw_fp32(&layer);
                snrt_mcycle();

            } else if (chw_layer) {
                snrt_mcycle();
                conv2d_chw_fp32(&layer);
                snrt_mcycle();
            } else {
                snrt_mcycle();
                conv2d_fp32(&layer);
                snrt_mcycle();
            }

        } else {
            // conv kernel has 1 cluster barrier to synchronize
            snrt_cluster_hw_barrier();
        }
    }
    snrt_cluster_hw_barrier();

    return 0;
}