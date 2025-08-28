#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys

import snitch.util.sim.data_utils as du


np.random.seed(42)


class GemvDataGen(du.DataGen):

    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096

    def golden_model(self, alpha, a, x):
        return alpha * np.matmul(a, x).flatten()

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        m, n, alpha = kwargs['m'], kwargs['n'], kwargs['alpha']

        a = du.generate_random_array((m, n))
        x = du.generate_random_array((n, 1))
        y = self.golden_model(alpha, a, x)

        # Store matrix in transposed form if requested
        a = a.T if kwargs['trans'] else a

        a_uid = 'a'
        x_uid = 'x'
        y_uid = 'y'

        cfg = {
            **kwargs,
            'a': a_uid,
            'x': x_uid,
            'y': y_uid,
        }

        a = a.flatten()
        x = x.flatten()

        header += [du.format_array_declaration('extern double', a_uid, a.shape)]
        header += [du.format_array_declaration('extern double', x_uid, x.shape)]
        header += [du.format_array_declaration('double', y_uid, y.shape)]
        header += [du.format_struct_definition('gemv_args_t', 'args', cfg)]
        header += [du.format_array_definition('double', a_uid, a,
                                              section=kwargs['section'])]
        header += [du.format_array_definition('double', x_uid, x,
                                              section=kwargs['section'])]
        result_def = du.format_array_definition('double', 'result', y)
        header += [du.format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == "__main__":
    sys.exit(GemvDataGen().main())
