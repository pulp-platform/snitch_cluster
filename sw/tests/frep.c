// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>
#include <stdint.h>
#include "printf.h"

int main() {
    if (snrt_cluster_core_idx() != 0) return 0;

    double one = 1.0;
    int n_iter_1 = 1;
    int n_iter_2 = 2;
    int n_iter_3 = 1;
    double exp_res_0 = n_iter_1 * 1;
    double exp_res_1 = n_iter_1 * n_iter_2 * 1;
    double exp_res_2 = n_iter_1 * n_iter_2 * 1;
    double exp_res_3 = n_iter_1 * n_iter_2 * n_iter_3 * 1;
    double exp_res_4 = n_iter_1 * n_iter_2 * n_iter_3 * 1;

    double res_0 = 0;
    double res_1 = 0;
    double res_2 = 0;
    double res_3 = 0;
    double res_4 = 0;

    asm volatile(
        "frep.o %[n_iter_1],  5, 0, 0 \n"
        "fadd.d %[res0], %[res0], %[one] \n"
        "frep.o %[n_iter_2], 4, 0, 0 \n"
        "fadd.d %[res1], %[res1], %[one] \n"
        "fadd.d %[res2], %[res2], %[one] \n"
        "frep.o %[n_iter_3], 2, 0, 0 \n"
        "fadd.d %[res3], %[res3], %[one] \n"
        "fadd.d %[res4], %[res4], %[one] \n"

        : [ res0 ] "+f"(res_0), [ res1 ] "+f"(res_1), [ res2 ] "+f"(res_2),
          [ res3 ] "+f"(res_3), [ res4 ] "+f"(res_4), [ one ] "+f"(one)
        : [ n_iter_1 ] "r"(n_iter_1 - 1), [ n_iter_2 ] "r"(n_iter_2 - 1),
          [ n_iter_3 ] "r"(n_iter_3 - 1));

    snrt_fpu_fence();
    return (exp_res_0 - res_0) + (exp_res_1 - res_1) + (exp_res_2 - res_2) +
           (exp_res_3 - res_3) + (exp_res_4 - res_4);
}
