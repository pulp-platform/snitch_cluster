#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
from datagen import FmatmulDataGen

from snitch.util.sim.verif_utils import Verifier
from snitch.util.sim.data_utils import ctype_from_precision_t


class FmatmulVerifier(Verifier):

    OUTPUT_UIDS = ['gemm_C_dram']
    ERR_THRESHOLD = {
        8: 1e-6,
        4: 1e-3,
        2: 5e-1,
    }

    def __init__(self):
        super().__init__()
        self.prec = self.get_input_from_symbol('prec', 'uint32_t')[0]

    def get_actual_results(self):
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        ctype = ctype_from_precision_t(self.prec)
        m = self.get_input_from_symbol('m', 'uint32_t')[0]
        n = self.get_input_from_symbol('n', 'uint32_t')[0]
        k = self.get_input_from_symbol('k', 'uint32_t')[0]
        a = self.get_input_from_symbol('gemm_A_dram', ctype).reshape(m, k)
        b = self.get_input_from_symbol('gemm_B_dram', ctype).reshape(k, n)

        return FmatmulDataGen().golden_model(a, b).flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=self.ERR_THRESHOLD[self.prec])


if __name__ == "__main__":
    sys.exit(FmatmulVerifier().main())
