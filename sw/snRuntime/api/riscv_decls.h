// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

void snrt_wfi();

uint32_t snrt_mcycle();

void snrt_interrupt_enable(uint32_t irq);

void snrt_interrupt_disable(uint32_t irq);

void snrt_interrupt_global_enable(void);

void snrt_interrupt_global_disable(void);
