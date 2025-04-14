// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <stdint.h>

#define MAX_UINT_PLUS1 4294967296.0

__thread double max_uint_plus_1_inverse = (double)1.0 / (double)MAX_UINT_PLUS1;

// Normalize integer PRN to [0, 1) range
double rand_int_to_unit_double(uint32_t x) {
    return (double)x * max_uint_plus_1_inverse;
}

#include "lcg.h"
#include "splitmix64.h"
#include "xoshiro128p.h"
