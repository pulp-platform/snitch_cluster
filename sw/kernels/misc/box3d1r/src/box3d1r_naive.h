// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Jayanth Jonnalagadda <jjonnalagadd@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

// Pure C implementation no ISA extensions

static inline void box3d1r_naive(int r, int nx, int ny, int nz, double* c,
                                 double* A, double* A_) {
    snrt_mcycle();
    for (int z = r; z < nz - r; z++) {
        for (int y = r; y < ny - r; y++) {
            for (int x = r; x < nx - r; x++) {
                double acc = 0.0;
                for (int dz = -r; dz <= r; dz++) {
                    for (int dy = -r; dy <= r; dy++) {
                        for (int dx = -r; dx <= r; dx++) {
                            acc += (c[((dz + r) * (2 * r + 1) * (2 * r + 1)) +
                                      ((dy + r) * (2 * r + 1)) + (dx + r)] *
                                    A[((z + dz) * ny * nx) + ((y + dy) * nx) +
                                      (x + dx)]);
                        }
                    }
                }
                A_[(z * ny * nx) + (y * nx) + x] = acc;
            }
        }
    }
    snrt_fpu_fence();
    snrt_mcycle();
}
