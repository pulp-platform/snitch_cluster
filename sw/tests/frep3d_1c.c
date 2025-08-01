// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>
#include <stdint.h>
#include "printf.h"

int main() {
    if (snrt_cluster_core_idx() != 0) return 0;

    int n_iter_1 = 1;
    int n_iter_2 = 1;
    int n_iter_3 = 2;
    int exp_res = n_iter_1 * (1 + n_iter_2 * (1 + (n_iter_3 * 1)));
    double res = 0.0;
    double one = 1.0;

    asm volatile(
        "frep.o %[n_iter_1], 3, 0, 0 \n"
        "fadd.d %[res], %[res], %[one] \n"
        "frep.o %[n_iter_2], 2, 0, 0 \n"
        "fadd.d %[res], %[res], %[one] \n"
        "frep.o %[n_iter_3], 1, 0, 0 \n"
        "fadd.d %[res], %[res], %[one] \n"
        : [ res ] "+f"(res), [ one ] "+f"(one)
        : [ n_iter_1 ] "r"(n_iter_1 - 1), [ n_iter_2 ] "r"(n_iter_2 - 1),
          [ n_iter_3 ] "r"(n_iter_3 - 1));

    snrt_fpu_fence();

    return exp_res - res;
}
