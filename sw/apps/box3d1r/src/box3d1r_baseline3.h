// Implementation using 3 SSRs (2 for grid points, 1 for coefficients) no FREP

static inline void box3d1r_baseline3(int r, int nx, int ny, int nz, double* c, double* A, double* A_) {
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
    int lx = 0, ly = 0, lz = 0;
    for (int z = lz; z < nz-2*r; z++) {
        snrt_mcycle();
        for (int y = ly; y < ny-2*r; y += 2) {
            __rt_sssr_bound_stride_2d(2, npoints, sizeof(double), (nx-2*r-lx)/2, 0);
            bool winit = true;
            for (int x = lx; x < nx-2*r; x += 2) {
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
}
