// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include <stdint.h>

// Define the gemm_fp function pointer
typedef void (*gemm_fp_t)(uint32_t setup_ssr, uint32_t partition_banks,
                          uint32_t transa, uint32_t transb, uint32_t M,
                          uint32_t N, uint32_t K, void* A_p, uint32_t lda,
                          void* B_p, uint32_t ldb, uint32_t beta, void* C_p,
                          uint32_t ldc);

/**
 * @struct gemm_args_t
 * @brief Structure to hold arguments for a GEMM operation on Snitch-based
 *        multiple-cluster architectures.
 *
 * This structure encapsulates all the parameters required to configure and
 * execute a GEMM operation on a Snitch-based multiple-cluster architecture
 * with support for parallelization, tiling, and data movement optimizations.
 *
 * @var gemm_args_t::m_tiles
 * Partition the problem into the specified number of tiles along the M
 * dimension.
 *
 * @var gemm_args_t::n_tiles
 * Partition the problem into the specified number of tiles along the N
 * dimension.
 *
 * @var gemm_args_t::k_tiles
 * Partition the problem into the specified number of tiles along the K
 * dimension.
 *
 * @var gemm_args_t::parallelize_m
 * If set, distributes tiles on the M dimension to different clusters.
 *
 * @var gemm_args_t::parallelize_k
 * If set, distributes tiles on the K dimension to different clusters.
 * The `snrt_global_reduction_dma` function is used to reduce the partial
 * results obtained in each cluster.
 *
 * @var gemm_args_t::load_a
 * Flag indicating whether to allocate and load the A matrix into TCDM.
 * Do not set if A matrix is already allocated and stored in TCDM, e.g. as the
 * result of a previous computation.
 *
 * @var gemm_args_t::load_b
 * Flag indicating whether to allocate and load the B matrix into TCDM.
 * Do not set if B matrix is already allocated and stored in TCDM, e.g. as the
 * result of a previous computation.
 *
 * @var gemm_args_t::load_c
 * Flag indicating whether to allocate and load the C matrix into TCDM.
 * Do not set if C matrix is already allocated and stored in TCDM, e.g. as the
 * result of a previous computation.
 *
 * @var gemm_args_t::double_buffer
 * Flag indicating whether to employ double buffering on arrays that are loaded
 * from memory.
 *
 * @var gemm_args_t::gemm_fp
 * Function pointer of a specific GEMM kernel implementation in Snitch, e.g.
 * `gemm_fp64_opt`.
 *
 * @var gemm_args_t::prec
 * Arithmetic precision of the operands and the computation.
 *
 * @var gemm_args_t::setup_ssr
 * Flag indicating whether to (re)configure the SSRs. Only needs to be set
 * on the invocation for the first tile. Successive tiles of the same problem
 * can inherit the same settings of the first tile without reconfiguration.
 *
 * @var gemm_args_t::partition_banks
 * Flag indicating whether to partition the banks, assigning a unique subset
 * of banks to each buffer.
 */
typedef struct {
    uint32_t m_tiles;
    uint32_t n_tiles;
    uint32_t k_tiles;
    uint32_t parallelize_m;
    uint32_t parallelize_k;
    uint32_t load_a;
    uint32_t load_b;
    uint32_t load_c;
    uint32_t double_buffer;
    gemm_fp_t gemm_fp;
    uint32_t prec;
    uint32_t setup_ssr;
    uint32_t partition_banks;
    // BLAS args
    uint32_t transa;
    uint32_t transb;
    uint32_t m;
    uint32_t n;
    uint32_t k;
    double alpha;
    void* a;
    uint32_t lda;
    void* b;
    uint32_t ldb;
    uint32_t beta;
    void* c;
    uint32_t ldc;
} gemm_args_t;

/**
 * @struct sc_st_gemm_args_t
 * @brief Structure to hold arguments for a GEMM operation on a single Snitch
 *        cluster.
 *
 * This structure encapsulates all the parameters required to configure and
 * execute a single tile GEMM operation on a single Snitch cluster.
 *
 * @note Refer to `gemm_args_t` for a description of each parameter.
 */
typedef struct {
    uint32_t prec;
    uint32_t setup_ssr;
    uint32_t partition_banks;
    // BLAS args
    uint32_t transa;
    uint32_t transb;
    uint32_t m;
    uint32_t n;
    uint32_t k;
    double alpha;
    void* a;
    uint32_t lda;
    void* b;
    uint32_t ldb;
    uint32_t beta;
    void* c;
    uint32_t ldc;
} sc_st_gemm_args_t;
