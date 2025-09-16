// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "args.h"
#include "snrt.h"

#define DOUBLE_BUFFER 1

#define ALIGN_NEXT_FROM_BASE(addr, base, size) \
    (((((addr) - (base)) + (size)-1) / (size)) * (size) + (base))

#define BANK_ALIGNMENT 8
#define TCDM_ALIGNMENT (24 * BANK_ALIGNMENT)
#define ALIGN_UP_TCDM(addr) \
    ALIGN_NEXT_FROM_BASE(addr, SNRT_TCDM_START_ADDR, TCDM_ALIGNMENT)

static inline void axpy_naive(uint32_t n, double a, double *x, double *y,
                              double *z) {
    int core_idx = snrt_cluster_core_idx();
    int frac = n / snrt_cluster_compute_core_num();
    int offset = core_idx;

    for (int i = offset; i < n; i += snrt_cluster_compute_core_num()) {
        z[i] = a * x[i] + y[i];
    }
    snrt_fpu_fence();
}

static inline void axpy_fma(uint32_t n, double a, double *x, double *y,
                            double *z) {
    int core_idx = snrt_cluster_core_idx();
    int frac = n / snrt_cluster_compute_core_num();
    int offset = core_idx;

    for (int i = offset; i < n; i += snrt_cluster_compute_core_num()) {
        asm volatile("fmadd.d %[z], %[a], %[x], %[y] \n"
                     : [ z ] "=f"(z[i])
                     : [ a ] "f"(a), [ x ] "f"(x[i]), [ y ] "f"(y[i]));
    }
    snrt_fpu_fence();
}

static inline void axpy_opt(uint32_t n, double a, double *x, double *y,
                            double *z) {
    int core_idx = snrt_cluster_core_idx();
    int frac = n / snrt_cluster_compute_core_num();
    int offset = core_idx;

    snrt_ssr_loop_1d(SNRT_SSR_DM_ALL, frac,
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
        : "ft0", "ft1", "ft2", "memory");

    snrt_fpu_fence();
    snrt_ssr_disable();
}

static inline void axpy_job(axpy_args_t *args) {
    uint32_t frac, offset, size;
    uint64_t local_x0_addr, local_y0_addr, local_z0_addr, local_x1_addr,
        local_y1_addr, local_z1_addr;
    double *local_x[2];
    double *local_y[2];
    double *local_z[2];
    double *remote_x, *remote_y, *remote_z;
    uint32_t iterations, i, i_dma_in, i_compute, i_dma_out, buff_idx;

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

    // Calculate size of each tile
    frac = args->n / args->n_tiles;
    size = frac * sizeof(double);

    // Allocate space for job operands in TCDM
    // Align X with the 1st bank in TCDM, Y with the 8th and Z with the 16th.
    local_x0_addr = ALIGN_UP_TCDM((uint64_t)args + sizeof(axpy_args_t));
    local_y0_addr = ALIGN_UP_TCDM(local_x0_addr + size) + 8 * BANK_ALIGNMENT;
    local_z0_addr = ALIGN_UP_TCDM(local_y0_addr + size) + 16 * BANK_ALIGNMENT;
    local_x[0] = (double *)local_x0_addr;
    local_y[0] = (double *)local_y0_addr;
    local_z[0] = (double *)local_z0_addr;
    if (DOUBLE_BUFFER) {
        local_x1_addr = ALIGN_UP_TCDM(local_z0_addr + size);
        local_y1_addr =
            ALIGN_UP_TCDM(local_x1_addr + size) + 8 * BANK_ALIGNMENT;
        local_z1_addr =
            ALIGN_UP_TCDM(local_y1_addr + size) + 16 * BANK_ALIGNMENT;
        local_x[1] = (double *)local_x1_addr;
        local_y[1] = (double *)local_y1_addr;
        local_z[1] = (double *)local_z1_addr;
    }
    if (snrt_cluster_core_idx() == 0) {
        DUMP(local_x0_addr);
        DUMP(local_y0_addr);
        DUMP(local_z0_addr);
        DUMP(local_x1_addr);
        DUMP(local_y1_addr);
        DUMP(local_z1_addr);
    }

    // Calculate number of iterations
    iterations = args->n_tiles;
    if (DOUBLE_BUFFER) iterations += 2;

    // Iterate over all tiles
    for (i = 0; i < iterations; i++) {
        if (snrt_is_dm_core()) {
            // DMA in
            if (!DOUBLE_BUFFER || (i < args->n_tiles)) {
                snrt_mcycle();

                // Compute tile and buffer indices
                i_dma_in = i;
                buff_idx = DOUBLE_BUFFER ? i_dma_in % 2 : 0;

                // Calculate size and pointers to current tile
                offset = i_dma_in * frac;
                remote_x = args->x + offset;
                remote_y = args->y + offset;

                // Copy job operands in TCDM
                snrt_dma_start_1d(local_x[buff_idx], remote_x, size);
                snrt_dma_start_1d(local_y[buff_idx], remote_y, size);
                snrt_dma_wait_all();

                snrt_mcycle();
            }

            // Additional barriers required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();

            // DMA out
            if (!DOUBLE_BUFFER || (i > 1)) {
                snrt_mcycle();

                // Compute tile and buffer indices
                i_dma_out = DOUBLE_BUFFER ? i - 2 : i;
                buff_idx = DOUBLE_BUFFER ? i_dma_out % 2 : 0;

                // Calculate pointers to current tile
                offset = i_dma_out * frac;
                remote_z = args->z + offset;

                // Copy job outputs from TCDM
                snrt_dma_start_1d(remote_z, local_z[buff_idx], size);
                snrt_dma_wait_all();

                snrt_mcycle();
            }
        }

        // Compute
        if (snrt_is_compute_core()) {
            // Additional barrier required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();

            if (!DOUBLE_BUFFER || (i > 0 && i < (args->n_tiles + 1))) {
                snrt_mcycle();

                // Compute tile and buffer indices
                i_compute = DOUBLE_BUFFER ? i - 1 : i;
                buff_idx = DOUBLE_BUFFER ? i_compute % 2 : 0;

                // Perform tile computation
                axpy_fp_t fp = args->funcptr;
                fp(frac, args->a, local_x[buff_idx], local_y[buff_idx],
                   local_z[buff_idx]);

                snrt_mcycle();
            }

            // Additional barrier required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();
        }

        // Synchronize cores after every iteration
        snrt_cluster_hw_barrier();
    }
}
