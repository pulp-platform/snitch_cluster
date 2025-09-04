// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "dnn.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreorder-init-list"
#include "data.h"
#pragma clang diagnostic pop

int main() {
    batchnorm_layer(&layer);

    snrt_global_barrier();

    return 0;
}
