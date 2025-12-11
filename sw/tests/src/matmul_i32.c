// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
// Compare RV32IM vs XPULPV2 integer matmul kernels on Snitch (no DMA, no checks)

#include <snrt.h>
#include <stdint.h>
#include <stdio.h>

#define matrix_M 32
#define matrix_N 32
#define matrix_P 32
// Reuse kernels from MemPool (header only declares plain C functions)
#include "mempool_matmul_i32p.h"

// ----------------------
// Matrix configuration
// ----------------------
#ifndef M
#define M 32
#endif
#ifndef N
#define N 32
#endif
#ifndef P
#define P 32
#endif

// ----------------------
// Buffers (L1 by default)
// ----------------------
static int32_t A[M * N];
static int32_t B[N * P];
static int32_t C_rv[M * P];
static int32_t C_xp[M * P];

// ----------------------
// Init helpers
// ----------------------
static void fill_inputs_identityB(void) {
    // A: simple pattern, B: identity — so C should equal A
    for (uint32_t i = 0; i < M; ++i) {
        for (uint32_t k = 0; k < N; ++k) {
            A[i * N + k] = (int32_t)((i + 1) * (k + 1) & 0x7fff);
        }
    }
    for (uint32_t k = 0; k < N; ++k) {
        for (uint32_t j = 0; j < P; ++j) {
            B[k * P + j] = (k == j) ? 1 : 0;  // identity
        }
    }
}

static void clear_out(int32_t *C) {
    for (uint32_t i = 0; i < M * P; ++i) C[i] = 0;
}

static int compare_C(const int32_t *Aexp, const int32_t *C) {
    // With B=I, expected C == A (when MxN and NxP with N==P)
    // Works as long as N == P; if not, you can skip this check.
    if (N != P) return 0;  // not a strict check in that case
    int errs = 0;
    for (uint32_t i = 0; i < M; ++i) {
        for (uint32_t j = 0; j < P; ++j) {
            int32_t a = Aexp[i * N + j];
            int32_t c = C[i * P + j];
            if (a != c) {
                ++errs;
                if (errs < 4)
                    printf("Mismatch @(%u,%u): A=%d C=%d\n", i, j, a, c);
            }
        }
    }
    return errs;
}

// ----------------------
// Main
// ----------------------
int main() {
    uint32_t core_id = snrt_cluster_core_idx();
    uint32_t num_cores = snrt_cluster_core_num();

    // Prepare inputs (core 0), then sync
    snrt_cluster_hw_barrier();
    if (core_id == 0) {
        printf("MatMul i32 compare on Snitch: M=%u N=%u P=%u, cores=%u\n", M, N,
               P, num_cores);
        fill_inputs_identityB();
        clear_out(C_rv);
        clear_out(C_xp);
    }
    snrt_cluster_hw_barrier();
    static int32_t *A_l1;
    static int32_t *B_l1;
    static int32_t *C_rv_l1;
    static int32_t *C_xp_l1;

    if (core_id == 0) {
        A_l1 = (int32_t *)snrt_l1_alloc(M * N * sizeof(int32_t));
        B_l1 = (int32_t *)snrt_l1_alloc(N * P * sizeof(int32_t));
        C_rv_l1 = (int32_t *)snrt_l1_alloc(M * P * sizeof(int32_t));
        C_xp_l1 = (int32_t *)snrt_l1_alloc(M * P * sizeof(int32_t));

        // copy inputs from global static to L1
        memcpy(A_l1, A, M * N * sizeof(int32_t));
        memcpy(B_l1, B, N * P * sizeof(int32_t));
        memset(C_rv_l1, 0, M * P * sizeof(int32_t));
        memset(C_xp_l1, 0, M * P * sizeof(int32_t));
    }

    snrt_cluster_hw_barrier();
    // ------------------------------
    // XPULPV2 optimized (if available)
    // ------------------------------
#if defined(__XPULPV2__)
    snrt_cluster_hw_barrier();
    if (core_id == 0) {
        snrt_reset_perf_counter(0);
        snrt_cfg_perf_counter(0, PERF_METRIC__CYCLE, 0);
        snrt_start_perf_counter(0);
    }
    snrt_cluster_hw_barrier();

    matmul_unrolled_2x2_parallel_i32_xpulpv2(A_l1, B_l1, C_xp_l1, M, N, P,
                                             core_id, num_cores);

    snrt_cluster_hw_barrier();
    uint32_t cycles_xp = 0;
    if (core_id == 0) {
        cycles_xp = snrt_get_perf_counter(0);
        printf("XPULPV2 cycles: %u\n", cycles_xp);

        // Optional functional check
        int errs = compare_C(A_l1, C_xp_l1);
        if (errs)
            printf("XPULPV2 result: %d mismatches\n", errs);
        else
            printf("XPULPV2 result: OK\n");
    }
#else
    // ------------------------------
    // RV32IM baseline
    // ------------------------------
    snrt_cluster_hw_barrier();
    if (core_id == 0) {
        snrt_reset_perf_counter(0);
        snrt_cfg_perf_counter(0, PERF_METRIC__CYCLE, 0);
        snrt_start_perf_counter(0);
    }
    snrt_cluster_hw_barrier();

    // Your reused kernel (parallel, row-split)
    matmul_unrolled_2x2_parallel_i32_rv32im(A_l1, B_l1, C_rv_l1, M, N, P,
                                            core_id, num_cores);

    snrt_cluster_hw_barrier();
    if (core_id == 0) {
        snrt_stop_perf_counter(0);
        uint32_t cycles = snrt_get_perf_counter(0);
        printf("RV32IM cycles: %u\n", cycles);
    }

    // Optional functional check vs A (since B=I)
    snrt_cluster_hw_barrier();
    if (core_id == 0) {
        int errs = compare_C(A_l1, C_rv_l1);
        if (errs)
            printf("RV32IM result: %d mismatches\n", errs);
        else
            printf("RV32IM result: OK\n");
    }
#endif

    snrt_cluster_hw_barrier();
    return 0;
}