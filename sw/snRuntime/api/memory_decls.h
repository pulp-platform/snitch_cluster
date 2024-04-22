// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

uint32_t __attribute__((const)) snrt_l1_start_addr();

uint32_t __attribute__((const)) snrt_l1_end_addr();

volatile uint32_t* __attribute__((const)) snrt_clint_mutex_ptr();

volatile uint32_t* __attribute__((const)) snrt_clint_msip_ptr();

volatile uint32_t* __attribute__((const)) snrt_cluster_clint_set_ptr();

volatile uint32_t* __attribute__((const)) snrt_cluster_clint_clr_ptr();

uint32_t __attribute__((const)) snrt_cluster_hw_barrier_addr();
