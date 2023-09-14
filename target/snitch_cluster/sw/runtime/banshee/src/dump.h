// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Authors: Samuel Riedel, ETH Zurich <sriedel@iis.ee.ethz.ch>
//          Viviane Potocnik, ETH Zurich <vivianep@iis.ee.ethz.ch>

// Dump a value via CSR
// !!! Careful: This is only supported in simulation and an experimental
// feature. All writes to unimplemented CSR registers will be dumped by Snitch.
// This can be exploited to quickly print measurement values from all cores
// simultaneously without the hassle of printf. To specify multiple metrics,
// different CSRs can be used. The macro will define a function that will then
// always print via the same CSR. E.g., `dump(errors, 8)` will define a function
// with the following signature: `dump_errors(uint32_t val)`, which will print
// the given value via the 8th register. Alternatively, the `write_csr(reg,
// val)` macro can be used directly.

#define dump_float(name, reg)                                                  \
    static __attribute__((always_inline)) inline void dump_##name(float val) { \
        asm volatile("csrw " #reg ", %0" ::"rK"(val));                         \
    }

#define dump_uint(name, reg)                                                   \
    static                                                                     \
        __attribute__((always_inline)) inline void dump_##name(uint32_t val) { \
        asm volatile("csrw " #reg ", %0" ::"rK"(val));                         \
    }