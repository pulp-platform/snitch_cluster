// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

// Test TCDM alignment functions

#include "snrt.h"

#define ALIGN_NEXT_FROM_BASE(addr, base, size) \
    (((((addr) - (base)) + (size)-1) / (size)) * (size) + (base))

#define BANK_ALIGNMENT 8
#define TCDM_ALIGNMENT (48 * BANK_ALIGNMENT)
#define ALIGN_UP_TCDM(addr) \
    ALIGN_NEXT_FROM_BASE(addr, SNRT_TCDM_START_ADDR, TCDM_ALIGNMENT)

int main() {
    if (snrt_cluster_core_idx() != 0) {
        return 0;
    }

    int n_errors = 1;

    uintptr_t tcdm_base = (uintptr_t)snrt_l1_next();
    uintptr_t tcdm_next_aligned = ALIGN_UP_TCDM(tcdm_base + 1);

    uintptr_t exp = tcdm_base + TCDM_ALIGNMENT;
    n_errors -= (tcdm_next_aligned == exp);

    return n_errors;
}
