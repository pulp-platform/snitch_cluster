// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Lannan Jiang <jiangl@student.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

typedef struct {
    uint64_t state;
} splitmix64_t;

splitmix64_t splitmix64_init(uint64_t seed) {
    splitmix64_t sp64 = {.state = seed};
    return sp64;
}

uint64_t splitmix64_next(splitmix64_t* sp64) {
    uint64_t z = (sp64->state += 0x9e3779b97f4a7c15);
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9;
    z = (z ^ (z >> 27)) * 0x94d049bb133111eb;
    return z ^ (z >> 31);
}
