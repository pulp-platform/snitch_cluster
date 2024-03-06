#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys
from pathlib import Path
from datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../../util/sim/'))
from verif_utils import Verifier  # noqa: E402
from data_utils import ctype_from_precision_t  # noqa: E402


class GemmVerifier(Verifier):

    OUTPUT_UIDS = ['c']
    ERR_THRESHOLD = {8: 1e-6, 4: 1e-6, 2: 1e-2, 1: 1e-1}

    def __init__(self):
        super().__init__()
        self.prec = self.get_input_from_symbol('dtype_size', 'uint32_t')[0]

    def get_actual_results(self):
        return self.get_output_from_symbol('c', ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        a = self.get_input_from_symbol('a', ctype_from_precision_t(self.prec))
        b = self.get_input_from_symbol('b', ctype_from_precision_t(self.prec))
        c = self.get_input_from_symbol('c', ctype_from_precision_t(self.prec))
        beta = self.get_input_from_symbol('BETA', 'uint32_t')[0]
        m = self.get_input_from_symbol('M', 'uint32_t')[0]
        n = self.get_input_from_symbol('N', 'uint32_t')[0]
        k = self.get_input_from_symbol('K', 'uint32_t')[0]
        tb = self.get_input_from_symbol('TB', 'uint32_t')[0]
        a = np.reshape(a, (m, k))
        if tb:
            b = np.reshape(b, (n, k))
            b = b.transpose()
        else:
            b = np.reshape(b, (k, n))
        c = np.reshape(c, (m, n))
        return golden_model(1, a, b, beta, c).flatten()

    def check_results(self, *args):
        return super().check_results(*args, atol=self.ERR_THRESHOLD[self.prec])


if __name__ == "__main__":
    sys.exit(GemmVerifier().main())
