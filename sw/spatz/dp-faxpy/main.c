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

// Author: Matheus Cavalcante, ETH Zürich

#include <benchmark.h>
#include <snrt.h>
#include <stdio.h>

#include DATAHEADER
#include "kernel/faxpy.c"

double *a;
double *x;
double *y;

static inline int fp_check(const double a, const double b) {
  const double threshold = 0.00001;

  // Absolute value
  double comp = a - b;
  if (comp < 0)
    comp = -comp;

  return comp > threshold;
}

int main() {
  const unsigned int dim = axpy_l.M;

  // DM core: allocate L1 buffers and DMA data from DRAM
  if (snrt_is_dm_core()) {
    x = (double *)snrt_l1_alloc(dim * sizeof(double));
    y = (double *)snrt_l1_alloc(dim * sizeof(double));
    a = (double *)snrt_l1_alloc(sizeof(double));

    *a = axpy_alpha_dram;
    snrt_dma_start_1d(x, axpy_X_dram, dim * sizeof(double));
    snrt_dma_start_1d(y, axpy_Y_dram, dim * sizeof(double));
    snrt_dma_wait_all();
  }

  snrt_cluster_hw_barrier();

  // DM core starts the performance counter
  unsigned int timer = (unsigned int)-1;
  if (snrt_is_dm_core()) {
    start_kernel();
    timer = benchmark_get_cycle();
  }

  // Compute cores run the kernel, each on its own slice
  if (snrt_is_compute_core()) {
    const unsigned int compute_num = snrt_cluster_compute_core_num();
    const unsigned int compute_id  = snrt_cluster_core_idx();
    const unsigned int dim_core    = dim / compute_num;

    double *x_int = x + dim_core * compute_id;
    double *y_int = y + dim_core * compute_id;

#ifdef UNROLL
    faxpy_v64b_unrl(*a, x_int, y_int, dim_core);
#else
    faxpy_v64b(*a, x_int, y_int, dim_core);
#endif
  }

  snrt_cluster_hw_barrier();

  // DM core stops timer, prints performance, checks results
  if (snrt_is_dm_core()) {
    timer = benchmark_get_cycle() - timer;
    stop_kernel();

    const unsigned int compute_num = snrt_cluster_compute_core_num();
    long unsigned int performance  = 1000 * 2 * dim / timer;
    long unsigned int utilization  = performance / (2 * compute_num * SNRT_NFPU_PER_CORE);

    printf("\n----- (%d) dp-faxpy -----\n", dim);
    printf("Compute core: %d \n", compute_num);
    printf("The execution took %u cycles.\n", timer);
    printf("The performance is %ld OP/1000cycle (%ld%%o utilization).\n",
           performance, utilization);

    for (unsigned int i = 0; i < dim; i++) {
      if (fp_check(y[i], axpy_GR_dram[i])) {
        printf("Error: Index %d -> Result = %f, Expected = %f\n", i,
               (float)y[i], (float)axpy_GR_dram[i]);
      }
    }
  }

  snrt_cluster_hw_barrier();

  return 0;
}
