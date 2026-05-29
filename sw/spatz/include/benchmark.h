// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
#pragma once
#include <snrt.h>
#include <stddef.h>
#include <stdio.h>

// Number of FPU lanes per Spatz core (matches N_FPU in spatz_pkg)
#ifndef SNRT_NFPU_PER_CORE
#define SNRT_NFPU_PER_CORE 8
#endif

size_t benchmark_get_cycle();

void start_kernel();
void stop_kernel();
