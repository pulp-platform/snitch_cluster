#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np

import snitch.util.sim.data_utils as du


DOUBLE_BUFFER = True


class SyrkDataGen(du.DataGen):

    # Function pointers to alternative implementations
    FUNCPTRS = ["syrk_naive", "syrk_baseline", "syrk_opt"]

    def golden_model(self, alpha, A, beta, C):
        return alpha * np.matmul(A, A.transpose()) + beta * C

    def validate(self, **kwargs):
        n_cores = 8
        assert (kwargs['m'] % kwargs['m_tiles']) == 0, "m must be an integer multiple of m_tiles"
        m_frac = kwargs['m'] / kwargs['m_tiles']
        assert (m_frac % n_cores) == 0, "m_frac must be an integer multiple of the number of cores"
        if kwargs['funcptr'] != "syrk_naive":
            assert (m_frac % 4) == 0, "m_frac must be an integer multiple of the unroll factor 4"
        assert kwargs['funcptr'] in self.FUNCPTRS, f"Function pointer must be among {self.FUNCPTRS}"

        # Calculate total TCDM occupation
        a_tile_size = m_frac * kwargs['n'] * 8
        c_tile_size = m_frac * m_frac * 8
        total_size = 2 * a_tile_size + c_tile_size
        if DOUBLE_BUFFER:
            total_size *= 2
        du.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate(**kwargs)

        if 'alpha' in kwargs:
            alpha = kwargs['alpha']
        else:
            alpha = du.generate_random_array(1)[0]
        if 'beta' in kwargs:
            beta = kwargs['beta']
        else:
            beta = du.generate_random_array(1)[0]

        A = du.generate_random_array((kwargs['m'], kwargs['n']))
        C_in = du.generate_random_array((kwargs['m'], kwargs['m']))

        A = A.flatten()
        C_in = C_in.flatten()

        A_uid = 'A'
        C_uid = 'C'

        cfg = {
            'm': kwargs['m'],
            'n': kwargs['n'],
            'alpha': alpha,
            'beta': beta,
            'a': A_uid,
            'c': C_uid,
            'm_tiles': kwargs['m_tiles'],
            'funcptr': kwargs['funcptr']
        }

        header += [du.format_array_definition('double', A_uid, A)]
        header += [du.format_array_definition('double', C_uid, C_in)]
        header += [du.format_struct_definition('syrk_args_t', 'args', cfg)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    SyrkDataGen().main()
