#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Jose Pedro Castro Fonseca <jose.pc.fonseca@gmail, jcastro@ethz.ch>
#         Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np

import snitch.util.sim.data_utils as du

np.random.seed(42)

DOUBLE_BUFFER = True


class CovarianceDataGen(du.DataGen):

    # Function pointers to alternative implementations
    FUNCPTRS = ["covariance_naive", "covariance_baseline", "covariance_opt"]

    def golden_model(self, data):
        return np.cov(data, rowvar=False)

    def validate(self, **kwargs):
        n_cores = 8
        assert (kwargs['m'] % kwargs['m_tiles']) == 0, "m must be an integer multiple of m_tiles"
        m_per_tile = kwargs['m'] / kwargs['m_tiles']
        assert (m_per_tile % n_cores) == 0, \
            "m_per_tile must be an integer multiple of the number of cores"
        assert (m_per_tile % 4) == 0, "m_per_tile must be an integer multiple of unroll1 = 4"
        m_per_core = m_per_tile / n_cores
        assert (m_per_core % 2) == 0, "m_per_core must be an integer multiple of the unroll0 = 2"
        assert kwargs['funcptr'] in self.FUNCPTRS, f"Function pointer must be among {self.FUNCPTRS}"

        # Calculate total TCDM occupation
        a_tile_size = m_per_tile * kwargs['n'] * 8
        b_tile_size = m_per_tile * m_per_tile * 8
        total_size = 2 * a_tile_size + b_tile_size
        if DOUBLE_BUFFER:
            total_size *= 2
        du.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate(**kwargs)

        data = du.generate_random_array((kwargs['n'], kwargs['m']))
        cov = self.golden_model(data)

        data = data.transpose().flatten()
        cov = cov.flatten()

        data_uid = 'data'
        cov_uid = 'cov'

        cfg = {
            'm': kwargs['m'],
            'n': kwargs['n'],
            'inv_n': 1 / kwargs['n'],
            'inv_n_m1': 1 / (kwargs['n'] - 1),
            'data': data_uid,
            'cov': cov_uid,
            'm_tiles': kwargs['m_tiles'],
            'funcptr': kwargs['funcptr']
        }

        header += [du.format_array_definition('double', data_uid, data)]
        header += [du.format_array_declaration('double', cov_uid, cov.shape)]
        header += [du.format_struct_definition('covariance_args_t', 'args', cfg)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    CovarianceDataGen().main()
