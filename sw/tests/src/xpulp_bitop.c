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

        // -------- p.exths: sign-extend 16-bit ----------
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") =
                0x0000F234;  // low 16 bits = 0xF234 -> -3532
            asm volatile("p.exths a3, a4\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
            if (rd != 0xFFFFF234 || rs1 != 0x0000F234) errs++;
        }

        // -------- p.exthz: zero-extend 16-bit ----------
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") =
                0x1234F234;  // low 16 bits = 0xF234 -> 0x0000F234
            asm volatile("p.exthz a3, a4\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
            if (rd != 0x0000F234 || rs1 != 0x1234F234) errs++;
        }

        // -------- p.extbs: sign-extend 8-bit ----------
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") =
                0x000000E2;  // low 8 bits = 0xE2 -> -30
            asm volatile("p.extbs a3, a4\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
            if (rd != 0xFFFFFFE2 || rs1 != 0x000000E2) errs++;
        }

        // -------- p.extbz: zero-extend 8-bit ----------
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0xABCD00E2;  // low 8 bits = 0xE2
            asm volatile("p.extbz a3, a4\n" : "=r"(rd) : "r"(rs1) : "a3", "a4");
            if (rd != 0x000000E2 || rs1 != 0xABCD00E2) errs++;
        }

        return errs;  // 0 if all tests pass
    } else {
        return 0;
    }
    snrt_cluster_hw_barrier();
#endif
    return 0;
}