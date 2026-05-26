// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <snrt.h>

int main() {
#ifdef SNRT_SUPPORTS_PULP
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
                         : "a4", "a5");

            result_rd = rd;
            if (result_rd != 0x5678DEAD) errs++;
        }

        // pv.shuffle2.b
        {
            register int32_t rd asm("a3") =
                0xAAAABBBB;  // rd initial = [AA][AA][BB][BB]
            register int32_t rs1 asm("a4") =
                0x11223344;  // rs1        = [11][22][33][44]
            // rs2 control (each byte: bit[2]=1→rs1, bit[2]=0→rd, bits[1:0]=index):
            // byte[3] (upper): rs1[idx 0] => 0x44 → ctrl = 0x04
            // byte[2]:         rs1[idx 1] => 0x33 → ctrl = 0x05
            // byte[1]:         rd[idx 2]  => 0xAA → ctrl = 0x02
            // byte[0] (low):   rd[idx 0]  => 0xBB → ctrl = 0x00
            register int32_t rs2 asm("a5") =
                0x00             // byte[0]: rd[idx 0] = 0xBB
                | (0x02 << 8)    // byte[1]: rd[idx 2] = 0xAA
                | (0x05 << 16)   // byte[2]: rs1[idx 1] = 0x33
                | (0x04 << 24);  // byte[3]: rs1[idx 0] = 0x44
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
            register int32_t rs1 asm("a4") = 0x12340000;  // high half = 0x1234
            register int32_t rs2 asm("a5") = 0x56780000;  // high half = 0x5678
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
    return 0;
#else
    return 1;
#endif
}