#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from datagen import KbpcpaDataGen

from snitch.util.sim.verif_utils import Verifier


class KbpcpaVerifier(Verifier):

    OUTPUT_UIDS = ['a']

    def get_actual_results(self):
        return self.get_output_from_symbol('a', 'double')

    def get_expected_results(self):
        k = self.get_input_from_symbol('k', 'double')
        b = self.get_input_from_symbol('b', 'double')
        c = self.get_input_from_symbol('c', 'double')
        return KbpcpaDataGen().golden_model(k, b, c)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(KbpcpaVerifier().main())
