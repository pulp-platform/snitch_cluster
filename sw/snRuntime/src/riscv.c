// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "riscv_decls.h"

#include "riscv.h"

extern void snrt_wfi();

extern void snrt_nop();

extern uint32_t snrt_mcycle();

extern void snrt_interrupt_enable(uint32_t irq);

extern void snrt_interrupt_disable(uint32_t irq);

extern void snrt_interrupt_global_enable(void);

extern void snrt_interrupt_global_disable(void);
