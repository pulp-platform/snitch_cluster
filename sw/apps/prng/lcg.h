// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Fabio Cappellini <fcappellini@student.ethz.ch>
// Hakim Filali <hfilali@student.ee.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

// Numerical Recipes from the "quick and dirty generators" list, Chapter 7.1,
// Eq. 7.1.6 parameters from Knuth and H. W. Lewis
#define LCG_A 1664525
#define LCG_C 1013904223

typedef struct {
    uint32_t state;
    uint32_t A;
    uint32_t C;
} lcg_t;

lcg_t lcg_init_default(uint32_t seed) {
    lcg_t lcg = {.state = seed, .A = LCG_A, .C = LCG_C};
    return lcg;
}

lcg_t lcg_init(uint32_t seed, uint32_t A, uint32_t C) {
    lcg_t lcg = {.state = seed, .A = A, .C = C};
    return lcg;
}

uint32_t lcg_next(lcg_t* lcg) {
    lcg->state = lcg->state * lcg->A + lcg->C;
    return lcg->state;
}

void lcg_init_n(uint32_t seed, uint32_t A, uint32_t C, uint32_t n, lcg_t* lcg) {
    // Calculate Ap and Cp of leapfrog sequences
    // Ap = a^k
    // Cp = (a^(k-1) + a^(k-2) + ... + a^1 + a^0)*c
    uint32_t Ap = 1;
    uint32_t Cp = 0;
    for (unsigned int p = 0; p < n; p++) {
        Cp += Ap;
        Ap *= A;
    }
    Cp *= C;

    // Calculate seeds of leapfrog sequences
    lcg_t lcg0 = lcg_init(seed, A, C);
    for (unsigned int i = 0; i < n; i++) {
        lcg[i] = lcg_init(lcg_next(&lcg0), Ap, Cp);
    }
}

void lcg_init_n_default(uint32_t seed, uint32_t n, lcg_t* lcg) {
    lcg_init_n(seed, LCG_A, LCG_C, n, lcg);
}
