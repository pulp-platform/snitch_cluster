// Copyright 2026 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdint.h>
#include <stdio.h>

#include "data.h"
#include "pace_elementwise.h"
#include "snrt.h"

#ifndef PACE_CSR_DEGREE
#define PACE_CSR_DEGREE PACE_DEGREE
#endif

#if PACE_DTYPE_FP32
#define SPATZ_VSETVLI "vsetvli %0, %1, e32, m8, ta, ma"
#define SPATZ_VLE_V0 "vle32.v v0, (%0)"
#define SPATZ_VLE_V16 "vle32.v v16, (%0)"
#define SPATZ_VSE_V8 "vse32.v v8, (%0)"
#define SPATZ_VSE_V24 "vse32.v v24, (%0)"
#define SPATZ_VPACE_PWPA_V8 "vpace.pwpa.s f8, ft0, ft0"
#define SPATZ_VPACE_PWPA_V24 "vpace.pwpa.s f24, f16, f16"
#elif PACE_DTYPE_FP16 || PACE_DTYPE_BFP16
#define SPATZ_VSETVLI "vsetvli %0, %1, e16, m8, ta, ma"
#define SPATZ_VLE_V0 "vle16.v v0, (%0)"
#define SPATZ_VLE_V16 "vle16.v v16, (%0)"
#define SPATZ_VSE_V8 "vse16.v v8, (%0)"
#define SPATZ_VSE_V24 "vse16.v v24, (%0)"
#define SPATZ_VPACE_PWPA_V8 "vpace.pwpa.h f8, ft0, ft0"
#define SPATZ_VPACE_PWPA_V24 "vpace.pwpa.h f24, f16, f16"
#else
#error "Unsupported Spatz PACE datatype"
#endif

static data_t *local_x;
static data_t *local_y;
static param_t *local_params;

static inline void write_pace_csr(uint32_t degree) {
    asm volatile("csrw 0x7d2, %0" : : "rK"(degree) : "memory");
}

static void copy_inputs_to_tcdm(void) {
    local_x = (data_t *)snrt_l1_alloc(INPUTS_LEN * sizeof(data_t));
    local_y = (data_t *)snrt_l1_alloc(INPUTS_LEN * sizeof(data_t));
    local_params = (param_t *)snrt_l1_alloc(PARAMS_LEN * sizeof(param_t));

    snrt_dma_start_1d(local_x, ifmap, INPUTS_LEN * sizeof(data_t));
    snrt_dma_start_1d(local_params, params, PARAMS_LEN * sizeof(param_t));
    snrt_dma_wait_all();
}

static void copy_params_to_pace_mem(void) {
    volatile param_t *pace_mem =
        (volatile param_t *)snrt_cluster()->pacemem.mem;

    snrt_dma_start_1d((void *)pace_mem, local_params,
                      PARAMS_LEN * sizeof(param_t));
    snrt_dma_wait_all();
}

static void run_spatz_pace_loop(void) {
    data_t *x = local_x;
    data_t *y = local_y;
    uint32_t avl = INPUTS_LEN;
    uint32_t vlmax;

    asm volatile(SPATZ_VSETVLI : "=r"(vlmax) : "r"(avl) : "memory");

    while (avl >= 2 * vlmax) {
        asm volatile(SPATZ_VLE_V0 : : "r"(x) : "memory");
        asm volatile(SPATZ_VLE_V16 : : "r"(x + vlmax) : "memory");

        asm volatile(SPATZ_VPACE_PWPA_V8 : : : "memory");
        asm volatile(SPATZ_VPACE_PWPA_V24 : : : "memory");

        asm volatile(SPATZ_VSE_V8 : : "r"(y) : "memory");
        asm volatile(SPATZ_VSE_V24 : : "r"(y + vlmax) : "memory");

        x += 2 * vlmax;
        y += 2 * vlmax;
        avl -= 2 * vlmax;
    }

    while (avl > 0) {
        uint32_t vl;

        asm volatile(SPATZ_VSETVLI : "=r"(vl) : "r"(avl) : "memory");

        asm volatile(SPATZ_VLE_V0 : : "r"(x) : "memory");
        asm volatile(SPATZ_VPACE_PWPA_V8 : : : "memory");
        asm volatile(SPATZ_VSE_V8 : : "r"(y) : "memory");

        x += vl;
        y += vl;
        avl -= vl;
    }
}

static void copy_output_from_tcdm(void) {
    snrt_dma_start_1d(ofmap, local_y, INPUTS_LEN * sizeof(data_t));
    snrt_dma_wait_all();
}

static int check_output(void) {
    int errors = 0;

    for (uint32_t i = 0; i < INPUTS_LEN; i++) {
        if (ofmap[i] == golden[i]) continue;

        if (errors < 16) {
            printf("idx:%u actual=0x%x golden=0x%x\n", i, (uint32_t)ofmap[i],
                   (uint32_t)golden[i]);
        }
        errors++;
    }

    return errors;
}

int main(void) {
    if (snrt_is_dm_core()) {
        copy_inputs_to_tcdm();
        copy_params_to_pace_mem();
    }
    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        write_pace_csr(PACE_CSR_DEGREE);
        pace_configure_fmode();
    }
    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core() && snrt_cluster_core_idx() == 0) {
        run_spatz_pace_loop();
    }
    snrt_cluster_hw_barrier();

    if (snrt_is_dm_core()) {
        copy_output_from_tcdm();
    }
    snrt_cluster_hw_barrier();

    if (snrt_global_core_idx() == 0) {
        int errors = check_output();
        printf("spatz_pace_loop: errors=%d\n", errors);
        return errors;
    }

    return 0;
}
