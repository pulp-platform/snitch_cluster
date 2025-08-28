#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys
from datagen import GemmDataGen

from snitch.util.sim.verif_utils import Verifier
from snitch.util.sim.data_utils import ctype_from_precision_t


class GemmVerifier(Verifier):

    OUTPUT_UIDS = ['c']
    ERR_THRESHOLD = {
        1: 1e-4,
        2: 5e-1,
        4: 1e-3,
        8: 1e-3
    }

    def __init__(self):
        super().__init__()
        self.prec = self.get_input_from_symbol('prec', 'uint32_t')[0]

    def get_actual_results(self):
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        a = self.get_input_from_symbol('a', ctype_from_precision_t(self.prec))
        b = self.get_input_from_symbol('b', ctype_from_precision_t(self.prec))
        c = self.get_input_from_symbol('c', ctype_from_precision_t(self.prec))
        m = self.get_input_from_symbol('m', 'uint32_t')[0]
        n = self.get_input_from_symbol('n', 'uint32_t')[0]
        k = self.get_input_from_symbol('k', 'uint32_t')[0]
        beta = self.get_input_from_symbol('beta', 'uint32_t')[0]
        transb = self.get_input_from_symbol('transb', 'uint32_t')[0]

        a = np.reshape(a, (m, k))
        if transb:
            b = np.reshape(b, (n, k))
            b = b.transpose()
        else:
            b = np.reshape(b, (k, n))
        c = np.reshape(c, (m, n))

        return GemmDataGen().exact_golden_model(1, a, b, beta, c).flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=self.ERR_THRESHOLD[self.prec])


if __name__ == "__main__":
    sys.exit(GemmVerifier().main())
