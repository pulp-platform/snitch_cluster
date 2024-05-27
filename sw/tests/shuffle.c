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
        uint32_t i_g = 0x40B80000;   // 5.75
        uint32_t i_h = 0x410428F6;   // 8.26
        uint32_t i_i = 0x42493333;   // 50.3
        uint32_t i_j = 0x40866666;   // 4.2

        int res0 = 0;

        uint32_t mask_a = 0b10010000; // 0h90
        uint32_t mask_b = 0b10011000; // 0h98
        uint32_t mask_c = 0b10000001; // 0h81
        uint32_t mask_d = 0b10001001; // 0h89
        uint32_t mask_e = 0b00000001; // 0h01
        uint32_t mask_f = 0b10000000; // 0h80
        uint32_t mask_g = 0b00001001; // 0h09

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
            "vfcpka.s.s ft4, ft3, ft0\n"  // ft4 = [3.14, 100.123456789]
                                          // ft5 = [-1.618, 0.250244]
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

        mask_a = 0x3298;
        mask_b = 0xBA10;
        mask_c = 0x9810;
        mask_d = 0x32BA;
        mask_e = 0x3098;
        mask_f = 0x2B1A;
        mask_g = 0x0832;
        uint32_t mask_h = 0x93A1;

        asm volatile(
            "fmv.s.x f0, %0\n" // 3.14 
            "fmv.s.x f1, %1\n" // 0.5
            "fmv.s.x f2, %2\n" // 1.618
            "fmv.s.x f3, %3\n" // 100.123456789
            "fmv.s.x f4, %4\n" // 5.75
            "fmv.s.x f5, %5\n" // 8.26
            "fmv.s.x f6, %6\n" // 50.3
            "fmv.s.x f7, %7\n" // 4.2

            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"   // f8 =  [100.125, 1.618, 0.5, 3.14]           
            "vfcpka.h.s f9, f4, f5\n"
            "vfcpkb.h.s f9, f6, f7\n"   // f9 =  [4.2, 50.3, 8.26, 5.75]
            "vfcpka.h.s f10, f4, f5\n"
            "vfcpkb.h.s f10, f2, f3\n"  // f10 = [100.125, 1.618, 8.26, 5.75]
            "vfcpka.h.s f11, f0, f1\n"
            "vfcpkb.h.s f11, f6, f7\n"  // f11 = [4.2, 50.3, 0.5, 3.14]
            : "+r"(i_a), "+r"(i_e), "+r"(i_b), "+r"(i_f), "+r"(i_g), "+r"(i_h), "+r"(i_i), "+r"(i_j));

        asm volatile(
            "vfshuffle.h f8, f9, %0\n" // rD = , rA = , rB = 0x3298
            "vfeq.h %1, f8, f10\n"     //  result = 0x = [100.125, 1.618, 8.26, 5.75]
            : "+r"(mask_a), "+r"(res0));
        errs += (res0 != 0xf);

        asm volatile(
            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"  // f8 = [100.125, 1.618, 0.5, 3.14]  
            "vfshuffle.h f8, f9, %0\n" // rD = 0x, rA = 0x, rB = 0xBA10
            "vfeq.h %1, f8, f11\n"     //  result = 0x = [4.2, 50.3, 0.5, 3.14]
            : "+r"(mask_b), "+r"(res0));
        errs += (res0 != 0xf);

        asm volatile(
            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"   // f8 =  [100.125, 1.618, 0.5, 3.14]  f9 = [4.2, 50.3, 8.26, 5.75]
            "vfcpka.h.s f10, f0, f1\n"
            "vfcpkb.h.s f10, f4, f5\n"  // f10 = [8.26, 5.75, 0.5, 3.14]
            "vfcpka.h.s f11, f6, f7\n"
            "vfcpkb.h.s f11, f2, f3\n"  // f11 = [100.125, 1.618, 4.2, 50.3]         
            "vfcpka.h.s f12, f4, f5\n"
            "vfcpkb.h.s f12, f0, f3\n"  // f12 = [8.26, 5.75, 3.14, 1.618]
            "vfcpka.h.s f13, f6, f1\n"
            "vfcpkb.h.s f13, f7, f2\n"  // f13 = [1.618, 4.2, 0.5, 50.3]
            "vfcpka.h.s f14, f2, f3\n"
            "vfcpkb.h.s f14, f4, f0\n"  // f14 = [3.14, 5.75, 100.125, 1.618]
            "vfcpka.h.s f15, f1, f6\n"
            "vfcpkb.h.s f15, f3, f5\n");// f15 = [8.26, 100.125, 50.3, 0.5]   

        asm volatile(
            "vfshuffle.h f8, f9, %0\n" 
            "vfeq.h %1, f8, f10\n"     //  result 
            : "+r"(mask_c), "+r"(res0));
        errs += (res0 != 0xf);

        asm volatile(
            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"  // f8 = [100.125, 1.618, 0.5, 3.14]  f9 =  [4.2, 50.3, 8.26, 5.75]
            "vfshuffle.h f8, f9, %0\n" 
            "vfeq.h %1, f8, f11\n"     //  result 
            : "+r"(mask_d), "+r"(res0));
        errs += (res0 != 0xf);

        asm volatile(
            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"  // f8 = [100.125, 1.618, 0.5, 3.14]  f9 =  [4.2, 50.3, 8.26, 5.75]
            "vfshuffle.h f8, f9, %0\n" 
            "vfeq.h %1, f8, f12\n"     //  result 
            : "+r"(mask_e), "+r"(res0));
        errs += (res0 != 0xf);

        asm volatile(
            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"  // f8 = [100.125, 1.618, 0.5, 3.14]  f9 =  [4.2, 50.3, 8.26, 5.75]
            "vfshuffle.h f8, f9, %0\n" 
            "vfeq.h %1, f8, f13\n"     //  result
            : "+r"(mask_f), "+r"(res0));
        errs += (res0 != 0xf);

        asm volatile(
            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"  // f8 = [100.125, 1.618, 0.5, 3.14]  f9 =  [4.2, 50.3, 8.26, 5.75]
            "vfshuffle.h f8, f9, %0\n" 
            "vfeq.h %1, f8, f14\n"     //  result
            : "+r"(mask_g), "+r"(res0));
        errs += (res0 != 0xf);

        asm volatile(
            "vfcpka.h.s f8, f0, f1\n"
            "vfcpkb.h.s f8, f2, f3\n"  // f8 = [100.125, 1.618, 0.5, 3.14]  f9 =  [4.2, 50.3, 8.26, 5.75]
            "vfshuffle.h f8, f9, %0\n" 
            "vfeq.h %1, f8, f15\n"     //  result
            : "+r"(mask_h), "+r"(res0));
        errs += (res0 != 0xf);


        // VFSHUFFLE FP8

        mask_a = 0xBA987654;
        mask_b = 0xFEDC3210;
        mask_c = 0x7654FEDC;
        mask_d = 0x3210BA98;
        mask_e = 0x763298FE;
        mask_f = 0x10DC5498;
        mask_g = 0xE749620F;
        mask_h = 0x183F5DBC;

        asm volatile(
            "fmv.s.x f0, %0\n" // 3.14 
            "fmv.s.x f1, %1\n" // 0.5
            "fmv.s.x f2, %2\n" // 1.618
            "fmv.s.x f3, %3\n" // 100.123456789
            "fmv.s.x f4, %4\n" // 5.75
            "fmv.s.x f5, %5\n" // 8.26
            "fmv.s.x f6, %6\n" // 50.3
            "fmv.s.x f7, %7\n" // 4.2
            "fmv.s.x f8, %8\n"   //-3.14 
            "fmv.s.x f9, %9\n"   //-0.5
            "fmv.s.x f10, %10\n" //-1.618
            "fmv.s.x f11, %11\n" //-100.125
            "fmv.s.x f12, %12\n" // 2.39062
            "fmv.s.x f13, %13\n" // 0.250244
            "fmv.s.x f14, %14\n" //-2.39062
            "fmv.s.x f15, %15\n" //-0.250244    
            : "+r"(i_a), "+r"(i_e), "+r"(i_b), "+r"(i_f), "+r"(i_g), "+r"(i_h), "+r"(i_i), "+r"(i_j), "+r"(i_an), "+r"(i_en), "+r"(i_bn), "+r"(i_fn), "+r"(i_c), "+r"(i_d), "+r"(i_cn), "+r"(i_dn));

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14]   
            "vfcpka.b.s f17, f8, f9\n"
            "vfcpkb.b.s f17, f10, f11\n"   
            "vfcpkc.b.s f17, f12, f13\n"
            "vfcpkd.b.s f17, f14, f15\n" // f17 =  [-0.25, -2.39, 0.25, 2.39, -100.125, -1.618, -0.5, -3.14]  
            );
        asm volatile(
            "vfcpka.b.s f18, f4, f5\n"
            "vfcpkb.b.s f18, f6, f7\n"   
            "vfcpkc.b.s f18, f8, f9\n"
            "vfcpkd.b.s f18, f10, f11\n"  // f18 = [-100.125, -1.618, -0.5, -3.14, 4.2, 50.3, 8.26, 5.75] mask_a
            "vfcpka.b.s f19, f0, f1\n"
            "vfcpkb.b.s f19, f2, f3\n"   
            "vfcpkc.b.s f19, f12, f13\n"
            "vfcpkd.b.s f19, f14, f15\n"   // f19 = [-0,.25 -2.39, 0.25, 2.39, 100.125, 1.618, 0.5, 3.14] mask_b
            );

        asm volatile(
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f18\n"     //  result 
            : "+r"(mask_a), "+r"(res0));
        errs += (res0 != 0xff);

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14] 
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f19\n"     //  result 
            : "+r"(mask_b), "+r"(res0));
        errs += (res0 != 0xff);

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14]   
            "vfcpka.b.s f18, f12, f13\n"
            "vfcpkb.b.s f18, f14, f15\n"   
            "vfcpkc.b.s f18, f4, f5\n"
            "vfcpkd.b.s f18, f6, f7\n"  // f18 = [4.2, 50.3, 8.26, 5.75, -0.25, -2.39, 0.25, 2.39] mask_c
            "vfcpka.b.s f19, f8, f9\n"
            "vfcpkb.b.s f19, f10, f11\n"   
            "vfcpkc.b.s f19, f0, f1\n"
            "vfcpkd.b.s f19, f2, f3\n"   // f19 = [100.125, 1.618, 0.5, 3.14, -100.125, -1.618, -0.5, -3.14] mask_d
            "vfcpka.b.s f20, f14, f15\n"
            "vfcpkb.b.s f20, f8, f9\n"   
            "vfcpkc.b.s f20, f2, f3\n"
            "vfcpkd.b.s f20, f6, f7\n"  // f20 = [4.2, 50.3, 100.125, 1.618, -0.5, -3.14, -0.25, -2.39] mask_e
            "vfcpka.b.s f21, f8, f9\n"
            "vfcpkb.b.s f21, f4, f5\n"   
            "vfcpkc.b.s f21, f12, f13\n"
            "vfcpkd.b.s f21, f0, f1\n"   // f21 = [0.5, 3.14, 0.25, 2.39, 8.26, 5.75, -0.5, -3.14] mask_f
            "vfcpka.b.s f22, f15, f0\n"
            "vfcpkb.b.s f22, f2, f6\n"   
            "vfcpkc.b.s f22, f9, f4\n"
            "vfcpkd.b.s f22, f7, f14\n"  // f22 = [-2.39, 4.2, 5.75, -0.5, 50.3, 1.168, 3.14, -0.25] mask_g
            "vfcpka.b.s f23, f12, f11\n"
            "vfcpkb.b.s f23, f13, f5\n"   
            "vfcpkc.b.s f23, f15, f3\n"
            "vfcpkd.b.s f23, f8, f1\n"   // f23 = [0.5, -3.14, 100.125, -0.25, 8.26, 0.25, -100.25, 2.39] mask_h
            );

        asm volatile(
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f18\n"     //  result 
            : "+r"(mask_c), "+r"(res0));
        errs += (res0 != 0xff);

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14] 
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f19\n"     //  result 
            : "+r"(mask_d), "+r"(res0));
        errs += (res0 != 0xff);

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14] 
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f20\n"     //  result 
            : "+r"(mask_e), "+r"(res0));
        errs += (res0 != 0xff);

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14] 
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f21\n"     //  result 
            : "+r"(mask_f), "+r"(res0));
        errs += (res0 != 0xff);

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14] 
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f22\n"     //  result 
            : "+r"(mask_g), "+r"(res0));
        errs += (res0 != 0xff);

        asm volatile(
            "vfcpka.b.s f16, f0, f1\n"
            "vfcpkb.b.s f16, f2, f3\n"   
            "vfcpkc.b.s f16, f4, f5\n"
            "vfcpkd.b.s f16, f6, f7\n"   // f16 =  [4.2, 50.3, 8.26, 5.75, 100.125, 1.618, 0.5, 3.14] 
            "vfshuffle.b f16, f17, %0\n" 
            "vfeq.b %1, f16, f23\n"     //  result 
            : "+r"(mask_h), "+r"(res0));
        errs += (res0 != 0xff);

        return errs;
    }
    return 0;
}
