// Copyright 2025 ETH Zurich and University of Bologna.
//
// SPDX-License-Identifier: Apache-2.0
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Author: Diyou Shen,              ETH Zurich <dishen@iis.ee.ethz.ch>
// Author: Navaneeth Kunhi Purayil, ETH Zurich <nkunhi@iis.ee.ethz.ch>

#include <snrt.h>
#include <stdio.h>

#include "data.h"

#ifndef SNRT_SUPPORTS_SPATZ
int main() { return 0; }
#else

#include "sel-gemv.c"

// Number of FPU lanes per Spatz core (matches N_FPU in spatz_pkg)
#ifndef SNRT_NFPU_PER_CORE
#define SNRT_NFPU_PER_CORE 8
#endif

#if (PREC == 64)
#define T double
#elif (PREC == 32)
#define T float
#elif (PREC == 16)
#define T __fp16
#else
#define T double
#endif

// Debugging defines
// #define DEBUG_NZ
// #define DEBUG_NZ_IDX
// #define DEBUG_GEMV_PreLD
// #define DEBUG_GEMV_DB

T *vec_buf0;
T *vec_buf1;
uint16_t *dense_idx;
T *dense_vec;
T *mat_buf0;
T *mat_buf1;
T *result;

int main() {
  const unsigned int num_cores = snrt_cluster_compute_core_num();
  const unsigned int cid = snrt_cluster_core_idx();

  // Reset timer
  unsigned int timer = (unsigned int)-1;
  unsigned int timer_best = (unsigned int)-1;
  unsigned int timer_nz = (unsigned int)-1;
  const unsigned int m_core = gemv_l.M / num_cores;
  // Size (in KiB) of L1 SPM, used to calculate tiling window
  const unsigned int spm_size = 128;

  // For Sparse Attention GEMV, we need several steps
  // 1. Find all non-zeros
  // 2. Calculate the GEMV
  // What to be double buffered?
  // 1. 2 chunks of sparse vector + densed vector (output) + densed idx
  // 2. 2 chunks of matrix + densed vector (output) + densed idx

  // Sizes of each part we need
  const uint32_t mat_size = sizeof(T) * gemv_l.M * tot_nz_dram;
  const uint32_t row_size = sizeof(T) * gemv_l.M;
  const uint32_t vec_size = sizeof(T) * gemv_l.N;
  const uint32_t dense_vec_size = sizeof(T) * tot_nz_dram;
  const uint32_t dense_idx_size = sizeof(uint16_t) * tot_nz_dram;
  const uint32_t result_size = sizeof(T) * gemv_l.M;

  // leave 8 KiB for Stack
  const uint32_t l1_size = (spm_size - 8) * 1024;
  const uint32_t fixed_alloc_size =
      dense_vec_size + dense_idx_size + result_size;

  // --- BOUNDS CHECK 1: Do the fixed arrays fit in L1? ---
  if (fixed_alloc_size >= l1_size) {
    if (snrt_is_dm_core()) {
      printf("FATAL: L1 Memory Overflow! Fixed arrays require %u bytes, but "
             "only %u bytes available.\n",
             fixed_alloc_size, l1_size);
    }
    snrt_cluster_hw_barrier();
    return -1; // Exit gracefully
  }

  const uint32_t l1_for_chunk = l1_size - fixed_alloc_size;

  // How many whole rows (or columns) can fit in half the L1 chunk space?
  const uint32_t num_row_mat = (l1_for_chunk / 2) / row_size;

  // --- BOUNDS CHECK 2: Can we double buffer at least 1 row? ---
  if (num_row_mat < 1) {
    if (snrt_is_dm_core()) {
      printf("FATAL: L1 Memory Overflow! Cannot fit at least 2 rows for double "
             "buffering. "
             "Chunk space left: %u bytes, Row size: %u bytes.\n",
             l1_for_chunk, row_size);
    }
    snrt_cluster_hw_barrier();
    return -1; // Exit gracefully
  }

  // Always strictly split the available memory in half for double-buffering
  const uint32_t vec_chunk_size = l1_for_chunk / 2;
  const uint32_t num_vec_chunk =
      (l1_for_chunk > vec_size)
          ? 1
          : ((vec_size + vec_chunk_size - 1) / vec_chunk_size);

  // Recalculate exact chunk size based on whole rows
  const uint32_t mat_chunk_size = num_row_mat * row_size;

  // Number of chunks based on the total non-zeros we need to process
  const uint32_t num_mat_chunk = (tot_nz_dram + num_row_mat - 1) / num_row_mat;

  // Number of elements in each chunk
  const uint32_t vec_chunk_len = vec_chunk_size / sizeof(T);

  // Memory Allocation
  if (snrt_is_dm_core()) {
    result = (T *)snrt_l1_alloc(result_size);
    dense_vec = (T *)snrt_l1_alloc(dense_vec_size);
    vec_buf0 = (T *)snrt_l1_alloc(l1_for_chunk);
    dense_idx = (uint16_t *)snrt_l1_alloc(dense_idx_size);

    // Offset by half of the size if needed by double buffering
    vec_buf1 = vec_buf0 + vec_chunk_len;

    mat_buf0 = vec_buf0;
    mat_buf1 = vec_buf1;
  }

  // MUST zero out the memory accumulator!
  if (snrt_is_dm_core()) {
    for (unsigned int i = 0; i < gemv_l.M; i++) {
      result[i] = 0.0;
    }
  }
  snrt_cluster_hw_barrier();

  if (snrt_is_dm_core()) {
    timer = snrt_mcycle();
  }

  // Task 1: Find out the non-zeros
  uint32_t nz_count = 0;

  if (snrt_is_dm_core()) {
    for (unsigned int i = 0; i < num_vec_chunk; ++i) {
      uint32_t curr_bytes = ((i + 1) * vec_chunk_size <= vec_size)
                                ? vec_chunk_size
                                : (vec_size - i * vec_chunk_size);
      snrt_dma_start_1d(vec_buf0, gemv_vec_dram + i * vec_chunk_len, curr_bytes);
      snrt_dma_wait_all();

#ifdef DEBUG_NZ
      printf("NZ-Calc Iter%u, SRC:%p, TGT:%p, SIZE:%u\n", i,
             gemv_vec_dram + i * vec_chunk_len, vec_buf0, curr_bytes);
#endif

      for (unsigned int j = 0; j < vec_chunk_len; ++j) {
        if ((float)vec_buf0[j] != 0.0) {
          dense_vec[nz_count] = vec_buf0[j];
          dense_idx[nz_count] = i * vec_chunk_len + j;
          nz_count++;
        }

        if (nz_count == tot_nz_dram)
          break;
      }

      if (nz_count == tot_nz_dram)
        break;
    }
  }

  snrt_cluster_hw_barrier();

#ifdef DEBUG_NZ
  if (snrt_is_dm_core())
    printf("Non-Zero Calc Complete\n");
#endif

#ifdef DEBUG_NZ_IDX
  if (snrt_is_dm_core()) {
    for (uint32_t i = 0; i < tot_nz_dram; i++) {
      printf("IDX[%u]=%u\n", i, dense_idx[i]);
    }
  }
#endif

  timer_nz = snrt_mcycle() - timer_nz;
  timer = snrt_mcycle();

  // Task 2: GEMV calculation
  // Calculate internal pointers
  T *mat_ptr = mat_buf0;
  T *mat_db_ptr = mat_buf1;
  T *result_core = result + m_core * snrt_cluster_core_idx();
  uint16_t *idx_ptr = dense_idx; // Corrected pointer type

  if (snrt_is_dm_core()) {
    // Determine how many rows are actually active for this very first chunk
    uint32_t active_rows =
        (tot_nz_dram < num_row_mat) ? tot_nz_dram : num_row_mat;

#ifdef DEBUG_GEMV_PreLD
    printf("GEMV PreLD\n");
    printf("Active Rows:%u\n", active_rows);
#endif

    for (unsigned int i = 0; i < active_rows; i++) {
#ifdef DEBUG
      printf("Row:%u, SRC:%p, TGT:%p, SIZE:%u\n", i,
             gemv_mat_dram + (size_t)(*idx_ptr) * gemv_l.M,
             mat_ptr + i * gemv_l.M, row_size);
#endif
      snrt_dma_start_1d(mat_ptr + i * gemv_l.M, // Pack linearly into L1
                        gemv_mat_dram +
                            (size_t)(*idx_ptr) * gemv_l.M, // Source from DRAM
                        row_size);
      idx_ptr++;
    }
  }

  snrt_cluster_hw_barrier();

#ifdef DEBUG_GEMV_PreLD
  if (snrt_is_dm_core())
    printf("GEMV PreLD Complete\n");
#endif

#ifdef DEBUG_GEMV_DB
  if (snrt_is_dm_core())
    printf("Tot Chunks %u\n", num_mat_chunk);
#endif

  for (unsigned int chunk_idx = 0; chunk_idx < num_mat_chunk; chunk_idx++) {
    // Wait for the CURRENT chunk to finish loading
    if (snrt_is_dm_core()) {
      snrt_dma_wait_all();
    }
    snrt_cluster_hw_barrier();

    // Determine bounds for the NEXT chunk (for background DMA)
    uint32_t next_chunk_start = (chunk_idx + 1) * num_row_mat;
    uint32_t next_active_rows = 0;

    if (next_chunk_start < tot_nz_dram) {
      next_active_rows = (tot_nz_dram - next_chunk_start < num_row_mat)
                             ? (tot_nz_dram - next_chunk_start)
                             : num_row_mat;
    }

#ifdef DEBUG_GEMV_DB
    if (snrt_is_dm_core())
      printf("Chunk%u, DB Rows%u\n", chunk_idx, next_active_rows);
#endif

    // Load NEXT chunk in the background
    if (snrt_is_dm_core() && next_active_rows > 0) {
      for (unsigned int i = 0; i < next_active_rows; i++) {
#ifdef DEBUG_GEMV_DB
        printf("Ptr:%p, Row:%u, SRC:%p, TGT:%p, SIZE:%u\n", idx_ptr, i,
               gemv_mat_dram + (size_t)(*idx_ptr) * gemv_l.M,
               mat_db_ptr + i * gemv_l.M, row_size);
#endif
        snrt_dma_start_1d(mat_db_ptr + i * gemv_l.M,
                          gemv_mat_dram + (size_t)(*idx_ptr) * gemv_l.M,
                          row_size);
        idx_ptr++;
      }
    }

    // Calculate active rows for the CURRENT compute phase
    uint32_t curr_active_rows =
        (tot_nz_dram - chunk_idx * num_row_mat < num_row_mat)
            ? (tot_nz_dram - chunk_idx * num_row_mat)
            : num_row_mat;

    // Calculate GEMV on the current chunk
    if (snrt_is_compute_core()) {
      T *current_dense_vec = dense_vec + chunk_idx * num_row_mat;

      // Offset the matrix pointer by m_core * cid so each core reads its
      // correct rows
      T *mat_core_ptr = mat_ptr + m_core * snrt_cluster_core_idx();

#if (PREC == 32)
      gemv_v32b_m4(mat_core_ptr, current_dense_vec, result_core, gemv_l.M,
                   m_core, curr_active_rows);
#elif (PREC == 16)
      gemv_v16b_m4(mat_core_ptr, current_dense_vec, result_core, gemv_l.M,
                   m_core, curr_active_rows);
#else
      gemv_v64b_m4(mat_core_ptr, current_dense_vec, result_core, gemv_l.M,
                   m_core, curr_active_rows);
#endif
    }

    // Swap pointers for the next iteration
    T *temp = mat_ptr;
    mat_ptr = mat_db_ptr;
    mat_db_ptr = temp;
  }

  snrt_cluster_hw_barrier();

  if (snrt_is_dm_core()) {
    timer = snrt_mcycle() - timer;
  }

  // Write results back to DRAM; verify.py reads gemv_out_dram post-simulation
  if (snrt_is_dm_core()) {
    snrt_dma_start_1d(gemv_out_dram, result, sizeof(T) * gemv_l.M);
    snrt_dma_wait_all();
  }

  snrt_cluster_hw_barrier();

  // Check and display results
  // Assume 8 fpu configuration
  if (snrt_is_dm_core()) {
    // Flops per cycle
    long unsigned int performance = 1000 * 2 * gemv_l.M * tot_nz_dram / timer;
    // Ideal perf = MACC * NCore * Nfpu * Prec adjustment
    long unsigned int utilization =
        performance / (2 * num_cores * 8 * 8 / sizeof(T));

    printf("\n----- (%d x %d) x (%d x 1) sel-gemv -----\n", gemv_l.M, gemv_l.N,
           tot_nz_dram);
    printf("The NZ finding takes %u cycles.\n", timer_nz);
    printf("The GEMV execution took %u cycles.\n", timer);
    printf("The performance is %ld OP/1000cycle (%ld%%o utilization).\n",
           performance, utilization);
  }

  // Wait for core 0 to finish displaying results
  snrt_cluster_hw_barrier();
  return 0;
}
#endif
