// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>
#include <stdint.h>
#include "printf.h"

int main() {
    if (snrt_cluster_core_idx() != 0) return 0;

    // n_iter_2 must be an even number
    int n_iter_1 = 2;
    int n_iter_2 = 4;
    int n_iter_2h = n_iter_2 / 2;
    int exp_res = n_iter_1 * (1 + (n_iter_2h * 3));
    double res = 0;
    register double one asm("ft0") = 1;
    register double two asm("ft1") = 2;

    asm volatile(
        "frep.o %[n_iter_1], 2, 0, 0 \n"
        "fadd.d %[res], %[res], %[one] \n"
        "frep.o %[n_iter_2], 1, 1, 0b0100 \n"
        "fadd.d %[res], %[res], %[one] \n"
        : [ res ] "+f"(res), [ one ] "+f"(one), [ two ] "+f"(two)
        : [ n_iter_1 ] "r"(n_iter_1 - 1), [ n_iter_2 ] "r"(n_iter_2 - 1));

    snrt_fpu_fence();
    printf("res = %f\n", res);
    return exp_res - res;
}
