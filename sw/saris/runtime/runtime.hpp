// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

// C linkage macros
#ifdef __cplusplus
#define EXTERN_C extern "C"
#define EXTERN_C_BEGIN extern "C" {
#define EXTERN_C_END }
#else
#define EXTERN_C
#define EXTERN_C_BEGIN
#define EXTERN_C_END
#endif

// Include C runtime, ignoring benign CXX-only warnings
EXTERN_C_BEGIN
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-register"
#include "runtime.h"
#pragma GCC diagnostic pop
EXTERN_C_END
