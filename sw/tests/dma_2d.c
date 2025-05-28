// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <snrt.h>


#define MAX_BUFFER_SIZE 0x1000
#define NB_TRANSFERS    4

// Allocate a buffer in the main memory which we will use to copy data around
// with the DMA.
uint32_t buffer[MAX_BUFFER_SIZE];

typedef struct {
  unsigned int nb_words;
  unsigned int src_stride;
  unsigned int dst_stride;
  unsigned int num_reps_2d;
} TransferParameters;

TransferParameters transfer_params[] = {
    {8, 9, 11, 15},
    {16, 18, 17, 6},
    {32, 36, 49, 8},
    {63, 79, 81, 2}
};



int main() {
    if (snrt_global_core_idx() != 8) return 0;  // only DMA core
    uint32_t errors = 0;
    uint32_t nb_words, dst_stride, src_stride, reps_2d;

    
    uint32_t buffer_src[MAX_BUFFER_SIZE], buffer_dst[MAX_BUFFER_SIZE];
    
    uint32_t src_offset_2d, dst_offset_2d;
    
    uint32_t main_start_addr, src_start_addr, dst_start_addr;
    
    main_start_addr = (int)&buffer;
    src_start_addr  = (int)&buffer_src;
    dst_start_addr  = (int)&buffer_dst;

    printf ("Main_start: %8x | Src_start: %8x | Dst_start: %8x \n", main_start_addr, src_start_addr, dst_start_addr);
    
    uint32_t *src_addr;
    uint32_t *dst_addr;
    uint32_t *main_addr;
    
    snrt_dma_txid_t id;

    for (int k = 0; k < NB_TRANSFERS; k++) {
        nb_words = transfer_params[k].nb_words;
        src_stride = transfer_params[k].src_stride * sizeof(uint32_t);
        dst_stride = transfer_params[k].dst_stride * sizeof(uint32_t);
        reps_2d = transfer_params[k].num_reps_2d;

        // Fill the source buffer
        for (int j = 0; j < reps_2d; j++) {
            src_offset_2d = j * src_stride;
            for (int i = 0; i < nb_words; i++) {
                src_addr = (uint32_t *)(src_start_addr + i * sizeof(uint32_t) + src_offset_2d);
                *src_addr = i+1;
            }
        }

        // Fill the main memory buffer

        for (int j = 0; j < reps_2d; j++) {
            src_offset_2d = j * src_stride;
            for (int i = 0; i < nb_words; i++) {
                main_addr = (uint32_t *)(main_start_addr + i * sizeof(uint32_t) + src_offset_2d);
                *main_addr = i*2;
                // printf ("Storing [%d] %8x @%8x \n", i * sizeof(uint32_t) + src_offset_2d, *main_addr, main_addr);
            }
        }

        // Fill the destination buffer

        for (int j = 0; j < reps_2d; j++) {
            dst_offset_2d = j * dst_stride;
            for (int i = 0; i < nb_words; i++) {
                dst_addr= (uint32_t *)(dst_start_addr + i * sizeof(uint32_t) + dst_offset_2d);
                *dst_addr= i*2;
                // printf ("Storing [%d] %8x @%8x \n", i * sizeof(uint32_t) + dst_offset_2d, *dst_addr, dst_addr);
            }
        }

        printf ("Start transfer %d from main to src \n", k);

        id = snrt_dma_start_2d(main_start_addr, src_start_addr, nb_words*sizeof(uint32_t), src_stride, src_stride, reps_2d);
        snrt_dma_wait(id);

        src_offset_2d = 0;
        for (int j = 0; j < reps_2d; j++) {
            src_offset_2d = j * src_stride;
            for (int i = 0; i < nb_words; i++) {
                src_addr = (uint32_t *)(src_start_addr + i * sizeof(uint32_t) + src_offset_2d);
                main_addr = (uint32_t *)(main_start_addr + i * sizeof(uint32_t) + src_offset_2d);

                if (*src_addr != *main_addr) {
                    errors ++;
                    printf("ERRORS ==> @%8x Dst[%d]: %d vs @%8x Src[%d]: %d \n", main_addr, i, *main_addr, src_addr, i, *src_addr);
                }
            }
        }

        printf ("Start transfer %d from src to dst \n", k);

        id = snrt_dma_start_2d(dst_start_addr, main_start_addr, nb_words*sizeof(uint32_t), dst_stride, src_stride, reps_2d);
        snrt_dma_wait(id);

        for (int j = 0; j < reps_2d; j++) {
            src_offset_2d = j * src_stride;
            dst_offset_2d = j * dst_stride;
            for (int i = 0; i < nb_words; i++) {
                main_addr   = (uint32_t *)(main_start_addr + i * sizeof(uint32_t) + src_offset_2d);
                dst_addr    = (uint32_t *)(dst_start_addr + i * sizeof(uint32_t) + dst_offset_2d);

                if (*main_addr != *dst_addr) {
                    errors ++;
                    printf("ERRORS ==> @%8x Dst[%d]: %d vs @%8x Src[%d]: %d \n", dst_addr, i * sizeof(uint32_t) + dst_offset_2d, *dst_addr, main_addr, i * sizeof(uint32_t) + src_offset_2d, *main_addr);
                }
            }
        }


    }

    return errors;
}




    // snrt_dma_txid_t id;

    // uint32_t errors = 0;
    // uint32_t dst_stride, src_stride, reps_2d;

    // dst_stride = 2 * sizeof(uint32_t);
    // src_stride = 2 * sizeof(uint32_t);
    // reps_2d = 5;

    // uint32_t buffer_src[MAX_BUFFER_SIZE], buffer_dst[MAX_BUFFER_SIZE];

    // uint8_t *src_ptr, *main_ptr, *dst_ptr;
    // int src_offset_2d, dst_offset_2d, main_offset_2d;
    // uint32_t main_start_addr, src_start_addr, dst_start_addr;

    // main_start_addr = (int)&buffer;
    // src_start_addr  = (int)&buffer_src;
    // dst_start_addr  = (int)&buffer_dst;

    // src_ptr = (uint8_t *)   src_start_addr;
    // main_ptr = (uint8_t *)  main_start_addr;
    // dst_ptr = (uint8_t *)   dst_start_addr;

    // src_offset_2d = 0;
    // for (int q = 0; q < reps_2d; q ++) {
    //     for (int i = 0; i < SIZE_1D; i++){
    //         src_ptr[i+src_offset_2d] = (uint8_t)(i & 0xFF);
    //     }
    //     src_offset_2d += src_stride;
    // }

    // main_offset_2d = 0;
    // for (int q = 0; q < reps_2d; q ++) {
    //     for (int i = 0; i < SIZE_1D; i++){
    //         main_ptr[i+main_offset_2d] = (uint8_t)((i+1) & 0xFF);
    //     }
    //     main_offset_2d += src_stride;
    // }

    // id = snrt_dma_start_2d(main_start_addr, src_start_addr, SIZE_1D, src_stride, src_stride, reps_2d);
    // snrt_dma_wait(id);

    // // Check the results
    
    // for (unsigned int rep = 0; rep < reps_2d; rep++) {
    //     unsigned int src_offset_2d = rep * src_stride;
    //     unsigned int main_offset_2d = rep * dst_stride;
    //     for (unsigned int i = 0; i < SIZE_1D; i++) {
    //         uint8_t expected = src_ptr[src_offset_2d + i];
    //         uint8_t actual = dst_ptr[main_offset_2d + i];

    //         if (expected != actual) {
    //             errors++;
    //             printf ("ERROR: expected[%d] @%8x = %8x vs actual[%d] @%8x = %8x \n", src_offset_2d + i, &src_ptr[src_offset_2d + i], expected, main_offset_2d+i, &dst_ptr[main_offset_2d + i], actual);
    //         }
    //     }
    // }