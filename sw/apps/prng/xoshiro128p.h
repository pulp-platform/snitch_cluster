// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Lannan Jiang <jiangl@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

typedef struct {
    uint32_t s[4];
} xoshiro128p_t;

xoshiro128p_t xoshiro128p_init(uint32_t seed) {
    // State initialization uses SplitMix64 generator as suggested by authors
    // https://prng.di.unimi.it/
    splitmix64_t sp64 = splitmix64_init(seed);

    // How SplitMix64 is used to initialize Xoshiro follows the Numba
    // implementation https://github.com/numba/numba/blob/
    // 5e626ba7d808dde8a9317ced8359c11f41b2cb6a/numba/cuda/random.py#L63-L69
    xoshiro128p_t xoshiro128p;
    for (int i = 0; i < 4; i++) xoshiro128p.s[i] = splitmix64_next(&sp64);
    return xoshiro128p;
}

void xoshiro128p_copy(xoshiro128p_t* target, xoshiro128p_t* source) {
    for (int i = 0; i < 4; i++) target->s[i] = source->s[i];
}

uint32_t xoshiro128p_next(xoshiro128p_t* xoshiro128p) {
    uint32_t* s = (uint32_t*)&(xoshiro128p->s);
    const uint32_t result = s[0] + s[3];

    const uint32_t t = s[1] << 9;

    s[2] ^= s[0];
    s[3] ^= s[1];
    s[1] ^= s[2];
    s[0] ^= s[3];

    s[2] ^= t;

    s[3] = (s[3] << 11) | (s[3] >> (32 - 11));

    return result;
}

/* This is the jump function for the generator. It is equivalent
   to 2^64 calls to next(); it can be used to generate 2^64
   non-overlapping subsequences for parallel computations. */
void xoshiro128p_jump(xoshiro128p_t* xoshiro128p) {
    static const uint32_t JUMP[] = {0x8764000b, 0xf542d2d3, 0x6fa035c3,
                                    0x77f2db5b};
    uint32_t* s = (uint32_t*)&(xoshiro128p->s);

    uint32_t s0 = 0;
    uint32_t s1 = 0;
    uint32_t s2 = 0;
    uint32_t s3 = 0;
    for (int i = 0; i < sizeof JUMP / sizeof *JUMP; i++)
        for (int b = 0; b < 32; b++) {
            if (JUMP[i] & UINT32_C(1) << b) {
                s0 ^= s[0];
                s1 ^= s[1];
                s2 ^= s[2];
                s3 ^= s[3];
            }
            xoshiro128p_next(xoshiro128p);
        }

    s[0] = s0;
    s[1] = s1;
    s[2] = s2;
    s[3] = s3;
}

void xoshiro128p_init_n(uint32_t seed, uint32_t n, xoshiro128p_t* xoshiro128p) {
    // Every sequence jumps 2^64 steps from the previous one.
    // See https://doi.org/10.1145/3460772 for details on subsequence overlap
    // probability.
    xoshiro128p[0] = xoshiro128p_init(seed);
    for (int i = 1; i < n; i++) {
        xoshiro128p_copy(xoshiro128p + i, xoshiro128p + i - 1);
        xoshiro128p_jump(xoshiro128p + i);
    }
}
