// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

//----------------------------------
// Author: Ryan Antonio (ryan.antonio@esat.kuleuven.be)
// Description:
// This test checks if a single Snitch core
// Can control multiple accelerators attached to it.
//
// Note that this test encodes the CSRs in a manual way
// because the write_csr and read_csr functions
// found in sw/deps/riscv-opcodes/encoding.h
// Do not allow variable inputs. The values need to be
// explicitly stated due to the # stringitized arguments
//----------------------------------

#include "snrt.h"

#include "data.h"
#include "mac.h"

int main() {
    // Set err value for checking
    int err = 0;

    uint32_t *local_a_acc_0, *local_b_acc_0, *local_o_acc_0;
    uint32_t *local_a_acc_1, *local_b_acc_1, *local_o_acc_1;
    uint32_t *local_a_acc_2, *local_b_acc_2, *local_o_acc_2;
    uint32_t *local_a_acc_3, *local_b_acc_3, *local_o_acc_3;

    uint32_t SLICE_LEN = VEC_LEN / ACC_NUM;

    // Calculate base addresses
    local_a_acc_0 = (uint32_t *)snrt_l1_next();
    local_b_acc_0 = local_a_acc_0 + VEC_LEN;
    local_o_acc_0 = local_b_acc_0 + VEC_LEN;

    local_a_acc_1 = local_a_acc_0 + SLICE_LEN;
    local_b_acc_1 = local_b_acc_0 + SLICE_LEN;
    local_o_acc_1 = local_o_acc_0 + SLICE_LEN;

    local_a_acc_2 = local_a_acc_0 + 2 * SLICE_LEN;
    local_b_acc_2 = local_b_acc_0 + 2 * SLICE_LEN;
    local_o_acc_2 = local_o_acc_0 + 2 * SLICE_LEN;

    local_a_acc_3 = local_a_acc_0 + 3 * SLICE_LEN;
    local_b_acc_3 = local_b_acc_0 + 3 * SLICE_LEN;
    local_o_acc_3 = local_o_acc_0 + 3 * SLICE_LEN;

    // Use data mover core to bring data from L3 to TCDM
    if (snrt_is_dm_core()) {
        size_t vector_size = VEC_LEN * sizeof(uint32_t);
        snrt_dma_start_1d(local_a_acc_0, A, vector_size);
        snrt_dma_start_1d(local_b_acc_0, B, vector_size);
    }

    // Wait for DMA transfer to finish
    snrt_cluster_hw_barrier();

    // Control all cores at this point
    if (snrt_is_compute_core()) {
        // Get start setup cycle
        uint32_t tic_setup_mcycle = snrt_mcycle();

        // We first set the 1st MAC accelerator's addresses
        write_csr(976, (uint32_t)local_a_acc_0);
        write_csr(977, (uint32_t)local_b_acc_0);
        write_csr(979, (uint32_t)local_o_acc_0);

        write_csr(980, 1);                 // Number of iterations
        write_csr(981, SLICE_LEN);         // Vector length
        write_csr(982, simple_mult_mode);  // Set simple multiplication

        // Set for 2nd addresses
        write_csr(1000, (uint32_t)local_a_acc_1);
        write_csr(1001, (uint32_t)local_b_acc_1);
        write_csr(1003, (uint32_t)local_o_acc_1);

        write_csr(1004, 1);                 // Number of iterations
        write_csr(1005, SLICE_LEN);         // Vector length
        write_csr(1006, simple_mult_mode);  // Set simple multiplication

        // Set for 3rd addresses
        write_csr(1024, (uint32_t)local_a_acc_2);
        write_csr(1025, (uint32_t)local_b_acc_2);
        write_csr(1027, (uint32_t)local_o_acc_2);

        write_csr(1028, 1);                 // Number of iterations
        write_csr(1029, SLICE_LEN);         // Vector length
        write_csr(1030, simple_mult_mode);  // Set simple multiplication

        // Set for 4th addresses
        write_csr(1048, (uint32_t)local_a_acc_3);
        write_csr(1049, (uint32_t)local_b_acc_3);
        write_csr(1051, (uint32_t)local_o_acc_3);

        write_csr(1052, 1);                 // Number of iterations
        write_csr(1053, SLICE_LEN);         // Vector length
        write_csr(1054, simple_mult_mode);  // Set simple multiplication

        // Get start setup cycle
        uint32_t toc_setup_mcycle = snrt_mcycle();

        // Start them all at once
        write_csr(960, 0);
        write_csr(984, 0);
        write_csr(1008, 0);
        write_csr(1032, 0);

        uint32_t toc_start_mcycle = snrt_mcycle();

        // Poll or read each accelerator's status
        while (read_csr(963) | read_csr(987) | read_csr(1011) |
               +read_csr(1035)) {
        };

        uint32_t toc_end_mcycle = snrt_mcycle();

        // Check values
        err = check_simple_mult(local_o_acc_0, OUT, VEC_LEN);
    }

    return err;
}
