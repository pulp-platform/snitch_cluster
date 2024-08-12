#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys

from snitch.util.sim.data_utils import format_scalar_definition, format_array_definition, \
    format_array_declaration, format_ifdef_wrapper, format_struct_definition, DataGen


class AxpyDataGen(DataGen):

    MIN = -1000
    MAX = +1000
    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096
    # Function pointers to alternative implementations
    FUNCPTRS = ["axpy_naive", "axpy_fma", "axpy_opt"]

    def golden_model(self, a, x, y):
        return a*x + y

    def validate_config(self, **kwargs):
        assert kwargs['n'] % kwargs['n_tiles'] == 0, "n must be an integer multiple of n_tiles"
        n_per_tile = kwargs['n'] // kwargs['n_tiles']
        assert (n_per_tile % 8) == 0, "n must be an integer multiple of the number of cores"
        assert kwargs['funcptr'] in self.FUNCPTRS, f"Function pointer must be among {self.FUNCPTRS}"

        # Calculate total TCDM occupation
        # Note: doesn't account for double buffering
        vec_size = n_per_tile * 8
        total_size = 3 * vec_size
        data_utils.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate_config(**kwargs)

        a = np.random.uniform(self.MIN, self.MAX, 1)[0]
        x = np.random.uniform(self.MIN, self.MAX, kwargs['n'])
        y = np.random.uniform(self.MIN, self.MAX, kwargs['n'])
        g = self.golden_model(a, x, y)

        x_uid = 'x'
        y_uid = 'y'
        z_uid = 'z'

        cfg = {
            'n': kwargs['n'],
            'a': a,
            'x': x_uid,
            'y': y_uid,
            'z': z_uid,
            'n_tiles': kwargs['n_tiles'],
            'funcptr': kwargs['funcptr']
        }

        header += [format_scalar_definition('const double', 'a', a)]
        header += [format_array_definition('double', x_uid, x,
                   alignment=self.BURST_ALIGNMENT, section=kwargs['section'])]
        header += [format_array_definition('double', y_uid, y,
                   alignment=self.BURST_ALIGNMENT, section=kwargs['section'])]
        header += [format_array_declaration('double', z_uid, x.shape,
                   alignment=self.BURST_ALIGNMENT, section=kwargs['section'])]
        header += [format_struct_definition('axpy_args_t', 'args', cfg)]
        result_def = format_array_definition('double', 'g', g)
        header += [format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(AxpyDataGen().main())
