// Copyright 2023 ETH Zurich and University of Bologna.
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

// Author: Matheus Cavalcante, ETH Zurich

#include <benchmark.h>
#include <snrt.h>
#include <stdio.h>

#include DATAHEADER
#include "kernel/dp-fmatmul.c"

double *a;
double *b;
double *c;

// Verify the matrices
int verify_matrix(double *matrix, const double *checksum,
                  const unsigned int num_rows, const unsigned int num_columns) {
  for (unsigned int i = 0; i < num_rows; ++i) {
    double sum = 0;
    for (unsigned int j = 0; j < num_columns; ++j) {
      sum += (double)matrix[i * num_columns + j];
    }

    double diff = sum - (double)checksum[i];
    if (diff < 0)
      diff = -diff;
    if (diff > 0.001) {
      return i == 0 ? -1 : (int)i;
    }
  }
  return 0;
}

int main() {
  // DM core: allocate L1 buffers and DMA data from DRAM
  if (snrt_is_dm_core()) {
    a = (double *)snrt_l1_alloc(gemm_l.M * gemm_l.K * sizeof(double));
    b = (double *)snrt_l1_alloc(gemm_l.K * gemm_l.N * sizeof(double));
    c = (double *)snrt_l1_alloc(gemm_l.M * gemm_l.N * sizeof(double));

    snrt_dma_start_1d(a, gemm_A_dram, gemm_l.M * gemm_l.K * sizeof(double));
    snrt_dma_start_1d(b, gemm_B_dram, gemm_l.K * gemm_l.N * sizeof(double));
    snrt_dma_start_1d(c, gemm_C_dram, gemm_l.M * gemm_l.N * sizeof(double));
    snrt_dma_wait_all();
  }

  snrt_cluster_hw_barrier();

  // DM core starts performance counter
  unsigned int timer = (unsigned int)-1;
  if (snrt_is_dm_core()) {
    start_kernel();
    timer = benchmark_get_cycle();
  }

  // Compute cores run the kernel, each on its own row slice
  if (snrt_is_compute_core()) {
    const unsigned int compute_num = snrt_cluster_compute_core_num();
    const unsigned int compute_id  = snrt_cluster_core_idx();

    const unsigned int m_start = (gemm_l.M / compute_num) * compute_id;
    const unsigned int m_end   = (gemm_l.M / compute_num) * (compute_id + 1);
    const unsigned int p_start = 0;
    const unsigned int p_end   = gemm_l.N;

    matmul_4xVL(c, a, b, m_start, m_end, gemm_l.K, gemm_l.N, p_start, p_end);
  }

  snrt_cluster_hw_barrier();

  // DM core stops timer, prints performance, checks results
  if (snrt_is_dm_core()) {
    timer = benchmark_get_cycle() - timer;
    stop_kernel();

    const unsigned int compute_num = snrt_cluster_compute_core_num();
    long unsigned int performance =
        1000 * 2 * gemm_l.M * gemm_l.N * gemm_l.K / timer;
    long unsigned int utilization =
        performance / (2 * compute_num * SNRT_NFPU_PER_CORE);

    printf("\n----- (%dx%d) dp fmatmul -----\n", gemm_l.M, gemm_l.N);
    printf("Compute cores: %d\n", compute_num);
    printf("The execution took %u cycles.\n", timer);
    printf("The performance is %ld OP/1000cycle (%ld%%o utilization).\n",
           performance, utilization);

    int error =
        verify_matrix(c, (const double *)gemm_checksum, gemm_l.M, gemm_l.N);
    if (error != 0) {
      printf("Error: row %d checksum mismatch\n", error);
      return error;
    }
  }

  snrt_cluster_hw_barrier();

  return 0;
}
