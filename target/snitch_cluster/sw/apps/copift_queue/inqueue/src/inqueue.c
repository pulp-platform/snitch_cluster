// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

int main() {
    if (snrt_cluster_core_idx() > 0) return 0;

    double     input;
    __uint32_t inq_read, t6_rf;

    input = 6.0;
    printf("\n----------Starting SW Test----------\n");
    printf("input: %f\n", input);

    asm volatile(
        "mv t6, x0 \n"              // INCC: Write RF t6
        
        "csrrsi x0, 0x7C4, 0x1\n"   // Enable queue
        
        "fcvt.w.d t2, %[input] \n"  // FPSS: Write into inq
        "mv %[inq_read], t6 \n"     // INCC: Read from inq

        "csrrci x0, 0x7C4, 0x1\n"   // Disable queue

        "add %[t6_rf], t6, x0 \n"   // INCC: Read RF t6
        : [ inq_read ] "=r"(inq_read), [ t6_rf ] "=r"(t6_rf)
        : [ input ] "f"(input)
        :);
    printf("-----Finished asm-----\n");
    printf("fcvt\'ed value from inq: %d\n", inq_read);
    printf("value in t6 RF: %d\n", t6_rf);
    printf("----------Finished SW Test----------\n\n");
    
    if((int)inq_read == input && t6_rf == 0) return 0;
    else return 1;
}