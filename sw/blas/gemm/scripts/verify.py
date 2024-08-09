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
        2: 1e-2,
        4: 1e-6,
        8: 1e-6
    }

    def __init__(self):
        super().__init__()
        self.func_args = {
            'alpha': 'd',
            'prec': 'I',
            'setup_ssr': 'I',
            'parallelize_m': 'I',
            'parallelize_k': 'I',
            'm_tiles': 'I',
            'n_tiles': 'I',
            'k_tiles': 'I',
            'load_a': 'I',
            'load_b': 'I',
            'load_c': 'I',
            'transa': 'I',
            'transb': 'I',
            'M': 'I',
            'N': 'I',
            'K': 'I',
            'a': 'I',
            'b': 'I',
            'beta': 'I',
            'c': 'I',
            'gemm_fp': 'I'
        }
        self.func_args = self.get_input_from_symbol('args', self.func_args)

    def get_actual_results(self):
        prec = self.func_args['prec']
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], ctype_from_precision_t(prec))

    def get_expected_results(self):
        prec = self.func_args['prec']
        a = self.get_input_from_symbol('a', ctype_from_precision_t(prec))
        b = self.get_input_from_symbol('b', ctype_from_precision_t(prec))
        c = self.get_input_from_symbol('c', ctype_from_precision_t(prec))
        beta = self.func_args['beta']
        m = self.func_args['M']
        n = self.func_args['N']
        k = self.func_args['K']
        tb = self.func_args['transb']

        a = np.reshape(a, (m, k))
        if tb:
            b = np.reshape(b, (n, k))
            b = b.transpose()
        else:
            b = np.reshape(b, (k, n))
        c = np.reshape(c, (m, n))
        return GemmDataGen().exact_golden_model(1, a, b, beta, c).flatten()

    def check_results(self, *args):
        prec = self.func_args['prec']
        return super().check_results(*args, rtol=self.ERR_THRESHOLD[prec])


if __name__ == "__main__":
    sys.exit(GemmVerifier().main())
