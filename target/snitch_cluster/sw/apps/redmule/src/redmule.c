// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdint.h>

#include "snrt.h"
#include "data.h"

#define VERBOSE

uint16_t *local_x;
uint16_t *local_w;
uint16_t *local_y;

int main() {

  uint32_t errors = 0;
  int offload_id_tmp;

  uint32_t core_idx = snrt_global_core_idx();

  uint16_t x_size = M_SIZE * N_SIZE * sizeof(uint16_t);
  uint16_t w_size = N_SIZE * K_SIZE * sizeof(uint16_t);
  uint16_t y_size = M_SIZE * K_SIZE * sizeof(uint16_t);

  // Allocate space in TCDM and copy inputs to TCDM
  if (snrt_is_dm_core()) {
    local_x = snrt_l1_alloc(x_size);
    local_w = snrt_l1_alloc(w_size);
    local_y = snrt_l1_alloc(y_size);
    snrt_dma_start_1d(local_x, x_inp, x_size);
    snrt_dma_start_1d(local_w, w_inp, w_size);
    snrt_dma_start_1d(local_y, y_inp, y_size);
    snrt_dma_wait_all();
  }

  snrt_cluster_hw_barrier();

  if (core_idx == 0) {
    printf("Starting RedMulE from core %d\n", core_idx);
    printf("x dim: %d\n", x_size);
    printf("w dim: %d\n", w_size);
    printf("y dim: %d\n", y_size);

    printf("local_x: %p\n", local_x);
    printf("local_w: %p\n", local_w);
    printf("local_y: %p\n", local_y);

    // Enable RedMulE
    hwpe_cg_enable();

    hwpe_soft_clear();

    while( ( offload_id_tmp = hwpe_acquire_job() ) < 0);

    redmule_cfg ((unsigned int) local_x,
                (unsigned int) local_w,
                (unsigned int) local_y,
                M_SIZE, N_SIZE, K_SIZE,
                (uint8_t) GEMM,
                (uint8_t) Float16);
    // Start RedMulE operation
    hwpe_trigger_job();
  }

  snrt_cluster_hw_barrier();

  if (core_idx == 0) {
    int status;
    snrt_interrupt_enable(IRQ_M_HWPE);
    while ((status = hwpe_get_status()) != 0) snrt_wfi();
    hwpe_evt_clear(1 << core_idx);
    snrt_interrupt_disable(IRQ_M_HWPE);

    // Disable RedMulE
    hwpe_cg_disable();

    // Check computation is correct
    errors = redmule16_compare_int((uint32_t*)local_y, golden, M_SIZE*K_SIZE/2);

    if (errors == 0)
      printf("No errors!\n");
    else
      printf("Errors: %d\n", errors);
  }

  return 0;
}
