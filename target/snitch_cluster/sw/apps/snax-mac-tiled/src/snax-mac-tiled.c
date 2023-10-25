// Copyright 2023 KU Leuven
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Josse Van Delm <jvandelm@esat.kuleuven.be>
// Ryan Antonio <rgantonio@esat.kuleuven.be>

#include "snrt.h"

#include "data.h"

// * mac_mode = 0
//   performs multiply-accumulate over elements to perform dot product
// * simple_mult_mode = 1
//   performs simple elementwise multiplication
enum mode { mac_mode, simple_mult_mode };

void snax_mac_launch() {
    // Write start CSR to launch accelerator
    write_csr(0x3c0, 0);
}

void snax_mac_sw_clear() {
    // write 0x3c5 to clear HWPE accelerator
    // Otherwise the accelerator goes into undefined behaviour:
    // It might stall/continue indefinitely
    write_csr(0x3c5, 0);
    asm volatile("nop\n");
    asm volatile("nop\n");
    asm volatile("nop\n");
}

void snax_mac_sw_barrier() {
    // poll csr 0x3c3 until HWPE MAC accelerator is finished
    while (read_csr(0x3c3)) {
    };
    // This is necessary for the HWPE MAC accelerator to allow multiple runs
    snax_mac_sw_clear();
}

void snax_mac_setup_simple_mult(uint32_t* a, uint32_t* b, uint32_t* o,
                                uint32_t vector_length) {
    /* Setup the hwpe_mac accelerator in simple_mult mode.
     * This computes the product A*B in 32 bits and stores it starting
     * from the pointer given by o
     * args:
     *  a: pointer in TCDM (L1) to vector A
     *  b: pointer in TCDM (L1) to vector B
     *  o: pointer in TCDM (L1) to where output O must be stored
     *  vector_length: length of A,B and O
     * */

    // Set addresses
    write_csr(0x3d0, (uint32_t)a);
    write_csr(0x3d1, (uint32_t)b);
    write_csr(0x3d3, (uint32_t)o);

    // Set configs
    write_csr(0x3d4, 1);                 // Number of iterations
    write_csr(0x3d5, vector_length);     // Vector length
    write_csr(0x3d6, simple_mult_mode);  // Set simple multiplication
}

void cpu_simple_mult(uint32_t* a, uint32_t* b, uint32_t* o,
                     uint32_t vector_length) {
    for (uint32_t i = 0; i < vector_length; i++) {
        o[i] = a[i] * b[i];
    };
}

int check_simple_mult(uint32_t* output, uint32_t* output_golden,
                      uint32_t vector_length) {
    /*
     * Compare output to output_golden with length vector_length
     */
    uint32_t err = 0;
    for (uint32_t i = 0; i < vector_length; i++) {
        // Check if output is same as golden output
        if (output[i] != output_golden[i]) {
            err++;
        };
    };
    return err;
}

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
        err = check_simple_mult(local_o, OUT, VEC_LEN);
        // Compute using CPU multiplier and check
        uint32_t cpu_output[VEC_LEN];
        cpu_simple_mult(local_a, local_b, cpu_output, VEC_LEN);
        // Compare CPU result with golden model
        err += check_simple_mult(cpu_output, OUT, VEC_LEN);
    };
    return err;
}
