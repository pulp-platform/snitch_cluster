// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Jayanth Jonnalagadda <jjonnalagadd@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

// Pure C implementation no ISA extensions

// The Kernel
static inline void j3d27pt_naive(int fac, int nx, int ny, int nz, double* c,
                                 double* A, double* A_) {
    snrt_mcycle();
    double fact = 1.0 / fac;
    for (int z = 1; z < nz - 1; z++) {
        for (int y = 1; y < ny - 1; y++) {
            for (int x = 1; x < nx - 1; x++) {
                double acc = 0.0;
                for (int dz = -1; dz <= 1; dz++) {
                    for (int dy = -1; dy <= 1; dy++) {
                        for (int dx = -1; dx <= 1; dx++) {
                            acc += (c[((dz + 1) * 3 * 3) + ((dy + 1) * 3) +
                                      (dx + 1)] *
                                    A[((z + dz) * ny * nx) + ((y + dy) * nx) +
                                      (x + dx)]);
                        }
                    }
                }
                A_[(z * ny * nx) + (y * nx) + x] = fact * acc;
            }
        }
    }
    snrt_fpu_fence();
    snrt_mcycle();
}