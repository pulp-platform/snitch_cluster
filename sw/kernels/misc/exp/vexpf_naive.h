// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

static inline void vexpf_naive(double *a, double *b) {
    uint64_t ki, t;

    if (snrt_cluster_core_idx() == 0) {
        // Loop over samples
        for (int i = 0; i < LEN; i++) {
            asm volatile(
                // clang-format off
                "fmul.d  fa3, %[InvLn2N], %[input] \n" // z = InvLn2N * xd
                "fadd.d  fa1, fa3, %[SHIFT]        \n" // kd = (double) (z + SHIFT)
                "fsd     fa1, 0(%[ki])             \n" // ki = asuint64 (kd)
                "lw      a0, 0(%[ki])              \n" // ki = asuint64 (kd)
                "andi    a1, a0, 0x1f              \n" // ki % N
                "slli    a1, a1, 0x3               \n" // T[ki % N]
                "add     a1, %[T], a1              \n" // T[ki % N]
                "lw      a2, 0(a1)                 \n" // t = T[ki % N]
                "lw      a1, 4(a1)                 \n" // t = T[ki % N]
                "slli    a0, a0, 0xf               \n" // ki << (52 - EXP2F_TABLE_BITS)
                "sw      a2, 0(%[t])               \n" // store lower 32b of t (unaffected)
                "add     a0, a0, a1                \n" // t += ki << (52 - EXP2F_TABLE_BITS)
                "sw      a0, 4(%[t])               \n" // store upper 32b of t
                "fsub.d  fa2, fa1, %[SHIFT]        \n" // kd -= SHIFT
                "fsub.d  fa3, fa3, fa2             \n" // r = z - kd
                "fmadd.d fa2, %[C0], fa3, %[C1]    \n" // z = C[0] * r + C[1]
                "fld     fa0, 0(%[t])              \n" // s = asdouble (t)
                "fmadd.d fa4, %[C2], fa3, %[C3]    \n" // y = C[2] * r + C[3]
                "fmul.d  fa1, fa3, fa3             \n" // r2 = r * r
                "fmadd.d fa4, fa2, fa1, fa4        \n" // y = z * r2 + y
                "fmul.d  %[output], fa4, fa0       \n" // y = y * s
                // clang-format on
                : [ output ] "=f"(b[i])
                : [ input ] "f"(a[i]), [ InvLn2N ] "f"(InvLn2N),
                  [ SHIFT ] "f"(SHIFT), [ C0 ] "f"(C[0]), [ C1 ] "f"(C[1]),
                  [ C2 ] "f"(C[2]), [ C3 ] "f"(C[3]), [ ki ] "r"(&ki),
                  [ t ] "r"(&t), [ T ] "r"(T)
                : "memory", "a0", "a1", "a2", "fa0", "fa1", "fa2", "fa3",
                  "fa4");
        }
    }
}
