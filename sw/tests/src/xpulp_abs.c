// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <snrt.h>

int main() {
#ifdef SNRT_SUPPORTS_XPULP
    uint32_t i = snrt_global_core_idx();
    snrt_cluster_hw_barrier();
    if (i == 2) {
        int errs = 0;
        int32_t result_rd;
        int32_t result_rs1;
        register int32_t rd asm("a3") = 0;
        register int32_t rs1 asm("a4") = -42;  // rs1, data source
        asm volatile("p.abs a3, a4\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        result_rd = rd;
        result_rs1 = rs1;
        if (!((result_rd == 42) && (result_rs1 == -42))) {
            errs = errs + 1;
        }
        return errs;
    } else
        return 0;
    snrt_cluster_hw_barrier();
#endif
    return 0;
}
