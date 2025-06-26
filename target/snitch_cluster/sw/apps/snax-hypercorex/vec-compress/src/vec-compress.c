// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Author: Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Program: Hypercorex Test AM Search
//
// This program is to test the Hypercorex's
// AM search on a continuous data stream.
//-------------------------------

#include "snrt.h"

#include "data.h"
#include "snax-hypercorex-lib.h"
#include "streamer_csr_addr_map.h"

int main() {
    // Set err value for checking
    int err = 0;

    uint32_t num_vectors = 5;
    uint32_t num_rows_per_512b = 64;
    uint32_t num_of_rows_for_vectors = num_vectors * num_rows_per_512b;

    uint32_t num_bits_per_row = 8;
    uint32_t num_rows_for_64b = 8;
    uint32_t num_iter_for_512b = 8;

    //-------------------------------
    // First load the data to be processed
    //-------------------------------
    uint64_t *vec_data_start;
    uint32_t *hv_data_start;

    // Start from base address 0
    // This is where we will dump the first data
    vec_data_start = (uint64_t *)snrt_l1_next();

    // Next data is 16 addresses away
    // Or, the next 8 banks
    hv_data_start = (uint32_t *)snrt_l1_next() + 16;

    size_t src_stride = 8 * sizeof(uint64_t);
    size_t dst_stride = 4 * src_stride;

    // First load the data accordingly
    if (snrt_is_dm_core()) {
        uint32_t start_dma_load = snrt_mcycle();
        // Load the data a list into the 2nd 8 banks
        snrt_dma_start_2d(
            // Destination address, source address
            vec_data_start, vec_list,
            // Size per chunk
            src_stride,
            // Destination stride, source stride
            dst_stride, src_stride,
            // Number of times to do
            num_of_rows_for_vectors);

        // Ensure that all DMA tasks finish
        snrt_dma_wait_all();
        uint32_t end_dma_load = snrt_mcycle();
        printf("DMA load time: %d\n", end_dma_load - start_dma_load);
    };
    // Synchronize cores
    snrt_cluster_hw_barrier();

    //-------------------------------
    // Set everything for the compute core
    //-------------------------------
    if (snrt_is_compute_core()) {
        uint32_t sub32b;
        uint8_t sub8b;
        uint32_t sub32b_target_addr;

        uint32_t src_base_addr;
        uint32_t dst_base_addr;

        src_base_addr = 0;
        dst_base_addr = 0;

        uint32_t core_start = snrt_mcycle();

        // Iterate through different hv counts
        for (uint32_t iter = 0; iter < num_vectors; iter++) {
            sub32b_target_addr = 15;
            // Iterate through different sub32 HVs counts
            for (uint32_t sub32_hv_count = 0; sub32_hv_count < 2048;
                 sub32_hv_count += 128) {
                sub32b = 0;
                // Iterate through each byte
                for (uint32_t byte_count = 0; byte_count < 128;
                     byte_count += 32) {
                    sub8b = 0;
                    // Iterate through each bit
                    for (uint32_t bit_count = 0; bit_count < 8; bit_count++) {
                        if ((int32_t) *
                                (vec_data_start + src_base_addr +
                                 sub32_hv_count + byte_count + bit_count) >=
                            0) {
                            sub8b = (sub8b << 1) | 0x01;
                        } else {
                            sub8b = sub8b << 1;
                        }
                    }
                    sub32b = (sub32b << 8) | sub8b;
                }

                // Store to correct location
                *(hv_data_start + dst_base_addr + sub32b_target_addr) = sub32b;
                sub32b_target_addr--;
            }
            // Increment base adddresses
            // This is used more than *
            src_base_addr += 2048;
            dst_base_addr += 16;
        }

        uint32_t core_end = snrt_mcycle();
        printf("Core run time: %d\n", core_end - core_start);

        // Checking of results
        uint32_t src_counter = 0;
        for (uint32_t i = 0; i < num_vectors; i++) {
            for (uint32_t j = 0; j < 16; j++) {
                if (binarized_vec_list[src_counter] !=
                    (int32_t) * (hv_data_start + i * 16 + j)) {
                    err++;
                }
                src_counter++;
            }
        }
    };

    // Synchronize cores
    snrt_cluster_hw_barrier();

    return err;
}
