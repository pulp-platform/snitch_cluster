// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>

#define R_TYPE_ENCODE(funct7, rs2, rs1, funct3, rd, opcode)                    \
    ((funct7 << 25) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | (rd << 7) | \
     (opcode))

#define OP_CUSTOM1 0b0101011

inline void snrt_wfi();

inline uint32_t snrt_mcycle();

inline void snrt_interrupt_enable(uint32_t irq);

inline void snrt_interrupt_disable(uint32_t irq);

inline void snrt_interrupt_global_enable(void);

inline void snrt_interrupt_global_disable(void);
