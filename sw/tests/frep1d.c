// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>
#include <stdint.h>
#include "printf.h"

int main() {
    if (snrt_is_dm_core()) return 0;

    int n_iter = 4;
    int exp_res = n_iter * 2;
    double res = 0.0;
    double one = 1.0;

    asm volatile(
        "frep.o %[n_iter], 2, 0, 0 \n"
        "fadd.d %[res], %[res], %[one] \n"
        "fadd.d %[res], %[res], %[one] \n"
        : [ res ] "+f"(res), [ one ] "+f"(one)
        : [ n_iter ] "r"(n_iter - 1));

    snrt_fpu_fence();

    return exp_res - res;
}
