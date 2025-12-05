// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Authors: Samuel Riedel, ETH Zurich <sriedel@iis.ee.ethz.ch>
//          Viviane Potocnik, ETH Zurich <vivianep@iis.ee.ethz.ch>
//          Luca Colagrande, ETH Zurich <colluca@iis.ee.ethz.ch>

// Dump a value via CSR
// !!! Careful: This is only supported in simulation and an experimental
// feature.
// This can be exploited to quickly print measurement values from all cores
// simultaneously without the hassle of printf.

#pragma once

#define DUMP(val) ({ asm volatile("csrw dump, %0" ::"rK"(val)); })
