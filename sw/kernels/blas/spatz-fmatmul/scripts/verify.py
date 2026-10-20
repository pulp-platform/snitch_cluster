#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys
import numpy as np
from pathlib import Path
from datagen import FmatmulDataGen, bf16_bits_to_fp32

from snitch.util.sim.verif_utils import Verifier, dump_results_to_csv
from snitch.util.sim.data_utils import ctype_from_precision_t, flatten


class FmatmulVerifier(Verifier):

    OUTPUT_UIDS = ['gemm_C_dram']
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
    # BF16 shares FP16's byte size (both are 2-byte, hence ATOL_THRESHOLD/
    # ERR_THRESHOLD[2] above) but has a 7-bit mantissa vs FP16's 10-bit one,
    # so its rounding noise floor -- and thus the atol needed for the same
    # near-zero cancellation elements -- is larger.
    ATOL_THRESHOLD_BF16 = 7e-2

    def __init__(self):
        super().__init__()
        self.prec = self.get_input_from_symbol('prec', 'uint32_t')[0]
        self.is_bf16 = bool(self.get_input_from_symbol('is_bf16', 'uint32_t')[0])

    def get_actual_results(self):
        if self.is_bf16:
            bits = self.get_output_from_symbol(self.OUTPUT_UIDS[0], 'uint16_t')
            return bf16_bits_to_fp32(bits)
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        ctype = 'uint16_t' if self.is_bf16 else ctype_from_precision_t(self.prec)
        m = self.get_input_from_symbol('m', 'uint32_t')[0]
        n = self.get_input_from_symbol('n', 'uint32_t')[0]
        k = self.get_input_from_symbol('k', 'uint32_t')[0]
        a = self.get_input_from_symbol('gemm_A_dram', ctype).reshape(m, k)
        b = self.get_input_from_symbol('gemm_B_dram', ctype).reshape(k, n)
        if self.is_bf16:
            a, b = bf16_bits_to_fp32(a), bf16_bits_to_fp32(b)

        return FmatmulDataGen().golden_model(a, b).flatten()

    def check_results(self, actual, expected):
        # Local combined atol+rtol check: base Verifier.check_results()
        # only accepts one or the other, but a pure rtol check is overly
        # strict on near-zero elements (from cancellation in the
        # accumulation), despite acceptable absolute error.
        atol = self.ATOL_THRESHOLD_BF16 if self.is_bf16 else self.ATOL_THRESHOLD[self.prec]
        rtol = self.ERR_THRESHOLD[self.prec]
        expected, actual = map(flatten, (expected, actual))
        err = np.abs(expected - actual)
        max_err = atol + rtol * np.abs(expected)
        success = np.allclose(expected, actual, atol=atol, rtol=rtol, equal_nan=False)
        if not success or self.args.dump_results:
            dump_results_to_csv(expected, actual, err, max_err, Path.cwd() / 'results.csv')
        return int(not success)


if __name__ == "__main__":
    sys.exit(FmatmulVerifier().main())
