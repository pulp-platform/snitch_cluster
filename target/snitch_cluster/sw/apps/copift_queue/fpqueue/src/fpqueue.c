// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

int main() {
    if (snrt_cluster_core_idx() > 0) return 0;

    __uint32_t input, t6_rf;
    double     fpq_read;

    input = 6;
    printf("\n----------Starting SW Test----------\n");
    printf("Input: %d\n", input);

    asm volatile(
        "mv t6, x0 \n"              // INCC: Write RF t6
        
        "csrrsi x0, 0x7C4, 0x1\n"   // Enable queue
        
        "mv t6, %[input] \n"        // INCC: Write into fpq
        "fcvt.d.w %[fpq_read], t6 \n" // FPSS: Read from fpq

        // Create FP->IN dependency
        "fadd.d ft2, ft2, %[fpq_read] \n"
        "fmv.x.w t6, ft2\n"
        "mv      t0, t6\n"

        "csrrci x0, 0x7C4, 0x1\n"   // Disable queue

        "add %[t6_rf], t6, x0 \n"   // INCC: Read RF t6
        : [ fpq_read ] "=f"(fpq_read), [ t6_rf ] "=r"(t6_rf)
        : [ input ] "r"(input)
        :);
    printf("-----Finished asm-----\n");
    printf("fcvt\'ed value from fpq: %f\n", fpq_read);
    printf("value in t6 RF: %d\n", t6_rf);
    printf("----------Finished SW Test----------\n\n");
    
    if((int)fpq_read == input && t6_rf == 0) return 0;
    else return 1;
}