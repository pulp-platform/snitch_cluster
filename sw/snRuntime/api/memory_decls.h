// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

inline volatile snitch_cluster_t* snrt_cluster_alias();

inline volatile snitch_cluster_t* snrt_cluster(int cluster_idx);

inline volatile snitch_cluster_t* snrt_cluster();
