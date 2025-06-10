// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "istc.common.hpp"

// ===============
//    Polybench
// ===============

KNL istci_pb_jacobi_2d(
    const int cid,
    TCDM d_t (RCP A)[s::n][s::n],
    TCDM d_t (RCP B)[s::n][s::n]
) {
    // Assertions and IDs
    static_assert(sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, sx = dx, sy = dy, sb = sx+sy;
    constexpr uint32_t b = dx, l = dy, cc = dx+dy, r = cc+dx, tt = cc+dy;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    IDXA i0[10], i1[10];
    /*b*/ i0[ 0] = b;  i0[ 1] = b + sx; i0[ 2] = b + sy; i0[ 3] = b + sb;
    /*l*/ i0[ 4] = l;  i0[ 5] = l + sx; i0[ 6] = l + sy; i0[ 7] = l + sb;
    /*c*/ i0[ 8] = cc; i0[ 9] = cc + sy;
    /*r*/ i1[ 0] = r;  i1[ 1] = r  + sx; i1[ 2] = r  + sy; i1[ 3] = r  + sb;
    /*t*/ i1[ 4] = tt; i1[ 5] = tt + sx; i1[ 6] = tt + sy; i1[ 7] = tt + sb;
    /*c*/ i1[ 8] = cc + sx; i1[ 9] = cc + sb;
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, 10, 10);

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (i, ly, s::n-2, jmpy) {
            __rt_sssr_bound_stride_3d(2, 2, sodt, 2, s::n*sodt, (s::n-2+jmpx-lx-sp::ux)/jmpx, jmpx*sodt);
            bool winit = true;
            form (j, lx, s::n-2, jmpx) {
                __istc_iter_issrs((void*)&(*A)[i][j], (void*)i0, (void*)i1);
                if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)&(*B)[i+1][lx+1], 2, __RT_SSSR_REG_WPTR_2);}
                asm volatile (
                    // br0..3 = b0..3 + r0..3 and lt0..3 = l0..3 + t0..3
                    "frep.o     %[c7], 1, 7, 0b001  \n"
                    "fadd.d     fa0, ft0, ft1       \n"
                    // p0..3 = br0..3 + lt0..3
                    "frep.o     %[c3], 1, 3, 0b111  \n"
                    "fadd.d     fa0, fa0, fa4       \n"
                    // tt0..3 = p0..3 + c0..3
                    "fadd.d     fa0, fa0, ft0       \n"
                    "fadd.d     fa1, fa1, ft1       \n"
                    "fadd.d     fa2, fa2, ft0       \n"
                    "fadd.d     fa3, fa3, ft1       \n"
                    // res0..3 = 0.2 * tt0..3
                    "frep.o     %[c3], 1, 3, 0b100  \n"
                    "fmul.d     ft2, %[cf], fa0     \n"
                    :: [c7]"r"(7), [c3]"r"(3), [cf]"f"(0.2)
                     : "memory", "fa0", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6", "fa7"
                );
            }
            lx = (lx + sp::px) % jmpx;
        }
        ly = (ly + sp::py) % jmpy;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


// ==========
//    AN5D
// ==========

KNL istci_an5d_j2d5pt(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t b = dx, l = dy, cc = dx+dy, r = cc+dx, tt = cc+dy;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    IDXA i0[10], i1[10];
    /*c*/ i0[ 0] = cc; i0[ 1] = cc+sy; /*b*/ i0[ 2] = b; i0[ 3] = b+sy;
    /*l*/ i0[ 4] = l;  i0[ 5] = l+sy;  /*r*/ i0[ 6] = r; i0[ 7] = r+sy;
    /*t*/ i0[ 8] = tt; i0[ 9] = tt+sy;
    /*c*/ i1[ 0] = cc+sx; i1[ 1] = cc+sb; /*b*/ i1[ 2] = b+sx; i1[ 3] = b+sb;
    /*l*/ i1[ 4] = l+sx;  i1[ 5] = l+sb;  /*r*/ i1[ 6] = r+sx; i1[ 7] = r+sb;
    /*t*/ i1[ 8] = tt+sx; i1[ 9] = tt+sb;
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, 10, 10);

    // Avoid constant FP division
    register d_t fac asm("ft7") = 1.0 / c::c0;
    // Use stacked registers for FREP
    register d_t cb asm("ft3") = c::ym[0];
    register d_t cl asm("ft4") = c::xm[0];
    register d_t cr asm("ft5") = c::xp[0];
    register d_t ct asm("ft6") = c::yp[0];
    register d_t cc_ asm("ft8") = c::cc;

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (y, ly, s::n-2, jmpy) {
            __rt_sssr_bound_stride_3d(2, 2, sodt, 2, s::n*sodt, (s::n-2+jmpx-lx-sp::ux)/jmpx, jmpx*sodt);
            bool winit = true;
            form (x, lx, s::n-2, jmpx) {
                __istc_iter_issrs((void*)&(*A[t%2])[y][x], (void*)i0, (void*)i1);
                if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)&(*A[(t+1)%2])[y+1][lx+1], 2, __RT_SSSR_REG_WPTR_2);}
                asm volatile (
                    // Initialize accumulators: center
                    "fmul.d    fa0, %[cc], ft0      \n"
                    "fmul.d    fa1, %[cc], ft1      \n"
                    "fmul.d    fa2, %[cc], ft0      \n"
                    "fmul.d    fa3, %[cc], ft1      \n"
                    // Do directionals as loop
                    "frep.o    %[c3], 4, 3, 0b0010  \n"
                    "fmadd.d   fa0, ft3, ft0, fa0   \n"
                    "fmadd.d   fa1, ft3, ft1, fa1   \n"
                    "fmadd.d   fa2, ft3, ft0, fa2   \n"
                    "fmadd.d   fa3, ft3, ft1, fa3   \n"
                    // Final scaling and writeback
                    "frep.o    %[c3], 1, 3, 0b100   \n"
                    "fmul.d    ft2, %[fc], fa0      \n"
                    : [cb]"+&f"(cb), [cl]"+&f"(cl), [cr]"+&f"(cr), [ct]"+&f"(ct),
                      [cc]"+&f"(cc_), [fc]"+&f"(fac)
                    : [c3]"r"(3)
                    : "memory", "fa0", "fa1", "fa2", "fa3"
                );
            }
            lx = (lx + sp::px) % jmpx;
        }
        ly = (ly + sp::py) % jmpy;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


KNL istci_an5d_j2d9pt(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t cc = 2*dy+2*dx,
        b0 = cc-dy, b1 = cc-2*dy,
        l0 = cc-dx, l1 = cc-2*dx,
        r0 = cc+dx, r1 = cc+2*dx,
        t0 = cc+dy, t1 = cc+2*dy;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    IDXA i0[18], i1[18];
    /*cc*/ i0[ 0] = cc; i0[ 1] = cc+sy;
    /*b0*/ i0[ 2] = b0; i0[ 3] = b0+sy; /*l0*/ i0[ 4] = l0; i0[ 5] = l0+sy;
    /*r0*/ i0[ 6] = r0; i0[ 7] = r0+sy; /*t0*/ i0[ 8] = t0; i0[ 9] = t0+sy;
    /*b1*/ i0[10] = b1; i0[11] = b1+sy; /*l1*/ i0[12] = l1; i0[13] = l1+sy;
    /*r1*/ i0[14] = r1; i0[15] = r1+sy; /*t1*/ i0[16] = t1; i0[17] = t1+sy;
    /*cc*/ i1[ 0] = cc+sx; i1[ 1] = cc+sb;
    /*b0*/ i1[ 2] = b0+sx; i1[ 3] = b0+sb; /*l0*/ i1[ 4] = l0+sx; i1[ 5] = l0+sb;
    /*r0*/ i1[ 6] = r0+sx; i1[ 7] = r0+sb; /*t0*/ i1[ 8] = t0+sx; i1[ 9] = t0+sb;
    /*b1*/ i1[10] = b1+sx; i1[11] = b1+sb; /*l1*/ i1[12] = l1+sx; i1[13] = l1+sb;
    /*r1*/ i1[14] = r1+sx; i1[15] = r1+sb; /*t1*/ i1[16] = t1+sx; i1[17] = t1+sb;
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, 18, 18);

    // Avoid constant FP division
    register d_t fac asm("fa4") = 1.0 / c::c0;
    // Use stacked registers for FREP
    register d_t cb0 asm("ft3")  = c::ym[0];
    register d_t cl0 asm("ft4")  = c::xm[0];
    register d_t cr0 asm("ft5")  = c::xp[0];
    register d_t ct0 asm("ft6")  = c::yp[0];
    register d_t cb1 asm("ft8")  = c::ym[1];
    register d_t cl1 asm("ft9")  = c::xm[1];
    register d_t cr1 asm("ft10") = c::xp[1];
    register d_t ct1 asm("ft11") = c::yp[1];
    register d_t cc_ asm("fa5") = c::cc;

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (y, ly, s::n-4,jmpy) {
            __rt_sssr_bound_stride_3d(2, 2, sodt, 2, s::n*sodt, (s::n-4+jmpx-lx-sp::ux)/jmpx, jmpx*sodt);
            bool winit = true;
            form (x, lx, s::n-4, jmpx) {
                __istc_iter_issrs((void*)&(*A[t%2])[y][x], (void*)i0, (void*)i1);
                if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)&(*A[(t+1)%2])[y+2][lx+2], 2, __RT_SSSR_REG_WPTR_2);}
                asm volatile (
                    // Initialize accumulators: center
                    "fmul.d    fa0, %[cc], ft0      \n"
                    "fmul.d    fa1, %[cc], ft1      \n"
                    "fmul.d    fa2, %[cc], ft0      \n"
                    "fmul.d    fa3, %[cc], ft1      \n"
                    // Do directionals as loop
                    "frep.o    %[c3], 4, 3, 0b0010  \n"
                    "fmadd.d   fa0, ft3, ft0, fa0   \n"
                    "fmadd.d   fa1, ft3, ft1, fa1   \n"
                    "fmadd.d   fa2, ft3, ft0, fa2   \n"
                    "fmadd.d   fa3, ft3, ft1, fa3   \n"
                    // Do directionals as loop
                    "frep.o    %[c3], 4, 3, 0b0010  \n"
                    "fmadd.d   fa0, ft8, ft0, fa0   \n"
                    "fmadd.d   fa1, ft8, ft1, fa1   \n"
                    "fmadd.d   fa2, ft8, ft0, fa2   \n"
                    "fmadd.d   fa3, ft8, ft1, fa3   \n"
                    // Final scaling and writeback
                    "frep.o    %[c3], 1, 3, 0b100   \n"
                    "fmul.d    ft2, %[fc], fa0      \n"
                    : [cb0]"+&f"(cb0), [cl0]"+&f"(cl0), [cr0]"+&f"(cr0), [ct0]"+&f"(ct0),
                      [cb1]"+&f"(cb1), [cl1]"+&f"(cl1), [cr1]"+&f"(cr1), [ct1]"+&f"(ct1),
                      [cc]"+&f"(cc_), [fc]"+&f"(fac)
                    : [c3]"r"(3)
                    : "memory", "fa0", "fa1", "fa2", "fa3"
                );
            }
            lx = (lx + sp::px) % jmpx;
        }
        ly = (ly + sp::py) % jmpy;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


KNL istci_an5d_j2d9pt_gol(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t
        bl = 0,    bc = dx,      br = 2*dx,
        ml = dy,   mc = dx+dy,   mr = 2*dx+dy,
        tl = 2*dy, tc = dx+2*dy, tr = 2*dx+2*dy;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    IDXA i0[18], i1[18];
    /*mc*/ i0[ 0] = mc; i0[ 1] = mc + sy;
    /*bl*/ i0[ 2] = bl; i0[ 3] = bl + sy; /*bc*/ i0[ 4] = bc; i0[ 5] = bc + sy;
    /*br*/ i0[ 6] = br; i0[ 7] = br + sy; /*ml*/ i0[ 8] = ml; i0[ 9] = ml + sy;
    /*mr*/ i0[10] = mr; i0[11] = mr + sy; /*tl*/ i0[12] = tl; i0[13] = tl + sy;
    /*tc*/ i0[14] = tc; i0[15] = tc + sy; /*tr*/ i0[16] = tr; i0[17] = tr + sy;
    /*mc*/ i1[ 0] = mc + sx; i1[ 1] = mc + sb;
    /*bl*/ i1[ 2] = bl + sx; i1[ 3] = bl + sb; /*bc*/ i1[ 4] = bc + sx; i1[ 5] = bc + sb;
    /*br*/ i1[ 6] = br + sx; i1[ 7] = br + sb; /*ml*/ i1[ 8] = ml + sx; i1[ 9] = ml + sb;
    /*mr*/ i1[10] = mr + sx; i1[11] = mr + sb; /*tl*/ i1[12] = tl + sx; i1[13] = tl + sb;
    /*tc*/ i1[14] = tc + sx; i1[15] = tc + sb; /*tr*/ i1[16] = tr + sx; i1[17] = tr + sb;
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, 18, 18);

    // Avoid constant FP division
    register d_t fac asm("fa4") = 1.0 / c::c0;
    // Use stacked registers for FREP
    register d_t cmc asm("fa5")  = c::c[1][1];
    register d_t cbl asm("ft3")  = c::c[0][0];
    register d_t cbc asm("ft4")  = c::c[0][1];
    register d_t cbr asm("ft5")  = c::c[0][2];
    register d_t cml asm("ft6")  = c::c[1][0];
    register d_t cmr asm("ft8")  = c::c[1][2];
    register d_t ctl asm("ft9")  = c::c[2][0];
    register d_t ctc asm("ft10") = c::c[2][1];
    register d_t ctr asm("ft11") = c::c[2][2];

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (y, ly, s::n-2,jmpy) {
            __rt_sssr_bound_stride_3d(2, 2, sodt, 2, s::n*sodt, (s::n-2+jmpx-lx-sp::ux)/jmpx, jmpx*sodt);
            bool winit = true;
            form (x, lx, s::n-2, jmpx) {
                __istc_iter_issrs((void*)&(*A[t%2])[y][x], (void*)i0, (void*)i1);
                if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)&(*A[(t+1)%2])[y+1][lx+1], 2, __RT_SSSR_REG_WPTR_2);}
                asm volatile (
                    // Initialize accumulators: center
                    "fmul.d    fa0, %[cmc], ft0     \n"
                    "fmul.d    fa1, %[cmc], ft1     \n"
                    "fmul.d    fa2, %[cmc], ft0     \n"
                    "fmul.d    fa3, %[cmc], ft1     \n"
                    // Do directionals as loop
                    "frep.o    %[c3], 4, 3, 0b0010  \n"
                    "fmadd.d   fa0, ft3, ft0, fa0   \n"
                    "fmadd.d   fa1, ft3, ft1, fa1   \n"
                    "fmadd.d   fa2, ft3, ft0, fa2   \n"
                    "fmadd.d   fa3, ft3, ft1, fa3   \n"
                    // Do directionals as loop
                    "frep.o    %[c3], 4, 3, 0b0010  \n"
                    "fmadd.d   fa0, ft8, ft0, fa0   \n"
                    "fmadd.d   fa1, ft8, ft1, fa1   \n"
                    "fmadd.d   fa2, ft8, ft0, fa2   \n"
                    "fmadd.d   fa3, ft8, ft1, fa3   \n"
                    // Final scaling and writeback
                    "frep.o    %[c3], 1, 3, 0b100   \n"
                    "fmul.d    ft2, %[fc], fa0      \n"
                    : [cbl]"+&f"(cbl), [cbc]"+&f"(cbc), [cbr]"+&f"(cbr), [cml]"+&f"(cml),
                      [cmr]"+&f"(cmr), [ctl]"+&f"(ctl), [ctc]"+&f"(ctc), [ctr]"+&f"(ctr),
                      [cmc]"+&f"(cmc), [fc]"+&f"(fac)
                    : [c3]"r"(3)
                    : "memory", "fa0", "fa1", "fa2", "fa3"
                );
            }
            lx = (lx + sp::px) % jmpx;
        }
        ly = (ly + sp::py) % jmpy;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


KNL istci_an5d_j3d27pt(
    const int cid,
    TCDM d_t (RCP A[2])[s::nz][s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uz == 1 && sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, dz = s::n*s::n, sx = dx, sy = dy, sb = sy+sx;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    constexpr uint32_t ilen = 2*27;
    IDXA i0[ilen], i1[ilen];
    IDXA *p0 = i0, *p1 = i1;
    #pragma unroll
    for (int z = 0; z < 3; ++z)
        #pragma unroll
        for (int y = 0; y < 3; ++y)
            #pragma unroll
            for (int x = 0; x < 3; ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                /*pt0*/ *(p0++) = pt;    *(p0++) = pt+sy;
                /*pt1*/ *(p1++) = pt+sx; *(p1++) = pt+sb;
            }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    // Avoid constant FP division
    register d_t fac asm("ft3") = 1.0 / c::c0;
    // Buffer constants in order for SSR use (each repeated to cover unroll)
    COFA ca[27];
    COFA* pa = ca;
    #pragma unroll
    for (int z = 0; z < 3; ++z)
        #pragma unroll
        for (int y = 0; y < 3; ++y)
            #pragma unroll
            for (int x = 0; x < 3; ++x)
                *(pa++) = c::c3[z][y][x];
    __rt_sssr_cfg_write(sp::uy*sp::ux-1, 2, __RT_SSSR_REG_REPEAT);

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {

        form (z, lz, s::n-2,jmpz) {
            form (y, ly, s::n-2,jmpy) {
                __rt_sssr_bound_stride_2d(2, 27, sodt, (s::n-2+jmpx-lx-sp::ux)/jmpx, 0);
                bool winit = true;
                form (x, lx, s::n-2, jmpx) {
                    __istc_iter_issrs((void*)&(*A[t%2])[z][y][x], (void*)i0, (void*)i1);
                    if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                    asm volatile (
                        // Initialize accumulators: bottom left
                        "fmul.d    fa0, ft2, ft0       \n"
                        "fmul.d    fa1, ft2, ft1       \n"
                        "fmul.d    fa2, ft2, ft0       \n"
                        "fmul.d    fa3, ft2, ft1       \n"
                        // Do remaining blocks as loop
                        "frep.o    %[cd], 4, 3, 0b0000 \n"
                        "fmadd.d   fa0, ft2, ft0, fa0  \n"
                        "fmadd.d   fa1, ft2, ft1, fa1  \n"
                        "fmadd.d   fa2, ft2, ft0, fa2  \n"
                        "fmadd.d   fa3, ft2, ft1, fa3  \n"
                        // Final scaling
                        "frep.o    %[c3], 1, 3, 0b101  \n"
                        "fmul.d    fa0, %[fc], fa0     \n"
                        // Final writeback
                        "fsd       fa0, 0    (%[wb])   \n"
                        "fsd       fa1, %[sx](%[wb])   \n"
                        "fsd       fa2, %[sy](%[wb])   \n"
                        "fsd       fa3, %[sb](%[wb])   \n"
                        : [fc]"+&f"(fac)
                        : [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [cd]"r"(27-2), [c3]"r"(3),
                          [wb]"r"(&(*A[(t+1)%2])[z+1][y+1][x+1])
                        : "memory", "fa0", "fa1", "fa2", "fa3"
                    );
                }
                lx = (lx + sp::px) % jmpx;
            }
            ly = (ly + sp::py) % jmpy;
        }
        lz = (lz + sp::pz) % jmpz;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


KNL istci_an5d_star2dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    static_assert(ci::r >= 1, "Radius must be at least 1!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t cc = ci::r*dy + ci::r*dx;
    constexpr uint32_t npoints = 1+4*ci::r;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    constexpr uint32_t ilen = 2*npoints;
    IDXA i0[ilen], i1[ilen];
    IDXA *p0 = i0, *p1 = i1;
    /*cc0*/ *(p0++) = cc;    *(p0++) = cc+sy;
    /*cc1*/ *(p1++) = cc+sx; *(p1++) = cc+sb;
    #pragma unroll
    for (int j = 1; j <= ci::r; ++j) {
            uint32_t bb = cc-j*dy, ll = cc-j*dx, rr = cc+j*dx, tt = cc+j*dy;
            /*bb0*/ *(p0++) = bb;    *(p0++) = bb+sy; /*ll0*/ *(p0++) = ll;    *(p0++) = ll+sy;
            /*rr0*/ *(p0++) = rr;    *(p0++) = rr+sy; /*tt0*/ *(p0++) = tt;    *(p0++) = tt+sy;
            /*bb1*/ *(p1++) = bb+sx; *(p1++) = bb+sb; /*ll1*/ *(p1++) = ll+sx; *(p1++) = ll+sb;
            /*rr1*/ *(p1++) = rr+sx; *(p1++) = rr+sb; /*tt1*/ *(p1++) = tt+sx; *(p1++) = tt+sb;
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    // Buffer constants in order for SSR use (each repeated to cover unroll)
    COFA ca[npoints];
    COFA* pa = ca;
    /*cc*/ *(pa++) = c::cc;
    #pragma unroll
    for (int j = 0; j < ci::r; ++j) {
        /*bb*/ *(pa++) = c::ym[j]; /*ll*/ *(pa++) = c::xm[j];
        /*rr*/ *(pa++) = c::xp[j]; /*tt*/ *(pa++) = c::yp[j];
    }
    __rt_sssr_cfg_write(sp::uy*sp::ux-1, 2, __RT_SSSR_REG_REPEAT);

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (y, ly, s::n-2*ci::r,jmpy) {
            __rt_sssr_bound_stride_2d(2, npoints, sodt, (s::n-2*ci::r+jmpx-lx-sp::ux)/jmpx, 0);
            bool winit = true;
            form (x, lx, s::n-2*ci::r, jmpx) {
                __istc_iter_issrs((void*)&(*A[t%2])[y][x], (void*)i0, (void*)i1);
                if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                asm volatile (
                    // Initialize accumulators: center
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa1, ft2, ft1        \n"
                    "fmul.d    fa2, ft2, ft0        \n"
                    "fmul.d    fa3, ft2, ft1        \n"
                    // Do directionals as loop
                    "frep.o    %[cd], 4, 3, 0b0000  \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    // Final writeback
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa1, %[sx](%[wb])    \n"
                    "fsd       fa2, %[sy](%[wb])    \n"
                    "fsd       fa3, %[sb](%[wb])    \n"
                    :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [cd]"r"(npoints-2),
                       [wb]"r"(&(*A[(t+1)%2])[y+ci::r][x+ci::r])
                    : "memory", "fa0", "fa1", "fa2", "fa3"
                );
            }
            lx = (lx + sp::px) % jmpx;
        }
        ly = (ly + sp::py) % jmpy;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


KNL istci_an5d_box2dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    static_assert(ci::r >= 1, "Radius must be at least 1!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t npoints = (2*ci::r+1)*(2*ci::r+1);
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    constexpr uint32_t ilen = 2*npoints;
    IDXA i0[ilen], i1[ilen];
    IDXA *p0 = i0, *p1 = i1;
    #pragma unroll
    for (int y = 0; y < 2*ci::r+1; ++y)
        #pragma unroll
        for (int x = 0; x < 2*ci::r+1; ++x) {
            uint32_t pt = y*dy + x*dx;
            /*pt0*/ *(p0++) = pt;    *(p0++) = pt+sy;
            /*pt1*/ *(p1++) = pt+sx; *(p1++) = pt+sb;
        }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    // Buffer constants in order for SSR use (each repeated to cover unroll)
    COFA ca[npoints];
    COFA* pa = ca;
    #pragma unroll
    for (int y = 0; y < 2*ci::r+1; ++y)
        #pragma unroll
        for (int x = 0; x < 2*ci::r+1; ++x)
            *(pa++) = c::c[y][x];
    __rt_sssr_cfg_write(sp::uy*sp::ux-1, 2, __RT_SSSR_REG_REPEAT);

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (y, ly, s::n-2*ci::r,jmpy) {
            __rt_sssr_bound_stride_2d(2, npoints, sodt, (s::n-2*ci::r+jmpx-lx-sp::ux)/jmpx, 0);
            bool winit = true;
            form (x, lx, s::n-2*ci::r, jmpx) {
                __istc_iter_issrs((void*)&(*A[t%2])[y][x], (void*)i0, (void*)i1);
                if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                asm volatile (
                    // Initialize accumulators: center
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa1, ft2, ft1        \n"
                    "fmul.d    fa2, ft2, ft0        \n"
                    "fmul.d    fa3, ft2, ft1        \n"
                    // Do directionals as loop
                    "frep.o    %[cd], 4, 3, 0b0000  \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    // Final writeback
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa1, %[sx](%[wb])    \n"
                    "fsd       fa2, %[sy](%[wb])    \n"
                    "fsd       fa3, %[sb](%[wb])    \n"
                    :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [cd]"r"(npoints-2),
                       [wb]"r"(&(*A[(t+1)%2])[y+ci::r][x+ci::r])
                    : "memory", "fa0", "fa1", "fa2", "fa3"
                );
            }
            lx = (lx + sp::px) % jmpx;
        }
        ly = (ly + sp::py) % jmpy;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


KNL istci_an5d_star3dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::nz][s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uz == 1 && sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    static_assert(ci::r >= 1, "Radius must be at least 1!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, dz = s::n*s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t cc = ci::r*dz + ci::r*dy + ci::r*dx;
    constexpr uint32_t npoints = 1+6*ci::r;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    constexpr uint32_t ilen = 2*npoints;
    IDXA i0[ilen], i1[ilen];
    IDXA *p0 = i0, *p1 = i1;
    /*cc0*/ *(p0++) = cc;    *(p0++) = cc+sy;
    /*cc1*/ *(p1++) = cc+sx; *(p1++) = cc+sb;
    #pragma unroll
    for (int j = 1; j <= ci::r; ++j) {
            uint32_t bb = cc-j*dy, ll=cc-j*dx, rr = cc+j*dx, tt = cc+j*dy, aa = cc-j*dz, ff = cc+j*dz;
            /*bb0*/ *(p0++) = bb;    *(p0++) = bb+sy; /*ll0*/ *(p0++) = ll;    *(p0++) = ll+sy;
            /*rr0*/ *(p0++) = rr;    *(p0++) = rr+sy; /*tt0*/ *(p0++) = tt;    *(p0++) = tt+sy;
            /*aa0*/ *(p0++) = aa;    *(p0++) = aa+sy; /*ff0*/ *(p0++) = ff;    *(p0++) = ff+sy;
            /*bb1*/ *(p1++) = bb+sx; *(p1++) = bb+sb; /*ll1*/ *(p1++) = ll+sx; *(p1++) = ll+sb;
            /*rr1*/ *(p1++) = rr+sx; *(p1++) = rr+sb; /*tt1*/ *(p1++) = tt+sx; *(p1++) = tt+sb;
            /*aa1*/ *(p1++) = aa+sx; *(p1++) = aa+sb; /*ff1*/ *(p1++) = ff+sx; *(p1++) = ff+sb;
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    // Buffer constants in order for SSR use (each repeated to cover unroll)
    COFA ca[npoints];
    COFA* pa = ca;
    /*cc*/ *(pa++) = c::cc;
    #pragma unroll
    for (int j = 0; j < ci::r; ++j) {
        /*bb*/ *(pa++) = c::ym[j]; /*ll*/ *(pa++) = c::xm[j];
        /*rr*/ *(pa++) = c::xp[j]; /*tt*/ *(pa++) = c::yp[j];
        /*rr*/ *(pa++) = c::zm[j]; /*tt*/ *(pa++) = c::zp[j];
    }
    __rt_sssr_cfg_write(sp::uy*sp::ux-1, 2, __RT_SSSR_REG_REPEAT);

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (z, lz, s::n-2*ci::r,jmpz) {
            form (y, ly, s::n-2*ci::r,jmpy) {
                __rt_sssr_bound_stride_2d(2, npoints, sodt, (s::n-2*ci::r+jmpx-lx-sp::ux)/jmpx, 0);
                bool winit = true;
                form (x, lx, s::n-2*ci::r, jmpx) {
                    __istc_iter_issrs((void*)&(*A[t%2])[z][y][x], (void*)i0, (void*)i1);
                    if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                    asm volatile (
                        // Initialize accumulators: center
                        "fmul.d    fa0, ft2, ft0        \n"
                        "fmul.d    fa1, ft2, ft1        \n"
                        "fmul.d    fa2, ft2, ft0        \n"
                        "fmul.d    fa3, ft2, ft1        \n"
                        // Do directionals as loop
                        "frep.o    %[cd], 4, 3, 0b0000  \n"
                        "fmadd.d   fa0, ft2, ft0, fa0   \n"
                        "fmadd.d   fa1, ft2, ft1, fa1   \n"
                        "fmadd.d   fa2, ft2, ft0, fa2   \n"
                        "fmadd.d   fa3, ft2, ft1, fa3   \n"
                        // Final writeback
                        "fsd       fa0, 0    (%[wb])    \n"
                        "fsd       fa1, %[sx](%[wb])    \n"
                        "fsd       fa2, %[sy](%[wb])    \n"
                        "fsd       fa3, %[sb](%[wb])    \n"
                        :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [cd]"r"(npoints-2),
                           [wb]"r"(&(*A[(t+1)%2])[z+ci::r][y+ci::r][x+ci::r])
                        : "memory", "fa0", "fa1", "fa2", "fa3"
                    );
                }
                lx = (lx + sp::px) % jmpx;
            }
            ly = (ly + sp::py) % jmpy;
        }
        lz = (lz + sp::pz) % jmpz;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


KNL istci_an5d_box3dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::nz][s::ny][s::nx]
) {
    // Assertions and IDs
    static_assert(sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    static_assert(ci::r >= 1, "Radius must be at least 1!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t dx = 1, dy = s::n, dz = s::n*s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t npoints = (2*ci::r+1)*(2*ci::r+1)*(2*ci::r+1);
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    constexpr uint32_t ilen = 2*npoints;
    IDXA i0[ilen], i1[ilen];
    IDXA *p0 = i0, *p1 = i1;
    #pragma unroll
    for (int z = 0; z < 2*ci::r+1; ++z)
        #pragma unroll
        for (int y = 0; y < 2*ci::r+1; ++y)
            #pragma unroll
            for (int x = 0; x < 2*ci::r+1; ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                /*pt0*/ *(p0++) = pt;    *(p0++) = pt+sy;
                /*pt1*/ *(p1++) = pt+sx; *(p1++) = pt+sb;
            }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    // Buffer constants in order for SSR use (each repeated to cover unroll)
    COFA ca[npoints];
    COFA* pa = ca;
    #pragma unroll
    for (int z = 0; z < 2*ci::r+1; ++z)
        #pragma unroll
        for (int y = 0; y < 2*ci::r+1; ++y)
            #pragma unroll
            for (int x = 0; x < 2*ci::r+1; ++x)
                *(pa++) = c::c3[z][y][x];
    __rt_sssr_cfg_write(sp::uy*sp::ux-1, 2, __RT_SSSR_REG_REPEAT);

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        form (z, lz, s::n-2*ci::r,jmpz) {
            form (y, ly, s::n-2*ci::r,jmpy) {
                __rt_sssr_bound_stride_2d(2, npoints, sodt, (s::n-2*ci::r+jmpx-lx-sp::ux)/jmpx, 0);
                bool winit = true;
                form (x, lx, s::n-2*ci::r, jmpx) {
                    __istc_iter_issrs((void*)&(*A[t%2])[z][y][x], (void*)i0, (void*)i1);
                    if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                    asm volatile (
                        // Initialize accumulators: center
                        "fmul.d    fa0, ft2, ft0        \n"
                        "fmul.d    fa1, ft2, ft1        \n"
                        "fmul.d    fa2, ft2, ft0        \n"
                        "fmul.d    fa3, ft2, ft1        \n"
                        // Do directionals as loop
                        "frep.o    %[cd], 4, 3, 0b0000  \n"
                        "fmadd.d   fa0, ft2, ft0, fa0   \n"
                        "fmadd.d   fa1, ft2, ft1, fa1   \n"
                        "fmadd.d   fa2, ft2, ft0, fa2   \n"
                        "fmadd.d   fa3, ft2, ft1, fa3   \n"
                        // Final writeback
                        "fsd       fa0, 0    (%[wb])    \n"
                        "fsd       fa1, %[sx](%[wb])    \n"
                        "fsd       fa2, %[sy](%[wb])    \n"
                        "fsd       fa3, %[sb](%[wb])    \n"
                        :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [cd]"r"(npoints-2),
                           [wb]"r"(&(*A[(t+1)%2])[z+ci::r][y+ci::r][x+ci::r])
                        : "memory", "fa0", "fa1", "fa2", "fa3"
                    );
                }
                lx = (lx + sp::px) % jmpx;
            }
            ly = (ly + sp::py) % jmpy;
        }
        lz = (lz + sp::pz) % jmpz;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}


// =============
//    Minimod
// =============

KNL istci_minimod_acoustic_iso_cd(
    const int cid,
    TCDM d_t (RCP u[2])[s::nz][s::ny][s::nx],
    TCDM d_t (RCP f)[s::nz-8][s::ny-8][s::nx-8]
) {
    // Assertions and IDs
    static_assert(sp::uz == 1 && sp::uy == 2 && sp::ux == 2, "Axes unrolls are static!");
    static_assert(s::n % 2 == 0, "Axes must be unroll-aligned!");
    KNL_IDS_LOC(cid)

    // Define points of stencil and unroll copies
    constexpr uint32_t rad = 4;
    constexpr uint32_t dx = 1, dy = s::n, dz = s::n*s::n, sx = dx, sy = dy, sb = sy+sx;
    constexpr uint32_t cct = rad*dz + rad*dy + rad*dx;
    constexpr uint32_t nhpoints = 6*rad;
    // Indices include padding on axes (do not init arrays to prevent memcpy)
    constexpr uint32_t ilen = 2*nhpoints+4;
    IDXA i0[ilen], i1[ilen];
    IDXA *p0 = i0, *p1 = i1;
    /*cc0*/ *(p0++) = cct; *(p1++) = cct+sx;
    /*cc1*/ *(p0++) = cct+sy; *(p1++) = cct+sb;
    #pragma unroll
    for (int j = 1; j <= rad; ++j) {
        uint32_t ll=cct-j*dx, rr = cct+j*dx, bb = cct-j*dy, tt = cct+j*dy, aa = cct-j*dz, ff = cct+j*dz;
        /*ll0*/ *(p0++) = ll;    *(p1++) = ll+sx;
        /*ll1*/ *(p0++) = ll+sy; *(p1++) = ll+sb;
        /*rr0*/ *(p0++) = rr;    *(p1++) = rr+sx;
        /*rr1*/ *(p0++) = rr+sy; *(p1++) = rr+sb;
        /*bb0*/ *(p0++) = bb;    *(p1++) = bb+sx;
        /*bb1*/ *(p0++) = bb+sy; *(p1++) = bb+sb;
        /*tt0*/ *(p0++) = tt;    *(p1++) = tt+sx;
        /*tt1*/ *(p0++) = tt+sy; *(p1++) = tt+sb;
        /*aa0*/ *(p0++) = aa;    *(p1++) = aa+sx;
        /*aa1*/ *(p0++) = aa+sy; *(p1++) = aa+sb;
        /*ff0*/ *(p0++) = ff;    *(p1++) = ff+sx;
        /*ff1*/ *(p0++) = ff+sy; *(p1++) = ff+sb;
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    // Use registers for coefficients
    register d_t cc0 asm("f3");
    register d_t cx0 asm("f4");
    register d_t cy0 asm("f5");
    register d_t cz0 asm("f6");
    register d_t cx1 asm("f7");
    register d_t cy1 asm("f8");
    register d_t cz1 asm("f9");
    register d_t cx2 asm("f10");
    register d_t cy2 asm("f11");
    register d_t cz2 asm("f12");
    register d_t cx3 asm("f13");
    register d_t cy3 asm("f14");
    register d_t cz3 asm("f15");

    // Preload registers
    asm volatile(
        "fld f13, -8(%[xp])  \n"
        "fld f14, -8(%[yp])  \n"
        "fld f15, -8(%[zp])  \n"
            "fadd.d  f3, f13, f14 \n"
        "fld f4,   0(%[xp])  \n"
        "fld f5,   0(%[yp])  \n"
        "fld f6,   0(%[zp])  \n"
            "fadd.d  f3, f3, f15 \n"
        "fld f7,   8(%[xp])  \n"
        "fld f8,   8(%[yp])  \n"
        "fld f9,   8(%[zp])  \n"
            "fmul.d  f3, f3, %[cf2]\n"
        "fld f10, 16(%[xp])  \n"
        "fld f11, 16(%[yp])  \n"
        "fld f12, 16(%[zp])  \n"
        "fld f13, 24(%[xp])  \n"
        "fld f14, 24(%[yp])  \n"
        "fld f15, 24(%[zp])  \n"
        : "+&f"(cx0), "+&f"(cy0), "+&f"(cz0), "+&f"(cx1), "+&f"(cy1), "+&f"(cz1),
          "+&f"(cx2), "+&f"(cy2), "+&f"(cz2), "+&f"(cx3), "+&f"(cy3), "+&f"(cz3),
          "+&f"(cc0)
        : [xp]"r"(&c::xp[1]), [yp]"r"(&c::yp[1]), [zp]"r"(&c::zp[1]), [cf2]"f"(2.0)
    );

    // introduce variable for tracking impulse offsets
    uint32_t lf = cid;

    __RT_SSSR_BLOCK_BEGIN
    for (int t = 0; t < st::t; t++) {
        // We load last grid's center piece inside the time loop as it keeps changing
        int32_t ccoffs = &(*u[(t+1)%2])[rad][rad][rad] - &(*u[t%2])[0][0][0];
        /*cc0*/ i0[ilen-2] = ccoffs;    i0[ilen-1] = ccoffs+sy;
        /*cc1*/ i1[ilen-2] = ccoffs+sx; i1[ilen-1] = ccoffs+sb;
        form (z, lz, s::n-2*rad, jmpz) {
            form (y, ly, s::n-2*rad, jmpy) {
                __rt_sssr_bound_stride_3d(2, 2, sodt, 2, s::n*sodt, (s::n-2*rad+jmpx-lx-sp::ux)/jmpx, jmpx*sodt);
                bool winit = true;
                form (x, lx, s::n-2*rad, jmpx) {
                    register d_t fi0 asm("f28") = c::uffac * (*f)[z][y  ][x  ];
                    register d_t fix asm("f29") = c::uffac * (*f)[z][y  ][x+1];
                    // Set up SSRs
                    __istc_iter_issrs((void*)&(*u[t%2])[z][y][x], (void*)i0, (void*)i1);
                    // Load impulses
                    register d_t fiy asm("f30") = c::uffac * (*f)[z][y+1][x  ];
                    register d_t fib asm("f31") = c::uffac * (*f)[z][y+1][x+1];
                    if (winit) {winit = false; __rt_sssr_cfg_write_ptr((void*)&(*u[(t+1)%2])[z+rad][y+rad][lx+rad], 2, __RT_SSSR_REG_WPTR_2);}
                    asm volatile (
                        // First add centerpoint
                        "fmadd.d   f28,  f3, f0, f28    \n"
                        "fmadd.d   f29,  f3, f1, f29    \n"
                        "fmadd.d   f30,  f3, f0, f30    \n"
                        "fmadd.d   f31,  f3, f1, f31    \n"
                        // Iterate over points (stagger coeffs)
                        "frep.o    %[c3], 8, 3, 0b010   \n"
                        "fmadd.d   f28,  f4, f0, f28    \n"
                        "fmadd.d   f29,  f4, f1, f29    \n"
                        "fmadd.d   f30,  f4, f0, f30    \n"
                        "fmadd.d   f31,  f4, f1, f31    \n"
                        "fmadd.d   f28,  f4, f0, f28    \n"
                        "fmadd.d   f29,  f4, f1, f29    \n"
                        "fmadd.d   f30,  f4, f0, f30    \n"
                        "fmadd.d   f31,  f4, f1, f31    \n"
                        "frep.o    %[c7], 8, 7, 0b010   \n"
                        "fmadd.d   f28,  f8, f0, f28    \n"
                        "fmadd.d   f29,  f8, f1, f29    \n"
                        "fmadd.d   f30,  f8, f0, f30    \n"
                        "fmadd.d   f31,  f8, f1, f31    \n"
                        "fmadd.d   f28,  f8, f0, f28    \n"
                        "fmadd.d   f29,  f8, f1, f29    \n"
                        "fmadd.d   f30,  f8, f0, f30    \n"
                        "fmadd.d   f31,  f8, f1, f31    \n"
                        // Final subtraction and writeback
                        "fsub.d    f2, f28, f0          \n"
                        "fsub.d    f2, f29, f1          \n"
                        "fsub.d    f2, f30, f0          \n"
                        "fsub.d    f2, f31, f1          \n"
                        : "+&f"(cx0), "+&f"(cy0), "+&f"(cz0), "+&f"(cx1), "+&f"(cy1), "+&f"(cz1),
                          "+&f"(cx2), "+&f"(cy2), "+&f"(cz2), "+&f"(cx3), "+&f"(cy3), "+&f"(cz3),
                          "+&f"(cc0),
                          "+&f"(fi0), "+&f"(fix), "+&f"(fiy), "+&f"(fib)
                        : [c7]"r"(7), [c3]"r"(3)
                        : "memory"
                    );
                }
                lx = (lx + sp::ux) % jmpx;
            }
            ly = (ly + sp::uy) % jmpy;
        }
        lz = (lz + sp::uz) % jmpz;
        __rt_barrier();
    }
    __RT_SSSR_BLOCK_END
}
