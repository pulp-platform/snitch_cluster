// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

static inline uint32_t asuint(float f) {
    union {
        float f;
        uint32_t i;
    } u = {f};
    return u.i;
}

static inline float asfloat(uint32_t i) {
    union {
        uint32_t i;
        float f;
    } u = {i};
    return u.f;
}

float glibc_logf(float x) {
    /* double_t for better performance on targets with FLT_EVAL_METHOD==2.  */
    double_t z, r, r2, y, y0, invc, logc;
    uint32_t ix, iz, tmp;
    int k, i;

    ix = asuint(x);

    /* x = 2^k z; where z is in range [OFF,2*OFF] and exact.
       The range is split into N subintervals.
       The ith subinterval contains z and c is near its center.  */
    tmp = ix - OFF;
    i = (tmp >> (23 - LOGF_TABLE_BITS)) % (1 << LOGF_TABLE_BITS);
    k = (int32_t)tmp >> 23; /* arithmetic shift */
    iz = ix - (tmp & 0x1ff << 23);
    invc = T[i].invc;
    logc = T[i].logc;
    z = (double_t)asfloat(iz);

    /* log(x) = log1p(z/c-1) + log(c) + k*Ln2 */
    r = z * invc - 1;
    y0 = logc + (double_t)k * Ln2;

    /* Pipelined polynomial evaluation to approximate log1p(r).  */
    r2 = r * r;
    y = A[1] * r + A[2];
    y = A[0] * r2 + y;
    y = y * r2 + (y0 + r);
    return (float)y;
}

void vlogf_glibc(float *a, double *b) {
    for (int i = 0; i < LEN; i++) {
        b[i] = (double)glibc_logf(a[i]);
    }
}
