// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "dnn.h"
#include "math.h"
#include "snrt.h"


#define UNROLL 4
#define USE_SSR 0
#define PREC 32
/**
 * @struct layernorm_layer_struct
 * @brief This structure contains all parameters necessary
 *        for computing the LayerNorm activation function
 * @var layernorm_layer_struct::batch_size
 * Size of each input sample
 * @var layernorm_layer_struct::seq_len
 * Size of each output sample
 * @var layernorm_layer_struct::embeddings
 * Number of hidden dimensions
 * @var layernorm_layer_struct::n_tiles
 * Number of tiles to split the data into
 * @var layernorm_layer_struct::ifmap
 * Pointer to input feature map
 * @var layernorm_layer_struct::ofmap
 * Pointer to output feature map
 */

dump_float(debug, 8);
dump_float(val, 9);
dump_uint(value, 7);
typedef struct layernorm_layer_struct {
    uint32_t batch_size;
    uint32_t seq_len;
    uint32_t embeddings;
    uint32_t n_tiles;
    float eps;
    void *ifmap;
    void *ofmap;
    precision_t dtype;
} layernorm_layer_t;

/**
 * Single-cluster implementation of a layernorm tile (data assumed in TCDM)
 */
static inline void layernorm_fp32(float *input, float *output,
                                  int32_t batch_size, int32_t seq_len,
                                  int32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        // Get parameters for every core's tile
        // offset: offset between data accessed by every core (for
        //         corresponding iterations)
        // stride: offset between data accessed by the same core in
        //         consecutive iterations
        // tile_seq_len: fraction of the sequence assigned to each core
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        float *core_itile = input + offset;
        float *core_otile = output + offset;

        // get derived layernorm quantities
        uint32_t batch_offset = seq_len * embeddings;

        // compute the mean and variance along the last dimension
        float mean = 0.0;  // max value of the current core
        float var = 0.0;   // sum of the exp values of the current core
        for (int32_t b = 0; b < batch_size; b++) {
            for (int32_t s = 0; s < tile_seq_len; s++) {
                // if (snrt_cluster_core_idx() == 0) {
                //     dump_value(s);
                // }
                mean = 0.0;
                var = 0.0;

                for (int32_t i = 0; i < embeddings; i++) {
                    mean += core_itile[b * batch_offset + s * stride + i];
                }
                mean /= embeddings;

                for (int32_t i = 0; i < embeddings; i++) {
                    // dump_debug(core_itile[b * batch_offset + s * stride + i] - mean);
                    var +=
                        (core_itile[b * batch_offset + s * stride + i] - mean) *
                        (core_itile[b * batch_offset + s * stride + i] - mean);
                }
                var /= embeddings;
                // dump_debug(var);

                // compute the shifted value of the current row
                for (int32_t i = 0; i < embeddings; i++) {
                    core_otile[b * batch_offset + s * stride + i] =
                        (core_itile[b * batch_offset + s * stride + i] - mean) /
                        (var + eps);//sqrtf(var + eps);
                }
            }
        }

        snrt_fpu_fence();
    }
}

static inline void layernorm_fp32_opt(float *input, float *output,
                                  int32_t batch_size, int32_t seq_len,
                                  int32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        // dump_value(snrt_cluster_core_idx());
        // Get parameters for every core's tile
        // offset: offset between data accessed by every core (for
        //         corresponding iterations)
        // stride: offset between data accessed by the same core in
        //         consecutive iterations
        // tile_seq_len: fraction of the sequence assigned to each core
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        float *core_itile = input + offset;
        float *core_otile = output + offset;

        // get derived layernorm quantities
        uint32_t batch_offset = seq_len * embeddings;

        // compute the mean and variance along the last dimension
        float mean_tot = 0.0;  // max value of the current core
        float var_tot = 0.0;   // sum of the exp values of the current core
        float divisor = 0.0;   // sqrt(var + eps)
        v2f32 mean_reg = {0.0, 0.0};
        for (int32_t b = 0; b < batch_size; b++) {
            // dump_value(111);

            // Unrolled loop:
            // for (int32_t s = 0; s < tile_seq_len; s++) {
            //     ssr_enable();
            //      for (int32_t i = 0; i < embeddings / unroll; i++) {
            //          for (int32_t j = 0; j < unroll; j++) {
            //              mean += core_itile[s * stride + i * unroll + j];
            //          }
            //      }
            //     ssr_disable();
            //     mean /= embeddings;
            //     for (int32_t i = 0; i < embeddings / unroll; i++) {
            //         for (int32_t j = 0; j < unroll; j++) {
            //             var +=
            //                 (core_itile[s * stride + i * unroll + j] - mean) *
            //                 (core_itile[s * stride + i * unroll + j] - mean);
            //         }
            //     }
            //     var /= embeddings;
            //     for (int32_t i = 0; i < embeddings / unroll; i++) {
            //         for (int32_t j = 0; j < unroll; j++) {
            //             core_otile[s * stride + i * unroll + j] =
            //                 (core_itile[s * stride + i * unroll + j] - mean) /
            //                 sqrtf(var + eps);
            //         }
            //     }
            // }
            
            // define the bounds for the loops
            const uint32_t ssr0_b[4] = {UNROLL, embeddings / (UNROLL * 2), 2, tile_seq_len};
            // INFO: increments MUST be 8 byte aligned!!
            const uint32_t ssr0_i[4] = {8, UNROLL * 8, 0, stride * 8};

            snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3], 
                            ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3], 
                            ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_loop_4d(SNRT_SSR_DM2, ssr0_b[0], ssr0_b[1], ssr0_b[2] - 1, ssr0_b[3], 
                            ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, core_itile);
            snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_4D, core_otile);
            snrt_ssr_read(SNRT_SSR_DM2, SNRT_SSR_4D, core_otile);


            // kernel progresses two values in each iteration
            const uint32_t n_frep = embeddings / (UNROLL * 2);

            // dump_value(222);

            for (int32_t s = 0; s < tile_seq_len; s++) {
                // dump_value(s);
                float mean[UNROLL] = {0.0, 0.0, 0.0, 0.0};
                float var[UNROLL] = {0.0, 0.0, 0.0, 0.0};
                mean_tot = 0.0;
                v2f32 var_reg[UNROLL];
                v2f32 pow[UNROLL];
                v2f32 div;
                var_tot = 0.0;
                snrt_ssr_enable();
                asm volatile(
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfsum.s %[mean0], ft0 \n" // mean0 += ft0[0] + ft0[1]
                    "vfsum.s %[mean1], ft0 \n" // mean1 += ft0[2] + ft0[3]
                    "vfsum.s %[mean2], ft0 \n" // mean2 += ft0[4] + ft0[5]
                    "vfsum.s %[mean3], ft0 \n" // mean3 += ft0[6] + ft0[7]
                    "fadd.s %[mean0], %[mean0], %[mean1] \n" // mean_tot += mean0
                    "fadd.s %[mean2], %[mean2], %[mean3] \n" // mean_tot += mean1
                    "fadd.s %[mean_tot], %[mean0], %[mean2] \n"
                    : [mean0] "+f" (mean[0]), [mean1] "+f" (mean[1]), 
                      [mean2] "+f" (mean[2]), [mean3] "+f" (mean[3]),
                      [mean_tot] "+f" (mean_tot)
                    : [n_frep] "r" (n_frep - 1)
                    : "ft0", "ft1", "ft2"
                );
                // snrt_ssr_disable();
                // TODO: fix the RegWriteKnown errors due to SSR bug
                // mean_tot /= embeddings;
                // dump_debug(mean_tot);
                asm volatile (
                    // var += (ft0 - mean) * (ft0 - mean)
                    "vfcpka.s.s %[mean_reg], %[mean_tot], %[mean_tot] \n"
                    "frep.o  %[n_frep], 16, 0, 0 \n"
                    "vfsub.s %[var_reg0], ft0, %[mean_reg] \n"     // var_reg0 = [ft0[0] - mean, ft0[1] - mean]
                    "vfsub.s %[var_reg1], ft0, %[mean_reg] \n"     // var_reg1 = [ft0[2] - mean, ft0[3] - mean]
                    "vfsub.s %[var_reg2], ft0, %[mean_reg] \n"     // var_reg2 = [ft0[4] - mean, ft0[5] - mean]
                    "vfsub.s %[var_reg3], ft0, %[mean_reg] \n"     // var_reg3 = [ft0[6] - mean, ft0[7] - mean]
                    "vfadd.s ft1, %[var_reg0], %[zero] \n"         // ft1[0, 1] = [ft0[0] - mean, ft0[1] - mean]
                    "vfadd.s ft1, %[var_reg1], %[zero] \n"         // ft1[2, 3] = [ft0[2] - mean, ft0[3] - mean]
                    "vfadd.s ft1, %[var_reg2], %[zero] \n"         // ft1[3, 4] = [ft0[4] - mean, ft0[5] - mean]
                    "vfadd.s ft1, %[var_reg3], %[zero] \n"         // ft1[5, 6] = [ft0[6] - mean, ft0[7] - mean]
                    "vfmul.s %[pow0], %[var_reg0], %[var_reg0] \n" // pow0 = [var_reg0[0]^2, var_reg0[1]^2]
                    "vfmul.s %[pow1], %[var_reg1], %[var_reg1] \n"
                    "vfmul.s %[pow2], %[var_reg2], %[var_reg2] \n"
                    "vfmul.s %[pow3], %[var_reg3], %[var_reg3] \n"
                    "vfsum.s %[var0], %[pow0] \n"              // var0 = pow0[0] + pow0[1]
                    "vfsum.s %[var1], %[pow1] \n"
                    "vfsum.s %[var2], %[pow2] \n"
                    "vfsum.s %[var3], %[pow3] \n"
                    "fadd.s %[var0], %[var0], %[var1] \n"    // var0 = var0 + var1
                    "fadd.s %[var2], %[var2], %[var3] \n"    // var2 = var2 + var3
                    "fadd.s %[var_tot], %[var0], %[var2] \n" // var_tot = var0 + var1 + var2 + var3

                    : [var_reg0] "+f" (var_reg[0]), [var_reg1] "+f" (var_reg[1]), 
                      [var_reg2] "+f" (var_reg[2]), [var_reg3] "+f" (var_reg[3]),
                      [pow0] "+f" (pow[0]), [pow1] "+f" (pow[1]), 
                      [pow2] "+f" (pow[2]), [pow3] "+f" (pow[3]),
                      [var0] "+f" (var[0]), [var1] "+f" (var[1]), 
                      [var2] "+f" (var[2]), [var3] "+f" (var[3]),
                      [var_tot] "+f" (var_tot), [mean_reg] "+f" (mean_reg)
                    : [n_frep] "r" (n_frep - 1), [mean_tot] "f" (mean_tot),
                      [zero] "f" (0.0)
                    : "ft0", "ft1", "ft2"

                );

                var_tot /= embeddings;

                // FIXME: does not work with divison and sqrtf!
                divisor = var_tot + eps;
                // mean_tot = (var_tot + eps);
                // FIXME: Assertion when reading from ft2
                asm volatile (
                    // computation: (ft0 - mean / sqrt(var + eps))
                    "vfcpka.s.s %[mean_reg], %[divisor], %[divisor] \n"
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    "vfmul.s ft1, ft2, %[mean_reg] \n"
                    : [divisor] "+f" (divisor), [mean_reg] "+f" (mean_reg)
                    : [n_frep] "r" (n_frep - 1), [zero] "f" (0.0)
                    : "ft0", "ft1", "ft2"

                );
                snrt_ssr_disable();

            }
        }

        snrt_fpu_fence();
    }
}

static inline void layernorm_fp64_opt(double *input, double *output,
                                  int32_t batch_size, int32_t seq_len,
                                  int32_t embeddings, int32_t eps) {
    if (snrt_is_compute_core()) {
        // Get parameters for every core's tile
        // offset: offset between data accessed by every core (for
        //         corresponding iterations)
        // stride: offset between data accessed by the same core in
        //         consecutive iterations
        // tile_seq_len: fraction of the sequence assigned to each core
        uint32_t offset = snrt_cluster_core_idx() * embeddings;
        uint32_t stride = snrt_cluster_compute_core_num() * embeddings;
        uint32_t tile_seq_len = seq_len / snrt_cluster_compute_core_num();
        double *core_itile = input + offset;
        double *core_otile = output + offset;

        // get derived layernorm quantities
        uint32_t batch_offset = seq_len * embeddings;

        // compute the mean and variance along the last dimension
        double mean_tot = 0.0;  // max value of the current core
        double var_tot = 0.0;   // sum of the exp values of the current core
        double divisor = 0.0;   // sqrt(var + eps)
        double mean_reg = 0.0;
        for (int32_t b = 0; b < batch_size; b++) {
            // define the bounds for the loops
            const uint32_t ssr0_b[4] = {UNROLL, embeddings / UNROLL, 2, tile_seq_len};
            // INFO: increments MUST be 8 byte aligned!!
            const uint32_t ssr0_i[4] = {8, UNROLL * 8, 0, stride * 8};

            snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3], 
                            ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3], 
                            ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_loop_4d(SNRT_SSR_DM2, ssr0_b[0], ssr0_b[1], ssr0_b[2] - 1, ssr0_b[3], 
                            ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

            snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, core_itile);
            snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_4D, core_otile);
            snrt_ssr_read(SNRT_SSR_DM2, SNRT_SSR_4D, core_otile);


            // kernel progresses two values in each iteration
            const uint32_t n_frep = embeddings / UNROLL;

            for (int32_t s = 0; s < tile_seq_len; s++) {
                double mean[UNROLL] = {0.0, 0.0, 0.0, 0.0};
                double var[UNROLL] = {0.0, 0.0, 0.0, 0.0};
                mean_tot = 0.0;
                double var_reg[UNROLL];
                double pow[UNROLL];
                double div;
                var_tot = 0.0;
                snrt_ssr_enable();
                asm volatile(
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "fadd.d %[mean0], %[mean0], ft0 \n" // mean0 += ft0[0]
                    "fadd.d %[mean1], %[mean1], ft0 \n" // mean1 += ft0[1]
                    "fadd.d %[mean2], %[mean2], ft0 \n" // mean2 += ft0[2]
                    "fadd.d %[mean3], %[mean3], ft0 \n" // mean3 += ft0[3]
                    "fadd.d %[mean0], %[mean0], %[mean1] \n" // mean_tot += mean0
                    "fadd.d %[mean2], %[mean2], %[mean3] \n" // mean_tot += mean1
                    "fadd.d %[mean_tot], %[mean0], %[mean2] \n"
                    : [mean0] "+f" (mean[0]), [mean1] "+f" (mean[1]), 
                      [mean2] "+f" (mean[2]), [mean3] "+f" (mean[3]),
                      [mean_tot] "+f" (mean_tot)
                    : [n_frep] "r" (n_frep - 1)
                    : "ft0", "ft1", "ft2"
                );
                // snrt_ssr_disable();
                // TODO: fix the RegWriteKnown errors due to SSR bug
                mean_tot /= embeddings;
                // dump_debug(mean_tot);
                asm volatile (
                    // var += (ft0 - mean) * (ft0 - mean)
                    "frep.o  %[n_frep], 16, 0, 0 \n"
                    "fsub.d %[var0], ft0, %[mean_tot] \n"     // var0 = ft0[0] - mean
                    "fsub.d %[var1], ft0, %[mean_tot] \n"     // var1 = ft0[1] - mean
                    "fsub.d %[var2], ft0, %[mean_tot] \n"     // var2 = ft0[2] - mean
                    "fsub.d %[var3], ft0, %[mean_tot] \n"     // var3 = ft0[3] - mean
                    "fadd.d ft1, %[var0], %[zero] \n"         // ft1[0, 1] = [ft0[0] - mean, ft0[1] - mean]
                    "fadd.d ft1, %[var1], %[zero] \n"         // ft1[2, 3] = [ft0[2] - mean, ft0[3] - mean]
                    "fadd.d ft1, %[var2], %[zero] \n"         // ft1[3, 4] = [ft0[4] - mean, ft0[5] - mean]
                    "fadd.d ft1, %[var3], %[zero] \n"         // ft1[5, 6] = [ft0[6] - mean, ft0[7] - mean]
                    "fmul.d %[pow0], %[var0], %[var0] \n" // pow0 = [var_reg0[0]^2, var_reg0[1]^2]
                    "fmul.d %[pow1], %[var1], %[var1] \n"
                    "fmul.d %[pow2], %[var2], %[var2] \n"
                    "fmul.d %[pow3], %[var3], %[var3] \n"
                    "fadd.s %[var0], %[pow0], %[pow1] \n"    // var0 = var0 + var1
                    "fadd.s %[var2], %[pow2], %[pow3] \n"    // var2 = var2 + var3
                    "fadd.s %[var_tot], %[var0], %[var2] \n" // var_tot = var0 + var1 + var2 + var3

                    : [var_reg0] "+f" (var_reg[0]), [var_reg1] "+f" (var_reg[1]), 
                      [var_reg2] "+f" (var_reg[2]), [var_reg3] "+f" (var_reg[3]),
                      [pow0] "+f" (pow[0]), [pow1] "+f" (pow[1]), 
                      [pow2] "+f" (pow[2]), [pow3] "+f" (pow[3]),
                      [var0] "+f" (var[0]), [var1] "+f" (var[1]), 
                      [var2] "+f" (var[2]), [var3] "+f" (var[3]),
                      [var_tot] "+f" (var_tot), [mean_reg] "+f" (mean_reg)
                    : [n_frep] "r" (n_frep - 1), [mean_tot] "f" (mean_tot),
                      [zero] "f" (0.0)
                    : "ft0", "ft1", "ft2"

                );

                var_tot /= embeddings;

                // FIXME: does not work with divison and sqrtf!
                divisor = var_tot + eps;
                // mean_tot = (var_tot + eps);
                // FIXME: Assertion when reading from ft2
                asm volatile (
                    // computation: (ft0 - mean / sqrt(var + eps))
                    "frep.o  %[n_frep], 4, 0, 0 \n"
                    "fmul.d ft1, ft2, %[divisor] \n"
                    "fmul.d ft1, ft2, %[divisor] \n"
                    "fmul.d ft1, ft2, %[divisor] \n"
                    "fmul.d ft1, ft2, %[divisor] \n"
                    : [divisor] "+f" (divisor), [mean_reg] "+f" (mean_reg)
                    : [n_frep] "r" (n_frep - 1), [zero] "f" (0.0)
                    : "ft0", "ft1", "ft2"

                );
                snrt_ssr_disable();

            }
        }

        snrt_fpu_fence();
    }
}

// /**
//  * Implementation of the LayerNorm layer for the Transformer model for FP64.
//  */
// static inline void transformer_layernorm_fp64(double *input, int32_t ldI,
//                                               int32_t seq_len, int32_t
//                                               embeddings, int32_t eps) {
//     layernorm_fp64(input, input, ldI, 0, 1, seq_len, embeddings, eps);
// }

// /**
//  * Implementation of the LayerNorm layer for the Transformer model for FP32.
//  */
// static inline void transformer_layernorm_fp32(float *input, int32_t ldI,
//                                               int32_t seq_len, int32_t
//                                               embeddings, int32_t eps) {
//     layernorm_fp32(input, input, ldI, 0, 1, seq_len, embeddings, eps);
// }

// Tiles the seq_len axis (assumes seq_len is an integer multiple of n_tiles)
// Distributes tiles to clusters (assumes n_tiles is an integer multiple of
// the number of clusters)
static inline void layernorm_layer(layernorm_layer_t l) {
    snrt_mcycle();

    // Compute the tiling parameters
    uint32_t n_tiles = l.n_tiles;
    uint32_t n_tiles_per_cluster = l.n_tiles / snrt_cluster_num();
    uint32_t tile_seq_len = l.seq_len / n_tiles;
    uint32_t tile_size = l.batch_size * tile_seq_len * l.embeddings;
    uint32_t tile_offset = tile_seq_len * l.embeddings;

    dump_val(n_tiles);
    dump_val(n_tiles_per_cluster);
    dump_val(tile_seq_len);
    dump_val(tile_size);
    dump_val(tile_offset);

    // Allocate space for arrays in TCDM (single precision)
    float *local_itile = (float *)snrt_l1_next();
    float *local_otile = local_itile + tile_size;

    // Get pointers to arrays in DRAM
    float *remote_ifmap = (float *)l.ifmap;
    float *remote_ofmap = (float *)l.ofmap;

    // Allocate space for arrays in TCDM (double precision)
    // double *local_itile = (double *)snrt_l1_next();
    // double *local_otile = local_itile + tile_size;

    // // Get pointers to arrays in DRAM
    // double *remote_ifmap = (double *)l.ifmap;
    // double *remote_ofmap = (double *)l.ofmap; 

    // Iterate tiles
    snrt_mcycle();
    for (uint32_t cluster_tile_idx = 0; cluster_tile_idx < n_tiles_per_cluster;
         cluster_tile_idx++) {
        // Calculate absolute tile index
        uint32_t tile_idx =
            snrt_cluster_idx() * n_tiles_per_cluster + cluster_tile_idx;
        // Copy input tile
        if (snrt_is_dm_core()) {
            void *remote_itile;
            if (PREC == 32) {
                // dump_value(888);
                float *remote_itile = remote_ifmap + tile_idx * tile_offset;
                snrt_dma_txid_t txid_ifmap = snrt_dma_start_2d(
                    local_itile,                                 /* dst */
                    remote_itile,                                /* src */
                    tile_seq_len * l.embeddings * sizeof(float), /* size */
                    tile_seq_len * l.embeddings * sizeof(float), /* dst_stride */
                    l.seq_len * l.embeddings * sizeof(float),    /* src_stride */
                    l.batch_size                                 /* repetitions */
                );
                snrt_dma_wait_all();
                snrt_mcycle();
                // dump_value(999);
            } else {
                double *remote_itile = remote_ifmap + tile_idx * tile_offset;
                snrt_dma_txid_t txid_ifmap = snrt_dma_start_2d(
                    local_itile,                                 /* dst */
                    remote_itile,                                /* src */
                    tile_seq_len * l.embeddings * sizeof(double), /* size */
                    tile_seq_len * l.embeddings * sizeof(double), /* dst_stride */
                    l.seq_len * l.embeddings * sizeof(double),    /* src_stride */
                    l.batch_size                                 /* repetitions */
                );
                snrt_dma_wait_all();
                snrt_mcycle();
            }
        }

        snrt_cluster_hw_barrier();

        // Compute layernorm tile
        if (USE_SSR == 0 && PREC == 32) {
            if (snrt_is_compute_core()) snrt_mcycle();
            layernorm_fp32(local_itile, local_otile, l.batch_size, tile_seq_len,
                        l.embeddings, l.eps);
            if (snrt_is_compute_core()) snrt_mcycle();
        } else if (USE_SSR == 1 && PREC == 32) {
            // dump_value(777);
            if (snrt_is_compute_core()) snrt_mcycle();
            layernorm_fp32_opt(local_itile, local_otile, l.batch_size, tile_seq_len,
                        l.embeddings, l.eps);
            if (snrt_is_compute_core()) snrt_mcycle();
            // dump_value(666);
        } else {
            if (snrt_is_compute_core()) snrt_mcycle();
            layernorm_fp64_opt(local_itile, local_otile, l.batch_size, tile_seq_len,
                        l.embeddings, l.eps);
            if (snrt_is_compute_core()) snrt_mcycle();
        }

        snrt_cluster_hw_barrier();

        // DMA transfer the ofmap to DRAM
        if (snrt_is_dm_core()) {
            // write_csr(trace, 0);
            void *remote_otile;
            if (PREC == 32) {
            snrt_mcycle();
                float *remote_otile = remote_ofmap + tile_idx * tile_offset;
                snrt_dma_txid_t txid_ofmap = snrt_dma_start_2d(
                    remote_otile,                                /* dst */
                    local_otile,                                 /* src */
                    tile_seq_len * l.embeddings * sizeof(float), /* size */
                    l.seq_len * l.embeddings * sizeof(float),    /* dst_stride */
                    tile_seq_len * l.embeddings * sizeof(float), /* src_stride */
                    l.batch_size                                 /* repetitions */
                );
                snrt_dma_wait_all();
                snrt_mcycle();
            } else {
                double *remote_otile = remote_ofmap + tile_idx * tile_offset;
                snrt_dma_txid_t txid_ofmap = snrt_dma_start_2d(
                    remote_otile,                                /* dst */
                    local_otile,                                 /* src */
                    tile_seq_len * l.embeddings * sizeof(double), /* size */
                    l.seq_len * l.embeddings * sizeof(double),    /* dst_stride */
                    tile_seq_len * l.embeddings * sizeof(double), /* src_stride */
                    l.batch_size                                 /* repetitions */
                );
                snrt_dma_wait_all();
                snrt_mcycle();
            }
        }
    }

    snrt_global_barrier();
}
