// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <snrt.h>
#include <stdint.h>
// precision_t is already defined in snitch runtime (sw/runtime/src/types.h)

typedef struct gemv_layer_struct {
  uint32_t M;
  uint32_t N;

  precision_t dtype;
} gemv_layer;
