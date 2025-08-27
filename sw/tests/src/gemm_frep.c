// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>
#include <stdint.h>
#include "printf.h"

int main() {
    if (snrt_cluster_core_idx() != 0) return 0;

    int n_iter_1 = 2;
    int n_iter_2 = 2;
    int exp_res = 16 + (n_iter_2 * 8);
    double c[8];
    double one = 1.0;

    asm volatile(
        "frep.o %[n_iter_1], 24, 0, 0 \n"
        "fmul.d %[c0], %[one], %[one] \n"
        "fmul.d %[c1], %[one], %[one] \n"
        "fmul.d %[c2], %[one], %[one] \n"
        "fmul.d %[c3], %[one], %[one] \n"
        "fmul.d %[c4], %[one], %[one] \n"
        "fmul.d %[c5], %[one], %[one] \n"
        "fmul.d %[c6], %[one], %[one] \n"
        "fmul.d %[c7], %[one], %[one] \n"
        "frep.o %[n_iter_2], 8, 0, 0 \n"
        "fmadd.d %[c0], %[one], %[one], %[c0] \n"
        "fmadd.d %[c1], %[one], %[one], %[c1] \n"
        "fmadd.d %[c2], %[one], %[one], %[c2] \n"
        "fmadd.d %[c3], %[one], %[one], %[c3] \n"
        "fmadd.d %[c4], %[one], %[one], %[c4] \n"
        "fmadd.d %[c5], %[one], %[one], %[c5] \n"
        "fmadd.d %[c6], %[one], %[one], %[c6] \n"
        "fmadd.d %[c7], %[one], %[one], %[c7] \n"
        "fmadd.d %[c0], %[one], %[one], %[c0] \n"
        "fmadd.d %[c1], %[one], %[one], %[c1] \n"
        "fmadd.d %[c2], %[one], %[one], %[c2] \n"
        "fmadd.d %[c3], %[one], %[one], %[c3] \n"
        "fmadd.d %[c4], %[one], %[one], %[c4] \n"
        "fmadd.d %[c5], %[one], %[one], %[c5] \n"
        "fmadd.d %[c6], %[one], %[one], %[c6] \n"
        "fmadd.d %[c7], %[one], %[one], %[c7] \n"
        : [ c0 ] "+f"(c[0]), [ c1 ] "+f"(c[1]), [ c2 ] "+f"(c[2]),
          [ c3 ] "+f"(c[3]), [ c4 ] "+f"(c[4]), [ c5 ] "+f"(c[5]),
          [ c6 ] "+f"(c[6]), [ c7 ] "+f"(c[7]), [ one ] "+f"(one)
        : [ n_iter_1 ] "r"(n_iter_1 - 1), [ n_iter_2 ] "r"(n_iter_2 - 1));

    snrt_fpu_fence();
    c[0] = c[0] + c[1] + c[2] + c[3] + c[4] + c[5] + c[6] + c[7];
    return exp_res - c[0];
}
