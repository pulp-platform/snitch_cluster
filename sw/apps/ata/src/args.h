// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#pragma once
#include <stdint.h>

typedef void (*ata_fp_t)(double alpha, uint32_t m, uint32_t n, double *a,
    double *at, double *b);

typedef struct {
    double alpha;
    uint32_t m;
    uint32_t n;
    double *a;
    double *b;
    uint32_t m_tiles;
    ata_fp_t funcptr;
} ata_args_t;
