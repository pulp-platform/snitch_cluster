// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

static inline void vlogf_naive(float *a, double *b) {
    // Loop over sample
    for (int i = 0; i < LEN; i++) {
        asm volatile(
            // clang-format off
            "fmv.x.w  a0, %[input]             \n" // ix = asuint (x)
            "sub      a1, a0, %[OFF]           \n" // tmp = ix - OFF
            "srai     a2, a1, 23               \n" // k = (int32_t) tmp >> 23
            "lui      a3, 1046528              \n" // 0x1ff << 23
            "and      a3, a1, a3               \n" // tmp & 0x1ff << 23
            "sub      a3, a0, a3               \n" // iz = ix - (tmp & 0x1ff << 23)
            "srli     a1, a1, 15               \n" // tmp >> (23 - LOGF_TABLE_BITS)
            "andi     a1, a1, 240              \n" // i = (tmp >> (23 - LOGF_TABLE_BITS)) % N
            "add      a1, %[T], a1             \n" // T[i]
            "fld      fa0, 0(a1)               \n" // invc = T[i].invc
            "fld      fa1, 8(a1)               \n" // logc = T[i].logc
            "fmv.w.x  fa2, a3                  \n" // asfloat (iz)
            "fcvt.d.s fa2, fa2                 \n" // z = (double_t) asfloat (iz)
            "fmadd.d  fa2, fa2, fa0, %[A3]     \n" // r = z * invc - 1
            "fcvt.d.w fa0, a2                  \n" // (double_t) k
            "fmadd.d  fa1, fa0, %[Ln2], fa1    \n" // y0 = logc + (double_t) k * Ln2
            "fmul.d   fa0, fa2, fa2            \n" // r2 = r * r
            "fmadd.d  fa3, fa2, %[A1], %[A2]   \n" // y = A[1] * r + A[2]
            "fmadd.d  fa3, fa0, %[A0], fa3     \n" // y = A[0] * r2 + y
            "fadd.d   fa1, fa1, fa2            \n" // y = y * r2 + (y0 + r)
            "fmadd.d  %[output], fa3, fa0, fa1 \n" // y = y * r2 + (y0 + r)
            // clang-format on
            : [ output ] "=f"(b[i])
            : [ input ] "f"(a[i]), [ Ln2 ] "f"(Ln2), [ OFF ] "r"(OFF),
              [ A0 ] "f"(A[0]), [ A1 ] "f"(A[1]), [ A2 ] "f"(A[2]),
              [ A3 ] "f"(A[3]), [ T ] "r"(T)
            : "memory", "a0", "a1", "a2", "a3", "fa0", "fa1", "fa2", "fa3");
    }
    snrt_fpu_fence();
}
