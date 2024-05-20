// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifdef OPENOCD_SEMIHOSTING
#include "openocd.h"
#endif

#ifdef SNRT_CRT0_EXIT
inline void snrt_exit_default(int exit_code) {
    exit_code = snrt_global_all_to_all_reduction(exit_code);
#ifdef OPENOCD_SEMIHOSTING
    if (snrt_global_core_idx() == 0) __ocd_semihost_exit(exit_code);
#else
    if (snrt_global_core_idx() == 0)
        *(snrt_exit_code_destination()) = (exit_code << 1) | 1;
#endif
}
#ifndef SNRT_CRT0_ALTERNATE_EXIT
inline void snrt_exit(int exit_code) { snrt_exit_default(exit_code); }
#endif
#endif

#ifdef SNRT_INIT_CLS
inline uint32_t snrt_cls_base_addr() {
    extern volatile uint32_t __cdata_start, __cdata_end;
    extern volatile uint32_t __cbss_start, __cbss_end;
    uint32_t cdata_size = ((uint32_t)&__cdata_end) - ((uint32_t)&__cdata_start);
    uint32_t cbss_size = ((uint32_t)&__cbss_end) - ((uint32_t)&__cbss_start);
    uint32_t l1_end_addr = SNRT_TCDM_START_ADDR +
                           snrt_cluster_idx() * SNRT_CLUSTER_OFFSET +
                           SNRT_TCDM_SIZE;
    return l1_end_addr - cdata_size - cbss_size;
}
#endif
