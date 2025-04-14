// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Jayanth Jonnalagadda <jjonnalagadd@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

// Implementation using 3 SSRs (2 for grid points, 1 for coefficients) w/ FREP

// The Kernel
static inline void j3d27pt_baseline4(int fac, int nx, int ny, int nz, double* c,
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

    volatile __attribute__((__aligned__(8))) double ca[npoints];
    volatile __attribute__((__aligned__(8))) double* pa = ca;
    for (int z = 0; z < 3; ++z) {
        for (int y = 0; y < 3; ++y) {
            for (int x = 0; x < 3; ++x) {
                *(pa++) = c[z * 3 * 3 + y * 3 + x];
            }
        }
    }
    snrt_ssr_repeat(SNRT_SSR_DM2, 4);

    register double fact asm("ft3") = 1.0 / fac;

    snrt_ssr_enable();
    int lx = 0, ly = 0, lz = 0;
    for (int z = lz; z < nz - 2; z++) {
        snrt_mcycle();
        for (int y = ly; y < ny - 2; y += 2) {
            snrt_ssr_loop_2d(SNRT_SSR_DM2, npoints, (nx - 2 - lx) / 2,
                             sizeof(double), 0);
            bool winit = true;
            for (int x = lx; x < nx - 2; x += 2) {
                snrt_issr_set_ptrs(SNRT_SSR_DM0,
                                   (void*)(&A[z * ny * nx + y * nx + x]),
                                   (void*)i0);
                snrt_issr_set_ptrs(SNRT_SSR_DM1,
                                   (void*)(&A[z * ny * nx + y * nx + x]),
                                   (void*)i1);
                if (winit) {
                    winit = false;
                    snrt_ssr_read(SNRT_SSR_DM2, SNRT_SSR_2D, (void*)ca);
                }
                asm volatile(
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa1, ft2, ft1        \n"
                    "fmul.d    fa2, ft2, ft0        \n"
                    "fmul.d    fa3, ft2, ft1        \n"
                    "frep.o    %[cd], 4, 3, 0b0000  \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "frep.i    %[c3], 1, 3, 0b101   \n"
                    "fmul.d    fa0, %[fc], fa0      \n"
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa1, %[sx](%[wb])    \n"
                    "fsd       fa2, %[sy](%[wb])    \n"
                    "fsd       fa3, %[sb](%[wb])    \n"
                    : [ fc ] "+&f"(fact)
                    :
                    [ sx ] "i"(8 * sx), [ sy ] "i"(8 * sy), [ sb ] "i"(8 * sb),
                    [ cd ] "r"(npoints - 2), [ c3 ] "r"(3),
                    [ wb ] "r"(&A_[(z + 1) * ny * nx + (y + 1) * nx + (x + 1)])
                    : "memory", "fa0", "fa1", "fa2", "fa3", "ft0", "ft1",
                      "ft2");
            }
        }
    }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();
}