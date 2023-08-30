// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Viviane Potocnik (ETH Zurich) <vivianep@iis.ee.ethz.ch>

#pragma once

#include "math.h"
#include "snrt.h"
#include "utils.h"
#include "gemm.h"

#define BANSHEE 0
#define DEBUG_VERBOSE 0
#define DEBUG 1
#define BRIEF 1 // enable this define to only compute two iterations of the loops
#define LAYERNORM 0 // enable this define to compute the layernorm
#define LINEAR_1 0 // enable this define to compute the linear layer 1
#define FLASH_ATTENTION 0 // enable this define to compute the flash attention
#define CONCAT 0 // enable this define to compute the head concatenation

/**
 * @struct transformer_layer_fp64_struct
 * @brief This structure contains all parameters necessary
 *        for computing a Transformer layer
 * @var transformer_layer_fp64_struct::seq_len
 * Number of input tokens
 * @var transformer_layer_fp64_struct::embeddings
 * Vector size of each input token
 * @var transformer_layer_fp64_struct::positional_embeddings
 * Vector size of each positional embedding
 * @var transformer_layer_fp64_struct::ifmap
 * Pointer to input feature map
 * @var transformer_layer_fp64_struct::bias
 * Pointer to bias for each head
 * @var transformer_layer_fp64_struct::weights_q
 * Pointer to weights for query
 * @var transformer_layer_fp64_struct::weights_k
 * Pointer to weights for key
 * @var transformer_layer_fp64_struct::weights_v
 * Pointer to weights for value
 * @var transformer_layer_fp64_struct::ofmap
 * Pointer to output feature map
 * @var transformer_layer_fp64_struct::query
 * Pointer to the golden model output for query
 * @var transformer_layer_fp64_struct::key
 * Pointer to the golden model output for key
 * @var transformer_layer_fp64_struct::value
 * Pointer to the golden model output for value
 */

typedef struct transformer_layer_fp64_struct {
    uint32_t BATCH_SIZE;
    uint32_t seq_len;
    uint32_t S_tile_ln;
    uint32_t S_tile_lin1;
    uint32_t P_tile_lin1;
    uint32_t Br_tile_fa;
    uint32_t Bc_tile_fa;
    uint32_t Br_tile_lin2;
    uint32_t Bc_tile_lin2;
    uint32_t positional_embeddings_fa;
    uint32_t embeddings;
    uint32_t embeddings_lin2;
    uint32_t positional_embeddings;
    uint32_t feedforward_len;
    uint32_t heads;
    double eps;

    double *ifmap;
    double *ifmap_lin2;
    double *attn_ifmap;
    double *bias;
    double *weights_q;
    double *weights_k;
    double *weights_v;
    double *weights_lin2;

    double *Q_lin;
    double *K_lin;
    double *V_lin;
    double *Q_fa;
    double *K_fa;
    double *V_fa;
    double *O;
    double *O_lin2;
    double *ofmap;
    double *query;
    double *key;
    double *value;

    precision_t dtype;
} transformer_layer_fp64_t;

/**
 * @struct transformer_layer_fp32_struct
 * @brief This structure contains all parameters necessary
 *        for computing a Transformer layer
 * @var transformer_layer_fp32_struct::seq_len
 * Number of input tokens
 * @var transformer_layer_fp32_struct::embeddings
 * Vector size of each input token
 * @var transformer_layer_fp32_struct::positional_embeddings
 * Vector size of each positional embedding
 * @var transformer_layer_fp32_struct::ifmap
 * Pointer to input feature map
 * @var transformer_layer_fp32_struct::bias
 * Pointer to bias for each head
 * @var transformer_layer_fp32_struct::weights_q
 * Pointer to weights for query
 * @var transformer_layer_fp32_struct::weights_k
 * Pointer to weights for key
 * @var transformer_layer_fp32_struct::weights_v
 * Pointer to weights for value
 * @var transformer_layer_fp32_struct::ofmap
 * Pointer to output feature map
 * @var transformer_layer_fp32_struct::query
 * Pointer to the golden model output for query
 * @var transformer_layer_fp32_struct::key
 * Pointer to the golden model output for key
 * @var transformer_layer_fp32_struct::value
 * Pointer to the golden model output for value
 */

typedef struct transformer_layer_fp32_struct {
    uint32_t BATCH_SIZE;
    uint32_t seq_len;
    uint32_t embeddings;
    uint32_t positional_embeddings;
    uint32_t heads;
    float eps;

    float *ifmap;
    float *attn_ifmap;
    float *bias;
    float *weights_q;
    float *weights_k;
    float *weights_v;
    float *weights_o;
    float *Q_lin;
    float *K_lin;
    float *V_lin;
    float *O;
    float *ofmap;
    float *query;
    float *key;
    float *value;

    precision_t dtype;
} transformer_layer_fp32_t;

/* Debugging Variables*/
// dump_float(debug, 8);
// dump_uint(idx, 7);
// dump_float(ifmap, 6);
// dump_float(weights, 10); // = 0xa
// dump_float(value, 12); // = 0xc

/**
 * @brief            Documentation for the DMA transfer function
 * @param dst        Pointer to destination
 * @param src        Pointer to source
 * @param size       How many bytes to transfer in total in one repetition/row
 * @param dst_stride Stride of the destination, i.e. how many bytes to jump
 *                   between two consecutive transfers in the same row of 
 *                   the destination
 * @param src_stride Stride of the source, i.e. how many bytes to jump
 *                   between two consecutive transfers in the same row of
 *                   the source
 * @param repetitions How many rows to transfer
 */

/**
 * Implementation of the GELU layer
 */
#define M_PI 3.14159265358979323846
static inline float transformer_gelu_fp32(float x) {
    float y = 0.5 * x * (1.0 + tanh(sqrt(2.0 / M_PI) * (x + 0.044715 * x * x * x)));
    return y;
}

/**
 * Implementation of the LayerNorm layer fused with a linear layer and a GELU activation.
 * Input is a 2D matrix of size (S x E) where S is the sequence length and E is the number of embeddings.
 * The weights matrix is of size (E x F) where F is the number of hidden nodes.
 */
static inline void fused_mlp_baseline(float *input, float *output, int32_t ldI, int32_t ldO, float *weights, int32_t ldW,
                                                  int32_t seq_len, int32_t embeddings, int32_t ff_len, int32_t eps) {
    float mean = 0.0;  // max value of the current core
    float var = 0.0;   // sum of the exp values of the current core
    float acc = 0.0;   // accumulator for the linear layer

    uint32_t compute_id = snrt_global_core_idx();
    uint32_t num_cores = snrt_cluster_compute_core_num();

    // compute the mean and variance along the innermost dimension
    for (int s = 0; s < seq_len; s++) {
        mean = 0.0;
        var = 0.0;
        for (int e = 0; e < embeddings; e++) {
            mean += input[s * ldI + e];
        }

        mean /= embeddings;

        for (int e = 0; e < embeddings; e++) {
            var += (input[s * ldI + e] - mean) * (input[s * ldI + e] - mean);
        }
        var /= embeddings;
        // we have to compute the normalize row only once
        // and then multiply with the columns of the weight matrix
        for (int f = 0; f < ff_len; f++) {
            acc = 0.0;
            for (int e = 0; e < embeddings; e++) {
                // we only have to compute the normalization once
                if (f == 0) {
                    output[s * ldO + f] = (input[s * ldI + e] - mean) / sqrtf(var + eps);
                }
                acc += output[s * ldO + e] * weights[e * ldW + f];
            }
            output[s * ldO + f] = transformer_gelu_fp32(acc);
        }
    }
    
}

// Debugging functions
dump_uint(idx, 6);
dump_float(debug, 7);
dump_uint(id, 5);
dump_float(concat, 10);
dump_uint(ct, 11);

/**
 * @brief  Transformer layer
 *
 * @param l transformer_layer struct that holds addresses and parameters in FP64
 *
 */
static inline void transformer_layer_fp64(transformer_layer_fp64_t *const l) {
    uint32_t compute_id = snrt_global_core_idx();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t num_cores = snrt_cluster_compute_core_num();
    uint32_t num_clusters = snrt_cluster_num();

    uint32_t seq_len = l->seq_len;
    uint32_t embeddings = l->embeddings;
    uint32_t positional_embeddings = l->positional_embeddings;
    uint32_t heads = l->heads;
    uint32_t eps = l->eps;

    // dump_id(compute_id);
    // dump_id(num_cores);
    // dump_id(num_clusters);

    /////////////////////////////////////////////////////////////////////
    //////////////   MULTI-HEAD SELF-ATTENTION BLOCK   /////////////////
    ///////////////////////////////////////////////////////////////////

    /////////////////////   Layer 1: LayerNorm   /////////////////////
    //                      Input size (S x E)                      //
    //                      Output size (S x E)                     //
    //             S is tiled into Row Blocks of B_r rows           //
    //////////////////////////////////////////////////////////////////

    if(LAYERNORM == 1) {    
        // compute the tiling parameters
        uint32_t B_r = l->S_tile_ln; // number of rows per row block
        uint32_t T_r = l->seq_len / B_r; // number of row blocks

        dump_idx(B_r);
        dump_idx(T_r);

        // compute the size of the matrices
        uint32_t ifmap_tcdm = B_r * embeddings * sizeof(double);

        // allocate memory in TCDM
        void *tcdm_ptr = (double *)snrt_l1_next();
        double *ifmap = tcdm_ptr;
        tcdm_ptr += ifmap_tcdm;

        uint32_t start_loop_outer = snrt_mcycle();
        for (int t_r = 0; t_r < T_r; t_r++) {
            // dump_index(t_r);
            uint32_t ifmap_offset = t_r * B_r * embeddings;
            if (!snrt_is_compute_core()) {
                // load the input feature map: B_r * E 
                // DMA transfer the ifmap into the cluster TCDM
                uint32_t start_dma = snrt_mcycle();
                snrt_dma_txid_t txid_ifmap =
                    snrt_dma_start_2d(
                        ifmap,                         /* dst */
                        l->ifmap + ifmap_offset,       /* src */
                        embeddings * sizeof(double),   /* size */
                        embeddings * sizeof(double),   /* dst_stride */
                        embeddings * sizeof(double),   /* src_stride */
                        B_r);                          /* repetitions */

                    snrt_dma_wait_all();
                    uint32_t end_dma = snrt_mcycle();

                    // dump the ifmap for debugging
                    // for (int i = 0; i < B_r * embeddings; i++) {
                    //     dump_debug(ifmap[i]);
                    // }
            }

            snrt_cluster_hw_barrier();

            if (snrt_is_compute_core()) {
                // determine the row offset for the current compute core
                uint32_t row_offset = (B_r / num_cores) * compute_id * embeddings;
                uint32_t ldI = embeddings;
                uint32_t start_layernom = snrt_mcycle();
                transformer_layernorm_fp64(&ifmap[row_offset], ldI, B_r / num_cores, embeddings, eps);
                uint32_t end_layernom = snrt_mcycle();
            } else {
                snrt_cluster_hw_barrier();
            }

        }
        uint32_t end_loop_outer = snrt_mcycle();

        snrt_cluster_hw_barrier();

    }

    /////////////////////   Layer 2: Linear   /////////////////////
    //                      Input size  (S x E)                  //
    //                     Weights size (E x P)                  //
    //                      Output size (S x P)                  //
    //             S is tiled into Row Blocks of B_r rows        //
    //             P is tiled into Column Blocks of B_c columns  //
    ///////////////////////////////////////////////////////////////

    if (LINEAR_1 == 1) {
        // compute the tiling parameters
        uint32_t B_r_lin1 = l->S_tile_lin1; // number of rows per row block
        uint32_t B_c_lin1 = l->P_tile_lin1; // number of columns per column block
        uint32_t T_r_lin1 = l->seq_len / B_r_lin1; // number of row blocks
        uint32_t T_c_lin1 = l->positional_embeddings / B_c_lin1; // number of column blocks

        dump_index(B_r_lin1);
        dump_index(B_c_lin1);
        dump_index(T_r_lin1);
        dump_index(T_c_lin1);

        // compute the size of the matrices
        uint32_t ifmap_tcdm_lin1 = B_r_lin1 * embeddings * sizeof(double);
        uint32_t weights_q_tiled_size = embeddings * B_c_lin1 * sizeof(double);
        uint32_t weights_k_tiled_size = weights_q_tiled_size;
        uint32_t weights_v_tiled_size = weights_q_tiled_size;
        uint32_t key_matrix_size = B_r_lin1 * B_c_lin1 * sizeof(double);
        uint32_t query_matrix_size = B_r_lin1 * B_c_lin1 * sizeof(double);
        uint32_t value_matrix_size = B_r_lin1 * B_c_lin1 * sizeof(double);
        
        // here we define the matrices that will be stored back in DRAM
        uint32_t q_lin_size = l->seq_len * l->positional_embeddings * sizeof(double);
        uint32_t k_lin_size = l->positional_embeddings * l->seq_len * sizeof(double);
        uint32_t v_lin_size = l->positional_embeddings * l->seq_len * sizeof(double);

        // allocate memory in TCDM
        void *tcdm_ptr = (double *)snrt_l1_next();
        double *ifmap_lin1 = tcdm_ptr;
        tcdm_ptr += ifmap_tcdm_lin1;
        double *weights_q = tcdm_ptr;
        tcdm_ptr += weights_q_tiled_size;
        double *weights_k = tcdm_ptr;
        tcdm_ptr += weights_k_tiled_size;
        double *weights_v = tcdm_ptr;
        tcdm_ptr += weights_v_tiled_size;
        double *key = tcdm_ptr;
        tcdm_ptr += key_matrix_size;
        double *query = tcdm_ptr;
        tcdm_ptr += query_matrix_size;
        double *value = tcdm_ptr;
        tcdm_ptr += value_matrix_size;

        double used_memory_kB =  (double)((uint64_t)tcdm_ptr - (uint64_t)snrt_l1_next()) / 1024.0f;

        dump_debug(used_memory_kB);

        uint32_t start_loop_outer = snrt_mcycle();
        for (int t_r = 0; t_r < T_r_lin1; t_r++) {
            uint32_t ifmap_offset = t_r * B_r_lin1 * embeddings;
            uint32_t start_dma = snrt_mcycle();
            if (!snrt_is_compute_core()) {
                snrt_dma_txid_t txid_ifmap = 
                    snrt_dma_start_2d(
                        ifmap_lin1,                     /* dst */
                        l->ifmap + ifmap_offset,        /* src */
                        embeddings * sizeof(double),    /* size */
                        embeddings * sizeof(double),    /* dst_stride */
                        embeddings * sizeof(double),    /* src_stride */
                        B_r_lin1);                      /* repetitions */

                    snrt_dma_wait_all();

                    // // dump the ifmap
                    // for (int i = 0; i < B_r_lin1 * embeddings; i++) {
                    //     dump_debug(ifmap_lin1[i]);
                    //     printf("ifmap[%d] = %f\n", i, ifmap_lin1[i]);
                    // }
            }

            uint32_t end_dma = snrt_mcycle();

            snrt_cluster_hw_barrier();

            uint32_t start_loop_inner = snrt_mcycle();
            for (int t_c = 0; t_c < T_c_lin1; t_c++) {
                uint32_t start_dma = snrt_mcycle();
                // weights: E x B_c
                uint32_t weights_offset = t_c * B_c_lin1;
                if (!snrt_is_compute_core()) {
                    snrt_dma_txid_t txid_weights_q = 
                        snrt_dma_start_2d(
                            weights_q,                                  /* dst */
                            l->weights_q + weights_offset,              /* src */
                            B_c_lin1 * sizeof(double),                  /* size */
                            B_c_lin1 * sizeof(double),                  /* dst_stride */
                            l->positional_embeddings * sizeof(double),  /* src_stride */
                            l->embeddings);                             /* repetitions */

                    snrt_dma_txid_t txid_weights_k =
                        snrt_dma_start_2d(
                            weights_k,                                  /* dst */
                            l->weights_k + weights_offset,              /* src */
                            B_c_lin1 * sizeof(double),                  /* size */
                            B_c_lin1 * sizeof(double),                  /* dst_stride */
                            l->positional_embeddings * sizeof(double),  /* src_stride */
                            l->embeddings);                             /* repetitions */

                    snrt_dma_txid_t txid_weights_v =
                        snrt_dma_start_2d(
                            weights_v,                                  /* dst */
                            l->weights_v + weights_offset,              /* src */
                            B_c_lin1 * sizeof(double),                  /* size */
                            B_c_lin1 * sizeof(double),                  /* dst_stride */
                            l->positional_embeddings * sizeof(double),  /* src_stride */
                            l->embeddings);                             /* repetitions */

                    snrt_dma_wait_all();

                    // dump the weights for debugging
                    // for (int i = 0; i < B_c_lin1 * l->embeddings; i++) {
                    //     dump_debug(weights_q[i]);
                    //     dump_debug(weights_k[i]);
                    //     dump_debug(weights_v[i]);
                    // }

                }
                uint32_t end_dma = snrt_mcycle();

                snrt_cluster_hw_barrier();

                if (snrt_is_compute_core()) {
                    // compute the gemm for the current row block and column block
                    uint32_t row_offset = (B_r_lin1 / num_cores) * compute_id * embeddings;
                    // printf("core %d: row_offset = %d\n", compute_id, row_offset);
                    // ifmap: B_r x E, weights: E x B_c
                    uint32_t start_gemm = snrt_mcycle();
                    gemm_fp64_baseline(B_r_lin1 / num_cores, B_c_lin1, l->embeddings,
                                        &ifmap_lin1[row_offset], l->embeddings, 0,
                                        weights_q, B_c_lin1, 0, 
                                        &query[row_offset], B_c_lin1, 0.0f);
                    gemm_fp64_baseline(B_r_lin1 / num_cores, B_c_lin1, l->embeddings,
                                        &ifmap_lin1[row_offset], l->embeddings, 0,
                                        weights_k, B_c_lin1, 0, 
                                        &key[row_offset], B_c_lin1, 0.0f);
                    gemm_fp64_baseline(B_r_lin1 / num_cores, B_c_lin1, l->embeddings,
                                        &ifmap_lin1[row_offset], l->embeddings, 0,
                                        weights_v, B_c_lin1, 0, 
                                        &value[row_offset], B_c_lin1, 0.0f);
                    uint32_t end_gemm = snrt_mcycle();
                } else {
                    // snrt_cluster_hw_barrier();
                }

                snrt_cluster_hw_barrier();

                // write the matrices back to DRAM
                uint32_t write_back_offset = t_r * B_r_lin1 * l->positional_embeddings + t_c * B_c_lin1;
                uint32_t start_dma_write_back = snrt_mcycle();
                if (!snrt_is_compute_core()) {
                    snrt_dma_txid_t txid_query = 
                        snrt_dma_start_2d(
                            l->Q_lin + write_back_offset,               /* dst */
                            query,                                      /* src */
                            B_c_lin1 * sizeof(double),                  /* size */
                            l->positional_embeddings * sizeof(double),  /* dst_stride */
                            B_c_lin1 * sizeof(double),                  /* src_stride */
                            B_r_lin1 / num_cores);                      /* repetitions */

                    snrt_dma_txid_t txid_key =
                        snrt_dma_start_2d(
                            l->K_lin + write_back_offset,               /* dst */
                            key,                                        /* src */
                            B_c_lin1 * sizeof(double),                  /* size */
                            l->positional_embeddings * sizeof(double),  /* dst_stride */
                            B_c_lin1 * sizeof(double),                  /* src_stride */
                            B_r_lin1 / num_cores);                      /* repetitions */

                    snrt_dma_txid_t txid_value =
                        snrt_dma_start_2d(
                            l->V_lin + write_back_offset,               /* dst */
                            value,                                      /* src */
                            B_c_lin1 * sizeof(double),                  /* size */
                            l->positional_embeddings * sizeof(double),  /* dst_stride */
                            B_c_lin1 * sizeof(double),                  /* src_stride */
                            B_r_lin1 / num_cores);                      /* repetitions */

                    snrt_dma_wait_all();
                }

                uint32_t end_dma_write_back = snrt_mcycle();
            }
            uint32_t end_loop_inner = snrt_mcycle();

        }
        uint32_t end_loop_outer = snrt_mcycle();

        snrt_cluster_hw_barrier();

    }

    /////////////////////   Layer 3: Flash Attention   /////////////////////
    //                       Input size  (S x P)                          //
    //                       Output size (S x P)                          //
    //              S is tiled into Row Blocks of B_r rows                //
    //              S is tiled into Column Blocks of B_c columns          //
    ////////////////////////////////////////////////////////////////////////

    // TODO: Check if it implemented correctly!!!
    if (FLASH_ATTENTION == 1) {
        // compute the tiling parameters
        uint32_t B_r_fa = l->Br_tile_fa; // number of rows per row block
        uint32_t B_c_fa = l->Bc_tile_fa; // number of columns per column block
        uint32_t T_r_fa = l->seq_len / B_r_fa; // number of row blocks
        uint32_t T_c_fa = l->seq_len / B_c_fa; // number of column blocks

        // dump_index(B_r_fa);
        // dump_index(B_c_fa);
        // dump_index(T_r_fa);
        // dump_index(T_c_fa);

        // compute the size of the matrices
        uint32_t q_fa_size = B_r_fa * l->positional_embeddings_fa * sizeof(double);
        uint32_t k_fa_size = B_c_fa * l->positional_embeddings_fa * sizeof(double);
        uint32_t v_fa_size = B_c_fa * l->positional_embeddings_fa * sizeof(double);
        uint32_t s_fa_size = B_r_fa * B_c_fa * sizeof(double);
        uint32_t p_fa_size = B_r_fa * B_c_fa * sizeof(double);
        uint32_t o_fa_size = B_r_fa * l->positional_embeddings_fa * sizeof(double);
        uint32_t m_i_size = B_r_fa * sizeof(double);
        uint32_t m_i_prev_size = m_i_size;
        uint32_t l_i_size = B_r_fa * sizeof(double);
        uint32_t shifted_exp_size = B_r_fa * sizeof(double);

        // allocate memory in TCDM
        void *tcdm_ptr = (double *)snrt_l1_next();
        double *Q_fa = tcdm_ptr;
        tcdm_ptr += q_fa_size;
        double *K_fa = tcdm_ptr;
        tcdm_ptr += k_fa_size;
        double *V_fa = tcdm_ptr;
        tcdm_ptr += v_fa_size;
        double *S_fa = tcdm_ptr;
        tcdm_ptr += s_fa_size;
        double *P_fa = tcdm_ptr;
        tcdm_ptr += p_fa_size;
        double *O_fa = tcdm_ptr;
        tcdm_ptr += o_fa_size;
        double *m_i = tcdm_ptr;
        tcdm_ptr += m_i_size;
        double *m_i_prev = tcdm_ptr;
        tcdm_ptr += m_i_prev_size;
        double *l_i = tcdm_ptr;
        tcdm_ptr += l_i_size;
        double shifted_exp;
        double row_sum;

        double used_memory_kB =  (double)((uint64_t)tcdm_ptr - (uint64_t)snrt_l1_next()) / 1024.0f;

        dump_debug(used_memory_kB);

        uint32_t start_loop_outer = snrt_mcycle();
        for (int t_r = 0; t_r < T_r_fa; t_r++) {
            uint32_t start_dma = snrt_mcycle();
            if (!snrt_is_compute_core()) {
                uint32_t q_fa_offset = t_r * B_r_fa * l->positional_embeddings_fa;
                // printf("q_fa_offset = %d\n", q_fa_offset);
                // load the Q tile
                snrt_dma_txid_t txid_q_fa = 
                    snrt_dma_start_2d(
                        Q_fa,                                           /* dst */
                        l->Q_fa + q_fa_offset,                          /* src */
                        l->positional_embeddings_fa * sizeof(double),   /* size */
                        l->positional_embeddings_fa * sizeof(double),   /* dst_stride */
                        l->positional_embeddings_fa * sizeof(double),   /* src_stride */
                        B_r_fa);                                        /* repetitions */

                snrt_dma_wait_all();  

                // // print matrix for debugging
                // for (int i = 0; i < B_r_fa * l->positional_embeddings_fa; i++) {
                //     dump_debug(Q_fa[i]);
                //     printf("Q_fa[%d] = %f\n", i, Q_fa[i]);
                // }
            }
            uint32_t end_dma = snrt_mcycle();

            snrt_cluster_hw_barrier();

            // initialize m_i, m_i_prev, l_i
            for (int i = 0; i < B_r_fa / num_cores; i++) {
                m_i[i + (B_r_fa / num_cores) * compute_id] = -INFINITY;
                m_i_prev[i + (B_r_fa / num_cores) * compute_id] = -INFINITY;
                l_i[i + (B_r_fa / num_cores) * compute_id] = 0.0f;
            }

            row_sum = 0.0;

            uint32_t start_loop_inner = snrt_mcycle();
            for (int t_c = 0; t_c < T_c_fa; t_c++) {
                // K: P x B_c, V: B_c x P
                uint32_t k_fa_offset = t_c * B_c_fa * l->positional_embeddings_fa;
                uint32_t v_fa_offset = t_c * B_c_fa * l->positional_embeddings_fa;

                uint32_t start_dma = snrt_mcycle();
                if (!snrt_is_compute_core()) {
                    // load the K tile
                    snrt_dma_txid_t txid_k_fa = 
                        snrt_dma_start_2d(
                            K_fa,                                       /* dst */
                            l->K_fa + k_fa_offset,                      /* src */
                            B_c_fa * sizeof(double),                    /* size */
                            B_c_fa * sizeof(double),                    /* dst_stride */
                            l->positional_embeddings_fa * sizeof(double),  /* src_stride */
                            l->positional_embeddings_fa);                  /* repetitions */

                    // load the V tile
                    snrt_dma_txid_t txid_v_fa = 
                        snrt_dma_start_2d(
                            V_fa,                                       /* dst */
                            l->V_fa + v_fa_offset,                      /* src */
                            l->positional_embeddings_fa * sizeof(double),  /* size */
                            l->positional_embeddings_fa * sizeof(double),  /* dst_stride */
                            l->positional_embeddings_fa * sizeof(double),  /* src_stride */
                            B_c_fa);                                    /* repetitions */

                    snrt_dma_wait_all();
                }
                uint32_t end_dma = snrt_mcycle();

                snrt_cluster_hw_barrier();

                // Matrix Multiplication S = Q * K^T
                if (snrt_is_compute_core()) {
                    // compute the gemm for the current row block and column block
                    uint32_t row_offset = (B_r_fa / num_cores) * compute_id * l->positional_embeddings_fa;
                    // every core writes to a different row of the S matrix
                    uint32_t tile_offset = (B_r_fa / num_cores) * compute_id * B_c_fa;
                    // dump_idx(row_offset);
                    uint32_t start_gemm = snrt_mcycle();
                    gemm_fp64_baseline(B_r_fa / num_cores, B_c_fa, l->positional_embeddings_fa,
                                        &Q_fa[row_offset], l->positional_embeddings_fa, 0,
                                        K_fa, l->positional_embeddings_fa, 1, 
                                        &S_fa[tile_offset], B_c_fa, 0.0f);
                    uint32_t end_gemm = snrt_mcycle();

                    snrt_cluster_hw_barrier();

                    // debug print the S matrix
                    // for (int i = 0; i < (B_r_fa / num_cores); i++) {
                    //     for (int j = 0; j < B_c_fa; j++) {
                    //         dump_debug(S_fa[i * B_c_fa + j + tile_offset]);
                    //     }
                    // } 

                    // next we determine the maximum value of each row
                    uint32_t offset = (B_r_fa / num_cores) * compute_id;
                    uint32_t o_offset = (B_r_fa / num_cores) * compute_id * l->positional_embeddings_fa;
                    uint32_t start_stats = snrt_mcycle();
                    for (int k = 0; k < B_r_fa / num_cores; k++) {
                        m_i_prev[k + offset] = m_i[k + offset];

                        // dump_idx(k * B_c_fa  + tile_offset);

                        for (int j = 0; j < B_c_fa; j++) {

                            // dump_idx(k * B_c_fa + j + tile_offset);
                            // dump_debug(S_fa[k * B_c_fa + j + tile_offset]);
                            // printf("S_fa[%d] = %f\n", k * B_c_fa + j + tile_offset, S_fa[k * B_c_fa + j + tile_offset]);

                            if(S_fa[tile_offset + k * B_c_fa + j] > m_i[k + offset]) {
                                m_i[k + offset] = S_fa[tile_offset + k * B_c_fa + j];
                            }
                            // dump_debug(m_i[k + offset]);

                            // determine the P matrix
                            P_fa[tile_offset + k * B_c_fa + j] = expf(S_fa[tile_offset + k * B_c_fa + j] - m_i[k + offset]);
                            // printf("P_fa[%d] = expf(%f - %f) = %f\n", tile_offset + k * B_c_fa + j, S_fa[tile_offset + k * B_c_fa + j], m_i[k + offset], P_fa[tile_offset + k * B_c_fa + j]);
                            // printf("P_fa[%d] = %f\n", tile_offset + k * B_c_fa + j, P_fa[tile_offset + k * B_c_fa + j]);
                            // dump_debug(P_fa[k * B_c_fa + j]);
                            row_sum += P_fa[tile_offset + k * B_c_fa + j];
                        }

                        // dump_debug(row_sum);

                        shifted_exp = expf(m_i[k + offset] - m_i_prev[k + offset]);
                        // printf("shifted_exp = expf(%f - %f) = %f\n", m_i[k + offset], m_i_prev[k + offset], shifted_exp);

                        // printf("BEFORE: l_i[%d] = %f\n", k + offset, l_i[k + offset]);
                        if (t_c == 0) {
                            l_i[k + offset] = row_sum;
                        } else {
                            l_i[k + offset] = l_i[k + offset] * shifted_exp + row_sum;
                        }
                        // printf("AFTER: l_i[%d] = %f\n", k + offset, l_i[k + offset]);
                        // dump_debug(l_i[k + offset]);

                        row_sum = 0.0;

                        // O_ij = diag(shifted_exp)^(-1) O_i(j-1) + P_ij * V_j
                        if (t_c == 0) {
                            gemm_fp64_baseline(1, B_c_fa, l->positional_embeddings_fa,
                                                &P_fa[tile_offset + k * B_c_fa], B_c_fa, 0,
                                                V_fa, l->positional_embeddings_fa, 0,
                                                &O_fa[o_offset + k * l->positional_embeddings_fa], l->positional_embeddings_fa, 0.0f);
                        } else {
                            gemm_fp64_baseline(1, B_c_fa, l->positional_embeddings_fa,
                                                &P_fa[tile_offset + k * B_c_fa], B_c_fa, 0,
                                                V_fa, l->positional_embeddings_fa, 0,
                                                &O_fa[o_offset + k * l->positional_embeddings_fa], l->positional_embeddings_fa, shifted_exp);
                        }

                    } // end of B_r loop
                    uint32_t end_stats = snrt_mcycle();

                } else {
                    snrt_cluster_hw_barrier();
                }
            } // end of T_c loop

            snrt_cluster_hw_barrier();

            // O_i = diag(l_i_Tc) ^-1 * O_i
            for (int i = 0; i < B_r_fa / num_cores; i++) {
                for (int j = 0; j < l->positional_embeddings_fa; j++) {
                    O_fa[i * l->positional_embeddings_fa + j + (B_r_fa / num_cores) * compute_id * l->positional_embeddings_fa] 
                                        /= l_i[i + (B_r_fa / num_cores) * compute_id];
                }
            }

            // write back O_fa as the i-th block of the output matrix
            uint32_t start_dma_write_back = snrt_mcycle();
            if (!snrt_is_compute_core()) {
                uint32_t o_fa_offset = t_r * B_r_fa * l->positional_embeddings_fa;
                // printf("o_fa_offset = %d\n", o_fa_offset);
                snrt_dma_txid_t txid_o_fa = 
                    snrt_dma_start_2d(
                        l->O + o_fa_offset,                             /* dst */
                        O_fa,                                           /* src */
                        l->positional_embeddings_fa * sizeof(double),   /* size */
                        l->positional_embeddings_fa * sizeof(double),   /* dst_stride */
                        l->positional_embeddings_fa * sizeof(double),   /* src_stride */
                        B_r_fa);                                        /* repetitions */

                snrt_dma_wait_all();  
            }
            uint32_t end_dma_write_back = snrt_mcycle();

        } // end of T_r loop
        uint32_t end_loop_outer = snrt_mcycle();

        snrt_cluster_hw_barrier();
    }

    snrt_global_barrier();

    ///////////////////// Layer 4: Concatenation /////////////////////
    //                    Input size (S x (H x P))                  //
    //                   Weights size ((H x P) x E)                 //
    //                      Output size (S x E)                     //
    //             S is tiled into Row Blocks of B_r rows           //
    //////////////////////////////////////////////////////////////////

    if (CONCAT == 1) {
        uint32_t cluster_id = snrt_cluster_idx();
        uint32_t core_id = snrt_cluster_core_idx();
        uint32_t num_clusters = snrt_cluster_num();
        uint32_t compute_id = snrt_global_core_idx();
        uint32_t cluster_core_id = snrt_cluster_core_idx();
        uint32_t num_cores = snrt_cluster_compute_core_num();
        uint32_t num_heads = l->heads;

        // INFO: we can only compute on as many heads as we have clusters
        if (num_heads > num_clusters) {
            num_heads = num_clusters;
        }

        // compute the tiling parameters
        uint32_t B_r_lin2 = l->Br_tile_lin2; // number of rows per row block
        uint32_t B_c_lin2 = l->Bc_tile_lin2; // number of columns per column block
        uint32_t T_r_lin2 = l->seq_len / B_r_lin2; // number of row blocks
        uint32_t T_c_lin2 = l->embeddings_lin2 / B_c_lin2; // number of column blocks

        // dump_idx(cluster_id);
        
        // if (core_id == 0 && cluster_id == 0) {
        //     dump_idx(B_r_lin2);
        //     dump_idx(B_c_lin2);
        //     dump_idx(T_r_lin2);
        //     dump_idx(T_c_lin2);
        // }

        // every cluster computes on a different head
        // and afterward we add the partial results together

        // compute the size of the matrices
        uint32_t ifmap_tcdm_lin2 = B_r_lin2 * l->positional_embeddings * sizeof(double);
        uint32_t weights_tcdm_lin2 = l->positional_embeddings * B_c_lin2 * sizeof(double);
        uint32_t ofmap_tcdm_lin2 = B_r_lin2 * B_c_lin2 * sizeof(double);
        // we use below variable for summing up the partial results
        uint32_t cluster_ofmap_tcdm_lin2 = ofmap_tcdm_lin2;

        // here we define the matrices that will be stored back in DRAM
        uint32_t O_lin2_size = l->seq_len * l->embeddings_lin2 * sizeof(double);

        // allocate memory in TCDM
        void *tcdm_ptr = (double *)snrt_l1_next();
        double *ifmap_lin2 = tcdm_ptr;
        tcdm_ptr += ifmap_tcdm_lin2;
        double *weights_lin2 = tcdm_ptr;
        tcdm_ptr += weights_tcdm_lin2;
        double *ofmap_lin2 = tcdm_ptr;
        tcdm_ptr += ofmap_tcdm_lin2;
        double *cluster_ofmap_lin2 = tcdm_ptr;
        tcdm_ptr += cluster_ofmap_tcdm_lin2;

        // double used_memory_kB =  (double)((uint64_t)tcdm_ptr - (uint64_t)snrt_l1_next()) / 1024.0f;
        // dump_debug(used_memory_kB);

        // determine the column offset of the ifmap for the current cluster
        uint32_t cluster_ifmap_offset = cluster_id * l->seq_len * l->positional_embeddings_fa;
        // if (core_id == 0) {
        //     dump_idx(cluster_id);
        //     dump_idx(cluster_ifmap_offset);
        // }
        // determine the column offset of the weights for the current cluster
        uint32_t cluster_weights_offset = cluster_id * l->positional_embeddings_fa * l->embeddings_lin2;

        uint32_t start_loop_outer = snrt_mcycle();
        for (int t_r = 0; t_r < T_r_lin2; t_r++) {
            uint32_t start_dma = snrt_mcycle();
            if (!snrt_is_compute_core()) {
                uint32_t ifmap_offset = t_r * B_r_lin2 * l->positional_embeddings_fa + cluster_ifmap_offset;
                // if (core_id == 0) {
                //     dump_idx(cluster_id);
                //     dump_idx(ifmap_offset);
                // }
                // load the ifmap tile
                snrt_dma_txid_t txid_ifmap = 
                    snrt_dma_start_2d(
                        ifmap_lin2,                                      /* dst */
                        l->ifmap_lin2 + ifmap_offset,                    /* src */
                        l->positional_embeddings_fa * sizeof(double),    /* size */
                        l->positional_embeddings_fa * sizeof(double),    /* dst_stride */
                        l->positional_embeddings_fa * sizeof(double),    /* src_stride */
                        B_r_lin2);                                    /* repetitions */

                snrt_dma_wait_all();

                // for (int i = 0; i < B_r_lin2 * l->positional_embeddings_fa; i++) {
                //     dump_idx(i + ifmap_offset);
                //     dump_debug(ifmap_lin2[i]);
                //     // printf("ifmap[%d] = %f\n", i + ifmap_offset, ifmap_lin2[i]);
                // }

            }
            uint32_t end_dma = snrt_mcycle();

            snrt_cluster_hw_barrier();

            uint32_t start_loop_inner = snrt_mcycle();
            for (int t_c = 0; t_c < T_c_lin2; t_c++) {
                // weights: P x B_c 
                uint32_t weights_offset = t_c * B_c_lin2 * l->positional_embeddings_fa + cluster_weights_offset;
                uint32_t start_dma = snrt_mcycle();
                if (!snrt_is_compute_core()) {
                    // load the weights tile
                    snrt_dma_txid_t txid_weights = 
                        snrt_dma_start_2d(
                            weights_lin2,                                   /* dst */
                            l->weights_lin2 + weights_offset,               /* src */
                            B_c_lin2 * sizeof(double),                      /* size */
                            B_c_lin2 * sizeof(double),                      /* dst_stride */
                            l->positional_embeddings_fa * sizeof(double),   /* src_stride */
                            l->positional_embeddings_fa);                   /* repetitions */

                    snrt_dma_wait_all();

                    // for (int i = 0; i < B_c_lin2 * l->positional_embeddings_fa; i++) {
                    //     dump_idx(i + weights_offset);
                    //     dump_debug(weights_lin2[i]);
                    //     // printf("weights[%d] = %f\n", i + weights_offset, weights_lin2[i]);
                    // }
                }
                uint32_t end_dma = snrt_mcycle();

                snrt_cluster_hw_barrier();

                if (snrt_is_compute_core()) {
                    // compute the gemm for the current row block and column block
                    uint32_t row_offset = (B_r_lin2 / num_cores) * cluster_core_id * l->positional_embeddings_fa;
                    // dump_id(cluster_core_id);
                    // dump_ct(row_offset);
                    uint32_t ofmap_offset = (B_r_lin2 / num_cores) * cluster_core_id * B_c_lin2;
                    uint32_t start_gemm = snrt_mcycle();
                    gemm_fp64_baseline(B_r_lin2 / num_cores, B_c_lin2, l->positional_embeddings_fa,
                                        &ifmap_lin2[row_offset], l->positional_embeddings_fa, 0,
                                        weights_lin2, l->positional_embeddings_fa, 0, 
                                        &ofmap_lin2[ofmap_offset], B_c_lin2, 0.0f);
                    uint32_t end_gemm = snrt_mcycle();

                    snrt_cluster_hw_barrier();

                    // for (int i = 0; i < B_r_lin2 / num_cores; i++) {
                    //     for (int j = 0; j < B_c_lin2; j++) {
                    //         dump_idx(i * B_c_lin2 + j + ofmap_offset);
                    //         dump_debug(ofmap_lin2[i * B_c_lin2 + j + ofmap_offset]);
                    //     }
                    // }
                } else {
                    snrt_cluster_hw_barrier();
                }
            } // end of T_c loop
            uint32_t end_loop_inner = snrt_mcycle();

            snrt_cluster_hw_barrier();
            // now we will add the partial results together
            // in a logarithmic reduction fashion
            uint32_t cl_offset = 0x40000;
            uint32_t is_active = 0;
            uint32_t is_sender = 0;
            // num_levels: number of levels in the reduction tree
            int num_levels = ceil(log2(num_clusters));
            uint32_t start_reduction = snrt_mcycle();
            for (int level = 0; level < num_levels; level++) {
                // determine whether the current cluster is an active cluster
                // an active cluster is a cluster that is part of the reduction tree
                is_active = (cluster_id % (1 << level)) == 0;
                if (is_active == 1) {
                    // check if the current cluster is a sender or a receiver
                    if (cluster_id == 0) {
                        is_sender = 0;
                    } else {
                        is_sender = (cluster_id % (1 << (level + 1))) != 0;
                    }

                    // if the cluster is a sender we perform a DMA transfer
                    if (is_sender == 1) {
                        // determine the destination address
                        double *data_dst = cluster_ofmap_lin2 - (1 << level) * cl_offset;
                        if (!snrt_is_compute_core()) {
                            for (int i = 0; i < B_r_lin2 * B_c_lin2; i++) {
                                dump_debug(ofmap_lin2[i]);
                            }
                            // printf("cluster_id = %d, level = %d, data_src = %d, data_dst = %d\n", cluster_id, level, data_src, data_dst);
                            snrt_dma_txid_t txid = 
                                snrt_dma_start_1d(
                                    data_dst,                          /* dst */
                                    ofmap_lin2,                        /* src */
                                    ofmap_tcdm_lin2 * sizeof(double)); /* size */

                            snrt_dma_wait_all();

                            // for (int i = 0; i < B_r_lin2 * B_c_lin2; i++) {
                            //     dump_debug(data_dst[i]);
                            // }
                        }
                    }

                    snrt_cluster_hw_barrier();

                    // active clusters that are not a sender perform the addition of the partial tiles
                    // if (is_active == 1 && is_sender == 0) {
                    //     // perform the addition
                    //     uint32_t row_offset = core_id * (B_r_lin2 / num_cores) * B_c_lin2;
                    //     for (int row = 0; row < B_r_lin2 / num_cores; row++) {
                    //         for (int col = 0; col < B_c_lin2; col++) {
                    //             ofmap_lin2[row_offset + row * B_c_lin2 + col] += cluster_ofmap_lin2[row_offset + row * B_c_lin2 + col];
                    //         }
                    //     }
                    // }

                    // snrt_cluster_hw_barrier();

                }

            }
            uint32_t end_reduction = snrt_mcycle();

            // write back O_lin2 as the i-th block of the output matrix
            uint32_t start_dma_write_back = snrt_mcycle();
            if (!snrt_is_compute_core()) {
                uint32_t o_lin2_offset = t_r * B_r_lin2 * l->embeddings_lin2;
                // printf("o_lin2_offset = %d\n", o_lin2_offset);
                snrt_dma_txid_t txid_o_lin2 = 
                    snrt_dma_start_2d(
                        l->O_lin2 + o_lin2_offset,                      /* dst */
                        ofmap_lin2,                                     /* src */
                        l->embeddings_lin2 * sizeof(double),            /* size */
                        l->embeddings_lin2 * sizeof(double),            /* dst_stride */
                        B_c_lin2 * sizeof(double),                      /* src_stride */
                        B_r_lin2);                                      /* repetitions */

                snrt_dma_wait_all();  
            } 
            uint32_t end_dma_write_back = snrt_mcycle();
        } // end of T_r loop
        uint32_t end_loop_outer = snrt_mcycle();
        snrt_cluster_hw_barrier();
    } // end of CONCAT
}

/**
 * @brief  Transformer layer
 *
 * @param l transformer_layer struct that holds addresses and parameters in FP32
 *
 */
static inline void transformer_layer_fp32(transformer_layer_fp32_t *const l) {
    uint32_t compute_id = snrt_global_core_idx();
    uint32_t num_cores = snrt_cluster_compute_core_num();
}