#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Nico Canzani <ncanzani@ethz.ch>
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import random
import numpy as np
import sys

import snitch.util.sim.data_utils as du


class SortDataGen(du.DataGen):
    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096

    def golden_model(self, x):
        return np.sort(x)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        n = kwargs['n']
        self.min = kwargs['min']
        self.max = kwargs['max']
        x = np.asarray([random.randrange(self.min, self.max + 1, 1) for i in range(n)])
        g = self.golden_model(x)

        assert (n % 8) == 0, "n must be an integer multiple of the number of cores (8)"

        header += [du.format_scalar_definition('const uint32_t', 'n', n)]
        header += [du.format_scalar_definition('const int32_t', 'min', self.min)]
        header += [du.format_scalar_definition('const int32_t', 'max', self.max)]
        header += [du.format_array_definition('int32_t', 'x', x, alignment=self.BURST_ALIGNMENT,
                                              section=kwargs['section'])]
        header += [du.format_array_declaration('int32_t', 'z', [n], alignment=self.BURST_ALIGNMENT,
                                               section=kwargs['section'])]
        result_def = du.format_array_definition('int32_t', 'g', g)
        header += [du.format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(SortDataGen().main())
