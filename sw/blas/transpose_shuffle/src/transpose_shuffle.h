// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Lucia Luzi <luzil@student.ethz.ch>

#pragma once

#include "snrt.h"
#include "data.h"
#include "math.h"
// #include "../dnn/transpose/src/transpose.h"

// Guard to avoid conflict with DNN header file
// TODO: move this definition to Snitch math library to solve problem
#ifndef PRECISION_T
#define PRECISION_T
typedef enum { FP64 = 8, FP32 = 4, FP16 = 2, FP8 = 1 } precision_t;

typedef float v2f32 __attribute__((vector_size(8)));
typedef __fp16 v4f16 __attribute__((vector_size(8)));
typedef char v8f8 __attribute__((vector_size(8)));
#endif

static inline void transpose_fp8_baseline_opt(char* input, char* res, uint32_t M, uint32_t N) {

    const uint32_t ssr_b[2] = {N, M};
    const uint32_t ssr0_i[2] = {N * sizeof(char), sizeof(char)};
    const uint32_t ssr1_i[2] = {sizeof(char), M * sizeof(char)};
    const uint32_t n_frep = M * N - 1;

    snrt_ssr_loop_2d(SNRT_SSR_DM0, ssr_b[1], ssr_b[0], ssr0_i[1], ssr0_i[0]);
    snrt_ssr_loop_2d(SNRT_SSR_DM1, ssr_b[1], ssr_b[0], ssr1_i[1], ssr1_i[0]);

    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_2D, input);
    snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_2D, res);
    snrt_ssr_enable();

    asm volatile(
        "frep.o  %[n_frep], 1, 0, 0 \n"
        "fsgnj.b ft1, ft0, ft0 \n" 
        ::[n_frep] "r"(n_frep)
        : "ft0", "ft1", "ft2");

    snrt_ssr_disable();

    snrt_fpu_fence();
}


static inline void transpose_fp8_baseline(char* input, char* res, uint32_t M, uint32_t N) {

    volatile register char *a_ptr;
    volatile char *b_ptr;

    for (int m = 0; m < M; m++) {
        for (int n = 0; n < N; n++)
        {
            a_ptr = &input[m * N + n];
            b_ptr = &res[n * M + m];

            asm volatile(
                "flb ft2, 0(%[a_ptr]) \n"
                "fsb ft2, 0(%[b_ptr]) \n"
                : 
                : [a_ptr] "r"(a_ptr), [b_ptr] "r"(b_ptr)
                : "ft0", "ft1", "ft2");

            // res[n * M + m] = input[m * N + n];
        }
    }
}

static inline void transpose_fp16_baseline(__fp16* input, __fp16* res, uint32_t M, uint32_t N) {

    volatile register __fp16 *a_ptr;
    volatile __fp16 *b_ptr;

    for (int m = 0; m < M; m++) {
        for (int n = 0; n < N; n++)
        {
            uint32_t indx_a = m * N + n;
            uint32_t indx_b = n * M + m;

            a_ptr = &input[indx_a];
            b_ptr = &res[indx_b];

            asm volatile(
                "flh ft2, 0(%[a_ptr]) \n"
                "fsh ft2, 0(%[b_ptr]) \n"
                :
                : [a_ptr] "r"(a_ptr), [b_ptr] "r"(b_ptr)
                : "ft0", "ft1", "ft2");
            // res[n * M + m] = input[m * N + n];
        }
    }
}

static inline void transpose_fp32_baseline(float* input, float* res, uint32_t M, uint32_t N) {

    for (int m = 0; m < M; m++) {
        for (int n = 0; n < N; n++)
        {
            res[n * M + m] = input[m * N + n];
        }
    }
}

static inline void transpose_shuffle_fp8(char* input, char* res, uint32_t M, uint32_t N) {
    uint32_t mask_0 = 0xF7E6D5C4;
    uint32_t mask_1 = 0xB3A29180;
    uint32_t mask_2 = 0xFE76DC54;
    uint32_t mask_3 = 0xBA329810;
    uint32_t mask_4 = 0xBA983210;
    uint32_t mask_5 = 0xFEDC7654;

    volatile register v8f8 *a0_ptr, *a1_ptr, *a2_ptr, *a3_ptr, *a4_ptr, *a5_ptr, *a6_ptr, *a7_ptr;
    volatile char *b0_ptr, *b1_ptr, *b2_ptr, *b3_ptr, *b4_ptr, *b5_ptr, *b6_ptr, *b7_ptr;

    for (uint32_t m = 0; m < M; m+=8)
    {
        for (uint32_t n = 0; n < N; n+=8)
        {
            uint32_t indx_a = m * N + n;
            uint32_t indx_b = n * M + m;
        
            a0_ptr = (v8f8*)(&input[indx_a]);
            a1_ptr = (v8f8*)(&input[indx_a + N]);
            a2_ptr = (v8f8*)(&input[indx_a + 2*N]);
            a3_ptr = (v8f8*)(&input[indx_a + 3*N]);
            a4_ptr = (v8f8*)(&input[indx_a + 4*N]);
            a5_ptr = (v8f8*)(&input[indx_a + 5*N]);
            a6_ptr = (v8f8*)(&input[indx_a + 6*N]);
            a7_ptr = (v8f8*)(&input[indx_a + 7*N]);

            b0_ptr = (char*)(&res[indx_b]);
            b1_ptr = (char*)(&res[indx_b + M]);
            b2_ptr = (char*)(&res[indx_b + 2*M]);
            b3_ptr = (char*)(&res[indx_b + 3*M]);
            b4_ptr = (char*)(&res[indx_b + 4*M]);
            b5_ptr = (char*)(&res[indx_b + 5*M]);
            b6_ptr = (char*)(&res[indx_b + 6*M]);
            b7_ptr = (char*)(&res[indx_b + 7*M]);

            asm volatile(
                "fld f0, 0(%[a0_ptr]) \n" 
                "fld f2, 0(%[a1_ptr]) \n"
                "fld f3, 0(%[a2_ptr]) \n" 
                "fld f5, 0(%[a3_ptr]) \n"
                "fld f6, 0(%[a4_ptr]) \n" 
                "fld f8, 0(%[a5_ptr]) \n"
                "fld f9, 0(%[a6_ptr]) \n" 
                "fld f11, 0(%[a7_ptr]) \n"

                "fmv.d f1, f0 \n"
                "fmv.d f4, f3 \n"
                "fmv.d f7, f6 \n"
                "fmv.d f10, f9 \n"

                "vfshuffle.b f0, f2, %[mask_0] \n" 
                "vfshuffle.b f1, f2, %[mask_1] \n" 
                "vfshuffle.b f3, f5, %[mask_0] \n" 
                "vfshuffle.b f4, f5, %[mask_1] \n" 
                "vfshuffle.b f6, f8, %[mask_0] \n" 
                "vfshuffle.b f7, f8, %[mask_1] \n" 
                "vfshuffle.b f9, f11, %[mask_0] \n" 
                "vfshuffle.b f10, f11, %[mask_1] \n" 
                :
                : [a0_ptr] "r"(a0_ptr), [a1_ptr] "r"(a1_ptr),
                [a2_ptr] "r"(a2_ptr), [a3_ptr] "r"(a3_ptr),
                [a4_ptr] "r"(a4_ptr), [a5_ptr] "r"(a5_ptr),
                [a6_ptr] "r"(a6_ptr), [a7_ptr] "r"(a7_ptr),
                [mask_0] "r"(mask_0), [mask_1] "r"(mask_1));     

            asm volatile(
                "fmv.d f12, f0 \n" // make copies
                "fmv.d f13, f1 \n"
                "fmv.d f14, f6 \n" 
                "fmv.d f15, f7 \n"

                "vfshuffle.b f0, f3, %[mask_2]\n" 
                "vfshuffle.b f12, f3, %[mask_3]\n" 
                "vfshuffle.b f1, f4, %[mask_2]\n" 
                "vfshuffle.b f13, f4, %[mask_3]\n" 
                "vfshuffle.b f6, f9, %[mask_2]\n" 
                "vfshuffle.b f14, f9, %[mask_3]\n" 
                "vfshuffle.b f7, f10, %[mask_2]\n" 
                "vfshuffle.b f15, f10, %[mask_3]\n" 

                "fmv.d f16, f0 \n" // make copies
                "fmv.d f17, f12 \n"
                "fmv.d f18, f1 \n" 
                "fmv.d f19, f13 \n"

                "vfshuffle.b f13, f15, %[mask_4]\n" 
                "vfshuffle.b f19, f15, %[mask_5]\n" 
                "vfshuffle.b f1, f7, %[mask_4]\n" 
                "vfshuffle.b f18, f7, %[mask_5]\n" 
                "vfshuffle.b f12, f14, %[mask_4]\n" 
                "vfshuffle.b f17, f14, %[mask_5]\n" 
                "vfshuffle.b f0, f6, %[mask_4]\n" 
                "vfshuffle.b f16, f6, %[mask_5]\n" 

                "fsd f13, 0(%[b0_ptr]) \n" 
                "fsd f19, 0(%[b1_ptr]) \n" 
                "fsd f1, 0(%[b2_ptr]) \n" 
                "fsd f18, 0(%[b3_ptr]) \n"  
                "fsd f12, 0(%[b4_ptr]) \n" 
                "fsd f17, 0(%[b5_ptr]) \n" 
                "fsd f0, 0(%[b6_ptr]) \n" 
                "fsd f16, 0(%[b7_ptr]) \n" 
                :
                : [mask_2] "r"(mask_2), [mask_3] "r"(mask_3),
                [mask_4] "r"(mask_4), [mask_5] "r"(mask_5),
                [b0_ptr] "r"(b0_ptr), [b1_ptr] "r"(b1_ptr),
                [b2_ptr] "r"(b2_ptr), [b3_ptr] "r"(b3_ptr),
                [b4_ptr] "r"(b4_ptr), [b5_ptr] "r"(b5_ptr),
                [b6_ptr] "r"(b6_ptr), [b7_ptr] "r"(b7_ptr));
        }
    }
}

static inline void transpose_shuffle_fp16(__fp16* input, __fp16* res, uint32_t M, uint32_t N) {
    uint32_t mask_0 = 0x9180;
    uint32_t mask_1 = 0xB3A2;
    uint32_t mask_2 = 0x9810;
    uint32_t mask_3 = 0xBA32;

    volatile register v4f16 *a0_ptr, *a1_ptr, *a2_ptr, *a3_ptr;
    volatile __fp16 *b0_ptr, *b1_ptr, *b2_ptr, *b3_ptr;

    for (uint32_t m = 0; m < M; m+=4)
    {
        for (uint32_t n = 0; n < N; n+=4)
        {
            uint32_t indx_a = m * N + n;
            uint32_t indx_b = n * M + m;
        
            a0_ptr = (v4f16*)(&input[indx_a]);
            a1_ptr = (v4f16*)(&input[indx_a + N]);
            a2_ptr = (v4f16*)(&input[indx_a + 2*N]);
            a3_ptr = (v4f16*)(&input[indx_a + 3*N]);

            b0_ptr = (__fp16*)(&res[indx_b]);
            b1_ptr = (__fp16*)(&res[indx_b + M]);
            b2_ptr = (__fp16*)(&res[indx_b + 2*M]);
            b3_ptr = (__fp16*)(&res[indx_b + 3*M]);

            asm volatile(
                "fld f2, 0(%0) \n" // f0 and f2 are a0
                "fld f12, 0(%2) \n" // f10 and f12 are a2
                "fld f1, 0(%1) \n"
                "fld f11, 0(%3) \n"
                "fmv.d f0, f2 \n"
                "fmv.d f10, f12 \n"
                "vfshuffle.h f0, f1, %[mask_0] \n" 
                "vfshuffle.h f2, f1, %[mask_1] \n" 
                "vfshuffle.h f10, f11, %[mask_0] \n" 
                "vfshuffle.h f12, f11, %[mask_1] \n" 
                :: "r"(a0_ptr), "r"(a1_ptr),
                "r"(a2_ptr), "r"(a3_ptr),
                [mask_0] "r"(mask_0), [mask_1] "r"(mask_1));     

            asm volatile(
                "fmv.d f3, f0 \n" // t0 in f4 and f8
                "fmv.d f4, f2 \n"
                "vfshuffle.h f0, f10, %[mask_2]\n" 
                "vfshuffle.h f3, f10, %[mask_3]\n" 
                "vfshuffle.h f2, f12, %[mask_2]\n" 
                "vfshuffle.h f4, f12, %[mask_3]\n" 
                "fsd f0, 0(%[b0_ptr]) \n" 
                "fsd f3, 0(%[b1_ptr]) \n" 
                "fsd f2, 0(%[b2_ptr]) \n" 
                "fsd f4, 0(%[b3_ptr]) \n"  
                :
                : [mask_2] "r"(mask_2), [mask_3] "r"(mask_3),
                [b0_ptr] "r"(b0_ptr), [b1_ptr] "r"(b1_ptr),
                [b2_ptr] "r"(b2_ptr), [b3_ptr] "r"(b3_ptr));
        }
    }
}

static inline void transpose_shuffle_fp32(float *input, float *res, uint32_t M, uint32_t N) {
    uint32_t mask_0 = 0x80;
    uint32_t mask_1 = 0x91;
    volatile register v2f32 *a0_ptr, *a1_ptr;
    volatile float *b0_ptr, *b1_ptr;

    for (uint32_t m = 0; m < M; m+=2)
    {
        for (uint32_t n = 0; n < N; n+=2)
        {
            uint32_t indx_a = m * N + n;
            uint32_t indx_b = n * M + m;
        
            a0_ptr = (v2f32*)(&input[indx_a]);
            a1_ptr = (v2f32*)(&input[indx_a + N]);
            b0_ptr = (float*)(&res[indx_b]);
            b1_ptr = (float*)(&res[indx_b + M]);

            asm volatile(
                "fld f0, 0(%0) \n"
                "fld f1, 0(%1) \n"
                "fmv.d f4, f0 \n"
                "vfshuffle.s f0, f1, %2\n"
                "vfshuffle.s f4, f1, %3\n"
                "fsd f0, 0(%4) \n"
                "fsd f4, 0(%5) \n"
                :
                : "r"(a0_ptr), "r"(a1_ptr),
                "r"(mask_0), "r"(mask_1),
                "r"(b0_ptr), "r"(b1_ptr));   
        }
    }
}

static inline void transpose_shuffle_fp8_opt(char* A, char* B, const uint32_t M, const uint32_t N) {

    uint32_t mask_0 = 0xF7E6D5C4;
    uint32_t mask_1 = 0xB3A29180;
    uint32_t mask_2 = 0xFE76DC54;
    uint32_t mask_3 = 0xBA329810;
    uint32_t mask_4 = 0xBA983210;
    uint32_t mask_5 = 0xFEDC7654;

    snrt_ssr_loop_3d(SNRT_SSR_DM0, 8, N/8, M/8, N*sizeof(char), 8*sizeof(char), 8*N*sizeof(char));
    snrt_ssr_loop_3d(SNRT_SSR_DM1, 8, N/8, M/8, M*sizeof(char), 8*M*sizeof(char), 8*sizeof(char)); 
    snrt_ssr_repeat(SNRT_SSR_DM0, 2); 

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_3D, A);
    snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_3D, B);
    snrt_ssr_enable();

    const uint32_t n_frep = (M * N / 64) - 1;

    for (int m = 0; m < M; m+=8)
    {
        for (int n = 0; n < N; n+=8)
        {
            asm volatile(

                "fmv.d ft3, ft0 \n"
                "fmv.d ft4, ft0 \n"
                "vfshuffle.b ft3, ft0, %[mask_0] \n" 
                "vfshuffle.b ft4, ft0, %[mask_1] \n" 
                "fmv.d ft5, ft0 \n"
                "fmv.d ft6, ft0 \n"
                "vfshuffle.b ft5, ft0, %[mask_0] \n" 
                "vfshuffle.b ft6, ft0, %[mask_1] \n" 
                "fmv.d ft7, ft0 \n"
                "fmv.d f8, ft0 \n"
                "vfshuffle.b ft7, ft0, %[mask_0] \n" 
                "vfshuffle.b f8, ft0, %[mask_1] \n" 
                "fmv.d f9, ft0 \n"
                "fmv.d f10, ft0 \n"
                "vfshuffle.b f9, ft0, %[mask_0] \n" 
                "vfshuffle.b f10, ft0, %[mask_1] \n" 

                "fmv.d f12, ft3 \n"
                "fmv.d f13, ft4 \n"
                "fmv.d f14, ft7 \n"
                "fmv.d f15, f8 \n"

                "vfshuffle.b ft3, ft5, %[mask_2]\n" 
                "vfshuffle.b f12, ft5, %[mask_3]\n" 
                "vfshuffle.b ft4, ft6, %[mask_2]\n" 
                "vfshuffle.b f13, ft6, %[mask_3]\n" 
                "vfshuffle.b ft7, f9, %[mask_2]\n" 
                "vfshuffle.b f14, f9, %[mask_3]\n" 
                "vfshuffle.b f8, f10, %[mask_2]\n" 
                "vfshuffle.b f15, f10, %[mask_3]\n" 

                "fmv.d f16, ft3 \n" // make copies
                "fmv.d f17, f12 \n"
                "fmv.d f18, ft4 \n" 
                "fmv.d f19, f13 \n"

                "vfshuffle.b f13, f15, %[mask_4]\n" 
                "vfshuffle.b f19, f15, %[mask_5]\n" 
                "vfshuffle.b ft4, f8, %[mask_4]\n" 
                "vfshuffle.b f18, f8, %[mask_5]\n" 
                "vfshuffle.b f12, f14, %[mask_4]\n" 
                "vfshuffle.b f17, f14, %[mask_5]\n" 
                "vfshuffle.b ft3, ft7, %[mask_4]\n" 
                "vfshuffle.b f16, ft7, %[mask_5]\n" 

                "fmv.d ft1, f13 \n"
                "fmv.d ft1, f19 \n"  
                "fmv.d ft1, ft4 \n"
                "fmv.d ft1, f18 \n" 
                "fmv.d ft1, f12 \n"
                "fmv.d ft1, f17 \n" 
                "fmv.d ft1, ft3 \n"
                "fmv.d ft1, f16 \n" 
                :
                : [mask_0] "r"(mask_0), [mask_1] "r"(mask_1), 
                  [mask_2] "r"(mask_2), [mask_3] "r"(mask_3),
                  [mask_4] "r"(mask_4), [mask_5] "r"(mask_5),
                  [ n_frep ] "r"(n_frep)
                : "ft0", "ft1", "ft2");
        }
    }   

    // Leave Clean up of leftover columns out for now
    // only use Matrix that sizes match the "unroll"-shuffle factor (2)

    snrt_ssr_disable();
}

static inline void transpose_shuffle_fp16_opt(__fp16* A, __fp16* B, const uint32_t M, const uint32_t N) {

    uint32_t mask_0 = 0x9180;
    uint32_t mask_1 = 0xB3A2;
    uint32_t mask_2 = 0x9810;
    uint32_t mask_3 = 0xBA32;

    snrt_ssr_loop_3d(SNRT_SSR_DM0, 4, N/4, M/4, N*sizeof(__fp16), 4*sizeof(__fp16), 4*N*sizeof(__fp16));
    snrt_ssr_loop_3d(SNRT_SSR_DM1, 4, N/4, M/4, M*sizeof(__fp16), 4*M*sizeof(__fp16), 4*sizeof(__fp16)); 
    snrt_ssr_repeat(SNRT_SSR_DM0, 2); 

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_3D, A);
    snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_3D, B);
    snrt_ssr_enable();

    const uint32_t n_frep = (M * N / 16) - 1;

    for (int m = 0; m < M; m+=4)
    {
        for (int n = 0; n < N; n+=4)
        {
            asm volatile(
                "fmv.d ft3, ft0 \n"
                "fmv.d ft4, ft0 \n"
                "vfshuffle.h ft3, ft0, %[mask_0] \n" 
                "vfshuffle.h ft4, ft0, %[mask_1] \n" 
                "fmv.d ft5, ft0 \n"
                "fmv.d ft6, ft0 \n"

                "fmv.d ft7, ft3 \n" 
                "fmv.d ft8, ft4 \n"

                "vfshuffle.h ft5, ft0, %[mask_0] \n" 
                "vfshuffle.h ft6, ft0, %[mask_1] \n" 

                "vfshuffle.h ft3, ft5, %[mask_2]\n" 
                "vfshuffle.h ft7, ft5, %[mask_3]\n" 
                "vfshuffle.h ft4, ft6, %[mask_2]\n" 
                "vfshuffle.h ft8, ft6, %[mask_3]\n" 
                "fmv.d ft1, ft3 \n"
                "fmv.d ft1, ft7 \n"
                "fmv.d ft1, ft4 \n"
                "fmv.d ft1, ft8 \n"  
                :
                : [mask_0] "r"(mask_0), [mask_1] "r"(mask_1), 
                  [mask_2] "r"(mask_2), [mask_3] "r"(mask_3),
                  [ n_frep ] "r"(n_frep)
                : "ft0", "ft1", "ft2");
        }
    }   

    // Leave Clean up of leftover columns out for now
    // only use Matrix that sizes match the "unroll"-shuffle factor (2)

    snrt_ssr_disable();
}

void transpose_shuffle_fp32_opt(float* A, float* B, const uint32_t M, const uint32_t N) {

    uint32_t mask_0 = 0x80;
    uint32_t mask_1 = 0x91;

    snrt_ssr_loop_3d(SNRT_SSR_DM0, 2, N/2, M/2, N*sizeof(float), 2*sizeof(float), 2*N*sizeof(float));
    snrt_ssr_loop_3d(SNRT_SSR_DM1, 2, N/2, M/2, M*sizeof(float), 2*M*sizeof(float), 2*sizeof(float)); 
    snrt_ssr_repeat(SNRT_SSR_DM0, 2); 

    // SSR start address need to be configured each time
    snrt_ssr_read(SNRT_SSR_DM0, SNRT_SSR_3D, A);
    snrt_ssr_write(SNRT_SSR_DM1, SNRT_SSR_3D, B);
    snrt_ssr_enable();

    const uint32_t n_frep = (M * N / 4) - 1;

    for (int m = 0; m < M; m+=2)
    {
        for (int n = 0; n < N; n+=2)
        {
            asm volatile(
                // "frep.o %[n_frep], 6, 0, 0 \n"
                "fmv.d ft3, ft0 \n"
                "fmv.d ft4, ft0 \n"
                "vfshuffle.s ft3, ft0, %[mask_0] \n"
                "vfshuffle.s ft4, ft0, %[mask_1] \n"
                "fmv.d ft1, ft3 \n"
                "fmv.d ft1, ft4 \n"
                :
                : [mask_0] "r"(mask_0), [mask_1] "r"(mask_1),
                  [ n_frep ] "r"(n_frep)
                : "ft0", "ft1", "ft2");
        }
    }   

    // Leave Clean up of leftover columns out for now
    // only use Matrix that sizes match the "unroll"-shuffle factor (2)

    snrt_ssr_disable();
}

static inline void transpose_shuffle_kernel(precision_t dtype, void* input,
                                    void* output, uint32_t M, uint32_t N,
                                    uint32_t baseline, uint32_t opt_ssr) {

    uint32_t frac_M = M / snrt_cluster_compute_core_num();
    
    if (snrt_cluster_core_idx() == 0) {
        switch (dtype) {
            case FP8:
                if (baseline)
                {
                    transpose_fp8_baseline(input, output, M, N);
                } else if (opt_ssr)
                {
                    transpose_shuffle_fp8_opt(input, output, M, N);
                } else {
                    transpose_shuffle_fp8(input, output, M, N);
                }
                break;
            case FP16:
                if (baseline)
                {
                    transpose_fp16_baseline(input, output, M, N);
                } else if (opt_ssr)
                {
                    transpose_shuffle_fp16_opt(input, output, M, N);
                } else {
                    transpose_shuffle_fp16(input, output, M, N);
                }
                break;
            case FP32:
                if (baseline)
                {
                    transpose_fp32_baseline(input, output, M, N);
                } else if (opt_ssr)
                {
                    transpose_shuffle_fp32_opt(input, output, M, N);
                } else {
                    transpose_shuffle_fp32(input, output, M, N);
                }
                break;
            case FP64:
                break;
            default:
                break;
        }
    }
}

static inline void transpose_shuffle(void* in, void* out, uint32_t M, uint32_t N, uint32_t dtype, uint32_t baseline, uint32_t opt_ssr) {

    uint32_t matrix_size = M * N;

    void* ptr = snrt_l1_next();
    void* input = ptr;
    ptr += matrix_size * dtype;
    void* output = ptr;
    ptr += matrix_size * dtype;

    // DMA transfer the matrix into the cluster TCDM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(input, in, matrix_size * dtype);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    transpose_shuffle_kernel(dtype, input, output, M, N, baseline, opt_ssr);

    snrt_cluster_hw_barrier();

    // DMA transfer the output to DRAM
    if (snrt_is_dm_core()) {
        snrt_dma_start_1d(out, output, matrix_size * dtype);
        snrt_dma_wait_all();
    }

    snrt_global_barrier();
}