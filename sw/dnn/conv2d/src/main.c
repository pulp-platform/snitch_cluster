// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// SW testbench for profiling Conv2d Layer
// Automatically checks the correctness of the results

#include "conv2d.h"
#include "dnn.h"
#include "snrt.h"

#include "data.h"

int main() {
    layer.ifmap = (double*)conv2d_ifmap_dram;
    layer.weights = (double*)conv2d_weights_dram;
    layer.ofmap = (double*)conv2d_ofmap_dram;
    layer.TILE_CI = min(32, layer.CI);
    layer.pad = (layer.FH - 1) / 2;
    layer.cluster2cluster = 0;

    const conv_layer l1_conv2d_l = layer;

    uint32_t cycles, dma_busy;

    if (snrt_global_core_idx() == 0) {
        snrt_reset_perf_counter(SNRT_PERF_CNT0);
        snrt_reset_perf_counter(SNRT_PERF_CNT1);
        snrt_start_perf_counter(SNRT_PERF_CNT0, SNRT_PERF_CNT_CYCLES, 0);
        snrt_start_perf_counter(SNRT_PERF_CNT1, SNRT_PERF_CNT_DMA_BUSY, 0);
    }

    conv2d_layer(&l1_conv2d_l);

    if (snrt_global_core_idx() == 0) {
        snrt_stop_perf_counter(SNRT_PERF_CNT0);
        snrt_stop_perf_counter(SNRT_PERF_CNT1);

        cycles = snrt_get_perf_counter(SNRT_PERF_CNT0);
        dma_busy = snrt_get_perf_counter(SNRT_PERF_CNT1);
        // printf("perf: %d/%d dma/total\n", dma_busy, cycles);
    }

    snrt_global_barrier();

    return 0;
}
