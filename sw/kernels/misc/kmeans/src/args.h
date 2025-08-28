// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#pragma once
#include <stdint.h>

typedef struct {
    uint32_t n_samples;
    uint32_t n_features;
    uint32_t n_clusters;
    uint32_t n_iter;
    uint64_t samples_addr;
    uint64_t centroids_addr;
} kmeans_args_t;
