// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "args.h"
#include "snrt.h"

#define DOUBLE_BUFFER 1

__thread int setup_ssr = 1;

void doitgen_naive(uint32_t r, uint32_t q, uint32_t s, double *A, double *x,
                   double *Aout) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    for (uint32_t i = offset; i < r; i += stride) {
        for (uint32_t j = 0; j < q; j++) {
            for (uint32_t k = 0; k < s; k++) {
                Aout[i * q * s + j * s + k] = 0.0;
                for (uint32_t l = 0; l < s; l++) {
                    Aout[i * q * s + j * s + k] +=
                        A[i * q * s + j * s + l] * x[k * s + l];
                }
            }
        }
    }

    snrt_fpu_fence();
}

void doitgen_baseline(uint32_t r, uint32_t q, uint32_t s, double *A, double *x,
                      double *Aout) {
    uint32_t offset = snrt_cluster_core_idx();
    uint32_t stride = snrt_cluster_compute_core_num();

    // Unrolling factors
    // Note: changes must be reflected in the inline assembly code
    //       and datagen script
    const uint32_t unroll1 = 4;
    const uint32_t unroll0 = 4;

    for (uint32_t i = offset; i < r; i += stride) {
        for (uint32_t j = 0; j < q; j++) {
            for (uint32_t k = 0; k < s; k += unroll1) {
                double acc[4];
                acc[0] = 0;
                acc[1] = 0;
                acc[2] = 0;
                acc[3] = 0;

                for (uint32_t l = 0; l < s; l += unroll0) {
                    asm volatile(
                        "fmadd.d %[acc0], %[a0], %[x0], %[acc0] \n"
                        "fmadd.d %[acc1], %[a0], %[x1], %[acc1] \n"
                        "fmadd.d %[acc2], %[a0], %[x2], %[acc2] \n"
                        "fmadd.d %[acc3], %[a0], %[x3], %[acc3] \n"
                        "fmadd.d %[acc0], %[a1], %[x4], %[acc0] \n"
                        "fmadd.d %[acc1], %[a1], %[x5], %[acc1] \n"
                        "fmadd.d %[acc2], %[a1], %[x6], %[acc2] \n"
                        "fmadd.d %[acc3], %[a1], %[x7], %[acc3] \n"
                        "fmadd.d %[acc0], %[a2], %[x8], %[acc0] \n"
                        "fmadd.d %[acc1], %[a2], %[x9], %[acc1] \n"
                        "fmadd.d %[acc2], %[a2], %[x10], %[acc2] \n"
                        "fmadd.d %[acc3], %[a2], %[x11], %[acc3] \n"
                        "fmadd.d %[acc0], %[a3], %[x12], %[acc0] \n"
                        "fmadd.d %[acc1], %[a3], %[x13], %[acc1] \n"
                        "fmadd.d %[acc2], %[a3], %[x14], %[acc2] \n"
                        "fmadd.d %[acc3], %[a3], %[x15], %[acc3] \n"
                        : [ acc0 ] "+f"(acc[0]), [ acc1 ] "+f"(acc[1]),
                          [ acc2 ] "+f"(acc[2]), [ acc3 ] "+f"(acc[3])
                        : [ a0 ] "f"(A[i * q * s + j * s + l + 0]),
                          [ a1 ] "f"(A[i * q * s + j * s + l + 1]),
                          [ a2 ] "f"(A[i * q * s + j * s + l + 2]),
                          [ a3 ] "f"(A[i * q * s + j * s + l + 3]),
                          [ x0 ] "f"(x[(k + 0) * s + l + 0]),
                          [ x1 ] "f"(x[(k + 1) * s + l + 0]),
                          [ x2 ] "f"(x[(k + 2) * s + l + 0]),
                          [ x3 ] "f"(x[(k + 3) * s + l + 0]),
                          [ x4 ] "f"(x[(k + 0) * s + l + 1]),
                          [ x5 ] "f"(x[(k + 1) * s + l + 1]),
                          [ x6 ] "f"(x[(k + 2) * s + l + 1]),
                          [ x7 ] "f"(x[(k + 3) * s + l + 1]),
                          [ x8 ] "f"(x[(k + 0) * s + l + 2]),
                          [ x9 ] "f"(x[(k + 1) * s + l + 2]),
                          [ x10 ] "f"(x[(k + 2) * s + l + 2]),
                          [ x11 ] "f"(x[(k + 3) * s + l + 2]),
                          [ x12 ] "f"(x[(k + 0) * s + l + 3]),
                          [ x13 ] "f"(x[(k + 1) * s + l + 3]),
                          [ x14 ] "f"(x[(k + 2) * s + l + 3]),
                          [ x15 ] "f"(x[(k + 3) * s + l + 3])
                        :);
                }

                Aout[i * q * s + j * s + k + 0] = acc[0];
                Aout[i * q * s + j * s + k + 1] = acc[1];
                Aout[i * q * s + j * s + k + 2] = acc[2];
                Aout[i * q * s + j * s + k + 3] = acc[3];
            }
        }
    }

    snrt_fpu_fence();
}

void doitgen_opt(uint32_t r, uint32_t q, uint32_t s, double *A, double *x,
                 double *Aout) {
    uint32_t bound = r / snrt_cluster_compute_core_num();
    uint32_t offset = bound * snrt_cluster_core_idx();

    // Unrolling factor of innermost loop
    // Note: changes must be reflected in the inline assembly code
    //       and datagen script
    const uint32_t unroll = 4;

    if (setup_ssr) {
        // Configure ft0 and ft1 to load A and x
        // for (i = offset; i < bound; i++)
        //     for (j = 0; j < q; j++)
        //         for (k1 = 0; k1 < s; k1 += unroll)
        //             for (l = 0; l < s; l++)
        //                 for (k0 = 0; k0 < unroll; k0++)
        //                     k = k1 + k0
        //                     ft0.push(A[i * q * s + j * s + l])
        //                     ft1.push(x[k * s + l])
        const uint32_t ssr0_b[4] = {unroll, s, s / unroll, q * bound};
        const uint32_t ssr0_i[4] = {0, sizeof(double), 0, s * sizeof(double)};
        snrt_ssr_loop_3d(SNRT_SSR_DM0, ssr0_b[1], ssr0_b[2], ssr0_b[3],
                         ssr0_i[1], ssr0_i[2], ssr0_i[3]);
        snrt_ssr_repeat(SNRT_SSR_DM0, unroll);
        const uint32_t ssr1_b[4] = {unroll, s, s / unroll, q * bound};
        const uint32_t ssr1_i[4] = {s * sizeof(double), sizeof(double),
                                    unroll * s * sizeof(double), 0};
        snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                         ssr1_b[3], ssr1_i[0], ssr1_i[1], ssr1_i[2], ssr1_i[3]);
        setup_ssr = 0;
    }

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, A + offset * q * s);
    snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_4D, x);
    snrt_ssr_enable();

    for (uint32_t i = offset; i < (offset + bound); i++) {
        for (uint32_t j = 0; j < q; j++) {
            for (uint32_t k = 0; k < s; k += unroll) {
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
                    : [ acc0 ] "+f"(acc[0]), [ acc1 ] "+f"(acc[1]),
                      [ acc2 ] "+f"(acc[2]), [ acc3 ] "+f"(acc[3])
                    : [ n_frep ] "r"(s - 1), [ unroll ] "i"(unroll)
                    : "ft0", "ft1", "ft2");

                Aout[i * q * s + j * s + k + 0] = acc[0];
                Aout[i * q * s + j * s + k + 1] = acc[1];
                Aout[i * q * s + j * s + k + 2] = acc[2];
                Aout[i * q * s + j * s + k + 3] = acc[3];
            }
        }
    }

    snrt_ssr_disable();
    snrt_fpu_fence();
}

void doitgen_job(doitgen_args_t *args) {
    uint32_t r_frac, q_frac, a_tile_size, a_tile_bytes, x_size, x_bytes;
    uint64_t local_a0_addr, local_aout0_addr, local_x0_addr, local_a1_addr,
        local_aout1_addr;
    double *local_a[2];
    double *local_aout[2];
    double *local_x;
    uint32_t iterations, sb_iterations;
    uint32_t i, i_dma_in, i_compute, i_dma_out, i_r, i_q, buff_idx;

#ifndef JOB_ARGS_PRELOADED
    // Allocate space for job arguments in TCDM
    doitgen_args_t *local_args = (doitgen_args_t *)snrt_l1_next();

    // Copy job arguments to TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_args, args, sizeof(doitgen_args_t));
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();
    args = local_args;
#endif

    // Calculate size of each tile
    r_frac = args->r / args->r_tiles;
    q_frac = args->q / args->q_tiles;
    a_tile_size = r_frac * q_frac * args->s;
    x_size = args->s * args->s;
    a_tile_bytes = a_tile_size * sizeof(double);
    x_bytes = x_size * sizeof(double);

    // Allocate space for job operands in TCDM
    local_x0_addr = (uint64_t)args + sizeof(doitgen_args_t);
    local_a0_addr = local_x0_addr + x_bytes;
    local_aout0_addr = local_a0_addr + a_tile_bytes;
    local_x = (double *)local_x0_addr;
    local_a[0] = (double *)local_a0_addr;
    local_aout[0] = (double *)local_aout0_addr;
    if (DOUBLE_BUFFER) {
        local_a1_addr = local_aout0_addr + a_tile_bytes;
        local_aout1_addr = local_a1_addr + a_tile_bytes;
        local_a[1] = (double *)local_a1_addr;
        local_aout[1] = (double *)local_aout1_addr;
    }

    // Calculate number of iterations
    sb_iterations = args->r_tiles * args->q_tiles;
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
                i_r = i_dma_in / args->q_tiles;
                i_q = i_dma_in % args->q_tiles;

                // Copy job operands in TCDM
                snrt_dma_load_2d_tile(local_a[buff_idx], args->A, i_r, i_q,
                                      r_frac, q_frac * args->s,
                                      args->q * args->s, sizeof(double));
                if (i_dma_in == 0) snrt_dma_start_1d(local_x, args->x, x_bytes);
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
                i_r = i_dma_out / args->q_tiles;
                i_q = i_dma_out % args->q_tiles;

                // Copy job outputs from TCDM
                snrt_dma_store_2d_tile(args->A, local_aout[buff_idx], i_r, i_q,
                                       r_frac, q_frac * args->s,
                                       args->q * args->s, sizeof(double));
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
                doitgen_fp_t fp = args->funcptr;
                fp(r_frac, q_frac, args->s, local_a[buff_idx], local_x,
                   local_aout[buff_idx]);

                snrt_mcycle();
            }

            // Additional barrier required when not double buffering
            if (!DOUBLE_BUFFER) snrt_cluster_hw_barrier();
        }
        // Synchronize cores after every iteration
        snrt_cluster_hw_barrier();
    }
}
