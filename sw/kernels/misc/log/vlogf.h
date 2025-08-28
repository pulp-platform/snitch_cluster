// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#ifndef LEN
#define LEN 2048
#endif

#ifndef BATCH_SIZE
#define BATCH_SIZE 64
#endif

#define IMPL_NAIVE 0
#define IMPL_BASELINE 1
#define IMPL_OPTIMIZED 2
#define IMPL_ISSR 3

#ifndef IMPL
#define IMPL IMPL_OPTIMIZED
#endif

#if IMPL == IMPL_NAIVE
#define FUNC_PTR vlogf_naive
#elif IMPL == IMPL_BASELINE
#define FUNC_PTR vlogf_baseline
#elif IMPL == IMPL_OPTIMIZED || IMPL == IMPL_ISSR
#define FUNC_PTR vlogf_optimized
#endif

#define ALLOCATE_BUFFER(type, size) \
    (type *)snrt_l1_alloc_cluster_local(size * sizeof(type), sizeof(type))

#define LOGF_TABLE_BITS 4

typedef struct {
    double invc, logc;
} log_tab_entry_t;

__thread const log_tab_entry_t T[16] = {
    {0x1.661ec79f8f3bep+0, -0x1.57bf7808caadep-2},
    {0x1.571ed4aaf883dp+0, -0x1.2bef0a7c06ddbp-2},
    {0x1.49539f0f010bp+0, -0x1.01eae7f513a67p-2},
    {0x1.3c995b0b80385p+0, -0x1.b31d8a68224e9p-3},
    {0x1.30d190c8864a5p+0, -0x1.6574f0ac07758p-3},
    {0x1.25e227b0b8eap+0, -0x1.1aa2bc79c81p-3},
    {0x1.1bb4a4a1a343fp+0, -0x1.a4e76ce8c0e5ep-4},
    {0x1.12358f08ae5bap+0, -0x1.1973c5a611cccp-4},
    {0x1.0953f419900a7p+0, -0x1.252f438e10c1ep-5},
    {0x1p+0, 0x0p+0},
    {0x1.e608cfd9a47acp-1, 0x1.aa5aa5df25984p-5},
    {0x1.ca4b31f026aap-1, 0x1.c5e53aa362eb4p-4},
    {0x1.b2036576afce6p-1, 0x1.526e57720db08p-3},
    {0x1.9c2d163a1aa2dp-1, 0x1.bc2860d22477p-3},
    {0x1.886e6037841edp-1, 0x1.1058bc8a07ee1p-2},
    {0x1.767dcf5534862p-1, 0x1.4043057b6ee09p-2}};
__thread const double A[4] = {-0x1.00ea348b88334p-2, 0x1.5575b0be00b6ap-2,
                              -0x1.ffffef20a4123p-2, -1};
__thread const double Ln2 = 0x1.62e42fefa39efp-1;
__thread const uint32_t OFF = 0x3f330000;

#include "vlogf_baseline.h"
#include "vlogf_glibc.h"
#include "vlogf_naive.h"
#include "vlogf_optimized.h"

static inline void vlogf_kernel(float *a, double *b) {
    snrt_mcycle();
    FUNC_PTR(a, b);
    snrt_mcycle();
}
