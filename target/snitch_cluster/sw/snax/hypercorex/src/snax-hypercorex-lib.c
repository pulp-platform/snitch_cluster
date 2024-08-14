// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Author: Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Library: Functions for Setting Hypecorex CSRs
//
// This pre-built library contains functions to set
// the HyperCoreX accelerator's CSRs.
//-------------------------------

#include <stdbool.h>
#include "snax-hypercorex-csr.h"
#include "snrt.h"
#include "stdint.h"

//-------------------------------
// Instruction loop control functions
//
// These isntructions take in 7 bits per configuration
// and packs them into one 32-bit register
// Upper MSBs are tied to 0s
//
// Note: This is a parameter that changes
// depending on how large the instruction memory is
//-------------------------------

uint32_t hypercorex_set_inst_loop_jump_addr(uint8_t config1, uint8_t config2,
                                            uint8_t config3) {
    uint32_t config =
        ((config3 & 0x7f) << 14) | ((config2 & 0x7f) << 7) | (config1 & 0x7f);

    csrw_ss(HYPERCOREX_INST_LOOP_JUMP_ADDR_REG_ADDR, config);
    return 0;
};

uint32_t hypercorex_set_inst_loop_end_addr(uint8_t config1, uint8_t config2,
                                           uint8_t config3) {
    uint32_t config =
        ((config3 & 0x7f) << 14) | ((config2 & 0x7f) << 7) | (config1 & 0x7f);

    csrw_ss(HYPERCOREX_INST_LOOP_END_ADDR_REG_ADDR, config);
    return 0;
};

uint32_t hypercorex_set_inst_loop_count(uint8_t config1, uint8_t config2,
                                        uint8_t config3) {
    uint32_t config =
        ((config3 & 0x7f) << 14) | ((config2 & 0x7f) << 7) | (config1 & 0x7f);

    csrw_ss(HYPERCOREX_INST_LOOP_COUNT_REG_ADDR, config);
    return 0;
};

//-------------------------------
// Writing to orthogonal IM seeds
//-------------------------------
uint32_t hypercorex_set_im_base_seed(uint32_t im_idx, uint32_t config) {
    csrw_ss(HYPERCOREX_IM_BASE_SEED_REG_ADDR + im_idx, config);
    return 0;
};
