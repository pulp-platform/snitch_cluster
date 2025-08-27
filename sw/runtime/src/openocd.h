// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

#include <stdint.h>

#pragma once

#define SEMIHOST_EXIT_SUCCESS 0x20026
#define SEMIHOST_EXIT_ERROR 0x20023

/* riscv semihosting standard:
 * IN: a0 holds syscall number
 * IN: a1 holds pointer to arg struct
 * OUT: a0 holds return value (if exists)
 */
static inline long __ocd_semihost(long n, long _a1) {
    register long a0 asm("a0") = n;
    register long a1 asm("a1") = _a1;

    // riscv magic values for semihosting
    asm volatile(
        ".option norvc;\t\n"
        "slli    zero,zero,0x1f\t\n"
        "ebreak\t\n"
        "srai    zero,zero,0x7\t\n"
        ".option rvc;\t\n"
        : "+r"(a0)
        : "r"(a1));

    return a0;
}

static inline int __ocd_semihost_write(int fd, uint8_t *buffer, int len) {
    uint32_t args[3] = {(long)fd, (long)buffer, (long)len};
    __asm__ __volatile__("" : : : "memory");
    return __ocd_semihost(0x05, (long)args);
}

static inline void __ocd_semihost_exit(int status) {
    __ocd_semihost(0x18,
                   status == 0 ? SEMIHOST_EXIT_SUCCESS : SEMIHOST_EXIT_ERROR);
}