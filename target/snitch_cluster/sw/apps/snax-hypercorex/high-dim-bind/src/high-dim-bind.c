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
#include "streamer_csr_addr_map.h"

int main() {
    // Set err value for checking
    int err = 0;

    //-------------------------------
    // First load the data to be processed
    //-------------------------------
    uint32_t *local_data_0, *local_data_1, *qhv_start;

    // Start from base address 0
    // This is where we will dump the first data
    local_data_0 = (uint32_t *)snrt_l1_next();

    // Next data is 16 addresses away
    // Or, the next 8 banks
    local_data_1 = local_data_0 + num_cut_in_wide_elem;

    // Output will be in the next 8 banks
    qhv_start = local_data_1 + num_cut_in_wide_elem;

    size_t chunk_size = num_cut_in_wide_elem * sizeof(uint32_t);
    size_t dst_stride = 4 * chunk_size;

    // First load the data accordingly
    if (snrt_is_dm_core()) {
        uint32_t start_dma_load = snrt_mcycle();
        // Load the data a list into the first 8 banks
        snrt_dma_start_2d(
            // Destination address, source address
            local_data_0, data_a_list,
            // Size per chunk
            chunk_size,
            // Destination stride, source stride
            dst_stride, chunk_size,
            // Number of times to do
            target_num_data);

        snrt_dma_start_2d(
            // Destination address, source address
            local_data_1, data_b_list,
            // Size per chunk
            chunk_size,
            // Destination stride, source stride
            dst_stride, chunk_size,
            // Number of times to do
            target_num_data);

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
        hypercorex_set_streamer_highdim_a(
            (uint32_t)local_data_0,  // Base pointer low
            0,                       // Base pointer high
            8,                       // Spatial stride
            target_num_data,         // Inner loop bound
            1,                       // Outer loop bound
            256,                     // Inner loop stride
            0                        // Outer loop stride
        );

        // Configure streamer for high dim B
        hypercorex_set_streamer_highdim_b(
            (uint32_t)local_data_1,  // Base pointer low
            0,                       // Base pointer high
            8,                       // Spatial stride
            target_num_data,         // Inner loop bound
            1,                       // Outer loop bound
            256,                     // Inner loop stride
            0                        // Outer loop stride
        );

        // Configure streamer for high dim QHV
        hypercorex_set_streamer_highdim_qhv(
            (uint32_t)qhv_start,  // Base pointer low
            0,                    // Base pointer high
            8,                    // Spatial stride
            target_num_data,      // Inner loop bound
            1,                    // Outer loop bound
            256,                  // Inner loop stride
            0                     // Outer loop stride
        );

        // Start the streamers
        hypercorex_start_streamer();

        //-------------------------------
        // Configuring the Hypercorex
        //-------------------------------

        // Load instructions for hypercorex
        hypercorex_load_inst(3, 0, high_dim_bind_code);

        // Enable loop mode to 2D
        csrw_ss(HYPERCOREX_INST_LOOP_CTRL_REG_ADDR, 0x00000001);

        // Set loop jump addresses
        hypercorex_set_inst_loop_jump_addr(0, 0, 0);

        // Set loop end addresses
        hypercorex_set_inst_loop_end_addr(2, 0, 0);

        // Set loop counts
        hypercorex_set_inst_loop_count(target_num_data, 0, 0);

        // Write control registers
        csrw_ss(HYPERCOREX_CORE_SET_REG_ADDR, 0x00000030);

        uint32_t core_config_end = snrt_mcycle();
        printf("Core config time: %d\n", core_config_end - core_config_start);

        uint32_t core_start = snrt_mcycle();
        // Start hypercorex
        csrw_ss(HYPERCOREX_CORE_SET_REG_ADDR, 0x00000031);

        // Poll the busy-state of Hypercorex
        // Check both the Hypercorex and Streamer
        while (csrr_ss(STREAMER_BUSY_CSR)) {
        };

        uint32_t core_end = snrt_mcycle();
        printf("Core run time: %d\n", core_end - core_start);

        //-------------------------------
        // Configuring the for Testing
        //-------------------------------

        // Check if prediction results are correct
        for (uint32_t i = 0; i < target_num_data; i++) {
            for (uint32_t j = 0; j < num_cut_in_wide_elem; j++) {
                if ((uint32_t) * (qhv_start + i * 64 + j) !=
                    golden_list_data[i * num_cut_in_wide_elem + j]) {
                    err = 1;
                };
            };
        };
    };

    // Synchronize cores
    snrt_cluster_hw_barrier();

    return err;
}
