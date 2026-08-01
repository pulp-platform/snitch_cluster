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

#include <snrt.h>
#include <stdio.h>

#include "data.h"

#ifndef SNRT_SUPPORTS_VECTOR
int main() { return 0; }
#else

#if (PREC == 64)
typedef double T;
#include "fmatmul_fp64.c"
#elif (PREC == 32)
typedef float T;
#include "fmatmul_fp32.c"
#elif (PREC == 16)
typedef __fp16 T;
#include "fmatmul_fp16.c"
#endif

// Number of FPU lanes per Spatz core (matches N_FPU in spatz_pkg)
#ifndef SNRT_NFPU_PER_CORE
#define SNRT_NFPU_PER_CORE 8
#endif

T *a;
T *b;
T *c;

int main() {
    // DM core: allocate L1 buffers and DMA data from DRAM
    if (snrt_is_dm_core()) {
        a = (T *)snrt_l1_alloc(gemm_l.M * gemm_l.K * sizeof(T));
        b = (T *)snrt_l1_alloc(gemm_l.K * gemm_l.N * sizeof(T));
        c = (T *)snrt_l1_alloc(gemm_l.M * gemm_l.N * sizeof(T));

        snrt_dma_start_1d(a, gemm_A_dram, gemm_l.M * gemm_l.K * sizeof(T));
        snrt_dma_start_1d(b, gemm_B_dram, gemm_l.K * gemm_l.N * sizeof(T));
        snrt_dma_start_1d(c, gemm_C_dram, gemm_l.M * gemm_l.N * sizeof(T));
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    // DM core starts performance counter
    unsigned int timer = (unsigned int)-1;
    if (snrt_is_dm_core()) {
        timer = snrt_mcycle();
    }

    // Compute cores run the kernel, each on its own row slice
    if (snrt_is_compute_core()) {
        const unsigned int compute_num = snrt_cluster_compute_core_num();
        const unsigned int compute_id = snrt_cluster_core_idx();

        const unsigned int m_start = (gemm_l.M / compute_num) * compute_id;
        const unsigned int m_end = (gemm_l.M / compute_num) * (compute_id + 1);
        const unsigned int p_start = 0;
        const unsigned int p_end = gemm_l.N;

        matmul_4xVL(c, a, b, m_start, m_end, gemm_l.K, gemm_l.N, p_start,
                    p_end);
    }

    snrt_cluster_hw_barrier();

    // DM core stops timer, prints performance, checks results
    if (snrt_is_dm_core()) {
        timer = snrt_mcycle() - timer;

        const unsigned int compute_num = snrt_cluster_compute_core_num();
        long unsigned int performance =
            1000 * 2 * gemm_l.M * gemm_l.N * gemm_l.K / timer;
// fp32 packs twice as many elements per FPU lane as fp64, doubling peak ops/cycle
#if (PREC == 32)
        long unsigned int utilization =
            performance / (2 * compute_num * SNRT_NFPU_PER_CORE * 2);
#else
        long unsigned int utilization =
            performance / (2 * compute_num * SNRT_NFPU_PER_CORE);
#endif

        printf("\n----- (%dx%d) fmatmul (fp%d) -----\n", gemm_l.M, gemm_l.N,
               PREC);
        printf("Compute cores: %d\n", compute_num);
        printf("The execution took %u cycles.\n", timer);
        printf("The performance is %ld OP/1000cycle (%ld%%o utilization).\n",
               performance, utilization);

        // Write results back to DRAM; verify.py reads gemm_C_dram post-simulation
        snrt_dma_start_1d(gemm_C_dram, c, gemm_l.M * gemm_l.N * sizeof(T));
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

    return 0;
}
#endif
