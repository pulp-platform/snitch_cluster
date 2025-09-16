// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#ifndef LEN
#define LEN 12288
#endif

#ifndef BATCH_SIZE
#define BATCH_SIZE 96
#endif

#define IMPL_NAIVE 0
#define IMPL_BASELINE 1
#define IMPL_OPTIMIZED 2

#ifndef IMPL
#define IMPL IMPL_OPTIMIZED
#endif

#if IMPL == IMPL_NAIVE
#define FUNC_PTR vexpf_naive
#elif IMPL == IMPL_BASELINE
#define FUNC_PTR vexpf_baseline
#elif IMPL == IMPL_OPTIMIZED
#define FUNC_PTR vexpf_optimized
#endif

#define ALLOCATE_BUFFER(type, size) \
    (type *)snrt_l1_alloc_cluster_local(size * sizeof(type), sizeof(type))

__thread uint64_t T[64] = {
    0x3ff0000000000000, 0x3fefd9b0d3158574, 0x3fefb5586cf9890f,
    0x3fef9301d0125b51, 0x3fef72b83c7d517b, 0x3fef54873168b9aa,
    0x3fef387a6e756238, 0x3fef1e9df51fdee1, 0x3fef06fe0a31b715,
    0x3feef1a7373aa9cb, 0x3feedea64c123422, 0x3feece086061892d,
    0x3feebfdad5362a27, 0x3feeb42b569d4f82, 0x3feeab07dd485429,
    0x3feea47eb03a5585, 0x3feea09e667f3bcd, 0x3fee9f75e8ec5f74,
    0x3feea11473eb0187, 0x3feea589994cce13, 0x3feeace5422aa0db,
    0x3feeb737b0cdc5e5, 0x3feec49182a3f090, 0x3feed503b23e255d,
    0x3feee89f995ad3ad, 0x3feeff76f2fb5e47, 0x3fef199bdd85529c,
    0x3fef3720dcef9069, 0x3fef5818dcfba487, 0x3fef7c97337b9b5f,
    0x3fefa4afa2a490da, 0x3fefd0765b6e4540,
};

__thread const uint32_t EXP2F_TABLE_BITS = 5;
__thread const double N = 1 << EXP2F_TABLE_BITS;
__thread const double InvLn2N = 0x1.71547652b82fep+0 * N;
__thread const double SHIFT = 0x1.8p+52;
__thread const double C[4] = {0x1.c6af84b912394p-5 / N / N / N,
                              0x1.ebfce50fac4f3p-3 / N / N,
                              0x1.62e42ff0c52d6p-1 / N, 1.0};

#include "vexpf_baseline.h"
#include "vexpf_naive.h"
#include "vexpf_optimized.h"

static inline void vexpf_kernel(double *a, double *b) {
    snrt_mcycle();
    FUNC_PTR(a, b);
    snrt_mcycle();
}