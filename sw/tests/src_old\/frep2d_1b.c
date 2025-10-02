// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>
#include <stdint.h>
#include "printf.h"

int main() {
    if (snrt_cluster_core_idx() != 0) return 0;

    int n_iter_1 = 1;
    int n_iter_2 = 2;
    int exp_res = n_iter_1 * (3 + (n_iter_2 * 2));
    double res = 0.0;
    double one = 1.0;
    double two = 2.0;

    asm volatile(
        "frep.o %[n_iter_1], 4, 0, 0 \n"
        "fadd.d %[res], %[res], %[one] \n"
        "fadd.d %[res], %[res], %[two] \n"
        "frep.o %[n_iter_2], 2, 0, 0 \n"
        "fadd.d %[res], %[res], %[one] \n"
        "fadd.d %[res], %[res], %[one] \n"
        : [ res ] "+f"(res), [ one ] "+f"(one), [ two ] "+f"(two)
        : [ n_iter_1 ] "r"(n_iter_1 - 1), [ n_iter_2 ] "r"(n_iter_2 - 1));

    snrt_fpu_fence();
    printf("res = %f\n", res);
    return exp_res - res;
}
