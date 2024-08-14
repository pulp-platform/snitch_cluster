// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Header file for functions in snax-hypercorex-lib.c
//-------------------------------

#pragma once
#include <stdbool.h>
#include "snax-hypercorex-csr.h"
#include "snrt.h"
#include "stdint.h"

uint32_t hypercorex_set_inst_loop_jump_addr(uint8_t config1, uint8_t config2,
                                            uint8_t config3);

uint32_t hypercorex_set_inst_loop_end_addr(uint8_t config1, uint8_t config2,
                                           uint8_t config3);

uint32_t hypercorex_set_inst_loop_count(uint8_t config1, uint8_t config2,
                                        uint8_t config3);

uint32_t hypercorex_set_im_base_seed(uint32_t im_idx, uint32_t config);
