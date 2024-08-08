#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys
from datagen import AtaxDataGen

from snitch.util.sim.verif_utils import Verifier


class AtaxVerifier(Verifier):

    OUTPUT_UIDS = ['y']

    def get_actual_results(self):
        return self.get_output_from_symbol('y', 'double')

    def get_expected_results(self):
        A = self.get_input_from_symbol('A', 'double')
        x = self.get_input_from_symbol('x', 'double')
        M = self.get_input_from_symbol('M', 'uint32_t')[0]
        N = self.get_input_from_symbol('N', 'uint32_t')[0]
        A = np.reshape(A, (M, N))
        return AtaxDataGen().golden_model(A, x).flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(AtaxVerifier().main())
