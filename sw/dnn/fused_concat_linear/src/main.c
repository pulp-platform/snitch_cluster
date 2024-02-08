// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "dnn.h"

#include "data.h"

int main() {
    uint32_t nerr = fused_concat_linear_layer(layer);
    return nerr;
}
