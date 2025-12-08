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

        // pv.add.h : vector-vector halfword add
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00020003;  // [0x0002, 0x0003]
            register int32_t rs2 asm("a5") = 0x00040005;  // [0x0004, 0x0005]
            asm volatile("pv.add.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [0x0006, 0x0008] -> 0x00060008
            result_rd = rd;
            if (result_rd != 0x00060008) errs++;
        }

        // pv.add.sc.h : replicate rs2 scalar across halfwords
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00020003;  // [0x0002, 0x0003]
            register int32_t rs2 asm("a5") = 0x0004;      // scalar = 4
            asm volatile("pv.add.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [0x0002+4, 0x0003+4] = [6,7] -> 0x00060007
            result_rd = rd;
            if (result_rd != 0x00060007) errs++;
        }

        // pv.add.sci.h : replicate immediate across halfwords
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00020003;  // [0x0002, 0x0003]
            asm volatile("pv.add.sci.h a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            // expect [0x0003, 0x0004] -> 0x00030004
            result_rd = rd;
            if (result_rd != 0x00030004) errs++;
        }

        // pv.add.b : vector-vector byte add
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01020304;  // [01,02,03,04]
            register int32_t rs2 asm("a5") = 0x05060708;  // [05,06,07,08]
            asm volatile("pv.add.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [06,08,0A,0C] -> 0x06080A0C
            result_rd = rd;
            if (result_rd != 0x06080A0C) errs++;
        }

        // pv.add.sc.b : replicate rs2 scalar across bytes
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01020304;  // [01,02,03,04]
            register int32_t rs2 asm("a5") = 0x05;        // scalar = 0x05
            asm volatile("pv.add.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [01+05, 02+05, 03+05, 04+05] = [06,07,08,09]
            result_rd = rd;
            if (result_rd != 0x06070809) errs++;
        }

        // pv.add.sci.b : replicate immediate across bytes
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01020304;  // [01,02,03,04]
            asm volatile("pv.add.sci.b a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            // expect [02,03,04,05] -> 0x02030405
            result_rd = rd;
            if (result_rd != 0x02030405) errs++;
        }
        // pv.sub.h : vector-vector halfword subtract
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00060008;  // [0x0006, 0x0008]
            register int32_t rs2 asm("a5") = 0x00020003;  // [0x0002, 0x0003]
            asm volatile("pv.sub.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [6-2, 8-3] = [4,5] -> 0x00040005
            result_rd = rd;
            if (result_rd != 0x00040005) errs++;
        }

        // pv.sub.sc.h : vector-scalar halfword subtract
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00060008;  // [0x0006, 0x0008]
            register int32_t rs2 asm("a5") = 0x0002;      // scalar = 2
            asm volatile("pv.sub.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [6-2, 8-2] = [4,6] -> 0x00040006
            result_rd = rd;
            if (result_rd != 0x00040006) errs++;
        }

        // pv.sub.sci.h : vector-imm halfword subtract
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00060008;  // [0x0006, 0x0008]
            asm volatile("pv.sub.sci.h a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            // expect [6-1, 8-1] = [5,7] -> 0x00050007
            result_rd = rd;
            if (result_rd != 0x00050007) errs++;
        }

        // pv.sub.b : vector-vector byte subtract
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x06080A0C;  // [06,08,0A,0C]
            register int32_t rs2 asm("a5") = 0x01020304;  // [01,02,03,04]
            asm volatile("pv.sub.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [05,06,07,08] -> 0x05060708
            result_rd = rd;
            if (result_rd != 0x05060708) errs++;
        }

        // pv.sub.sc.b : vector-scalar byte subtract
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x06070809;  // [06,07,08,09]
            register int32_t rs2 asm("a5") = 0x01;        // scalar = 1
            asm volatile("pv.sub.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            // expect [05,06,07,08] -> 0x05060708
            result_rd = rd;
            if (result_rd != 0x05060708) errs++;
        }

        // pv.sub.sci.b : vector-imm byte subtract
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x06070809;  // [06,07,08,09]
            asm volatile("pv.sub.sci.b a3, a4, 2\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            // expect [04,05,06,07] -> 0x04050607
            result_rd = rd;
            if (result_rd != 0x04050607) errs++;
        }
        // pv.avg.h  (vector-vector, halfwords)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0xFFFE0006;  // [-2, 6]
            register int32_t rs2 asm("a5") = 0xFFFC0002;  // [-4, 2]
            asm volatile("pv.avg.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // (-2+-4)>>1 = -3(FFFD), (6+2)>>1 = 4
            if (result_rd != 0xFFFD0004) errs++;
        }

        // pv.avg.sc.h  (vector-scalar, halfwords; replicate low 16b of rs2)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0x00030005;  // [3,5]
            register int32_t rs2 asm("a5") = 0x0000FFFE;  // replicate -2
            asm volatile("pv.avg.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // (3+-2)>>1=0, (5+-2)>>1=1
            if (result_rd != 0x00000001) errs++;
        }

        // pv.avg.sci.h (vector-imm, halfwords; imm sign-extended)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0xFFFD0002;  // [-3,2]
            asm volatile("pv.avg.sci.h a3, a4, -1\n"  // add -1, arithmetic >> 1
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // (-3+-1)>>1=-2(FFFE), (2+-1)>>1=0
            if (result_rd != 0xFFFE0000) errs++;
        }

        // pv.avg.b  (vector-vector, bytes)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0xFC07FF02;  // [-4,7,-1,2]
            register int32_t rs2 asm("a5") = 0xFE0101FE;  // [-2,1,1,-2]
            asm volatile("pv.avg.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [-3,4,0,0] -> 0xFD040000
            if (result_rd != 0xFD040000) errs++;
        }

        // pv.avg.sc.b (vector-scalar, bytes; replicate low 8b of rs2)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0xFE06FE06;  // [-2,6,-2,6]
            register int32_t rs2 asm("a5") = 0x000000FE;  // replicate -2
            asm volatile("pv.avg.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [-2,2,-2,2] -> 0xFE02FE02
            if (result_rd != 0xFE02FE02) errs++;
        }

        // pv.avg.sci.b (vector-imm, bytes; imm sign-extended)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0x02030405;  // [2,3,4,5]
            asm volatile("pv.avg.sci.b a3, a4, -1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [0,1,1,2] -> 0x00010102
            if (result_rd != 0x00010102) errs++;
        }

        // ---------------- pv.avgu.* (unsigned; logical >> 1) ----------------

        // pv.avgu.h (vector-vector, halfwords)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0x12345678;  // [0x1234,0x5678]
            register int32_t rs2 asm("a5") = 0x00100004;  // [0x0010,0x0004]
            asm volatile("pv.avgu.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [(0x1234+0x10)>>1,(0x5678+0x4)>>1]
                             // -> [0x0922,0x2B3E] = 0x09222B3E
            if (result_rd != 0x09222B3E) errs++;
        }

        // pv.avgu.sc.h (vector-scalar, halfwords; replicate low 16b of rs2)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0x10023004;  // [0x1002,0x3004]
            register int32_t rs2 asm("a5") = 0x00000002;  // replicate 0x0002
            asm volatile("pv.avgu.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [(0x1002+2)>>1,(0x3004+2)>>1]
                             // -> [0x0802,0x1803] = 0x08021803
            if (result_rd != 0x08021803) errs++;
        }

        // pv.avgu.sci.h (vector-imm, halfwords; use small positive imm)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0x00040005;  // [4,5]
            asm volatile("pv.avgu.sci.h a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [(4+3)>>1,(5+3)>>1] -> [3,4]
            if (result_rd != 0x00030004) errs++;
        }

        // pv.avgu.b (vector-vector, bytes)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") =
                0x10203040;  // [0x10,0x20,0x30,0x40]
            register int32_t rs2 asm("a5") =
                0x01020304;  // [0x01,0x02,0x03,0x04]
            asm volatile("pv.avgu.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [0x08,0x11,0x19,0x22] = 0x08111922
            if (result_rd != 0x08111922) errs++;
        }

        // pv.avgu.sc.b (vector-scalar, bytes; replicate low 8b of rs2)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0x0507090B;  // [5,7,9,11]
            register int32_t rs2 asm("a5") = 0x00000003;  // replicate 3
            asm volatile("pv.avgu.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [4,5,6,7] = 0x04050607
            if (result_rd != 0x04050607) errs++;
        }

        // pv.avgu.sci.b (vector-imm, bytes; small positive imm)
        {
            register int32_t rd asm("a3") = 0x00000000;
            register int32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4]
            asm volatile("pv.avgu.sci.b a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [1,1,2,2] = 0x01010202
            if (result_rd != 0x01010202) errs++;
        }
        // pv.min.h (vector-vector, halfwords)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x0004FF00;  // [4,-256]
            register int32_t rs2 asm("a5") = 0x0003FF10;  // [3,-240]
            asm volatile("pv.min.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [3,-256] -> 0x0003FF00
            if (result_rd != 0x0003FF00) errs++;
        }

        // pv.min.sc.h (vector-scalar, halfwords; replicate low 16b of rs2)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x0008FF00;  // [8,-256]
            register int32_t rs2 asm("a5") = 0x0006;      // replicate 6
            asm volatile("pv.min.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [6,-256] -> 0x0006FF00
            if (result_rd != 0x0006FF00) errs++;
        }

        // pv.min.sci.h (vector-imm, halfwords)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x0008FF00;  // [8,-256]
            asm volatile("pv.min.sci.h a3, a4, 6\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [6,-256] -> 0x0006FF00
            if (result_rd != 0x0006FF00) errs++;
        }

        // pv.min.b (vector-vector, bytes)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x10111213;  // [16,17,18,19]
            register int32_t rs2 asm("a5") = 0x05060708;  // [5,6,7,8]
            asm volatile("pv.min.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [5,6,7,8] -> 0x05060708
            if (result_rd != 0x05060708) errs++;
        }

        // pv.min.sc.b (vector-scalar, bytes)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x08090A0B;  // [8,9,10,11]
            register int32_t rs2 asm("a5") = 0x00000007;  // replicate 7
            asm volatile("pv.min.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [7,7,7,7] -> 0x07070707
            if (result_rd != 0x07070707) errs++;
        }

        // pv.min.sci.b (vector-imm, bytes)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x08090A0B;  // [8,9,10,11]
            asm volatile("pv.min.sci.b a3, a4, 7\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [7,7,7,7] -> 0x07070707
            if (result_rd != 0x07070707) errs++;
        }

        // pv.minu.h (unsigned, vector-vector, halfwords)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xFF000010;  // [0xFF00,0x0010]
            register uint32_t rs2 asm("a5") = 0x00100008;  // [0x0010,0x0008]
            asm volatile("pv.minu.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [0x0010,0x0008] -> 0x00100008
            if (result_rd != 0x00100008) errs++;
        }

        // pv.minu.sc.h (unsigned, vector-scalar)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xFF000010;
            register uint32_t rs2 asm("a5") = 0x00000008;
            asm volatile("pv.minu.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [8,8] -> 0x00080008
            if (result_rd != 0x00080008) errs++;
        }

        // pv.minu.sci.h (unsigned, imm)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xFF000010;
            asm volatile("pv.minu.sci.h a3, a4, 8\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [8,8] -> 0x00080008
            if (result_rd != 0x00080008) errs++;
        }

        // pv.minu.b (unsigned, vector-vector)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x10FF00F0;
            register uint32_t rs2 asm("a5") = 0x05FF10F1;
            asm volatile("pv.minu.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [5,FF,00,F0] -> 0x05FF00F0
            if (result_rd != 0x05FF00F0) errs++;
        }

        // pv.minu.sc.b (unsigned, vector-scalar)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x08090A0B;
            register uint32_t rs2 asm("a5") = 0x00000008;
            asm volatile("pv.minu.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [8,8,8,8] -> 0x08080808
            if (result_rd != 0x08080808) errs++;
        }

        // pv.minu.sci.b (unsigned, imm)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x08090A0B;
            asm volatile("pv.minu.sci.b a3, a4, 8\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [8,8,8,8] -> 0x08080808
            if (result_rd != 0x08080808) errs++;
        }
        // pv.max.h (vector-vector, halfwords)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0xFFFE000A;  // [-2,10]
            register int32_t rs2 asm("a5") = 0x0005FFF0;  // [5,-16]
            asm volatile("pv.max.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [5,10] -> 0x0005000A
            if (result_rd != 0x0005000A) errs++;
        }

        // pv.max.sc.h (vector-scalar, halfwords)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0xFFFA0004;  // [-6,4]
            register int32_t rs2 asm("a5") = 0x0007;      // scalar=7
            asm volatile("pv.max.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [7,7] -> 0x00070007
            if (result_rd != 0x00070007) errs++;
        }

        // pv.max.sci.h (vector-imm, halfwords)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0xFF000009;  // [-256,9]
            asm volatile("pv.max.sci.h a3, a4, 6\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [6,9] -> 0x00060009
            if (result_rd != 0x00060009) errs++;
        }

        // pv.max.b (vector-vector, bytes)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x7F800102;  // [127,-128,1,2]
            register int32_t rs2 asm("a5") = 0x000203FE;  // [0,2,3,-2]
            asm volatile("pv.max.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [127,2,3,2] -> 0x7F020302
            if (result_rd != 0x7F020302) errs++;
        }

        // pv.max.sc.b (vector-scalar, bytes)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x02030405;  // [2,3,4,5]
            register int32_t rs2 asm("a5") = 0x00000003;  // scalar=3
            asm volatile("pv.max.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [3,3,4,5] -> 0x03030405
            if (result_rd != 0x03030405) errs++;
        }

        // pv.max.sci.b (vector-imm, bytes)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x06050403;  // [6,5,4,3]
            asm volatile("pv.max.sci.b a3, a4, 4\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [6,5,4,4] -> 0x06050404
            if (result_rd != 0x06050404) errs++;
        }

        // pv.maxu.h (unsigned, vector-vector, halfwords)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x80000010;  // [0x8000,0x0010]
            register uint32_t rs2 asm("a5") = 0x7FFF0020;  // [0x7FFF,0x0020]
            asm volatile("pv.maxu.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [0x8000,0x0020] -> 0x80000020
            if (result_rd != 0x80000020) errs++;
        }

        // pv.maxu.sc.h (unsigned, vector-scalar)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x0010FF00;
            register uint32_t rs2 asm("a5") = 0x00000008;
            asm volatile("pv.maxu.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [16,255] -> 0x0010FF00
            if (result_rd != 0x0010FF00) errs++;
        }

        // pv.maxu.sci.h (unsigned, imm)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x00040005;
            asm volatile("pv.maxu.sci.h a3, a4, 6\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [6,6] -> 0x00060006
            if (result_rd != 0x00060006) errs++;
        }

        // pv.maxu.b (unsigned, vector-vector)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x10FF00F0;
            register uint32_t rs2 asm("a5") = 0x05FE20E0;
            asm volatile("pv.maxu.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [16,255,32,240] -> 0x10FF20F0
            if (result_rd != 0x10FF20F0) errs++;
        }

        // pv.maxu.sc.b (unsigned, vector-scalar)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x05060708;
            register uint32_t rs2 asm("a5") = 0x00000006;
            asm volatile("pv.maxu.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [6,6,7,8] -> 0x06060708
            if (result_rd != 0x06060708) errs++;
        }

        // pv.maxu.sci.b (unsigned, imm)
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x01020304;
            asm volatile("pv.maxu.sci.b a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [3,3,3,4] -> 0x03030304
            if (result_rd != 0x03030304) errs++;
        }

        // pv.srl.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xA00F1234;  // [0xA00F,0x1234]
            register uint32_t rs2 asm("a5") = 0x00030002;  // shifts [3,2]
            asm volatile("pv.srl.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x1401048D
            if (result_rd != 0x1401048D) errs++;
        }

        // pv.srl.sc.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xF0001234;
            register uint32_t rs2 asm("a5") = 0x0003;
            asm volatile("pv.srl.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x1E000246
            if (result_rd != 0x1E000246) errs++;
        }

        // pv.srl.sci.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x12345678;
            asm volatile("pv.srl.sci.h a3, a4, 4\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x01230567
            if (result_rd != 0x01230567) errs++;
        }

        // pv.srl.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xF16080FF;  // [F1,60,80,FF]
            register uint32_t rs2 asm("a5") = 0x01020304;  // shifts [1,2,3,4]
            asm volatile("pv.srl.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x7818100F
            if (result_rd != 0x7818100F) errs++;
        }

        // pv.srl.sc.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xF0E0C080;
            register uint32_t rs2 asm("a5") = 0x00000002;
            asm volatile("pv.srl.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x3C383020
            if (result_rd != 0x3C383020) errs++;
        }

        // pv.srl.sci.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xE1C2A304;
            asm volatile("pv.srl.sci.b a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x1C181400
            if (result_rd != 0x1C181400) errs++;
        }

        // pv.sra.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x8001F000;  // [0x8001,0xF000]
            register uint32_t rs2 asm("a5") = 0x00010004;  // shifts [1,4]
            asm volatile("pv.sra.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0xC000FF00
            if (result_rd != 0xC000FF00) errs++;
        }

        // pv.sra.sc.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xFF000040;
            register uint32_t rs2 asm("a5") = 0x0002;
            asm volatile("pv.sra.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0xFFC00010
            if (result_rd != 0xFFC00010) errs++;
        }

        // pv.sra.sci.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xF0007000;
            asm volatile("pv.sra.sci.h a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0xFE000E00
            if (result_rd != 0xFE000E00) errs++;
        }

        // pv.sra.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x80F70810;  // [80,F7,08,10]
            register uint32_t rs2 asm("a5") = 0x01020103;  // shifts [1,2,1,3]
            asm volatile("pv.sra.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0xC0FD0402
            if (result_rd != 0xC0FD0402) errs++;
        }

        // pv.sra.sc.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xE0C0807F;  // [E0,C0,80,7F]
            register uint32_t rs2 asm("a5") = 0x00000002;
            asm volatile("pv.sra.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0xF8F0E01F
            if (result_rd != 0xF8F0E01F) errs++;
        }

        // pv.sra.sci.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x7F80F000;
            asm volatile("pv.sra.sci.b a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x3FC0F800
            if (result_rd != 0x3FC0F800) errs++;
        }

        // pv.sll.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x0F018007;  // [0x0F01,0x8007]
            register uint32_t rs2 asm("a5") = 0x00010003;  // shifts [1,3]
            asm volatile("pv.sll.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x1E020038
            if (result_rd != 0x1E020038) errs++;
        }

        // pv.sll.sc.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x00F00008;
            register uint32_t rs2 asm("a5") = 0x0002;
            asm volatile("pv.sll.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x3C00020
            if (result_rd != 0x3C00020) errs++;
        }

        // pv.sll.sci.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x00010002;
            asm volatile("pv.sll.sci.h a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x00080010
            if (result_rd != 0x00080010) errs++;
        }

        // pv.sll.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x81422311;  // [81,42,23,11]
            register uint32_t rs2 asm("a5") = 0x01020301;  // shifts [1,2,3,1]
            asm volatile("pv.sll.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x02081822
            if (result_rd != 0x02081822) errs++;
        }

        // pv.sll.sc.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x07060504;
            register uint32_t rs2 asm("a5") = 0x00000002;
            asm volatile("pv.sll.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x1C181410
            if (result_rd != 0x1C181410) errs++;
        }

        // pv.sll.sci.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x55AA0180;
            asm volatile("pv.sll.sci.b a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0xAA540200
            if (result_rd != 0xAA540200) errs++;
        }
        // pv.or.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x0F0F00F0;  // [0x0F0F,0x00F0]
            register uint32_t rs2 asm("a5") = 0x00F0000F;  // [0x00F0,0x000F]
            asm volatile("pv.or.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd =
                rd;  // [0x0F0F|0x00F0=0x0FFF, 0x00F0|0x000F=0x00FF] -> 0x0FFF00FF
            if (result_rd != 0x0FFF00FF) errs++;
        }

        // pv.or.sc.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x123400F0;
            register uint32_t rs2 asm("a5") = 0x00AA;
            asm volatile("pv.or.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // [0x12BE,0x00FA] -> 0x12BE00FA
            if (result_rd != 0x12BE00FA) errs++;
        }

        // pv.or.sci.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x00F0000F;
            asm volatile("pv.or.sci.h a3, a4, 0x0A\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [0x00FA,0x000F|0x000A=0x000F] -> 0x00FA000F
            if (result_rd != 0x00FA000F) errs++;
        }

        // pv.or.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x11223344;
            register uint32_t rs2 asm("a5") = 0x0F0F0F0F;
            asm volatile("pv.or.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x1F2F3F4F
            if (result_rd != 0x1F2F3F4F) errs++;
        }

        // pv.or.sc.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x01020304;
            register uint32_t rs2 asm("a5") = 0x0000000F;
            asm volatile("pv.or.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x0F0F0F0F
            if (result_rd != 0x0F0F0F0F) errs++;
        }

        // pv.or.sci.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xA1B2C3D4;
            asm volatile("pv.or.sci.b a3, a4, 0x0F\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0xAFBFCFDF
            if (result_rd != 0xAFBFCFDF) errs++;
        }

        // pv.xor.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xAAAA5555;
            register uint32_t rs2 asm("a5") = 0x0F0FF0F0;
            asm volatile("pv.xor.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd =
                rd;  // [0xAAAA^0x0F0F=0xA5A5,0x5555^0xF0F0=0xA5A5] -> 0xA5A5A5A5
            if (result_rd != 0xA5A5A5A5) errs++;
        }

        // pv.xor.sc.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x0F0F000F;
            register uint32_t rs2 asm("a5") = 0x00FF;
            asm volatile("pv.xor.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x0FF000F0
            if (result_rd != 0x0FF000F0) errs++;
        }

        // pv.xor.sci.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x123400F0;
            asm volatile("pv.xor.sci.h a3, a4, 10\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x129E00AA
            if (result_rd != 0x123E00FA) errs++;
        }

        // pv.xor.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x01020304;
            register uint32_t rs2 asm("a5") = 0x0F0F0F0F;
            asm volatile("pv.xor.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x0E0D0C0B
            if (result_rd != 0x0E0D0C0B) errs++;
        }

        // pv.xor.sc.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x55667788;
            register uint32_t rs2 asm("a5") = 0x0000000F;
            asm volatile("pv.xor.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x5a697887
            if (result_rd != 0x5a697887) errs++;
        }

        // pv.xor.sci.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x12345678;
            asm volatile("pv.xor.sci.b a3, a4, 10\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x183e5c72
            if (result_rd != 0x183e5c72) errs++;
        }

        // pv.and.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xFFFF00FF;
            register uint32_t rs2 asm("a5") = 0x0F0FF0F0;
            asm volatile("pv.and.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x0F0F00F0
            if (result_rd != 0x0F0F00F0) errs++;
        }

        // pv.and.sc.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x12345678;
            register uint32_t rs2 asm("a5") = 0x00F0;
            asm volatile("pv.and.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x00300070
            if (result_rd != 0x00300070) errs++;
        }

        // pv.and.sci.h
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x0F0F00F0;
            asm volatile("pv.and.sci.h a3, a4, 0x0A\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x000A0000
            if (result_rd != 0x000A0000) errs++;
        }

        // pv.and.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x11223344;
            register uint32_t rs2 asm("a5") = 0x0F0F0F0F;
            asm volatile("pv.and.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x01020304
            if (result_rd != 0x01020304) errs++;
        }

        // pv.and.sc.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0xF1E2D3C4;
            register uint32_t rs2 asm("a5") = 0x0000000F;
            asm volatile("pv.and.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -> 0x01020304
            if (result_rd != 0x01020304) errs++;
        }

        // pv.and.sci.b
        {
            register uint32_t rd asm("a3") = 0;
            register uint32_t rs1 asm("a4") = 0x55667788;
            asm volatile("pv.and.sci.b a3, a4, 16\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -> 0x10001000
            if (result_rd != 0x10001000) errs++;
        }

        // pv.abs.h
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x8001F000;  // [-32767,-4096]
            asm volatile("pv.abs.h a3, a4\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [32767,4096] -> 0x7FFF1000
            if (result_rd != 0x7FFF1000) errs++;
        }

        // pv.abs.b
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x80F70810;  // [-128,-9,8,16]
            asm volatile("pv.abs.b a3, a4\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // [128,9,8,16] -> 0x80090810 (wrap for -128)
            if (result_rd != 0x80090810) errs++;
        }

        // pv.extract.h (I=0,1)  — sign-extend
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0xABCD1234;
            asm volatile("pv.extract.h a3, a4, 0\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0x1234 -> 0x00001234
            if (result_rd != 0x00001234) errs++;

            asm volatile("pv.extract.h a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0xABCD -> 0xFFFFABCD
            if (result_rd != 0xFFFFABCD) errs++;
        }

        // pv.extract.b (I=0,3)  — sign-extend
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") =
                0x80F70810;  // [0x80,0xF7,0x08,0x10]
            asm volatile("pv.extract.b a3, a4, 0\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0x10 -> 0x00000010
            if (result_rd != 0x00000010) errs++;

            asm volatile("pv.extract.b a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0x80 -> 0xFFFFFF80
            if (result_rd != 0xFFFFFF80) errs++;
        }

        // pv.extractu.h (I=1,0) — zero-extend
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0xABCD1234;
            asm volatile("pv.extractu.h a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0xABCD -> 0x0000ABCD
            if (result_rd != 0x0000ABCD) errs++;

            asm volatile("pv.extractu.h a3, a4, 0\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0x1234 -> 0x00001234
            if (result_rd != 0x00001234) errs++;
        }

        // pv.extractu.b (I=3,1) — zero-extend
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x80F70810;
            asm volatile("pv.extractu.b a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0x80 -> 0x00000080
            if (result_rd != 0x00000080) errs++;

            asm volatile("pv.extractu.b a3, a4, 1\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 0x8 -> 0x0000008
            if (result_rd != 0x00000008) errs++;
        }

        // pv.insert.h (I=1 then I=0) — rD preserved in other lanes
        {
            register int32_t rd asm("a3") = 0x11112222;   // initial rD
            register int32_t rs1 asm("a4") = 0x0000BEEF;  // low 16 bits used
            asm volatile("pv.insert.h a3, a4, 1\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // upper half replaced -> 0xBEEF2222
            if (result_rd != 0xBEEF2222) errs++;

            rd = 0x11112222;
            asm volatile("pv.insert.h a3, a4, 0\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // lower half replaced -> 0x1111BEEF
            if (result_rd != 0x1111BEEF) errs++;
        }

        // pv.insert.b (I=2 then I=0) — rD preserved in other lanes
        {
            register int32_t rd asm("a3") = 0x11223344;
            register int32_t rs1 asm("a4") = 0x000000AA;  // low 8 bits used
            asm volatile("pv.insert.b a3, a4, 2\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // byte[2] = 0xAA -> 0x11AA3344
            if (result_rd != 0x11AA3344) errs++;

            rd = 0x11223344;
            asm volatile("pv.insert.b a3, a4, 0\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // byte[0] = 0xAA -> 0x112233AA
            if (result_rd != 0x112233AA) errs++;
        }

        // pv.dotsp.h (vector-vector)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00010002;  // [1,2]
            register int32_t rs2 asm("a5") = 0x00030004;  // [3,4]
            asm volatile("pv.dotsp.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 1*3 + 2*4 = 3 + 8 = 11
            if (result_rd != 11) errs++;
        }

        // pv.dotsp.sc.h (vector-scalar)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0xFFFE0003;  // [-2,3]
            register int32_t rs2 asm("a5") = 0x0004;      // scalar = 4
            asm volatile("pv.dotsp.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // (-2)*4 + 3*4 = -8 + 12 = 4
            if (result_rd != 4) errs++;
        }

        // pv.dotsp.sci.h (vector-imm)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x0002FFFE;  // [2,-2]
            asm volatile("pv.dotsp.sci.h a3, a4, 3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 2*3 + (-2)*3 = 6 - 6 = 0
            if (result_rd != 0) errs++;
        }

        // pv.dotsp.b (vector-vector)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4]
            register int32_t rs2 asm("a5") = 0x05060708;  // [5,6,7,8]
            asm volatile("pv.dotsp.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 1*5 + 2*6 + 3*7 + 4*8 = 5 + 12 + 21 + 32 = 70
            if (result_rd != 70) errs++;
        }

        // pv.dotsp.sc.b (vector-scalar)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01FF0203;  // [1,-1,2,3]
            register int32_t rs2 asm("a5") = 0x00000004;  // scalar = 4
            asm volatile("pv.dotsp.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 1*4 + (-1)*4 + 2*4 + 3*4 = 4 - 4 + 8 + 12 = 20
            if (result_rd != 20) errs++;
        }

        // pv.dotsp.sci.b (vector-imm)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x010203FD;  // [1,2,3,-3]
            asm volatile("pv.dotsp.sci.b a3, a4, 5\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 1*5 + 2*5 + 3*5 + (-3)*5 = 5 + 10 + 15 - 15 = 15
            if (result_rd != 15) errs++;
        }

        // pv.dotup.h (unsigned × unsigned)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00020003;  // [2,3]
            register int32_t rs2 asm("a5") = 0x00040005;  // [4,5]
            asm volatile("pv.dotup.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 2*4 + 3*5 = 8 + 15 = 23
            if (result_rd != 23) errs++;
        }

        // pv.dotup.sc.h (unsigned × scalar)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00FE0002;  // [254,2]
            register int32_t rs2 asm("a5") = 0x0003;      // scalar = 3
            asm volatile("pv.dotup.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 254*3 + 2*3 = 762 + 6 = 768
            if (result_rd != 768) errs++;
        }

        // pv.dotup.sci.h (unsigned × imm)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00030004;  // [3,4]
            asm volatile("pv.dotup.sci.h a3, a4, 5\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 3*5 + 4*5 = 15 + 20 = 35
            if (result_rd != 35) errs++;
        }

        // pv.dotup.b (unsigned × unsigned)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4]
            register int32_t rs2 asm("a5") = 0x05060708;  // [5,6,7,8]
            asm volatile("pv.dotup.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 1*5 + 2*6 + 3*7 + 4*8 = 70
            if (result_rd != 70) errs++;
        }

        // pv.dotup.sc.b (unsigned × scalar)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4]
            register int32_t rs2 asm("a5") = 0x00000003;  // scalar = 3
            asm volatile("pv.dotup.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // (1+2+3+4)*3 = 10*3 = 30
            if (result_rd != 30) errs++;
        }

        // pv.dotup.sci.b (unsigned × imm)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x05060708;  // [5,6,7,8]
            asm volatile("pv.dotup.sci.b a3, a4, 2\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // (5+6+7+8)*2 = 26*2 = 52
            if (result_rd != 52) errs++;
        }

        // -------------------------------------------------------
        // pv.dotusp.h (unsigned × signed)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00030004;  // [3,4] unsigned
            register int32_t rs2 asm("a5") = 0xFFFE0002;  // [-2,2] signed
            asm volatile("pv.dotusp.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 3*(-2) + 4*2 = -6 + 8 = 2
            if (result_rd != 2) errs++;
        }

        // pv.dotusp.sc.h (unsigned × signed scalar)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00030004;  // [3,4] unsigned
            register int32_t rs2 asm("a5") =
                0xFFFE;  // scalar = -2 signed (low 16b replicated)
            asm volatile("pv.dotusp.sc.h a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 3*(-2) + 4*(-2) = -6 - 8 = -14
            if (result_rd != -14) errs++;
        }

        // pv.dotusp.sci.h (unsigned × signed imm)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x00030002;  // [3,2] unsigned
            asm volatile("pv.dotusp.sci.h a3, a4, -3\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 3*(-3) + 2*(-3) = -9 - 6 = -15
            if (result_rd != -15) errs++;
        }

        // pv.dotusp.b (unsigned × signed)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x05060708;  // [5,6,7,8] unsigned
            register int32_t rs2 asm("a5") = 0x01FF0203;  // [1,-1,2,3] signed
            asm volatile("pv.dotusp.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 5*1 + 6*(-1) + 7*2 + 8*3 = 5 - 6 + 14 + 24 = 37
            if (result_rd != 37) errs++;
        }

        // pv.dotusp.sc.b (unsigned × signed scalar)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4] unsigned
            register int32_t rs2 asm("a5") =
                0xFFFFFFFD;  // scalar = -3 signed (low 8b replicated)
            asm volatile("pv.dotusp.sc.b a3, a4, a5\n"
                         : "=r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 1*(-3) + 2*(-3) + 3*(-3) + 4*(-3) = -30
            if (result_rd != -30) errs++;
        }

        // pv.dotusp.sci.b (unsigned × signed imm)
        {
            register int32_t rd asm("a3") = 0;
            register int32_t rs1 asm("a4") = 0x05060708;  // [5,6,7,8] unsigned
            asm volatile("pv.dotusp.sci.b a3, a4, -2\n"
                         : "=r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 5*(-2) + 6*(-2) + 7*(-2) + 8*(-2) = -52
            if (result_rd != -52) errs++;
        }

        // -------------------------------------------------------
        // pv.sdotsp.h (signed × signed + accumulate)
        {
            register int32_t rd asm("a3") =
                10;  // start with 10 to test accumulation
            register int32_t rs1 asm("a4") = 0xFFFE0003;  // [-2,3]
            register int32_t rs2 asm("a5") = 0x00040005;  // [4,5]
            asm volatile("pv.sdotsp.h a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // old 10 + (-2*4 + 3*5) = 10 + (-8 + 15) = 17
            if (result_rd != 17) errs++;
        }

        // pv.sdotsp.sc.h (signed × signed scalar + accumulate)
        {
            register int32_t rd asm("a3") = -5;
            register int32_t rs1 asm("a4") = 0x00030004;  // [3,4]
            register int32_t rs2 asm("a5") =
                0xFFFD;  // scalar = -3 (low 16b replicated)
            asm volatile("pv.sdotsp.sc.h a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -5 + (3*-3 + 4*-3) = -5 + (-9 -12) = -26
            if (result_rd != -26) errs++;
        }

        // pv.sdotsp.sci.h (signed × signed imm + accumulate)
        {
            register int32_t rd asm("a3") = 7;
            register int32_t rs1 asm("a4") = 0x00020003;  // [2,3]
            asm volatile("pv.sdotsp.sci.h a3, a4, -2\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 7 + (2*-2 + 3*-2) = 7 + (-4 -6) = -3
            if (result_rd != -3) errs++;
        }

        // pv.sdotsp.b (signed × signed + accumulate)
        {
            register int32_t rd asm("a3") = 5;
            register int32_t rs1 asm("a4") = 0x01FF0203;  // [1,-1,2,3]
            register int32_t rs2 asm("a5") = 0x05060708;  // [5,6,7,8]
            asm volatile("pv.sdotsp.b a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd =
                rd;  // 5 + (1*5 + (-1)*6 + 2*7 + 3*8) = 5 + (5 -6 +14 +24) = 42
            if (result_rd != 42) errs++;
        }

        // pv.sdotsp.sc.b (signed × signed scalar + accumulate)
        {
            register int32_t rd asm("a3") = -8;
            register int32_t rs1 asm("a4") = 0x010203FD;  // [1,2,3,-3]
            register int32_t rs2 asm("a5") = 0x00000003;  // scalar = 3
            asm volatile("pv.sdotsp.sc.b a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd =
                rd;  // -8 + (1*3 + 2*3 + 3*3 + (-3)*3) = -8 + (3 +6 +9 -9) = 1
            if (result_rd != 1) errs++;
        }

        // pv.sdotsp.sci.b (signed × signed imm + accumulate)
        {
            register int32_t rd asm("a3") = 4;
            register int32_t rs1 asm("a4") = 0x01FF0203;  // [1,-1,2,3]
            asm volatile("pv.sdotsp.sci.b a3, a4, 2\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd =
                rd;  // 4 + (1*2 + (-1)*2 + 2*2 + 3*2) = 4 + (2 -2 +4 +6) = 14
            if (result_rd != 14) errs++;
        }

        // -------------------------------------------------------
        // pv.sdotup.h (unsigned × unsigned + accumulate)
        {
            register uint32_t rd asm("a3") = 5;            // start accumulator
            register uint32_t rs1 asm("a4") = 0x00020003;  // [2,3]
            register uint32_t rs2 asm("a5") = 0x00040005;  // [4,5]
            asm volatile("pv.sdotup.h a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 5 + (2*4 + 3*5) = 5 + (8 + 15) = 28
            if (result_rd != 28) errs++;
        }

        // pv.sdotup.sc.h (unsigned × unsigned scalar + accumulate)
        {
            register uint32_t rd asm("a3") = 10;
            register uint32_t rs1 asm("a4") = 0x00030004;  // [3,4]
            register uint32_t rs2 asm("a5") = 0x0002;      // scalar = 2
            asm volatile("pv.sdotup.sc.h a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 10 + (3*2 + 4*2) = 10 + (6 + 8) = 24
            if (result_rd != 24) errs++;
        }

        // pv.sdotup.sci.h (unsigned × unsigned imm + accumulate)
        {
            register uint32_t rd asm("a3") = 7;
            register uint32_t rs1 asm("a4") = 0x00030002;  // [3,2]
            asm volatile("pv.sdotup.sci.h a3, a4, 3\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 7 + (3*3 + 2*3) = 7 + (9 + 6) = 22
            if (result_rd != 22) errs++;
        }

        // pv.sdotup.b (unsigned × unsigned + accumulate)
        {
            register uint32_t rd asm("a3") = 4;
            register uint32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4]
            register uint32_t rs2 asm("a5") = 0x05060708;  // [5,6,7,8]
            asm volatile("pv.sdotup.b a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd =
                rd;  // 4 + (1*5 + 2*6 + 3*7 + 4*8) = 4 + (5+12+21+32) = 74
            if (result_rd != 74) errs++;
        }

        // pv.sdotup.sc.b (unsigned × unsigned scalar + accumulate)
        {
            register uint32_t rd asm("a3") = 3;
            register uint32_t rs1 asm("a4") = 0x05060708;  // [5,6,7,8]
            register uint32_t rs2 asm("a5") = 0x00000002;  // scalar = 2
            asm volatile("pv.sdotup.sc.b a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 3 + ((5+6+7+8)*2) = 3 + (26*2) = 55
            if (result_rd != 55) errs++;
        }

        // pv.sdotup.sci.b (unsigned × unsigned imm + accumulate)
        {
            register uint32_t rd asm("a3") = 2;
            register uint32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4]
            asm volatile("pv.sdotup.sci.b a3, a4, 3\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 2 + ((1+2+3+4)*3) = 2 + (10*3) = 32
            if (result_rd != 32) errs++;
        }

        // -------------------------------------------------------
        // pv.sdotusp.h (unsigned × signed + accumulate)
        {
            register int32_t rd asm("a3") = 5;
            register int32_t rs1 asm("a4") = 0x00030004;  // [3,4] unsigned
            register int32_t rs2 asm("a5") = 0xFFFE0002;  // [-2,2] signed
            asm volatile("pv.sdotusp.h a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 5 + (3*-2 + 4*2) = 5 + (-6 + 8) = 7
            if (result_rd != 7) errs++;
        }

        // pv.sdotusp.sc.h (unsigned × signed scalar + accumulate)
        {
            register int32_t rd asm("a3") = 12;
            register int32_t rs1 asm("a4") = 0x00020003;  // [2,3] unsigned
            register int32_t rs2 asm("a5") = 0xFFFD;      // scalar = -3 signed
            asm volatile("pv.sdotusp.sc.h a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // 12 + (2*-3 + 3*-3) = 12 + (-6 -9) = -3
            if (result_rd != -3) errs++;
        }

        // pv.sdotusp.sci.h (unsigned × signed imm + accumulate)
        {
            register int32_t rd asm("a3") = -4;
            register int32_t rs1 asm("a4") = 0x00040002;  // [4,2] unsigned
            asm volatile("pv.sdotusp.sci.h a3, a4, -2\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // -4 + (4*-2 + 2*-2) = -4 + (-8 -4) = -16
            if (result_rd != -16) errs++;
        }

        // pv.sdotusp.b (unsigned × signed + accumulate)
        {
            register int32_t rd asm("a3") = 3;
            register int32_t rs1 asm("a4") = 0x05060708;  // [5,6,7,8] unsigned
            register int32_t rs2 asm("a5") = 0x01FF0203;  // [1,-1,2,3] signed
            asm volatile("pv.sdotusp.b a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd =
                rd;  // 3 + (5*1 + 6*-1 + 7*2 + 8*3) = 3 + (5 -6 +14 +24) = 40
            if (result_rd != 40) errs++;
        }

        // pv.sdotusp.sc.b (unsigned × signed scalar + accumulate)
        {
            register int32_t rd asm("a3") = -2;
            register int32_t rs1 asm("a4") = 0x01020304;  // [1,2,3,4] unsigned
            register int32_t rs2 asm("a5") = 0xFFFFFFFE;  // scalar = -2 signed
            asm volatile("pv.sdotusp.sc.b a3, a4, a5\n"
                         : "+r"(rd)
                         : "r"(rs1), "r"(rs2)
                         : "a3", "a4", "a5");
            result_rd = rd;  // -2 + ((1+2+3+4)*-2) = -2 + (10*-2) = -22
            if (result_rd != -22) errs++;
        }

        // pv.sdotusp.sci.b (unsigned × signed imm + accumulate)
        {
            register int32_t rd asm("a3") = 6;
            register int32_t rs1 asm("a4") = 0x05060708;  // [5,6,7,8] unsigned
            asm volatile("pv.sdotusp.sci.b a3, a4, -3\n"
                         : "+r"(rd)
                         : "r"(rs1)
                         : "a3", "a4");
            result_rd = rd;  // 6 + ((5+6+7+8)*-3) = 6 + (26*-3) = 6 - 78 = -72
            if (result_rd != -72) errs++;
        }

        return errs;
    } else
        return 0;
    snrt_cluster_hw_barrier();
#endif
    return 0;
}