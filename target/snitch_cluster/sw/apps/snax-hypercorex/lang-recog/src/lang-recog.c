// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Author: Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Program: Hypercorex Test CSRs
//
// This program is to test the language recognition program
//-------------------------------

#include "snrt.h"

#include "data.h"
#include "snax-hypercorex-lib.h"
#include "streamer_csr_addr_map.h"

int main() {
    // Set err value for checking
    int err = 0;

    //-------------------------------
    // First load the data to be processed
    //-------------------------------
    uint32_t num_predictions = 21;
    uint32_t num_features = 128;
    uint32_t num_classes = 21;

    uint32_t *am_start, *predict_start;
    uint64_t *data_start_1;

    // AM address starts from 0
    am_start = (uint64_t *)snrt_l1_next();

    // Next data is 16 32b addresses away
    data_start_1 = am_start + 8;

    // Output will be in the last 8 banks
    predict_start = am_start + 48;

    size_t src_stride = 16 * sizeof(uint32_t);
    size_t dst_stride = 4 * src_stride;

    // First load the data accordingly
    if (snrt_is_dm_core()) {
        uint32_t start_dma_load = snrt_mcycle();

        // Load the AM unto the 1st 8 banks
        snrt_dma_start_2d(
            // Destination address, source address
            am_start, am_list,
            // Size per chunk
            src_stride,
            // Destination stride, source stride
            dst_stride, src_stride,
            // Number of times to do
            num_classes);

        // Load the data a list into the 2nd 8 banks
        snrt_dma_start_2d(
            // Destination address, source address
            data_start_1, test_samples_list,
            // Size per chunk
            src_stride,
            // Destination stride, source stride
            dst_stride, src_stride,
            // Number of times to do
            336);

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
        //-------------------------------
        // Configuring the streamers
        //-------------------------------
        uint32_t core_config_start = snrt_mcycle();
        // Configure streamer for high dim A
        hypercorex_set_streamer_lowdim_a(
            (uint32_t)data_start_1,  // Base pointer low
            0,                       // Base pointer high
            1,                       // Spatial stride
            8,                       // Inner loop bound
            336,                     // Outer loop bound
            8,                       // Inner loop stride
            256                      // Outer loop stride
        );

        // Configure streamer for AM
        hypercorex_set_streamer_highdim_am(
            (uint32_t)am_start,  // Base pointer low
            0,                   // Base pointer high
            8,                   // Spatial stride
            num_classes,         // Inner loop bound
            num_predictions,     // Outer loop bound
            256,                 // Inner loop stride
            0                    // Outer loop stride
        );

        hypercorex_set_streamer_lowdim_predict(
            (uint32_t)predict_start,  // Base pointer low
            0,                        // Base pointer high
            1,                        // Spatial stride
            num_predictions,          // Inner loop bound
            1,                        // Outer loop bound
            256,                      // Inner loop stride
            0                         // Outer loop stride
        );

        // Start the streamers
        hypercorex_start_streamer();

        //-------------------------------
        // Configuring the Hypercorex
        //-------------------------------

        // Write number of classes to be checked
        csrw_ss(HYPERCOREX_AM_NUM_PREDICT_REG_ADDR, num_classes);

        // Load instructions for hypercorex
        hypercorex_load_inst(12, 0, code);

        // Enable loop mode to 2D
        csrw_ss(HYPERCOREX_INST_LOOP_CTRL_REG_ADDR, 0x00000002);

        // Encoding loops and jumps
        hypercorex_set_inst_loop_jump_addr(4, 0, 0);

        hypercorex_set_inst_loop_end_addr(8, 11, 0);

        // Reduced because of ngram counts
        hypercorex_set_inst_loop_count(125, num_predictions, 0);

        uint32_t core_config_end = snrt_mcycle();
        printf("Core config time: %d\n", core_config_end - core_config_start);

        uint32_t core_start = snrt_mcycle();

        // Start hypercorex
        csrw_ss(HYPERCOREX_CORE_SET_REG_ADDR, 0x00000001);

        // Poll the busy-state of Hypercorex
        // Check both the Hypercorex and Streamer
        while (csrr_ss(STREAMER_BUSY_CSR)) {
        };

        uint32_t core_end = snrt_mcycle();
        printf("Core run time: %d\n", core_end - core_start);

        //-------------------------------
        // Check results
        //-------------------------------
        for (uint32_t i = 0; i < num_predictions; i++) {
            if (golden_list_data[i] != (uint32_t) * (predict_start + i * 64)) {
                err++;
            }
        };
    };

    // Synchronize cores
    snrt_cluster_hw_barrier();

    return err;
}
