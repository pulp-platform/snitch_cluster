#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys
from datagen import GemvDataGen

from snitch.util.sim.verif_utils import Verifier


class GemvVerifier(Verifier):

    OUTPUT_UIDS = ['y']

    def __init__(self):
        super().__init__()
        self.func_args = {
            'alpha': 'd',
            'trans': 'I',
            'm': 'I',
            'n': 'I',
            'a': 'I',
            'x': 'I',
            'y': 'I'
        }
        self.func_args = self.get_input_from_symbol('args', self.func_args)

    def get_actual_results(self):
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], 'double')

    def get_expected_results(self):
        a = self.get_input_from_symbol('a', 'double')
        x = self.get_input_from_symbol('x', 'double')
        trans = self.func_args['trans']
        m = self.func_args['m']
        n = self.func_args['n']
        alpha = self.func_args['alpha']

        if trans:
            a = np.reshape(a, (n, m))
            a = a.transpose()
        else:
            a = np.reshape(a, (m, n))
        return GemvDataGen().golden_model(alpha, a, x)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-9)


if __name__ == "__main__":
    sys.exit(GemvVerifier().main())
