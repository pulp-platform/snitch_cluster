#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Jose Pedro Castro Fonseca <jcastro@ethz.ch>
#         Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np

import snitch.util.sim.data_utils as du


# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


class AtaxDataGen(du.DataGen):

    def golden_model(self, A, x):
        return np.matmul(A.transpose(), np.matmul(A, x))

    def validate(self, M, N, **kwargs):
        assert (N % 8) == 0, "N must be an integer multiple of the number of cores"

        # Calculate total TCDM occupation
        a_size = M * N * 8
        x_size = N * 8
        y_size = N * 8
        tmp_size = M * 8
        total_size = a_size
        total_size += x_size
        total_size += y_size
        total_size += tmp_size
        du.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        # Validate parameters
        self.validate(**kwargs)

        M, N = kwargs['M'], kwargs['N']
        A = du.generate_random_array((M, N))
        x = du.generate_random_array((N, 1))
        y = self.golden_model(A, x)

        A = A.flatten()
        x = x.flatten()
        y = y.flatten()

        header += [du.format_scalar_definition('uint32_t', 'M', M)]
        header += [du.format_scalar_definition('uint32_t', 'N', N)]
        header += [du.format_array_definition('double', 'A', A, alignment=BURST_ALIGNMENT)]
        header += [du.format_array_definition('double', 'x', x, alignment=BURST_ALIGNMENT)]
        header += [du.format_array_declaration('double', 'y', y.shape, alignment=BURST_ALIGNMENT)]
        result_def = du.format_array_definition('double', 'golden', y, alignment=BURST_ALIGNMENT)
        header += [du.format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    AtaxDataGen().main()
