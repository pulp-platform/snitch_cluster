#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import sys
from datagen import exact_flexfloat_golden_model
import pyflexfloat as ff

from snitch.util.sim.verif_utils import Verifier
from snitch.util.sim.data_utils import ctype_from_precision_t, ff_desc_from_precision_t


class FlashAttention2Verifier(Verifier):

    OUTPUT_UIDS = ['O']
    ERR_THRESHOLD = {4: 1e-6, 2: 8e-3, 1: 3e-1}

    def __init__(self):
        super().__init__()
        self.layer_struct = {
            'L': 'I',
            'S': 'I',
            'd': 'I',
            'B_r': 'I',
            'B_c': 'I',
            'Q': 'I',
            'K': 'I',
            'V': 'I',
            'O': 'I',
            'dtype': 'I',
            'baseline': 'I',
            'gemm_fp': 'I'
        }
        self.layer = self.get_input_from_symbol('layer', self.layer_struct)
        self.L = self.layer['L']
        self.S = self.layer['S']
        self.d = self.layer['d']
        self.B_r = self.layer['B_r']
        self.B_c = self.layer['B_c']
        self.prec = self.layer['dtype']

    def get_actual_results(self):
        return self.get_output_from_symbol(self.OUTPUT_UIDS[0], ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        Q = self.get_input_from_symbol('Q', ctype_from_precision_t(self.prec))
        K = self.get_input_from_symbol('K', ctype_from_precision_t(self.prec))
        V = self.get_input_from_symbol('V', ctype_from_precision_t(self.prec))
        # convert Q, K, V to float using ff.FlexFloat.__float__
        Q_f = np.array([q.__float__() for q in Q])
        K_f = np.array([k.__float__() for k in K])
        V_f = np.array([v.__float__() for v in V])
        # Q = torch.from_numpy(Q.reshape(self.L, self.d))
        # V = torch.from_numpy(V.reshape(self.S, self.d))
        # K = torch.from_numpy(K.reshape(self.S, self.d))
        ff_desc = ff_desc_from_precision_t(self.prec)
        Q = ff.array(Q_f.reshape(self.L, self.d), ff_desc)
        V = ff.array(V_f.reshape(self.S, self.d), ff_desc)
        K = ff.array(K_f.reshape(self.S, self.d), ff_desc)
        # return torch_golden_model(Q, K, V).detach().numpy().flatten()
        # return exact_golden_model(Q, K, V, self.B_r, self.B_c).flatten()
        return exact_flexfloat_golden_model(Q, K, V, self.B_r, self.B_c, ff_desc).flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=self.ERR_THRESHOLD[self.prec])


if __name__ == "__main__":
    sys.exit(FlashAttention2Verifier().main())
