// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

#define TCDM_ALIGNMENT (SNRT_TCDM_BANK_NUM * SNRT_TCDM_BANK_WIDTH)

int main() {
    if (snrt_cluster_core_idx() != 0) {
        return 0;
    }

    int n_errors = 1;

    uintptr_t tcdm_base = SNRT_TCDM_START_ADDR;
    uintptr_t actual = snrt_align_up(tcdm_base + 1, TCDM_ALIGNMENT);
    n_errors -= actual == (tcdm_base + TCDM_ALIGNMENT);

    return n_errors;
}
