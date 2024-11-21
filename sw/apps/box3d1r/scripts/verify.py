#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
from datagen import Box3D1RDataGen

sys.path.append(str(Path(__file__).parent / '../../../../util/sim/'))
from verif_utils import Verifier  # noqa: E402


class Box3D1RVerifier(Verifier):

    OUTPUT_UIDS = ['A_']

    def get_actual_results(self):
        return self.get_output_from_symbol('A_', 'double')

    def get_expected_results(self):
        R = self.get_input_from_symbol('r', 'const int')
        NX = self.get_input_from_symbol('nx', 'const int')
        NY = self.get_input_from_symbol('ny', 'const int')
        NZ = self.get_input_from_symbol('nz', 'const int')
        C = self.get_input_from_symbol('c', 'double')
        A = self.get_input_from_symbol('A', 'double')
        return Box3D1RDataGen().golden_model(1, 16, 16, 16, C, A)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(Box3D1RVerifier().main())