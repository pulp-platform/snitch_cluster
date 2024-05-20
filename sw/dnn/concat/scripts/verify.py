#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
import torch
from datagen import golden_model

from snitch.util.sim.verif_utils import Verifier
from snitch.util.sim.data_utils import ctype_from_precision_t


class ConcatVerifier(Verifier):

    OUTPUT_UIDS = ['output']

    def __init__(self):
        super().__init__()
        self.layer_struct = {
            'num_inputs': 'I',
            'height': 'I',
            'width': 'I',
            'inputs': 'I',
            'output': 'I',
            'dtype': 'I'
        }
        self.layer = self.get_input_from_symbol('layer', self.layer_struct)
        self.num_inputs = self.layer['num_inputs']
        self.input_shape = [self.layer['height'], self.layer['width']]
        self.prec = self.layer['dtype']

    def get_actual_results(self):
        return self.get_output_from_symbol('output', ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        inputs = [self.get_input_from_symbol(f'input_{i}', ctype_from_precision_t(self.prec))
                  for i in range(self.num_inputs)]
        inputs = [torch.from_numpy(tensor.reshape(self.input_shape)) for tensor in inputs]
        return golden_model(inputs).detach().numpy().flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=1E-6)


if __name__ == "__main__":
    sys.exit(ConcatVerifier().main())
