#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
import numpy as np
from pathlib import Path
from datagen import FgemvDataGen

from snitch.util.sim.verif_utils import Verifier, dump_results_to_csv
from snitch.util.sim.data_utils import ctype_from_precision_t, flatten


class FgemvVerifier(Verifier):

    OUTPUT_UIDS = ['gemv_C_dram']
    ERR_THRESHOLD = {
        8: 1e-6,
        4: 1e-3,
        2: 5e-1,
    }
    # Absolute tolerance floor, needed on top of ERR_THRESHOLD's relative
    # tolerance for FP16: near-zero output elements (from cancellation in
    # the accumulation) can have an absolute error larger than a pure
    # rtol check allows, despite being within FP16's rounding noise floor.
    ATOL_THRESHOLD = {
        8: 0,
        4: 0,
        2: 1e-2,
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
        # gemv_A_dram is stored column-major, i.e. as A^T (N x M)
        a = self.get_input_from_symbol('gemv_A_dram', ctype).reshape(n, m)
        b = self.get_input_from_symbol('gemv_B_dram', ctype)

        return FgemvDataGen().golden_model(a, b)

    def check_results(self, actual, expected):
        # Local combined atol+rtol check: base Verifier.check_results()
        # only accepts one or the other, but a pure rtol check is overly
        # strict on near-zero elements (from cancellation in the
        # accumulation), despite acceptable absolute error.
        atol = self.ATOL_THRESHOLD[self.prec]
        rtol = self.ERR_THRESHOLD[self.prec]
        expected, actual = map(flatten, (expected, actual))
        err = np.abs(expected - actual)
        max_err = atol + rtol * np.abs(expected)
        success = np.allclose(expected, actual, atol=atol, rtol=rtol, equal_nan=False)
        if not success or self.args.dump_results:
            dump_results_to_csv(expected, actual, err, max_err, Path.cwd() / 'results.csv')
        return int(not success)


if __name__ == "__main__":
    sys.exit(FgemvVerifier().main())
