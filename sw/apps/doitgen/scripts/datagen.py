#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np

import snitch.util.sim.data_utils as du

np.random.seed(42)

DOUBLE_BUFFER = True


class DoitgenDataGen(du.DataGen):

    # Function pointers to alternative implementations
    FUNCPTRS = ["doitgen_naive", "doitgen_baseline", "doitgen_opt"]

    def golden_model(self, A, x):
        R, Q, S = A.shape
        P, _ = x.shape
        Aout = np.ndarray((R, Q, P))
        for r in range(R):
            for q in range(Q):
                for p in range(P):
                    Aout[r, q, p] = 0
                    for s in range(S):
                        Aout[r, q, p] += A[r, q, s] * x[p, s]
        return Aout

    def validate(self, **kwargs):
        n_cores = 8
        assert (kwargs['r'] % kwargs['r_tiles']) == 0, "r must be an integer multiple of r_tiles"
        assert (kwargs['q'] % kwargs['q_tiles']) == 0, "q must be an integer multiple of q_tiles"
        if kwargs['funcptr'] != 'doitgen_naive':
            assert (kwargs['s'] % 4) == 0, "s must be an integer multiple of unrolling factor"
        r_per_tile = kwargs['r'] / kwargs['r_tiles']
        q_per_tile = kwargs['q'] / kwargs['q_tiles']
        assert (r_per_tile % n_cores) == 0, "r_per_tile must be an integer multiple of n_cores"
        assert kwargs['funcptr'] in self.FUNCPTRS, f"Function pointer must be among {self.FUNCPTRS}"

        # Calculate total TCDM occupation
        a_tile_size = r_per_tile * q_per_tile * kwargs['s'] * 8
        x_size = kwargs['s'] * kwargs['s'] * 8
        total_size = 2 * a_tile_size + x_size
        if DOUBLE_BUFFER:
            total_size *= 2
        du.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate(**kwargs)

        A = du.generate_random_array((kwargs['r'], kwargs['q'], kwargs['s']), seed=42)
        x = du.generate_random_array((kwargs['s'], kwargs['s']), seed=42)

        _ = self.golden_model(A, x)

        A = A.flatten()
        x = x.flatten()

        A_uid = 'A'
        x_uid = 'x'

        cfg = {
            'r': kwargs['r'],
            'q': kwargs['q'],
            's': kwargs['s'],
            'A': A_uid,
            'x': x_uid,
            'r_tiles': kwargs['r_tiles'],
            'q_tiles': kwargs['q_tiles'],
            'funcptr': kwargs['funcptr']
        }

        header += [du.format_array_definition('double', A_uid, A)]
        header += [du.format_array_definition('double', x_uid, x)]
        header += [du.format_struct_definition('doitgen_args_t', 'args', cfg)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    DoitgenDataGen().main()
