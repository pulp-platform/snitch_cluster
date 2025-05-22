// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"
// #include <bits/types.h>

#define LENGTH 64

int main() {
    if (snrt_cluster_core_idx() > 0) return 0;

    __uint32_t input = 21, t6_out;
    double     output;

    printf("Starting Test\n");
    printf("Input: %d\n", input);

    asm volatile(
        ".data \n"
        "zero_val: .double 0.0 \n"
        
        ".text \n"
        // Initialize registers to 0
        "mv t6, x0 \n"
        "fcvt.d.w ft3, t6 \n"
        "fcvt.d.w ft2, t6 \n"
        "fcvt.d.w ft1, t6 \n"

        // Create FP->IN dependency
        "fmv.x.w t2, ft1\n"
        "mv      t0, t2\n"

        // Input
        "mv t1, %[in] \n"
        "add t2, t1, %[frep_len] \n"
        
        // Enable Queues
        "csrrsi x0, 0x7C4, 0x1\n"
        
        // Initial data in queue
        "mv t6, t1 \n"

        // outer loop, repeat frep_len+1 times, next 2 instrs in loopbody, don't stagger
        "frep.o %[frep_len], 2, 0, 0 \n"
        "fcvt.d.w ft1, t6 \n"
        "fadd.d ft2, ft2, ft1 \n"
        
        // Fill queue
        "1: \n"
        "addi t1, t1, 1 \n"
        "mv t6, t1 \n"
        "bne t1, t2, 1b \n"

        // Create FP->IN dependency
        "fmv.x.w t6, ft2\n"
        "mv      t0, t6\n"

        // Disable Queues
        "csrrci x0, 0x7C4, 0x1\n"

        "mv %[t6_out], t6 \n"
        "fadd.d %[fp_out], ft2, ft3 \n"
        : [ fp_out ] "=f"(output), [ t6_out ] "=r"(t6_out)
        : [ in ] "r"(input), [frep_len] "r"(LENGTH-1)
        : "t2");
    
    printf("Finished Test\n");
    int golden_sum = input*LENGTH+(LENGTH-1)*LENGTH/2;
    printf("Sum Obtained: %d vs Golden Sum: %d\n", (int)output, golden_sum);
    printf("Value in t6: %d\n", t6_out);
    if((int)output == golden_sum && t6_out == 0) return 0;
    else return 1;
}