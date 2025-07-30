// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#ifdef __cplusplus
#define EXTERN_C extern "C"
#else
#define EXTERN_C
#endif

#ifdef SNRT_INIT_CLS
extern uint32_t snrt_cls_base_addr();
#endif

#ifdef SNRT_INIT_TLS
static inline void snrt_init_tls() {
    extern volatile uint32_t __tdata_start, __tdata_end;
    extern volatile uint32_t __tbss_start, __tbss_end;

    size_t size;
    volatile uint32_t tls_ptr;

    // To avoid contentions in main memory, and take advantage of the
    // bandwidth of the DMA, the DM core initializes the TLS section
    // for every core in a cluster.
    if (snrt_is_dm_core()) {
        size = (size_t)(&__tdata_end) - (size_t)(&__tdata_start);

        // First initialize the DM core's .tdata section from main memory
        asm volatile("mv %0, tp" : "=r"(tls_ptr) : :);
        snrt_dma_start_1d(tls_ptr, (uint64_t)&__tdata_start, size);
        snrt_dma_wait_all();

        // Then initialize all other cores' .tdata sections from the DM
        // core's. The offset between the TLS section of successive cores
        // is defined in start.S
        size_t tls_offset = (1 << SNRT_LOG2_STACK_SIZE) + 8;
        for (int i = 1; i < snrt_cluster_core_num(); i++) {
            snrt_dma_start_1d(tls_ptr + i * tls_offset, tls_ptr, size);
        }

        // Initialize all cores' .tbss sections
        tls_ptr += size;
        size = (size_t)(&__tbss_end) - (size_t)(&__tbss_start);
        for (int i = 0; i < snrt_cluster_core_num(); i++) {
            snrt_dma_memset((void*)(tls_ptr + i * tls_offset), 0, size);
        }
        snrt_dma_wait_all();
    }

    snrt_cluster_hw_barrier();
}
#endif

#ifdef SNRT_INIT_BSS
static inline void snrt_init_bss() {
    extern volatile uint32_t __bss_start, __bss_end;

    // Only one core needs to perform the initialization
    if (snrt_cluster_idx() == 0) {
        if (snrt_is_dm_core()) {
            size_t size = (size_t)(&__bss_end) - (size_t)(&__bss_start);
            snrt_dma_memset((void*)&__bss_start, 0, size);
            snrt_dma_wait_all();
        }
        snrt_cluster_hw_barrier();
    }
}
#endif

#ifdef SNRT_WAKE_UP
static inline void snrt_wake_up() {
    // Core 0 of cluster 0 wakes up all other cores
    if (snrt_cluster_idx() == 0 && snrt_cluster_core_idx() == 0) {
        // Do not use `snrt_wake_all` routine which requires
        // TLS to already be initialized.
        for (int i = 0; i < snrt_cluster_num(); i++) {
            if (snrt_cluster_idx() != i) {
                snrt_cluster(i)->peripheral_reg.cl_clint_set.f.cl_clint_set =
                    (1 << snrt_cluster_core_num()) - 1;
            }
        }
        snrt_fence();
    }

    // Synchronize all cores
    snrt_cluster_hw_barrier();

    // Clear the reset flag
    snrt_int_clr_mcip();
}
#endif

#ifdef SNRT_INIT_CLS
static inline void snrt_init_cls() {
    extern volatile uint32_t __cdata_start, __cdata_end;
    extern volatile uint32_t __cbss_start, __cbss_end;

    // Only one core per cluster has to do this
    if (snrt_is_dm_core()) {
        uint64_t ptr = (uint64_t)snrt_cls_base_addr();
        size_t size;

        // Copy cdata section to base of the TCDM
        size = (size_t)(&__cdata_end) - (size_t)(&__cdata_start);
        snrt_dma_start_1d(ptr, (uint64_t)(&__cdata_start), size);

        // Clear cbss section
        ptr += size;
        size = (size_t)(&__cbss_end) - (size_t)(&__cbss_start);
        snrt_dma_memset((void*)ptr, 0, size);
        snrt_dma_wait_all();
    }
    // Init the cls pointer
    _cls_ptr = (cls_t*)snrt_cls_base_addr();
    snrt_cluster_hw_barrier();
}
#endif

#ifdef SNRT_INIT_LIBS
static inline void snrt_init_libs() {
    snrt_alloc_init();
    snrt_l1_init();
    snrt_l3_init();
    snrt_comm_init();
}
#endif

#ifdef SNRT_CRT0_EXIT
extern void snrt_exit_default(int exit_code);
#ifndef SNRT_CRT0_ALTERNATE_EXIT
extern void snrt_exit(int exit_code);
#endif
#endif

// Referenced in an assembly file (start.S), must use C linkage
EXTERN_C void snrt_main() {
    int exit_code = 0;
    if (snrt_cluster_idx() == 0) {
        snrt_int_clr_mcip();
    }

#ifdef SNRT_CRT0_CALLBACK0
    snrt_crt0_callback0();
#endif

#ifdef SNRT_INIT_BSS
    snrt_init_bss();
#endif

#ifdef SNRT_WAKE_UP
    snrt_wake_up();
#endif

#ifdef SNRT_CRT0_CALLBACK1
    snrt_crt0_callback1();
#endif

#ifdef SNRT_INIT_TLS
    snrt_init_tls();
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
