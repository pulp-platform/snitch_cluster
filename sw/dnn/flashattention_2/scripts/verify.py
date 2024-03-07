#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
import torch
from pathlib import Path
from datagen import exact_golden_model

sys.path.append(str(Path(__file__).parent / '../../../../util/sim/'))
from verif_utils import Verifier  # noqa: E402
from data_utils import ctype_from_precision_t  # noqa: E402


class FlashAttention2Verifier(Verifier):

    OUTPUT_UIDS = ['O']

    def __init__(self):
        super().__init__()
        self.layer_struct = {
            'N': 'I',
            'd': 'I',
            'B_r': 'I',
            'B_c': 'I',
            'Q': 'I',
            'K': 'I',
            'V': 'I',
            'O': 'I',
            'dtype': 'I',
            'baseline': 'I'
        }
        self.layer = self.get_input_from_symbol('layer', self.layer_struct)
        self.N = self.layer['N']
        self.d = self.layer['d']
        self.B_r = self.layer['B_r']
        self.B_c = self.layer['B_c']
        self.prec = self.layer['dtype']

    def get_actual_results(self):
        return self.get_output_from_symbol('O', ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        Q = self.get_input_from_symbol('Q', ctype_from_precision_t(self.prec))
        K = self.get_input_from_symbol('K', ctype_from_precision_t(self.prec))
        V = self.get_input_from_symbol('V', ctype_from_precision_t(self.prec))
        Q = torch.from_numpy(Q.reshape(self.N, self.d))
        V = torch.from_numpy(V.reshape(self.N, self.d))
        K = torch.from_numpy(K.reshape(self.N, self.d))
        # return torch_golden_model(Q, K, V).detach().numpy().flatten()
        return exact_golden_model(Q, K, V, self.B_r, self.B_c).flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=1E-4)


if __name__ == "__main__":
    sys.exit(FlashAttention2Verifier().main())
