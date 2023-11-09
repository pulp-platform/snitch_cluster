// Copyright 2023 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Josse Van Delm <jvandelm@esat.kuleuven.be>

#include "mac.h"
#include <stdint.h>
#include "snrt.h"

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
