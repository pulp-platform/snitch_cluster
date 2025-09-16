// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#pragma once
#include <stdint.h>

typedef void (*doitgen_fp_t)(uint32_t r, uint32_t q, uint32_t s, double *A,
                             double *x, double *Aout);

typedef struct {
    uint32_t r;
    uint32_t q;
    uint32_t s;
    double *A;
    double *x;
    uint32_t r_tiles;
    uint32_t q_tiles;
    doitgen_fp_t funcptr;
} doitgen_args_t;
