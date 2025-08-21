// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifdef SNRT_INIT_CLS
static inline uint32_t snrt_cls_base_addr() {
    extern volatile uint32_t __cdata_start, __cdata_end;
    extern volatile uint32_t __cbss_start, __cbss_end;
    uint32_t cdata_size = ((uint32_t)&__cdata_end) - ((uint32_t)&__cdata_start);
    uint32_t cbss_size = ((uint32_t)&__cbss_end) - ((uint32_t)&__cbss_start);
    // uint32_t l1_end_addr = SNRT_TCDM_START_ADDR +
    //                        snrt_cluster_idx() * SNRT_CLUSTER_OFFSET +
    //                        SNRT_TCDM_SIZE;
    uint32_t l1_end_addr = snrt_cluster_base_addrl() + SNRT_TCDM_SIZE;
    return l1_end_addr - cdata_size - cbss_size;
}
#endif
// In the future we will remove the idma in the cluster
// Hence we remove the init code that using DMA to init
// We use the CPU to init
#ifdef SNRT_INIT_TLS
static inline void snrt_init_tls() {
    extern volatile uint32_t __tdata_start, __tdata_end;
    extern volatile uint32_t __tbss_start, __tbss_end;

    size_t size;
    volatile uint32_t tls_ptr;

    uint8_t* tdata_src = (uint8_t*)&__tdata_start;
    uint8_t* tdata_end = (uint8_t*)&__tdata_end;
    if (snrt_is_dm_core()) {
        size = (size_t)(&__tdata_end) - (size_t)(&__tdata_start);
        // First initialize the DM core's .tdata section from main memory
        asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
        uint8_t* tls_dst = (uint8_t*)tls_ptr;
        for (size_t i = 0; i < size; i++) {
            tls_dst[i] = tdata_src[i];
        }
        // Then initialize all other cores' .tdata sections from the DM
        // core's. The offset between the TLS section of successive cores
        // is defined in start.S
        size_t tls_offset = (1 << SNRT_LOG2_STACK_SIZE) + 8;
        for (int i = 1; i < snrt_cluster_core_num(); i++) {
            uint8_t* dst = (uint8_t*)(tls_ptr + i * tls_offset);
            for (size_t j = 0; j < size; j++) {
                dst[j] = tls_dst[j];
            }
        }
        // Initialize all cores' .tbss sections
        uint8_t* tbss_start = (uint8_t*)&__tbss_start;
        uint8_t* tbss_end = (uint8_t*)&__tbss_end;
        size_t tbss_size = tbss_end - tbss_start;
        uint8_t* tls_tbss_base = tls_dst + size;
        for (int i = 0; i < snrt_cluster_core_num(); i++) {
            uint8_t* tbss_dst = tls_tbss_base + i * tls_offset;
            for (size_t j = 0; j < tbss_size; j++) {
                tbss_dst[j] = 0;
            }
        }
    }

    snrt_cluster_hw_barrier();
}
#endif

#ifdef SNRT_INIT_BSS
static inline void snrt_init_bss() {
    extern volatile uint32_t __bss_start, __bss_end;
    // Only one core needs to perform the initialization
    // As the snitch core is 32bit, initialize the bss region above 4GB does not
    // make sense.
    // We temporally using the CPU to init the bss

    if (snrt_cluster_idx() == 0 && snrt_is_dm_core()) {
        volatile uint8_t* bss_start = (volatile uint8_t*)&__bss_start;
        volatile uint8_t* bss_end = (volatile uint8_t*)&__bss_end;

        // 1. Byte-level Init until the 4B boundary
        volatile uint8_t* aligned_start =
            (volatile uint8_t*)((uintptr_t)(bss_start + 3) & ~(uintptr_t)3);
        for (volatile uint8_t* p = bss_start; p < aligned_start; p++) {
            *p = 0U;
        }
        // 2. 4B algined
        volatile uint32_t* word_ptr = (volatile uint32_t*)aligned_start;
        size_t total_words = (bss_end - (uint8_t*)word_ptr) / 4;
        for (size_t i = 0; i < total_words; i++) {
            word_ptr[i] = 0U;
        }
        // 3. Tail Byte-level Aligned
        volatile uint8_t* tail_start = (uint8_t*)(word_ptr + total_words);
        for (volatile uint8_t* p = tail_start; p < bss_end; p++) {
            *p = 0U;
        }
    }
}
#endif

#ifdef SNRT_INIT_CLS
static inline void snrt_init_cls() {
    extern volatile uint32_t __cdata_start, __cdata_end;
    extern volatile uint32_t __cbss_start, __cbss_end;

    _cls_ptr = (cls_t*)snrt_cls_base_addr();
    if (snrt_is_dm_core()) {
        volatile uint8_t* tcdm_base = (volatile uint8_t*)snrt_cls_base_addr();
        size_t size;

        volatile uint8_t* cdata_src = (volatile uint8_t*)&__cdata_start;
        volatile uint8_t* cdata_end = (volatile uint8_t*)&__cdata_end;
        size = cdata_end - cdata_src;

        for (size_t i = 0; i < size; i++) {
            tcdm_base[i] = cdata_src[i];
        }

        volatile uint8_t* cbss_start = (volatile uint8_t*)&__cbss_start;
        volatile uint8_t* cbss_end = (volatile uint8_t*)&__cbss_end;
        size_t cbss_size = cbss_end - cbss_start;

        volatile uint8_t* cbss_dst = tcdm_base + size;
        for (size_t i = 0; i < cbss_size; i++) {
            cbss_dst[i] = 0U;
        }
    }
}
#endif

#ifdef SNRT_INIT_LIBS
static inline void snrt_init_libs() { snrt_alloc_init(); }
#endif

#ifdef SNRT_CRT0_EXIT
static inline void snrt_exit_default(int exit_code) {
    exit_code = snrt_global_all_to_all_reduction(exit_code);
#ifdef OPENOCD_SEMIHOSTING
    if (snrt_global_core_idx() == 0) __ocd_semihost(0x18, (long)exit_code);
#else
    if (snrt_global_core_idx() == 0)
        *(snrt_exit_code_destination()) = (exit_code << 1) | 1;
#endif
}
#ifndef SNRT_CRT0_ALTERNATE_EXIT
static inline void snrt_exit(int exit_code) { snrt_exit_default(exit_code); }
#endif
#endif

void snrt_main() {
    int exit_code = 0;

#ifdef SNRT_CRT0_CALLBACK0
    snrt_crt0_callback0();
#endif

#ifdef SNRT_INIT_TLS
    snrt_init_tls();
#endif

#ifdef SNRT_CRT0_CALLBACK1
    snrt_crt0_callback1();
#endif

#ifdef SNRT_INIT_BSS
    snrt_init_bss();
#endif

#ifdef SNRT_CRT0_CALLBACK2
    snrt_crt0_callback2();
#endif

#ifdef SNRT_INIT_CLS
    snrt_init_cls();
#endif

#ifdef SNRT_CRT0_CALLBACK3
    snrt_crt0_callback3();
#endif

#ifdef SNRT_INIT_LIBS
    snrt_init_libs();
#endif

#ifdef SNRT_CRT0_CALLBACK4
    snrt_crt0_callback4();
#endif

#ifdef SNRT_CRT0_PRE_BARRIER
    snrt_cluster_hw_barrier();
#endif

#ifdef SNRT_CRT0_CALLBACK5
    snrt_crt0_callback5();
#endif

#ifdef SNRT_INVOKE_MAIN
    extern int main();
    exit_code = main();
#endif

#ifdef SNRT_CRT0_CALLBACK6
    snrt_crt0_callback6();
#endif

#ifdef SNRT_CRT0_POST_BARRIER
    snrt_cluster_hw_barrier();
#endif

#ifdef SNRT_CRT0_CALLBACK7
    snrt_crt0_callback7();
#endif

#ifdef SNRT_CRT0_EXIT
    snrt_exit(exit_code);
#endif

#ifdef SNRT_CRT0_CALLBACK8
    snrt_crt0_callback8();
#endif
}
