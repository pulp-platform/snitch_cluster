#!/usr/bin/env python3
# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Authors: Tim Fischer     <fischeti@iis.ee.ethz.ch>
#          Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
#          Viviane Potocnik <vivianep@iis.ee.ethz.ch>

import numpy as np
import argparse
import pathlib
import json5
import sys
import os
import pyflexfloat as ff

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))
import data_utils  # noqa: E402
from data_utils import emit_license, format_scalar_definition, \
                       format_array_definition, format_ifdef_wrapper  # noqa: E402


np.random.seed(42)

class GemmDataGen(DataGen):

    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096

    def golden_model(self, alpha, a, b, beta, c):
        return alpha * np.matmul(a, b) + beta * c

    def exact_golden_model(self, alpha, a, b, beta, c):
        M, N, K = a.shape[0], b.shape[1], b.shape[0]
        result = beta * c
        for m in range(M):
            for n in range(N):
                for k in range(K):
                    result[m][n] += a[m][k] * b[k][n]
        return result

    def validate_config(self, prec, implementation, parallelize_m, parallelize_k, m_tiles, n_tiles, k_tiles, ta,
                        tb, M, N, K, beta, **kwargs):
        frac_m = M / m_tiles
        frac_n = N / n_tiles

        assert (M % m_tiles) == 0, 'M is not an integer multiple of tile size'
        assert (N % n_tiles) == 0, 'N is not an integer multiple of tile size'
        assert (K % k_tiles) == 0, 'K is not an integer multiple of tile size'
        assert (frac_m % 8) == 0, 'frac_m is not an integer multiple of the number of cores per' \
                                ' cluster'
        assert not (parallelize_m and parallelize_k), 'Cannot parallelize K and M simultaneously'
        assert not ta, 'SIMD kernels don\'t support transposed A matrix'
        assert (prec == "FP64") or (implementation == 'BASELINE') or (implementation == 'NAIVE') \
               or tb, 'Optimized SIMD kernels only support transposed B matrix'
        assert not tb or n_tiles == 1, 'Tiling in the N dimension supported only if B is' \
                                    ' not transposed'
        assert not tb or k_tiles == 1, 'Tiling in the K dimension supported only if B is' \
                                    ' not transposed'
        assert (implementation == 'BASELINE') or (implementation == 'NAIVE') or frac_n >= 8, \
               'N dimension of tile size must be greater or equal to the unrolling factor (8) ' \
               'when using optimized kernels'
        assert beta == 0 or beta == 1, 'Only values of 0 or 1 supported for beta'
        assert not (prec == "FP64" and implementation == "BASELINE"), 'No baseline implemented' \
                                                                  ' for FP64 (switch to NAIVE)'
        assert not (((prec == "FP64") or (prec == "FP32")) and implementation == "OPT_EX"), \
            'Expanding GEMM kernels' \
            ' not supported for FP64 and FP32'
        assert not (((prec == "FP16") or (prec == "FP8")) and implementation == "NAIVE"), \
            'FP16 and FP8 not supported' \
            ' in naive implementation'
        assert not (prec == "FP8" and implementation == "OPT"), 'FP8 not supported in' \
                                                                ' optimized implementation' \
                                                                ' (switch to OPT_EX)'


    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        # Validate parameters
        self.validate_config(**kwargs)

        # Generate random input matrices
        prec = kwargs['prec']
        M, N, K = kwargs['M'], kwargs['N'], kwargs['K']

        ff_desc = data_utils.ff_desc_from_precision_t(prec)
        ctype = data_utils.ctype_from_precision_t(prec)

        a = ff.array(np.random.rand(M, K), ff_desc)
        b = ff.array(np.random.rand(K, N), ff_desc)
        c = ff.array(np.random.rand(M, N), ff_desc)
        result = self.exact_golden_model(1, a, b, kwargs['beta'], c)

        # Store matrices in transposed form if requested
        a = a.T if kwargs['ta'] else a
        b = b.T if kwargs['tb'] else b

        header += [format_scalar_definition('uint32_t', 'M', M)]
        header += [format_scalar_definition('uint32_t', 'N', N)]
        header += [format_scalar_definition('uint32_t', 'K', K)]
        header += [format_scalar_definition('uint32_t', 'TA', int(kwargs['ta']))]
        header += [format_scalar_definition('uint32_t', 'TB', int(kwargs['tb']))]
        header += [format_scalar_definition('uint32_t', 'BETA', kwargs['beta'])]
        header += [format_scalar_definition('uint32_t', 'dtype_size', prec)]
        header += [format_scalar_definition('uint32_t', 'expand', int(kwargs['expand']))]
        header += [format_scalar_definition('uint32_t', 'm_tiles', kwargs['m_tiles'])]
        header += [format_scalar_definition('uint32_t', 'n_tiles', kwargs['n_tiles'])]
        header += [format_scalar_definition('uint32_t', 'k_tiles', kwargs['k_tiles'])]
        header += [format_scalar_definition('uint32_t', 'parallelize_m', kwargs['parallelize_m'])]
        header += [format_scalar_definition('uint32_t', 'parallelize_k', kwargs['parallelize_k'])]
        header += [format_scalar_definition('implementation_t', 'implementation', kwargs['implementation'])]
        header += [format_array_definition(ctype, 'a', a.flatten(), alignment=self.BURST_ALIGNMENT,
                                           section=kwargs['section'])]
        header += [format_array_definition(ctype, 'b', b.flatten(), alignment=self.BURST_ALIGNMENT,
                                           section=kwargs['section'])]
        header += [format_array_definition(ctype, 'c', c.flatten(), alignment=self.BURST_ALIGNMENT,
                                           section=kwargs['section'])]
        result_def = format_array_definition(ctype, 'result', result.flatten())
        header += [format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    main()
