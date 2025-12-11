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
        int taken;

        //------------------------------------------------------------
        // 1. p.beqimm: branch SHOULD be taken (rs1 == imm)
        //------------------------------------------------------------
        {
            register int32_t rs1 asm("a4") = 5;
            taken = 0;
            asm volatile(
                "p.beqimm a4, 5, 1f\n"  // if a4 == 5 → jump to label 1
                "li %[tk], 0\n"         // if not jumped → tk = 0
                "j 2f\n"                // skip label 1
                "1:\n"
                "li %[tk], 1\n"  // if jumped → tk = 1
                "2:\n"
                : [ tk ] "=r"(taken)
                : "r"(rs1)
                : "a4");
            if (taken != 1) errs++;
        }

        //------------------------------------------------------------
        // 2. p.beqimm: branch SHOULD NOT be taken (rs1 != imm)
        //------------------------------------------------------------
        {
            register int32_t rs1 asm("a4") = 7;
            taken = 0;
            asm volatile(
                "p.beqimm a4, 5, 1f\n"
                "li %[tk], 0\n"
                "j 2f\n"
                "1:\n"
                "li %[tk], 1\n"
                "2:\n"
                : [ tk ] "=r"(taken)
                : "r"(rs1)
                : "a4");
            if (taken != 0) errs++;
        }

        //------------------------------------------------------------
        // 3. p.bneimm: branch SHOULD be taken (rs1 != imm)
        //------------------------------------------------------------
        {
            register int32_t rs1 asm("a4") = 7;
            taken = 0;
            asm volatile(
                "p.bneimm a4, 5, 1f\n"  // if a4 != 5 → jump to label 1
                "li %[tk], 0\n"         // if not jumped → tk = 0
                "j 2f\n"
                "1:\n"
                "li %[tk], 1\n"  // if jumped → tk = 1
                "2:\n"
                : [ tk ] "=r"(taken)
                : "r"(rs1)
                : "a4");
            if (taken != 1) errs++;
        }

        //------------------------------------------------------------
        // 4. p.bneimm: branch SHOULD NOT be taken (rs1 == imm)
        //------------------------------------------------------------
        {
            register int32_t rs1 asm("a4") = 5;
            taken = 0;
            asm volatile(
                "p.bneimm a4, 5, 1f\n"
                "li %[tk], 0\n"
                "j 2f\n"
                "1:\n"
                "li %[tk], 1\n"
                "2:\n"
                : [ tk ] "=r"(taken)
                : "r"(rs1)
                : "a4");
            if (taken != 0) errs++;
        }

        return errs;
    } else {
        return 0;
    }

    snrt_cluster_hw_barrier();
#endif
    return 0;
}