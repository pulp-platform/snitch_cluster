#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Nico Canzani <ncanzani@ethz.ch>
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import random
import numpy as np
import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
from data_utils import format_scalar_definition, format_array_definition, \
                       format_array_declaration, format_ifdef_wrapper, DataGen  # noqa: E402


class IntsortDataGen(DataGen):
    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096

    def golden_model(self, x):
        return np.sort(x)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        n = kwargs['n']
        self.MIN = kwargs['min']
        self.MAX = kwargs['max']
        syntetic_data = kwargs['syntetic']
        if syntetic_data:
            if len(range(self.MIN, self.MAX + 1)) == n:
                print(f'Creating syntetic data')
                x = np.arange(-n//2, n//2)
                np.random.shuffle(x)
            else:
                print(f'Parameter Problem: n is set to {n}, min to max generates {len(range(self.MIN, self.MAX + 1))} numbers.\nExit Generator\n')
                sys.exit()
        else:
            x = np.asarray([random.randrange(self.MIN, self.MAX + 1, 1) for i in range(n)])
        g = self.golden_model(x)

        assert (n % 8) == 0, "n must be an integer multiple of the number of cores (8)"

        header += [format_scalar_definition('const uint32_t', 'n', n)]
        header += [format_scalar_definition('const int32_t', 'min', self.MIN)]
        header += [format_scalar_definition('const int32_t', 'max', self.MAX)]
        header += [format_array_definition('int32_t', 'x', x, alignment=self.BURST_ALIGNMENT,
                                           section=kwargs['section'])]
        header += [format_array_declaration('int32_t', 'z', [n], alignment=self.BURST_ALIGNMENT,
                                            section=kwargs['section'])]
        result_def = format_array_definition('int32_t', 'g', g)
        header += [format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(IntsortDataGen().main())
