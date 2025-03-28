// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

inline void snrt_wfi();

inline uint32_t snrt_mcycle();

inline void snrt_interrupt_enable(uint32_t irq);

inline void snrt_interrupt_disable(uint32_t irq);

inline void snrt_interrupt_global_enable(void);

inline void snrt_interrupt_global_disable(void);
