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

    conv2d_layer(&l1_conv2d_l);

    snrt_global_barrier();

    return 0;
}
