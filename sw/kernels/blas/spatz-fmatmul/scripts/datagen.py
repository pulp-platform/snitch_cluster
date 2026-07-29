#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys

import snitch.util.sim.data_utils as du


class FmatmulDataGen(du.DataGen):

    def golden_model(self, a, b):
        return a @ b

    def validate(self, **kwargs):
        prec_bytes = du.size_from_precision_t(kwargs['prec'])
        total_size = (kwargs['m'] * kwargs['k'] + kwargs['k'] * kwargs['n']
                      + kwargs['m'] * kwargs['n']) * prec_bytes
        du.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate(**kwargs)

        m, n, k = kwargs['m'], kwargs['n'], kwargs['k']
        prec = kwargs['prec']
        ctype = du.ctype_from_precision_t(prec)
        prec_bytes = du.size_from_precision_t(prec)

        a = du.generate_random_array((m, k), prec=prec, seed=42)
        b = du.generate_random_array((k, n), prec=prec, seed=42)
        c = du.generate_random_array((m, n), prec=prec, seed=42)

        cfg = {
            'M': m,
            'N': n,
            'K': k,
            'TA': 0,
            'TB': 0,
            'ALPHA': 0,
            'dtype': prec,
            'expand': 0,
        }

        # gemm_layer is defined in the shared layer.h, not generated here.
        # PREC (a preprocessor macro) drives main.c's choice of T and of
        # which precision-specific kernel source it #includes. The plain
        # m/n/k/prec scalars below are for verify.py, which can't easily
        # unpack fields out of the gemm_l struct directly.
        header += ['#include "layer.h"', f'#define PREC {prec_bytes * 8}']
        header += [du.format_scalar_definition('extern const uint32_t', 'm', m)]
        header += [du.format_scalar_definition('extern const uint32_t', 'n', n)]
        header += [du.format_scalar_definition('extern const uint32_t', 'k', k)]
        header += [du.format_scalar_definition('extern const uint32_t', 'prec', prec_bytes)]
        header += [du.format_struct_definition('const gemm_layer', 'gemm_l', cfg)]
        header += [du.format_array_definition(ctype, 'gemm_A_dram', a, section=kwargs['section'])]
        header += [du.format_array_definition(ctype, 'gemm_B_dram', b, section=kwargs['section'])]
        # gemm_C_dram is also the kernel's output buffer: it's DMA'd in as the
        # initial C, then overwritten with the result at the end (verify.py
        # reads it back post-simulation).
        header += [du.format_array_definition(ctype, 'gemm_C_dram', c, section=kwargs['section'])]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(FmatmulDataGen().main())
