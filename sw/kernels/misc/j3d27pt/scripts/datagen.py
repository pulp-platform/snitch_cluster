#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys

import snitch.util.sim.data_utils as du


class J3D27PTDataGen(du.DataGen):

    MIN = -1000
    MAX = +1000
    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096

    def golden_model(self, FAC, NZ, NY, NX, C, A):
        FAC = int(FAC)
        NX = int(NX)
        NY = int(NY)
        NZ = int(NZ)
        A_n = np.zeros(NZ*NY*NX)
        fact = 1.0 / FAC
        for z in range(1, NZ-1):
            for y in range(1, NY-1):
                for x in range(1, NX-1):
                    acc = 0.0
                    for dz in range(-1, 2):
                        for dy in range(-1, 2):
                            for dx in range(-1, 2):
                                acc += C[((dz+1)*3*3) + ((dy+1)*3) + (dx+1)] * \
                                       A[((z+dz)*NY*NX) + ((y+dy)*NX) + (x+dx)]
                    A_n[(z*NY*NX) + (y*NX) + x] = fact * acc
        return A_n

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        FAC = kwargs['FAC']
        NX = kwargs['NX']
        NY = kwargs['NY']
        NZ = kwargs['NZ']
        C = np.random.uniform(self.MIN, self.MAX, (3*3*3))
        A = np.random.uniform(self.MIN, self.MAX, (NZ*NY*NX))
        G = self.golden_model(FAC, NX, NY, NZ, C, A)

        # "extern" specifier ensures that the variable is emitted and not mangled
        header += [du.format_scalar_definition('extern const uint32_t', 'fac', FAC)]
        header += [du.format_scalar_definition('extern const uint32_t', 'nx', NX)]
        header += [du.format_scalar_definition('extern const uint32_t', 'ny', NY)]
        header += [du.format_scalar_definition('extern const uint32_t', 'nz', NZ)]
        header += [du.format_array_definition('double', 'c', C, alignment=self.BURST_ALIGNMENT,
                                              section=kwargs['section'])]
        header += [du.format_array_definition('double', 'A', A, alignment=self.BURST_ALIGNMENT,
                                              section=kwargs['section'])]
        header += [du.format_array_declaration('double', 'A_', [NZ*NY*NX],
                                               alignment=self.BURST_ALIGNMENT,
                                               section=kwargs['section'])]
        result_def = du.format_array_definition('double', 'G', G)
        header += [du.format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(J3D27PTDataGen().main())
