// Copyright 2021 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Author: Samuel Riedel, ETH Zurich

/* This library implements the matrix multiplication in multiple different ways.
 * The functions all follow the following format:
 *
 * A is an M x N matrix, B is a N x P matrix, and C is a M x P matrix
 * C = AB
 */
/*
 * Matrix multiplication ----------------------------------
 * kernel     = matmul_unrolled_2x2_parallel_i32_rv32im
 * data type  = 32-bit integer
 * multi-core = yes
 * unrolling  = 4 elements of C per iteration (2x2 chunks)
 * simd       = no
 */
void matmul_unrolled_2x2_parallel_i32_rv32im(int32_t const *__restrict__ A,
                                             int32_t const *__restrict__ B,
                                             int32_t *__restrict__ C,
                                             uint32_t M, uint32_t N, uint32_t P,
                                             uint32_t id, uint32_t numThreads) {
    // Parallelize by assigning each core one row
    uint32_t const c = 8;  // How many columns to split the matrix into
    uint32_t const c_start = (P / c) * (id % c);
    uint32_t const c_end = (P / c) * ((id % c) + 1);
    for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
        for (uint32_t j = c_start; j < c_end; j += 2) {
            int32_t c00 = 0;
            int32_t c01 = 0;
            int32_t c10 = 0;
            int32_t c11 = 0;
            for (uint32_t k = 0; k < N; k += 2) {
                // Explicitly load the values first to help with scheduling
                int32_t val_a00 = A[(i + 0) * N + k + 0];
                int32_t val_a01 = A[(i + 0) * N + k + 1];
                int32_t val_a10 = A[(i + 1) * N + k + 0];
                int32_t val_a11 = A[(i + 1) * N + k + 1];
                int32_t val_b00 = B[(k + 0) * P + j + 0];
                int32_t val_b01 = B[(k + 0) * P + j + 1];
                int32_t val_b10 = B[(k + 1) * P + j + 0];
                int32_t val_b11 = B[(k + 1) * P + j + 1];
                c00 += val_a00 * val_b00;
                c00 += val_a01 * val_b10;
                c01 += val_a00 * val_b01;
                c01 += val_a01 * val_b11;
                c10 += val_a10 * val_b00;
                c10 += val_a11 * val_b10;
                c11 += val_a10 * val_b01;
                c11 += val_a11 * val_b11;
            }
            C[(i + 0) * P + j + 0] = c00;
            C[(i + 0) * P + j + 1] = c01;
            C[(i + 1) * P + j + 0] = c10;
            C[(i + 1) * P + j + 1] = c11;
        }
    }
}

/*
 * Matrix multiplication ----------------------------------
 * kernel     = matmul_unrolled_2x2_parallel_i32_xpulpv2
 * data type  = 32-bit integer
 * multi-core = yes
 * unrolling  = 4 elements of C per iteration (2x2 chunks)
 * simd       = no
 * other      = loads/stores explicitly written in asm
 *              for optimal register utilization
 */
#ifdef __XPULPV2__
void matmul_unrolled_2x2_parallel_i32_xpulpv2(int32_t const *__restrict__ A,
                                              int32_t const *__restrict__ B,
                                              int32_t *__restrict__ C,
                                              uint32_t M, uint32_t N,
                                              uint32_t P, uint32_t id,
                                              uint32_t numThreads) {
    // Parallelize by assigning each core one row
    uint32_t const c = 8;  // How many columns to split the matrix into
    uint32_t const c_start = (P / c) * (id % c);
    uint32_t const c_end = (P / c) * ((id % c) + 1);

    uint32_t const A_incr = (N * sizeof(int32_t)) - sizeof(int32_t);
    uint32_t const B_incr = (P * sizeof(int32_t)) - sizeof(int32_t);

    for (uint32_t i = 2 * (id / c); i < M; i += 2 * (numThreads / c)) {
        for (uint32_t j = c_start; j < c_end; j += 2) {
            int32_t c00 = 0;
            int32_t c01 = 0;
            int32_t c10 = 0;
            int32_t c11 = 0;

            for (uint32_t k = 0; k < N; k += 2) {
                const int32_t *idx_a = &A[i * N + k];
                const int32_t *idx_b = &B[k * P + j];
                int32_t val_a00, val_a01, val_a10, val_a11, val_b00, val_b01,
                    val_b10, val_b11;
                __asm__ volatile(
                    "p.lw %[a00], 4(%[addr_a]!) \n"
                    "p.lw %[a01], %[a_incr](%[addr_a]!) \n"
                    "p.lw %[a10], 4(%[addr_a]!) \n"
                    "p.lw %[a11], 0(%[addr_a]!) \n"
                    "p.lw %[b00], 4(%[addr_b]!) \n"
                    "p.lw %[b01], %[b_incr](%[addr_b]!) \n"
                    "p.lw %[b10], 4(%[addr_b]!) \n"
                    "p.lw %[b11], 0(%[addr_b]!) \n"
                    : [ a00 ] "=&r"(val_a00), [ a01 ] "=&r"(val_a01),
                      [ a10 ] "=&r"(val_a10), [ a11 ] "=&r"(val_a11),
                      [ b00 ] "=&r"(val_b00), [ b01 ] "=&r"(val_b01),
                      [ b10 ] "=&r"(val_b10), [ b11 ] "=&r"(val_b11),
                      [ addr_a ] "+&r"(idx_a), [ addr_b ] "+&r"(idx_b)
                    : [ a_incr ] "r"(A_incr), [ b_incr ] "r"(B_incr)
                    : "memory");
                /* The asm code above implements the following commented C code */
                // int32_t val_a00 = A[(i + 0) * N + k + 0];
                // int32_t val_a01 = A[(i + 0) * N + k + 1];
                // int32_t val_a10 = A[(i + 1) * N + k + 0];
                // int32_t val_a11 = A[(i + 1) * N + k + 1];
                // int32_t val_b00 = B[(k + 0) * P + j + 0];
                // int32_t val_b01 = B[(k + 0) * P + j + 1];
                // int32_t val_b10 = B[(k + 1) * P + j + 0];
                // int32_t val_b11 = B[(k + 1) * P + j + 1];
                c00 += val_a00 * val_b00;

                c01 += val_a00 * val_b01;
                c10 += val_a10 * val_b00;
                c11 += val_a10 * val_b01;
                c00 += val_a01 * val_b10;
                c01 += val_a01 * val_b11;
                c10 += val_a11 * val_b10;
                c11 += val_a11 * val_b11;
            }
            int32_t *idx_c = &C[i * P + j];
            __asm__ volatile(
                "p.sw %[s00], 4(%[addr_c]!) \n"
                "p.sw %[s01], %[c_incr](%[addr_c]!) \n"
                "p.sw %[s10], 4(%[addr_c]!) \n"
                "p.sw %[s11], 0(%[addr_c]!) \n"
                : [ addr_c ] "+&r"(idx_c)
                : [ s00 ] "r"(c00), [ s01 ] "r"(c01), [ s10 ] "r"(c10),
                  [ s11 ] "r"(c11), [ c_incr ] "r"(B_incr)
                : "memory");
            /* The asm code above implements the following commented C code */
            // C[(i + 0) * P + j + 0] = c00;
            // C[(i + 0) * P + j + 1] = c01;
            // C[(i + 1) * P + j + 0] = c10;
            // C[(i + 1) * P + j + 1] = c11;
        }
    }
}
#endif