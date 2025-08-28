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


class GeluVerifier(Verifier):

    OUTPUT_UIDS = ['ofmap']

    def __init__(self):
        super().__init__()
        self.layer_struct = {
            'size': 'I',
            'ifmap': 'I',
            'ofmap': 'I',
            'dtype': 'I'
        }
        self.layer = self.get_input_from_symbol('layer', self.layer_struct)
        self.prec = self.layer['dtype']

    def get_actual_results(self):
        return self.get_output_from_symbol('ofmap', ctype_from_precision_t(self.prec))

    def get_expected_results(self):
        ifmap = self.get_input_from_symbol('ifmap', ctype_from_precision_t(self.prec))
        ifmap = torch.from_numpy(ifmap)
        return golden_model(ifmap).detach().numpy().flatten()

    def check_results(self, *args):
        return super().check_results(*args, rtol=1E-10)


if __name__ == "__main__":
    sys.exit(GeluVerifier().main())
