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

        // pv.shuffle2.h
        {
            register int32_t rd asm("a3") =
                0xDEADBEAF;  // rD initial (upper=0xDEAD, lower=0xBEAF)
            register int32_t rs1 asm("a4") =
                0x12345678;  // rs1 (upper=0x1234, lower=0x5678)
            register int32_t rs2 asm("a5") =
                0x00020001;  // control: upper→from rs1[1]=0x1234, lower→from rd[0]=0x5678
            int32_t result_rd;

            asm volatile("pv.shuffle2.h a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");

            result_rd = rd;
            if (result_rd != 0x5678DEAD) errs++;
        }

        // pv.shuffle2.b
        {
            int errs = 0;
            register int32_t rd asm("a3") =
                0xAAAABBBB;  // rd initial = [AA][AA][BB][BB]
            register int32_t rs1 asm("a4") =
                0x11223344;  // rs1        = [11][22][33][44]
            // rs2 control:
            // upper byte: take from rs1, index 0 => 0x44
            // next byte:  take from rs1, index 1 => 0x33
            // next byte:  take from rd,  index 2 => 0xAA
            // low byte:   take from rd,  index 3 => 0xBB
            register int32_t rs2 asm("a5") = 0b01000101         // low nibble
                                             | (0b0101 << 8)    // next byte
                                             | (0b0010 << 16)   // next
                                             | (0b0000 << 24);  // top
            int32_t result_rd;

            asm volatile("pv.shuffle2.b a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2));
            result_rd = rd;

            // expected: [44][33][AA][BB]
            if (result_rd != 0x4433AABB) errs++;
        }

        // pv.pack.h
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00001234;
            register int32_t rs2 asm("a5") = 0x00005678;
            asm volatile("pv.pack.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;
            if (result_rd != 0x12345678) errs++;
        }

        // pv.pack
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x89ABCDEF;
            register int32_t rs2 asm("a5") = 0x01234567;
            asm volatile("pv.pack a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;
            if (result_rd != 0xCDEF4567) errs++;
        }

        return errs;
    } else
        return 0;
    snrt_cluster_hw_barrier();
#endif
    return 0;
}