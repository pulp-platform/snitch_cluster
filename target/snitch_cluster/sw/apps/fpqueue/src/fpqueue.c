// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"
// #include <bits/types.h>

int main() {
    __uint32_t input, t6_out;
    double     output;

    input = 6;
    printf("Starting Test\n");
    printf("Input: %d\n", input);

    asm volatile(
        "mv t6, x0 \n"
        
        "csrrsi x0, 0x7C4, 0x1\n" // Set first bit
        
        "mv t6, %[in] \n"
        "fcvt.d.w %[fp_out], t6 \n"

        "csrrci x0, 0x7C4, 0x1\n"    // Clear first bit

        "add %[t6_out], t6, x0 \n"
        : [ fp_out ] "=f"(output), [ t6_out ] "=r"(t6_out)
        : [ in ] "r"(input)
        :);
    
    printf("Finished Test\n");
    printf("fcvt\'ed value in ft3: %f\n", output);
    printf("value in t6: %d\n", t6_out);
    return 0;
}