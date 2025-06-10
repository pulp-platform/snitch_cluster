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
#define NB_TRANSFERS 7

// Allocate a buffer in the main memory which we will use to copy data around
// with the DMA.
uint32_t buffer[MAX_BUFFER_SIZE];

typedef struct {
    unsigned int nb_bytes;
    unsigned int src_stride;
    unsigned int dst_stride;
    unsigned int num_reps_2d;
} TransferParameters;

TransferParameters transfer_params[] = {
    {3, 3, 7, 19},   {8, 9, 11, 15},     {16, 18, 17, 6},   {32, 36, 49, 8},
    {63, 79, 81, 2}, {123, 144, 185, 4}, {256, 100, 300, 2}};

int main() {
    if (snrt_global_core_idx() != 8) return 0;  // only DMA core
    uint32_t errors = 0;
    uint32_t nb_bytes, dst_stride, src_stride, reps_2d, src_offset_2d,
        dst_offset_2d;

    uint32_t buffer_src[MAX_BUFFER_SIZE];
    uint32_t buffer_dst[MAX_BUFFER_SIZE];

    uint8_t *src_ptr, *main_ptr, *dst_ptr;

    uint32_t src_start_addr, dst_start_addr, main_start_addr;

    main_start_addr = buffer;
    src_start_addr = buffer_src;
    dst_start_addr = buffer_dst;

    src_ptr = (uint8_t *)src_start_addr;
    main_ptr = (uint8_t *)main_start_addr;
    dst_ptr = (uint8_t *)dst_start_addr;

    snrt_dma_txid_t id;

    PRINTF("Main_start: %8x | Src_start: %8x | Dst_start: %8x \n",
           main_start_addr, src_start_addr, dst_start_addr);

    for (int k = 0; k < NB_TRANSFERS; k++) {
        errors +=
            transfer_params[k].nb_bytes * transfer_params[k].num_reps_2d * 2;
    }

    for (int k = 0; k < NB_TRANSFERS; k++) {
        PRINTF("Start transfer #%d \n", k);

        nb_bytes = transfer_params[k].nb_bytes;
        src_stride = transfer_params[k].src_stride;
        dst_stride = transfer_params[k].dst_stride;
        reps_2d = transfer_params[k].num_reps_2d;

        // Fill source buffer
        for (int q = 0; q < reps_2d; q++) {
            src_offset_2d = q * src_stride;
            for (int i = 0; i < nb_bytes; i++) {
                src_ptr[i + src_offset_2d] = (uint8_t)(i & 0xFF);
            }
        }
        // Fill main memory buffer
        for (int q = 0; q < reps_2d; q++) {
            src_offset_2d = q * src_stride;
            for (int i = 0; i < nb_bytes; i++) {
                main_ptr[i + src_offset_2d] = (uint8_t)((i + 1) & 0xFF);
            }
        }
        // Fill destination buffer
        for (int q = 0; q < reps_2d; q++) {
            dst_offset_2d = q * dst_stride;
            for (int i = 0; i < nb_bytes; i++) {
                dst_ptr[i + dst_offset_2d] = (uint8_t)((i + 2) & 0xFF);
            }
        }

        // Launch transfer source -> main memory
        id = snrt_dma_start_2d(main_start_addr, src_start_addr, nb_bytes,
                               src_stride, src_stride, reps_2d);
        snrt_dma_wait(id);

        // Check the results of source -> main memory

        for (unsigned int rep = 0; rep < reps_2d; rep++) {
            src_offset_2d = rep * src_stride;
            for (unsigned int i = 0; i < nb_bytes; i++) {
                uint8_t expected = src_ptr[src_offset_2d + i];
                uint8_t actual = main_ptr[src_offset_2d + i];

                if (expected != actual) {
                    PRINTF(
                        "ERROR: expected[%d] @%8x = %8x vs actual[%d] @%8x = "
                        "%8x \n",
                        src_offset_2d + i, &src_ptr[src_offset_2d + i],
                        expected, src_offset_2d + i,
                        &main_ptr[src_offset_2d + i], actual);
                } else {
                    errors--;
                }
            }
        }

        // Launch transfer main memory -> dst
        id = snrt_dma_start_2d(dst_start_addr, main_start_addr, nb_bytes,
                               dst_stride, src_stride, reps_2d);
        snrt_dma_wait(id);

        // Check the results of main memory -> dst

        for (unsigned int rep = 0; rep < reps_2d; rep++) {
            src_offset_2d = rep * src_stride;
            dst_offset_2d = rep * dst_stride;
            for (unsigned int i = 0; i < nb_bytes; i++) {
                uint8_t expected = main_ptr[src_offset_2d + i];
                uint8_t actual = dst_ptr[dst_offset_2d + i];

                if (expected != actual) {
                    PRINTF(
                        "ERROR: expected[%d] @%8x = %8x vs actual[%d] @%8x = "
                        "%8x \n",
                        src_offset_2d + i, &main_ptr[src_offset_2d + i],
                        expected, dst_offset_2d + i,
                        &dst_ptr[dst_offset_2d + i], actual);
                } else {
                    errors--;
                }
            }
        }
    }

    return errors;
}
