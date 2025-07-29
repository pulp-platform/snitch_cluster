// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

#include <stdalign.h>
#include <stdint.h>

#include "snrt.h"

#pragma once

#include "gemm_types.h"

#include "gemm_fp16.h"
#include "gemm_fp32.h"
#include "gemm_fp64.h"
#include "gemm_fp8.h"

/**
 * @brief Executes one GEMM tile on one Snitch cluster (single-cluster,
 *        single-tile GEMM).
 *
 * @param args Pointer to a `sn_sc_gemm_args_t` structure containing arguments
 *             for the GEMM operation.
 *
 * @details
 * The function performs the following steps:
 * 1. Parallelizes the computation by distributing distinct rows of the C
 *    matrix to distinct compute cores in the cluster. Each core works not on a
 *    contiguous set of rows, but on a strided set of rows (stride equal to the
 *    number of compute cores).
 * 2. Each compute core invokes an underlying GEMM kernel function, to compute
 *    the assigned subproblem.
 */
void sc_st_gemm(gemm_fp_t kernel, sc_st_gemm_args_t *args) {
    if (snrt_is_compute_core()) {
        const uint32_t core_num = snrt_cluster_compute_core_num();
        const uint32_t core_idx = snrt_cluster_core_idx();

        // Compute cores work not on contiguous blocks but on strided rows
        uint32_t lda = core_num * args->lda;
        uint32_t ldc = core_num * args->ldc;

        // Compute cores access A and C at offsets of one row from each other
        uint32_t offset_a = core_idx * args->lda * args->prec;
        uint32_t offset_c = core_idx * args->ldc * args->prec;
        void *a = (void *)((uintptr_t)(args->a) + offset_a);
        void *c = (void *)((uintptr_t)(args->c) + offset_c);

        // Compute fraction of C rows every core computes
        uint32_t frac_m = args->m / core_num;
        uint32_t rem_m = args->m % core_num;
        if (snrt_cluster_core_idx() < rem_m) frac_m++;

        // Invoke kernel for each core
        if (frac_m > 0) {
            kernel(args->setup_ssr, args->partition_banks, args->transa,
                   args->transb, frac_m, args->n, args->k, a, lda, args->b,
                   args->ldb, args->beta, c, ldc);
            snrt_fpu_fence();
        }
    }
}

// With the partitioned banks layout, the stride between rows of a matrix
// equals the number of TCDM lines needed to store a row of the matrix. This
// function calculates such stride.
// `size` is in bytes
static inline uint32_t calculate_partitioned_banks_lines(
    uint32_t banks_per_buffer, uint32_t size) {
    return size / (banks_per_buffer * SNRT_TCDM_BANK_WIDTH);
}

// Allocate space for local tile buffers in TCDM, unless preloaded
static inline void allocate_buffers(uint32_t size_a, uint32_t size_b,
                                    uint32_t size_c, const gemm_args_t *largs,
                                    uint32_t banks_per_buffer, void **la,
                                    void **lb, void **lc, void **lcr) {
    uintptr_t a_addr[2], b_addr[2], c_addr[2];

    // Calculate base address of each buffer
    a_addr[0] = snrt_align_up_hyperbank((uintptr_t)snrt_l1_next_v2());
    if (largs->partition_banks) {
        // Each buffer is allocated in distinct TCDM banks. Particularly,
        // each buffer is assigned as many banks as there are compute cores.
        // Note: this assumes there are more than (banks_per_buffer * 3) banks.
        b_addr[0] = a_addr[0] + SNRT_TCDM_BANK_WIDTH * banks_per_buffer;
        c_addr[0] = b_addr[0] + SNRT_TCDM_BANK_WIDTH * banks_per_buffer;

        // If there are two hyperbanks, we allocate the second set of buffers
        // in the second hyperbank, at the same offsets of the first set in
        // in the first hyperbank.
        if (SNRT_TCDM_HYPERBANK_NUM == 2) {
            a_addr[1] = a_addr[0] + SNRT_TCDM_HYPERBANK_SIZE;
            b_addr[1] = b_addr[0] + SNRT_TCDM_HYPERBANK_SIZE;
            c_addr[1] = c_addr[0] + SNRT_TCDM_HYPERBANK_SIZE;
        }
        // If there is only one hyperbank, but we have enough banks to store the
        // second set of buffers also in distinct banks, then each buffer is
        // allocated in distinct banks.
        else if (SNRT_TCDM_BANK_NUM >= (banks_per_buffer * 6)) {
            a_addr[1] = c_addr[0] + SNRT_TCDM_BANK_WIDTH * banks_per_buffer;
            b_addr[1] = a_addr[1] + SNRT_TCDM_BANK_WIDTH * banks_per_buffer;
            c_addr[1] = b_addr[1] + SNRT_TCDM_BANK_WIDTH * banks_per_buffer;
        }
        // In all other cases, each buffer in the second set is allocated in the
        // same banks as the respective buffer in the first set.
        else {
            a_addr[1] = a_addr[0] + (SNRT_TCDM_HYPERBANK_WIDTH *
                                     calculate_partitioned_banks_lines(
                                         banks_per_buffer, size_a));
            b_addr[1] = b_addr[0] + (SNRT_TCDM_HYPERBANK_WIDTH *
                                     calculate_partitioned_banks_lines(
                                         banks_per_buffer, size_b));
            c_addr[1] = c_addr[0] + (SNRT_TCDM_HYPERBANK_WIDTH *
                                     calculate_partitioned_banks_lines(
                                         banks_per_buffer, size_c));
        }
    } else {
        b_addr[0] = snrt_align_up(a_addr[0] + size_a, sizeof(double));
        c_addr[0] = snrt_align_up(b_addr[0] + size_b, sizeof(double));
        a_addr[1] = snrt_align_up(c_addr[0] + size_c, sizeof(double));
        b_addr[1] = snrt_align_up(a_addr[1] + size_a, sizeof(double));
        c_addr[1] = snrt_align_up(b_addr[1] + size_b, sizeof(double));
    }

    // Allocate
    if (largs->load_a) {
        la[0] = (void *)a_addr[0];
        if (largs->double_buffer) la[1] = (void *)a_addr[1];
    } else
        la[0] = largs->a;
    if (largs->load_b) {
        lb[0] = (void *)b_addr[0];
        if (largs->double_buffer) lb[1] = (void *)b_addr[1];
    } else
        lb[0] = largs->b;
    if (largs->load_c) {
        lc[0] = (void *)c_addr[0];
        if (largs->double_buffer) lc[1] = (void *)c_addr[1];
    } else
        lc[0] = largs->c;
    // Note: uses the second C buffer for the reduction phase. Double buffering
    // is not supported when parallelizing K.
    if (largs->parallelize_k) *lcr = (void *)c_addr[1];
}

// With the partitioned banks layout, the stride between rows of a matrix
// equals the number of TCDM lines needed to store a row of the matrix. This
// function calculates such stride.
static inline uint32_t calculate_partitioned_banks_stride(
    uint32_t banks_per_buffer, uint32_t row_size, uint32_t prec) {
    uint32_t elems_per_line = (banks_per_buffer * SNRT_TCDM_BANK_WIDTH) / prec;
    uint32_t lines_per_row = row_size / elems_per_line;
    return (lines_per_row * SNRT_TCDM_HYPERBANK_WIDTH) / prec;
}

/**
 * @brief Performs a General Matrix Multiplication (GEMM) operation on a
 *        Snitch-based multiple-cluster architecture with support for
 *        parallelization, tiling, and data movement optimizations.
 *
 * @param args Pointer to a `gemm_args_t` structure containing arguments
 *             for the GEMM operation.
 *
 * @details
 * The function performs the following steps:
 * 1. Copies the input arguments to local memory for faster access.
 * 2. Calculates tile sizes based on the input dimensions and number of tiles.
 * 3. Allocates space in TCDM for local copies of matrix tiles, unless
 *    matrix tiles are already stored in TCDM (see `load_* arguments`).
 * 4. Distributes tiles to clusters for parallel processing.
 * 5. Each cluster iterates over the assigned tiles, performing the following:
 *    - Copies data for the current tile into local memory.
 *    - Performs the tile computation using the `sc_st_gemm` function.
 *    - Performs a logarithmic reduction to combine partial results across
 *      clusters, if `parallelize_k` is enabled.
 *    - Writes the result back to global memory.
 *
 * @note Current implementation assumes that `parallelize_m` and
 *       `parallelize_k` options are mutually exclusive.
 */
static inline int gemm(const gemm_args_t *args) {
#ifndef JOB_ARGS_PRELOADED
    // Copy the arguments to local memory
    gemm_args_t *largs = (gemm_args_t *)snrt_l1_alloc_cluster_local(
        sizeof(gemm_args_t), alignof(gemm_args_t));
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d((void *)largs, (void *)args, sizeof(gemm_args_t));
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();
#else
    const gemm_args_t *largs = args;
#endif

    // Calculate tile sizes
    uint32_t tile_m = largs->m / largs->m_tiles;
    uint32_t tile_n = largs->n / largs->n_tiles;
    uint32_t tile_k = largs->k / largs->k_tiles;
    uint32_t tile_a_size = tile_m * tile_k * largs->prec;
    uint32_t tile_b_size = tile_k * tile_n * largs->prec;
    uint32_t tile_c_size = tile_m * tile_n * largs->prec;

    // Allocate space for local tile buffers in TCDM, unless preloaded
    void *a0, *a1, *b0, *b1, *c0, *c1;
    void *la[2], *lb[2], *lc[2], *lcr;
    int banks_per_buffer = snrt_cluster_compute_core_num();
    allocate_buffers(tile_a_size, tile_b_size, tile_c_size, largs,
                     banks_per_buffer, la, lb, lc, &lcr);
    if (snrt_cluster_core_idx() == 0) {
        DUMP(la[0]);
        DUMP(la[1]);
        DUMP(lb[0]);
        DUMP(lb[1]);
        DUMP(lc[0]);
        DUMP(lc[1]);
    }
    snrt_cluster_hw_barrier();

    // Distribute m and k tiles to clusters
    uint32_t cluster_m_tiles = largs->m_tiles;
    uint32_t cluster_k_tiles = largs->k_tiles;
    uint32_t num_working_clusters = snrt_cluster_num();
    if (largs->parallelize_m) cluster_m_tiles /= snrt_cluster_num();
    if (largs->parallelize_k) {
        uint32_t k_tiles_quotient = cluster_k_tiles / snrt_cluster_num();
        uint32_t k_tiles_remainder = cluster_k_tiles % snrt_cluster_num();
        cluster_k_tiles = k_tiles_quotient;
        if (snrt_cluster_idx() < k_tiles_remainder) cluster_k_tiles++;
        if (k_tiles_quotient == 0) num_working_clusters = k_tiles_remainder;
    }
    snrt_comm_t comm;
    snrt_comm_create(num_working_clusters, &comm);

    // Calculate number of iterations
    uint32_t num_tiles = cluster_m_tiles * largs->n_tiles * cluster_k_tiles;
    uint32_t num_iters = num_tiles;
    if (largs->double_buffer)
        num_iters += 2;
    else
        num_iters += 1;

    // Iterate over all tiles
    for (uint32_t i = 0; i < num_iters; i++) {
        // Calculate tile indices (we iterate in k->n->m order)
        int dma_in_i = i;
        int comp_i = largs->double_buffer ? i - 1 : i;
        int dma_out_i = largs->double_buffer ? i - 2 : i - 1;
        int dma_in_k = dma_in_i % cluster_k_tiles;
        int dma_in_mn = dma_in_i / cluster_k_tiles;
        int dma_in_n = dma_in_mn % largs->n_tiles;
        int dma_in_m = dma_in_mn / largs->n_tiles;
        int comp_k = comp_i % cluster_k_tiles;
        int comp_mn = comp_i / cluster_k_tiles;
        int comp_n = comp_mn % largs->n_tiles;
        int comp_m = comp_mn / largs->n_tiles;
        int dma_out_k = dma_out_i % cluster_k_tiles;
        int dma_out_mn = dma_out_i / cluster_k_tiles;
        int dma_out_n = dma_out_mn % largs->n_tiles;
        int dma_out_m = dma_out_mn / largs->n_tiles;

        // If m and k tiles are parallelized across clusters,
        // calculate the absolute m and k indices for each cluster
        int dma_in_m_abs = dma_in_m;
        int comp_m_abs = comp_m;
        int dma_out_m_abs = dma_out_m;
        int dma_in_k_abs = dma_in_k;
        int comp_k_abs = comp_k;
        int dma_out_k_abs = dma_out_k;
        if (largs->parallelize_m) {
            dma_in_m_abs += snrt_cluster_idx() * cluster_m_tiles;
            comp_m_abs += snrt_cluster_idx() * cluster_m_tiles;
            dma_out_m_abs += snrt_cluster_idx() * cluster_m_tiles;
        }
        if (largs->parallelize_k) {
            dma_in_k_abs += snrt_cluster_idx() * cluster_k_tiles;
            comp_k_abs += snrt_cluster_idx() * cluster_k_tiles;
            dma_out_k_abs += snrt_cluster_idx() * cluster_k_tiles;
        }

        // DMA out phase
        if (snrt_is_dm_core()) {
            if (dma_out_i >= 0) {
                // Switch buffers
                int buff_idx = largs->double_buffer ? dma_out_mn % 2 : 0;

                // Store C
                // If parallelize_k, then only cluster 0 must writeback
                if ((snrt_cluster_idx() == 0) || !(largs->parallelize_k)) {
                    if (largs->partition_banks) {
                        snrt_dma_2d_to_1d(
                            (void *)((uintptr_t)largs->c +
                                     dma_out_m_abs * tile_c_size),
                            lc[buff_idx], tile_c_size,
                            banks_per_buffer * SNRT_TCDM_BANK_WIDTH,
                            SNRT_TCDM_HYPERBANK_WIDTH);
                    } else {
                        snrt_dma_store_2d_tile(largs->c, lc[buff_idx],
                                               dma_out_m_abs, dma_out_n, tile_m,
                                               tile_n, largs->ldc, largs->prec);
                    }
                    snrt_dma_wait_all();
                }
            }
        }

        // DMA in phase
        if (snrt_is_dm_core()) {
            if (dma_in_i < num_tiles) {
                // Switch buffers
                // A and B buffers are switched every iteration, while the C
                // buffer only needs to be switched after fully accumulating
                // the result, i.e. after finishing the K loop.
                int buff_idx = largs->double_buffer ? dma_in_i % 2 : 0;
                int c_buff_idx = largs->double_buffer ? dma_in_mn % 2 : 0;

                // Load A
                if (largs->load_a) {
                    if (largs->partition_banks) {
                        snrt_dma_1d_to_2d(
                            la[buff_idx],
                            (void *)((uintptr_t)largs->a +
                                     dma_in_m_abs * tile_a_size),
                            tile_a_size,
                            banks_per_buffer * SNRT_TCDM_BANK_WIDTH,
                            SNRT_TCDM_HYPERBANK_WIDTH);
                    } else {
                        snrt_dma_load_2d_tile(
                            la[buff_idx], largs->a, dma_in_m_abs, dma_in_k_abs,
                            tile_m, tile_k, largs->lda, largs->prec);
                    }
                }

                // Load B
                if (largs->load_b) {
                    if (largs->transb) {
                        snrt_dma_load_2d_tile(lb[buff_idx], largs->b, dma_in_n,
                                              dma_in_k_abs, tile_n, tile_k,
                                              largs->ldb, largs->prec);
                    } else {
                        if (largs->partition_banks) {
                            snrt_dma_1d_to_2d(
                                lb[buff_idx],
                                (void *)((uintptr_t)largs->b +
                                         dma_in_k_abs * tile_b_size),
                                tile_b_size,
                                banks_per_buffer * SNRT_TCDM_BANK_WIDTH,
                                SNRT_TCDM_HYPERBANK_WIDTH);
                        } else {
                            snrt_dma_load_2d_tile(
                                lb[buff_idx], largs->b, dma_in_k_abs, dma_in_n,
                                tile_k, tile_n, largs->ldb, largs->prec);
                        }
                    }
                }

                // Load C
                // C tile is loaded only upon the first k iteration, then
                // the C array will contain the partial results from the
                // previous iteration
                if (largs->load_c) {
                    if (dma_in_k_abs == 0) {
                        if (largs->partition_banks) {
                            snrt_dma_1d_to_2d(
                                lc[c_buff_idx],
                                (void *)((uintptr_t)largs->c +
                                         dma_in_m_abs * tile_c_size),
                                tile_c_size,
                                banks_per_buffer * SNRT_TCDM_BANK_WIDTH,
                                SNRT_TCDM_HYPERBANK_WIDTH);
                        } else {
                            snrt_dma_load_2d_tile(lc[c_buff_idx], largs->c,
                                                  dma_in_m_abs, dma_in_n,
                                                  tile_m, tile_n, largs->ldc,
                                                  largs->prec);
                        }
                    } else if (dma_in_k == 0) {
                        // Clusters other than the first need to initialize
                        // the C array to zero in their first iteration
                        if (largs->partition_banks) {
                            snrt_dma_1d_to_2d(
                                lc[c_buff_idx], snrt_cluster()->zeromem.mem,
                                tile_c_size,
                                banks_per_buffer * SNRT_TCDM_BANK_WIDTH,
                                SNRT_TCDM_HYPERBANK_WIDTH);
                        } else {
                            snrt_dma_start_1d(lc[c_buff_idx],
                                              snrt_cluster()->zeromem.mem,
                                              tile_c_size);
                        }
                    }
                }
                snrt_dma_wait_all();
            }
        }

        // Additional barrier required when not double buffering
        if (!largs->double_buffer) snrt_cluster_hw_barrier();

        // Compute phase
        if (comp_i >= 0 && comp_i < num_tiles) {
            // Switch buffers
            int buff_idx = largs->double_buffer ? comp_i % 2 : 0;
            int c_buff_idx = largs->double_buffer ? comp_mn % 2 : 0;

            // Only compute cores participate in the tile computation
            if (!snrt_is_dm_core()) {
                // uint32_t start_cycle = snrt_mcycle();

                // In the first k iteration we accumulate with the C matrix
                // scaled by beta, in successive iterations we accumulate
                // the previous partial result. The tile-level beta is thus
                // a function of k: beta(k).
                uint32_t beta_k = comp_k_abs == 0 ? largs->beta : 1;

                // Tile computation
                sc_st_gemm_args_t sc_st_args;
                sc_st_args.prec = largs->prec;
                sc_st_args.setup_ssr = largs->setup_ssr;
                sc_st_args.partition_banks = largs->partition_banks;
                sc_st_args.transa = largs->transa;
                sc_st_args.transb = largs->transb;
                sc_st_args.a = la[buff_idx];
                if (largs->transa) {
                    sc_st_args.lda = tile_m;
                } else if (largs->partition_banks) {
                    sc_st_args.lda = calculate_partitioned_banks_stride(
                        banks_per_buffer, tile_k, largs->prec);
                } else {
                    sc_st_args.lda = tile_k;
                }
                sc_st_args.b = lb[buff_idx];
                if (largs->transb) {
                    sc_st_args.ldb = tile_k;
                } else if (largs->partition_banks) {
                    sc_st_args.ldb = calculate_partitioned_banks_stride(
                        banks_per_buffer, tile_n, largs->prec);
                } else {
                    sc_st_args.ldb = tile_n;
                }
                sc_st_args.beta = beta_k;
                sc_st_args.c = lc[c_buff_idx];
                if (largs->partition_banks) {
                    sc_st_args.ldc = calculate_partitioned_banks_stride(
                        banks_per_buffer, tile_n, largs->prec);
                } else {
                    sc_st_args.ldc = tile_n;
                }
                sc_st_args.m = tile_m;
                sc_st_args.n = tile_n;
                sc_st_args.k = tile_k;
                sc_st_gemm(largs->gemm_fp, &sc_st_args);

                // uint32_t end_cycle = snrt_mcycle();
            }

            // Add the partial result tiles from the various clusters together
            // in a logarithmic reduction fashion.
            // Note: both compute and DMA cores participate in this step.
            if (largs->parallelize_k && (comp_k == (cluster_k_tiles - 1))) {
                switch (largs->prec) {
                    case FP64:
                        snrt_global_reduction_dma<double>(
                            (double *)lcr, (double *)lc[c_buff_idx],
                            tile_m * tile_n, comm);
                        break;
                    case FP32:
                        snrt_global_reduction_dma<float>(
                            (float *)lcr, (float *)lc[c_buff_idx],
                            tile_m * tile_n, comm);
                        break;
                    case FP16:
                        snrt_global_reduction_dma<__fp16>(
                            (__fp16 *)lcr, (__fp16 *)lc[c_buff_idx],
                            tile_m * tile_n, comm);
                        break;
                }
            }
        }

        // Synchronize cores after every iteration
        snrt_cluster_hw_barrier();
    }

    return 0;
}
