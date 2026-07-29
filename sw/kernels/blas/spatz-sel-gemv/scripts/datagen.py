#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import numpy as np
import sys

import snitch.util.sim.data_utils as du


class SelGemvDataGen(du.DataGen):

    def golden_model(self, a, b):
        return a @ b

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        m, n, tot_nz = kwargs['m'], kwargs['n'], kwargs['tot_nz']
        prec = kwargs['prec']
        ctype = du.ctype_from_precision_t(prec)
        prec_bytes = du.size_from_precision_t(prec)

        a = du.generate_random_array((m, n), prec=prec, seed=42)
        b = du.generate_random_array(n, prec=prec, seed=43)

        # Zero out all but tot_nz entries of b
        rng = np.random.default_rng(seed=44)
        nz_indices = rng.choice(n, size=tot_nz, replace=False)
        mask = np.zeros(n, dtype=bool)
        mask[nz_indices] = True
        b = np.where(mask, b, 0).astype(b.dtype)

        # The kernel expects the matrix in column-major layout: N contiguous
        # blocks of M elements each, block j being column j of A
        mat = a.T

        cfg = {
            'M': m,
            'N': n,
            'dtype': prec,
        }

        # gemv_layer is defined in the shared layer.h, not generated here.
        # PREC drives main.c's choice of T. The plain m/n/prec scalars below
        # are for verify.py, which can't easily unpack fields out of the
        # gemv_l struct directly; tot_nz_dram is also read directly by the
        # kernel itself.
        header += ['#include "layer.h"', f'#define PREC {prec_bytes * 8}']
        header += [du.format_scalar_definition('extern const uint32_t', 'm', m)]
        header += [du.format_scalar_definition('extern const uint32_t', 'n', n)]
        header += [du.format_scalar_definition('extern const uint32_t', 'tot_nz_dram', tot_nz)]
        header += [du.format_scalar_definition('extern const uint32_t', 'prec', prec_bytes)]
        header += [du.format_struct_definition('const gemv_layer', 'gemv_l', cfg)]
        header += [du.format_array_definition(ctype, 'gemv_mat_dram', mat, section=kwargs['section'])]
        header += [du.format_array_definition(ctype, 'gemv_vec_dram', b, section=kwargs['section'])]
        # Declaration-only output buffer: the kernel DMAs its result here,
        # verify.py reads it back post-simulation.
        header += [du.format_array_declaration(ctype, 'gemv_out_dram', (m,), section=kwargs['section'])]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(SelGemvDataGen().main())
