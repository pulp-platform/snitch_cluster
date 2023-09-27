// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Fabio Cappellini <fcappellini@student.ethz.ch>
// Hakim Filali <hfilali@student.ee.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

#include "snrt.h"

// Numerical Recipes from the "quick and dirty generators" list, Chapter 7.1,
// Eq. 7.1.6 parameters from Knuth and H. W. Lewis
#define MAX_UINT_PLUS1 4294967296.0
#define LCG_A 1664525
#define LCG_C 1013904223

__thread double max_uint_plus_1_inverse = (double)1.0 / (double)MAX_UINT_PLUS1;

// Calculate A' and C' constants
inline void leapfrog_constants(unsigned int num_sequences, uint32_t a,
                               uint32_t c, uint32_t* Ap, uint32_t* Cp) {
    // Ap = a^k
    // Cp = (a^(k-1) + a^(k-2) + ... + a^1 + a^0)*c
    uint32_t Ap_tmp = 1;
    uint32_t Cp_tmp = 0;
    for (unsigned int p = 0; p < num_sequences; p++) {
        Cp_tmp += Ap_tmp;
        Ap_tmp *= a;
    }
    Cp_tmp *= c;

    // Store temporary variables to outputs
    *Ap = Ap_tmp;
    *Cp = Cp_tmp;
}

// Calculate seed for leapfrog method's right sequence of index `sequence_idx`
inline uint32_t right_seed(uint32_t left_seed, uint32_t a, uint32_t c,
                           unsigned int sequence_idx) {
    uint32_t seed = left_seed;
    for (unsigned int p = 1; p <= sequence_idx; p++) {
        seed = seed * a + c;
    }
    return seed;
}

// Generate next PRN from LCG recurrence equation
inline uint32_t lcg(uint32_t a, uint32_t c, uint32_t previous) {
    return previous * a + c;
}

// Normalize LCG PRN to [0, 1) range
inline double normalize(uint32_t x) {
    return (double)x * max_uint_plus_1_inverse;
}

inline void init_2d_lcg_params(unsigned int num_sequences, uint32_t seed,
                               uint32_t a, uint32_t c, uint32_t* seed0,
                               uint32_t* seed1, uint32_t* Ap, uint32_t* Cp) {
    *seed0 = right_seed(seed, a, c, 2 * snrt_global_compute_core_idx());
    *seed1 = right_seed(seed, a, c, 2 * snrt_global_compute_core_idx() + 1);
    leapfrog_constants(num_sequences, a, c, Ap, Cp);
}
