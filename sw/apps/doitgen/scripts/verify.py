#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys
from datagen import DoitgenDataGen

from snitch.util.sim.verif_utils import Verifier


class DoitgenVerifier(Verifier):

    OUTPUT_UIDS = ['A']

    def __init__(self):
        super().__init__()
        self.func_args = {
            'r': 'I',
            'q': 'I',
            's': 'I',
            'A': 'I',
            'x': 'I',
            'r_tiles': 'I',
            'q_tiles': 'I',
            'funcptr': 'I'
        }
        self.func_args = self.get_input_from_symbol('args', self.func_args)

    def get_actual_results(self):
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], 'double')

    def get_expected_results(self):
        A = self.get_input_from_symbol('A', 'double')
        A = np.reshape(A, (self.func_args['r'], self.func_args['q'], self.func_args['s']))
        x = self.get_input_from_symbol('x', 'double')
        x = np.reshape(x, (self.func_args['s'], self.func_args['s']))
        return DoitgenDataGen().golden_model(A, x).flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(DoitgenVerifier().main())
