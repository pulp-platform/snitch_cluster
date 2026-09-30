#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys

import snitch.util.sim.data_utils as du


class FgemvDataGen(du.DataGen):

    def golden_model(self, a, b):
        # a is stored column-major, i.e. as A^T (N x M); logical A is M x N
        return a.T @ b

    def validate(self, **kwargs):
        prec_bytes = du.size_from_precision_t(kwargs['prec'])
        total_size = (kwargs['m'] * kwargs['n'] + kwargs['n'] + kwargs['m']) * prec_bytes
        du.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate(**kwargs)

        m, n = kwargs['m'], kwargs['n']
        prec = kwargs['prec']
        ctype = du.ctype_from_precision_t(prec)
        prec_bytes = du.size_from_precision_t(prec)

        # Generated already in the column-major layout the vector kernel
        # expects: an (n, m) array whose rows are the columns of A.
        a = du.generate_random_array((n, m), prec=prec, seed=42)
        b = du.generate_random_array(n, prec=prec, seed=42)
        c = du.generate_random_array(m, prec=prec, seed=42)

        cfg = {
            'M': m,
            'N': n,
            'dtype': prec,
        }

        # gemv_layer is defined in the shared layer.h, not generated here.
        # PREC (a preprocessor macro) drives main.c's choice of T and of
        # which precision-specific kernel source it #includes. The plain
        # m/n/prec scalars below are for verify.py, which can't easily
        # unpack fields out of the gemv_l struct directly.
        header += ['#include "layer.h"', f'#define PREC {prec_bytes * 8}']
        header += [du.format_scalar_definition('extern const uint32_t', 'm', m)]
        header += [du.format_scalar_definition('extern const uint32_t', 'n', n)]
        header += [du.format_scalar_definition('extern const uint32_t', 'prec', prec_bytes)]
        header += [du.format_struct_definition('const gemv_layer', 'gemv_l', cfg)]
        header += [du.format_array_definition(ctype, 'gemv_A_dram', a, section=kwargs['section'])]
        header += [du.format_array_definition(ctype, 'gemv_B_dram', b, section=kwargs['section'])]
        # gemv_C_dram is also the kernel's output buffer: it's DMA'd in as the
        # initial C, then overwritten with the result at the end (verify.py
        # reads it back post-simulation).
        header += [du.format_array_definition(ctype, 'gemv_C_dram', c, section=kwargs['section'])]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(FgemvDataGen().main())
