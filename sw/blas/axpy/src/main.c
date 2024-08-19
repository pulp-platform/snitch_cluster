// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#include "axpy.h"
#include "data.h"

int main() {
    axpy_job(&args);

// TODO: currently only works for single cluster otherwise need to
//       synchronize all cores here
#ifdef BIST
    uint32_t n = args.n;
    double* z = args.z;
    uint32_t nerr = n;

    // Check computation is correct
    if (snrt_global_core_idx() == 0) {
        for (int i = 0; i < n; i++) {
            if (z[i] == g[i]) nerr--;
            printf("%d %d\n", z[i], g[i]);
        }
    }

    return nerr;
#endif

    return 0;
}
