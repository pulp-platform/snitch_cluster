// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Tim Fischer <fischeti@iis.ee.ethz.ch>
//         Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>
//         Viviane Potocnik <vivianep@iis.ee.ethz.ch>

#include <stdint.h>

#include "snrt.h"

#pragma once

#include "gemm_fp16.h"
#include "gemm_fp32.h"
#include "gemm_fp64.h"
#include "gemm_fp8.h"

// define the gemm_fp function pointer
typedef void (*gemm_fp_t)(uint32_t m, uint32_t n, uint32_t k, void* a,
                          uint32_t lda, uint32_t transa, void* b,
                          uint32_t transb, uint32_t ldb, void* c, uint32_t ldc,
                          uint32_t beta, uint32_t setup_ssr);

typedef struct {
    double alpha;
    uint32_t prec;
    uint32_t setup_ssr;
    uint32_t parallelize_m;
    uint32_t parallelize_k;
    uint32_t m_tiles;
    uint32_t n_tiles;
    uint32_t k_tiles;
    uint32_t load_a;
    uint32_t load_b;
    uint32_t load_c;
    uint32_t transa;
    uint32_t transb;
    uint32_t M;
    uint32_t N;
    uint32_t K;
    void* a;
    void* b;
    uint32_t beta;
    void* c;
    void* gemm_fp;
} gemm_args_t;

// BLAS compliant single-cluster single-tile GEMM kernel, with some additional
// arguments at the beginning to specify Snitch implementation details. Matrix
// sizes and pointers are for the whole cluster computation. Within a cluster
// the computation is parallelized by assigning distinct output rows to
// distinct cores.
// TODO: beta (and alpha) should be of floating-point type (same precision as
// operands)
void sc_st_gemm(gemm_args_t* gemm_args, void* a, void* b, uint32_t beta,
                void* c) {
    gemm_fp_t impl = (gemm_fp_t)gemm_args->gemm_fp;
    precision_t prec = gemm_args->prec;
    uint32_t setup_ssr = gemm_args->setup_ssr;
    uint32_t transa = gemm_args->transa;
    uint32_t transb = gemm_args->transb;

    uint32_t m = gemm_args->M / gemm_args->m_tiles;
    uint32_t n = gemm_args->N / gemm_args->n_tiles;
    uint32_t k = gemm_args->K / gemm_args->k_tiles;

    uint32_t lda = k;
    uint32_t ldb;
    if (transb) {
        ldb = k;
    } else {
        ldb = n;
    }
    uint32_t ldc = n;

    double alpha = gemm_args->alpha;

    if (snrt_is_compute_core()) {
        const uint32_t compute_num = snrt_cluster_compute_core_num();
        const uint32_t compute_id = snrt_cluster_core_idx();

        // Compute cores work not on contiguous blocks but on strided rows
        uint32_t lda_strided = compute_num * lda;
        uint32_t ldc_strided = compute_num * ldc;

        // Compute cores access A and C at offsets of one row from each other
        uint32_t offsetA = compute_id * lda * prec;
        uint32_t offsetC = compute_id * ldc * prec;

        // Compute fraction of C rows every core computes
        uint32_t frac_m = m / compute_num;
        uint32_t rem_m = m % compute_num;
        if (snrt_cluster_core_idx() < rem_m) frac_m++;

        if (frac_m > 0)
            impl(frac_m, n, k, a + offsetA, lda_strided, transa, b, ldb, transb,
                 c + offsetC, ldc_strided, (float)beta, setup_ssr);
    }
}

// Multiple-cluster multiple-tile GEMM implementation.
// If parallelize_m, assigns a distinct subset of M-tiles to distinct clusters.
// If parallelize_k, then K-tiles are distributed to distinct clusters; a
// binary reduction tree is implemented to accumulate these tiles together.
// Note: in the current implementation, parallelize_m and parallelize_k
// should be mutually-exclusive. The load_* options allow to bypass the DMA
// transfers and operate directly on the a, b and c inputs.
// m_tiles: number of tiles in M dimension
// k_tiles: number of tiles in K dimension
// n_tiles: number of tiles in N dimension
int gemm(gemm_args_t* args) {
    gemm_args_t* local_args = snrt_l1_next();

    // Copy the arguments to local memory
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(local_args, args, sizeof(gemm_args_t));
        snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    uint32_t m = local_args->M;
    uint32_t n = local_args->N;
    uint32_t k = local_args->K;
    precision_t prec = (precision_t)local_args->prec;
    uint32_t setup_ssr = local_args->setup_ssr;
    uint32_t parallelize_m = local_args->parallelize_m;
    uint32_t parallelize_k = local_args->parallelize_k;
    uint32_t m_tiles = local_args->m_tiles;
    uint32_t n_tiles = local_args->n_tiles;
    uint32_t k_tiles = local_args->k_tiles;
    uint32_t load_a = local_args->load_a;
    uint32_t load_b = local_args->load_b;
    uint32_t load_c = local_args->load_c;
    uint32_t transa = local_args->transa;
    uint32_t transb = local_args->transb;
    double alpha = local_args->alpha;
    void* a = local_args->a;
    void* b = local_args->b;
    uint32_t beta = local_args->beta;
    void* c = local_args->c;

    // Calculate tile sizes
    uint32_t frac_m = m / m_tiles;
    uint32_t frac_n = n / n_tiles;
    uint32_t frac_k = k / k_tiles;
    uint32_t frac_a = frac_m * frac_k;
    uint32_t frac_c = frac_m * frac_n;
    uint32_t size_frac_a = frac_a * prec;
    uint32_t size_frac_b = frac_k * frac_n * prec;
    uint32_t size_frac_c = frac_c * prec;

    // Allocate space in TCDM
    void *local_a, *local_b, *local_c_partial, *local_c;
    void* heap_ptr = (void*)local_args + sizeof(gemm_args_t);
    if (load_a) {
        local_a = heap_ptr;
        heap_ptr += size_frac_a;
    } else
        local_a = a;
    if (load_b) {
        local_b = heap_ptr;
        heap_ptr += size_frac_b;
    } else
        local_b = b;
    if (load_c) {
        local_c_partial = heap_ptr;
        heap_ptr += size_frac_c;
    } else
        local_c_partial = c;
    local_c = parallelize_k ? heap_ptr : local_c_partial;

    // Assign m and k tiles to clusters
    uint32_t m_tiles_per_cluster =
        parallelize_m ? m_tiles / snrt_cluster_num() : m_tiles;
    uint32_t k_tiles_per_cluster =
        parallelize_k ? k_tiles / snrt_cluster_num() : k_tiles;

    // Every cluster iterates over its subset of m tiles
    for (uint32_t m_tile = 0; m_tile < m_tiles_per_cluster; m_tile++) {
        for (uint32_t n_tile = 0; n_tile < n_tiles; n_tile++) {
            // Calculate absolute m tile index for the current cluster
            uint32_t abs_m_tile_idx =
                !parallelize_m
                    ? m_tile
                    : snrt_cluster_idx() * m_tiles_per_cluster + m_tile;

            // k accumulation loop
            for (uint32_t k_tile = 0; k_tile < k_tiles_per_cluster; k_tile++) {
                // Calculate absolute k tile index for the current cluster
                uint32_t abs_k_tile_idx =
                    !parallelize_k
                        ? k_tile
                        : snrt_cluster_idx() * k_tiles_per_cluster + k_tile;

                // Copy data in TCDM
                if (snrt_is_dm_core()) {
                    if (load_a) {
                        snrt_dma_load_2d_tile(local_a, a, abs_m_tile_idx,
                                              abs_k_tile_idx, frac_m, frac_k, k,
                                              prec);
                    }
                    if (load_b) {
                        snrt_dma_load_2d_tile(local_b, b, abs_k_tile_idx,
                                              n_tile, frac_k, frac_n, n, prec);
                    }
                    // C tile is loaded only upon first iteration, then the C
                    // array will contain the partial results from the
                    // previous iteration
                    if (load_c) {
                        if (abs_k_tile_idx == 0) {
                            snrt_dma_load_2d_tile(local_c_partial, c,
                                                  abs_m_tile_idx, n_tile,
                                                  frac_m, frac_n, n, prec);
                        } else if (k_tile == 0) {
                            // Clusters other than the first need to initialize
                            // the C array to zero in their first iteration
                            snrt_dma_start_1d(local_c_partial,
                                              (void*)snrt_zero_memory_ptr(),
                                              frac_m * frac_n * prec);
                        }
                    }
                    snrt_dma_wait_all();
                }

                snrt_cluster_hw_barrier();

                // Compute
                if (!snrt_is_dm_core()) {
                    uint32_t start_cycle = snrt_mcycle();

                    volatile uint32_t ldb = frac_n;
                    volatile uint32_t ldc = frac_n;

                    if (transb) {
                        ldb = frac_k;
                    }

                    // In the first K iteration we accumulate with the C matrix
                    // scaled by beta, in successive iterations we accumulate
                    // the previous partial result for the tile
                    uint32_t beta_k;
                    if (abs_k_tile_idx == 0) {
                        beta_k = beta;
                    } else {
                        beta_k = 1;
                    }

                    sc_st_gemm(local_args, local_a, local_b, beta_k,
                               local_c_partial);

                    uint32_t end_cycle = snrt_mcycle();
                }

                snrt_cluster_hw_barrier();
            }

            // Add the partial results from the various clusters together in a
            // logarithmic reduction fashion
            if (parallelize_k) {
                snrt_global_reduction_dma((double*)local_c,
                                          (double*)local_c_partial,
                                          frac_m * frac_n);
            }

            // Copy data out of TCDM
            if (snrt_is_dm_core()) {
                // If parallelize_k, then only cluster 0 must writeback
                if ((snrt_cluster_idx() == 0) || !parallelize_k) {
                    snrt_dma_store_2d_tile(c, local_c, abs_m_tile_idx, n_tile,
                                           frac_m, frac_n, n, prec);
                    snrt_dma_wait_all();
                }
            }
        }
    }

    return 0;
}
