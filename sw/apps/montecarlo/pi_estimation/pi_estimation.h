// Copyright 2023 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Fabio Cappellini <fcappellini@student.ethz.ch>
// Hakim Filali <hfilali@student.ee.ethz.ch>
// Luca Colagrande <colluca@iis.ee.ethz.ch>

__thread double one = 1.0;

inline uint32_t calculate_partial_sum(uint32_t seed0, uint32_t seed1,
                                      uint32_t Ap, uint32_t Cp,
                                      unsigned int n_samples) {
    uint32_t x1 = seed0;
    uint32_t x2 = seed1;
    double u1, u2;
    unsigned int result = 0;

    for (unsigned int i = 0; i < n_samples; i++) {
        u1 = normalize(x1);
        u2 = normalize(x2);
        x1 = lcg(Ap, Cp, x1);
        x2 = lcg(Ap, Cp, x2);

        if ((u1 * u1 + u2 * u2) < one) {
            result++;
        }
    }
    return result;
}

inline double estimate_pi(uint32_t sum, uint32_t n_samples) {
    return (double)(4 * sum) / (double)n_samples;
}
