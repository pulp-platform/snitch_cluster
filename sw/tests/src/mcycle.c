// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Author: Luca Colagrande <colluca@iis.ee.ethz.ch>
//
// Should create 5 regions in the trace.

#include "snrt.h"

int main() {
    snrt_mcycle();
    snrt_mcycle();
    snrt_mcycle();
    snrt_mcycle();
}
