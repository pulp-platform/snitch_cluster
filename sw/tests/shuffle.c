// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#include <snrt.h>

int main() {
    if (snrt_is_compute_core() && (snrt_cluster_core_idx() == 0)) {
        int errs = 0;

        uint32_t a = 0x4048F5C3;   // 3.14 0
        uint32_t an = 0xC048F5C3;  // -3.14
        uint32_t b = 0x3FCF1AA0;   // 1.618 2
        uint32_t bn = 0xBFCF1AA0;  // -1.618
        uint32_t c = 0x4018FFEB;   // 2.39062
        uint32_t cn = 0xC018FFEB;  // -2.39062
        uint32_t d = 0x3E801FFB;   // 0.250244 6
        uint32_t dn = 0xBE801FFB;  // -0.250244
        uint32_t e = 0x3F000000;   // 0.5
        uint32_t en = 0xBF000000;  // -0.5
        uint32_t f = 0x42C83F36;   // 100.123456789 10
        uint32_t fn = 0xC2C83F36;  // -100.123456789
        uint32_t g = 0x40B80000;   // 5.75
        uint32_t gn = 0xC0B80000;  // -5.75
        uint32_t h = 0x410428F6;   // 8.26
        uint32_t hn = 0xC10428F6;  // -8.26

        int res0 = 0;
        int res1 = 0;
        uint32_t mask_a, mask_b;

        // vfshuffle.s
        mask_a = 0x10;  // -> [vec[0][1], vec[0][0]]
        mask_b = 0x98;  // -> [vec[0][1], vec[0][0]]

        asm volatile(
            "fmv.s.x ft0, %[a]\n"  // ft0 = a
            "fmv.s.x ft1, %[b]\n"  // ft1 = b
            // Pack input & solution vectors
            "vfcpka.s.s ft2, ft0, ft1\n"  // ft2 = [a, b]
            // Load mask
            "fmv.s.x ft3, %[mask_a]\n"  // ft3 = mask_a
            "fmv.s.x ft1, %[mask_b]\n"  // ft1 = mask_b
            // Shuffle input vectors with mask
            "vfshuffle.s ft0, ft2, ft3\n"  // ft0 = [a, b]
            "vfshuffle.s ft1, ft2, ft1\n"  // ft1 = [a, b]
            // Compare
            "vfeq.s %[res0], ft0, ft2\n"  // res0 = (ft0 == ft2) = 0x3
            "vfeq.s %[res1], ft1, ft2\n"  // res1 = (ft1 == ft2) = 0x3
            : [ res0 ] "+r"(res0), [ res1 ] "+r"(res1)
            : [ a ] "r"(a), [ b ] "r"(b), [ mask_a ] "r"(mask_a),
              [ mask_b ] "r"(mask_b)
            : "ft0", "ft1", "ft2", "ft3");

        mask_a = 0x01;  // -> [vec[0][0], vec[0][1]]
        mask_b = 0x89;  // -> [vec[1][0], vec[1][1]]

        asm volatile(
            "fmv.s.x ft0, %[a]\n"  // ft0 = a
            "fmv.s.x ft1, %[b]\n"  // ft1 = b
            // Pack input vectors
            "vfcpka.s.s ft2, ft0, ft1\n"  // ft2 = [a, b]
            // Pack solution vectors
            "vfcpka.s.s ft3, ft1, ft0\n"  // ft3 = [b, a]
            // Load mask
            "fmv.s.x ft4, %[mask_a]\n"  // ft4 = mask_a
            "fmv.s.x ft5, %[mask_b]\n"  // ft5 = mask_b
            // Shuffle input vectors with mask
            "vfshuffle.s ft6, ft2, ft4\n"  // ft6 = [b, a]
            "vfshuffle.s ft7, ft2, ft5\n"  // ft7 = [b, a]
            // Compare
            "vfeq.s %[res0], ft6, ft3\n"  // res0 = (ft6 == ft3) = 0x3
            "vfeq.s %[res1], ft7, ft3\n"  // res1 = (ft7 == ft3) = 0x3
            : [ res0 ] "+r"(res0), [ res1 ] "+r"(res1)
            : [ a ] "r"(a), [ b ] "r"(b), [ mask_a ] "r"(mask_a),
              [ mask_b ] "r"(mask_b)
            : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7");
        errs += (res0 != 0x3);
        errs += (res1 != 0x3);

        // vfshuffle2.s
        mask_a = 0x99;  // -> [vec[1][1], vec[1][1]]
        mask_b = 0x81;  // -> [vec[1][0], vec[0][1]]

        asm volatile(
            "fmv.s.x ft0, %[a]\n"  // ft0 = a
            "fmv.s.x ft1, %[b]\n"  // ft1 = b
            "fmv.s.x ft2, %[c]\n"  // ft2 = c
            "fmv.s.x ft3, %[d]\n"  // ft3 = d
            // Pack input vectors
            "vfcpka.s.s ft4, ft0, ft1\n"  // ft4 = [b, a]
            "vfcpka.s.s ft5, ft2, ft3\n"  // ft5 = [d, c]
            // Pack solution vectors
            "vfcpka.s.s ft6, ft1, ft1\n"  // ft6 = [b, b]
            // Load mask
            "fmv.s.x ft7, %[mask_a]\n"  // ft7 = mask_a
            // Shuffle input vectors with mask
            "vfshuffle2.s ft4, ft5, ft7\n"  // ft4 = [b, b]
            // Compare
            "vfeq.s %[res0], ft4, ft6\n"  // res0 = (ft4 == ft6) = 0x3
            : [ res0 ] "+r"(res0)
            : [ a ] "r"(a), [ b ] "r"(b), [ c ] "r"(c), [ d ] "r"(d),
              [ mask_a ] "r"(mask_a)
            : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7");

        asm volatile(
            "fmv.s.x ft0, %[a]\n"  // ft0 = a
            "fmv.s.x ft1, %[b]\n"  // ft1 = b
            "fmv.s.x ft2, %[c]\n"  // ft2 = c
            "fmv.s.x ft3, %[d]\n"  // ft3 = d
            // Pack input vectors
            "vfcpka.s.s ft4, ft0, ft1\n"  // ft4 = [b, a]
            "vfcpka.s.s ft5, ft2, ft3\n"  // ft5 = [d, c]
            // Pack solution vectors
            "vfcpka.s.s ft6, ft3, ft0\n"  // ft6 = [a, d]
            // Load mask
            "fmv.s.x ft7, %[mask_b]\n"  // ft7 = mask_b
            // Shuffle input vectors with mask
            "vfshuffle2.s ft4, ft5, ft7\n"  // ft4 = [a, d]
            // Compare
            "vfeq.s %[res1], ft4, ft6\n"  // res1 = (ft4 == ft6) = 0x3
            : [ res1 ] "+r"(res1)
            : [ a ] "r"(a), [ b ] "r"(b), [ c ] "r"(c), [ d ] "r"(d),
              [ mask_b ] "r"(mask_b)
            : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7");

        errs += (res0 != 0x3);
        errs += (res1 != 0x3);

        // vfshuffle.h
        mask_a = 0x0000;  // -> [vec[0][0], vec[0][0], vec[0][0], vec[0][0]]
        mask_b = 0x0123;  // -> [vec[0][0], vec[0][1], vec[0][2], vec[0][3]]

        asm volatile(
            "fmv.s.x ft0, %[a]\n"  // ft0 = a
            "fmv.s.x ft1, %[b]\n"  // ft1 = b
            "fmv.s.x ft2, %[c]\n"  // ft2 = c
            "fmv.s.x ft3, %[d]\n"  // ft3 = d
            // Pack input vectors
            "vfcpka.h.s ft4, ft0, ft1\n"  // ft4 = [-, -, b, a]
            "vfcpkb.h.s ft4, ft2, ft3\n"  // ft4 = [d, c, b, a]
            "vfcpka.h.s ft5, ft0, ft0\n"  // ft5 = [-, -, a, a]
            "vfcpkb.h.s ft5, ft0, ft0\n"  // ft5 = [a, a, a, a]
            // Pack solution vectors
            "vfcpka.h.s ft6, ft3, ft2\n"  // ft6 = [-, -, c, d]
            "vfcpkb.h.s ft6, ft1, ft0\n"  // ft6 = [a, b, c, d]
            // Load mask
            "fmv.s.x ft7, %[mask_a]\n"  // ft7 = mask_a
            "fmv.s.x ft8, %[mask_b]\n"  // ft8 = mask_b
            // Shuffle input vectors with mask
            "vfshuffle.h ft9, ft4, ft7\n"   // ft9  = [a, a, a, a]
            "vfshuffle.h ft10, ft4, ft8\n"  // ft10 = [d, c, b, a]
            // Compare
            "vfeq.h %[res0], ft5, ft9\n"   // res0 = (ft5 == ft9) = 0xf
            "vfeq.h %[res1], ft6, ft10\n"  // res1 = (ft6 == ft10) = 0xf
            : [ res0 ] "+r"(res0), [ res1 ] "+r"(res1)
            : [ a ] "r"(a), [ b ] "r"(b), [ c ] "r"(c), [ d ] "r"(d),
              [ mask_a ] "r"(mask_a), [ mask_b ] "r"(mask_b)
            : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7", "ft8",
              "ft9", "ft10");

        errs += (res0 != 0xf);
        errs += (res1 != 0xf);

        // vfshuffle2.h
        mask_a = 0x092b;  // -> [vec[0][0], vec[1][1], vec[0][2], vec[1][3]]
        mask_b = 0x8800;  // -> [vec[1][0], vec[1][0], vec[0][0], vec[0][0]]

        asm volatile(
            "fmv.s.x ft0, %[a]\n"  // ft0 = a
            "fmv.s.x ft1, %[b]\n"  // ft1 = b
            "fmv.s.x ft2, %[c]\n"  // ft2 = c
            "fmv.s.x ft3, %[d]\n"  // ft3 = d
            "fmv.s.x ft4, %[e]\n"  // ft4 = e
            "fmv.s.x ft5, %[f]\n"  // ft5 = f
            "fmv.s.x ft6, %[g]\n"  // ft6 = g
            "fmv.s.x ft7, %[h]\n"  // ft7 = h
            // Pack input vectors
            "vfcpka.h.s ft8, ft0, ft1\n"  // ft8  = [-, -, b, a]
            "vfcpkb.h.s ft8, ft2, ft3\n"  // ft8  = [d, c, b, a]
            "vfcpka.h.s ft9, ft4, ft5\n"  // ft9  = [-, -, f, e]
            "vfcpkb.h.s ft9, ft6, ft7\n"  // ft9  = [h, g, f, e]
            // Copy second input vector
            "fmv.d ft10, ft9\n"  // ft10 = [d, c, b, a]
            // Pack solution vectors
            "vfcpka.h.s ft11, ft7, ft2\n"  // ft11 = [-, -, c, h]
            "vfcpkb.h.s ft11, ft5, ft0\n"  // ft11 = [a, f, c, h]
            "vfcpka.h.s fa0, ft0, ft0\n"   // fa0  = [-, -, a, a]
            "vfcpkb.h.s fa0, ft4, ft4\n"   // fa0  = [e, e, a, a]
            // Load mask
            "fmv.s.x fa1, %[mask_a]\n"  // fa1 = mask_a
            "fmv.s.x fa2, %[mask_b]\n"  // fa2 = mask_b
            // Shuffle input vectors with mask
            "vfshuffle2.h ft9, ft8, fa1\n"   // ft8  = [a, g, c, h]
            "vfshuffle2.h ft10, ft8, fa2\n"  // ft9  = [e, e, a, a]
            // Compare
            "vfeq.h %[res0], ft9, ft11\n"  // res0 = (ft10 == ft8) = 0xf
            "vfeq.h %[res1], ft10, fa0\n"  // res1 = (ft11 == ft9) = 0xf
            : [ res0 ] "+r"(res0), [ res1 ] "+r"(res1)
            : [ a ] "r"(a), [ b ] "r"(b), [ c ] "r"(c), [ d ] "r"(d),
              [ e ] "r"(e), [ f ] "r"(f), [ g ] "r"(g), [ h ] "r"(h),
              [ mask_a ] "r"(mask_a), [ mask_b ] "r"(mask_b)
            : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7", "ft8",
              "ft9", "ft10", "ft11", "fa0", "fa1");

        errs += (res0 != 0xf);
        errs += (res1 != 0xf);

        // vfshuffle.b
        mask_a = 0x01234567;  // -> [vec[0][0], vec[0][1], vec[0][2], vec[0][3],
                              // vec[0][4], vec[0][5], vec[0][6], vec[0][7]]

        asm volatile(
            "fmv.s.x ft0, %[a]\n"  // ft0 = a
            "fmv.s.x ft1, %[b]\n"  // ft1 = b
            "fmv.s.x ft2, %[c]\n"  // ft2 = c
            "fmv.s.x ft3, %[d]\n"  // ft3 = d
            "fmv.s.x ft4, %[e]\n"  // ft4 = e
            "fmv.s.x ft5, %[f]\n"  // ft5 = f
            "fmv.s.x ft6, %[g]\n"  // ft6 = g
            "fmv.s.x ft7, %[h]\n"  // ft7 = h
            // Pack input vectors
            "vfcpka.b.s ft8, ft0, ft1\n"  // ft8  = [-, - ,-, -, -, -, b, a]
            "vfcpkb.b.s ft8, ft2, ft3\n"  // ft8  = [-, - ,-, -, d, c, b, a]
            "vfcpkc.b.s ft8, ft4, ft5\n"  // ft8  = [-, -, f, e, d, c, b, a]
            "vfcpkd.b.s ft8, ft6, ft7\n"  // ft8  = [h, g, f, e, d, c, b, a]
            // Pack solution vectors
            "vfcpka.b.s ft9, ft7, ft6\n"  // ft9  = [-, -, -, -, -, -, g, h]
            "vfcpkb.b.s ft9, ft5, ft4\n"  // ft9  = [-, -, -, -, e, f, g, h]
            "vfcpkc.b.s ft9, ft3, ft2\n"  // ft9  = [-, -, c, d, e, f, g, h]
            "vfcpkd.b.s ft9, ft1, ft0\n"  // ft9  = [a, b, c, d, e, f, g, h]
            // Load mask
            "fmv.s.x ft10, %[mask_a]\n"  // ft10 = mask_a
            // Shuffle input vectors with mask
            "vfshuffle.b ft11, ft8, ft10\n"  // ft11 = [a, b, c, d, e, f, g, h]
            // Compare
            "vfeq.b %[res0], ft11, ft9\n"  // res0 = (ft11 == ft9) = 0xff
            : [ res0 ] "+r"(res0)
            : [ a ] "r"(a), [ b ] "r"(b), [ c ] "r"(c), [ d ] "r"(d),
              [ e ] "r"(e), [ f ] "r"(f), [ g ] "r"(g), [ h ] "r"(h),
              [ mask_a ] "r"(mask_a)
            : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7", "ft8",
              "ft9", "ft10", "ft11");

        errs += (res0 != 0xff);

        // vfshuffle2.b
        mask_a = 0x89ab4567;  // -> [vec[1][0], vec[1][1], vec[1][2], vec[1][3],
                              // vec[0][4], vec[0][5], vec[0][6], vec[0][7]]

        asm volatile(
            "fmv.s.x ft0, %[a]\n"    // ft0 = a
            "fmv.s.x ft1, %[b]\n"    // ft1 = b
            "fmv.s.x ft2, %[c]\n"    // ft2 = c
            "fmv.s.x ft3, %[d]\n"    // ft3 = d
            "fmv.s.x ft4, %[e]\n"    // ft4 = e
            "fmv.s.x ft5, %[f]\n"    // ft5 = f
            "fmv.s.x ft6, %[g]\n"    // ft6 = g
            "fmv.s.x ft7, %[h]\n"    // ft7 = h
            "fmv.s.x ft8, %[an]\n"   // ft8 = an
            "fmv.s.x ft9, %[bn]\n"   // ft9 = bn
            "fmv.s.x ft10, %[cn]\n"  // ft10 = cn
            "fmv.s.x ft11, %[dn]\n"  // ft11 = dn
            "fmv.s.x fa0, %[en]\n"   // fa0 = en
            "fmv.s.x fa1, %[fn]\n"   // fa1 = fn
            "fmv.s.x fa2, %[gn]\n"   // fa2 = gn
            "fmv.s.x fa3, %[hn]\n"   // fa3 = hn
            // Pack input vectors
            "vfcpka.b.s fa4, ft0, ft1\n"    // fa4  = [-, - ,-, -, -, -, b, a]
            "vfcpkb.b.s fa4, ft2, ft3\n"    // fa4  = [-, - ,-, -, d, c, b, a]
            "vfcpkc.b.s fa4, ft4, ft5\n"    // fa4  = [-, -, f, e, d, c, b, a]
            "vfcpkd.b.s fa4, ft6, ft7\n"    // fa4  = [h, g, f, e, d, c, b, a]
            "vfcpka.b.s fa5, ft8, ft9\n"    // fa5  = [-, - ,-, -, -, -, bn, an]
            "vfcpkb.b.s fa5, ft10, ft11\n"  // fa5  = [-, - ,-, -, dn, cn, bn,
                                            // an]
            "vfcpkc.b.s fa5, fa0, fa1\n"    // fa5  = [-, -, fn, en, dn, cn, bn,
                                            // an]
            "vfcpkd.b.s fa5, fa2, fa3\n"  // fa5  = [hn, gn, fn, en, dn, cn, bn,
                                          // an]
            // Pack solution vectors
            "vfcpka.b.s fa6, ft7, ft6\n"    // fa6  = [-, -, -, -, -, -, g, h]
            "vfcpkb.b.s fa6, ft5, ft4\n"    // fa6  = [-, -, -, -, e, f, g, h]
            "vfcpkc.b.s fa6, ft11, ft10\n"  // fa6  = [-, -, cn, dn, e, f, g, h]
            "vfcpkd.b.s fa6, ft9, ft8\n"  // fa6  = [an, bn, cn, dn, e, f, g, h]
            // Load mask
            "fmv.s.x fa7, %[mask_a]\n"  // ft10 = mask_a
            // Shuffle input vectors with mask
            "vfshuffle2.b fa5, fa4, fa7\n"  // fa5 = [an, bn, cn, dn, e, f, g,
                                            // h]
            // Compare
            "vfeq.b %[res0], fa5, fa6\n"  // res0 = (fa5 == fa6) = 0xffff
            : [ res0 ] "+r"(res0)
            : [ a ] "r"(a), [ b ] "r"(b), [ c ] "r"(c), [ d ] "r"(d),
              [ e ] "r"(e), [ f ] "r"(f), [ g ] "r"(g), [ h ] "r"(h),
              [ an ] "r"(an), [ bn ] "r"(bn), [ cn ] "r"(cn), [ dn ] "r"(dn),
              [ en ] "r"(en), [ fn ] "r"(fn), [ gn ] "r"(gn), [ hn ] "r"(hn),
              [ mask_a ] "r"(mask_a)
            : "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7", "ft8",
              "ft9", "ft10", "ft11", "fa0", "fa1", "fa2", "fa3", "fa4", "fa5",
              "fa6", "fa7");

        errs += (res0 != 0xff);

        return errs;
    }
    return 0;
}
