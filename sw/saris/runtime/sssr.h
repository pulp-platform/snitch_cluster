// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#pragma once

// Registers
#define __RT_SSSR_REG_STATUS     0
#define __RT_SSSR_REG_REPEAT     1

#define __RT_SSSR_REG_BOUND_0    2
#define __RT_SSSR_REG_BOUND_1    3
#define __RT_SSSR_REG_BOUND_2    4
#define __RT_SSSR_REG_BOUND_3    5

#define __RT_SSSR_REG_STRIDE_0   6
#define __RT_SSSR_REG_STRIDE_1   7
#define __RT_SSSR_REG_STRIDE_2   8
#define __RT_SSSR_REG_STRIDE_3   9

#define __RT_SSSR_REG_IDX_CFG    10
#define __RT_SSSR_REG_IDX_BASE   11
#define __RT_SSSR_REG_IDX_ISECT  12

#define __RT_SSSR_REG_RPTR_INDIR 16
#define __RT_SSSR_REG_RPTR_SLV   17
#define __RT_SSSR_REG_RPTR_MST_NOSLV 18
#define __RT_SSSR_REG_RPTR_MST_TOSLV 19

#define __RT_SSSR_REG_WPTR_INDIR 20
#define __RT_SSSR_REG_WPTR_SLV   21
#define __RT_SSSR_REG_WPTR_MST_NOSLV 22
#define __RT_SSSR_REG_WPTR_MST_TOSLV 23

#define __RT_SSSR_REG_RPTR_0     24
#define __RT_SSSR_REG_RPTR_1     25
#define __RT_SSSR_REG_RPTR_2     26
#define __RT_SSSR_REG_RPTR_3     27

#define __RT_SSSR_REG_WPTR_0     28
#define __RT_SSSR_REG_WPTR_1     29
#define __RT_SSSR_REG_WPTR_2     30
#define __RT_SSSR_REG_WPTR_3     31

// Enable and disable
#define __RT_SSSR_ENABLE  "csrsi 0x7C0, 1\n"
#define __RT_SSSR_DISABLE "csrci 0x7C0, 1\n"

// Write configuration registers
// To write to all SSRs, use ssridx=31
#define __RT_SSSR_IDXALL 31
#define __RT_SSSR_SCFGWI_INT(valreg,ssridx,regidx) "scfgwi "#valreg", "#ssridx" | "#regidx"<<5\n"
#define __RT_SSSR_SCFGWI(valreg,ssridx,regname) __RT_SSSR_SCFGWI_INT(valreg,ssridx,regname)

// Read configuration registers
#define __RT_SSSR_SCFGRI_INT(valreg,ssridx,regidx) "scfgri "#valreg", "#ssridx" | "#regidx"<<5\n"
#define __RT_SSSR_SCFGRI(valreg,ssridx,regname) __RT_SSSR_SCFGRI_INT(valreg,ssridx,regname)

// Assemble index configuration word
#define __RT_SSSR_IDXSIZE_U8   0
#define __RT_SSSR_IDXSIZE_U16  1
#define __RT_SSSR_IDXSIZE_U32  2
#define __RT_SSSR_IDXSIZE_U64  3
#define __RT_SSSR_IDX_NOMERGE  0
#define __RT_SSSR_IDX_MERGE    1
#define __RT_SSSR_IDX_CFG(size,shift,flags) (((flags & 0xFFFF)<<16) | ((shift & 0xFF)<<8) | (size & 0xFF) )

// Block until job is done
// TODO: Replace with (shadowed) blocking read or write
#define __RT_SSSR_WAIT_DONE(tempreg, ssridx) \
    "1:" __RT_SSSR_SCFGRI(tempreg,ssridx,__RT_SSSR_REG_STATUS) \
    "srli   "#tempreg", "#tempreg", 31  \n" \
    "beqz   "#tempreg", 1b              \n"

// Allocates the specified registers and fakes them as
// outputs of an SSSR enable, enforcing an order.
#define __RT_SSSR_BLOCK_BEGIN \
    { \
    register double _rt_sssr_0 asm("ft0"); \
    register double _rt_sssr_1 asm("ft1"); \
    register double _rt_sssr_2 asm("ft2"); \
    asm volatile(__RT_SSSR_ENABLE : "+f"(_rt_sssr_0), "+f"(_rt_sssr_1), "+f"(_rt_sssr_2) :: "memory");

// Disables the SSSRs, taking as fake inputs the allocated
// registers for the SSRs and thus allowing reallocation.
#define __RT_SSSR_BLOCK_END \
    asm volatile(__RT_SSSR_DISABLE : "+f"(_rt_sssr_0), "+f"(_rt_sssr_1), "+f"(_rt_sssr_2) :: "memory"); \
    }

static inline void __rt_sssr_cfg_write(uint32_t val, uint32_t ssridx, uint32_t regidx) {
    asm volatile (
        __RT_SSSR_SCFGWI_INT(%[valreg],%[ssridx],%[regidx])
        :: [valreg]"r"(val), [ssridx]"i"(ssridx), [regidx]"i"(regidx) : "memory"
    );
}

static inline void __rt_sssr_cfg_write_ptr(void* val, uint32_t ssridx, uint32_t regidx) {
    __rt_sssr_cfg_write((uintptr_t)val, ssridx, regidx);
}

static inline uint32_t __rt_sssr_cfg_read(uint32_t ssridx, uint32_t regidx) {
    uint32_t ret;
    asm volatile (
        __RT_SSSR_SCFGRI_INT(%[retreg],%[ssridx],%[regidx])
        : [retreg]"=r"(ret) : [ssridx]"i"(ssridx), [regidx]"i"(regidx) : "memory"
    );
    return ret;
}

static inline void __rt_sssr_enable() {
    asm volatile(__RT_SSSR_ENABLE ::: "memory");
}

static inline void __rt_sssr_disable() {
    asm volatile(__RT_SSSR_DISABLE ::: "memory");
}

static inline uint16_t __rt_sssr_ptoi(void* ptr) {
    // We assume TCDM alignment here; TCDM address offset is ignored
    // as it will be masked in the SSR at at the latest
    return (uint16_t)((uintptr_t)ptr >> 3);
}

static inline void __rt_sssr_bound_stride_1d(
    uint32_t ssridx,
    uint32_t b0, uint32_t s0
) {
    // argument bounds and strides are *non-inclusive* for convenience
    __rt_sssr_cfg_write(--b0, ssridx, __RT_SSSR_REG_BOUND_0);
    __rt_sssr_cfg_write(s0, ssridx, __RT_SSSR_REG_STRIDE_0);
}

static inline void __rt_sssr_bound_stride_2d(
    uint32_t ssridx,
    uint32_t b0, uint32_t s0,
    uint32_t b1, uint32_t s1
) {
    // argument bounds and strides are *non-inclusive* for convenience
    __rt_sssr_cfg_write(--b0 , ssridx, __RT_SSSR_REG_BOUND_0);
    __rt_sssr_cfg_write(--b1 , ssridx, __RT_SSSR_REG_BOUND_1);
    uint32_t a = 0;
    __rt_sssr_cfg_write(s0-a, ssridx, __RT_SSSR_REG_STRIDE_0);
    a += s0 * b0;
    __rt_sssr_cfg_write(s1-a, ssridx, __RT_SSSR_REG_STRIDE_1);
}

static inline void __rt_sssr_bound_stride_3d(
    uint32_t ssridx,
    uint32_t b0, uint32_t s0,
    uint32_t b1, uint32_t s1,
    uint32_t b2, uint32_t s2
) {
    // argument bounds and strides are *non-inclusive* for convenience
    __rt_sssr_cfg_write(--b0 , ssridx, __RT_SSSR_REG_BOUND_0);
    __rt_sssr_cfg_write(--b1 , ssridx, __RT_SSSR_REG_BOUND_1);
    __rt_sssr_cfg_write(--b2 , ssridx, __RT_SSSR_REG_BOUND_2);
    uint32_t a = 0;
    __rt_sssr_cfg_write(s0-a, ssridx, __RT_SSSR_REG_STRIDE_0);
    a += s0 * b0;
    __rt_sssr_cfg_write(s1-a, ssridx, __RT_SSSR_REG_STRIDE_1);
    a += s1 * b1;
    __rt_sssr_cfg_write(s2-a, ssridx, __RT_SSSR_REG_STRIDE_2);
}

static inline void __rt_sssr_bound_stride_4d(
    uint32_t ssridx,
    uint32_t b0, uint32_t s0,
    uint32_t b1, uint32_t s1,
    uint32_t b2, uint32_t s2,
    uint32_t b3, uint32_t s3
) {
    // argument bounds and strides are *non-inclusive* for convenience
    __rt_sssr_cfg_write(--b0 , ssridx, __RT_SSSR_REG_BOUND_0);
    __rt_sssr_cfg_write(--b1 , ssridx, __RT_SSSR_REG_BOUND_1);
    __rt_sssr_cfg_write(--b2 , ssridx, __RT_SSSR_REG_BOUND_2);
    __rt_sssr_cfg_write(--b3 , ssridx, __RT_SSSR_REG_BOUND_3);
    uint32_t a = 0;
    __rt_sssr_cfg_write(s0-a, ssridx, __RT_SSSR_REG_STRIDE_0);
    a += s0 * b0;
    __rt_sssr_cfg_write(s1-a, ssridx, __RT_SSSR_REG_STRIDE_1);
    a += s1 * b1;
    __rt_sssr_cfg_write(s2-a, ssridx, __RT_SSSR_REG_STRIDE_2);
    a += s2 * b2;
    __rt_sssr_cfg_write(s3-a, ssridx, __RT_SSSR_REG_STRIDE_3);
}

static inline void __rt_sssr_wait_done(uint32_t ssridx) {
    uint32_t tmp;
    asm volatile (
        __RT_SSSR_WAIT_DONE(%[tmpreg],%[ssridx])
        : [tmpreg]"+&r"(tmp) : [ssridx]"i"(ssridx) : "memory"
    );
}
