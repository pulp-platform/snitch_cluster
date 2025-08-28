// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#pragma once
#include <stdint.h>

typedef struct {
    uint32_t M;
    uint32_t N;
    uint64_t A_addr;
    uint64_t x_addr;
    uint64_t y_addr;
} atax_args_t;
