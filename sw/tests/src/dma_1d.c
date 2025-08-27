// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>

#ifdef DEBUG
#define PRINTF(...) printf(__VA_ARGS__)
#else
#define PRINTF(...)
#endif

#define MAX_BUFFER_SIZE 0x1000
#define NB_TRANSFERS 14

// Allocate a buffer in the main memory which we will use to copy data around
// with the DMA.
uint32_t buffer[MAX_BUFFER_SIZE];

typedef struct {
    unsigned int nb_bytes;
} TransferParameters;

TransferParameters transfer_params[] = {
    {1},  {2},   {3},   {4},   {8},    {16},   {32},
    {64}, {128}, {256}, {512}, {1024}, {2048}, {4096},
};

int main() {
    if (snrt_global_core_idx() != 8) return 0;  // only DMA core
    uint32_t errors = 0;
    uint32_t nb_bytes;

    uint32_t buffer_src[MAX_BUFFER_SIZE];
    uint32_t buffer_dst[MAX_BUFFER_SIZE];

    uint8_t *src_ptr, *main_ptr, *dst_ptr;

    uint32_t src_start_addr, dst_start_addr, main_start_addr;

    main_start_addr = (uintptr_t)buffer;
    src_start_addr = (uintptr_t)buffer_src;
    dst_start_addr = (uintptr_t)buffer_dst;

    src_ptr = (uint8_t *)src_start_addr;
    main_ptr = (uint8_t *)main_start_addr;
    dst_ptr = (uint8_t *)dst_start_addr;

    snrt_dma_txid_t id;

    PRINTF("Main_start: %8x | Src_start: %8x | Dst_start: %8x \n",
           main_start_addr, src_start_addr, dst_start_addr);

    for (int k = 0; k < NB_TRANSFERS; k++) {
        errors += transfer_params[k].nb_bytes * 2;
    }

    for (int k = 0; k < NB_TRANSFERS; k++) {
        PRINTF("Start transfer #%d \n", k);

        nb_bytes = transfer_params[k].nb_bytes;

        // Fill source buffer
        for (int i = 0; i < nb_bytes; i++) {
            src_ptr[i] = (uint8_t)(i & 0xFF);
        }

        // Fill main memory buffer
        for (int i = 0; i < nb_bytes; i++) {
            main_ptr[i] = (uint8_t)((i + 1) & 0xFF);
        }
        // Fill destination buffer
        for (int i = 0; i < nb_bytes; i++) {
            dst_ptr[i] = (uint8_t)((i + 2) & 0xFF);
        }

        // Launch transfer source -> main memory
        id = snrt_dma_start_1d(main_start_addr, src_start_addr, nb_bytes);
        snrt_dma_wait(id);

        // Check the results of source -> main memory

        for (unsigned int i = 0; i < nb_bytes; i++) {
            uint8_t expected = src_ptr[i];
            uint8_t actual = main_ptr[i];

            if (expected != actual) {
                PRINTF(
                    "ERROR: expected[%d] @%8x = %8x vs actual[%d] @%8x = %8x "
                    "\n",
                    i, &src_ptr[i], expected, i, &main_ptr[i], actual);
            } else {
                errors--;
            }
        }

        // Launch transfer main memory -> dst
        id = snrt_dma_start_1d(dst_start_addr, main_start_addr, nb_bytes);
        snrt_dma_wait(id);

        // Check the results of main memory -> dst
        for (unsigned int i = 0; i < nb_bytes; i++) {
            uint8_t expected = main_ptr[i];
            uint8_t actual = dst_ptr[i];

            if (expected != actual) {
                PRINTF(
                    "ERROR: expected[%d] @%8x = %8x vs actual[%d] @%8x = %8x "
                    "\n",
                    i, &main_ptr[i], expected, i, &dst_ptr[i], actual);
            } else {
                errors--;
            }
        }
    }

    return errors;
}
