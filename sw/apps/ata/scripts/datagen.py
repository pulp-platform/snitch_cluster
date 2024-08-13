#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np

from snitch.util.sim import data_utils
from snitch.util.sim.data_utils import format_array_definition, format_array_declaration, \
    format_struct_definition, DataGen


DOUBLE_BUFFER = True

class AtaDataGen(DataGen):

    # Function pointers to alternative implementations
    FUNCPTRS = ["ata_baseline", "ata_opt"]

    def golden_model(self, A):
        return np.matmul(A, A.transpose())

    def validate(self, **kwargs):
        assert (kwargs['m'] % kwargs['m_tiles']) == 0, "m must be an integer multiple of m_tiles"
        m_frac = kwargs['m'] / kwargs['m_tiles']
        assert (m_frac % 8) == 0, "m_frac must be an integer multiple of the number of cores"
        assert (m_frac % 4) == 0, "m_frac must be an integer multiple of the unroll factor 4"
        assert kwargs['funcptr'] in self.FUNCPTRS, f"Function pointer must be among {self.FUNCPTRS}"

        # Calculate total TCDM occupation
        a_tile_size = m_frac * kwargs['n'] * 8
        b_tile_size = m_frac * m_frac * 8
        total_size = 2 * a_tile_size + b_tile_size
        if DOUBLE_BUFFER:
            total_size *= 2
        data_utils.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate(**kwargs)

        A = np.random.randint(-200, 100, size=(kwargs['m'], kwargs['n']))/100
        B = self.golden_model(A)

        A = A.flatten()
        B = B.flatten()

        A_uid = 'A'
        B_uid = 'B'

        cfg = {
            'm': kwargs['m'],
            'n': kwargs['n'],
            'a': A_uid,
            'b': B_uid,
            'm_tiles': kwargs['m_tiles'],
            'funcptr': kwargs['funcptr']
        }

        header += [format_array_definition('double', A_uid, A)]
        header += [format_array_declaration('double', B_uid, B.shape)]
        header += [format_struct_definition('ata_args_t', 'args', cfg)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    AtaDataGen().main()
