// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#pragma once
#include <stdint.h>

typedef void (*syrk_fp_t)(uint32_t m, uint32_t n, double alpha, double *a,
                          double *at, double beta, double *b);

typedef struct {
    uint32_t m;
    uint32_t n;
    double alpha;
    double beta;
    double *a;
    double *c;
    uint32_t m_tiles;
    syrk_fp_t funcptr;
} syrk_args_t;
