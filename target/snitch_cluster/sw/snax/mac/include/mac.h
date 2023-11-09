// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Josse Van Delm <jvandelm@esat.kuleuven.be>

#include <stdint.h>

#pragma once
// * mac_mode = 0
//   performs multiply-accumulate over elements to perform dot product
// * simple_mult_mode = 1
//   performs simple elementwise multiplication
enum mode { mac_mode, simple_mult_mode };

void snax_mac_launch();

void snax_mac_sw_clear();

void snax_mac_sw_barrier();

void snax_mac_setup_simple_mult(uint32_t* a, uint32_t* b, uint32_t* o,
                                uint32_t vector_length);

void cpu_simple_mult(uint32_t* a, uint32_t* b, uint32_t* o,
                     uint32_t vector_length);

int check_simple_mult(uint32_t* output, uint32_t* output_golden,
                      uint32_t vector_length);
