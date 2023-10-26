// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// SW testbench for profiling MaxPool Layer
// Automatically checks the correctness of the results

#include "dnn.h"

#include "data.h"

int main() {
    maxpool_layer(&layer);

    snrt_global_barrier();
    return 0;
}
