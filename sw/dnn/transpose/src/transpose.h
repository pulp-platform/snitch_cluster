// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include "math.h"
#include "snrt.h"

/**
 * @struct transpose_layer_t
 * @brief This structure contains all parameters necessary
 *       for computing the Transpose of a matrix
 * @var transpose_layer_t::M
 * First dimension of the matrix
 * @var transpose_layer_t::N
 * Second dimension of the matrix
 * @var transpose_layer_t::input
 * Pointer to input feature map
 * @var transpose_layer_t::output
 * Pointer to output feature map
 */
typedef struct {
    uint32_t M;
    uint32_t N;
    void* input;
    void* output;
    precision_t dtype;
    uint32_t baseline;
} transpose_layer_t;

/**
 * @brief Implementation of a baseline Transpose kernel
 *
 * @tparam T Data type of the input and output feature map
 * @param input Pointer to input feature map
 * @param output Pointer to output feature map
 * @param M First dimension of the matrix
 * @param N Second dimension of the matrix
 */
template <typename T>
static inline void transpose_baseline(T* input, T* output, uint32_t M,
                                      uint32_t N, uint32_t M_stride) {
    for (uint32_t m = 0; m < M; m++) {
        for (uint32_t n = 0; n < N; n++) {
            output[n * M_stride + m] = input[m * N + n];
        }
    }
}

/**
 * @brief Implementation of an optimized FP64 Transpose kernel
 *
 * @param input Pointer to input feature map
 * @param output Pointer to output feature map
 * @param M First dimension of the matrix
 * @param N Second dimension of the matrix
 */
static inline void transpose_fp64_opt(double* input, double* output, uint32_t M,
                                      uint32_t N, uint32_t M_stride) {
    const uint32_t ssr_b[2] = {N, M};
    const uint32_t ssr0_i[2] = {sizeof(double), N * sizeof(double)};
    const uint32_t ssr1_i[2] = {sizeof(double) * M_stride, sizeof(double)};

    snrt_ssr_loop_2d(SNRT_SSR_DM0, ssr_b[0], ssr_b[1], ssr0_i[0], ssr0_i[1]);
    snrt_ssr_loop_2d(SNRT_SSR_DM1, ssr_b[0], ssr_b[1], ssr1_i[0], ssr1_i[1]);

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_2D, input);
    snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_2D, output);
    snrt_ssr_enable();

    asm volatile(
        "frep.o  %[n_frep], 1, 0, 0 \n"
        "fsgnj.d ft1, ft0, ft0 \n" ::[n_frep] "r"(M * N - 1)
        : "ft0", "ft1", "ft2");

    snrt_ssr_disable();

    snrt_fpu_fence();
}

/**
 * @brief  Transpose kernel
 *
 * @param l transpose struct that holds addresses and parameters
 *
 */
static inline void transpose_kernel(precision_t dtype, void* input,
                                    void* output, uint32_t M, uint32_t N,
                                    uint32_t baseline) {
    uint32_t frac_M = M / snrt_cluster_compute_core_num();

    if (snrt_is_compute_core()) {
        // determine the row offset for each core
        int32_t row_offset = snrt_cluster_core_idx() * frac_M;

        // calculate the input address offset
        void* input_offset = (char*)input + row_offset * N * dtype;

        // caluclate the output address offset
        void* output_offset = (char*)output + row_offset * dtype;

        switch (dtype) {
            case FP8:
                transpose_baseline<char>((char*)input_offset,
                                         (char*)output_offset, frac_M, N, M);
                break;
            case FP16:
                transpose_baseline<__fp16>((__fp16*)input_offset,
                                           (__fp16*)output_offset, frac_M, N,
                                           M);
                break;
            case FP32:
                transpose_baseline<float>((float*)input_offset,
                                          (float*)output_offset, frac_M, N, M);
                break;
            case FP64:
                if (baseline) {
                    transpose_baseline<double>((double*)input_offset,
                                               (double*)output_offset, frac_M,
                                               N, M);
                } else {
                    transpose_fp64_opt((double*)input_offset,
                                       (double*)output_offset, frac_M, N, M);
                }
                break;
            default:
                break;
        }
    }
}

/**
 * @brief  Transpose layer
 *
 * @param l transpose struct that holds addresses and parameters
 *
 */
static inline void transpose_layer(transpose_layer_t const l) {
    uint32_t matrix_size = l.M * l.N * l.dtype;

    char* ptr = (char*)snrt_l1_next();
    void* input = ptr;
    ptr += matrix_size;
    void* output = ptr;
    ptr += matrix_size;

    // DMA transfer the matrix into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(input, l.input, matrix_size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    transpose_kernel(l.dtype, input, output, l.M, l.N, l.baseline);

    snrt_cluster_hw_barrier();

    // DMA transfer the output to DRAM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(l.output, output, matrix_size);
        snrt_dma_wait_all();
    }

    snrt_global_barrier();
}
