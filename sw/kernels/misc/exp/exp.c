// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Reference implementation
float __expf(float x) {
    uint32_t abstop;
    uint64_t ki, t;
    /* double_t for better performance on targets with FLT_EVAL_METHOD==2.  */
    double_t kd, xd, z, r, r2, y, s;

    xd = (double_t)x;
    abstop = top12(x) & 0x7ff;
    if (__glibc_unlikely(abstop >= top12(88.0f))) {
        /* |x| >= 88 or x is nan.  */
        if (asuint(x) == asuint(-INFINITY)) return 0.0f;
        if (abstop >= top12(INFINITY)) return x + x;
        if (x > 0x1.62e42ep6f) /* x > log(0x1p128) ~= 88.72 */
            return __math_oflowf(0);
        if (x < -0x1.9fe368p6f) /* x < log(0x1p-150) ~= -103.97 */
            return __math_uflowf(0);
#if WANT_ERRNO_UFLOW
        if (x < -0x1.9d1d9ep6f) /* x < log(0x1p-149) ~= -103.28 */
            return __math_may_uflowf(0);
#endif
    }

    /* x*N/Ln2 = k + r with r in [-1/2, 1/2] and int k.  */
    z = InvLn2N * xd;

    /* Round and convert z to int, the result is in [-150*N, 128*N] and
       ideally ties-to-even rule is used, otherwise the magnitude of r
       can be bigger which gives larger approximation error.  */
#if TOINT_INTRINSICS
    kd = roundtoint(z);
    ki = converttoint(z);
#else
#define SHIFT __exp2f_data.shift
    kd = math_narrow_eval((double)(z + SHIFT)); /* Needs to be double.  */
    ki = asuint64(kd);
    kd -= SHIFT;
#endif
    r = z - kd;

    /* exp(x) = 2^(k/N) * 2^(r/N) ~= s * (C0*r^3 + C1*r^2 + C2*r + 1) */
    t = T[ki % N];
    t += ki << (52 - EXP2F_TABLE_BITS);
    s = asdouble(t);
    z = C[0] * r + C[1];
    r2 = r * r;
    y = C[2] * r + 1;
    y = z * r2 + y;
    y = y * s;
    return (float)y;
}

// Simplified reference implementation
float __expf(float x) {
    uint64_t ki, t;
    double_t kd, xd, z, r, r2, y, s;

    xd = (double_t)x;
    z = InvLn2N * xd;

    kd = (double)(z + SHIFT);
    ki = asuint64(kd);
    kd -= SHIFT;
    r = z - kd;

    t = T[ki % N];
    t += ki << (52 - EXP2F_TABLE_BITS);
    s = asdouble(t);
    z = C[0] * r + C[1];
    r2 = r * r;
    y = C[2] * r + 1;
    y = z * r2 + y;
    y = y * s;
    return (float)y;
}
