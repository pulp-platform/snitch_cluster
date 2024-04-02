// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>
#include <stddef.h>
#include "dma.h"
#include "sssr.h"

#define PRINTF_NTOA_BUFFER_SIZE 12
#define PRINTF_DISABLE_SUPPORT_LONG_LONG 1

#include "printf.h"

extern uintptr_t volatile tohost, fromhost;

extern void *__const_tcdm_start;
extern void *__const_dram_start;

// Use this to identify and differentiate TCDM data and pointers
#define TCDMSPC __attribute__((address_space(1)))
#define TCDMSEC __attribute__((section(".l1")))
#define TCDM TCDMSPC
#define TCDMDECL TCDMSPC TCDMSEC

static inline volatile uint32_t __rt_get_hartid() {
    uint32_t register r;
    asm volatile ("csrr %0, mhartid" : "=r"(r));
    return r;
}
// Rudimentary string buffer for putchar calls.
extern uint32_t _putcb;
#define PUTC_BUFFER_LEN (1024 - sizeof(size_t) - 8*sizeof(uint64_t))

typedef struct {
    size_t size;
    uint64_t syscall_mem[8];
} putc_buffer_header_t;

typedef struct {
    putc_buffer_header_t hdr;
    char data[PUTC_BUFFER_LEN];
} putc_buffer_t;

static volatile putc_buffer_t *const putc_buffer = (putc_buffer_t *const)(void *)&_putcb;

// Provide an implementation for putchar.
void _putchar(char character) {
    volatile putc_buffer_t *buf = &putc_buffer[__rt_get_hartid()];
    buf->data[buf->hdr.size++] = character;
    if (buf->hdr.size == PUTC_BUFFER_LEN || character == '\n') {
        buf->hdr.syscall_mem[0] = 64;  // sys_write
        buf->hdr.syscall_mem[1] = 1;   // file descriptor (1 = stdout)
        buf->hdr.syscall_mem[2] = (uintptr_t)&buf->data;  // buffer
        buf->hdr.syscall_mem[3] = buf->hdr.size;          // length

        tohost = (uintptr_t)buf->hdr.syscall_mem;
        while (fromhost == 0)
            ;
        fromhost = 0;

        buf->hdr.size = 0;
    }
}

// Print a (null-terminated) string
static inline void __rt_print(const char* buf) {
    for (; *buf; ++buf) _putchar(*buf);
}

// Print a decimal number
static inline void __rt_print_dec_uint(uint32_t val) {
    const int DEC_BUF_LEN = 10;
    char out [DEC_BUF_LEN];
    int out_msd;
    int i;
    // Capture digits
    for (i=DEC_BUF_LEN-2; i >= 0; --i) {
        char digit = (val % 10);
        out[i] = digit + '0';
        val /= 10;
        out_msd = i;
        if (val == 0) break;
    }
    out[DEC_BUF_LEN-1] = '\0';
    // Print digits
    __rt_print(out + out_msd);
}

// Cluster-local barrier
static inline void __rt_barrier() {
    asm volatile("csrr x0, 0x7C2" ::: "memory");
}

// Full memory fence
static inline void __rt_fence() {
    asm volatile("fence" ::: "memory");
}

#define __RT_FPU_FENCE  "fmv.x.w zero, fa0\n"

// Fence waiting for FPU to catch up to core
static inline void __rt_fpu_fence() {
    asm volatile(__RT_FPU_FENCE ::: "memory");
}

// Cluster-local barrier
static inline void __rt_fpu_fence_full() {
    uint32_t register tmp;
    asm volatile (
        "fmv.x.w %[tmp], fa0 \n"
        "mv zero, %[tmp] \n"
        : [tmp]"=r"(tmp) :: "memory"
    );
}

// Memcopy using FPU
static inline void __rt_memcpy_fpu(double* dst, double* src, size_t lend) {
    #pragma clang loop unroll_count(8)
    for (int i = 0; i < lend; i++)
        *(volatile double*)(dst + i) = *(volatile double*)(src + i);
}

// Monotonically increasing cycle count
static inline volatile uint32_t __rt_get_timer() {
    uint32_t register r;
    asm volatile ("csrr %0, mcycle" : "=r"(r));
    return r;
}

// Sleep for multiples of 10 (Deca) cycles
static inline void __rt_shortsleep(uint32_t Dcycles) {
    for (int i = 0; i < Dcycles; ++i) {
        asm volatile ("nop; nop; nop; nop; nop; nop; nop; nop; nop; nop" ::: "memory");
    }
}

// Include putchar code directly (header-only implementation)
#include "printf.c"
