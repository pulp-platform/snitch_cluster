// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <runtime.h>
#include <math.h>
#include <stdint.h>

#pragma once

// ============
//    Macros
// ============

// ST and S contain temporal and spatial dimension constants, SP parallelization and unroll constants, C value constants of type `d_t`
#define RCP *__restrict__ const
#define PRM static constexpr int
#define PRMD static constexpr double
#define PRMX constexpr int
#define PRMXD constexpr double
struct __istc_dstr{PRM __dummy=0;};
PRMX __istc_dstr::__dummy;
#define KNL template<class st=__istc_dstr, class s=__istc_dstr, class sp=__istc_dstr, \
                     class c=__istc_dstr,  class ci=__istc_dstr, typename d_t=double, typename i_t=uint16_t> \
                     static __attribute__((noinline)) void
#define IDXA volatile  __attribute__ ((__aligned__(8))) i_t
#define COFA volatile  __attribute__ ((__aligned__(8))) d_t

// Shorten indexing code a bit
#define I(ptr) __rt_sssr_ptoi(ptr)
// Further simplify RCP deref magic (selexp indexes into A)
#define J(A, selexp) I(&(*A) selexp)

// Shorten unroll for loops and canonical axis loops
#define PRAGMA(X) _Pragma(#X)
#define foru(unroll) \
        PRAGMA(clang loop unroll_count(unroll)) \
        for
#define forp(unroll, i, init, pte, stride) for (int i = init; i < pte; i += stride)
#define forpu(unroll, i, init, pte, stride) foru(unroll) (int i = init; i < pte; i += stride)
// Axis assist macro: shortcut for most axes (requires KNL_IDS)
#define forpx(axis, ii, init, pte) forp(sp::u##axis, ii, i##axis+init, pte, sp::p##axis)
#define forpux(axis, ii, init, pte) forpu(sp::u##axis, ii, i##axis+init, pte, sp::p##axis)
// Same as forpux, but explicitly control unroll (e.g. 1). Helps when kernels
// get so large that register allocation suffocates and addresses stack-swap.
#define forpex(unroll, axis, ii, init, pte) forpu(unroll, ii, i##axis+init, pte, sp::p##axis)
// For manual unrolling: simply combines strides
#define form(i, init, pte, stride) for (int i = init; i < pte; i += stride)

// Macro to define core constants
#define KNL_IDS(cid) \
        const uint32_t ix = cid % sp::px; \
        const uint32_t iy = (cid / sp::px) % sp::py; \
        const uint32_t iz = cid / (sp::px * sp::py);

#define sodt sizeof(d_t)

// Macro for core constants with *local* unroll
#define KNL_IDS_LOC(cid) \
    KNL_IDS(cid) \
    uint32_t lx = ix * sp::ux; \
    uint32_t ly = iy * sp::uy; \
    uint32_t lz = iz * sp::uz; \
    constexpr uint32_t jmpz = sp::pz*sp::uz; \
    constexpr uint32_t jmpy = sp::py*sp::uy; \
    constexpr uint32_t jmpx = sp::px*sp::ux;

// ========================
//    Dimension defaults
// ========================

#define SU(name, dim) \
    struct name {PRM n=dim; PRM nx=dim; PRM ny=dim; PRM nz=dim;}; \
    PRMX name::n, name::nx, name::ny, name::nz;

// Keep these dimensions aligned with data generation
SU(s1s,  1000)
SU(s1sm, 1728)
SU(s1m,  2744)
SU(s1ml, 4096)
SU(s1l,  5832)

SU(s2s,  32)
SU(s2sm, 42)
SU(s2m,  52)
SU(s2ml, 64)
SU(s2l,  76)

SU(s3s,  10)
SU(s3sm, 12)
SU(s3m,  14)
SU(s3ml, 16)
SU(s3l,  18)

#define ST(name, steps) \
    struct name {PRM t=steps;}; \
    PRMX name::t;

ST(st1, 1)
ST(st4, 4)
ST(st12, 12)

#define SP(name, ncores, parz, pary, parx, unrz, unry, unrx, unru) \
    struct name {PRM nc=ncores; PRM px=parx; PRM py=pary; PRM pz=parz; PRM ux=unrx; PRM uy=unry; PRM uz=unrz; PRM uu=unru;}; \
    PRMX name::nc, name::px, name::py, name::pz, name::ux, name::uy, name::uz, name::uu;

SP(sp1, 8, 1, 1, 8, 1, 1, 4, 8)
SP(sp2, 8, 1, 2, 4, 1, 2, 2, 8)
SP(sp3, 8, 2, 2, 2, 1, 2, 2, 8)

// =============
//    Helpers
// =============

inline void __istc_barrier() {
    __rt_barrier();
}

inline double __istc_sgnjx(double rs1, double rs2) {
    double rd;
    asm volatile("fsgnjx.d %[rd], %[rs1], %[rs2]" : [rd]"=f"(rd) : [rs1]"f"(rs1), [rs2]"f"(rs2));
    return rd;
}

// Implements `sign(a) ==  sign(b) ? 0 : a` using only FP operations and no conditional logic
inline double __istc_ternclip(double a, double b) {
    // If `sign(a) == sign(b)`, then ainj is +|a|, otherwise |-a|
    double ainj = __istc_sgnjx(a, b);
    // This gives us +|a| if the condition holds, otherwise 0
    double ainj_clip = fmax(ainj, 0.0);
    // Inject original sign of a into the clipped result, yielding a or (+/-) 0
    return copysign(ainj_clip, a);
}

// ==================
//    ISSR helpers
// ==================

inline void __istc_setup_issrs(uint32_t idxsize, uint32_t i0l, uint32_t i1l) {
    __rt_sssr_cfg_write(__RT_SSSR_IDX_CFG(idxsize, 0, 0), __RT_SSSR_IDXALL, __RT_SSSR_REG_IDX_CFG);
    __rt_sssr_cfg_write(i0l-1, 0, __RT_SSSR_REG_BOUND_0);
    __rt_sssr_cfg_write(i1l-1, 1, __RT_SSSR_REG_BOUND_0);
}


inline void __istc_iter_issrs(void* base, void* i0, void* i1) {
    __rt_sssr_cfg_write_ptr(base, __RT_SSSR_IDXALL, __RT_SSSR_REG_IDX_BASE);
    __rt_sssr_cfg_write_ptr(i0, 0, __RT_SSSR_REG_RPTR_INDIR);
    __rt_sssr_cfg_write_ptr(i1, 1, __RT_SSSR_REG_RPTR_INDIR);
}

// ==========================
//    Verification helpers
// ==========================

inline void __istc_cmp_grids(
    uint32_t core_id, uint32_t core_num, uint32_t core_stride,
    TCDM double* grid1, TCDM double* grid2, uint32_t len, double rel_eps,
    TCDM volatile uint32_t* err_sema
) {
    __rt_barrier();
    uint32_t errors = 0;
    uint32_t stride = core_num * core_stride;
    #pragma clang loop unroll_count(16)
    for (int i = core_id; i < len; i += stride)
        errors += (fabs(grid1[i] - grid2[i]) > fabs(rel_eps * grid1[i]));
    __atomic_fetch_add(err_sema, errors, __ATOMIC_RELAXED);
    __rt_barrier();
}

volatile void __attribute__((noinline)) __istc_touch_grid(
    uint32_t core_id, uint32_t core_num, uint32_t core_stride,
    TCDM double* grid, uint32_t len, TCDM volatile uint32_t* ret_sema
) {
    __rt_barrier();
    uint32_t ret_loc;
    double sum = 0.0;
    uint32_t stride = core_num * core_stride;
    #pragma clang loop unroll_count(16)
    for (int i = core_id; i < len; i += stride)
        sum += grid[i];
    asm volatile("fcvt.w.d t1, %1; sub %0, t1, t1" : "=r"(ret_loc) : "f"(sum) : "memory", "t1");
    __atomic_fetch_add(ret_sema, ret_loc, __ATOMIC_RELAXED);
    __rt_barrier();
}
