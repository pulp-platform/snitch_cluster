// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifndef PACE_ELEMENTWISE_H
#define PACE_ELEMENTWISE_H

#include <stdint.h>

#include "data.h"

#define PACE_FMODE_FP 0
#define PACE_FMODE_ALT 3

#ifndef PACE_FMODE
#if defined(PACE_DTYPE_BFP16) && PACE_DTYPE_BFP16
#define PACE_FMODE PACE_FMODE_ALT
#else
#define PACE_FMODE PACE_FMODE_FP
#endif
#endif

static inline void pace_configure_fmode(void) {
    asm volatile("csrw fmode, %0" : : "rK"(PACE_FMODE) : "memory");
}

#if !defined(PACE_DTYPE_FP32) && !defined(PACE_DTYPE_FP16) && \
    !defined(PACE_DTYPE_BFP16)
#if defined(ENABLE_FP32)
#define PACE_DTYPE_FP32 1
#define PACE_DTYPE_FP16 0
#define PACE_DTYPE_BFP16 0
#elif defined(ENABLE_FP16)
#define PACE_DTYPE_FP32 0
#define PACE_DTYPE_FP16 1
#define PACE_DTYPE_BFP16 0
#else
#error "Unsupported PACE datatype configuration"
#endif
#endif

#define PACE_VPWPA_FP32 "vpace.pwpa.s "
#define PACE_VPWPA_FP16 "vpace.pwpa.h "
#define PACE_VPWPA_BFP16 "vpace.pwpa.h "
#define PACE_VINV_FP32 "vpace.inv.s "
#define PACE_VINV_FP16 "vpace.inv.h "
#define PACE_VINV_BFP16 "vpace.inv.h "
#define PACE_VSQRT_FP32 "vpace.sqrt.s "
#define PACE_VSQRT_FP16 "vpace.sqrt.h "
#define PACE_VSQRT_BFP16 "vpace.sqrt.h "
#define PACE_VRSQRT_FP32 "vpace.rsqrt.s "
#define PACE_VRSQRT_FP16 "vpace.rsqrt.h "
#define PACE_VRSQRT_BFP16 "vpace.rsqrt.h "
#define PACE_PWPA_FP32 "pace.pwpa.s "
#define PACE_PWPA_FP16 "pace.pwpa.h "
#define PACE_PWPA_BFP16 "pace.pwpa.h "
#define PACE_INV_FP32 "pace.inv.s "
#define PACE_INV_FP16 "pace.inv.h "
#define PACE_INV_BFP16 "pace.inv.h "
#define PACE_SQRT_FP32 "pace.sqrt.s "
#define PACE_SQRT_FP16 "pace.sqrt.h "
#define PACE_SQRT_BFP16 "pace.sqrt.h "
#define PACE_RSQRT_FP32 "pace.rsqrt.s "
#define PACE_RSQRT_FP16 "pace.rsqrt.h "
#define PACE_RSQRT_BFP16 "pace.rsqrt.h "

#if PACE_DTYPE_FP32
#define PACE_VPWPA PACE_VPWPA_FP32
#define PACE_VINV PACE_VINV_FP32
#define PACE_VSQRT PACE_VSQRT_FP32
#define PACE_VRSQRT PACE_VRSQRT_FP32
#define PACE_PWPA PACE_PWPA_FP32
#define PACE_INV PACE_INV_FP32
#define PACE_SQRT PACE_SQRT_FP32
#define PACE_RSQRT PACE_RSQRT_FP32
#elif PACE_DTYPE_FP16
#define PACE_VPWPA PACE_VPWPA_FP16
#define PACE_VINV PACE_VINV_FP16
#define PACE_VSQRT PACE_VSQRT_FP16
#define PACE_VRSQRT PACE_VRSQRT_FP16
#define PACE_PWPA PACE_PWPA_FP16
#define PACE_INV PACE_INV_FP16
#define PACE_SQRT PACE_SQRT_FP16
#define PACE_RSQRT PACE_RSQRT_FP16
#elif PACE_DTYPE_BFP16
#define PACE_VPWPA PACE_VPWPA_BFP16
#define PACE_VINV PACE_VINV_BFP16
#define PACE_VSQRT PACE_VSQRT_BFP16
#define PACE_VRSQRT PACE_VRSQRT_BFP16
#define PACE_PWPA PACE_PWPA_BFP16
#define PACE_INV PACE_INV_BFP16
#define PACE_SQRT PACE_SQRT_BFP16
#define PACE_RSQRT PACE_RSQRT_BFP16
#else
#error "Unsupported PACE datatype"
#endif

#if defined(PACE_MODE_PWPA) && defined(PACE_MODE_INV) && \
    defined(PACE_MODE_SQRT) && defined(PACE_MODE_RSQRT)
#if PACE_MODE_PWPA
#define PACE_SCALAR PACE_PWPA
#define PACE_VECTOR PACE_VPWPA
#elif PACE_MODE_INV
#define PACE_SCALAR PACE_INV
#define PACE_VECTOR PACE_VINV
#elif PACE_MODE_SQRT
#define PACE_SCALAR PACE_SQRT
#define PACE_VECTOR PACE_VSQRT
#elif PACE_MODE_RSQRT
#define PACE_SCALAR PACE_RSQRT
#define PACE_VECTOR PACE_VRSQRT
#else
#error "Unsupported PACE mode"
#endif
#endif

#define PACE_VPWPA_OP(rd, rs1, rs2) PACE_VPWPA rd ", " rs1 ", " rs2 "\n\t"
#define PACE_VINV_OP(rd, rs1, rs2) PACE_VINV rd ", " rs1 ", " rs2 "\n\t"
#define PACE_INV_OP(rd, rs1) PACE_INV rd ", " rs1 "\n\t"
#define PACE_SCALAR_OP(rd, rs1) PACE_SCALAR rd ", " rs1 "\n\t"
#define PACE_VECTOR_OP(rd, rs1, rs2) PACE_VECTOR rd ", " rs1 ", " rs2 "\n\t"

#define PACE_FREP_VPACE(repeat_count, instruction)                  \
    __asm__ volatile("frep.o  %[n], 1, 0, 0\n\t" instruction "\n\t" \
                     :                                              \
                     : [ n ] "r"(repeat_count)                      \
                     : "ft0", "ft1", "memory")

static inline void pwpa_vector_fp32(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.pwpa.s ft1, ft0, ft0");
}

static inline void pwpa_vector_fp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.pwpa.h ft1, ft0, ft0");
}

static inline void pwpa_vector_bfp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.pwpa.h ft1, ft0, ft0");
}

static inline void pace_inv_vector_fp32(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.inv.s ft1, ft0, ft0");
}

static inline void pace_inv_vector_fp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.inv.h ft1, ft0, ft0");
}

static inline void pace_inv_vector_bfp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.inv.h ft1, ft0, ft0");
}

static inline void pace_sqrt_vector_fp32(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.sqrt.s ft1, ft0, ft0");
}

static inline void pace_sqrt_vector_fp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.sqrt.h ft1, ft0, ft0");
}

static inline void pace_sqrt_vector_bfp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.sqrt.h ft1, ft0, ft0");
}

static inline void pace_rsqrt_vector_fp32(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.rsqrt.s ft1, ft0, ft0");
}

static inline void pace_rsqrt_vector_fp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.rsqrt.h ft1, ft0, ft0");
}

static inline void pace_rsqrt_vector_bfp16(uint32_t repeat_count) {
    PACE_FREP_VPACE(repeat_count, "vpace.rsqrt.h ft1, ft0, ft0");
}

#if defined(PACE_MODE_PWPA) && defined(PACE_MODE_INV) && \
    defined(PACE_MODE_SQRT) && defined(PACE_MODE_RSQRT)
static inline void pace_vector_ssr(uint32_t repeat_count) {
#if PACE_MODE_PWPA
#if PACE_DTYPE_FP32
    pwpa_vector_fp32(repeat_count);
#elif PACE_DTYPE_FP16
    pwpa_vector_fp16(repeat_count);
#elif PACE_DTYPE_BFP16
    pwpa_vector_bfp16(repeat_count);
#else
#error "Unsupported PACE PWPA vector datatype"
#endif
#elif PACE_MODE_INV
#if PACE_DTYPE_FP32
    pace_inv_vector_fp32(repeat_count);
#elif PACE_DTYPE_FP16
    pace_inv_vector_fp16(repeat_count);
#elif PACE_DTYPE_BFP16
    pace_inv_vector_bfp16(repeat_count);
#else
#error "Unsupported PACE inv vector datatype"
#endif
#elif PACE_MODE_SQRT
#if PACE_DTYPE_FP32
    pace_sqrt_vector_fp32(repeat_count);
#elif PACE_DTYPE_FP16
    pace_sqrt_vector_fp16(repeat_count);
#elif PACE_DTYPE_BFP16
    pace_sqrt_vector_bfp16(repeat_count);
#else
#error "Unsupported PACE sqrt vector datatype"
#endif
#elif PACE_MODE_RSQRT
#if PACE_DTYPE_FP32
    pace_rsqrt_vector_fp32(repeat_count);
#elif PACE_DTYPE_FP16
    pace_rsqrt_vector_fp16(repeat_count);
#elif PACE_DTYPE_BFP16
    pace_rsqrt_vector_bfp16(repeat_count);
#else
#error "Unsupported PACE rsqrt vector datatype"
#endif
#else
#error "Unsupported PACE vector mode"
#endif
}
#endif

#undef PACE_FREP_VPACE

#endif
