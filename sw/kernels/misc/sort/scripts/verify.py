#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Nico Canzani <ncanzani@ethz.ch>
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from datagen import SortDataGen

from snitch.util.sim.verif_utils import Verifier


class SortVerifier(Verifier):

    OUTPUT_UIDS = ['z']

    def get_actual_results(self):
        return self.get_output_from_symbol('z', 'int32_t')

    def get_expected_results(self):
        x = self.get_input_from_symbol('x', 'int32_t')
        return SortDataGen().golden_model(x)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(SortVerifier().main())
