// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

// Use snrt_putchar for printf
#define _putchar snrt_putchar

#ifdef __cplusplus
extern "C" {
#endif

extern void snrt_putchar(char character);

#ifdef __cplusplus
}  // extern "C"
#endif

#include "../../deps/printf/printf.h"
