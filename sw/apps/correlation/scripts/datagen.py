#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Jose Pedro Castro Fonseca <jose.pc.fonseca@gmail, jcastro@ethz.ch>
#         Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np

import snitch.util.sim.data_utils as du


# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


class CorrelationDataGen(du.DataGen):

    def golden_model(self, data):
        return np.corrcoef(data, rowvar=False)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        M, N = kwargs['M'], kwargs['N']
        data = du.generate_random_array((N, M))
        corr = self.golden_model(data)

        data = data.flatten()
        corr = corr.flatten()

        header += [du.format_scalar_definition('uint32_t', 'M', M)]
        header += [du.format_scalar_definition('uint32_t', 'N', N)]
        header += [du.format_array_definition('double', 'data', data, alignment=BURST_ALIGNMENT)]
        header += [du.format_array_declaration('double', 'corr', corr.shape,
                                               alignment=BURST_ALIGNMENT)]
        result_def = du.format_array_definition('double', 'golden', corr,
                                                alignment=BURST_ALIGNMENT)
        header += [du.format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    CorrelationDataGen().main()
