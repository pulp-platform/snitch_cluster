#!/usr/bin/env python3
# Copyright 2024 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
from datagen import TransposeDataGen

sys.path.append(str(Path(__file__).parent / '../../../../../../../util/sim/'))
from verif_utils import Verifier  # noqa: E402
from data_utils import ctype_from_precision_t  # noqa: E402


class TransposeVerifier(Verifier):

    OUTPUT_UIDS = ['output']
    ERR_THRESHOLD = {8: 1e-6, 4: 1e-6, 2: 1e-2, 1: 1e-4}

    def __init__(self):
        super().__init__()

        self.M = self.get_input_from_symbol('M', 'uint32_t')[0]
        self.N = self.get_input_from_symbol('N', 'uint32_t')[0]
        self.prec = self.get_input_from_symbol('dtype', 'uint32_t')[0]

    def get_actual_results(self):
        return self.get_output_from_symbol(
            "output", ctype_from_precision_t(self.prec)
        ).reshape(self.N, self.M)

    def get_expected_results(self):
        inp = self.get_input_from_symbol('input', ctype_from_precision_t(self.prec))
        inp = inp.reshape(self.M, self.N)
        return TransposeDataGen().golden_model(inp)
        # return self.get_input_from_symbol('golden', ctype_from_precision_t(self.prec))

    def check_results(self, *args):
        return super().check_results(*args, rtol=self.ERR_THRESHOLD[self.prec])


if __name__ == "__main__":
    sys.exit(TransposeVerifier().main())
