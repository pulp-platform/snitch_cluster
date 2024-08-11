#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from datagen import TransposeDataGen

from snitch.util.sim.verif_utils import Verifier
from snitch.util.sim.data_utils import ctype_from_precision_t


class TransposeVerifier(Verifier):

    OUTPUT_UIDS = ['output']

    def __init__(self):
        super().__init__()
        self.layer_struct = {
            'M': 'I',
            'N': 'I',
            'input_ptr': 'I',
            'output_ptr': 'I',
            'dtype': 'I',
            'baseline': 'I'
        }
        self.layer = self.get_input_from_symbol('layer', self.layer_struct)
        self.M = self.layer['M']
        self.N = self.layer['N']
        self.prec = self.layer['dtype']

    def get_actual_results(self):
        return self.get_output_from_symbol('output', ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        inp = self.get_input_from_symbol('input', ctype_from_precision_t(self.prec))
        inp = inp.reshape(self.M, self.N)
        return TransposeDataGen().golden_model(inp)

    def check_results(self, *args):
        return super().check_results(*args, atol=0)


if __name__ == "__main__":
    sys.exit(TransposeVerifier().main())
