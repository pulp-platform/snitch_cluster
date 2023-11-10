// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "dnn.h"

#include "data.h"

int main() {
    layernorm_layer_t *layer_cfg = snrt_l1alloc(sizeof(*layer_cfg));
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d((void *)layer_cfg, (void *)&layer, sizeof(*layer_cfg));
    }
    layernorm_layer(layer);
    return 0;
}
