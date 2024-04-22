// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

void snrt_int_cluster_set(uint32_t mask);

void snrt_int_cluster_clr(uint32_t mask);

void snrt_int_clr_mcip_unsafe();

void snrt_int_clr_mcip();

void snrt_int_set_mcip();
