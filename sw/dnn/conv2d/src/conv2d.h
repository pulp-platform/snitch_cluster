// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "blas.h"
#include "dnn.h"
#include "snrt.h"

#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

/**
 * @struct conv_layer_struct
 * @brief This structure contains all parameters necessary for Convolutional
 * layers
 * @var conv_layer_struct::CO
 * Number of output channels
 * @var conv_layer_struct::CI
 * Number of input channels
 * @var conv_layer_struct::IH
 * Height of input feature map
 * @var conv_layer_struct::IW
 * Width of input feature map
 * @var conv_layer_struct::OH
 * Height of output feature map
 * @var conv_layer_struct::OW
 * Width of output feature map
 * @var conv_layer_struct::FH
 * Height of filter
 * @var conv_layer_struct::FW
 * Width of filter
 * @var conv_layer_struct::pad
 * Padding on all sides
 * @var conv_layer_struct::ifmap
 * Pointer to input feature map
 * @var conv_layer_struct::weights
 * Pointer to weights
 * @var conv_layer_struct::ofmap
 * Pointer to output feature map
 * @var conv_layer_struct::TILE_CI
 * Tiling factor of input channel
 * @var conv_layer_struct::cluster2cluster
 * Flag for enabling cluster 2 cluster communication
 * @var conv_layer_struct::im2col
 * Flag for enabling im2col + GEMM
 * @var conv_layer_struct::gamma
 * Pointer to gamma for BatchNorm
 * @var conv_layer_struct::beta
 * Pointer to beta for BatchNorm
 * @var gemm_layer_struct::dtype
 * Precision of Convolution layer
 */
typedef struct conv_layer_struct {
    // CONV2D
    uint32_t CO;
    uint32_t CI;
    uint32_t IH;
    uint32_t IW;
    uint32_t OH;
    uint32_t OW;
    uint32_t FH;
    uint32_t FW;
    uint32_t pad;

    double *ifmap;
    double *weights;
    double *ofmap;

    uint32_t TILE_CI;
    uint32_t cluster2cluster;
    uint32_t im2col;

    // BATCHNORM
    double *gamma;
    double *beta;

    precision_t dtype;
} conv_layer;

/**
 * @struct kernel_fp32
 * @brief parameters for single-precision fusedconv kernel
 *
 * @var kernel_fp32::pInBuffer
 * pointer to the input feature map
 * @var kernel_fp32::dim_in_x
 * width of input feature map
 * @var kernel_fp32::dim_in_y
 * height of input feature map
 * @var kernel_fp32::ch_in
 * number of input channels
 * @var kernel_fp32::pWeight
 * pointer to weights
 * @var kernel_fp32::ch_out
 * number of output channels
 * @var kernel_fp32::dim_kernel_x
 * width of kernel
 * @var kernel_fp32::dim_kernel_y
 * height of kernel
 * @var kernel_fp32::padding_y_top
 * number of pixels padded on the top
 * @var kernel_fp32::padding_y_bottom
 * number of pixels padded on the bottom
 * @var kernel_fp32::padding_x_left
 * number of pixels padded on the left
 * @var kernel_fp32::padding_x_right
 * number of pixels padded on the right
 * @var kernel_fp32::stride_x
 * stride in x direction
 * @var kernel_fp32::stride_y
 * stride in y direction
 * @var kernel_fp32::bias
 * bias of convolution (currently not used)
 * @var kernel_fp32::bias_shift
 * bias shift of convolution (currently not used)
 * @var kernel_fp32::out_shift
 * shift factor for requantization (not used for floating point)
 * @var kernel_fp32::out_mult
 * mult factor for requantization (not used for floating point)
 * @var kernel_fp32::pOutBuffer
 * pointer to output feature map
 * @var kernel_fp32::dim_out_x
 * width of output feature map
 * @var kernel_fp32::dim_out_y
 * height of output feature map
 * @var kernel_fp32::kappa
 * multiplication factor for BatchNorm
 * @var kernel_fp32::lambda
 * @var kernel_fp32::pIm2ColBuffer
 * pointer to im2col Buffer (not used)
 * bias for BatchNorm
 * @var kernel_fp32::flag_relu
 * RELU activation flag
 * @var kernel_fp32::flag_batch_norm
 * BatchNorm flag
 * @var kernel_fp32::flag_y_accumulate_start
 * indicates that output feature map is initizialized with zeros
 * @var kernel_fp32::flag_y_accumulate_end
 * indicates that BN, RELU can be performed
 * @var kernel_fp32::memory_chan
 * Not used
 */

typedef struct {
    uint32_t ch_in;
    uint32_t ch_out;
    uint32_t dim_in_x;
    uint32_t dim_in_y;
    uint32_t dim_kernel_x;
    uint32_t dim_kernel_y;
    uint32_t dim_out_x;
    uint32_t dim_out_y;
    uint32_t padding_y_top;
    uint32_t padding_y_bottom;
    uint32_t padding_x_left;
    uint32_t padding_x_right;
    uint32_t stride_x;
    uint32_t stride_y;
    uint32_t flag_relu;
    int flag_batch_norm;
    int depthwise;
    int chw_layer;
    int flag_y_accumulate_start;
    int flag_y_accumulate_end;
    float *pInBuffer;
    float *pWeight;
    float *lambda;
    float *kappa;
    float *pOutBuffer;
    int8_t *bias;
    uint8_t *pIm2ColBuffer;
    unsigned int *memory_chan;
    uint32_t bias_shift;
    uint32_t out_shift;
    uint32_t out_mult;
    precision_t dtype;
} kernel_fp32;

/**
 * @struct kernel_fp64
 * @brief parameters for double-precision fusedconv kernel
 *
 * @var kernel_fp64::pInBuffer
 * pointer to the input feature map
 * @var kernel_fp64::dim_in_x
 * width of input feature map
 * @var kernel_fp64::dim_in_y
 * height of input feature map
 * @var kernel_fp64::ch_in
 * number of input channels
 * @var kernel_fp64::pWeight
 * pointer to weights
 * @var kernel_fp64::ch_out
 * number of output channels
 * @var kernel_fp64::dim_kernel_x
 * width of kernel
 * @var kernel_fp64::dim_kernel_y
 * height of kernel
 * @var kernel_fp64::padding_y_top
 * number of pixels padded on the top
 * @var kernel_fp64::padding_y_bottom
 * number of pixels padded on the bottom
 * @var kernel_fp64::padding_x_left
 * number of pixels padded on the left
 * @var kernel_fp64::padding_x_right
 * number of pixels padded on the right
 * @var kernel_fp64::stride_x
 * stride in x direction
 * @var kernel_fp64::stride_y
 * stride in y direction
 * @var kernel_fp64::bias
 * bias of convolution (currently not used)
 * @var kernel_fp64::bias_shift
 * bias shift of convolution (currently not used)
 * @var kernel_fp64::out_shift
 * shift factor for requantization (not used for floating point)
 * @var kernel_fp64::out_mult
 * mult factor for requantization (not used for floating point)
 * @var kernel_fp64::pOutBuffer
 * pointer to output feature map
 * @var kernel_fp64::dim_out_x
 * width of output feature map
 * @var kernel_fp64::dim_out_y
 * height of output feature map
 * @var kernel_fp64::kappa
 * multiplication factor for BatchNorm
 * @var kernel_fp64::lambda
 * bias for BatchNorm
 * @var kernel_fp64::pIm2ColBuffer
 * pointer to im2col Buffer (not used)
 * @var kernel_fp64::flag_relu
 * RELU activation flag
 * @var kernel_fp64::flag_batch_norm
 * BatchNorm flag
 * @var kernel_fp64::flag_y_accumulate_start
 * indicates that output feature map is initizialized with zeros
 * @var kernel_fp64::flag_y_accumulate_end
 * indicates that BN, RELU can be performed
 * @var kernel_fp64::memory_chan
 * Not used
 */
typedef struct {
    double *pInBuffer;
    uint16_t dim_in_x;
    uint16_t dim_in_y;
    uint16_t ch_in;
    double *pWeight;
    uint16_t ch_out;
    uint16_t dim_kernel_x;
    uint16_t dim_kernel_y;
    uint16_t padding_y_top;
    uint16_t padding_y_bottom;
    uint16_t padding_x_left;
    uint16_t padding_x_right;
    uint16_t stride_x;
    uint16_t stride_y;
    int8_t *bias;
    uint16_t bias_shift;
    uint16_t out_shift;
    uint16_t out_mult;
    double *pOutBuffer;
    uint16_t dim_out_x;
    uint16_t dim_out_y;
    double *kappa;
    double *lambda;
    uint8_t *pIm2ColBuffer;
    int flag_relu;
    int flag_batch_norm;
    int flag_y_accumulate_start;
    int flag_y_accumulate_end;
    unsigned int *memory_chan;
} kernel_fp64;

/**
 * @brief helper function that implements Batch Normalization and ReLU
 * @param pBuffer pointer to the feature map
 * @param dim_x width of feature map
 * @param dim_y height of feature map
 * @param ch number of channels (SIMD restricts multiple of 2)
 * @param kappa multiplication factor for BatchNorm
 * @param lambda bias for BatchNorm
 * @param flag_relu RELU activation flag
 * @param flag_batch_norm BatchNorm flag
 */
void bn_relu(const float *pBuffer, const uint16_t dim_x, const uint16_t dim_y,
             const uint16_t ch, float *kappa, float *lambda, int flag_relu,
             int flag_batch_norm) {
    // Parallelization/Pipelining parameters
    const uint32_t compute_id = snrt_cluster_compute_core_num();
    const uint32_t compute_num =
        (snrt_cluster_compute_core_num()) ? snrt_cluster_compute_core_num() : 1;
    // BN & ReLU require 3 instructions. Unrolling by 4 gives as 12 instruction
    // which is still feasible with a FPU sequencer that holds 16 instructions
    const uint32_t n_unroll = 4;
    const uint32_t cleanup_unroll = dim_y % n_unroll;

    // Feature map (H x W x C)
    const uint32_t co_stride = 1;
    const uint32_t w_stride = co_stride * ch;
    const uint32_t h_stride = w_stride * dim_x;

    // Reference Loops
    // for (int co = 0; co < ch_out; co++) {
    //     for (int y0 = 0; y0 < dim_out_y0; y+=n_unroll) {
    //         for (int x = 0; x < dim_out_x; x++) {
    //              for (int y1 = 0; y1 < n_unroll; y1++) {
    //                  y = y0 * n_unroll + y1;
    //                  pOutBuffer[y][x][co] =  max(pOutBuffer[y][x][co] * k[co]
    //                      + l[co], 0);
    //                  }
    //         }
    //     }
    // }

    // Ouput channels are distributed across cores, SIMD operates on pairs
    // of 2 One SSR reads, while the other SSR writes back to the same
    // location

    const uint32_t ssr_b[4] = {n_unroll, dim_x, dim_y / n_unroll,
                               (ch + compute_num - 1) / compute_num / 2};
    const uint32_t ssr_i[4] = {
        h_stride * sizeof(float), w_stride * sizeof(float),
        n_unroll * h_stride * sizeof(float), compute_num * sizeof(v2s)};

    snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr_b[0], ssr_b[1], ssr_b[2], ssr_b[3],
                     ssr_i[0], ssr_i[1], ssr_i[2], ssr_i[3]);
    snrt_ssr_loop_4d(SNRT_SSR_DM1, ssr_b[0], ssr_b[1], ssr_b[2], ssr_b[3],
                     ssr_i[0], ssr_i[1], ssr_i[2], ssr_i[3]);
    snrt_ssr_repeat(SNRT_SSR_DM1, 1);  // Disable repeat from conv2d

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D, (volatile void *)&pBuffer[compute_id * 2]);
    snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_4D, (volatile void *)&pBuffer[compute_id * 2]);

    // Regular path with max unrolling is only done if dim_y
    // is at least n_unroll
    if (dim_y >= n_unroll) {
        for (uint32_t co = compute_id; co < ch / 2; co += compute_num) {
            volatile register v2s current_lambda = ((v2s *)lambda)[co];
            volatile register v2s current_kappa = ((v2s *)kappa)[co];
            volatile register v2s zero = (v2s)0.0;

            volatile v2s tmp[n_unroll];

            snrt_ssr_enable();

            if (flag_batch_norm && flag_relu) {
                asm volatile(
                    "frep.o %[n_frep], 12, 0, 0\n"
                    "vfmul.s %[tmp0], ft0, %[k]\n"      // BN kappa
                    "vfmul.s %[tmp1], ft0, %[k]\n"      // BN kappa
                    "vfmul.s %[tmp2], ft0, %[k]\n"      // BN kappa
                    "vfmul.s %[tmp3], ft0, %[k]\n"      // BN kappa
                    "vfadd.s %[tmp0], %[tmp0], %[l]\n"  // BN lambda
                    "vfadd.s %[tmp1], %[tmp1], %[l]\n"  // BN lambda
                    "vfadd.s %[tmp2], %[tmp2], %[l]\n"  // BN lambda
                    "vfadd.s %[tmp3], %[tmp3], %[l]\n"  // BN lambda
                    "vfmax.s ft1, %[tmp0], %[zero]\n"   // ReLU
                    "vfmax.s ft1, %[tmp1], %[zero]\n"   // ReLU
                    "vfmax.s ft1, %[tmp2], %[zero]\n"   // ReLU
                    "vfmax.s ft1, %[tmp3], %[zero]\n"   // ReLU
                    : [ tmp0 ] "+f"(tmp[0].vec), [ tmp1 ] "+f"(tmp[1].vec),
                      [ tmp2 ] "+f"(tmp[2].vec), [ tmp3 ] "+f"(tmp[3].vec)
                    : [ k ] "f"(current_kappa.vec),
                      [ l ] "f"(current_lambda.vec), [ zero ] "f"(zero.vec),
                      [ n_frep ] "r"(dim_x * (dim_y / n_unroll) - 1)
                    : "ft0", "ft1", "ft2");
            } else if (flag_batch_norm && !flag_relu) {
                asm volatile(
                    "frep.o %[n_frep], 8, 0, 0\n"
                    "vfmul.s %[tmp0], ft0, %[k]\n"  // BN kappa
                    "vfmul.s %[tmp1], ft0, %[k]\n"  // BN kappa
                    "vfmul.s %[tmp2], ft0, %[k]\n"  // BN kappa
                    "vfmul.s %[tmp3], ft0, %[k]\n"  // BN kappa
                    "vfadd.s ft1, %[tmp0], %[l]\n"  // BN lambda
                    "vfadd.s ft1, %[tmp1], %[l]\n"  // BN lambda
                    "vfadd.s ft1, %[tmp2], %[l]\n"  // BN lambda
                    "vfadd.s ft1, %[tmp3], %[l]\n"  // BN lambda
                    : [ tmp0 ] "+f"(tmp[0].f64), [ tmp1 ] "+f"(tmp[1].f64),
                      [ tmp2 ] "+f"(tmp[2].f64), [ tmp3 ] "+f"(tmp[3].f64)
                    : [ k ] "f"(current_kappa.f64),
                      [ l ] "f"(current_lambda.f64),
                      [ n_frep ] "r"(dim_x * (dim_y / n_unroll) - 1)
                    : "ft0", "ft1", "ft2");
            } else if (!flag_batch_norm && flag_relu) {
                asm volatile(
                    "frep.o %[n_frep], 4, 0, 0\n"
                    "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                    "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                    "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                    "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                    ::[k] "f"(current_kappa.f64),
                    [ l ] "f"(current_lambda.f64), [ zero ] "f"(zero.f64),
                    [ n_frep ] "r"(dim_x * (dim_y / n_unroll) - 1)
                    : "ft0", "ft1", "ft2");
            }
            snrt_ssr_disable();
        }
    }

    if (cleanup_unroll) {
        // 1st and 3rd SSR dimensions are dependent on n_unroll, in the clean up
        // loops they need be adjusted to cleanup_unroll
        snrt_ssr_loop_4d(SNRT_SSR_DM0, cleanup_unroll, ssr_b[1], 1, ssr_b[3],
                         ssr_i[0], ssr_i[1],
                         cleanup_unroll * h_stride * sizeof(float), ssr_i[3]);
        snrt_ssr_loop_4d(SNRT_SSR_DM1, cleanup_unroll, ssr_b[1], 1, ssr_b[3],
                         ssr_i[0], ssr_i[1],
                         cleanup_unroll * h_stride * sizeof(float), ssr_i[3]);
        snrt_ssr_repeat(SNRT_SSR_DM1, 1);  // Disable repeat from conv2d

        uint32_t h_cleanup_index = dim_y - cleanup_unroll;

        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_4D,
                      (volatile void*)&pBuffer[h_cleanup_index * h_stride + compute_id * 2]);
        snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_4D,
                       (volatile void*)&pBuffer[h_cleanup_index * h_stride + compute_id * 2]);

        for (uint32_t co = compute_id; co < ch / 2; co += compute_num) {
            volatile register v2s current_lambda = ((v2s *)lambda)[co];
            volatile register v2s current_kappa = ((v2s *)kappa)[co];
            volatile register v2s zero = (v2s)0.0;

            volatile v2s tmp[n_unroll];

            snrt_ssr_enable();

            switch (cleanup_unroll) {
                case 3:
                    if (flag_batch_norm && flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 9, 0, 0\n"
                            "vfmul.s %[tmp0], ft0, %[k]\n"      // BN kappa
                            "vfmul.s %[tmp1], ft0, %[k]\n"      // BN kappa
                            "vfmul.s %[tmp2], ft0, %[k]\n"      // BN kappa
                            "vfadd.s %[tmp0], %[tmp0], %[l]\n"  // BN lambda
                            "vfadd.s %[tmp1], %[tmp1], %[l]\n"  // BN lambda
                            "vfadd.s %[tmp2], %[tmp2], %[l]\n"  // BN lambda
                            "vfmax.s ft1, %[tmp0], %[zero]\n"   // ReLU
                            "vfmax.s ft1, %[tmp1], %[zero]\n"   // ReLU
                            "vfmax.s ft1, %[tmp2], %[zero]\n"   // ReLU
                            : [ tmp0 ] "+f"(tmp[0].vec),
                              [ tmp1 ] "+f"(tmp[1].vec),
                              [ tmp2 ] "+f"(tmp[2].vec)
                            : [ k ] "f"(current_kappa.vec),
                              [ l ] "f"(current_lambda.vec),
                              [ zero ] "f"(zero.vec), [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    } else if (flag_batch_norm && !flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 6, 0, 0\n"
                            "vfmul.s %[tmp0], ft0, %[k]\n"  // BN kappa
                            "vfmul.s %[tmp1], ft0, %[k]\n"  // BN kappa
                            "vfmul.s %[tmp2], ft0, %[k]\n"  // BN kappa
                            "vfadd.s ft1, %[tmp0], %[l]\n"  // BN lambda
                            "vfadd.s ft1, %[tmp1], %[l]\n"  // BN lambda
                            "vfadd.s ft1, %[tmp2], %[l]\n"  // BN lambda
                            : [ tmp0 ] "+f"(tmp[0].f64),
                              [ tmp1 ] "+f"(tmp[1].f64),
                              [ tmp2 ] "+f"(tmp[2].f64)
                            : [ k ] "f"(current_kappa.f64),
                              [ l ] "f"(current_lambda.f64),
                              [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    } else if (!flag_batch_norm && flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 3, 0, 0\n"
                            "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                            "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                            "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                            ::[k] "f"(current_kappa.f64),
                            [ l ] "f"(current_lambda.f64),
                            [ zero ] "f"(zero.f64), [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    }
                    break;
                case 2:
                    if (flag_batch_norm && flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 6, 0, 0\n"
                            "vfmul.s %[tmp0], ft0, %[k]\n"      // BN kappa
                            "vfmul.s %[tmp1], ft0, %[k]\n"      // BN kappa
                            "vfadd.s %[tmp0], %[tmp0], %[l]\n"  // BN lambda
                            "vfadd.s %[tmp1], %[tmp1], %[l]\n"  // BN lambda
                            "vfmax.s ft1, %[tmp0], %[zero]\n"   // ReLU
                            "vfmax.s ft1, %[tmp1], %[zero]\n"   // ReLU
                            :
                            [ tmp0 ] "+f"(tmp[0].vec), [ tmp1 ] "+f"(tmp[1].vec)
                            : [ k ] "f"(current_kappa.vec),
                              [ l ] "f"(current_lambda.vec),
                              [ zero ] "f"(zero.vec), [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    } else if (flag_batch_norm && !flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 4, 0, 0\n"
                            "vfmul.s %[tmp0], ft0, %[k]\n"  // BN kappa
                            "vfmul.s %[tmp1], ft0, %[k]\n"  // BN kappa
                            "vfadd.s ft1, %[tmp0], %[l]\n"  // BN lambda
                            "vfadd.s ft1, %[tmp1], %[l]\n"  // BN lambda
                            :
                            [ tmp0 ] "+f"(tmp[0].f64), [ tmp1 ] "+f"(tmp[1].f64)
                            : [ k ] "f"(current_kappa.f64),
                              [ l ] "f"(current_lambda.f64),
                              [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    } else if (!flag_batch_norm && flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 2, 0, 0\n"
                            "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                            "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                            ::[k] "f"(current_kappa.f64),
                            [ l ] "f"(current_lambda.f64),
                            [ zero ] "f"(zero.f64), [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    }
                    break;
                case 1:
                    if (flag_batch_norm && flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 3, 0, 0\n"
                            "vfmul.s %[tmp0], ft0, %[k]\n"      // BN kappa
                            "vfadd.s %[tmp0], %[tmp0], %[l]\n"  // BN lambda
                            "vfmax.s ft1, %[tmp0], %[zero]\n"   // ReLU
                            : [ tmp0 ] "+f"(tmp[0].vec)
                            : [ k ] "f"(current_kappa.vec),
                              [ l ] "f"(current_lambda.vec),
                              [ zero ] "f"(zero.vec), [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    } else if (flag_batch_norm && !flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 2, 0, 0\n"
                            "vfmul.s %[tmp0], ft0, %[k]\n"  // BN kappa
                            "vfadd.s ft1, %[tmp0], %[l]\n"  // BN lambda
                            : [ tmp0 ] "+f"(tmp[0].f64)
                            : [ k ] "f"(current_kappa.f64),
                              [ l ] "f"(current_lambda.f64),
                              [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    } else if (!flag_batch_norm && flag_relu) {
                        asm volatile(
                            "frep.o %[n_frep], 1, 0, 0\n"
                            "vfmax.s ft1, ft0, %[zero]\n"  // ReLU
                            ::[k] "f"(current_kappa.f64),
                            [ l ] "f"(current_lambda.f64),
                            [ zero ] "f"(zero.f64), [ n_frep ] "r"(dim_x - 1)
                            : "ft0", "ft1", "ft2");
                    }
                    break;
            }
            snrt_ssr_disable();
        }
    }
}

/**
 * @brief implementation of a double-precision fp convolutional kernel
 * for DORY trials. Currently does a direct convolution without im2col.
 * The memory layout of input/output feature map is HxWxC, resp. CoxFhxFwxCi.
 * Fuses multiple layers together (Conv2d, Batchnorm, Relu) that can be enabled
 * with a flag
 * @param k kernel_fp64 struct reference that holds all parameters
 */
static inline void conv2d_fp64(kernel_fp64 *k) {
    // Parallelization/Pipelining parameters
    const uint32_t compute_id = snrt_cluster_compute_core_num();
    const uint32_t compute_num =
        (snrt_cluster_compute_core_num()) ? snrt_cluster_compute_core_num() : 1;
    const uint32_t max_unroll = 8;  // Maximum number of unrolling
    const uint32_t cleanup_unroll = k->dim_out_y % max_unroll;

    // Calculate strides to access specific dimensions
    // of input/output feature map and weights
    // Input feature map (H x W x Ci)
    // Calculate effective H, W dimension including padding
    const uint32_t dim_in_eff_x =
        k->dim_in_x + k->padding_x_left + k->padding_x_right;
    const uint32_t dim_in_eff_y =
        k->dim_in_y + k->padding_y_top + k->padding_y_bottom;
    const uint32_t input_w_stride = k->ch_in;
    const uint32_t input_h_stride = input_w_stride * dim_in_eff_x;

    // Output feature map (H x W x Co)
    const uint32_t output_w_stride = k->ch_out;
    const uint32_t output_h_stride = output_w_stride * k->dim_out_x;

    // Weight (Co x Fh x Fw x Ci)
    const uint32_t kernel_w_stride = k->ch_in;
    const uint32_t kernel_h_stride = kernel_w_stride * k->dim_kernel_x;
    const uint32_t kernel_co_stride = kernel_h_stride * k->dim_kernel_y;

    // Reference Loops
    // for (uint32_t co = compute_id; co < k->ch_out; co += compute_num) {
    //     for (uint32_t h0 = 0; h0 < k->dim_in_y / max_unroll; h++) {
    //         for (uint32_t w = 0; w < k->dim_in_x; w += k->stride_x) {
    //             for (uint32_t fh = 0; fh < k->dim_kernel_y, fh++) {
    //                 for (uint32_t fw = 0; fw < k->dim_kernel_x, fw++) {
    //                     for (uint32_t ci = 0; ci < k->ch_in; ci++) {
    //                         for (uint32_t h1 = 0; h1 < max_unroll; h1++) {
    //                             k->pOutBuffer[(h-pad_t)/str_y][(w-pad_l)/str_x][co]
    //                                   +=  k->pInBuffer[h+fh][w+fw][ci] *
    //                                       k->pWeightBuffer[co][fh][fw][ci]
    //                         }
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }

    // Setup SSRs bounds and strides for input feature map
    const uint32_t ssr0_b[4] = {max_unroll, k->ch_in, k->dim_kernel_x,
                                k->dim_kernel_y};
    const uint32_t ssr0_i[4] = {
        input_h_stride * k->stride_y * sizeof(double), 1 * sizeof(double),
        input_w_stride * sizeof(double), input_h_stride * sizeof(double)};

    snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3],
                     ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

    // Setup SSRs bounds and strides for kernel
    // We use only 3D SSRs here as the inner most dimension is repeated
    const uint32_t ssr1_b[3] = {k->ch_in, k->dim_kernel_x, k->dim_kernel_y};
    const uint32_t ssr1_i[3] = {1 * sizeof(double),
                                kernel_w_stride * sizeof(double),
                                kernel_h_stride * sizeof(double)};

    snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2], ssr1_i[0],
                     ssr1_i[1], ssr1_i[2]);

    snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);

    // Output channel dimension `k->ch_out` is parallelized over cores
    for (uint32_t co = compute_id; co < k->ch_out; co += compute_num) {
        uint32_t h0 = 0;

        // If `k->dim_out_y` is not divisible by `unroll`, we have to clean up
        // at the end which modifies the SSR loops, thus initialize it again
        // correctly
        if (cleanup_unroll) {
            snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_i[0], ssr1_i[1], ssr1_i[2]);

            snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);
        }

        // Output height dimension `k->dim_out_y` first split
        for (h0 = 0; h0 < k->dim_out_y / max_unroll; h0++) {
            // Output width dimension `k->dim_out_x`
            for (uint32_t w = 0; w < k->dim_out_x; w++) {
                // TODO: check if initialization needs to be unrolled by hand
                volatile double sum[max_unroll];
                if (k->flag_y_accumulate_start) {
                    for (uint32_t i = 0; i < max_unroll; i++) {
                        sum[i] = 0.0;
                    }
                } else {
                    for (uint32_t i = 0; i < max_unroll; i++) {
                        sum[i] = *(k->pOutBuffer +
                                   (h0 * max_unroll + i) * output_h_stride +
                                   w * output_w_stride + co);
                    }
                }

                // SSR address setup and enable
                snrt_ssr_read(
                    SNRT_SSR_DM0, SNRT_SSR_4D,
                    (void *)(k->pInBuffer +
                             h0 * max_unroll * k->stride_y * input_h_stride +
                             w * k->stride_x * input_w_stride));
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D,
                              (void *)(k->pWeight + co * kernel_co_stride));
                snrt_ssr_enable();

                asm volatile(
                    "frep.o %[n_frep], 8, 0, 0 \n"
                    "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                    "fmadd.d %[sum1], ft0, ft1, %[sum1] \n"
                    "fmadd.d %[sum2], ft0, ft1, %[sum2] \n"
                    "fmadd.d %[sum3], ft0, ft1, %[sum3] \n"
                    "fmadd.d %[sum4], ft0, ft1, %[sum4] \n"
                    "fmadd.d %[sum5], ft0, ft1, %[sum5] \n"
                    "fmadd.d %[sum6], ft0, ft1, %[sum6] \n"
                    "fmadd.d %[sum7], ft0, ft1, %[sum7] \n"
                    : [ sum0 ] "+f"(sum[0]), [ sum1 ] "+f"(sum[1]),
                      [ sum2 ] "+f"(sum[2]), [ sum3 ] "+f"(sum[3]),
                      [ sum4 ] "+f"(sum[4]), [ sum5 ] "+f"(sum[5]),
                      [ sum6 ] "+f"(sum[6]), [ sum7 ] "+f"(sum[7])
                    : [ n_frep ] "r"(
                        k->dim_kernel_y * k->dim_kernel_x * k->ch_in - 1)
                    : "ft0", "ft1", "ft2");

                snrt_ssr_disable();

                // TODO: Check if needs to be unrolled manually
                for (uint32_t i = 0; i < max_unroll; i++) {
                    k->pOutBuffer[(h0 * max_unroll + i) * output_h_stride +
                                  w * output_w_stride + co] = sum[i];
                }
            }
        }

        // Clean up rows
        if (cleanup_unroll) {
            // Modify most inner loop unrolling
            snrt_ssr_loop_4d(SNRT_SSR_DM0, cleanup_unroll, ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_i[0], ssr1_i[1], ssr1_i[2]);

            snrt_ssr_repeat(SNRT_SSR_DM1, cleanup_unroll);

            // Output width dimension `k->dim_out_x`
            for (uint32_t w = 0; w < k->dim_out_x; w++) {
                volatile double sum[max_unroll];
                if (k->flag_y_accumulate_start) {
                    for (uint32_t i = 0; i < cleanup_unroll; i++) {
                        sum[i] = 0.0;
                    }
                } else {
                    for (uint32_t i = 0; i < cleanup_unroll; i++) {
                        sum[i] = *(k->pOutBuffer +
                                   (h0 * max_unroll + i) * output_h_stride +
                                   w * output_w_stride + co);
                    }
                }

                // SSR address setup and enable
                snrt_ssr_read(
                    SNRT_SSR_DM0, SNRT_SSR_4D,
                    (void *)(k->pInBuffer +
                             h0 * max_unroll * k->stride_y * input_h_stride +
                             w * k->stride_x * input_w_stride));
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D,
                              (void *)(k->pWeight + co * kernel_co_stride));
                snrt_ssr_enable();

                switch (cleanup_unroll) {
                    case 7:
                        asm volatile(
                            "frep.o %[n_frep], 7, 0, 0 \n"
                            "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                            "fmadd.d %[sum1], ft0, ft1, %[sum1] \n"
                            "fmadd.d %[sum2], ft0, ft1, %[sum2] \n"
                            "fmadd.d %[sum3], ft0, ft1, %[sum3] \n"
                            "fmadd.d %[sum4], ft0, ft1, %[sum4] \n"
                            "fmadd.d %[sum5], ft0, ft1, %[sum5] \n"
                            "fmadd.d %[sum6], ft0, ft1, %[sum6] \n"
                            : [ sum0 ] "+f"(sum[0]), [ sum1 ] "+f"(sum[1]),
                              [ sum2 ] "+f"(sum[2]), [ sum3 ] "+f"(sum[3]),
                              [ sum4 ] "+f"(sum[4]), [ sum5 ] "+f"(sum[5]),
                              [ sum6 ] "+f"(sum[6])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 6:
                        asm volatile(
                            "frep.o %[n_frep], 6, 0, 0 \n"
                            "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                            "fmadd.d %[sum1], ft0, ft1, %[sum1] \n"
                            "fmadd.d %[sum2], ft0, ft1, %[sum2] \n"
                            "fmadd.d %[sum3], ft0, ft1, %[sum3] \n"
                            "fmadd.d %[sum4], ft0, ft1, %[sum4] \n"
                            "fmadd.d %[sum5], ft0, ft1, %[sum5] \n"
                            : [ sum0 ] "+f"(sum[0]), [ sum1 ] "+f"(sum[1]),
                              [ sum2 ] "+f"(sum[2]), [ sum3 ] "+f"(sum[3]),
                              [ sum4 ] "+f"(sum[4]), [ sum5 ] "+f"(sum[5])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 5:
                        asm volatile(
                            "frep.o %[n_frep], 5, 0, 0 \n"
                            "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                            "fmadd.d %[sum1], ft0, ft1, %[sum1] \n"
                            "fmadd.d %[sum2], ft0, ft1, %[sum2] \n"
                            "fmadd.d %[sum3], ft0, ft1, %[sum3] \n"
                            "fmadd.d %[sum4], ft0, ft1, %[sum4] \n"
                            : [ sum0 ] "+f"(sum[0]), [ sum1 ] "+f"(sum[1]),
                              [ sum2 ] "+f"(sum[2]), [ sum3 ] "+f"(sum[3]),
                              [ sum4 ] "+f"(sum[4])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 4:
                        asm volatile(
                            "frep.o %[n_frep], 4, 0, 0 \n"
                            "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                            "fmadd.d %[sum1], ft0, ft1, %[sum1] \n"
                            "fmadd.d %[sum2], ft0, ft1, %[sum2] \n"
                            "fmadd.d %[sum3], ft0, ft1, %[sum3] \n"
                            : [ sum0 ] "+f"(sum[0]), [ sum1 ] "+f"(sum[1]),
                              [ sum2 ] "+f"(sum[2]), [ sum3 ] "+f"(sum[3])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 3:
                        asm volatile(
                            "frep.o %[n_frep], 3, 0, 0 \n"
                            "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                            "fmadd.d %[sum1], ft0, ft1, %[sum1] \n"
                            "fmadd.d %[sum2], ft0, ft1, %[sum2] \n"
                            : [ sum0 ] "+f"(sum[0]), [ sum1 ] "+f"(sum[1]),
                              [ sum2 ] "+f"(sum[2])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 2:
                        asm volatile(
                            "frep.o %[n_frep], 2, 0, 0 \n"
                            "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                            "fmadd.d %[sum1], ft0, ft1, %[sum1] \n"
                            : [ sum0 ] "+f"(sum[0]), [ sum1 ] "+f"(sum[1])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 1:
                        asm volatile(
                            "frep.o %[n_frep], 1, 0, 0 \n"
                            "fmadd.d %[sum0], ft0, ft1, %[sum0] \n"
                            : [ sum0 ] "+f"(sum[0])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                }

                snrt_ssr_disable();

                // TODO: Check if needs to be unrolled manually
                for (uint32_t i = 0; i < cleanup_unroll; i++) {
                    k->pOutBuffer[(h0 * max_unroll + i) * output_h_stride +
                                  w * output_w_stride + co] = sum[i];
                }
            }
        }
    }

    snrt_cluster_hw_barrier();

    if (k->flag_batch_norm | k->flag_relu) {
        snrt_ssr_loop_2d(SNRT_SSR_DM0, k->dim_out_x * k->dim_out_y,
                         k->ch_out / compute_num, sizeof(double) * k->ch_out,
                         sizeof(double));
        snrt_ssr_loop_2d(SNRT_SSR_DM1, k->dim_out_x * k->dim_out_y,
                         k->ch_out / compute_num, sizeof(double) * k->ch_out,
                         sizeof(double));
        snrt_ssr_repeat(SNRT_SSR_DM1, 1);

        snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_2D, &k->pOutBuffer[compute_id]);
        snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_2D, &k->pOutBuffer[compute_id]);

        snrt_ssr_enable();

        for (uint32_t co = compute_id; co < k->ch_out; co += compute_num) {
            volatile register double current_lambda = k->lambda[co];
            volatile register double current_kappa = k->kappa[co];
            volatile register double zero = 0.0;

            volatile register double tmp;

            if (k->flag_batch_norm && k->flag_relu) {
                asm volatile(
                    "frep.o %[n_frep], 2, 0, 0\n"
                    "fmadd.d %[tmp], ft0, %[k], %[l]\n"
                    "fmax.d ft1, %[tmp], %[zero]\n"
                    : [ tmp ] "+f"(tmp)
                    : [ k ] "f"(current_kappa), [ l ] "f"(current_lambda),
                      [ zero ] "f"(zero),
                      [ n_frep ] "r"(k->dim_out_x * k->dim_out_y - 1)
                    : "ft0", "ft1", "ft2");
            } else if (k->flag_batch_norm && !k->flag_relu) {
                asm volatile(
                    "frep.o %[n_frep], 1, 0, 0\n"
                    "fmadd.d %[tmp], ft0, %[k], %[l]\n"
                    : [ tmp ] "+f"(tmp), [ k ] "+f"(current_kappa),
                      [ l ] "+f"(current_lambda)
                    : [ n_frep ] "r"(k->dim_out_x * k->dim_out_y - 1)
                    : "ft0", "ft1", "ft2");
            } else if (!k->flag_batch_norm && k->flag_relu) {
                asm volatile(
                    "frep.o %[n_frep], 1, 0, 0 \n"
                    "fmax.d ft1, ft0, %[zero]\n" ::[zero] "f"(zero),
                    [ n_frep ] "r"(k->dim_out_x * k->dim_out_y - 1)
                    : "ft0", "ft1", "ft2");
            }
        }

        snrt_ssr_disable();
    }
}

/**
 * @brief implementation of a single-precision fp convolutional kernel
 * for DORY trials. Currently does a direct convolution without im2col.
 * The memory layout of input/output feature map is HxWxC, resp. CoxFhxFwxCi.
 * Fuses multiple layers together (Conv2d, Batchnorm, Relu) that can be enabled
 * with a flag
 * @param k kernel_fp32 struct reference that holds all parameters
 */
static inline void conv2d_fp32(kernel_fp32 *k) {
    // Parallelization/Pipelining parameters
    const uint32_t compute_id = snrt_cluster_compute_core_num();
    const uint32_t compute_num =
        (snrt_cluster_compute_core_num()) ? snrt_cluster_compute_core_num() : 1;
    const uint32_t max_unroll = 8;  // Maximum number of unrolling
    const uint32_t cleanup_unroll = k->dim_out_y % max_unroll;

    // Calculate strides to access specific dimensions
    // of input/output feature map and weights
    // Input feature map (H x W x Ci)
    // Calculate effective H, W dimension including padding
    const uint32_t dim_in_eff_x =
        k->dim_in_x + k->padding_x_left + k->padding_x_right;
    const uint32_t dim_in_eff_y =
        k->dim_in_y + k->padding_y_top + k->padding_y_bottom;
    const uint32_t input_w_stride = k->ch_in;
    const uint32_t input_h_stride = input_w_stride * dim_in_eff_x;

    // Output feature map (H x W x Co)
    const uint32_t output_w_stride = k->ch_out;
    const uint32_t output_h_stride = output_w_stride * k->dim_out_x;

    // Weight (Co x Fh x Fw x Ci)
    const uint32_t kernel_w_stride = k->ch_in;
    const uint32_t kernel_h_stride = kernel_w_stride * k->dim_kernel_x;
    const uint32_t kernel_co_stride = kernel_h_stride * k->dim_kernel_y;

    // Reference Loops
    // for (uint32_t co = compute_id; co < k->ch_out; co += compute_num) {
    //     for (uint32_t h0 = 0; h0 < k->dim_in_y / max_unroll; h++) {
    //         for (uint32_t w = 0; w < k->dim_in_x; w += k->stride_x) {
    //             for (uint32_t fh = 0; fh < k->dim_kernel_y, fh++) {
    //                 for (uint32_t fw = 0; fw < k->dim_kernel_x, fw++) {
    //                     for (uint32_t ci = 0; ci < k->ch_in; ci++) {
    //                         for (uint32_t h1 = 0; h1 < max_unroll; h1++) {
    //                             k->pOutBuffer[(h-pad_t)/str_y][(w-pad_l)/str_x][co]
    //                                   +=  k->pInBuffer[h+fh][w+fw][ci] *
    //                                       k->pWeightBuffer[co][fh][fw][ci]
    //                         }
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }

    // Setup SSRs bounds and strides for input feature map
    const uint32_t ssr0_b[4] = {max_unroll, k->ch_in / 2, k->dim_kernel_x,
                                k->dim_kernel_y};
    const uint32_t ssr0_i[4] = {input_h_stride * k->stride_y * sizeof(float),
                                1 * sizeof(v2s), input_w_stride * sizeof(float),
                                input_h_stride * sizeof(float)};

    snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3],
                     ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

    // Setup SSRs bounds and strides for kernel
    // We use only 3D SSRs here as the inner most dimension is repeated
    const uint32_t ssr1_b[3] = {k->ch_in / 2, k->dim_kernel_x, k->dim_kernel_y};
    const uint32_t ssr1_i[3] = {1 * sizeof(v2s),
                                kernel_w_stride * sizeof(float),
                                kernel_h_stride * sizeof(float)};

    snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2], ssr1_i[0],
                     ssr1_i[1], ssr1_i[2]);

    // Repeat the innermost value `max_unroll` times
    snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);

    // Output channel dimension `k->ch_out` is parallelized over cores
    for (uint32_t co = compute_id; co < k->ch_out; co += compute_num) {
        uint32_t h0 = 0;

        // If `k->dim_out_y` is not divisible by `unroll`, we have to clean up
        // at the end which modifies the SSR loops, thus initialize it again
        // correctly
        if (cleanup_unroll) {
            snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_i[0], ssr1_i[1], ssr1_i[2]);

            snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);
        }

        // Output height dimension `k->dim_out_y` first split
        for (h0 = 0; h0 < k->dim_out_y / max_unroll; h0++) {
            // Output width dimension `k->dim_out_x`
            for (uint32_t w = 0; w < k->dim_out_x; w++) {
                volatile v2s sum[max_unroll];
                volatile float reduce_reg[max_unroll];
                // pointer to output buffer location where intermediate values
                // are read from and stored
                float *_pOutBuffer =
                    &k->pOutBuffer[(h0 * max_unroll) * output_h_stride +
                                   w * output_w_stride + co];

                // Initialize registers with zero if the first
                // tile is processed, otherwise load intermediate values
                if (k->flag_y_accumulate_start) {
                    for (uint32_t i = 0; i < max_unroll; i++) {
                        sum[i].f64 = 0.0;
                        reduce_reg[i] = 0.0;
                    }
                } else {
                    for (uint32_t i = 0; i < max_unroll; i++) {
                        sum[i].f64 = 0.0;
                        reduce_reg[i] = _pOutBuffer[i * output_h_stride];
                    }
                }

                // SSR address setup and enable
                snrt_ssr_read(
                    SNRT_SSR_DM0, SNRT_SSR_4D,
                    (void *)(k->pInBuffer +
                             h0 * max_unroll * k->stride_y * input_h_stride +
                             w * k->stride_x * input_w_stride));
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D,
                              (void *)(k->pWeight + co * kernel_co_stride));
                snrt_ssr_enable();

                asm volatile(
                    // frep over vfMACs
                    "frep.o %[n_frep], 8, 0, 0 \n"
                    "vfmac.s %[sum0], ft0, ft1 \n"
                    "vfmac.s %[sum1], ft0, ft1 \n"
                    "vfmac.s %[sum2], ft0, ft1 \n"
                    "vfmac.s %[sum3], ft0, ft1 \n"
                    "vfmac.s %[sum4], ft0, ft1 \n"
                    "vfmac.s %[sum5], ft0, ft1 \n"
                    "vfmac.s %[sum6], ft0, ft1 \n"
                    "vfmac.s %[sum7], ft0, ft1 \n"
                    // Sum reduce vector
                    "vfsum.s %[reduce_reg0], %[sum0] \n"
                    "vfsum.s %[reduce_reg1], %[sum1] \n"
                    "vfsum.s %[reduce_reg2], %[sum2] \n"
                    "vfsum.s %[reduce_reg3], %[sum3] \n"
                    "vfsum.s %[reduce_reg4], %[sum4] \n"
                    "vfsum.s %[reduce_reg5], %[sum5] \n"
                    "vfsum.s %[reduce_reg6], %[sum6] \n"
                    "vfsum.s %[reduce_reg7], %[sum7] \n"
                    : [ sum0 ] "+f"(sum[0].f64), [ sum1 ] "+f"(sum[1].f64),
                      [ sum2 ] "+f"(sum[2].f64), [ sum3 ] "+f"(sum[3].f64),
                      [ sum4 ] "+f"(sum[4].f64), [ sum5 ] "+f"(sum[5].f64),
                      [ sum6 ] "+f"(sum[6].f64), [ sum7 ] "+f"(sum[7].f64),
                      [ reduce_reg0 ] "+f"(reduce_reg[0]),
                      [ reduce_reg1 ] "+f"(reduce_reg[1]),
                      [ reduce_reg2 ] "+f"(reduce_reg[2]),
                      [ reduce_reg3 ] "+f"(reduce_reg[3]),
                      [ reduce_reg4 ] "+f"(reduce_reg[4]),
                      [ reduce_reg5 ] "+f"(reduce_reg[5]),
                      [ reduce_reg6 ] "+f"(reduce_reg[6]),
                      [ reduce_reg7 ] "+f"(reduce_reg[7])
                    : [ n_frep ] "r"(
                        k->dim_kernel_y * k->dim_kernel_x * k->ch_in / 2 - 1)
                    : "ft0", "ft1", "ft2");

                snrt_ssr_disable();

                // Write back output values
                for (uint32_t i = 0; i < max_unroll; i++) {
                    _pOutBuffer[i * output_h_stride] = reduce_reg[i];
                }
            }
        }

        // Clean up rows
        if (cleanup_unroll) {
            // Modify most inner loop unrolling
            snrt_ssr_loop_4d(SNRT_SSR_DM0, cleanup_unroll, ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_i[0], ssr1_i[1], ssr1_i[2]);

            snrt_ssr_repeat(SNRT_SSR_DM1, cleanup_unroll);

            // Output width dimension `k->dim_out_x`
            for (uint32_t w = 0; w < k->dim_out_x; w++) {
                volatile v2s sum[max_unroll];
                volatile float reduce_reg[max_unroll];

                // pointer to output buffer location where intermediate values
                // are read from and stored
                float *_pOutBuffer =
                    &k->pOutBuffer[(h0 * max_unroll) * output_h_stride +
                                   w * output_w_stride + co];

                if (k->flag_y_accumulate_start) {
                    for (uint32_t i = 0; i < cleanup_unroll; i++) {
                        sum[i].f64 = 0.0;
                        reduce_reg[i] = 0.0;
                    }
                } else {
                    for (uint32_t i = 0; i < cleanup_unroll; i++) {
                        sum[i].f64 = 0.0;
                        reduce_reg[i] = _pOutBuffer[i * output_h_stride];
                    }
                }

                // SSR address setup and enable
                snrt_ssr_read(
                    SNRT_SSR_DM0, SNRT_SSR_4D,
                    (void *)(k->pInBuffer +
                             h0 * max_unroll * k->stride_y * input_h_stride +
                             w * k->stride_x * input_w_stride));
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D,
                              (void *)(k->pWeight + co * kernel_co_stride));
                snrt_ssr_enable();

                switch (cleanup_unroll) {
                    case 7:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 7, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            "vfmac.s %[sum4], ft0, ft1 \n"
                            "vfmac.s %[sum5], ft0, ft1 \n"
                            "vfmac.s %[sum6], ft0, ft1 \n"
                            // Sum reduce vector
                            "vfsum.s %[reduce_reg0], %[sum0] \n"
                            "vfsum.s %[reduce_reg1], %[sum1] \n"
                            "vfsum.s %[reduce_reg2], %[sum2] \n"
                            "vfsum.s %[reduce_reg3], %[sum3] \n"
                            "vfsum.s %[reduce_reg4], %[sum4] \n"
                            "vfsum.s %[reduce_reg5], %[sum5] \n"
                            "vfsum.s %[reduce_reg6], %[sum6] \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64),
                              [ sum4 ] "+f"(sum[4].f64),
                              [ sum5 ] "+f"(sum[5].f64),
                              [ sum6 ] "+f"(sum[6].f64),
                              [ reduce_reg0 ] "+f"(reduce_reg[0]),
                              [ reduce_reg1 ] "+f"(reduce_reg[1]),
                              [ reduce_reg2 ] "+f"(reduce_reg[2]),
                              [ reduce_reg3 ] "+f"(reduce_reg[3]),
                              [ reduce_reg4 ] "+f"(reduce_reg[4]),
                              [ reduce_reg5 ] "+f"(reduce_reg[5]),
                              [ reduce_reg6 ] "+f"(reduce_reg[6])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in / 2 -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 6:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 6, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            "vfmac.s %[sum4], ft0, ft1 \n"
                            "vfmac.s %[sum5], ft0, ft1 \n"
                            // Sum reduce vector
                            "vfsum.s %[reduce_reg0], %[sum0] \n"
                            "vfsum.s %[reduce_reg1], %[sum1] \n"
                            "vfsum.s %[reduce_reg2], %[sum2] \n"
                            "vfsum.s %[reduce_reg3], %[sum3] \n"
                            "vfsum.s %[reduce_reg4], %[sum4] \n"
                            "vfsum.s %[reduce_reg5], %[sum5] \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64),
                              [ sum4 ] "+f"(sum[4].f64),
                              [ sum5 ] "+f"(sum[5].f64),
                              [ reduce_reg0 ] "+f"(reduce_reg[0]),
                              [ reduce_reg1 ] "+f"(reduce_reg[1]),
                              [ reduce_reg2 ] "+f"(reduce_reg[2]),
                              [ reduce_reg3 ] "+f"(reduce_reg[3]),
                              [ reduce_reg4 ] "+f"(reduce_reg[4]),
                              [ reduce_reg5 ] "+f"(reduce_reg[5])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in / 2 -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 5:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 5, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            "vfmac.s %[sum4], ft0, ft1 \n"
                            // Sum reduce vector
                            "vfsum.s %[reduce_reg0], %[sum0] \n"
                            "vfsum.s %[reduce_reg1], %[sum1] \n"
                            "vfsum.s %[reduce_reg2], %[sum2] \n"
                            "vfsum.s %[reduce_reg3], %[sum3] \n"
                            "vfsum.s %[reduce_reg4], %[sum4] \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64),
                              [ sum4 ] "+f"(sum[4].f64),
                              [ reduce_reg0 ] "+f"(reduce_reg[0]),
                              [ reduce_reg1 ] "+f"(reduce_reg[1]),
                              [ reduce_reg2 ] "+f"(reduce_reg[2]),
                              [ reduce_reg3 ] "+f"(reduce_reg[3]),
                              [ reduce_reg4 ] "+f"(reduce_reg[4])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in / 2 -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 4:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 4, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            // Sum reduce vector
                            "vfsum.s %[reduce_reg0], %[sum0] \n"
                            "vfsum.s %[reduce_reg1], %[sum1] \n"
                            "vfsum.s %[reduce_reg2], %[sum2] \n"
                            "vfsum.s %[reduce_reg3], %[sum3] \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64),
                              [ reduce_reg0 ] "+f"(reduce_reg[0]),
                              [ reduce_reg1 ] "+f"(reduce_reg[1]),
                              [ reduce_reg2 ] "+f"(reduce_reg[2]),
                              [ reduce_reg3 ] "+f"(reduce_reg[3])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in / 2 -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 3:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 3, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            // Sum reduce vector
                            "vfsum.s %[reduce_reg0], %[sum0] \n"
                            "vfsum.s %[reduce_reg1], %[sum1] \n"
                            "vfsum.s %[reduce_reg2], %[sum2] \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ reduce_reg0 ] "+f"(reduce_reg[0]),
                              [ reduce_reg1 ] "+f"(reduce_reg[1]),
                              [ reduce_reg2 ] "+f"(reduce_reg[2])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in / 2 -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 2:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 2, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            // Sum reduce vector
                            "vfsum.s %[reduce_reg0], %[sum0] \n"
                            "vfsum.s %[reduce_reg1], %[sum1] \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ reduce_reg0 ] "+f"(reduce_reg[0]),
                              [ reduce_reg1 ] "+f"(reduce_reg[1])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in / 2 -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 1:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 1, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            // Sum reduce vector
                            "vfsum.s %[reduce_reg0], %[sum0] \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ reduce_reg0 ] "+f"(reduce_reg[0])
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x *
                                                 k->ch_in / 2 -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                }

                snrt_ssr_disable();

                for (uint32_t i = 0; i < cleanup_unroll; i++) {
                    _pOutBuffer[i * output_h_stride] = reduce_reg[i];
                }
            }
        }
    }

    // Cores need to be synchronized as the conv2d is parallized over output
    // channels but BatchNorm/ReLU uses the channel dimension for SIMD
    // instructions
    snrt_cluster_hw_barrier();

    if (k->flag_batch_norm | k->flag_relu) {
        bn_relu(k->pOutBuffer, k->dim_out_x, k->dim_out_y, k->ch_out, k->kappa,
                k->lambda, k->flag_relu, k->flag_batch_norm);
    }
}

/**
 * @brief implementation of a single-precision fp DEPTHWISE convolutional kernel
 * for DORY trials. Currently does a direct convolution without im2col.
 * The memory layout of input/output feature map is HxWxC, resp. CoxFhxFwxCi.
 * Fuses multiple layers together (Conv2d, Batchnorm, Relu) that can be enabled
 * with a flag
 * @param k kernel_fp32 struct reference that holds all parameters
 */
static inline void conv2d_dw_fp32(kernel_fp32 *k) {
    // Parallelization/Pipelining parameters
    const uint32_t compute_id = snrt_cluster_compute_core_num();
    const uint32_t compute_num =
        (snrt_cluster_compute_core_num()) ? snrt_cluster_compute_core_num() : 1;
    const uint32_t max_unroll = 8;  // Maximum number of unrolling
    const uint32_t cleanup_unroll = k->dim_out_y % max_unroll;

    // Calculate strides to access specific dimensions
    // of input/output feature map and weights
    // Input feature map (H x W x Ci)
    // Calculate effective H, W dimension including padding
    const uint32_t dim_in_eff_x =
        k->dim_in_x + k->padding_x_left + k->padding_x_right;
    const uint32_t dim_in_eff_y =
        k->dim_in_y + k->padding_y_top + k->padding_y_bottom;
    const uint32_t input_w_stride = k->ch_in;
    const uint32_t input_h_stride = input_w_stride * dim_in_eff_x;

    // Output feature map (H x W x Co)
    const uint32_t output_w_stride = k->ch_out;
    const uint32_t output_h_stride = output_w_stride * k->dim_out_x;

    // Weight (Co x Fh x Fw x Ci)
    const uint32_t kernel_w_stride = k->ch_in;
    const uint32_t kernel_h_stride = kernel_w_stride * k->dim_kernel_x;
    const uint32_t kernel_co_stride = kernel_h_stride * k->dim_kernel_y;

    // Reference Loops
    // for (uint32_t c = compute_id; c < k->ch_out/2; c += compute_num) {
    //     for (uint32_t h0 = 0; h0 < k->dim_in_y / max_unroll; h++) {
    //         for (uint32_t w = 0; w < k->dim_in_x; w += k->stride_x) {
    //             for (uint32_t fh = 0; fh < k->dim_kernel_y, fh++) {
    //                 for (uint32_t fw = 0; fw < k->dim_kernel_x, fw++) {
    //                     for (uint32_t h1 = 0; h1 < max_unroll; h1++) {
    //                         k->pOutBuffer[(h-pad_t)/str_y][(w-pad_l)/str_x][c]
    //                                   +=  k->pInBuffer[h+fh][w+fw][c] *
    //                                       k->pWeightBuffer[co][fh][fw][c]
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }

    // Setup SSRs bounds and strides for input feature map
    const uint32_t ssr0_b[4] = {max_unroll, k->dim_kernel_x, k->dim_kernel_y,
                                k->dim_out_x};
    const uint32_t ssr0_i[4] = {input_h_stride * k->stride_y * sizeof(float),
                                input_w_stride * sizeof(float),
                                input_h_stride * sizeof(float),
                                input_w_stride * k->stride_x * sizeof(float)};

    snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3],
                     ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

    // Setup SSRs bounds and strides for kernel
    // We use only 3D SSRs here as the inner most dimension is repeated
    const uint32_t ssr1_b[3] = {k->dim_kernel_x, k->dim_kernel_y, k->dim_out_x};
    const uint32_t ssr1_i[3] = {kernel_w_stride * sizeof(float),
                                kernel_h_stride * sizeof(float), 0};

    snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2], ssr1_i[0],
                     ssr1_i[1], ssr1_i[2]);

    // Repeat the innermost value `max_unroll` times
    snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);

    // channel dimension `k->ch_out` (same as `k->ch_in`) is parallelized over
    // cores
    for (uint32_t co = compute_id * 2; co < k->ch_out; co += compute_num * 2) {
        uint32_t h0 = 0;

        // If `k->dim_out_y` is not divisible by `unroll`, we have to clean up
        // at the end which modifies the SSR loops, thus initialize it again
        // correctly
        if (cleanup_unroll) {
            snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_i[0], ssr1_i[1], ssr1_i[2]);

            snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);
        }

        // Output height dimension `k->dim_out_y` first split
        for (h0 = 0; h0 < k->dim_out_y / max_unroll; h0++) {
            // SSR address setup and enable
            snrt_ssr_read(
                SNRT_SSR_DM0, SNRT_SSR_4D,
                (void *)(k->pInBuffer +
                         h0 * max_unroll * k->stride_y * input_h_stride + co));
            snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D, (void *)(k->pWeight + co));

            // Output width dimension `k->dim_out_x`
            for (uint32_t w = 0; w < k->dim_out_x; w++) {
                volatile v2s sum[max_unroll];
                // pointer to output buffer location where intermediate values
                // are read from and stored
                v2s *_pOutBuffer =
                    (v2s *)(&k->pOutBuffer[(h0 * max_unroll) * output_h_stride +
                                           w * output_w_stride + co]);

                // Initialize registers with zero if the first
                // tile is processed, otherwise load intermediate values
                if (k->flag_y_accumulate_start) {
                    for (uint32_t i = 0; i < max_unroll; i++) {
                        sum[i].f64 = 0.0;
                    }
                } else {
                    for (uint32_t i = 0; i < max_unroll; i++) {
                        sum[i].vec = _pOutBuffer[i * output_h_stride / 2].vec;
                    }
                }

                snrt_ssr_enable();

                asm volatile(
                    // frep over vfMACs
                    "frep.o %[n_frep], 8, 0, 0 \n"
                    "vfmac.s %[sum0], ft0, ft1 \n"
                    "vfmac.s %[sum1], ft0, ft1 \n"
                    "vfmac.s %[sum2], ft0, ft1 \n"
                    "vfmac.s %[sum3], ft0, ft1 \n"
                    "vfmac.s %[sum4], ft0, ft1 \n"
                    "vfmac.s %[sum5], ft0, ft1 \n"
                    "vfmac.s %[sum6], ft0, ft1 \n"
                    "vfmac.s %[sum7], ft0, ft1 \n"
                    : [ sum0 ] "+f"(sum[0].f64), [ sum1 ] "+f"(sum[1].f64),
                      [ sum2 ] "+f"(sum[2].f64), [ sum3 ] "+f"(sum[3].f64),
                      [ sum4 ] "+f"(sum[4].f64), [ sum5 ] "+f"(sum[5].f64),
                      [ sum6 ] "+f"(sum[6].f64), [ sum7 ] "+f"(sum[7].f64)
                    : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x - 1)
                    : "ft0", "ft1", "ft2");

                snrt_ssr_disable();

                // Write back output values
                for (uint32_t i = 0; i < max_unroll; i++) {
                    _pOutBuffer[i * output_h_stride / 2] = sum[i];
                }
            }
        }

        // Clean up rows
        if (cleanup_unroll) {
            // Modify most inner loop unrolling
            snrt_ssr_loop_4d(SNRT_SSR_DM0, cleanup_unroll, ssr0_b[1], ssr0_b[2],
                             ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                             ssr0_i[3]);

            snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                             ssr1_i[0], ssr1_i[1], ssr1_i[2]);

            snrt_ssr_repeat(SNRT_SSR_DM1, cleanup_unroll);

            // SSR address setup and enable
            snrt_ssr_read(
                SNRT_SSR_DM0, SNRT_SSR_4D,
                (void *)(k->pInBuffer +
                         h0 * max_unroll * k->stride_y * input_h_stride + co));
            snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D, (void *)(k->pWeight + co));

            // Output width dimension `k->dim_out_x`
            for (uint32_t w = 0; w < k->dim_out_x; w++) {
                volatile v2s sum[max_unroll];

                // pointer to output buffer location where intermediate values
                // are read from and stored
                v2s *_pOutBuffer =
                    (v2s *)(&k->pOutBuffer[(h0 * max_unroll) * output_h_stride +
                                           w * output_w_stride + co]);

                if (k->flag_y_accumulate_start) {
                    for (uint32_t i = 0; i < cleanup_unroll; i++) {
                        sum[i].f64 = 0.0;
                    }
                } else {
                    for (uint32_t i = 0; i < cleanup_unroll; i++) {
                        sum[i].vec = _pOutBuffer[i * output_h_stride / 2].vec;
                    }
                }

                snrt_ssr_enable();

                switch (cleanup_unroll) {
                    case 7:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 7, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            "vfmac.s %[sum4], ft0, ft1 \n"
                            "vfmac.s %[sum5], ft0, ft1 \n"
                            "vfmac.s %[sum6], ft0, ft1 \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64),
                              [ sum4 ] "+f"(sum[4].f64),
                              [ sum5 ] "+f"(sum[5].f64),
                              [ sum6 ] "+f"(sum[6].f64)
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 6:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 6, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            "vfmac.s %[sum4], ft0, ft1 \n"
                            "vfmac.s %[sum5], ft0, ft1 \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64),
                              [ sum4 ] "+f"(sum[4].f64),
                              [ sum5 ] "+f"(sum[5].f64)
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 5:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 5, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            "vfmac.s %[sum4], ft0, ft1 \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64),
                              [ sum4 ] "+f"(sum[4].f64)
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 4:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 4, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            "vfmac.s %[sum3], ft0, ft1 \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64),
                              [ sum3 ] "+f"(sum[3].f64)
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 3:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 3, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            "vfmac.s %[sum2], ft0, ft1 \n"
                            : [ sum0 ] "+f"(sum[0].f64),
                              [ sum1 ] "+f"(sum[1].f64),
                              [ sum2 ] "+f"(sum[2].f64)
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 2:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 2, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            "vfmac.s %[sum1], ft0, ft1 \n"
                            :
                            [ sum0 ] "+f"(sum[0].f64), [ sum1 ] "+f"(sum[1].f64)
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                    case 1:
                        asm volatile(
                            // frep over vfMACs
                            "frep.o %[n_frep], 1, 0, 0 \n"
                            "vfmac.s %[sum0], ft0, ft1 \n"
                            : [ sum0 ] "+f"(sum[0].f64)
                            : [ n_frep ] "r"(k->dim_kernel_y * k->dim_kernel_x -
                                             1)
                            : "ft0", "ft1", "ft2");
                        break;
                }

                snrt_ssr_disable();

                for (uint32_t i = 0; i < cleanup_unroll; i++) {
                    _pOutBuffer[i * output_h_stride / 2].vec = sum[i].vec;
                }
            }
        }
    }

    // Cores need to be synchronized as the conv2d is parallized over output
    // channels but BatchNorm/ReLU uses the channel dimension for SIMD
    // instructions
    snrt_cluster_hw_barrier();

    if (k->flag_batch_norm | k->flag_relu) {
        bn_relu(k->pOutBuffer, k->dim_out_x, k->dim_out_y, k->ch_out, k->kappa,
                k->lambda, k->flag_relu, k->flag_batch_norm);
    }
}

/**
 * @brief implementation of a single-precision fp convolutional kernel
 * for DORY trials. Currently does a direct convolution without im2col.
 * The memory layout of input feature map is C x H x W, resp. Co x Fh x Fw x Ci
 * for weights Howevever, the output memory layout is H x W x C. This kernel
 * should be used for the first layers in a network where Ci is very small and
 * usually odd numbered. Fuses multiple layers together (Conv2d, Batchnorm,
 * Relu) that can be enabled with a flag
 * @param k kernel_fp32 struct reference that holds all parameters
 */
static inline void conv2d_chw_fp32(kernel_fp32 *k) {
    // Parallelization/Pipelining parameters
    const uint32_t compute_id = snrt_cluster_compute_core_num();
    const uint32_t compute_num =
        (snrt_cluster_compute_core_num()) ? snrt_cluster_compute_core_num() : 1;
    const uint32_t max_unroll = 8;  // Maximum number of unrolling
    const uint32_t cleanup_unroll = k->dim_out_y % max_unroll;

    // Calculate strides to access specific dimensions
    // of input feature map and weights
    // Input feature map (Ci x H x W)
    // Calculate effective H, W dimension including padding
    const uint32_t dim_in_eff_x =
        k->dim_in_x + k->padding_x_left + k->padding_x_right;
    const uint32_t dim_in_eff_y =
        k->dim_in_y + k->padding_y_top + k->padding_y_bottom;
    const uint32_t input_w_stride = 1;
    const uint32_t input_h_stride = dim_in_eff_x;
    const uint32_t input_ci_stride = input_h_stride * dim_in_eff_y;

    // Output feature map (H x W x Co)
    const uint32_t output_co_stride = 1;
    const uint32_t output_w_stride = k->ch_out;
    const uint32_t output_h_stride = output_w_stride * k->dim_out_x;

    // Weight (Co x Ci x Fh x Fw)
    const uint32_t kernel_fw_stride = 1;
    const uint32_t kernel_fh_stride = k->dim_kernel_x;
    const uint32_t kernel_ci_stride = kernel_fh_stride * k->dim_kernel_y;
    const uint32_t kernel_co_stride = kernel_ci_stride * k->ch_in;

    // Reference Loops
    // for (int co = compute_id; co < k->ch_out; co += compute_num) {
    //     for (int ci = 0; i < k->ch_in; ci++) {
    //         for (int h0 = 0; h0 < k->dim_out_y / unroll; h0++) {
    //             for (int w = 0; w < k->dim_out_x; w+=stridex_x) {
    //                 for (int fh = 0; fh < k->dim_kernel_y; fh++) {
    //                     for (int fw = 0; fw < k->dim_kernel_x; fw++) {
    //                         for (int h1 = 0; h1 < unroll; h1++) {
    //                             int h = h0 * unroll + h1;
    //                             k->pOutBuffer[co][h/str_y][w/str_x] +=
    //                             k->pInBuffer[ci][h+fh][w+fw] *
    //                                                     k->pWeights[co][ci][fh][fw]
    //                         }
    //                     }
    //                 }
    //             }
    //         }
    //     }
    // }

    // Setup SSRs bounds and strides for input feature map
    const uint32_t ssr0_b[4] = {max_unroll, k->dim_kernel_x / 2,
                                k->dim_kernel_y, k->dim_out_x};
    const uint32_t ssr0_i[4] = {input_h_stride * k->stride_y * sizeof(float),
                                input_w_stride * sizeof(v2s),
                                input_h_stride * sizeof(float),
                                input_w_stride * k->stride_x * sizeof(float)};

    // printf("bounds [%d, %d, %d, %d] strides [%d, %d, %d, %d]\n",  ssr0_b[0],
    // ssr0_b[1], ssr0_b[2], ssr0_b[3],
    //  ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

    snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2], ssr0_b[3],
                     ssr0_i[0], ssr0_i[1], ssr0_i[2], ssr0_i[3]);

    // Setup SSRs bounds and strides for kernel
    // We use only 3D SSRs here as the inner most dimension is repeated
    const uint32_t ssr1_b[3] = {k->dim_kernel_x / 2, k->dim_kernel_y,
                                k->dim_out_x};
    const uint32_t ssr1_i[3] = {kernel_fw_stride * sizeof(v2s),
                                kernel_fh_stride * sizeof(float), 0};

    snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2], ssr1_i[0],
                     ssr1_i[1], ssr1_i[2]);

    // Repeat the innermost value `max_unroll` times
    snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);

    // Output channel dimension `k->ch_out` is parallelized over cores
    for (uint32_t co = compute_id; co < k->ch_out; co += compute_num) {
        for (uint32_t ci = 0; ci < k->ch_in; ci++) {
            uint32_t h = 0, h0 = 0;

            // If `k->dim_out_y` is not divisible by `unroll`, we have to clean
            // up at the end which modifies the SSR loops, thus initialize it
            // again correctly
            if (cleanup_unroll) {
                snrt_ssr_loop_4d(SNRT_SSR_DM0, ssr0_b[0], ssr0_b[1], ssr0_b[2],
                                 ssr0_b[3], ssr0_i[0], ssr0_i[1], ssr0_i[2],
                                 ssr0_i[3]);

                snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                                 ssr1_i[0], ssr1_i[1], ssr1_i[2]);

                snrt_ssr_repeat(SNRT_SSR_DM1, max_unroll);
            }

            // Output height dimension `k->dim_out_y` first split
            for (h0 = 0; h0 < k->dim_out_y / max_unroll;
                 h0++, h += max_unroll) {
                // SSR address setup and enable
                snrt_ssr_read(
                    SNRT_SSR_DM0, SNRT_SSR_4D,
                    (void *)(k->pInBuffer + h * k->stride_y * input_h_stride +
                             ci * input_ci_stride));
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D,
                              (void *)(k->pWeight + ci * kernel_ci_stride +
                                       co * kernel_co_stride));

                // Output width dimension `k->dim_out_x`
                for (uint32_t w = 0; w < k->dim_out_x; w++) {
                    volatile v2s sum[max_unroll];
                    volatile float reduce_reg[max_unroll];
                    // pointer to output buffer location where intermediate
                    // values are read from and stored
                    float *_pOutBuffer = &k->pOutBuffer[h * output_h_stride +
                                                        w * output_w_stride +
                                                        co * output_co_stride];

                    // Initialize registers with zero if the first
                    // tile is processed, otherwise load intermediate values
                    if (k->flag_y_accumulate_start && (ci == 0)) {
                        // printf("Zero: ci %d/%d h %d/%d w %d/%d\n", ci,
                        // k->ch_in, h, k->dim_out_y, w, k->dim_out_x);
                        for (uint32_t i = 0; i < max_unroll; i++) {
                            sum[i].f64 = 0.0;
                            reduce_reg[i] = 0.0;
                        }
                    } else {
                        // printf("Value: ci %d/%d h %d/%d w %d/%d\n", ci,
                        // k->ch_in, h, k->dim_out_y, w, k->dim_out_x);
                        for (uint32_t i = 0; i < max_unroll; i++) {
                            sum[i].f64 = 0.0;
                            reduce_reg[i] = _pOutBuffer[i * output_h_stride];
                        }
                    }

                    snrt_ssr_enable();

                    asm volatile(
                        // frep over vfMACs
                        "frep.o %[n_frep], 8, 0, 0 \n"
                        "vfmac.s %[sum0], ft0, ft1 \n"
                        "vfmac.s %[sum1], ft0, ft1 \n"
                        "vfmac.s %[sum2], ft0, ft1 \n"
                        "vfmac.s %[sum3], ft0, ft1 \n"
                        "vfmac.s %[sum4], ft0, ft1 \n"
                        "vfmac.s %[sum5], ft0, ft1 \n"
                        "vfmac.s %[sum6], ft0, ft1 \n"
                        "vfmac.s %[sum7], ft0, ft1 \n"
                        // Sum reduce vector
                        "vfsum.s %[reduce_reg0], %[sum0] \n"
                        "vfsum.s %[reduce_reg1], %[sum1] \n"
                        "vfsum.s %[reduce_reg2], %[sum2] \n"
                        "vfsum.s %[reduce_reg3], %[sum3] \n"
                        "vfsum.s %[reduce_reg4], %[sum4] \n"
                        "vfsum.s %[reduce_reg5], %[sum5] \n"
                        "vfsum.s %[reduce_reg6], %[sum6] \n"
                        "vfsum.s %[reduce_reg7], %[sum7] \n"
                        : [ sum0 ] "+f"(sum[0].f64), [ sum1 ] "+f"(sum[1].f64),
                          [ sum2 ] "+f"(sum[2].f64), [ sum3 ] "+f"(sum[3].f64),
                          [ sum4 ] "+f"(sum[4].f64), [ sum5 ] "+f"(sum[5].f64),
                          [ sum6 ] "+f"(sum[6].f64), [ sum7 ] "+f"(sum[7].f64),
                          [ reduce_reg0 ] "+f"(reduce_reg[0]),
                          [ reduce_reg1 ] "+f"(reduce_reg[1]),
                          [ reduce_reg2 ] "+f"(reduce_reg[2]),
                          [ reduce_reg3 ] "+f"(reduce_reg[3]),
                          [ reduce_reg4 ] "+f"(reduce_reg[4]),
                          [ reduce_reg5 ] "+f"(reduce_reg[5]),
                          [ reduce_reg6 ] "+f"(reduce_reg[6]),
                          [ reduce_reg7 ] "+f"(reduce_reg[7])
                        : [ n_frep ] "r"(k->dim_kernel_x / 2 * k->dim_kernel_y -
                                         1)
                        : "ft0", "ft1", "ft2");

                    snrt_ssr_disable();

                    // Write back output values
                    for (uint32_t i = 0; i < max_unroll; i++) {
                        _pOutBuffer[i * output_h_stride] = reduce_reg[i];
                    }
                }
            }

            // Clean up rows
            if (cleanup_unroll) {
                // Modify most inner loop unrolling
                snrt_ssr_loop_4d(SNRT_SSR_DM0, cleanup_unroll, ssr0_b[1],
                                 ssr0_b[2], ssr0_b[3], ssr0_i[0], ssr0_i[1],
                                 ssr0_i[2], ssr0_i[3]);

                snrt_ssr_loop_3d(SNRT_SSR_DM1, ssr1_b[0], ssr1_b[1], ssr1_b[2],
                                 ssr1_i[0], ssr1_i[1], ssr1_i[2]);

                snrt_ssr_repeat(SNRT_SSR_DM1, cleanup_unroll);

                // SSR address setup and enable
                snrt_ssr_read(
                    SNRT_SSR_DM0, SNRT_SSR_4D,
                    (void *)(k->pInBuffer + h * k->stride_y * input_h_stride +
                             ci * input_ci_stride));
                snrt_ssr_read(SNRT_SSR_DM1, SNRT_SSR_3D,
                              (void *)(k->pWeight + ci * kernel_ci_stride +
                                       co * kernel_co_stride));

                // Output width dimension `k->dim_out_x`
                for (uint32_t w = 0; w < k->dim_out_x; w++) {
                    volatile v2s sum[max_unroll];
                    volatile float reduce_reg[max_unroll];

                    // pointer to output buffer location where intermediate
                    // values are read from and stored
                    float *_pOutBuffer = &k->pOutBuffer[h * output_h_stride +
                                                        w * output_w_stride +
                                                        co * output_co_stride];

                    if (k->flag_y_accumulate_start && (ci == 0)) {
                        for (uint32_t i = 0; i < cleanup_unroll; i++) {
                            sum[i].f64 = 0.0;
                            reduce_reg[i] = 0.0;
                        }
                    } else {
                        for (uint32_t i = 0; i < cleanup_unroll; i++) {
                            sum[i].f64 = 0.0;
                            reduce_reg[i] = _pOutBuffer[i * output_h_stride];
                        }
                    }

                    snrt_ssr_enable();

                    switch (cleanup_unroll) {
                        case 7:
                            asm volatile(
                                // frep over vfMACs
                                "frep.o %[n_frep], 7, 0, 0 \n"
                                "vfmac.s %[sum0], ft0, ft1 \n"
                                "vfmac.s %[sum1], ft0, ft1 \n"
                                "vfmac.s %[sum2], ft0, ft1 \n"
                                "vfmac.s %[sum3], ft0, ft1 \n"
                                "vfmac.s %[sum4], ft0, ft1 \n"
                                "vfmac.s %[sum5], ft0, ft1 \n"
                                "vfmac.s %[sum6], ft0, ft1 \n"
                                // Sum reduce vector
                                "vfsum.s %[reduce_reg0], %[sum0] \n"
                                "vfsum.s %[reduce_reg1], %[sum1] \n"
                                "vfsum.s %[reduce_reg2], %[sum2] \n"
                                "vfsum.s %[reduce_reg3], %[sum3] \n"
                                "vfsum.s %[reduce_reg4], %[sum4] \n"
                                "vfsum.s %[reduce_reg5], %[sum5] \n"
                                "vfsum.s %[reduce_reg6], %[sum6] \n"
                                : [ sum0 ] "+f"(sum[0].f64),
                                  [ sum1 ] "+f"(sum[1].f64),
                                  [ sum2 ] "+f"(sum[2].f64),
                                  [ sum3 ] "+f"(sum[3].f64),
                                  [ sum4 ] "+f"(sum[4].f64),
                                  [ sum5 ] "+f"(sum[5].f64),
                                  [ sum6 ] "+f"(sum[6].f64),
                                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                                  [ reduce_reg4 ] "+f"(reduce_reg[4]),
                                  [ reduce_reg5 ] "+f"(reduce_reg[5]),
                                  [ reduce_reg6 ] "+f"(reduce_reg[6])
                                : [ n_frep ] "r"(
                                    k->dim_kernel_x / 2 * k->dim_kernel_y - 1)
                                : "ft0", "ft1", "ft2");
                            break;
                        case 6:
                            asm volatile(
                                // frep over vfMACs
                                "frep.o %[n_frep], 6, 0, 0 \n"
                                "vfmac.s %[sum0], ft0, ft1 \n"
                                "vfmac.s %[sum1], ft0, ft1 \n"
                                "vfmac.s %[sum2], ft0, ft1 \n"
                                "vfmac.s %[sum3], ft0, ft1 \n"
                                "vfmac.s %[sum4], ft0, ft1 \n"
                                "vfmac.s %[sum5], ft0, ft1 \n"
                                // Sum reduce vector
                                "vfsum.s %[reduce_reg0], %[sum0] \n"
                                "vfsum.s %[reduce_reg1], %[sum1] \n"
                                "vfsum.s %[reduce_reg2], %[sum2] \n"
                                "vfsum.s %[reduce_reg3], %[sum3] \n"
                                "vfsum.s %[reduce_reg4], %[sum4] \n"
                                "vfsum.s %[reduce_reg5], %[sum5] \n"
                                : [ sum0 ] "+f"(sum[0].f64),
                                  [ sum1 ] "+f"(sum[1].f64),
                                  [ sum2 ] "+f"(sum[2].f64),
                                  [ sum3 ] "+f"(sum[3].f64),
                                  [ sum4 ] "+f"(sum[4].f64),
                                  [ sum5 ] "+f"(sum[5].f64),
                                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                                  [ reduce_reg4 ] "+f"(reduce_reg[4]),
                                  [ reduce_reg5 ] "+f"(reduce_reg[5])
                                : [ n_frep ] "r"(
                                    k->dim_kernel_x / 2 * k->dim_kernel_y - 1)
                                : "ft0", "ft1", "ft2");
                            break;
                        case 5:
                            asm volatile(
                                // frep over vfMACs
                                "frep.o %[n_frep], 5, 0, 0 \n"
                                "vfmac.s %[sum0], ft0, ft1 \n"
                                "vfmac.s %[sum1], ft0, ft1 \n"
                                "vfmac.s %[sum2], ft0, ft1 \n"
                                "vfmac.s %[sum3], ft0, ft1 \n"
                                "vfmac.s %[sum4], ft0, ft1 \n"
                                // Sum reduce vector
                                "vfsum.s %[reduce_reg0], %[sum0] \n"
                                "vfsum.s %[reduce_reg1], %[sum1] \n"
                                "vfsum.s %[reduce_reg2], %[sum2] \n"
                                "vfsum.s %[reduce_reg3], %[sum3] \n"
                                "vfsum.s %[reduce_reg4], %[sum4] \n"
                                : [ sum0 ] "+f"(sum[0].f64),
                                  [ sum1 ] "+f"(sum[1].f64),
                                  [ sum2 ] "+f"(sum[2].f64),
                                  [ sum3 ] "+f"(sum[3].f64),
                                  [ sum4 ] "+f"(sum[4].f64),
                                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                                  [ reduce_reg3 ] "+f"(reduce_reg[3]),
                                  [ reduce_reg4 ] "+f"(reduce_reg[4])
                                : [ n_frep ] "r"(
                                    k->dim_kernel_x / 2 * k->dim_kernel_y - 1)
                                : "ft0", "ft1", "ft2");
                            break;
                        case 4:
                            asm volatile(
                                // frep over vfMACs
                                "frep.o %[n_frep], 4, 0, 0 \n"
                                "vfmac.s %[sum0], ft0, ft1 \n"
                                "vfmac.s %[sum1], ft0, ft1 \n"
                                "vfmac.s %[sum2], ft0, ft1 \n"
                                "vfmac.s %[sum3], ft0, ft1 \n"
                                // Sum reduce vector
                                "vfsum.s %[reduce_reg0], %[sum0] \n"
                                "vfsum.s %[reduce_reg1], %[sum1] \n"
                                "vfsum.s %[reduce_reg2], %[sum2] \n"
                                "vfsum.s %[reduce_reg3], %[sum3] \n"
                                : [ sum0 ] "+f"(sum[0].f64),
                                  [ sum1 ] "+f"(sum[1].f64),
                                  [ sum2 ] "+f"(sum[2].f64),
                                  [ sum3 ] "+f"(sum[3].f64),
                                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                                  [ reduce_reg2 ] "+f"(reduce_reg[2]),
                                  [ reduce_reg3 ] "+f"(reduce_reg[3])
                                : [ n_frep ] "r"(
                                    k->dim_kernel_x / 2 * k->dim_kernel_y - 1)
                                : "ft0", "ft1", "ft2");
                            break;
                        case 3:
                            asm volatile(
                                // frep over vfMACs
                                "frep.o %[n_frep], 3, 0, 0 \n"
                                "vfmac.s %[sum0], ft0, ft1 \n"
                                "vfmac.s %[sum1], ft0, ft1 \n"
                                "vfmac.s %[sum2], ft0, ft1 \n"
                                // Sum reduce vector
                                "vfsum.s %[reduce_reg0], %[sum0] \n"
                                "vfsum.s %[reduce_reg1], %[sum1] \n"
                                "vfsum.s %[reduce_reg2], %[sum2] \n"
                                : [ sum0 ] "+f"(sum[0].f64),
                                  [ sum1 ] "+f"(sum[1].f64),
                                  [ sum2 ] "+f"(sum[2].f64),
                                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                                  [ reduce_reg1 ] "+f"(reduce_reg[1]),
                                  [ reduce_reg2 ] "+f"(reduce_reg[2])
                                : [ n_frep ] "r"(
                                    k->dim_kernel_x / 2 * k->dim_kernel_y - 1)
                                : "ft0", "ft1", "ft2");
                            break;
                        case 2:
                            asm volatile(
                                // frep over vfMACs
                                "frep.o %[n_frep], 2, 0, 0 \n"
                                "vfmac.s %[sum0], ft0, ft1 \n"
                                "vfmac.s %[sum1], ft0, ft1 \n"
                                // Sum reduce vector
                                "vfsum.s %[reduce_reg0], %[sum0] \n"
                                "vfsum.s %[reduce_reg1], %[sum1] \n"
                                : [ sum0 ] "+f"(sum[0].f64),
                                  [ sum1 ] "+f"(sum[1].f64),
                                  [ reduce_reg0 ] "+f"(reduce_reg[0]),
                                  [ reduce_reg1 ] "+f"(reduce_reg[1])
                                : [ n_frep ] "r"(
                                    k->dim_kernel_x / 2 * k->dim_kernel_y - 1)
                                : "ft0", "ft1", "ft2");
                            break;
                        case 1:
                            asm volatile(
                                // frep over vfMACs
                                "frep.o %[n_frep], 1, 0, 0 \n"
                                "vfmac.s %[sum0], ft0, ft1 \n"
                                // Sum reduce vector
                                "vfsum.s %[reduce_reg0], %[sum0] \n"
                                : [ sum0 ] "+f"(sum[0].f64),
                                  [ reduce_reg0 ] "+f"(reduce_reg[0])
                                : [ n_frep ] "r"(
                                    k->dim_kernel_x / 2 * k->dim_kernel_y - 1)
                                : "ft0", "ft1", "ft2");
                            break;
                    }

                    snrt_ssr_disable();

                    for (uint32_t i = 0; i < cleanup_unroll; i++) {
                        _pOutBuffer[i * output_h_stride] = reduce_reg[i];
                    }
                }
            }
        }
    }

    // Cores need to be synchronized as the conv2d is parallized over output
    // channels but BatchNorm/ReLU uses the channel dimension for SIMD
    // instructions
    snrt_cluster_hw_barrier();

    if (k->flag_batch_norm | k->flag_relu) {
        bn_relu(k->pOutBuffer, k->dim_out_x, k->dim_out_y, k->ch_out, k->kappa,
                k->lambda, k->flag_relu, k->flag_batch_norm);
    }
}

/**
 * @brief conv2d layer that handles data transfers in a double buffered fashion
 *
 * @param l conv_layer struct that holds addresses and parameters
 */
void conv2d_layer(const conv_layer *l) {
    uint32_t cluster_num = snrt_cluster_num();
    uint32_t cluster_id = snrt_cluster_idx();
    uint32_t compute_num = snrt_cluster_compute_core_num();
    uint32_t compute_id = snrt_global_core_idx();

    const uint32_t cluster_per_quadrant = min(4, cluster_num);

    // typedef struct cluster_mem_alloc_struct {
    //     double im2col[2][compute_num][l->FW*l->FH*l->TILE_CI+1];
    //     double ifmap[2][l->FH][compute_num + l->FW - 1][l->TILE_CI];
    //     double weights[compute_num][l->FH*l->FW*l->TILE_CI+1];
    //     double ofmap[2][compute_num][8];
    //     volatile uint32_t synch_flag[2];
    // } cluster_mem_alloc;

    // im2col[2][compute_num][l->FW*l->FH*l->TILE_CI+1];
    uint32_t im2col_row_stride = l->FW * l->FH * l->TILE_CI + 1;
    uint32_t im2col_mat_stride = im2col_row_stride * compute_num;
    uint32_t im2col_size = 2 * im2col_mat_stride;

    // ifmap[2][l->FH][compute_num + l->FW - 1][l->TILE_CI];
    uint32_t ifmap_col_stride = l->TILE_CI;
    uint32_t ifmap_row_stride = ifmap_col_stride * (compute_num + l->FW - 1);
    uint32_t ifmap_stride = ifmap_row_stride * l->FH;
    uint32_t ifmap_size = 2 * ifmap_stride;

    // weights[compute_num][l->FH*l->FW*l->TILE_CI+1];
    uint32_t weights_co_stride = l->FH * l->FW * l->TILE_CI + 1;
    uint32_t weights_size = compute_num * weights_co_stride;

    // ofmap[2][compute_num][8];
    uint32_t ofmap_co_stride = 8;
    uint32_t ofmap_stride = compute_num * ofmap_co_stride;
    uint32_t ofmap_size = 2 * ofmap_stride;

    double *ptr = (double *)snrt_l1_next();
    double *im2col = ptr;
    ptr += im2col_size;
    double *ifmap = ptr;
    ptr += ifmap_size;
    double *weights = ptr;
    ptr += weights_size;
    double *ofmap = ptr;
    ptr += ofmap_size;
    volatile uint32_t *synch_flag = (void *)ptr;

    uint32_t write_buf = 0;
    uint32_t read_buf = 0;

    int32_t oh_prev = -1;
    int32_t ow_prev = -1;

    // snrt_global_barrier();

    snrt_mcycle();

    // Distribute output channels across clusters
    for (uint32_t co = cluster_id * compute_num; co < l->CO;
         co += cluster_num * compute_num) {
        // Tile CI dimension
        for (uint32_t ci = 0; ci < l->CI; ci += l->TILE_CI) {
            snrt_mcycle();

            // Load weights in the beginning
            if (snrt_is_dm_core()) {
                snrt_dma_start_tracking();

                // Weights are stored in CO x FH x FW x CI format with
                // additional padding (CI + 1) to prevent banking conflicts
                for (uint32_t _co = 0; _co < 8; _co++) {
                    if (l->TILE_CI == l->CI) {
                        snrt_dma_txid_t weight_txid = snrt_dma_start_1d(
                            &weights[_co * weights_co_stride], /* dst */
                            &l->weights[(co + _co) * l->FH * l->FW *
                                        l->CI], /* src */
                            sizeof(double) * l->CI * l->FH * l->FW /* size */);
                    } else {
                        snrt_dma_txid_t weight_txid = snrt_dma_start_2d(
                            &weights[_co * weights_co_stride], /* dst */
                            &l->weights[(co + _co) * l->FH * l->FW * l->CI +
                                        ci],             /* src */
                            sizeof(double) * l->TILE_CI, /* size */
                            sizeof(double) * l->TILE_CI, /* dst_stride */
                            sizeof(double) * l->CI,      /* src_stride */
                            l->FH * l->FW /* repetitions */);
                    }
                }
                snrt_dma_wait_all();

                snrt_dma_stop_tracking();
            }
            snrt_mcycle();

            // Iterate over pixels, outer loop iterates over tiles of columns in
            // feature map, inner loop iterates over rows. Each core processes
            // one pixel at a time. In case of cluster2cluster communication,
            // each cluster in a quadrant starts with a different row. The first
            // time, all clusters load a different row from memory. In each
            // subsequent iteration the leading cluster loads a new row from
            // main memory and the others load from the next cluster
            for (uint32_t ow = 0; ow < l->OW; ow += compute_num) {
                if (l->cluster2cluster) {
                    synch_flag[0] = 0;
                    synch_flag[1] = 0;
                }

                for (uint32_t _oh = 0; _oh < l->OH; _oh++) {
                    // If cluster2cluster is enabled, each cluster starts with a
                    // different row, requires that OH is bigger than
                    // cluster_num (per quadrant at least)
                    uint32_t oh = ((cluster_per_quadrant - 1) -
                                   (cluster_id % cluster_per_quadrant) + _oh) %
                                  l->OH;

                    if (snrt_is_dm_core()) {
                        uint32_t n_ifmap_pixel_read =
                            min(compute_num + l->FW - 1,
                                l->IW - ow + (l->pad << 1));
                        uint32_t n_ofmap_pixel_read =
                            min(compute_num, l->OW - ow);
                        uint32_t n_ofmap_pixel_write =
                            min(compute_num, l->OW - ow_prev);

                        // Load the intermediate outputs from memory
                        if (ci != 0) {
                            snrt_dma_txid_t ofmap_txid = snrt_dma_start_2d(
                                &ofmap[write_buf * ofmap_stride], /* dst */
                                &l->ofmap[(oh * l->OW + ow) * l->CO +
                                          co],          /* src */
                                sizeof(double) * 8,     /* size */
                                sizeof(double) * 8,     /* dst_stride */
                                sizeof(double) * l->CO, /* src_stride */
                                n_ofmap_pixel_read);    /* repetitions */
                            snrt_dma_wait_all();
                        } else {
                            snrt_dma_memset(
                                &ofmap[write_buf * ofmap_stride], 0,
                                sizeof(double) * 8 * n_ofmap_pixel_read);
                        }

                        if (l->cluster2cluster) {
                            // All except last cluster need to wait until
                            // cluster synch flag is cleared
                            if (cluster_id % cluster_per_quadrant !=
                                cluster_per_quadrant - 1) {
                                while (synch_flag[write_buf])
                                    ;
                            }
                        }

                        snrt_dma_start_tracking();

                        // The input feature map needs to be loaded from main
                        // memory in the following cases: 1) cluster2cluster
                        // communication is not enabled 2) The first iteration,
                        // every cluster loads a row from main memory 3) The
                        // leading cluster always loads rows from main memory
                        if (!l->cluster2cluster || _oh == 0 ||
                            cluster_id % cluster_per_quadrant == 0) {
                            // Transfer in FH * (compute_num + FW - 1) pixels
                            // such that im2col transformation can be performed
                            // for every core

                            for (uint32_t fh = 0; fh < l->FH; fh++) {
                                // Fill horizontal lines with zeros for padding
                                if (oh + fh < l->pad ||
                                    oh + fh >= l->IH + ((l->FH - 1) >> 1)) {
                                    snrt_dma_memset(
                                        &ifmap[write_buf * ifmap_stride +
                                               fh * ifmap_row_stride],
                                        0,
                                        sizeof(double) * l->TILE_CI *
                                            n_ifmap_pixel_read);
                                } else {
                                    uint32_t padding_left =
                                        (ow < l->pad) ? (l->pad - ow) : 0;
                                    uint32_t padding_right =
                                        (ow + compute_num + l->pad <= l->OW)
                                            ? 0
                                            : n_ifmap_pixel_read -
                                                  ((l->FW - 1) >> 1) -
                                                  (l->IW - ow);

                                    // If there is need for padding, set whole
                                    // buffer to zero
                                    if (padding_left || padding_right) {
                                        snrt_dma_memset(
                                            &ifmap[write_buf * ifmap_stride +
                                                   fh * ifmap_row_stride],
                                            0,
                                            sizeof(double) *
                                                (compute_num + l->FW - 1) *
                                                l->TILE_CI);
                                    }

                                    // Then fill in the rest of the values
                                    snrt_dma_txid_t ifmap_txid =
                                        snrt_dma_start_2d(
                                            &ifmap[write_buf * ifmap_stride +
                                                   fh * ifmap_row_stride +
                                                   padding_left *
                                                       ifmap_col_stride], /* dst
                                                                           */
                                            (double *)&l->ifmap
                                                [((oh + fh - l->pad) * l->IW +
                                                  ow -
                                                  (l->pad - padding_left)) *
                                                     l->CI +
                                                 ci], /* src */
                                            sizeof(double) *
                                                l->TILE_CI, /* size */
                                            sizeof(double) *
                                                l->TILE_CI, /* dst_stride */
                                            sizeof(double) *
                                                l->CI, /* src_stride */
                                            n_ifmap_pixel_read - padding_left -
                                                padding_right /* n_ifmap_pixel_read
                                                               */
                                            /* repetitions */);
                                    snrt_dma_wait_all();
                                }
                            }

                        }

                        // Transfer tile from other cluster to memory
                        else {
                            // A cluster always loads from the previous cluster
                            volatile uint32_t *src_synch_flag =
                                (void *)synch_flag - SNRT_CLUSTER_OFFSET;
                            double *src_ifmap =
                                (void *)ifmap - SNRT_CLUSTER_OFFSET;

                            // Wait until previous cluster has released data
                            if (l->cluster2cluster &&
                                (cluster_id % cluster_per_quadrant) != 0) {
                                while (src_synch_flag[!write_buf] == 0)
                                    ;
                            }

                            // Transfer in FH * (compute_num + FW - 1) pixels
                            // such that im2col transformation can be performed
                            // for every core
                            snrt_dma_txid_t ifmap_txid = snrt_dma_start_1d(
                                &ifmap[write_buf * ifmap_stride],
                                &src_ifmap[!write_buf * ifmap_stride],
                                sizeof(double) * n_ifmap_pixel_read *
                                    l->TILE_CI * l->FH);
                            snrt_dma_wait_all();

                            // clear synch flag of src cluster
                            if (l->cluster2cluster &&
                                (cluster_id % cluster_per_quadrant) != 0) {
                                // printf("Cluster %d clearing synch flag %p\n",
                                // cluster_id, &src_synch_flag[!write_buf]);
                                src_synch_flag[!write_buf] = 0;
                            }
                        }

                        snrt_dma_stop_tracking();

                        // New data is produced
                        if (l->cluster2cluster) {
                            synch_flag[write_buf] = 1;
                            // printf("Cluster %d setting synch flag %p\n",
                            // cluster_id, &synch_flag[write_buf]);
                        }

                        snrt_dma_start_tracking();

                        // Reshuffle and write data to the im2col buffer by the
                        // DMA
                        for (uint32_t n = 0; n < compute_num; n++) {
                            // only construct im2col matrix for leftover pixels
                            if (ow + n < l->OW) {
                                snrt_dma_txid_t im2col_txid = snrt_dma_start_2d(
                                    &im2col[write_buf * im2col_mat_stride +
                                            n * im2col_row_stride], /* dst */
                                    &ifmap[read_buf * ifmap_stride +
                                           n * ifmap_col_stride], /* src */
                                    sizeof(double) * l->FW *
                                        l->TILE_CI, /* size */
                                    sizeof(double) * l->FW *
                                        l->TILE_CI, /* dst_stride */
                                    sizeof(double) * (compute_num + l->FW - 1) *
                                        l->TILE_CI, /* src_stride */
                                    l->FH /* repetitions */);
                            }
                        }

                        // Wait for im2col transform to end, and synchronize
                        // with compute cores
                        snrt_dma_wait_all();
                        snrt_dma_stop_tracking();
                        snrt_cluster_hw_barrier();
                        snrt_mcycle();

                        // Transfer back the output feature maps
                        if (oh_prev + ow_prev >= 0) {
                            snrt_dma_txid_t ofmap_txid = snrt_dma_start_2d(
                                &l->ofmap[(oh_prev * l->OW + ow_prev) * l->CO +
                                          co],                    /* dst */
                                &ofmap[!read_buf * ofmap_stride], /* src */
                                sizeof(double) * 8,               /* size */
                                sizeof(double) * l->CO, /* dst_stride */
                                sizeof(double) * 8,     /* src_stride */
                                n_ofmap_pixel_write);   /* repetitions */
                            snrt_dma_wait_all();
                        }
                        oh_prev = oh;
                        ow_prev = ow;

                        // Toggle write and read buffer
                        write_buf = !write_buf;
                        read_buf = !read_buf;
                    }

                    if (snrt_is_compute_core()) {
                        // Wait until DMA core has finished the im2col transform
                        snrt_mcycle();
                        snrt_cluster_hw_barrier();
                        snrt_mcycle();

                        // Each core performs a matrix multiplication on the
                        // im2col buffer Of size (1 x FHxFWxCI) x (FHxFWxCI x
                        // 8), 8 represents CO and is the unrolling factor
                        // needed to prevent RAW conflicts.
                        if (ow + compute_id < l->OW) {
                            uint32_t setup_SSR =
                                (ci == 0 && ow == 0 && _oh == 0) ? 1 : 0;

                            if (ci != 0 && l->TILE_CI != l->CI) {
                                const uint32_t alpha = 0;
                                gemm_fp64_opt(
                                    1, 8, l->FH * l->FW * l->TILE_CI,
                                    &im2col[read_buf * im2col_mat_stride +
                                            compute_id * im2col_row_stride],
                                    0, 0, weights,
                                    l->FH * l->FW * l->TILE_CI + 1, 1,
                                    &ofmap[write_buf * ofmap_stride +
                                           compute_id * ofmap_co_stride],
                                    0, &alpha, setup_SSR);

                            } else {
                                const uint32_t alpha = 1;
                                gemm_fp64_opt(
                                    1, 8, l->FH * l->FW * l->TILE_CI,
                                    &im2col[read_buf * im2col_mat_stride +
                                            compute_id * im2col_row_stride],
                                    0, 0, weights,
                                    l->FH * l->FW * l->TILE_CI + 1, 1,
                                    &ofmap[write_buf * ofmap_stride +
                                           compute_id * ofmap_co_stride],
                                    0, &alpha, setup_SSR);
                            }
                        }
                        // Toggle read and write buffer
                        read_buf = !read_buf;
                        write_buf = !write_buf;
                    }
                }
            }

            snrt_cluster_hw_barrier();

            // Transfer back last output tile
            if (snrt_is_dm_core()) {
                snrt_dma_txid_t ofmap_txid = snrt_dma_start_2d(
                    &l->ofmap[(oh_prev * l->OW + ow_prev) * l->CO +
                              co],                      /* dst */
                    &ofmap[!read_buf * ofmap_stride],   /* src */
                    sizeof(double) * 8,                 /* size */
                    sizeof(double) * l->CO,             /* dst_stride */
                    sizeof(double) * 8,                 /* src_stride */
                    min(compute_num, l->OW - ow_prev)); /* repetitions */
                snrt_dma_wait_all();
            }
        }
    }

    // snrt_global_barrier();
}
