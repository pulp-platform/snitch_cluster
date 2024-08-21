// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//-------------------------------
// Author: Ryan Antonio <ryan.antonio@esat.kuleuven.be>
//
// Program: Hypercorex Test CSRs
//
// This program is to test the capabilities
// of the HyperCoreX accelerator's CSRs so the test is
// to check if registers are working as intended.
//
// This includes checking for RW, RO, and WO registers.
//-------------------------------

#include "snrt.h"

#include "data.h"
#include "snax-hypercorex-lib.h"

int main() {
    // Set err value for checking
    int err = 0;

    //-------------------------------
    // First load the data to be processed
    //-------------------------------
    uint64_t *local_data_0, *local_data_1;
    uint64_t *qhv_start;
    uint64_t *predict_start;

    // Start from base address
    local_data_0 = (uint64_t *)snrt_l1_next();

    // Move to next bank
    // Note that it's of pointer type uint64_t
    // so it knows it's the next address
    local_data_1 = local_data_0 + 1;

    // QHV start is 8 banks later
    qhv_start = local_data_0 + 8;

    // Prediction is the bank after the
    // 2nd bank of the input data
    predict_start = local_data_0 + 2;

    size_t num_elem_size = 35 * 13;
    size_t chunk_size = sizeof(uint64_t);

    if (snrt_is_dm_core()) {
        // Calculate total bytes to send
        // There are a total of 910 elements
        // So half of the data in 1 bank then
        // the other half on the other bank
        // This is because each bank only has
        // 512 word lines so we need to split
        // We decide to split evenly

        // Loading to first bank
        snrt_dma_start_2d(
            // Destination address, source address
            local_data_0, char_data,
            // Size per chunk
            chunk_size,
            // Destination stride, source stride
            32 * chunk_size, chunk_size,
            // Number of times to do
            num_elem_size);

        // Loading to 2nd bank
        snrt_dma_start_2d(
            // Destination address, source address
            local_data_1, (char_data + num_elem_size),
            // Size per chunk
            chunk_size,
            // Destination stride, source stride
            32 * chunk_size, chunk_size,
            // Number of times to do
            num_elem_size);

        // Ensure that all DMA tasks finish
        snrt_dma_wait_all();
    };

    // Synchronize cores
    snrt_cluster_hw_barrier();

    //-------------------------------
    // Set everything for the compute core
    //-------------------------------
    if (snrt_is_compute_core()) {
        //-------------------------------
        // Configuring system for training phase
        //-------------------------------

        //-------------------------------
        // Configuring the streamers
        //-------------------------------
        // Configure streamer lowdim streamer A
        hypercorex_set_streamer_lowdim_a(num_elem_size,  // Inner loop bound
                                         2,              // Outer loop bound
                                         256,            // Inner loop stride
                                         8,              // Outer loop stride
                                         1,              // Spatial stride
                                         (uint32_t)local_data_0  // Base address
        );

        hypercorex_set_streamer_highdim_qhv(num_classes,  // Inner loop bound
                                            1,            // Outer loop bound
                                            256,          // Inner loop stride
                                            0,            // Outer loop stride
                                            1,            // Spatial stride
                                            (uint32_t)qhv_start  // Base address
        );

        // Start the streamers
        hypercorex_start_streamer();

        //-------------------------------
        // Configuring the Hypercorex
        //-------------------------------
        // Load orthogonal IM seeds
        for (uint32_t i = 0; i < 8; i++) {
            hypercorex_set_im_base_seed(i, im_seed_list[i]);
        }

        // Load instructions for hypercorex
        hypercorex_load_inst(4, 0, train_inst_code);

        // Enable loop mode to 2D
        csrw_ss(HYPERCOREX_INST_LOOP_CTRL_REG_ADDR, 0x00000002);

        // Set loop jump addresses
        hypercorex_set_inst_loop_jump_addr(0, 0, 0);

        // Set loop end addresses
        hypercorex_set_inst_loop_end_addr(0, 3, 0);

        // Set loop counts
        hypercorex_set_inst_loop_count(num_features, 26, 0);

        // Start hypercorex
        csrw_ss(HYPERCOREX_CORE_SET_REG_ADDR, 1);

        // Poll the busy-state of Hypercorex
        // Check both the Hypercorex and Streamer
        while (csrr_ss(HYPERCOREX_CORE_SET_REG_ADDR) |
               csrr_ss(HYPERCORES_STREAMER_BUSY)) {
        };

        //-------------------------------
        // Configuring the for Testing
        //-------------------------------

        //-------------------------------
        // Configuring the streamers
        //-------------------------------

        // The settings for input streamer are
        // the same hence we do not need to process

        // Disable the QHV streamer by setting all to 0
        hypercorex_set_streamer_highdim_qhv(0,  // Inner loop bound
                                            0,  // Outer loop bound
                                            0,  // Inner loop stride
                                            0,  // Outer loop stride
                                            0,  // Spatial stride
                                            0   // Base address
        );

        // Enable the AM streamer
        // Note that it uses the output of the
        // where the QHV streamer data was stored
        // It needs to loop 26 times for all classes
        // and we also check all 26 classes at the same time
        hypercorex_set_streamer_highdim_am(num_classes,  // Inner loop bound
                                           num_classes,  // Outer loop bound
                                           256,          // Inner loop stride
                                           0,            // Outer loop stride
                                           1,            // Spatial stride
                                           (uint32_t)qhv_start  // Base address
        );

        // Enable the predict output streamer
        hypercorex_set_streamer_lowdim_predict(
            num_classes,             // Inner loop bound
            1,                       // Outer loop bound
            256,                     // Inner loop stride
            0,                       // Outer loop stride
            1,                       // Spatial stride
            (uint32_t)predict_start  // Base address
        );

        // Start the streamers
        hypercorex_start_streamer();

        //-------------------------------
        // Configuring the Hypercorex
        //-------------------------------
        // Load test instructions for hypercorex
        hypercorex_load_inst(4, 0, test_inst_code);

        // Set number of classes to be predicted
        // During AM search mode
        csrw_ss(HYPERCOREX_AM_NUM_PREDICT_REG_ADDR, num_classes);

        // Nothing else changes for the other
        // configurations hence we can start immediately

        // Start hypercorex
        csrw_ss(HYPERCOREX_CORE_SET_REG_ADDR, 1);

        // Poll the busy-state of Hypercorex
        // Check both the Hypercorex and Streamer
        while (csrr_ss(HYPERCOREX_CORE_SET_REG_ADDR) |
               csrr_ss(HYPERCORES_STREAMER_BUSY)) {
        };

        // Check if prediction results are correct
        for (uint64_t i = 0; i < num_classes; i++) {
            if (i != (uint32_t) * (predict_start + i * 32)) {
                err++;
            }
        };
    };

    // Synchronize cores
    snrt_cluster_hw_barrier();

    return err;
}
