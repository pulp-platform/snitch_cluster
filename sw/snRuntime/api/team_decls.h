// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

uint32_t __attribute__((const)) snrt_hartid();
uint32_t __attribute__((const)) snrt_cluster_num();
uint32_t __attribute__((const)) snrt_cluster_core_num();
uint32_t __attribute__((const)) snrt_global_core_base_hartid();
uint32_t __attribute__((const)) snrt_global_core_num();
uint32_t __attribute__((const)) snrt_global_core_idx();
uint32_t __attribute__((const)) snrt_cluster_idx();
uint32_t __attribute__((const)) snrt_cluster_core_idx();
uint32_t __attribute__((const)) snrt_cluster_dm_core_num();
uint32_t __attribute__((const)) snrt_cluster_compute_core_num();
int __attribute__((const)) snrt_is_compute_core();
int __attribute__((const)) snrt_is_dm_core();
