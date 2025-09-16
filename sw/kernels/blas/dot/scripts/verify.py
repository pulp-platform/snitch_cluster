#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
from datagen import DotDataGen

from snitch.util.sim.verif_utils import Verifier


class DotVerifier(Verifier):

    OUTPUT_UIDS = ['result']

    def get_actual_results(self):
        return self.get_output_from_symbol('result', 'double')

    def get_expected_results(self):
        x = self.get_input_from_symbol('x', 'double')
        y = self.get_input_from_symbol('y', 'double')
        return DotDataGen().golden_model(x, y)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(DotVerifier().main())
