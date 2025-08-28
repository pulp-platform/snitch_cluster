#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from datagen import AxpyDataGen

from snitch.util.sim.verif_utils import Verifier


class AxpyVerifier(Verifier):

    OUTPUT_UIDS = ['z']

    def get_actual_results(self):
        return self.get_output_from_symbol('z', 'double')

    def get_expected_results(self):
        a = self.get_input_from_symbol('a', 'double')
        x = self.get_input_from_symbol('x', 'double')
        y = self.get_input_from_symbol('y', 'double')
        return AxpyDataGen().golden_model(a, x, y)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(AxpyVerifier().main())
