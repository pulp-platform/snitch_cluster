// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#define FP_ASM_BODY                              \
    "fcvt.d.s     fa2, ft0                   \n" \
    "fcvt.d.s     ft5, ft0                   \n" \
    "fcvt.d.s     ft6, ft0                   \n" \
    "fcvt.d.s     ft7, ft0                   \n" \
    "fmadd.d      fa2, fa2, ft1, %[A3]       \n" \
    "fmadd.d      ft5, ft5, ft1, %[A3]       \n" \
    "fmadd.d      ft6, ft6, ft1, %[A3]       \n" \
    "fmadd.d      ft7, ft7, ft1, %[A3]       \n" \
    "fcvt.d.w.copift fa0, ft0                \n" \
    "fcvt.d.w.copift fa4, ft0                \n" \
    "fcvt.d.w.copift fa5, ft0                \n" \
    "fcvt.d.w.copift fa6, ft0                \n" \
    "fmadd.d      fa1, fa0, %[Ln2], ft1      \n" \
    "fmadd.d      fa7, fa4, %[Ln2], ft1      \n" \
    "fmadd.d      ft3, fa5, %[Ln2], ft1      \n" \
    "fmadd.d      ft4, fa6, %[Ln2], ft1      \n" \
    "fmul.d       fa0, fa2, fa2              \n" \
    "fmul.d       fa4, ft5, ft5              \n" \
    "fmul.d       fa5, ft6, ft6              \n" \
    "fmul.d       fa6, ft7, ft7              \n" \
    "fmadd.d      fa3, fa2, %[A1], %[A2]     \n" \
    "fmadd.d      ft8, ft5, %[A1], %[A2]     \n" \
    "fmadd.d      ft9, ft6, %[A1], %[A2]     \n" \
    "fmadd.d      ft10, ft7, %[A1], %[A2]    \n" \
    "fmadd.d      fa3, fa0, %[A0], fa3       \n" \
    "fmadd.d      ft8, fa4, %[A0], ft8       \n" \
    "fmadd.d      ft9, fa5, %[A0], ft9       \n" \
    "fmadd.d      ft10, fa6, %[A0], ft10     \n" \
    "fadd.d       fa1, fa1, fa2              \n" \
    "fadd.d       fa7, fa7, ft5              \n" \
    "fadd.d       ft3, ft3, ft6              \n" \
    "fadd.d       ft4, ft4, ft7              \n" \
    "fmadd.d      ft2, fa3, fa0, fa1         \n" \
    "fmadd.d      ft2, ft8, fa4, fa7         \n" \
    "fmadd.d      ft2, ft9, fa5, ft3         \n" \
    "fmadd.d      ft2, ft10, fa6, ft4        \n"

#if IMPL == IMPL_ISSR
#define INT_ASM_BODY          \
    "lw   a0,  0(%[a])    \n" \
    "lw   a4,  4(%[a])    \n" \
    "lw   a5,  8(%[a])    \n" \
    "lw   a6, 12(%[a])    \n" \
    "sub  a1, a0, %[OFF]  \n" \
    "sub  a7, a4, %[OFF]  \n" \
    "sub  t0, a5, %[OFF]  \n" \
    "sub  t1, a6, %[OFF]  \n" \
    "srai a2, a1, 23      \n" \
    "srai t2, a7, 23      \n" \
    "srai t3, t0, 23      \n" \
    "srai t4, t1, 23      \n" \
    "sw   a2,  0(%[k])    \n" \
    "sw   t2,  8(%[k])    \n" \
    "sw   t3, 16(%[k])    \n" \
    "sw   t4, 24(%[k])    \n" \
    "lui  a3, 1046528     \n" \
    "lui  t5, 1046528     \n" \
    "lui  t6, 1046528     \n" \
    "lui  s0, 1046528     \n" \
    "and  a3, a1, a3      \n" \
    "and  t5, a7, t5      \n" \
    "and  t6, t0, t6      \n" \
    "and  s0, t1, s0      \n" \
    "sub  a3, a0, a3      \n" \
    "sub  t5, a4, t5      \n" \
    "sub  t6, a5, t6      \n" \
    "sub  s0, a6, s0      \n" \
    "sw   a3,  0(%[z])    \n" \
    "sw   t5,  8(%[z])    \n" \
    "sw   t6, 16(%[z])    \n" \
    "sw   s0, 24(%[z])    \n" \
    "srli a1, a1, 18      \n" \
    "srli a7, a7, 18      \n" \
    "srli t0, t0, 18      \n" \
    "srli t1, t1, 18      \n" \
    "andi a1, a1, 30      \n" \
    "andi a7, a7, 30      \n" \
    "andi t0, t0, 30      \n" \
    "andi t1, t1, 30      \n" \
    "sb   a1, 0(%[idx])   \n" \
    "sb   a7, 1(%[idx])   \n" \
    "sb   t0, 2(%[idx])   \n" \
    "sb   t1, 3(%[idx])   \n" \
    "addi a1, a1, 1       \n" \
    "addi a7, a7, 1       \n" \
    "addi t0, t0, 1       \n" \
    "addi t1, t1, 1       \n" \
    "sb   a1, 4(%[idx])   \n" \
    "sb   a7, 5(%[idx])   \n" \
    "sb   t0, 6(%[idx])   \n" \
    "sb   t1, 7(%[idx])   \n"
#else
#define INT_ASM_BODY          \
    "lw   a0,  0(%[a])    \n" \
    "lw   a4,  4(%[a])    \n" \
    "lw   a5,  8(%[a])    \n" \
    "lw   a6, 12(%[a])    \n" \
    "sub  a1, a0, %[OFF]  \n" \
    "sub  a7, a4, %[OFF]  \n" \
    "sub  t0, a5, %[OFF]  \n" \
    "sub  t1, a6, %[OFF]  \n" \
    "srai a2, a1, 23      \n" \
    "srai t2, a7, 23      \n" \
    "srai t3, t0, 23      \n" \
    "srai t4, t1, 23      \n" \
    "sw   a2,  0(%[k])    \n" \
    "sw   t2,  8(%[k])    \n" \
    "sw   t3, 16(%[k])    \n" \
    "sw   t4, 24(%[k])    \n" \
    "lui  a3, 1046528     \n" \
    "lui  t5, 1046528     \n" \
    "lui  t6, 1046528     \n" \
    "lui  s0, 1046528     \n" \
    "and  a3, a1, a3      \n" \
    "and  t5, a7, t5      \n" \
    "and  t6, t0, t6      \n" \
    "and  s0, t1, s0      \n" \
    "sub  a3, a0, a3      \n" \
    "sub  t5, a4, t5      \n" \
    "sub  t6, a5, t6      \n" \
    "sub  s0, a6, s0      \n" \
    "sw   a3,  0(%[z])    \n" \
    "sw   t5,  8(%[z])    \n" \
    "sw   t6, 16(%[z])    \n" \
    "sw   s0, 24(%[z])    \n" \
    "srli a1, a1, 15      \n" \
    "srli a7, a7, 15      \n" \
    "srli t0, t0, 15      \n" \
    "srli t1, t1, 15      \n" \
    "andi a1, a1, 240     \n" \
    "andi a7, a7, 240     \n" \
    "andi t0, t0, 240     \n" \
    "andi t1, t1, 240     \n" \
    "add  a1, %[T], a1    \n" \
    "add  a7, %[T], a7    \n" \
    "add  t0, %[T], t0    \n" \
    "add  t1, %[T], t1    \n" \
    "lw   a0,   0(a1)     \n" \
    "lw   a2,   4(a1)     \n" \
    "lw   a3,   8(a1)     \n" \
    "lw   a1,  12(a1)     \n" \
    "lw   a4,   0(a7)     \n" \
    "lw   a5,   4(a7)     \n" \
    "lw   a6,   8(a7)     \n" \
    "lw   a7,  12(a7)     \n" \
    "lw   t2,   0(t0)     \n" \
    "lw   t3,   4(t0)     \n" \
    "lw   t4,   8(t0)     \n" \
    "lw   t0,  12(t0)     \n" \
    "lw   t5,   0(t1)     \n" \
    "lw   t6,   4(t1)     \n" \
    "lw   s0,   8(t1)     \n" \
    "lw   t1,  12(t1)     \n" \
    "sw   a0,  0(%[invc]) \n" \
    "sw   a2,  4(%[invc]) \n" \
    "sw   a3,  0(%[logc]) \n" \
    "sw   a1,  4(%[logc]) \n" \
    "sw   a4,  8(%[invc]) \n" \
    "sw   a5, 12(%[invc]) \n" \
    "sw   a6,  8(%[logc]) \n" \
    "sw   a7, 12(%[logc]) \n" \
    "sw   t2, 16(%[invc]) \n" \
    "sw   t3, 20(%[invc]) \n" \
    "sw   t4, 16(%[logc]) \n" \
    "sw   t0, 20(%[logc]) \n" \
    "sw   t5, 24(%[invc]) \n" \
    "sw   t6, 28(%[invc]) \n" \
    "sw   s0, 24(%[logc]) \n" \
    "sw   t1, 28(%[logc]) \n"
#endif