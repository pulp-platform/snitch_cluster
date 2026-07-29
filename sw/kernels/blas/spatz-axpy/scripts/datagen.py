#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys

import snitch.util.sim.data_utils as du


class SpatzAxpyDataGen(du.DataGen):

    def golden_model(self, alpha, x, y):
        return alpha * x + y

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        m = kwargs['m']
        prec = kwargs['prec']
        ctype = du.ctype_from_precision_t(prec)

        alpha = du.generate_random_array(1, prec=prec, seed=0)[0]
        x = du.generate_random_array(m, prec=prec, seed=0)
        y = du.generate_random_array(m, prec=prec, seed=0)

        cfg = {
            'M': m,
            'dtype': prec,
        }

        # axpy_layer is defined in the shared layer.h, not generated here.
        # The plain m/prec scalars below are for verify.py, which can't
        # easily unpack fields out of the axpy_l struct directly.
        header += ['#include "layer.h"']
        header += [du.format_scalar_definition('extern const uint32_t', 'm', m)]
        header += [du.format_scalar_definition('extern const uint32_t', 'prec',
                                               du.size_from_precision_t(prec))]
        header += [du.format_struct_definition('const axpy_layer', 'axpy_l', cfg)]
        header += [du.format_scalar_definition(f'extern const {ctype}', 'axpy_alpha_dram', alpha)]
        header += [du.format_array_definition(ctype, 'axpy_X_dram', x, section=kwargs['section'])]
        # axpy_Y_dram is also the kernel's output buffer: it's DMA'd in as the
        # initial Y, then overwritten with the result at the end (verify.py
        # reads it back post-simulation).
        header += [du.format_array_definition(ctype, 'axpy_Y_dram', y, section=kwargs['section'])]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(SpatzAxpyDataGen().main())
