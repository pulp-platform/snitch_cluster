// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <snrt.h>

int main() {
    if (snrt_is_compute_core()) {
        int errs = 0;

        uint32_t mask_a = 0b00000011000000100000000100000000;
        uint32_t mask_b = 0b00000111000001100000010100000100;


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
            "mv.x t0, %0\n"
            : "+r"(a));

        asm volatile(
            "fmv.s.x ft0, %0\n"
            "fmv.s.x ft1, %1\n"
            "fmv.s.x ft2, %2\n"
            "fmv.s.x ft3, %3\n"
            "vfcpka.s.s ft4, ft0, ft2\n"  // ft4 = {3.14, 1.618}
            "vfcpka.s.s ft5, ft1, ft3\n"  // ft5 = {-3.14, -1.618}
            "vfcpka.s.s ft6, ft0, ft3\n"  // ft6 = {3.14, -1.618}
            "vfcpka.s.s ft7, ft1, ft2\n"  // ft7 = {-3.14, 1.618}
            "vfcpka.s.s ft8, ft0, ft2\n"  // ft8 = {3.14, 1.618}
            : "+r"(i_a), "+r"(i_an), "+r"(i_b), "+r"(i_bn));

        // VFSHUFFLE
        // just copy rD
        asm volatile(
            "vfshuffle.s ft4, ft5, %0\n"
            "vfeq.s %0, ft4, ft8\n"
            : "+r"(mask_a), "+r"(res0));
        errs += (res0 == 0x3);

        // just copy rA
        asm volatile(
            "vfshuffle.s ft4, ft5, %0\n"
            "vfeq.s %0, ft4, ft8\n"
            : "+r"(mask_b), "+r"(res0));
        errs += (res0 == 0x3);

        return errs;
    }
    return 0;
}
