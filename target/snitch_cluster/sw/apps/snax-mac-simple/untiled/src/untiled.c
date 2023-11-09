// Copyright 2020 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include <stdint.h>
#include "data.h"
#include "mac.h"
#include "snrt.h"

int main() {
    uint32_t *local_a, *local_b;
    uint32_t *local_o;

    // Allocate space in TCDM
    local_a = (uint32_t *)snrt_l1_next();
    local_b = local_a + VEC_LEN;
    local_o = local_b + VEC_LEN;

    uint32_t cycles_pre = snrt_mcycle();
    // Use data mover core to bring data from L3 to TCDM
    if (snrt_is_dm_core()) {
        size_t vector_size = VEC_LEN * sizeof(uint32_t);
        snrt_dma_start_1d(local_a, A, vector_size);
        snrt_dma_start_1d(local_b, B, vector_size);
    }

    // Wait until DMA transfer is done
    snrt_cluster_hw_barrier();

    if (snrt_is_compute_core()) {
        snax_mac_setup_simple_mult(local_a, local_b, local_o, VEC_LEN);
        snax_mac_launch();
        snax_mac_sw_barrier();
    }

    // Wait until computation is done
    snrt_cluster_hw_barrier();

    // Technically we can already check the output here, but we still perform
    // the transfer to L3 to match the tiled example's flow.
    // Use data mover to send output from TCDM to L3
    if (snrt_is_dm_core()) {
        size_t vector_size = VEC_LEN * sizeof(uint32_t);
        snrt_dma_start_1d(OUT_TEST, local_o, vector_size);
    }
    snrt_cluster_hw_barrier();
    uint32_t cycles_post = snrt_mcycle();
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
