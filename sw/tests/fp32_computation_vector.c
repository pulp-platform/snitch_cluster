// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <snrt.h>

int main() {
    if (snrt_is_compute_core()) {
        int errs = 0;

        uint32_t i_a = 0x4048F5C3;   // 3.14 0
        uint32_t i_an = 0xC048F5C3;  // -3.14
        uint32_t i_b = 0x3FCF1AA0;   // 1.618 2
        uint32_t i_bn = 0xBFCF1AA0;  // -1.618
        uint32_t i_c = 0x4018FFEB;   // 2.39062
        uint32_t i_cn = 0xC018FFEB;  // -2.39062
        uint32_t i_d = 0x3E801FFB;   // 0.250244 6
        uint32_t i_dn = 0xBE801FFB;  // -0.250244
        uint32_t i_e = 0x3F000000;   // 0.5
        uint32_t i_en = 0xBF000000;  // -0.5
        uint32_t i_f = 0x42C83F36;   // 100.123456789 10
        uint32_t i_fn = 0xC2C83F36;  // -100.123456789

        int res0 = 0;
        uint32_t res1 = 0;
        uint32_t res2 = 0;
        uint32_t res3 = 0;
        uint32_t res4 = 0;

        asm volatile(
            "fmv.s.x ft0, %0\n"// 3.14
            "fmv.s.x ft1, %1\n"// -2.39062
            "fmv.s.x ft2, %2\n"// 1.618
            "fmv.s.x ft3, %3\n"// -0.250244
            "vfcpka.s.s ft4, ft0, ft2\n"  // ft4 = [1.618, 3.14]
            "vfcpka.s.s ft5, ft1, ft3\n"  // ft5 = [-0.250244, -2.39062]
            "vfcpka.s.s ft6, ft0, ft3\n"  // ft6 = [-0.250244, 3.14]
            "vfcpka.s.s ft7, ft2, ft1\n"  // ft7 = [-2.39062, 1.618]
            : "+r"(i_a), "+r"(i_cn), "+r"(i_b), "+r"(i_dn));

        uint32_t mask = 0x0;
        uint32_t mask_a = 0b10010000; // 0h90
        uint32_t mask_b = 0b10011000; // 0h98
        uint32_t mask_c = 0b10000001; // 0h81
        uint32_t mask_d = 0b10001001; // 0h89
        uint32_t mask_e = 0b00000001; // 0h01
        uint32_t mask_f = 0b10000000; // 0h80
        uint32_t mask_g = 0b00001001; // 0h09

        // VFSHUFFLE FP32

        asm volatile(
            "vfshuffle.s ft4, ft5, %0\n" // rD = 0x3FCF1AA0 4048F5C3, rA = 0xBE801FFB C018FFEB, rB = 0x90
            "vfeq.s %1, ft4, ft6\n"     //  result = 0xBE801FFB 4048F5C3 = [-0.250244, 3.14]
            : "+r"(mask_a), "+r"(res0));
        errs += (res0 != 0x3);
        
        asm volatile(
            "vfcpka.s.s ft4, ft0, ft2\n"  //ft4 = [1.618, 3.14]
            "vfshuffle.s ft4, ft5, %0\n" // rD = 0x3FCF1AA0 4048F5C3, rA = 0xBE801FFB C018FFEB, rB = 0x98
            "vfeq.s %1, ft4, ft5\n"     //  result = 0xBE801FFB C018FFEB = [-0.250244, -2.39062]
            : "+r"(mask_b), "+r"(res0));
        errs += (res0 != 0x3);

        asm volatile(
            "vfcpka.s.s ft4, ft0, ft2\n"  //ft4 = [1.618, 3.14]
            "vfshuffle.s ft4, ft5, %0\n" // rD = 0x3FCF1AA0 4048F5C3, rA = 0xBE801FFB C018FFEB, rB = 0x81
            "vfeq.s %1, ft4, ft7\n"     //  result = 0xC018FFEB 3FCF1AA0 = [-2.39062, 1.618]
            : "+r"(mask_c), "+r"(res0));
        errs += (res0 != 0x3);



        // load new data
        asm volatile(
            "fmv.s.x ft0, %0\n"           // 3.14
            "fmv.s.x ft1, %1\n"           // -1.618
            "fmv.s.x ft2, %2\n"           // 0.250244
            "fmv.s.x ft3, %3\n"           // 100.123456789
            "vfcpka.s.s ft4, ft3, ft0\n"  // ft4 = [3.14, 100.123456789]
            "vfcpka.s.s ft5, ft2, ft1\n"  // ft5 = [-1.618, 0.250244]
            "vfcpka.s.s ft6, ft1, ft3\n"  // ft6 = [100.123456789, -1.618]
            "vfcpka.s.s ft7, ft3, ft2\n"  // ft7 = [0.250244, 100.123456789]
            : "+r"(i_a), "+r"(i_bn), "+r"(i_d), "+r"(i_f));

        asm volatile(
            "vfshuffle.s ft4, ft5, %0\n" // rD = 0x4048F5C3 42C83F36, rA = 0xBFCF1AA0 3E801FFB, rB = 0x09
            "vfeq.s %1, ft4, ft6\n"     //  result = 0x42C83F36 BFCF1AA0 = [100.123456789, -1.618]
            : "+r"(mask_g), "+r"(res0));
        errs += (res0 != 0x3);

        asm volatile(
            "vfcpka.s.s ft4, ft3, ft0\n"  //ft4 = [3.14, 100.123456789]
            "vfshuffle.s ft4, ft5, %0\n" // rD = 0x4048F5C3 42C83F36, rA = 0xBFCF1AA0 3E801FFB, rB = 0x80
            "vfeq.s %1, ft4, ft7\n"     //  result = 0x3E801FFB 42C83F36 = [0.250244, 100.123456789]
            : "+r"(mask_f), "+r"(res0));
        errs += (res0 != 0x3);


        // load new data
        asm volatile(
            // "fmv.s.x ft0, %0\n"           // 3.14
            // "fmv.s.x ft1, %1\n"           // -1.618
            // "fmv.s.x ft2, %2\n"           // 0.250244
            // "fmv.s.x ft3, %3\n"           // 100.123456789
            "vfcpka.s.s ft4, ft3, ft0\n"  // ft4 = [3.14, 100.123456789]
            // "vfcpka.s.s ft5, ft2, ft1\n"  // ft5 = [-1.618, 0.250244]
            "vfcpka.s.s ft6, ft1, ft2\n"  // ft6 = [0.250244, -1.618]
            "vfcpka.s.s ft7, ft0, ft3\n"  // ft7 = [100.123456789, 3.14]
            : "+r"(i_a), "+r"(i_bn), "+r"(i_d), "+r"(i_f));

        asm volatile(
            "vfshuffle.s ft4, ft5, %0\n" // rD = 0x4048F5C3 42C83F36, rA = 0xBFCF1AA0 3E801FFB, rB = 0x89
            "vfeq.s %1, ft4, ft6\n"     //  result = 0x3E801FFB BFCF1AA0 = [0.250244, -1.618]
            : "+r"(mask_d), "+r"(res0));
        errs += (res0 != 0x3);

        asm volatile(
            "vfcpka.s.s ft4, ft3, ft0\n"  //ft4 = [3.14, 100.123456789]
            "vfshuffle.s ft4, ft5, %0\n" // rD = 0x4048F5C3 42C83F36, rA = 0xBFCF1AA0 3E801FFB, rB = 0x01
            "vfeq.s %1, ft4, ft7\n"     //  result = 0x42C83F36 4048F5C3 = [100.123456789, 3.14]
            : "+r"(mask_e), "+r"(res0));
        errs += (res0 != 0x3);


        // VFSHUFFLE FP16

        asm volatile(
            "fmv.s.x ft0, %0\n" // 3.14 
            "fmv.s.x ft1, %1\n" // 0.5
            "fmv.s.x ft2, %2\n" // 1.618
            "fmv.s.x ft3, %3\n" // 100.123456789
            "vfcpka.h.s ft4, ft0, ft2\n"
            "vfcpkb.h.s ft4, ft1, ft3\n"  // ft4 = [100.125, 0.5, 1.6181640625, 3.140625]
            "fmv.s.x ft0, %0\n" // 3.14 
            "fmv.s.x ft1, %1\n" // 0.5
            "fmv.s.x ft2, %2\n" // 1.618
            "fmv.s.x ft3, %3\n" // 100.123456789            
            "vfcpka.h.s ft5, ft3, ft1\n"
            "vfcpkb.h.s ft5, ft2, ft0\n"  // ft5 = 
            "vfcpka.h.s ft6, ft0, ft3\n"
            "vfcpkb.h.s ft6, ft0, ft3\n"  // ft6 = {3.14, -1.618, 3.14, -1.618}
            "vfcpka.h.s ft7, ft1, ft2\n"
            "vfcpkb.h.s ft7, ft1, ft2\n"  // ft7 = {-3.14, 1.618, -3.14, 1.618}
            : "+r"(i_a), "+r"(i_e), "+r"(i_b), "+r"(i_f));

        asm volatile(
            "vfshuffle.h ft4, ft5, %0\n" // rD = 0x4048F5C3 42C83F36, rA = 0xBFCF1AA0 3E801FFB, rB = 0x89
            "vfeq.h %1, ft4, ft6\n"     //  result = 0x3E801FFB BFCF1AA0 = [0.250244, -1.618]
            : "+r"(mask_d), "+r"(res0));
        errs += (res0 != 0xf);

        // VFSGNJ
        asm volatile(
            "vfsgnj.h ft0, ft4, ft4\n"
            "vfeq.h %0, ft4, ft0\n"
            : "+r"(res0));
        errs += (res0 != 0xf);


        // VFSHUFLE FP8


 /*    

        // load new data
        asm volatile(
            "fmv.s.x ft0, %0\n"           // 3.14
            "fmv.s.x ft1, %1\n"           // -1.618
            "fmv.s.x ft2, %2\n"           // 0.250244
            "fmv.s.x ft3, %3\n"           // 100.123456789
            "vfcpka.s.s ft4, ft3, ft0\n"  // ft4 = {100.123456789, 3.14}
            "vfcpka.s.s ft5, ft2, ft1\n"  // ft5 = {0.250244, -1.618}
            "vfcpka.s.s ft6, ft1, ft3\n"  // ft6 = {-1.618, 100.123456789}
            : "+r"(i_a), "+r"(i_bn), "+r"(i_d), "+r"(i_f));

        // VFADD
        // pack results
        res1 = 0x42C8BF56;
        res2 = 0x3FC2D0E6;
        res3 = 0xBFAF12A1;
        res4 = 0x42C502CC;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfadd.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfadd.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFADD.R
        // pack results
        res1 = 0x42C8BF56;
        res2 = 0x4058F9C2;
        res3 = 0xBFAF12A1;
        res4 = 0xC04F1AA0;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfadd.r.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfadd.r.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFSUB
        // pack results
        res1 = 0x42C7BF16;
        res2 = 0x4098418A;
        res3 = 0x3FEF229F;
        res4 = 0xC2CB7BA0;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfsub.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfsub.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFSUB.R
        // pack results
        res1 = 0x42C7BF16;
        res2 = 0x4038F1C4;
        res3 = 0x3FEF229F;
        res4 = 0x00000000;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfsub.r.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfsub.r.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFMUL
        // pack results
        res1 = 0x41C8713E;
        res2 = 0xC0A2939F;
        res3 = 0xBECF4E5F;
        res4 = 0xC321FFF0;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfmul.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfmul.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFMUL.R
        // pack results
        res1 = 0x41C8713E;
        res2 = 0x3F4927F9;
        res3 = 0xBECF4E5F;
        res4 = 0x40278C12;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfmul.r.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfmul.r.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFMAC
        // pack results
        res1 = 0x41C8713E;
        res2 = 0xC0A2939F;
        res3 = 0x41C53405;
        res4 = 0xC327148D;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            // reset ft0
            "fcvt.d.w ft0, zero\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfmac.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfmac.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFMAC.R
        // pack results
        res1 = 0x41C8713E;
        res2 = 0x3F4927F9;
        res3 = 0x41C53405;
        res4 = 0x4059D610;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            // reset ft0
            "fcvt.d.w ft0, zero\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfmac.r.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfmac.r.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFMRE
        // pack results
        res1 = 0xC1C8713E;
        res2 = 0x40A2939F;
        res3 = 0xC1C53405;
        res4 = 0x4327148D;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            // reset ft0
            "fcvt.d.w ft0, zero\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfmre.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfmre.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // pack results
        res1 = 0x43095970;
        res2 = 0xC3134EB1;

        asm volatile(
            "fmv.s.x ft1, %0\n"
            "fmv.s.x ft2, %1\n"
            // pack h values
            "vfcpka.s.s ft7, ft1, ft2\n"
            // do NOT reset ft0
            : "+r"(res1), "+r"(res2));

        asm volatile(
            "vfmre.s ft0, ft4, ft6\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // VFMRE.R
        // pack results
        res1 = 0xC1C8713E;
        res2 = 0xBF4927F9;
        res3 = 0xC1C53405;
        res4 = 0xC059D610;

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            // pack h values
            "vfcpka.s.s ft7, ft0, ft1\n"
            "vfcpka.s.s ft8, ft2, ft3\n"
            // reset ft0
            "fcvt.d.w ft0, zero\n"
            : "+r"(res1), "+r"(res2), "+r"(res3), "+r"(res4));

        asm volatile(
            "vfmre.r.s ft0, ft4, ft5\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        asm volatile(
            "vfmre.r.s ft0, ft5, ft6\n"
            "vfeq.s %0, ft8, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);

        // pack results
        res1 = 0x43095970;
        res2 = 0x3FD6A25D;

        asm volatile(
            "fmv.s.x ft1, %0\n"
            "fmv.s.x ft2, %1\n"
            // pack h values
            "vfcpka.s.s ft7, ft1, ft2\n"
            // do NOT reset ft0
            : "+r"(res1), "+r"(res2));

        asm volatile(
            "vfmre.r.s ft0, ft4, ft6\n"
            "vfeq.s %0, ft7, ft0\n"
            : "+r"(res0));
        errs -= (res0 == 0x3);
*/
        return errs;
    }
    return 0;
}
