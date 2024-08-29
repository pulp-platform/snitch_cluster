// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#pragma once
#include <stdint.h>

typedef void (*covariance_fp_t)(uint32_t m, uint32_t n, double inv_n,
                                double inv_n_m1, double *data, double *datat,
                                double *cov);

typedef struct {
    uint32_t m;
    uint32_t n;
    double inv_n;
    double inv_n_m1;
    double *data;
    double *cov;
    uint32_t m_tiles;
    covariance_fp_t funcptr;
} covariance_args_t;
