// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Viviane Potocnik <vivianep@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

static inline void flashattention_2_fp16(flashattention_2_layer_t layer) {
    // alias layer parameters
    uint32_t dtype = layer.dtype;
    uint32_t L = layer.L;
    uint32_t S = layer.S;
    uint32_t d = layer.d;
    uint32_t B_r = layer.B_r;
    uint32_t B_c = layer.B_c;
    uint32_t baseline = layer.baseline;
    void *gemm_implementation = layer.gemm_implementation;
    __fp16 *Q_l3 = layer.Q;
    __fp16 *K_l3 = layer.K;
    __fp16 *V_l3 = layer.V;
    __fp16 *O_l3 = layer.O;

    // alias system parameters
    uint32_t compute_id = snrt_global_core_idx();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t num_cores = snrt_cluster_compute_core_num();
    uint32_t num_clusters = snrt_cluster_num();

    // compute the tiling parameters
    uint32_t T_r = L / B_r;  // number of row blocks
    uint32_t T_c = S / B_c;  // number of column blocks

    // compute the size of the matrices
    uint32_t q_fa_size = B_r * d * sizeof(__fp16);
    uint32_t k_fa_size = B_c * d * sizeof(__fp16);
    uint32_t v_fa_size = B_c * d * sizeof(__fp16);
    uint32_t s_fa_size = B_r * B_c * sizeof(__fp16);
    uint32_t p_fa_size = B_r * B_c * sizeof(__fp16);
    uint32_t o_fa_size = B_r * d * sizeof(__fp16);
    uint32_t m_i_size = B_r * sizeof(float);
    uint32_t m_i_prev_size = m_i_size;
    uint32_t l_i_size = B_r * sizeof(float);

    // allocate memory in TCDM
    __fp16 *Q_fa = snrt_l1_alloc_cluster_local(q_fa_size, sizeof(__fp16));
    __fp16 *K_fa = snrt_l1_alloc_cluster_local(k_fa_size, sizeof(__fp16));
    __fp16 *V_fa = snrt_l1_alloc_cluster_local(v_fa_size, sizeof(__fp16));
    __fp16 *S_fa = snrt_l1_alloc_cluster_local(s_fa_size, sizeof(__fp16));
    __fp16 *P_fa = snrt_l1_alloc_cluster_local(p_fa_size, sizeof(__fp16));
    __fp16 *O_fa = snrt_l1_alloc_cluster_local(o_fa_size, sizeof(__fp16));
    float *m_i = snrt_l1_alloc_cluster_local(m_i_size, sizeof(float));
    float *m_i_prev = snrt_l1_alloc_cluster_local(m_i_prev_size, sizeof(float));
    float *l_i = snrt_l1_alloc_cluster_local(l_i_size, sizeof(float));

    // allocate space for V^t when using optimized kernels
    __fp16 *V_t;
    if (!baseline) V_t = snrt_l1_alloc_cluster_local(v_fa_size, sizeof(__fp16));

    float shifted_exp;
    float row_sum;

    snrt_mcycle();

    // Iterate row blocks of Q
    for (int t_r = 0; t_r < T_r; t_r++) {
        // DMA copy Q row block to TCDM
        if (snrt_is_dm_core()) {
            snrt_dma_load_2d_tile(Q_fa,           // dst
                                  Q_l3,           // src
                                  t_r,            // tile_x1_idx
                                  0,              // tile_x0_idx
                                  B_r,            // tile_x1_size
                                  d,              // tile_x0_size
                                  d,              // full_x0_size
                                  sizeof(__fp16)  // prec
            );
            snrt_dma_wait_all();
        }
        snrt_cluster_hw_barrier();

        snrt_mcycle();

        // Initialize m_i, m_i_prev, l_i, row_sum.
        // Distribute rows evenly to the cores in a cluster.
        // Last core handles remainder rows.
        uint32_t rows_per_core = B_r / num_cores;
        uint32_t start_row = rows_per_core * compute_id;
        char is_last_compute_core = snrt_cluster_core_idx() == (snrt_cluster_compute_core_num() - 1);
        uint32_t end_row = is_last_compute_core ? B_r : start_row + rows_per_core;
        if (snrt_is_compute_core()) {
            for (int row_idx = start_row; row_idx < end_row; row_idx++) {
                m_i[row_idx] = -INFINITY;
                m_i_prev[row_idx] = -INFINITY;
                // TODO this shouldn't be necessary since it is later
                // initialized to row_sum (change in all precisions)
                l_i[row_idx] = 0.0f;
            }
        }

        snrt_cluster_hw_barrier();

        snrt_mcycle();

        // Iterate column blocks of K (corresponding to row blocks of V)
        for (int t_c = 0; t_c < T_c; t_c++) {

            // DMA copy K column block (B_c, d) and V row block (B_c, d) to
            // TCDM. Both K and V are stored in (S, d) form in memory
            if (!snrt_is_compute_core()) {
                snrt_dma_load_2d_tile(K_fa,           // dst
                                      K_l3,           // src
                                      t_c,            // tile_x1_idx
                                      0,              // tile_x0_idx
                                      B_c,            // tile_x1_size
                                      d,              // tile_x0_size
                                      d,              // full_x0_size
                                      sizeof(__fp16)  // prec
                );
                snrt_dma_load_2d_tile(V_fa,           // dst
                                      V_l3,           // src
                                      t_c,            // tile_x1_idx
                                      0,              // tile_x0_idx
                                      B_c,            // tile_x1_size
                                      d,              // tile_x0_size
                                      d,              // full_x0_size
                                      sizeof(__fp16)  // prec
                );
                snrt_dma_wait_all();
            }
            snrt_cluster_hw_barrier();

            snrt_mcycle();

            // Calculate O tile from Q, K and V tiles
            if (snrt_is_compute_core()) {
                // Matrix multiplication between row block of Q and transposed
                // column block of K to calculate a tile of S: S = Q * K^T.
                // The S tile is of form (B_r, B_c)
                sc_st_gemm(dtype, 1, 0, 1, B_r, B_c, d, 1, Q_fa, d, K_fa, d, 0,
                           S_fa, B_c, gemm_implementation);

                snrt_cluster_hw_barrier();

                snrt_mcycle();

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
                        float val =
                            expf(S_fa[row_idx * B_c + col_idx] - m_i[row_idx]);
                        P_fa[row_idx * B_c + col_idx] = val;
                        row_sum += val;
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

                snrt_mcycle();

                // Calculate O tile (O_ij) of size (B_r, d).
                // The P tile is of size (B_r, B_c) and V of size (B_c, d)
                if (baseline) {
                    // In first t_c iteration, initialize O_ij to P_ij * V_j
                    // In successive t_c iterations, O_ij += P_ij * V_j
                    uint32_t beta;
                    if (t_c == 0)
                        beta = 0;
                    else
                        beta = 1;
                    sc_st_gemm(dtype, 1, 0, 0, B_r, d, B_c, 1, P_fa, B_c, V_fa,
                               d, beta, O_fa, d, gemm_implementation);
                } else {
                    // The SIMD-optimized GEMM kernel performs the A*B^t
                    // operation. We must transpose V in advance, so
                    // we can compute P*(V^t)^t with the optimized GEMM.

                    // Compute V^t
                    transpose_kernel(dtype, V_fa, V_t, B_c, d, baseline);

                    // In first t_c iteration, initialize O_ij to
                    // P_ij * (V_j^t)^t. In successive t_c iterations,
                    // O_ij += P_ij * (V_j^t)^t
                    uint32_t beta;
                    if (t_c == 0)
                        beta = 0;
                    else
                        beta = 1;
                    sc_st_gemm(dtype, 1, 0, 1, B_r, d, B_c, 1, P_fa, B_c, V_t,
                               B_c, beta, O_fa, d, gemm_implementation);
                }
            } else {
                snrt_cluster_hw_barrier();
                snrt_cluster_hw_barrier();
                snrt_mcycle();
                snrt_mcycle();
            }
            snrt_cluster_hw_barrier();
        
            snrt_mcycle();
        }  // end of T_c loop

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

        snrt_mcycle();

        // Write back O row block (B_r, d) to DRAM
        if (snrt_is_dm_core()) {
            snrt_dma_store_2d_tile(O_l3,           // dst
                                   O_fa,           // src
                                   t_r,            // tile_x1_idx
                                   0,              // tile_x0_idx
                                   B_r,            // tile_x1_size
                                   d,              // tile_x0_size
                                   d,              // full_x0_size
                                   sizeof(__fp16)  // prec
            );
            snrt_dma_wait_all();
        }
        snrt_cluster_hw_barrier();

        snrt_mcycle();

    }  // end of T_r loop

    snrt_cluster_hw_barrier();
}