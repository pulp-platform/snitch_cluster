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
        int32_t result_rs2;

        // ---------- p.min (signed) ----------
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = -42;
            register int32_t rs2 asm("a5") = 17;
            asm volatile("p.min a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;
            result_rs1 = rs1;
            result_rs2 = rs2;
            if (!((result_rd == -42) && (result_rs1 == -42) &&
                  (result_rs2 == 17)))
                errs++;
        }

        // ---------- p.minu (unsigned) ----------
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 42;
            register uint32_t rs2 asm("a5") = 17;
            asm volatile("p.minu a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;
            result_rs1 = rs1;
            result_rs2 = rs2;
            if (!((result_rd == 17) && (result_rs1 == 42) &&
                  (result_rs2 == 17)))
                errs++;
        }

        // ---------- p.max (signed) ----------
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = -42;
            register int32_t rs2 asm("a5") = 17;
            asm volatile("p.max a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;
            result_rs1 = rs1;
            result_rs2 = rs2;
            if (!((result_rd == 17) && (result_rs1 == -42) &&
                  (result_rs2 == 17)))
                errs++;
        }

        // ---------- p.maxu (unsigned) ----------
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 42;
            register uint32_t rs2 asm("a5") = 17;
            asm volatile("p.maxu a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;
            result_rs1 = rs1;
            result_rs2 = rs2;
            if (!((result_rd == 42) && (result_rs1 == 42) &&
                  (result_rs2 == 17)))
                errs++;
        }

        return errs;
    } else
        return 0;
    snrt_cluster_hw_barrier();
#endif
    return 0;
}