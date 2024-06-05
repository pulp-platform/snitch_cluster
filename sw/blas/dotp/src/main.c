// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#include "printf.h"

#define XSSR
#include "dotp.h"
#include "data.h"

int main() {
    double *local_x, *local_y, *local_z;
    double *remote_x, *remote_y, *remote_z;

    volatile double sum;

    uint32_t start_cycle, end_cycle;

    // Calculate size and pointers for each cluster
    uint32_t frac = n / snrt_cluster_num();
    uint32_t offset = frac * snrt_cluster_idx();
    remote_x = x + offset;
    remote_y = y + offset;
    remote_z = z + snrt_cluster_idx();

    // Allocate space in TCDM
    local_x = (double *)snrt_l1_next();
    local_y = local_x + frac;
    local_z = local_y + frac;

    // Copy data in TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac * sizeof(double);
        snrt_dma_start_1d(local_x, remote_x, size);
        snrt_dma_start_1d(local_y, remote_y, size);
        snrt_dma_wait_all();
    }

    // Calculate TCDM size and pointers for each core
    int core_idx = snrt_cluster_core_idx();
    int frac_core = n / snrt_cluster_compute_core_num();
    int offset_core = core_idx * frac_core;
    local_x += offset_core;
    local_y += offset_core;
    local_z += core_idx;

    snrt_cluster_hw_barrier();

    // Compute
    if (!snrt_is_dm_core()) {
        start_cycle = snrt_mcycle();
        dotp_seq_4_acc(frac_core, local_x, local_y, local_z);
        snrt_cluster_hw_barrier();

#ifndef _DOTP_EXCLUDE_FINAL_SYNC_
        if (!snrt_cluster_core_idx()) {
            sum = 0;
            for (uint32_t i = 0; i < snrt_cluster_compute_core_num(); ++i) {
                sum += local_z[i];
            }
        }
        snrt_fpu_fence();
#endif

        end_cycle = snrt_mcycle();
    } else {
      // DMA should also sync with the computational cores
      snrt_cluster_hw_barrier();
    }

    snrt_cluster_hw_barrier();

    if (!snrt_cluster_core_idx()) {
      unsigned int runtime = end_cycle - start_cycle;
      double performance   = (double) (2 * n - 1) / runtime;
      double util          = 100 * (performance / (2 * snrt_cluster_compute_core_num()));

      printf("Core %d execution time: %u cycles\nPerformance: %f DP-FLOP/Cycle\nUtilization: %f%%\n",
        snrt_cluster_core_idx(), runtime, performance, util);
    }

    snrt_cluster_hw_barrier();

    // Copy data out of TCDM
    if (snrt_is_dm_core()) {
        size_t size = frac_core * sizeof(double);
        snrt_dma_start_1d(remote_z, local_z, size);
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();

// TODO: currently only works for single cluster otherwise need to
//       synchronize all cores here
#ifdef BIST
    uint32_t nerr = 1;

    // Check computation is correct
    if (snrt_global_core_idx() == 0) {
      if (sum == g) nerr--;
      printf("%f %f\n", sum, g);
    }

    return nerr;
#endif

    return 0;
}
