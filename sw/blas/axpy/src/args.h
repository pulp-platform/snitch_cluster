// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once
#include <stdint.h>

typedef void (*axpy_fp_t)(uint32_t n, double a, double* x, double* y,
                          double* z);

typedef struct {
    uint32_t n;
    double a;
    double* x;
    double* y;
    double* z;
    uint32_t n_tiles;
    axpy_fp_t funcptr;
} axpy_args_t;
