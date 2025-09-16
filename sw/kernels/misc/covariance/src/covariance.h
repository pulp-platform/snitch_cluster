// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "args.h"
#include "blas.h"
#include "snrt.h"

#define DOUBLE_BUFFER 1

void covariance_naive(uint32_t m, uint32_t n, double inv_n, double inv_n_m1,
                      double *data, double *datat, double *cov) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    // Center data
    for (uint32_t i = offset; i < m; i += stride) {
        // Calculate row mean
        double data_mean = 0.0;
        double datat_mean = 0.0;
        for (uint32_t j = 0; j < n; j++) {
            data_mean += data[i * n + j];
            datat_mean += datat[i * n + j];
        }
        data_mean = data_mean * inv_n;
        datat_mean = datat_mean * inv_n;

        // Center row around zero
        for (uint32_t j = 0; j < n; j++) {
            data[i * n + j] -= data_mean;
            datat[i * n + j] -= datat_mean;
        }
    }

    snrt_fpu_fence();
    snrt_cluster_hw_barrier();

    // Compute covariance matrix
    syrk_naive(m, n, inv_n_m1, data, datat, 0, cov);
}

void covariance_baseline(uint32_t m, uint32_t n, double inv_n, double inv_n_m1,
                         double *data, double *datat, double *cov) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    // Center data
    for (uint32_t i = offset; i < m; i += stride) {
        // Calculate row mean
        double data_mean = 0.0;
        double datat_mean = 0.0;
        for (uint32_t j = 0; j < n; j++) {
            data_mean += data[i * n + j];
            datat_mean += datat[i * n + j];
        }
        data_mean = data_mean * inv_n;
        datat_mean = datat_mean * inv_n;

        // Center row around zero
        for (uint32_t j = 0; j < n; j++) {
            data[i * n + j] -= data_mean;
            datat[i * n + j] -= datat_mean;
        }
    }

    snrt_fpu_fence();
    snrt_cluster_hw_barrier();

    // Compute covariance matrix
    syrk_baseline(m, n, inv_n_m1, data, datat, 0, cov);
}

void covariance_opt(uint32_t m, uint32_t n, double inv_n, double inv_n_m1,
                    double *data, double *datat, double *cov) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    // Unrolling factor of innermost loop
    // Note: changes must be reflected in the inline assembly code
    //       and datagen script
    const uint32_t unroll0 = 2;

    // Configure ft0 and ft1 to load data and datat elements
    // for (k = 0; k < 2; k++)
    //     for (i1 = offset; i1 < m; i1 += stride * unroll0)
    //         for (j = 0; j < n; j++)
    //             for (i0 = 0; i0 < unroll0; i0++)
    //                 i = i1 + i0 * stride
    //                 ft0.push(data[i * n + j])
    //                 ft1.push(datat[i * n + j])
    const uint32_t ssr01_b[4] = {unroll0, n, 2, m / (stride * unroll0)};
    const uint32_t ssr01_i[4] = {sizeof(double) * n * stride, sizeof(double), 0,
                                 sizeof(double) * n * stride * unroll0};
    snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr01_b[0], ssr01_b[1], ssr01_b[2],
                     ssr01_b[3], ssr01_i[0], ssr01_i[1], ssr01_i[2],
                     ssr01_i[3]);
    snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr01_b[0], ssr01_b[1], ssr01_b[2],
                     ssr01_b[3], ssr01_i[0], ssr01_i[1], ssr01_i[2],
                     ssr01_i[3]);
    snrt_ssr_repeat(SNRT_SSR_DM0, 1);
    // Configure ft2 to store data and datat elements
    // for (i1 = offset; i1 < m; i1 += stride * unroll0)
    //     for (j = 0; j < n; j++)
    //         for (i0 = 0; i0 < unroll0; i0++)
    //             i = i1 + i0 * stride
    //             data[i * n + j] = ft2.pop()
    //             datat[i * n + j] = ft2.pop()
    const uint32_t ssr2_b[4] = {2, unroll0, n, m / (stride * unroll0)};
    const uint32_t ssr2_i[4] = {(uint32_t)datat - (uint32_t)data,
                                sizeof(double) * n * stride, sizeof(double),
                                sizeof(double) * n * stride * unroll0};
    snrt_ssr_loop_4d(SNRT_SSR_DM2, ssr2_b[0], ssr2_b[1], ssr2_b[2], ssr2_b[3],
                     ssr2_i[0], ssr2_i[1], ssr2_i[2], ssr2_i[3]);

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, data + offset * n);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, datat + offset * n);
    snrt_ssr_write(SNRT_SSR_DM2, SNRT_SSR_4D, data + offset * n);
    snrt_ssr_enable();

    // Center data
    for (uint32_t i = offset; i < m; i += stride * unroll0) {
        // Calculate row means
        double m[2 * unroll0];
        m[0] = 0.0;  // mean(data[i])
        m[1] = 0.0;  // mean(datat[i])
        m[2] = 0.0;  // mean(data[i + stride])
        m[3] = 0.0;  // mean(datat[i + stride])
        asm volatile(
            "frep.o %[n_frep], %[n_insn], 0, 0 \n"
            "fadd.d %[m0], ft0, %[m0] \n"
            "fadd.d %[m1], ft1, %[m1] \n"
            "fadd.d %[m2], ft0, %[m2] \n"
            "fadd.d %[m3], ft1, %[m3] \n"
            : [ m0 ] "+f"(m[0]), [ m1 ] "+f"(m[1]), [ m2 ] "+f"(m[2]),
              [ m3 ] "+f"(m[3])
            : [ n_frep ] "r"(n - 1), [ n_insn ] "i"(2 * unroll0)
            : "ft0", "ft1", "ft2");
        m[0] *= inv_n;
        m[1] *= inv_n;
        m[2] *= inv_n;
        m[3] *= inv_n;

        snrt_fpu_fence();

        // Center row around zero
        asm volatile(
            "frep.o %[n_frep], %[n_insn], 0, 0 \n"
            "fsub.d ft2, ft0, %[m0] \n"
            "fsub.d ft2, ft1, %[m1] \n"
            "fsub.d ft2, ft0, %[m2] \n"
            "fsub.d ft2, ft1, %[m3] \n"
            : [ m0 ] "+f"(m[0]), [ m1 ] "+f"(m[1]), [ m2 ] "+f"(m[2]),
              [ m3 ] "+f"(m[3])
            : [ n_frep ] "r"(n - 1), [ n_insn ] "i"(2 * unroll0)
            : "ft0", "ft1", "ft2");
    }

    snrt_ssr_disable();

    snrt_fpu_fence();
    snrt_cluster_hw_barrier();

    // The following is taken from the AtA kernel, where alpha is set to
    // the factor 1/(n - 1).
    // Here data stands for A and datat for At.

    // Unrolling factor of innermost loop
    // Note: changes must be reflected in the inline assembly code
    //       and datagen script
    const uint32_t unroll1 = 4;

    // Configure ft0 and ft1 to load A and At
    // for (i = offset; i < m; i += stride)
    //     for (j1 = 0; j1 < m; j1 += unroll1)
    //         for (k = 0; k < n; k++)
    //             for (j0 = 0; j0 < unroll1; j0++)
    //                 j = j1 + j0
    //                 ft0.push(a[i * n + k])
    //                 ft1.push(at[j * n + k])
    const uint32_t ssr0_b[4] = {unroll1, n, m / unroll1, m / stride};
    const uint32_t ssr0_i[4] = {0, sizeof(double), 0,
                                stride * n * sizeof(double)};
    snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3], ssr0_i[1],
                     ssr0_i[2], ssr0_i[3]);
    snrt_ssr_repeat(SNRT_SSR_DM0, unroll1);
    const uint32_t ssr1_b[4] = {unroll1, n, m / unroll1, m / stride};
    const uint32_t ssr1_i[4] = {n * sizeof(double), sizeof(double),
                                unroll1 * n * sizeof(double), 0};
    snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2], ssr1_b[3],
                     ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_3D, data + offset * n);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, datat);
    snrt_ssr_enable();

    for (uint32_t i = offset; i < m; i += stride) {
        for (uint32_t j = 0; j < m; j += unroll1) {
            double acc[unroll1];
            acc[0] = 0;
            acc[1] = 0;
            acc[2] = 0;
            acc[3] = 0;

            asm volatile(
                "frep.o %[n_frep], %[unroll1], 0, 0 \n"
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
                  [ b0 ] "=f"(cov[i * m + j + 0]),
                  [ b1 ] "=f"(cov[i * m + j + 1]),
                  [ b2 ] "=f"(cov[i * m + j + 2]),
                  [ b3 ] "=f"(cov[i * m + j + 3])
                : [ n_frep ] "r"(n - 1), [ unroll1 ] "i"(unroll1),
                  [ alpha ] "f"(inv_n_m1)
                : "ft0", "ft1", "ft2");
        }
    }

    snrt_ssr_disable();
    snrt_fpu_fence();
}

void covariance_job(covariance_args_t *args) {
    uint32_t m_frac, a_tile_size, a_tile_bytes, b_tile_size, b_tile_bytes;
    uint64_t local_a0_addr, local_at0_addr, local_b0_addr, local_a1_addr,
        local_at1_addr, local_b1_addr;
    double *local_a[2];
    double *local_at[2];
    double *local_b[2];
    uint32_t iterations, sb_iterations;
    uint32_t i, i_dma_in, i_compute, i_dma_out, i_row, i_col, buff_idx;

#ifndef JOB_ARGS_PRELOADED
    // Allocate space for job arguments in TCDM
    covariance_args_t *local_args =
        (covariance_args_t *)snrt_l1_alloc_cluster_local(
            sizeof(covariance_args_t), sizeof(double));

    // Copy job arguments to TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_args, args, sizeof(covariance_args_t));
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
    local_a[0] =
        (double *)snrt_l1_alloc_cluster_local(a_tile_bytes, sizeof(double));
    local_at[0] =
        (double *)snrt_l1_alloc_cluster_local(a_tile_bytes, sizeof(double));
    local_b[0] =
        (double *)snrt_l1_alloc_cluster_local(b_tile_bytes, sizeof(double));
    if (DOUBLE_BUFFER) {
        local_a[1] =
            (double *)snrt_l1_alloc_cluster_local(a_tile_bytes, sizeof(double));
        local_at[1] =
            (double *)snrt_l1_alloc_cluster_local(a_tile_bytes, sizeof(double));
        local_b[1] =
            (double *)snrt_l1_alloc_cluster_local(b_tile_bytes, sizeof(double));
    }

    // Calculate number of iterations
    sb_iterations = args->m_tiles * args->m_tiles;
    if (DOUBLE_BUFFER)
        iterations = sb_iterations + 2;
    else
        iterations = sb_iterations;

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
                snrt_dma_load_1d_tile(local_a[buff_idx], args->data, i_row,
                                      a_tile_size, sizeof(double));
                snrt_dma_load_1d_tile(local_at[buff_idx], args->data, i_col,
                                      a_tile_size, sizeof(double));
                snrt_dma_wait_all();

                snrt_mcycle();
            }

            // Additional barriers required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();

            // Additional barrier required to synchronize the compute cores
            // among them after the data centering phase
            if (!DOUBLE_BUFFER || (i > 0 && i < (sb_iterations + 1)))
                snrt_cluster_hw_barrier();

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
                snrt_dma_store_2d_tile(args->cov, local_b[buff_idx], i_row,
                                       i_col, m_frac, m_frac, args->m,
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
                covariance_fp_t fp = args->funcptr;
                fp(m_frac, args->n, args->inv_n, args->inv_n_m1,
                   local_a[buff_idx], local_at[buff_idx], local_b[buff_idx]);

                snrt_mcycle();
            }

            // Additional barrier required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();
        }
        // Synchronize cores after every iteration
        snrt_cluster_hw_barrier();
    }

    // Free memory
#ifndef JOB_ARGS_PRELOADED
    snrt_l1_update_next_v2(args);
#else
    snrt_l1_update_next_v2(local_a[0]);
#endif
}
