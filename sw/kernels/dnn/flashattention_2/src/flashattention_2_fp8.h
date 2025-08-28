// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Viviane Potocnik <vivianep@iis.ee.ethz.ch>
//         Luca Colagrande <colluca@iis.ee.ethz.ch>

static inline float fp8_to_float(char val) {
    float res;
    asm volatile(
        "fmv.b.x %[res], %[val]\n"
        "fcvt.s.b %[res], %[res]\n"
        : [ res ] "=f"(res)
        : [ val ] "r"(val));
    return res;
}

static inline char float_to_fp8(float val) {
    char res;
    asm volatile(
        "fcvt.b.s ft3, %[val]\n"
        "fmv.x.b %[res], ft3\n"
        : [ res ] "=r"(res)
        : [ val ] "f"(val)
        : "ft3");
    return res;
}

static inline void flashattention_2_fp8(flashattention_2_layer_t layer) {
    // alias layer parameters
    uint32_t dtype = layer.dtype;
    uint32_t L = layer.L;
    uint32_t S = layer.S;
    uint32_t d = layer.d;
    uint32_t B_r = layer.B_r;
    uint32_t B_c = layer.B_c;
    uint32_t baseline = layer.baseline;
    gemm_fp_t gemm_implementation = layer.gemm_implementation;
    char *Q_l3 = (char *)layer.Q;
    char *K_l3 = (char *)layer.K;
    char *V_l3 = (char *)layer.V;
    char *O_l3 = (char *)layer.O;

    // gemm specific parameters
    sc_st_gemm_args_t gemm_args;

    gemm_args.prec = dtype;
    if (!baseline) {
        gemm_args.setup_ssr = 1;
    } else {
        gemm_args.setup_ssr = 0;
    }
    gemm_args.transa = 0;
    gemm_args.transb = 1;
    gemm_args.m = B_r;
    gemm_args.alpha = 1;

    // alias system parameters
    uint32_t compute_id = snrt_cluster_core_idx();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t num_cores = snrt_cluster_compute_core_num();
    uint32_t num_clusters = snrt_cluster_num();

    // compute the tiling parameters
    uint32_t T_r = L / B_r;  // number of row blocks
    uint32_t T_c = S / B_c;  // number of column blocks

    // compute the size of the matrices
    uint32_t q_fa_size = B_r * d * sizeof(char);
    uint32_t k_fa_size = B_c * d * sizeof(char);
    uint32_t v_fa_size = B_c * d * sizeof(char);
    uint32_t s_fa_size = B_r * B_c * sizeof(char);
    uint32_t p_fa_size = B_r * B_c * sizeof(char);
    uint32_t o_fa_size = B_r * d * sizeof(char);
    uint32_t m_i_size = B_r * sizeof(float);
    uint32_t l_i_size = B_r * sizeof(float);
    uint32_t shifted_exp_size = B_r * sizeof(float);

    // allocate memory in TCDM
    char *Q_fa = (char *)snrt_l1_alloc_cluster_local(q_fa_size, alignof(char));
    char *K_fa = (char *)snrt_l1_alloc_cluster_local(k_fa_size, alignof(char));
    char *V_fa = (char *)snrt_l1_alloc_cluster_local(v_fa_size, alignof(char));
    char *S_fa = (char *)snrt_l1_alloc_cluster_local(s_fa_size, alignof(char));
    char *P_fa = (char *)snrt_l1_alloc_cluster_local(p_fa_size, alignof(char));
    char *O_fa = (char *)snrt_l1_alloc_cluster_local(o_fa_size, alignof(char));
    float *m_i = (float *)snrt_l1_alloc_cluster_local(m_i_size, alignof(float));
    float *m_i_prev =
        (float *)snrt_l1_alloc_cluster_local(m_i_size, alignof(float));
    float *l_i = (float *)snrt_l1_alloc_cluster_local(l_i_size, alignof(float));

    // Allocate space for V^t
    char *V_t;
    if (!baseline) {
        V_t = (char *)snrt_l1_alloc_cluster_local(v_fa_size, alignof(char));
    }

    float shifted_exp;
    float row_sum;

    snrt_mcycle();

    // Iterate row blocks of Q
    for (int t_r = 0; t_r < T_r; t_r++) {
        // DMA copy Q row block to TCDM
        if (snrt_is_dm_core()) {
            snrt_dma_load_2d_tile(Q_fa,         // dst
                                  Q_l3,         // src
                                  t_r,          // tile_x1_idx
                                  0,            // tile_x0_idx
                                  B_r,          // tile_x1_size
                                  d,            // tile_x0_size
                                  d,            // full_x0_size
                                  sizeof(char)  // prec
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
        char is_last_compute_core =
            snrt_cluster_core_idx() == (snrt_cluster_compute_core_num() - 1);
        uint32_t end_row =
            is_last_compute_core ? B_r : start_row + rows_per_core;
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
                snrt_dma_load_2d_tile(K_fa,         // dst
                                      K_l3,         // src
                                      t_c,          // tile_x1_idx
                                      0,            // tile_x0_idx
                                      B_c,          // tile_x1_size
                                      d,            // tile_x0_size
                                      d,            // full_x0_size
                                      sizeof(char)  // prec
                );
                snrt_dma_load_2d_tile(V_fa,         // dst
                                      V_l3,         // src
                                      t_c,          // tile_x1_idx
                                      0,            // tile_x0_idx
                                      B_c,          // tile_x1_size
                                      d,            // tile_x0_size
                                      d,            // full_x0_size
                                      sizeof(char)  // prec
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
                gemm_args.n = B_c;
                gemm_args.k = d;
                gemm_args.a = Q_fa;
                gemm_args.lda = d;
                gemm_args.b = K_fa;
                gemm_args.ldb = d;
                gemm_args.beta = 0;
                gemm_args.c = S_fa;
                gemm_args.ldc = B_c;
                sc_st_gemm(gemm_implementation, &gemm_args);

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
                        float val = fp8_to_float(S_fa[row_idx * B_c + col_idx]);
                        if (val > m_i[row_idx]) m_i[row_idx] = val;
                    }

                    // Calculate P tile as the "local" softmax of S
                    for (int col_idx = 0; col_idx < B_c; col_idx++) {
                        float val =
                            expf(fp8_to_float(S_fa[row_idx * B_c + col_idx]) -
                                 m_i[row_idx]);
                        P_fa[row_idx * B_c + col_idx] = float_to_fp8(val);
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
                            float val =
                                fp8_to_float(O_fa[row_idx * d + col_idx]);
                            O_fa[row_idx * d + col_idx] =
                                float_to_fp8(val / shifted_exp);
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

                    gemm_args.n = d;
                    gemm_args.k = B_c;
                    gemm_args.transb = 0;
                    gemm_args.a = P_fa;
                    gemm_args.lda = B_c;
                    gemm_args.b = V_fa;
                    gemm_args.ldb = d;
                    gemm_args.beta = beta;
                    gemm_args.c = O_fa;
                    gemm_args.ldc = d;
                    sc_st_gemm(gemm_implementation, &gemm_args);
                    gemm_args.transb = 1;
                } else {
                    // The SIMD-optimized GEMM kernel performs the A*B^t
                    // operation. We must transpose V in advance, so
                    // we can compute P*(V^t)^t with the optimized GEMM.

                    // Compute V^t
                    transpose_kernel((precision_t)dtype, V_fa, V_t, B_c, d,
                                     baseline);

                    // In first t_c iteration, initialize O_ij to
                    // P_ij * (V_j^t)^t. In successive t_c iterations,
                    // O_ij += P_ij * (V_j^t)^t
                    uint32_t beta;
                    if (t_c == 0)
                        beta = 0;
                    else
                        beta = 1;
                    gemm_args.n = d;
                    gemm_args.k = B_c;
                    gemm_args.a = P_fa;
                    gemm_args.lda = B_c;
                    gemm_args.b = V_t;
                    gemm_args.ldb = B_c;
                    gemm_args.beta = beta;
                    gemm_args.c = O_fa;
                    gemm_args.ldc = d;
                    sc_st_gemm(gemm_implementation, &gemm_args);
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
                    float val = fp8_to_float(O_fa[row_idx * d + col_idx]);
                    O_fa[row_idx * d + col_idx] =
                        float_to_fp8(val / l_i[row_idx]);
                }
            }
        }

        snrt_fpu_fence();
        snrt_cluster_hw_barrier();

        snrt_mcycle();

        // Write back O row block (B_r, d) to DRAM
        if (snrt_is_dm_core()) {
            snrt_dma_store_2d_tile(O_l3,         // dst
                                   O_fa,         // src
                                   t_r,          // tile_x1_idx
                                   0,            // tile_x0_idx
                                   B_r,          // tile_x1_size
                                   d,            // tile_x0_size
                                   d,            // full_x0_size
                                   sizeof(char)  // prec
            );
            snrt_dma_wait_all();
        }

        snrt_cluster_hw_barrier();

        snrt_mcycle();

    }  // end of T_r loop

    snrt_cluster_hw_barrier();
}
