#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys
from datagen import CorrelationDataGen

from snitch.util.sim.verif_utils import Verifier


class CorrelationVerifier(Verifier):

    OUTPUT_UIDS = ['corr']

    def get_actual_results(self):
        return self.get_output_from_symbol('corr', 'double')

    def get_expected_results(self):
        M = self.get_input_from_symbol('M', 'uint32_t')[0]
        N = self.get_input_from_symbol('N', 'uint32_t')[0]
        data = self.get_input_from_symbol('data', 'double')
        data = np.reshape(data, (N, M))
        return CorrelationDataGen().golden_model(data).flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(CorrelationVerifier().main())
