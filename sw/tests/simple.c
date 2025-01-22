// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

uint32_t buffer[32];

int main() {
    if (snrt_global_core_idx() != 8) return 0;  // only DMA core
    uint32_t buffer_src[32], buffer_dst[32];
    for (int i = 0; i < 100; i++)
          {
              snrt_mcycle();
              snrt_dma_start_1d_wideptr(buffer_src, buffer_dst, 1);
              snrt_dma_wait_all();
              snrt_mcycle();
          }
    return 0;
}
