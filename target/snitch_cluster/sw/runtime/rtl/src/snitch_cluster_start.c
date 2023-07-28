// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// needs to be before #define SNRT_CRT0_EXIT
static inline void snrt_exit(int exit_code) {
    extern volatile uint32_t tohost;

    if (snrt_global_core_idx() == 0) tohost = (exit_code << 1) | 1;
}

#define SNRT_INIT_TLS
#define SNRT_INIT_BSS
#define SNRT_INIT_CLS
#define SNRT_INIT_LIBS
#define SNRT_CRT0_PRE_BARRIER
#define SNRT_INVOKE_MAIN
#define SNRT_CRT0_POST_BARRIER
#define SNRT_CRT0_EXIT

#include "start.c"
