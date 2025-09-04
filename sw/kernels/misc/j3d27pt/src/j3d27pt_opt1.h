// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Jayanth Jonnalagadda <jjonnalagadd@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

// Implementation using chaining, 2 SSRs for grid points, no FREP

// The Kernel
static inline void j3d27pt_opt1(int fac, int nx, int ny, int nz, double* c,
                                double* A, double* A_) {
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny * nx, sx = dx, sy = dy,
                   sb = sy + sx;
    const uint32_t npoints = 27;
    const uint32_t ilen = 2 * npoints;
    volatile __attribute__((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile __attribute__((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < 3; ++z) {
        for (int y = 0; y < 3; ++y) {
            for (int x = 0; x < 3; ++x) {
                uint32_t pt = z * dz + y * dy + x * dx;
                *(p0++) = pt;
                *(p0++) = pt + sy;
                *(p1++) = pt + sx;
                *(p1++) = pt + sb;
            }
        }
    }
    snrt_issr_set_idx_cfg(SNRT_SSR_DM0, SNRT_SSR_IDXSIZE_U16);
    snrt_issr_set_bound(SNRT_SSR_DM0, ilen);
    snrt_issr_set_idx_cfg(SNRT_SSR_DM1, SNRT_SSR_IDXSIZE_U16);
    snrt_issr_set_bound(SNRT_SSR_DM1, ilen);

    register double fact asm("fa7") = 1.0 / fac;

    asm volatile(
        "fld    ft3, 0(%[cf])  \n"
        "fld    ft4, 8(%[cf])  \n"
        "fld    ft5, 16(%[cf])  \n"
        "fld    ft6, 24(%[cf])  \n"
        "fld    ft7, 32(%[cf])  \n"
        "fld    ft8, 40(%[cf])  \n"
        "fld    ft9, 48(%[cf])  \n"
        "fld    ft10, 56(%[cf])  \n"
        "fld    ft11, 64(%[cf])  \n"
        "fld    fs0, 72(%[cf]) \n"
        "fld    fs1, 80(%[cf])  \n"
        "fld    fs2, 88(%[cf])  \n"
        "fld    fs3, 96(%[cf])  \n"
        "fld    fs4, 104(%[cf])  \n"
        "fld    fs5, 112(%[cf])  \n"
        "fld    fs6, 120(%[cf])  \n"
        "fld    fs7, 128(%[cf])  \n"
        "fld    fs8, 136(%[cf])  \n"
        "fld    fs9, 144(%[cf])  \n"
        "fld    fs10, 152(%[cf])  \n"
        "fld    fs11, 160(%[cf])  \n"
        "fld    fa1, 168(%[cf])  \n"
        "fld    fa2, 176(%[cf])  \n"
        "fld    fa3, 184(%[cf])  \n"
        "fld    fa4, 192(%[cf])  \n"
        "fld    fa5, 200(%[cf])  \n"
        "fld    fa6, 208(%[cf])  \n" ::[cf] "r"(&c[0])
        : "memory", "ft3", "ft4", "ft5", "ft6", "ft7", "ft8", "ft9", "ft10",
          "ft11", "fs0", "fs1", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7", "fs8",
          "fs9", "fs10", "fs11", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6");

    snrt_ssr_enable();
    uint32_t mask = 0x00000400;
    snrt_sc_enable(mask);
    int lx = 0, ly = 0, lz = 0;
    for (int z = lz; z < nz - 2; z++) {
        snrt_mcycle();
        for (int y = ly; y < ny - 2; y += 2) {
            for (int x = lx; x < nx - 2; x += 2) {
                snrt_issr_set_ptrs(SNRT_SSR_DM0,
                                   (void*)(&A[z * ny * nx + y * nx + x]),
                                   (void*)i0);
                snrt_issr_set_ptrs(SNRT_SSR_DM1,
                                   (void*)(&A[z * ny * nx + y * nx + x]),
                                   (void*)i1);
                asm volatile(
                    "fmul.d    fa0, ft3, ft0        \n"
                    "fmul.d    fa0, ft3, ft1        \n"
                    "fmul.d    fa0, ft3, ft0        \n"
                    "fmul.d    fa0, ft3, ft1        \n"
                    "fmadd.d   fa0, ft4, ft0, fa0   \n"
                    "fmadd.d   fa0, ft4, ft1, fa0   \n"
                    "fmadd.d   fa0, ft4, ft0, fa0   \n"
                    "fmadd.d   fa0, ft4, ft1, fa0   \n"
                    "fmadd.d   fa0, ft5, ft0, fa0   \n"
                    "fmadd.d   fa0, ft5, ft1, fa0   \n"
                    "fmadd.d   fa0, ft5, ft0, fa0   \n"
                    "fmadd.d   fa0, ft5, ft1, fa0   \n"
                    "fmadd.d   fa0, ft6, ft0, fa0   \n"
                    "fmadd.d   fa0, ft6, ft1, fa0   \n"
                    "fmadd.d   fa0, ft6, ft0, fa0   \n"
                    "fmadd.d   fa0, ft6, ft1, fa0   \n"
                    "fmadd.d   fa0, ft7, ft0, fa0   \n"
                    "fmadd.d   fa0, ft7, ft1, fa0   \n"
                    "fmadd.d   fa0, ft7, ft0, fa0   \n"
                    "fmadd.d   fa0, ft7, ft1, fa0   \n"
                    "fmadd.d   fa0, ft8, ft0, fa0   \n"
                    "fmadd.d   fa0, ft8, ft1, fa0   \n"
                    "fmadd.d   fa0, ft8, ft0, fa0   \n"
                    "fmadd.d   fa0, ft8, ft1, fa0   \n"
                    "fmadd.d   fa0, ft9, ft0, fa0   \n"
                    "fmadd.d   fa0, ft9, ft1, fa0   \n"
                    "fmadd.d   fa0, ft9, ft0, fa0   \n"
                    "fmadd.d   fa0, ft9, ft1, fa0   \n"
                    "fmadd.d   fa0, ft10, ft0, fa0   \n"
                    "fmadd.d   fa0, ft10, ft1, fa0   \n"
                    "fmadd.d   fa0, ft10, ft0, fa0   \n"
                    "fmadd.d   fa0, ft10, ft1, fa0   \n"
                    "fmadd.d   fa0, ft11, ft0, fa0   \n"
                    "fmadd.d   fa0, ft11, ft1, fa0   \n"
                    "fmadd.d   fa0, ft11, ft0, fa0   \n"
                    "fmadd.d   fa0, ft11, ft1, fa0   \n"
                    "fmadd.d   fa0, fs0, ft0, fa0   \n"
                    "fmadd.d   fa0, fs0, ft1, fa0   \n"
                    "fmadd.d   fa0, fs0, ft0, fa0   \n"
                    "fmadd.d   fa0, fs0, ft1, fa0   \n"
                    "fmadd.d   fa0, fs1, ft0, fa0   \n"
                    "fmadd.d   fa0, fs1, ft1, fa0   \n"
                    "fmadd.d   fa0, fs1, ft0, fa0   \n"
                    "fmadd.d   fa0, fs1, ft1, fa0   \n"
                    "fmadd.d   fa0, fs2, ft0, fa0   \n"
                    "fmadd.d   fa0, fs2, ft1, fa0   \n"
                    "fmadd.d   fa0, fs2, ft0, fa0   \n"
                    "fmadd.d   fa0, fs2, ft1, fa0   \n"
                    "fmadd.d   fa0, fs3, ft0, fa0   \n"
                    "fmadd.d   fa0, fs3, ft1, fa0   \n"
                    "fmadd.d   fa0, fs3, ft0, fa0   \n"
                    "fmadd.d   fa0, fs3, ft1, fa0   \n"
                    "fmadd.d   fa0, fs4, ft0, fa0   \n"
                    "fmadd.d   fa0, fs4, ft1, fa0   \n"
                    "fmadd.d   fa0, fs4, ft0, fa0   \n"
                    "fmadd.d   fa0, fs4, ft1, fa0   \n"
                    "fmadd.d   fa0, fs5, ft0, fa0   \n"
                    "fmadd.d   fa0, fs5, ft1, fa0   \n"
                    "fmadd.d   fa0, fs5, ft0, fa0   \n"
                    "fmadd.d   fa0, fs5, ft1, fa0   \n"
                    "fmadd.d   fa0, fs6, ft0, fa0   \n"
                    "fmadd.d   fa0, fs6, ft1, fa0   \n"
                    "fmadd.d   fa0, fs6, ft0, fa0   \n"
                    "fmadd.d   fa0, fs6, ft1, fa0   \n"
                    "fmadd.d   fa0, fs7, ft0, fa0   \n"
                    "fmadd.d   fa0, fs7, ft1, fa0   \n"
                    "fmadd.d   fa0, fs7, ft0, fa0   \n"
                    "fmadd.d   fa0, fs7, ft1, fa0   \n"
                    "fmadd.d   fa0, fs8, ft0, fa0   \n"
                    "fmadd.d   fa0, fs8, ft1, fa0   \n"
                    "fmadd.d   fa0, fs8, ft0, fa0   \n"
                    "fmadd.d   fa0, fs8, ft1, fa0   \n"
                    "fmadd.d   fa0, fs9, ft0, fa0   \n"
                    "fmadd.d   fa0, fs9, ft1, fa0   \n"
                    "fmadd.d   fa0, fs9, ft0, fa0   \n"
                    "fmadd.d   fa0, fs9, ft1, fa0   \n"
                    "fmadd.d   fa0, fs10, ft0, fa0   \n"
                    "fmadd.d   fa0, fs10, ft1, fa0   \n"
                    "fmadd.d   fa0, fs10, ft0, fa0   \n"
                    "fmadd.d   fa0, fs10, ft1, fa0   \n"
                    "fmadd.d   fa0, fs11, ft0, fa0   \n"
                    "fmadd.d   fa0, fs11, ft1, fa0   \n"
                    "fmadd.d   fa0, fs11, ft0, fa0   \n"
                    "fmadd.d   fa0, fs11, ft1, fa0   \n"
                    "fmadd.d   fa0, fa1, ft0, fa0   \n"
                    "fmadd.d   fa0, fa1, ft1, fa0   \n"
                    "fmadd.d   fa0, fa1, ft0, fa0   \n"
                    "fmadd.d   fa0, fa1, ft1, fa0   \n"
                    "fmadd.d   fa0, fa2, ft0, fa0   \n"
                    "fmadd.d   fa0, fa2, ft1, fa0   \n"
                    "fmadd.d   fa0, fa2, ft0, fa0   \n"
                    "fmadd.d   fa0, fa2, ft1, fa0   \n"
                    "fmadd.d   fa0, fa3, ft0, fa0   \n"
                    "fmadd.d   fa0, fa3, ft1, fa0   \n"
                    "fmadd.d   fa0, fa3, ft0, fa0   \n"
                    "fmadd.d   fa0, fa3, ft1, fa0   \n"
                    "fmadd.d   fa0, fa4, ft0, fa0   \n"
                    "fmadd.d   fa0, fa4, ft1, fa0   \n"
                    "fmadd.d   fa0, fa4, ft0, fa0   \n"
                    "fmadd.d   fa0, fa4, ft1, fa0   \n"
                    "fmadd.d   fa0, fa5, ft0, fa0   \n"
                    "fmadd.d   fa0, fa5, ft1, fa0   \n"
                    "fmadd.d   fa0, fa5, ft0, fa0   \n"
                    "fmadd.d   fa0, fa5, ft1, fa0   \n"
                    "fmadd.d   fa0, fa6, ft0, fa0   \n"
                    "fmadd.d   fa0, fa6, ft1, fa0   \n"
                    "fmadd.d   fa0, fa6, ft0, fa0   \n"
                    "fmadd.d   fa0, fa6, ft1, fa0   \n"
                    "frep.o    %[c3], 1, 3, 0b000   \n"
                    "fmul.d    fa0, %[fc], fa0      \n"
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa0, %[sx](%[wb])    \n"
                    "fsd       fa0, %[sy](%[wb])    \n"
                    "fsd       fa0, %[sb](%[wb])    \n"
                    : [ fc ] "+&f"(fact)
                    :
                    [ sx ] "i"(8 * sx), [ sy ] "i"(8 * sy), [ sb ] "i"(8 * sb),
                    [ wb ] "r"(&A_[(z + 1) * ny * nx + (y + 1) * nx + (x + 1)]),
                    [ c3 ] "r"(3)
                    : "memory", "fa0", "ft0", "ft1", "ft2", "ft3", "ft4", "ft5",
                      "ft6", "ft7", "ft8", "ft9", "ft10", "ft11", "fs0", "fs1",
                      "fs2", "fs3", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9",
                      "fs10", "fs11", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6");
            }
        }
    }
    snrt_sc_disable(mask);
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();
}