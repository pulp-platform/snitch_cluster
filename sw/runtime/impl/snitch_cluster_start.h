// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#define SNRT_INIT_BSS
#define SNRT_WAKE_UP
#define SNRT_INIT_TLS
#define SNRT_INIT_CLS
#define SNRT_INIT_LIBS
#define SNRT_CRT0_PRE_BARRIER
#define SNRT_INVOKE_MAIN
#define SNRT_CRT0_POST_BARRIER
#define SNRT_CRT0_EXIT

extern volatile uint32_t tohost;

#ifndef OPENOCD_SEMIHOSTING
static inline volatile uint32_t* snrt_exit_code_destination() {
    return (volatile uint32_t*)&tohost;
}
#endif

#include "start.h"
