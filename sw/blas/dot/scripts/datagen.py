#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import numpy as np
import sys

import snitch.util.sim.data_utils as du


class DotDataGen(du.DataGen):

    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096

    def golden_model(self, x, y):
        return np.dot(x, y)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        n = kwargs['n']
        x = du.generate_random_array(n)
        y = du.generate_random_array(n)
        g = self.golden_model(x, y)

        assert (n % (8 * 4)) == 0, "n must be an integer multiple of the number of cores times " \
                                   "the unrolling factor"

        header += [du.format_scalar_definition('const uint32_t', 'n', n)]
        header += [du.format_array_definition('double', 'x', x, alignment=self.BURST_ALIGNMENT,
                                              section=kwargs['section'])]
        header += [du.format_array_definition('double', 'y', y, alignment=self.BURST_ALIGNMENT,
                                              section=kwargs['section'])]
        header += [du.format_scalar_declaration('double', 'result', alignment=self.BURST_ALIGNMENT,
                                                section=kwargs['section'])]
        result_def = du.format_scalar_definition('double', 'g', g)
        header += [du.format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(DotDataGen().main())
