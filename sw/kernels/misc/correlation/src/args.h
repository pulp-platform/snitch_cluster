// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#pragma once
#include <stdint.h>

typedef struct {
    uint32_t N;
    uint32_t M;
    uint64_t data_addr;
    uint64_t corr_addr;
} correlation_args_t;
