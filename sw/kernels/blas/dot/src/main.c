// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "snrt.h"

#include "data.h"
#include "dot.h"

int main() {
    dot(n, x, y, &result);

// TODO: currently only works for single cluster otherwise need to
//       synchronize all cores here
#ifdef BIST
    uint32_t nerr = 1;

    // Check computation is correct
    if (snrt_global_core_idx() == 0) {
        if (result == g) nerr--;
        return nerr;
    }

#endif

    return 0;
}
