#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
from datagen import SpatzAxpyDataGen

from snitch.util.sim.verif_utils import Verifier
from snitch.util.sim.data_utils import ctype_from_precision_t


class SpatzAxpyVerifier(Verifier):

    OUTPUT_UIDS = ['axpy_Y_dram']
    ERR_THRESHOLD = {
        8: 1e-10,
        4: 1e-5,
        2: 5e-2,
    }

    def __init__(self):
        super().__init__()
        self.prec = self.get_input_from_symbol('prec', 'uint32_t')[0]

    def get_actual_results(self):
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        ctype = ctype_from_precision_t(self.prec)
        alpha = self.get_input_from_symbol('axpy_alpha_dram', ctype)[0]
        x = self.get_input_from_symbol('axpy_X_dram', ctype)
        y = self.get_input_from_symbol('axpy_Y_dram', ctype)

        return SpatzAxpyDataGen().golden_model(alpha, x, y)

    def check_results(self, *args):
        return super().check_results(*args, rtol=self.ERR_THRESHOLD[self.prec])


if __name__ == "__main__":
    sys.exit(SpatzAxpyVerifier().main())
