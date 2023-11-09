// Copyright 2023 KU Leuven
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Josse Van Delm <jvandelm@esat.kuleuven.be>
// Ryan Antonio <rgantonio@esat.kuleuven.be>

#include <stdint.h>
#include "data.h"
#include "mac.h"
#include "snrt.h"

int main() {
    uint32_t *local_a, *local_b;
    uint32_t* local_o;

    // Allocate space in TCDM
    local_a = (uint32_t*)snrt_l1_next();
    local_b = local_a + VEC_LEN;
    local_o = local_b + VEC_LEN;

    uint32_t tile_size = TILE_SIZE;
    // Warning: Manually make sure this is an integer number!
    uint32_t iterations = VEC_LEN / tile_size;
    size_t transfer_size = tile_size * sizeof(uint32_t);
    // Main tiling loop
    // I:
    // | (0) | (1) | (2) | (3) | (4) | (5) |
    // Phase:
    // |in---| cal |--out|
    //       |in---| cal |  out|
    //             |in---| cal |--out|
    //                   |in---| cal |--out|
    //
    // Note:"in" and "out" can technically not execute at the same time,
    // so they are "waiting" for each other to release the DMA.
    //
    // Add + 2 to iterations for end of pipeline
    uint32_t cycles_pre_loop = snrt_mcycle();
    for (uint32_t i = 0; i < iterations + 2; i++) {
        // Load in data: not in last two iterations
        if (snrt_is_dm_core() && i < iterations) {
            // Use data mover core to bring data from L3 to TCDM
            snrt_dma_start_1d(local_a + i * tile_size, A + i * tile_size,
                              transfer_size);
            snrt_dma_start_1d(local_b + i * tile_size, B + i * tile_size,
                              transfer_size);
        }
        // Calculate a tile: not in first iteration, not in last iteration
        if (snrt_is_compute_core() && i > 0 && i < iterations + 1) {
            snax_mac_setup_simple_mult(
                local_a + (i - 1) * tile_size, local_b + (i - 1) * tile_size,
                local_o + (i - 1) * tile_size, tile_size);
            snax_mac_launch();
            snax_mac_sw_barrier();
        }
        // Load out data: not in first two iterations
        if (snrt_is_dm_core() && i > 1) {
            // Use data mover core to bring data from TCDM to L3
            snrt_dma_start_1d(OUT_TEST + (i - 2) * tile_size,
                              local_o + (i - 2) * tile_size, transfer_size);
        }
        // Wait until DMA transfers are done
        snrt_cluster_hw_barrier();
    }
    uint32_t cycles_post_loop = snrt_mcycle();
    // Move tiled output data from L3 back to TCDM to check for correctness
    if (snrt_is_dm_core()) {
        size_t vector_size = VEC_LEN * sizeof(uint32_t);
        snrt_dma_start_1d(local_o, OUT_TEST, vector_size);
    }
    // Wait until DMA transfer is done
    snrt_cluster_hw_barrier();

    // Perform correctness check
    int err = 0;
    if (snrt_is_compute_core()) {
        // Also perform calculation on CPU
        uint32_t cpu_output[VEC_LEN];
        cpu_simple_mult(local_a, local_b, cpu_output, VEC_LEN);
        // Compare SNAX result with golden model
        err = check_simple_mult(local_o, OUT, VEC_LEN);
        // Compare CPU result with golden model
        err += check_simple_mult(cpu_output, OUT, VEC_LEN);
    };
    return err;
}
