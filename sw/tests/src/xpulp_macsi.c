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
        int32_t result_rd, result_rs1, result_rs2;

        // ---------- p.mac ----------
        register int32_t rd asm("a3") = 10;
        register int32_t rs1 asm("a4") = 3;
        register int32_t rs2 asm("a5") = -4;

        asm volatile("p.mac a3, a4, a5\n"
                     : "+r"(rd)
                     : "r"(rs1), "r"(rs2)
                     : "a3", "a4", "a5");

        result_rd = rd;
        result_rs1 = rs1;
        result_rs2 = rs2;

        // 10 + 3 * (-4) = -2
        if (!(result_rd == -2 && result_rs1 == 3 && result_rs2 == -4)) errs++;

        // ---------- p.msu ----------
        rd = -2;
        rs1 = 5;
        rs2 = 6;

        asm volatile("p.msu a3, a4, a5\n"
                     : "+r"(rd)
                     : "r"(rs1), "r"(rs2)
                     : "a3", "a4", "a5");

        result_rd = rd;
        result_rs1 = rs1;
        result_rs2 = rs2;

        // -2 - 5 * 6 = -32
        if (!(result_rd == -32 && result_rs1 == 5 && result_rs2 == 6)) errs++;

        return errs;
    } else {
        return 0;
    }

    snrt_cluster_hw_barrier();
#endif
    return 0;
}