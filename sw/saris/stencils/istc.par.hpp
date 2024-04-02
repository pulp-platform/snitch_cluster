// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "istc.common.hpp"

// ===============
//    Polybench
// ===============

KNL istcp_pb_jacobi_2d(
    const int cid,
    TCDM d_t (RCP A)[s::n][s::n],
    TCDM d_t (RCP B)[s::n][s::n]
) {
    KNL_IDS(cid)
    for (int t = 0; t < st::t; t++) {
        forpx (y, i, 1, s::n-1)
            forpex (4, x, j, 1, s::n-1)
                (*B)[i][j] = 0.2 * ((*A)[i][j] + (*A)[i][j-1] + (*A)[i][1+j] + (*A)[1+i][j] + (*A)[i-1][j]);
        __rt_barrier();
    }
}


// ==========
//    AN5D
// ==========

KNL istcp_an5d_j2d5pt(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    KNL_IDS(cid)
    // Avoid constant FP division
    constexpr d_t fac = 1.0 / c::c0;
    for (int t = 0; t < st::t; t++) {
        forpx (y, y, 1, s::ny-1)
            forpex (4, x, x, 1, s::nx-1)
                (*A[(t+1)%2])[y][x] = fac * (
                    c::ym[0] * (*A[t%2])[y-1][x  ] +
                    c::xm[0] * (*A[t%2])[y  ][x-1] +
                    c::cc    * (*A[t%2])[y  ][x  ] +
                    c::xp[0] * (*A[t%2])[y  ][x+1] +
                    c::yp[0] * (*A[t%2])[y+1][x  ]
                );
        __rt_barrier();
    }
}


KNL istcp_an5d_j2d9pt(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    KNL_IDS(cid)
    // Avoid constant FP division
    constexpr d_t fac = 1.0 / c::c0;
    for (int t = 0; t < st::t; t++) {
        forpx (y, y, 2, s::ny-2)
            forpex (2, x, x, 2, s::nx-2)
                (*A[(t+1)%2])[y][x] = fac * (
                    c::ym[0] * (*A[t%2])[y-1][x  ] + c::ym[1] * (*A[t%2])[y-2][x  ] +
                    c::xm[0] * (*A[t%2])[y  ][x-1] + c::xm[1] * (*A[t%2])[y  ][x-2] +
                    c::cc    * (*A[t%2])[y  ][x  ] +
                    c::xp[0] * (*A[t%2])[y  ][x+1] + c::xp[1] * (*A[t%2])[y  ][x+2] +
                    c::yp[0] * (*A[t%2])[y+1][x  ] + c::yp[1] * (*A[t%2])[y+2][x  ]
                );
        __rt_barrier();
    }
}


KNL istcp_an5d_j2d9pt_gol(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    KNL_IDS(cid)
    // Avoid constant FP division
    constexpr d_t fac = 1.0 / c::c0;
    for (int t = 0; t < st::t; t++) {
        forpx (y, y, 1, s::ny-1)
            forpex (2, x, x, 1, s::nx-1) {
                d_t acc = 0.0;
                #pragma unroll
                for (int dy = -1; dy <= 1; ++dy)
                    #pragma unroll
                    for (int dx = -1; dx <= 1; ++dx)
                        acc += c::c[dy+1][dx+1] * (*A[t%2])[y+dy][x+dx];
                (*A[(t+1)%2])[y][x] = fac * acc;
            }
        __rt_barrier();
    }
}


KNL istcp_an5d_star2dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    KNL_IDS(cid)
    for (int t = 0; t < st::t; t++) {
        forpx (y, y, ci::r, s::ny-ci::r)
            forpx (x, x, ci::r, s::nx-ci::r) {
                d_t acc = c::cc * (*A[t%2])[y][x];
                #pragma unroll
                for (int dr = 0; dr < ci::r; ++dr) {
                    acc += c::xm[dr] * (*A[t%2])[y][x-1-dr];
                    acc += c::xp[dr] * (*A[t%2])[y][x+1+dr];
                    acc += c::ym[dr] * (*A[t%2])[y-1-dr][x];
                    acc += c::yp[dr] * (*A[t%2])[y+1+dr][x];
                }
                (*A[(t+1)%2])[y][x] = acc;
            }
        __rt_barrier();
    }
}


KNL istcp_an5d_box2dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::ny][s::nx]
) {
    KNL_IDS(cid)
    for (int t = 0; t < st::t; t++) {
        forpx (y, y, ci::r, s::ny-ci::r)
            forpx (x, x, ci::r, s::nx-ci::r) {
                d_t acc = 0.0;
                #pragma unroll
                for (int dy = -ci::r; dy <= ci::r; ++dy)
                    #pragma unroll
                    for (int dx = -ci::r; dx <= ci::r; ++dx)
                        acc += c::c[dy+ci::r][dx+ci::r] * (*A[t%2])[y+dy][x+dx];
                (*A[(t+1)%2])[y][x] = acc;
            }
        __rt_barrier();
    }
}


KNL istcp_an5d_star3dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::nz][s::ny][s::nx]
) {
    KNL_IDS(cid)
    for (int t = 0; t < st::t; t++) {
        forpx (z, z, ci::r, s::nz-ci::r)
            forpx (y, y, ci::r, s::ny-ci::r)
                forpx (x, x, ci::r, s::nx-ci::r) {
                    d_t acc = c::cc * (*A[t%2])[z][y][x];
                    #pragma unroll
                    for (int dr = 0; dr < ci::r; ++dr) {
                        acc += c::xm[dr] * (*A[t%2])[z][y][x-1-dr];
                        acc += c::xp[dr] * (*A[t%2])[z][y][x+1+dr];
                        acc += c::ym[dr] * (*A[t%2])[z][y-1-dr][x];
                        acc += c::yp[dr] * (*A[t%2])[z][y+1+dr][x];
                        acc += c::zm[dr] * (*A[t%2])[z-1-dr][y][x];
                        acc += c::zp[dr] * (*A[t%2])[z+1+dr][y][x];
                    }
                    (*A[(t+1)%2])[z][y][x] = acc;
                }
        __rt_barrier();
    }
}


KNL istcp_an5d_box3dXr(
    const int cid,
    TCDM d_t (RCP A[2])[s::nz][s::ny][s::nx]
) {
    KNL_IDS(cid)
    for (int t = 0; t < st::t; t++) {
        forpx (z, z, ci::r, s::nz-ci::r)
            forpx (y, y, ci::r, s::ny-ci::r)
                forpx (x, x, ci::r, s::nx-ci::r) {
                    d_t acc = 0.0;
                    for (int dz = -ci::r; dz <= ci::r; ++dz)
                        #pragma unroll
                        for (int dy = -ci::r; dy <= ci::r; ++dy)
                            #pragma unroll
                            for (int dx = -ci::r; dx <= ci::r; ++dx)
                                acc += c::c3[dz+ci::r][dy+ci::r][dx+ci::r] * (*A[t%2])[z+dz][y+dy][x+dx];
                    (*A[(t+1)%2])[z][y][x] = acc;
                }
        __rt_barrier();
    }
}


KNL istcp_an5d_j3d27pt(
    const int cid,
    TCDM d_t (RCP A[2])[s::nz][s::ny][s::nx]
) {
    KNL_IDS(cid)
    // Avoid constant FP division
    constexpr d_t fac = 1.0 / c::c0;
    for (int t = 0; t < st::t; t++) {
        forpx (z, z, 1, s::nz-1)
            forpx (y, y, 1, s::ny-1)
                forpx (x, x, 1, s::nx-1) {
                    d_t acc = 0.0;
                    for (int dz = -1; dz <= 1; ++dz)
                        #pragma unroll
                        for (int dy = -1; dy <= 1; ++dy)
                            #pragma unroll
                            for (int dx = -1; dx <= 1; ++dx)
                                acc += c::c3[dz+1][dy+1][dx+1] * (*A[t%2])[z+dz][y+dy][x+dx];
                    (*A[(t+1)%2])[z][y][x] = fac * acc;
                }
        __rt_barrier();
    }
}

// =============
//    Minimod
// =============

KNL istcp_minimod_acoustic_iso_cd(
    const int cid,
    TCDM d_t (RCP u[2])[s::nz][s::ny][s::nx],
    TCDM d_t (RCP f)[s::nz-8][s::ny-8][s::nx-8]
) {
    KNL_IDS(cid)
    constexpr uint32_t rad = 4;
    // Compute coefficient of center point
    constexpr float cc = 2 * (c::xp[0] + c::yp[0] + c::zp[0]);
    for (int t = 0; t < st::t; t++) {
        forpx (z, z, rad, s::nz-rad)
            forpx (y, y, rad, s::ny-rad)
                forpx (x, x, rad, s::nx-rad) {
                    // Initialize with incorporated impulse (has optional factor)
                    d_t lapl = c::uffac * (*f)[z-rad][y-rad][x-rad];
                    // Compute Laplacian
                    lapl += cc * (*u[t%2])[z][y][x];
                    for (int m = 1; m <= rad; ++m)
                        lapl += c::xp[m] * ((*u[t%2])[z][y][x-m] + (*u[t%2])[z][y][x+m]) +
                                c::yp[m] * ((*u[t%2])[z][y-m][x] + (*u[t%2])[z][y+m][x]) +
                                c::zp[m] * ((*u[t%2])[z-m][y][x] + (*u[t%2])[z+m][y][x]);
                    (*u[(t+1)%2])[z][y][x] = lapl - (*u[(t+1)%2])[z][y][x];
                }
        __rt_barrier();
    }
}
