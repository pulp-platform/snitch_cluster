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

        //-----------------------------------------------------------------
        // 1. p.clip  (signed, immediate)
        //-----------------------------------------------------------------
        register int32_t rd asm("a3");
        register int32_t rs1 asm("a4");

        // if rs1 <= -2^(Is2-1), rD = -2^(Is2-1)
        // else if rs1 >= 2^(Is2-1)–1, rD = 2^(Is2-1)-1
        // else rD = rs1
        // Note: If ls2 is equal to 0, -2^(Is2-1)= -1 while (2^(Is2-1)-1)=0;
        // case 1 - rs1 is inside the range
        rs1 = -42;
        asm volatile("p.clip a3, a4, 7\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        if (!(rd == -42 && rs1 == -42)) errs++;
        // --- outside range: should clip (100 -> 63)
        rs1 = 100;
        asm volatile("p.clip a3, a4, 7\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        if (!(rd == 63 && rs1 == 100)) errs++;

        // if ls2 = 0
        rs1 = 100;
        asm volatile("p.clip a3, a4, 0\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        if (!(rd == 0 && rs1 == 100)) errs++;

        rs1 = -10;
        asm volatile("p.clip a3, a4, 0\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        if (!(rd == -1 && rs1 == -10)) errs++;

        //-----------------------------------------------------------------
        // 2. p.clipr  (signed, register)
        //-----------------------------------------------------------------

        // if rs1 <= -(rs2+1), rD = -(rs2+1),
        //else if rs1 >=rs2, rD = rs2,
        //else rD = rs1
        register int32_t rs2 asm("a5") = 20;
        // --- inside range: should NOT clip (-10)
        rs1 = -10;
        asm volatile("p.clipr a3, a4, a5\n"
                     : "=r"(rd)
                     : "r"(rs1), "r"(rs2)
                     : "a3", "a4", "a5");
        if (!(rd == -10 && rs1 == -10)) errs++;
        // --- outside range: should clip (-100 -> -64)
        rs1 = -100;
        rs2 = 15;
        asm volatile("p.clipr a3, a4, a5\n"
                     : "=r"(rd)
                     : "r"(rs1), "r"(rs2)
                     : "a3", "a4", "a5");
        if (!(rd == -16 && rs1 == -100)) errs++;
        //-----------------------------------------------------------------
        // 3. p.clipu  (signed, immediate)
        //-----------------------------------------------------------------
        // if rs1 <= 0, rD = 0,
        // else if rs1 >= 2^(Is2–1)-1, rD = 2^(Is2-1)-1,
        // else rD = rs1
        // Note: If ls2 is equal to 0, (2^(Is2-1)-1)=0;
        // case 1 - rs1 <= 0
        rs1 = -201;
        asm volatile("p.clipu a3, a4, 7\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        if (!(rd == 0 && rs1 == -201)) errs++;
        // case 2 - rs1 >= 2^(Is2–1)-1
        rs1 = 121;
        asm volatile("p.clipu a3, a4, 7\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        if (!(rd == 63 && rs1 == 121)) errs++;
        // case 3 - rs1 < 2^(Is2–1)-1
        rs1 = 12;
        asm volatile("p.clipu a3, a4, 7\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
        if (!(rd == 12 && rs1 == 12)) errs++;
        //-----------------------------------------------------------------
        // 4. p.clipur  (signed, register)
        //-----------------------------------------------------------------
        // if rs1 <= 0, rD = 0,
        // else if rs1 >= rs2, rD = rs2,
        // else rD = rs1
        // case 1 - rs1 <= 0
        rs1 = -201;
        rs2 = 15;
        asm volatile("p.clipur a3, a4, a5\n"
                     : "=r"(rd)
                     : "r"(rs1), "r"(rs2)
                     : "a3", "a4", "a5");
        if (!(rd == 0 && rs1 == -201)) errs++;
        // case 2 - rs1 >= rs2
        rs1 = 201;
        rs2 = 15;
        asm volatile("p.clipur a3, a4, a5\n"
                     : "=r"(rd)
                     : "r"(rs1), "r"(rs2)
                     : "a3", "a4", "a5");
        if (!(rd == 15 && rs1 == 201)) errs++;
        // case 3 - rs1 < rs2
        rs1 = 7;
        rs2 = 15;
        asm volatile("p.clipur a3, a4, a5\n"
                     : "=r"(rd)
                     : "r"(rs1), "r"(rs2)
                     : "a3", "a4", "a5");
        if (!(rd == 7 && rs1 == 7)) errs++;

        return errs;
    } else {
        return 0;
    }

    snrt_cluster_hw_barrier();
#endif
    return 0;
}