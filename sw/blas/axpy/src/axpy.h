// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "args.h"
#include "snrt.h"

#define BANK_ALIGNMENT 8
#define TCDM_ALIGNMENT (32 * BANK_ALIGNMENT)
#define ALIGN_UP_TCDM(addr) ALIGN_UP(addr, TCDM_ALIGNMENT)

static inline void axpy_naive(uint32_t n, double a, double* x, double* y, double* z) {
    int core_idx = snrt_cluster_core_idx();
    int frac = n / snrt_cluster_compute_core_num();
    int offset = core_idx;

    for (int i = offset; i < n; i += snrt_cluster_compute_core_num()) {
        z[i] = a * x[i] + y[i];
    }
    snrt_fpu_fence();
}

static inline void axpy_fma(uint32_t n, double a, double* x, double* y, double* z) {
    int core_idx = snrt_cluster_core_idx();
    int frac = n / snrt_cluster_compute_core_num();
    int offset = core_idx;

    for (int i = offset; i < n; i += snrt_cluster_compute_core_num()) {
        asm volatile (
            "fmadd.d %[z], %[a], %[x], %[y] \n"
            : [ z ]"=f"(z[i])
            : [ a ]"f"(a), [ x ]"f"(x[i]), [ y ]"f"(y[i])
        );
    }
    snrt_fpu_fence();
}

static inline void axpy_opt(uint32_t n, double a, double* x, double* y, double* z) {
    int core_idx = snrt_cluster_core_idx();
    int frac = n / snrt_cluster_compute_core_num();
    int offset = core_idx;

    snrt_ssr_loop_1d(SNRT_SSR_DM_ALL,
                     frac,
                     snrt_cluster_compute_core_num() * sizeof(double));

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_1D, x + offset);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_1D, y + offset);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_1D, z + offset);

    snrt_ssr_enable();

    asm volatile(
        "frep.o %[n_frep], 1, 0, 0 \n"
        "fmadd.d ft2, %[a], ft0, ft1\n"
        :
        : [ n_frep ] "r"(frac - 1), [ a ] "f"(a)
        : "ft0", "ft1", "ft2", "memory"
    );
    
    snrt_fpu_fence();
    snrt_ssr_disable();
}

static inline void axpy_job(axpy_args_t *args) {
    uint64_t local_x_addr, local_y_addr, local_z_addr;
    double *local_x, *local_y, *local_z;
    double *remote_x, *remote_y, *remote_z;

#ifndef JOB_ARGS_PRELOADED
    // Allocate space for job arguments in TCDM
    axpy_args_t *local_args = (axpy_args_t *)snrt_l1_next();

    // Copy job arguments to TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_args, args, sizeof(axpy_args_t));
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();
    args = local_args;
#endif

    // Calculate size and pointers for each cluster
    uint32_t frac = args->n / snrt_cluster_num();
    uint32_t offset = frac * snrt_cluster_idx();
    remote_x = args->x + offset;
    remote_y = args->y + offset;
    remote_z = args->z + offset;

    // Allocate space for job operands in TCDM
    // Align X with the 1st bank in TCDM, Y with the 8th and Z with the 16th.
    local_x_addr = ALIGN_UP_TCDM((uint64_t)args + sizeof(axpy_args_t));
    local_y_addr = ALIGN_UP_TCDM(local_x_addr + frac * sizeof(double)) + 8 * BANK_ALIGNMENT;
    local_z_addr = ALIGN_UP_TCDM(local_y_addr + frac * sizeof(double)) + 16 * BANK_ALIGNMENT;
    local_x = (double *)local_x_addr;
    local_y = (double *)local_y_addr;
    local_z = (double *)local_z_addr;

    // Copy job operands in TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac * sizeof(double);
        snrt_dma_start_1d(local_x, remote_x, size);
        snrt_dma_start_1d(local_y, remote_y, size);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    // Compute
    if (!snrt_is_dm_core()) {
        axpy_fp_t fp = args->funcptr;
        uint32_t start_cycle = snrt_mcycle();
        fp(frac, args->a, local_x, local_y, local_z);
        uint32_t end_cycle = snrt_mcycle();
    }
    snrt_cluster_hw_barrier();

    // Copy data out of TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac * sizeof(double);
        snrt_dma_start_1d(remote_z, local_z, size);
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();
}
