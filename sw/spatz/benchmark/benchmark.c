// Copyright 2025 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Ported from the Spatz cluster benchmark runtime to the Snitch cluster
// runtime. start_kernel/stop_kernel are stubs until the snitch cluster
// peripheral register for waveform annotation is identified.

#include "benchmark.h"

size_t benchmark_get_cycle() { return snrt_mcycle(); }

// TODO: write to snitch_cluster_peripheral status register once the
//       correct offset is known (was SPATZ_CLUSTER_PERIPHERAL_SPATZ_STATUS_REG
//       in the original Spatz cluster).
void start_kernel() {}
void stop_kernel() {}
