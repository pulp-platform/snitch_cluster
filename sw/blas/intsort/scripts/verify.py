#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Author: Nico Canzani <ncanzani@ethz.ch>
# Author: Luca Colagrande <colluca@iis.ee.ethz.ch>

import sys
from pathlib import Path
from datagen import IntsortDataGen

sys.path.append(str(Path(__file__).parent / '../../../../util/sim/'))
from verif_utils import Verifier  # noqa: E402


class IntsortVerifier(Verifier):

    OUTPUT_UIDS = ['z']

    def get_actual_results(self):
        return self.get_output_from_symbol('z', 'int32_t')

    def get_expected_results(self):
        x = self.get_input_from_symbol('x', 'int32_t')
        return IntsortDataGen().golden_model(x)

    def check_results(self, *args):
        return super().check_results(*args, rtol=1e-10)


if __name__ == "__main__":
    sys.exit(IntsortVerifier().main())
