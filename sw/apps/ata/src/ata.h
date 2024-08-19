// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "args.h"
#include "snrt.h"

#define DOUBLE_BUFFER 1

__thread int setup_ssr = 1;

void ata_naive(double alpha, uint32_t m, uint32_t n, double *a, double *at, double *b) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    for (uint32_t i = offset; i < m; i += stride) {
        for (uint32_t j = 0; j < m; j++) {
            b[i * m + j] = 0;
            for (uint32_t k = 0; k < n; k++) {
                b[i * m + j] += a[i * n + k] * at[j * n + k];
            }
            b[i * m + j] *= alpha;
        }
    }
}

void ata_baseline(double alpha, uint32_t m, uint32_t n, double *a, double *at, double *b) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    // Unrolling factors
    // Note: changes must be reflected in the inline assembly code
    //       and datagen script
    const uint32_t unroll1 = 4;
    const uint32_t unroll0 = 4;

    for (uint32_t i = offset; i < m; i += stride) {
        for (uint32_t j = 0; j < m; j += unroll1) {

            double acc[4];
            acc[0] = 0;
            acc[1] = 0;
            acc[2] = 0;
            acc[3] = 0;

            for (uint32_t k = 0; k < n; k += unroll0) {
                asm volatile(
                    "fmadd.d %[acc0], %[a0], %[at0], %[acc0] \n"
                    "fmadd.d %[acc1], %[a0], %[at1], %[acc1] \n"
                    "fmadd.d %[acc2], %[a0], %[at2], %[acc2] \n"
                    "fmadd.d %[acc3], %[a0], %[at3], %[acc3] \n"
                    "fmadd.d %[acc0], %[a1], %[at4], %[acc0] \n"
                    "fmadd.d %[acc1], %[a1], %[at5], %[acc1] \n"
                    "fmadd.d %[acc2], %[a1], %[at6], %[acc2] \n"
                    "fmadd.d %[acc3], %[a1], %[at7], %[acc3] \n"
                    "fmadd.d %[acc0], %[a2], %[at8], %[acc0] \n"
                    "fmadd.d %[acc1], %[a2], %[at9], %[acc1] \n"
                    "fmadd.d %[acc2], %[a2], %[at10], %[acc2] \n"
                    "fmadd.d %[acc3], %[a2], %[at11], %[acc3] \n"
                    "fmadd.d %[acc0], %[a3], %[at12], %[acc0] \n"
                    "fmadd.d %[acc1], %[a3], %[at13], %[acc1] \n"
                    "fmadd.d %[acc2], %[a3], %[at14], %[acc2] \n"
                    "fmadd.d %[acc3], %[a3], %[at15], %[acc3] \n"
                    : [ acc0 ] "+f"(acc[0]), [ acc1 ] "+f"(acc[1]),
                      [ acc2 ] "+f"(acc[2]), [ acc3 ] "+f"(acc[3])
                    : [ a0 ] "f"(a[i * n + k + 0]),
                      [ a1 ] "f"(a[i * n + k + 1]),
                      [ a2 ] "f"(a[i * n + k + 2]),
                      [ a3 ] "f"(a[i * n + k + 3]),
                      [ at0 ] "f"(at[(j + 0) * n + k]),
                      [ at1 ] "f"(at[(j + 1) * n + k]),
                      [ at2 ] "f"(at[(j + 2) * n + k]),
                      [ at3 ] "f"(at[(j + 3) * n + k]),
                      [ at4 ] "f"(at[(j + 0) * n + k + 1]),
                      [ at5 ] "f"(at[(j + 1) * n + k + 1]),
                      [ at6 ] "f"(at[(j + 2) * n + k + 1]),
                      [ at7 ] "f"(at[(j + 3) * n + k + 1]),
                      [ at8 ] "f"(at[(j + 0) * n + k + 2]),
                      [ at9 ] "f"(at[(j + 1) * n + k + 2]),
                      [ at10 ] "f"(at[(j + 2) * n + k + 2]),
                      [ at11 ] "f"(at[(j + 3) * n + k + 2]),
                      [ at12 ] "f"(at[(j + 0) * n + k + 3]),
                      [ at13 ] "f"(at[(j + 1) * n + k + 3]),
                      [ at14 ] "f"(at[(j + 2) * n + k + 3]),
                      [ at15 ] "f"(at[(j + 3) * n + k + 3])
                    :
                );
            }

            b[i * m + j + 0] = alpha * acc[0];
            b[i * m + j + 1] = alpha * acc[1];
            b[i * m + j + 2] = alpha * acc[2];
            b[i * m + j + 3] = alpha * acc[3];
        }
    }
}

void ata_opt(double alpha, uint32_t m, uint32_t n, double *a, double *at, double *b) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    // Unrolling factor of innermost loop
    // Note: changes must be reflected in the inline assembly code
    //       and datagen script
    const uint32_t unroll = 4;

    if (setup_ssr) {
        // Configure ft0 and ft1 to load A and At
        // for (i = offset; i < m; i += stride)
        //     for (j1 = 0; j1 < m; j1 += unroll)
        //         for (k = 0; k < n; k++)
        //             for (j0 = 0; j0 < unroll; j0++)
        //                 j = j1 + j0
        //                 ft0.push(a[i * n + k])
        //                 ft1.push(at[j * n + k])
        const uint32_t ssr0_b[4] = {unroll, n, m / unroll, m / stride};
        const uint32_t ssr0_i[4] = {0, sizeof(double), 0, stride * n * sizeof(double)};
        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_repeat(SNRT_SSR_DM0, unroll);
        const uint32_t ssr1_b[4] = {unroll, n, m / unroll, m / stride};
        const uint32_t ssr1_i[4] = {n * sizeof(double), sizeof(double), unroll * n * sizeof(double), 0};
        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2],
                         ssr1_i[3]);
        setup_ssr = 0;
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, a + offset * n);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, at);
    snrt_ssr_enable();

    for (uint32_t i = offset; i < m; i += stride) {
        for (uint32_t j = 0; j < m; j += unroll) {

            double acc[unroll];
            acc[0] = 0;
            acc[1] = 0;
            acc[2] = 0;
            acc[3] = 0;

            asm volatile(
                "frep.o %[n_frep], %[unroll], 0, 0 \n"
                "fmadd.d %[acc0], ft0, ft1, %[acc0] \n"
                "fmadd.d %[acc1], ft0, ft1, %[acc1] \n"
                "fmadd.d %[acc2], ft0, ft1, %[acc2] \n"
                "fmadd.d %[acc3], ft0, ft1, %[acc3] \n"
                "fmul.d %[b0], %[acc0], %[alpha] \n"
                "fmul.d %[b1], %[acc1], %[alpha] \n"
                "fmul.d %[b2], %[acc2], %[alpha] \n"
                "fmul.d %[b3], %[acc3], %[alpha] \n"
                : [ acc0 ] "+f"(acc[0]), [ acc1 ] "+f"(acc[1]),
                  [ acc2 ] "+f"(acc[2]), [ acc3 ] "+f"(acc[3]),
                  [ b0 ] "=f"(b[i * m + j + 0]), [ b1 ] "=f"(b[i * m + j + 1]),
                  [ b2 ] "=f"(b[i * m + j + 2]), [ b3 ] "=f"(b[i * m + j + 3])
                : [ n_frep ] "r"(n - 1), [ unroll ] "i"(unroll),
                  [ alpha ] "f"(alpha)
                : "ft0", "ft1", "ft2");
        }
    }

    snrt_ssr_disable();
    snrt_fpu_fence();
}

void ata_job(ata_args_t *args) {
    uint32_t m_frac, a_tile_size, a_tile_bytes, b_tile_size, b_tile_bytes;
    uint64_t local_a0_addr, local_at0_addr, local_b0_addr,
             local_a1_addr, local_at1_addr, local_b1_addr;
    double *local_a[2];
    double *local_at[2];
    double *local_b[2];
    uint32_t iterations, sb_iterations;
    uint32_t i, i_dma_in, i_compute, i_dma_out, i_row, i_col, buff_idx;

#ifndef JOB_ARGS_PRELOADED
    // Allocate space for job arguments in TCDM
    ata_args_t *local_args = (ata_args_t *)snrt_l1_next();

    // Copy job arguments to TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_args, args, sizeof(ata_args_t));
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();
    args = local_args;
#endif

    // Calculate size of each tile
    m_frac = args->m / args->m_tiles;
    a_tile_size = args->n * m_frac;
    b_tile_size = m_frac * m_frac;
    a_tile_bytes = a_tile_size * sizeof(double);
    b_tile_bytes = b_tile_size * sizeof(double);

    // Allocate space for job operands in TCDM
    // Align X with the 1st bank in TCDM, Y with the 8th and Z with the 16th.
    local_a0_addr = (uint64_t)args + sizeof(ata_args_t);
    local_at0_addr = local_a0_addr + a_tile_bytes;
    local_b0_addr = local_at0_addr + a_tile_bytes;
    local_a[0] = (double *)local_a0_addr;
    local_at[0] = (double *)local_at0_addr;
    local_b[0] = (double *)local_b0_addr;
    if (DOUBLE_BUFFER) {
        local_a1_addr = local_b0_addr + b_tile_bytes;
        local_at1_addr = local_a1_addr + a_tile_bytes;
        local_b1_addr = local_at1_addr + a_tile_bytes;
        local_a[1] = (double *)local_a1_addr;
        local_at[1] = (double *)local_at1_addr;
        local_b[1] = (double *)local_b1_addr;
    }

    // Calculate number of iterations
    sb_iterations = args->m_tiles * args->m_tiles;
    if (DOUBLE_BUFFER) iterations = sb_iterations + 2;
    else iterations = sb_iterations;

    // Iterate over all tiles
    for (i = 0; i < iterations; i++) {
        
        if (snrt_is_dm_core()) {
            // DMA in
            if (!DOUBLE_BUFFER || (i < sb_iterations)) {
                snrt_mcycle();

                // Compute tile and buffer indices
                i_dma_in = i;
                buff_idx = DOUBLE_BUFFER ? i_dma_in % 2 : 0;
                i_row = i_dma_in / args->m_tiles;
                i_col = i_dma_in % args->m_tiles;

                // Copy job operands in TCDM
                snrt_dma_load_1d_tile(
                    local_a[buff_idx],
                    args->a,
                    i_row,
                    a_tile_size,
                    sizeof(double));
                snrt_dma_load_1d_tile(
                    local_at[buff_idx],
                    args->a,
                    i_col,
                    a_tile_size,
                    sizeof(double));
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
                i_row = i_dma_out / args->m_tiles;
                i_col = i_dma_out % args->m_tiles;

                // Copy job outputs from TCDM
                snrt_dma_store_2d_tile(
                    args->b,
                    local_b[buff_idx],
                    i_row,
                    i_col,
                    m_frac,
                    m_frac,
                    args->m,
                    sizeof(double));
                snrt_dma_wait_all();

                snrt_mcycle();
            }
        }

        // Compute
        if (snrt_is_compute_core()) {
            // Additional barrier required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();

            if (!DOUBLE_BUFFER || (i > 0 && i < (sb_iterations + 1))) {
                snrt_mcycle();

                // Compute tile and buffer indices
                i_compute = DOUBLE_BUFFER ? i - 1 : i;
                buff_idx = DOUBLE_BUFFER ? i_compute % 2 : 0;

                // Perform tile computation
                ata_fp_t fp = args->funcptr;
                fp(args->alpha, m_frac, args->n, local_a[buff_idx],
                   local_at[buff_idx], local_b[buff_idx]);

                snrt_mcycle();
            }

            // Additional barrier required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();
        }
        // Synchronize cores after every iteration
        snrt_cluster_hw_barrier();
    }
}
