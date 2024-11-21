#include "snrt.h"
#include "math.h"
#include "stdint.h"
#include "stdbool.h"

#include "common.h"

// #define C_BASE
// #define SSRUNROLL
// #define SSRNOFREP
// #define SCSSRUNROLL
// #define SCSSRNOFREP
// #define SCSSRFURL
#define SCSSRCOFURL
// #define SCSSRFURLWB

// The Kernel
static inline void mcbox3d1r(int r, int nx, int ny, int nz, double* c, double* A, double* A_) {
    int cid = snrt_cluster_core_idx();
    
    int px = 2, py = 2, pz = 2;
    int ux = 2, uy = 2, uz = 1;

    int ix = cid % px;
    int iy = (cid / px) % py;
    int iz = cid / (px * py);

    int lx = ix * ux, ly = iy * uy, lz = iz * uz;
    int jmpx = px * ux, jmpy = py * uy, jmpz = pz * uz; 

#ifdef C_BASE
    snrt_mcycle();
    for (int z = iz+r; z < nz-r; z += pz) {
        for (int y = iy+r; y < ny-r; y += py) {
            for (int x = ix+r; x < nx-r; x += px) {
                double acc = 0.0;
                for (int dz = -r; dz <= r; dz++) {
                    for (int dy = -r; dy <= r; dy++) {
                        for (int dx = -r; dx <= r; dx++) {
                            acc += (c[((dz+r)*(2*r+1)*(2*r+1)) + ((dy+r)*(2*r+1)) + (dx+r)] * A[((z+dz)*ny*nx) + ((y+dy)*nx) + (x+dx)]);
                        }
                    }
                }
                A_[(z*ny*nx) + (y*nx) + x] = acc;
            }
        }
    }
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SSRUNROLL)
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny*nx, sx = dx, sy = dy, sb = sy+sx;
    const uint32_t npoints = (2*r+1)*(2*r+1)*(2*r+1);
    const uint32_t ilen = 2*npoints;
    volatile  __attribute__ ((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile  __attribute__ ((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                *(p0++) = pt;
                *(p0++) = pt+sy;
                *(p1++) = pt+sx;
                *(p1++) = pt+sb;
            }
        }
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    volatile  __attribute__ ((__aligned__(8))) double ca[npoints];
    volatile  __attribute__ ((__aligned__(8))) double *pa = ca;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                *(pa++) = c[z*(2*r+1)*(2*r+1) + y*(2*r+1) + x];
            }
        }
    }
    __rt_sssr_cfg_write(3, 2, __RT_SSSR_REG_REPEAT);

    snrt_ssr_enable();
    for (int z = lz; z < nz-2*r; z += jmpz) {
        for (int y = ly; y < ny-2*r; y += jmpy) {
            __rt_sssr_bound_stride_2d(2, npoints, sizeof(double), (nx-2*r+jmpx-lx-ux)/jmpx, 0);
            bool winit = true;
            for (int x = lx; x < nx-2*r; x += jmpx) {
                __istc_iter_issrs((void*)(&A[z*ny*nx + y*nx + x]), (void*)i0, (void*)i1);
                if (winit) { winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                asm volatile (
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa1, ft2, ft1        \n"
                    "fmul.d    fa2, ft2, ft0        \n"
                    "fmul.d    fa3, ft2, ft1        \n"
                    "frep.o    %[cd], 4, 3, 0b0000  \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa1, %[sx](%[wb])    \n"
                    "fsd       fa2, %[sy](%[wb])    \n"
                    "fsd       fa3, %[sb](%[wb])    \n"
                    :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [cd]"r"(npoints-2),
                       [wb]"r"(&A_[(z+r)*ny*nx + (y+r)*nx + (x+r)])
                    : "memory", "fa0", "fa1", "fa2", "fa3", "ft0", "ft1", "ft2"
                );
            }
        }
    }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SSRNOFREP)
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny*nx, sx = dx, sy = dy, sb = sy+sx;
    const uint32_t npoints = (2*r+1)*(2*r+1)*(2*r+1);
    const uint32_t ilen = 2*npoints;
    volatile  __attribute__ ((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile  __attribute__ ((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                *(p0++) = pt;
                *(p0++) = pt+sy;
                *(p1++) = pt+sx;
                *(p1++) = pt+sb;
            }
        }
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    volatile  __attribute__ ((__aligned__(8))) double ca[npoints];
    volatile  __attribute__ ((__aligned__(8))) double *pa = ca;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                *(pa++) = c[z*(2*r+1)*(2*r+1) + y*(2*r+1) + x];
            }
        }
    }
    __rt_sssr_cfg_write(3, 2, __RT_SSSR_REG_REPEAT);

    snrt_ssr_enable();
    for (int z = lz; z < nz-2*r; z += jmpz) {
        for (int y = ly; y < ny-2*r; y += jmpy) {
            __rt_sssr_bound_stride_2d(2, npoints, sizeof(double), (nx-2*r+jmpx-lx-ux)/jmpx, 0);
            bool winit = true;
            for (int x = lx; x < nx-2*r; x += jmpx) {
                __istc_iter_issrs((void*)(&A[z*ny*nx + y*nx + x]), (void*)i0, (void*)i1);
                if (winit) { winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                asm volatile (
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa1, ft2, ft1        \n"
                    "fmul.d    fa2, ft2, ft0        \n"
                    "fmul.d    fa3, ft2, ft1        \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa1, ft2, ft1, fa1   \n"
                    "fmadd.d   fa2, ft2, ft0, fa2   \n"
                    "fmadd.d   fa3, ft2, ft1, fa3   \n"
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa1, %[sx](%[wb])    \n"
                    "fsd       fa2, %[sy](%[wb])    \n"
                    "fsd       fa3, %[sb](%[wb])    \n"
                    :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [wb]"r"(&A_[(z+r)*ny*nx + (y+r)*nx + (x+r)])
                    : "memory", "fa0", "fa1", "fa2", "fa3", "ft0", "ft1", "ft2"
                );
            }
        }
    }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SCSSRUNROLL)
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny*nx, sx = dx, sy = dy, sb = sy+sx;
    const uint32_t npoints = (2*r+1)*(2*r+1)*(2*r+1);
    const uint32_t ilen = 2*npoints;
    volatile  __attribute__ ((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile  __attribute__ ((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                *(p0++) = pt;
                *(p0++) = pt+sy;
                *(p1++) = pt+sx;
                *(p1++) = pt+sb;
            }
        }
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    volatile  __attribute__ ((__aligned__(8))) double ca[npoints];
    volatile  __attribute__ ((__aligned__(8))) double *pa = ca;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                *(pa++) = c[z*(2*r+1)*(2*r+1) + y*(2*r+1) + x];
            }
        }
    }
    __rt_sssr_cfg_write(3, 2, __RT_SSSR_REG_REPEAT);

    snrt_ssr_enable();
    for (int z = lz; z < nz-2*r; z += jmpz) {
        for (int y = ly; y < ny-2*r; y += jmpy) {
            __rt_sssr_bound_stride_2d(2, npoints, sizeof(double), (nx-2*r+jmpx-lx-ux)/jmpx, 0);
            bool winit = true;
            for (int x = lx; x < nx-2*r; x += jmpx) {
                __istc_iter_issrs((void*)(&A[z*ny*nx + y*nx + x]), (void*)i0, (void*)i1);
                if (winit) { winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                uint32_t mask = 0x00000400;
                snrt_sc_enable(mask);
                asm volatile (
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa0, ft2, ft1        \n"
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa0, ft2, ft1        \n"
                    "frep.o    %[cd], 4, 3, 0b0000  \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa0, %[sx](%[wb])    \n"
                    "fsd       fa0, %[sy](%[wb])    \n"
                    "fsd       fa0, %[sb](%[wb])    \n"
                    :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [cd]"r"(npoints-2),
                       [wb]"r"(&A_[(z+r)*ny*nx + (y+r)*nx + (x+r)])
                    : "memory", "fa0", "ft0", "ft1", "ft2"
                );
                snrt_sc_disable(mask);
            }
        }
    }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SCSSRNOFREP)
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny*nx, sx = dx, sy = dy, sb = sy+sx;
    const uint32_t npoints = (2*r+1)*(2*r+1)*(2*r+1);
    const uint32_t ilen = 2*npoints;
    volatile  __attribute__ ((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile  __attribute__ ((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                *(p0++) = pt;
                *(p0++) = pt+sy;
                *(p1++) = pt+sx;
                *(p1++) = pt+sb;
            }
        }
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    volatile  __attribute__ ((__aligned__(8))) double ca[npoints];
    volatile  __attribute__ ((__aligned__(8))) double *pa = ca;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                *(pa++) = c[z*(2*r+1)*(2*r+1) + y*(2*r+1) + x];
            }
        }
    }
    __rt_sssr_cfg_write(3, 2, __RT_SSSR_REG_REPEAT);

    snrt_ssr_enable();
    for (int z = lz; z < nz-2*r; z += jmpz) {
        for (int y = ly; y < ny-2*r; y += jmpy) {
            __rt_sssr_bound_stride_2d(2, npoints, sizeof(double), (nx-2*r+jmpx-lx-ux)/jmpx, 0);
            bool winit = true;
            for (int x = lx; x < nx-2*r; x += jmpx) {
                __istc_iter_issrs((void*)(&A[z*ny*nx + y*nx + x]), (void*)i0, (void*)i1);
                if (winit) { winit = false; __rt_sssr_cfg_write_ptr((void*)ca, 2, __RT_SSSR_REG_RPTR_1);}
                uint32_t mask = 0x00000400;
                snrt_sc_enable(mask);
                asm volatile (
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa0, ft2, ft1        \n"
                    "fmul.d    fa0, ft2, ft0        \n"
                    "fmul.d    fa0, ft2, ft1        \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fmadd.d   fa0, ft2, ft0, fa0   \n"
                    "fmadd.d   fa0, ft2, ft1, fa0   \n"
                    "fsd       fa0, 0    (%[wb])    \n"
                    "fsd       fa0, %[sx](%[wb])    \n"
                    "fsd       fa0, %[sy](%[wb])    \n"
                    "fsd       fa0, %[sb](%[wb])    \n"
                    :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [wb]"r"(&A_[(z+r)*ny*nx + (y+r)*nx + (x+r)])
                    : "memory", "fa0", "ft0", "ft1", "ft2"
                );
                snrt_sc_disable(mask);
            }
        }
    }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SCSSRFURL)
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny*nx, sx = dx, sy = dy, sb = sy+sx;
    const uint32_t npoints = (2*r+1)*(2*r+1)*(2*r+1);
    const uint32_t ilen = 2*npoints;
    volatile  __attribute__ ((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile  __attribute__ ((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                *(p0++) = pt;
                *(p0++) = pt+sy;
                *(p1++) = pt+sx;
                *(p1++) = pt+sb;
            }
        }
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    snrt_ssr_enable();
        int lx = 0, ly = 0, lz = 0;
        for (int z = lz; z < nz-2*r; z++) {
            for (int y = ly; y < ny-2*r; y += 2) {
                for (int x = lx; x < nx-2*r; x += 2) {
                    __istc_iter_issrs((void*)(&A[z*ny*nx + y*nx + x]), (void*)i0, (void*)i1);
                    uint32_t mask = 0x00000400;
                    snrt_sc_enable(mask);
                    asm volatile (
                        "fmul.d    fa0, %[c0], ft0        \n"
                        "fmul.d    fa0, %[c0], ft1        \n"
                        "fmul.d    fa0, %[c0], ft0        \n"
                        "fmul.d    fa0, %[c0], ft1        \n"
                        "fmadd.d   fa0, %[c1], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c1], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c1], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c1], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c2], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c2], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c2], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c2], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c3], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c3], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c3], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c3], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c4], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c4], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c4], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c4], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c5], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c5], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c5], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c5], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c6], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c6], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c6], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c6], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c7], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c7], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c7], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c7], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c8], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c8], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c8], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c8], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c9], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c9], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c9], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c9], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c10], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c10], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c10], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c10], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c11], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c11], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c11], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c11], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c12], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c12], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c12], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c12], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c13], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c13], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c13], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c13], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c14], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c14], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c14], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c14], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c15], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c15], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c15], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c15], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c16], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c16], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c16], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c16], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c17], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c17], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c17], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c17], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c18], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c18], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c18], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c18], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c19], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c19], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c19], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c19], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c20], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c20], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c20], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c20], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c21], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c21], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c21], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c21], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c22], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c22], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c22], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c22], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c23], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c23], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c23], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c23], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c24], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c24], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c24], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c24], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c25], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c25], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c25], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c25], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c26], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c26], ft1, fa0   \n"
                        "fmadd.d   fa0, %[c26], ft0, fa0   \n"
                        "fmadd.d   fa0, %[c26], ft1, fa0   \n"
                        "fsd       fa0, 0    (%[wb])    \n"
                        "fsd       fa0, %[sx](%[wb])    \n"
                        "fsd       fa0, %[sy](%[wb])    \n"
                        "fsd       fa0, %[sb](%[wb])    \n"
                        :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [wb]"r"(&A_[(z+r)*ny*nx + (y+r)*nx + (x+r)]), 
                        [c0]"f"(c[0]), [c1]"f"(c[1]), [c2]"f"(c[2]), [c3]"f"(c[3]),
                        [c4]"f"(c[4]), [c5]"f"(c[5]), [c6]"f"(c[6]), [c7]"f"(c[7]),
                        [c8]"f"(c[8]), [c9]"f"(c[9]), [c10]"f"(c[10]), [c11]"f"(c[11]),
                        [c12]"f"(c[12]), [c13]"f"(c[13]), [c14]"f"(c[14]), [c15]"f"(c[15]),
                        [c16]"f"(c[16]), [c17]"f"(c[17]), [c18]"f"(c[18]), [c19]"f"(c[19]),
                        [c20]"f"(c[20]), [c21]"f"(c[21]), [c22]"f"(c[22]), [c23]"f"(c[23]),
                        [c24]"f"(c[24]), [c25]"f"(c[25]), [c26]"f"(c[26])
                        : "memory", "fa0", "ft0", "ft1", "ft2"
                    );
                    snrt_sc_disable(mask);
                }
            }
        }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SCSSRCOFURL)
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny*nx, sx = dx, sy = dy, sb = sy+sx;
    const uint32_t npoints = (2*r+1)*(2*r+1)*(2*r+1);
    const uint32_t ilen = 2*npoints;
    volatile  __attribute__ ((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile  __attribute__ ((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                *(p0++) = pt;
                *(p0++) = pt+sy;
                *(p1++) = pt+sx;
                *(p1++) = pt+sb;
            }
        }
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    asm volatile (
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
        "fld    fa6, 208(%[cf])  \n"
        :: [cf]"r"(&c[0])
        : "memory", "ft3", "ft4", "ft5", "ft6", "ft7", "ft8", "ft9", "ft10", "ft11",
          "fs0", "fs1", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9", "fs10",
          "fs11", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6"
    );

    snrt_ssr_enable();
        for (int z = lz; z < nz-2*r; z+=jmpz) {
            for (int y = ly; y < ny-2*r; y += jmpy) {
                for (int x = lx; x < nx-2*r; x += jmpx) {
                    __istc_iter_issrs((void*)(&A[z*ny*nx + y*nx + x]), (void*)i0, (void*)i1);
                    uint32_t mask = 0x00000400;
                    snrt_sc_enable(mask);
                    asm volatile (
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
                        "fsd       fa0, 0    (%[wb])    \n"
                        "fsd       fa0, %[sx](%[wb])    \n"
                        "fsd       fa0, %[sy](%[wb])    \n"
                        "fsd       fa0, %[sb](%[wb])    \n"
                        :: [sx]"i"(8*sx), [sy]"i"(8*sy), [sb]"i"(8*sb), [wb]"r"(&A_[(z+r)*ny*nx + (y+r)*nx + (x+r)])
                        : "memory", "fa0", "ft0", "ft1", "ft2",
                          "ft3", "ft4", "ft5", "ft6", "ft7", "ft8", "ft9", "ft10", "ft11", 
                          "fs0", "fs1", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9", "fs10", "fs11",
                          "fa1", "fa2", "fa3", "fa4", "fa5", "fa6"
                    );
                    snrt_sc_disable(mask);
                }
            }
        }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();

#elif defined(SCSSRFURLWB)
    snrt_mcycle();
    const uint32_t dx = 1, dy = nx, dz = ny*nx, sx = dx, sy = dy, sb = sy+sx;
    const uint32_t npoints = (2*r+1)*(2*r+1)*(2*r+1);
    const uint32_t ilen = 2*npoints;
    volatile  __attribute__ ((__aligned__(8))) uint16_t i0[ilen], i1[ilen];
    volatile  __attribute__ ((__aligned__(8))) uint16_t *p0 = i0, *p1 = i1;
    for (int z = 0; z < (2*r+1); ++z) {
        for (int y = 0; y < (2*r+1); ++y) {
            for (int x = 0; x < (2*r+1); ++x) {
                uint32_t pt = z*dz + y*dy + x*dx;
                *(p0++) = pt;
                *(p0++) = pt+sy;
                *(p1++) = pt+sx;
                *(p1++) = pt+sb;
            }
        }
    }
    __istc_setup_issrs(__RT_SSSR_IDXSIZE_U16, ilen, ilen);

    // volatile  __attribute__ ((__aligned__(8))) uint16_t i2[4];
    // volatile  __attribute__ ((__aligned__(8))) uint16_t *p2 = i2;
    // *(p2++) = 0;
    // *(p2++) = 8*sx;
    // *(p2++) = 8*sy;
    // *(p2++) = 8*sb;
    // __rt_sssr_cfg_write(__RT_SSSR_IDX_CFG(__RT_SSSR_IDXSIZE_U16, 0, 0), 2, __RT_SSSR_REG_IDX_CFG);
    // __rt_sssr_cfg_write(3, 2, __RT_SSSR_REG_BOUND_0);

    asm volatile (
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
        "fld    fa6, 208(%[cf])  \n"
        :: [cf]"r"(&c[0])
        : "memory", "ft3", "ft4", "ft5", "ft6", "ft7", "ft8", "ft9", "ft10", "ft11",
          "fs0", "fs1", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9", "fs10",
          "fs11", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6"
    );

    snrt_ssr_loop_1d(SNRT_SSR_DM2, nz*ny*nx, sizeof(double));
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, A_);

    snrt_ssr_enable();
    for (int z = lz; z < nz-2*r; z += jmpz) {
        for (int y = ly; y < ny-2*r; y += jmpy) {
            for (int x = lx; x < nx-2*r; x += jmpx) {
                __istc_iter_issrs((void*)(&A[z*ny*nx + y*nx + x]), (void*)i0, (void*)i1);
                // __rt_sssr_cfg_write_ptr((void*)(&A_[(z+r)*ny*nx + (y+r)*nx + (x+r)]), 2, __RT_SSSR_REG_IDX_BASE);
                // __rt_sssr_cfg_write_ptr((void*)i2, 2, __RT_SSSR_REG_WPTR_INDIR);
                uint32_t mask = 0x00000400;
                snrt_sc_enable(mask);
                asm volatile (
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
                    "fmadd.d   ft2, fa6, ft0, fa0   \n"
                    "fmadd.d   ft2, fa6, ft1, fa0   \n"
                    "fmadd.d   ft2, fa6, ft0, fa0   \n"
                    "fmadd.d   ft2, fa6, ft1, fa0   \n"
                    ::: "memory", "fa0", "ft0", "ft1", "ft2",
                        "ft3", "ft4", "ft5", "ft6", "ft7", "ft8", "ft9", "ft10", "ft11", 
                        "fs0", "fs1", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7", "fs8", "fs9", "fs10", "fs11",
                        "fa1", "fa2", "fa3", "fa4", "fa5", "fa6"
                );
                snrt_sc_disable(mask);
            }
        }
    }
    snrt_ssr_disable();
    snrt_fpu_fence();
    snrt_mcycle();

#else
    snrt_mcycle();
    for (int z = r; z < nz-r; z++) {
        for (int y = r; y < ny-r; y++) {
            for (int x = r; x < nx-r; x++) {
                double acc = 0.0;
                for (int dz = -r; dz <= r; dz++) {
                    for (int dy = -r; dy <= r; dy++) {
                        for (int dx = -r; dx <= r; dx++) {
                            acc += (c[((dz+r)*(2*r+1)*(2*r+1)) + ((dy+r)*(2*r+1)) + (dx+r)] * A[((z+dz)*ny*nx) + ((y+dy)*nx) + (x+dx)]);
                        }
                    }
                }
                A_[(z*ny*nx) + (y*nx) + x] = acc;
            }
        }
    }
    snrt_fpu_fence();
    snrt_mcycle();
#endif
}