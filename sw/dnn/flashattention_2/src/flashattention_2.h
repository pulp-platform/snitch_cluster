// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Viviane Potocnik <vivianep@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "blas.h"
#include "snrt.h"

/**
 * @struct flashattention_2_layer_t
 * @brief This structure contains all parameters necessary
 *        for computing a FlashAttention-2 layer. Refer to
 *        "FlashAttention-2: Faster Attention with Better
 *        Parallelism and Work Partitioning" for more info
 * @var flashattention_2_layer_t::N
 * Sequence length in number of tokens
 * @var flashattention_2_layer_t::d
 * Head dimension
 * @var flashattention_2_layer_t::Q
 * Pointer to query tensor
 * @var flashattention_2_layer_t::K
 * Pointer to key tensor
 * @var flashattention_2_layer_t::V
 * Pointer to value tensor
 * @var flashattention_2_layer_t::O
 * Pointer to output tensor
 */
typedef struct {
    uint32_t N;
    uint32_t d;
    uint32_t B_r;
    uint32_t B_c;
    void *Q;
    void *K;
    void *V;
    void *O;
    precision_t dtype;
    uint32_t baseline;
} flashattention_2_layer_t;

static inline void flashattention_2_layer(flashattention_2_layer_t layer) {
    // alias layer parameters
    uint32_t dtype = layer.dtype;
    uint32_t N = layer.N;
    uint32_t d = layer.d;
    uint32_t B_r = layer.B_r;
    uint32_t B_c = layer.B_c;
    uint32_t baseline = layer.baseline;
    float *Q_l3 = layer.Q;
    float *K_l3 = layer.K;
    float *V_l3 = layer.V;
    float *O_l3 = layer.O;

    // alias system parameters
    uint32_t compute_id = snrt_global_core_idx();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t num_cores = snrt_cluster_compute_core_num();
    uint32_t num_clusters = snrt_cluster_num();

    // compute the tiling parameters
    uint32_t T_r = N / B_r;  // number of row blocks
    uint32_t T_c = N / B_c;  // number of column blocks

    // compute the size of the matrices
    uint32_t q_fa_size = B_r * d * sizeof(float);
    uint32_t k_fa_size = B_c * d * sizeof(float);
    uint32_t v_fa_size = B_c * d * sizeof(float);
    uint32_t s_fa_size = B_r * B_c * sizeof(float);
    uint32_t p_fa_size = B_r * B_c * sizeof(float);
    uint32_t o_fa_size = B_r * d * sizeof(float);
    uint32_t m_i_size = B_r * sizeof(float);
    uint32_t m_i_prev_size = m_i_size;
    uint32_t l_i_size = B_r * sizeof(float);
    uint32_t shifted_exp_size = B_r * sizeof(float);

    // allocate memory in TCDM
    void *tcdm_ptr = (float *)snrt_l1_next();
    float *Q_fa = tcdm_ptr;
    tcdm_ptr += q_fa_size;
    float *K_fa = tcdm_ptr;
    tcdm_ptr += k_fa_size;
    float *V_fa = tcdm_ptr;
    tcdm_ptr += v_fa_size;
    float *S_fa = tcdm_ptr;
    tcdm_ptr += s_fa_size;
    float *P_fa = tcdm_ptr;
    tcdm_ptr += p_fa_size;
    float *O_fa = tcdm_ptr;
    tcdm_ptr += o_fa_size;
    float *m_i = tcdm_ptr;
    tcdm_ptr += m_i_size;
    float *m_i_prev = tcdm_ptr;
    tcdm_ptr += m_i_prev_size;
    float *l_i = tcdm_ptr;
    tcdm_ptr += l_i_size;
    float shifted_exp;
    float row_sum;

    // Iterate row blocks of Q
    uint32_t start_loop_outer = snrt_mcycle();
    for (int t_r = 0; t_r < T_r; t_r++) {
        // DMA copy Q row block to TCDM
        uint32_t start_dma = snrt_mcycle();
        if (snrt_is_dm_core()) {
            uint32_t q_fa_offset = t_r * B_r * d;

            snrt_dma_txid_t txid_q_fa =
                snrt_dma_start_2d(Q_fa,               /* dst */
                                  Q_l3 + q_fa_offset, /* src */
                                  d * sizeof(float),  /* size */
                                  d * sizeof(float),  /* dst_stride */
                                  d * sizeof(float),  /* src_stride */
                                  B_r);               /* repetitions */

            snrt_dma_wait_all();
        }
        uint32_t end_dma = snrt_mcycle();

        snrt_cluster_hw_barrier();

        // Initialize m_i, m_i_prev, l_i, row_sum
        uint32_t rows_per_core = B_r / num_cores;
        uint32_t start_row = rows_per_core * compute_id;
        uint32_t end_row = start_row + rows_per_core;
        if (snrt_is_compute_core()) {
            for (int row_idx = start_row; row_idx < end_row; row_idx++) {
                m_i[row_idx] = -INFINITY;
                m_i_prev[row_idx] = -INFINITY;
                l_i[row_idx] = 0.0f;
            }
        }

        snrt_cluster_hw_barrier();

        snrt_cluster_hw_barrier();

        // Iterate column blocks of K (corresponding to row blocks of V)
        uint32_t start_loop_inner = snrt_mcycle();
        for (int t_c = 0; t_c < T_c; t_c++) {
            snrt_cluster_hw_barrier();

            // DMA copy K column block (B_c, d) and V row block (B_c, d) to
            // TCDM. Both K and V are stored in (N, d) form in memory
            uint32_t k_fa_offset = t_c * B_c * d;
            uint32_t v_fa_offset = t_c * B_c * d;
            uint32_t start_dma = snrt_mcycle();
            if (!snrt_is_compute_core()) {
                // K is in (N, d) format in main memory
                snrt_dma_txid_t txid_k_fa =
                    snrt_dma_start_2d(K_fa,               /* dst */
                                      K_l3 + k_fa_offset, /* src */
                                      d * sizeof(float),  /* size */
                                      d * sizeof(float),  /* dst_stride */
                                      d * sizeof(float),  /* src_stride */
                                      B_c);               /* repetitions */

                snrt_dma_txid_t txid_v_fa =
                    snrt_dma_start_2d(V_fa,               /* dst */
                                      V_l3 + v_fa_offset, /* src */
                                      d * sizeof(float),  /* size */
                                      d * sizeof(float),  /* dst_stride */
                                      d * sizeof(float),  /* src_stride */
                                      B_c);               /* repetitions */

                snrt_dma_wait_all();
            }
            uint32_t end_dma = snrt_mcycle();

            snrt_cluster_hw_barrier();

            // Calculate O tile from Q, K and V tiles
            if (snrt_is_compute_core()) {
                // Matrix multiplication between row block of Q and transposed
                // column block of K to calculate a tile of S: S = Q * K^T.
                // The S tile is of form (B_r, B_c)
                uint32_t start_gemm = snrt_mcycle();
                sc_st_gemm(dtype, 0, 1, 0, 1, B_r, B_c, d, 1, Q_fa, d, K_fa,
                           d, 0, S_fa, B_c, baseline);
                uint32_t end_gemm = snrt_mcycle();

                snrt_cluster_hw_barrier();

                // Iterate over the rows of the S row block, distributing
                // the rows to the cores
                for (int row_idx = start_row; row_idx < end_row; row_idx++) {
                    // Save m of current tile to rescale next tile
                    m_i_prev[row_idx] = m_i[row_idx];

                    // Initialize "local" row_sum to zero
                    row_sum = 0.0;

                    // Iterate over all columns to calculate maximum for the
                    // current row
                    for (int col_idx = 0; col_idx < B_c; col_idx++) {
                        float val = S_fa[row_idx * B_c + col_idx];
                        if (val > m_i[row_idx]) m_i[row_idx] = val;
                    }

                    // Calculate P tile as the "local" softmax of S
                    for (int col_idx = 0; col_idx < B_c; col_idx++) {
                        P_fa[row_idx * B_c + col_idx] =
                            expf(S_fa[row_idx * B_c + col_idx] - m_i[row_idx]);
                        row_sum += P_fa[row_idx * B_c + col_idx];
                    }

                    // Calculate rescaling factor l
                    shifted_exp = expf(m_i_prev[row_idx] - m_i[row_idx]);
                    if (t_c != 0) {
                        l_i[row_idx] = l_i[row_idx] * shifted_exp + row_sum;
                    } else {
                        l_i[row_idx] = row_sum;
                    }

                    // If not in first t_c iteration, update
                    // O_ij = diag(shifted_exp)^(-1) * O_i(j-1)
                    if (t_c != 0) {
                        for (int col_idx = 0; col_idx < d; col_idx++) {
                            O_fa[row_idx * d + col_idx] /= shifted_exp;
                        }
                    }
                }

                snrt_cluster_hw_barrier();

                snrt_cluster_hw_barrier();

                // Calculate O tile (O_ij) of size (B_r, d).
                // The P tile is of size (B_r, B_c) and V of size (B_c, d)
                if (t_c == 0) {
                    // In first t_c iteration, initialize O_ij to P_ij * V_j
                    sc_st_gemm(dtype, 0, 0, 0, 0, B_r, d, B_c, 1, P_fa, B_c,
                               V_fa, d, 0.0f, O_fa, d, baseline);
                } else {
                    // In successive t_c iterations, O_ij += P_ij * V_j
                    sc_st_gemm(dtype, 0, 0, 0, 0, B_r, d, B_c, 1, P_fa, B_c,
                               V_fa, d, 1.0f, O_fa, d, baseline);
                }

                uint32_t end_stats = snrt_mcycle();

                snrt_cluster_hw_barrier();
            } else {
                snrt_cluster_hw_barrier();
                snrt_cluster_hw_barrier();
                snrt_cluster_hw_barrier();
                snrt_cluster_hw_barrier();
            }
        }  // end of T_c loop

        snrt_cluster_hw_barrier();

        // Rescaling for last t_c iteration
        // O_i = diag(l_i_Tc)^-1 * O_i
        if (snrt_is_compute_core()) {
            for (int row_idx = start_row; row_idx < end_row; row_idx++) {
                for (int col_idx = 0; col_idx < d; col_idx++) {
                    O_fa[row_idx * d + col_idx] /= l_i[row_idx];
                }
            }
        }

        snrt_fpu_fence();

        snrt_cluster_hw_barrier();

        snrt_cluster_hw_barrier();

        // Write back O row block (B_r, d) to DRAM
        uint32_t start_dma_write_back = snrt_mcycle();
        if (snrt_is_dm_core()) {
            uint32_t o_fa_offset = t_r * B_r * d;
            snrt_dma_txid_t txid_o_fa =
                snrt_dma_start_2d(O_l3 + o_fa_offset, /* dst */
                                  O_fa,               /* src */
                                  d * sizeof(float),  /* size */
                                  d * sizeof(float),  /* dst_stride */
                                  d * sizeof(float),  /* src_stride */
                                  B_r);               /* repetitions */

            snrt_dma_wait_all();
        }
        uint32_t end_dma_write_back = snrt_mcycle();

    }  // end of T_r loop
    uint32_t end_loop_outer = snrt_mcycle();

    snrt_cluster_hw_barrier();
}
