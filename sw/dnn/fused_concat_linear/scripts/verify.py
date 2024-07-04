#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
import torch
from pathlib import Path
from datagen import golden_model

sys.path.append(str(Path(__file__).parent / '../../../../util/sim/'))
from verif_utils import Verifier  # noqa: E402
from data_utils import ctype_from_precision_t  # noqa: E402


class FusedConcatLinearVerifier(Verifier):

    OUTPUT_UIDS = ['linear_output']

    def __init__(self):
        super().__init__()
        self.layer_struct = {
            'num_inputs': 'I',
            'in_height': 'I',
            'in_width': 'I',
            'out_height': 'I',
            'out_width': 'I',
            'inputs': 'I',
            'weights': 'I',
            'concat_output': 'I',
            'linear_output': 'I',
            'dtype': 'I',
            'baseline': 'I',
            'gemm_fp': 'I'
        }
        self.layer = self.get_input_from_symbol('layer', self.layer_struct)
        self.num_inputs = self.layer['num_inputs']
        self.input_shape = [self.layer['in_height'], self.layer['in_width']]
        self.weights_shape = [self.layer['in_width']*self.num_inputs, self.layer['out_width']]
        self.prec = self.layer['dtype']

    def get_actual_results(self):
        return self.get_output_from_symbol('linear_output', ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        inputs = [self.get_input_from_symbol(f'input_{i}', ctype_from_precision_t(self.prec))
                  for i in range(self.num_inputs)]
        inputs = [torch.from_numpy(tensor.reshape(self.input_shape)) for tensor in inputs]
        weights = self.get_input_from_symbol('weights', ctype_from_precision_t(self.prec))
        weights = torch.from_numpy(weights.reshape(self.weights_shape))
        output_golden, _ = golden_model(inputs, weights)
        return output_golden.detach().numpy().flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=1E-6)


if __name__ == "__main__":
    sys.exit(FusedConcatLinearVerifier().main())
