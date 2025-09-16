#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from datagen import Box3D1RDataGen

from snitch.util.sim.verif_utils import Verifier


class Box3D1RVerifier(Verifier):

    OUTPUT_UIDS = ['A_']

    def get_actual_results(self):
        return self.get_output_from_symbol('A_', 'double')

    def get_expected_results(self):
        R = self.get_input_from_symbol('r', 'uint32_t')
        NX = self.get_input_from_symbol('nx', 'uint32_t')
        NY = self.get_input_from_symbol('ny', 'uint32_t')
        NZ = self.get_input_from_symbol('nz', 'uint32_t')
        C = self.get_input_from_symbol('c', 'double')
        A = self.get_input_from_symbol('A', 'double')
        return Box3D1RDataGen().golden_model(R, NX, NY, NZ, C, A)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(Box3D1RVerifier().main())
