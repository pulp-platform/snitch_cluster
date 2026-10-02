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

#include <snrt.h>
#include <stdio.h>

#include "data.h"

#ifndef SNRT_SUPPORTS_VECTOR
int main() { return 0; }
#else

#include "faxpy.c"

// Number of FPU lanes per Spatz core (matches N_FPU in spatz_pkg)
#ifndef SNRT_NFPU_PER_CORE
#define SNRT_NFPU_PER_CORE 8
#endif

void *a;
void *x;
void *y;

int main() {
    const unsigned int dim = axpy_l.M;
    const size_t elem_size = axpy_l.dtype == FP32 ? sizeof(float) :
                             axpy_l.dtype == FP16 ? sizeof(_Float16) :
                                                     sizeof(double);

    // DM core: allocate L1 buffers and DMA data from DRAM
    if (snrt_is_dm_core()) {
        x = snrt_l1_alloc(dim * elem_size);
        y = snrt_l1_alloc(dim * elem_size);
        a = snrt_l1_alloc(elem_size);

        if (axpy_l.dtype == FP32) {
            *(float *)a = (float)axpy_alpha_dram;
        } else if (axpy_l.dtype == FP16) {
            *(_Float16 *)a = (_Float16)axpy_alpha_dram;
        } else {
            *(double *)a = (double)axpy_alpha_dram;
        }
        snrt_dma_start_1d(x, axpy_X_dram, dim * elem_size);
        snrt_dma_start_1d(y, axpy_Y_dram, dim * elem_size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    // DM core starts the performance counter
    unsigned int timer = (unsigned int)-1;
    if (snrt_is_dm_core()) {
        timer = snrt_mcycle();
    }

    // Compute cores run the kernel, each on its own slice
    if (snrt_is_compute_core()) {
        const unsigned int compute_num = snrt_cluster_compute_core_num();
        const unsigned int compute_id = snrt_cluster_core_idx();
        const unsigned int dim_core = dim / compute_num;

        if (axpy_l.dtype == FP32) {
            float *x_int = (float *)x + dim_core * compute_id;
            float *y_int = (float *)y + dim_core * compute_id;
            faxpy_v32b(*(float *)a, x_int, y_int, dim_core);
        } else if (axpy_l.dtype == FP16) {
            _Float16 *x_int = (_Float16 *)x + dim_core * compute_id;
            _Float16 *y_int = (_Float16 *)y + dim_core * compute_id;
            faxpy_v16b(*(_Float16 *)a, x_int, y_int, dim_core);
        } else {
            double *x_int = (double *)x + dim_core * compute_id;
            double *y_int = (double *)y + dim_core * compute_id;
#ifdef UNROLL
            faxpy_v64b_unrl(*(double *)a, x_int, y_int, dim_core);
#else
            faxpy_v64b(*(double *)a, x_int, y_int, dim_core);
#endif
        }
    }

    snrt_cluster_hw_barrier();

    // DM core stops timer, prints performance, checks results
    if (snrt_is_dm_core()) {
        timer = snrt_mcycle() - timer;

        const unsigned int compute_num = snrt_cluster_compute_core_num();
        long unsigned int performance = 1000 * 2 * dim / timer;
        long unsigned int utilization =
            performance / (2 * compute_num * SNRT_NFPU_PER_CORE);

        printf("\n----- (%d) spatz-axpy -----\n", dim);
        printf("Compute core: %d \n", compute_num);
        printf("The execution took %u cycles.\n", timer);
        printf("The performance is %ld OP/1000cycle (%ld%%o utilization).\n",
               performance, utilization);

        // Write results back to DRAM; verify.py reads axpy_Y_dram post-simulation
        snrt_dma_start_1d(axpy_Y_dram, y, dim * elem_size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    return 0;
}
#endif
