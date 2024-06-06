#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import numpy as np
import os
import pyflexfloat as ff
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), "../../../../util/sim/"))

#print(f'System path {os.path.join(os.path.dirname(__file__), "../../../../util/sim/")}')
import data_utils
from data_utils import ctype_from_precision_t, ff_desc_from_precision_t, \
                       format_struct_definition, format_array_definition, \
                       format_array_declaration, format_ifdef_wrapper, DataGen, \
                       format_scalar_definition  # noqa: E402

np.random.seed(42)

# AXI splits bursts crossing 4KB address boundaries. To minimize
# the occurrence of these splits the data should be aligned to 4KB
BURST_ALIGNMENT = 4096


class TransposeDataGen(DataGen):

    def golden_model(self, inp):
        return np.transpose(inp)

# TODO:
# def validate_config(prec, parallelize_m, parallelize_k, m_tiles, n_tiles, k_tiles, ta, tb, M, N, K,
#                     baseline, beta, **kwargs):
#     frac_m = M / m_tiles
#     frac_n = N / n_tiles

#     assert (M % m_tiles) == 0, 'M is not an integer multiple of tile size'
#     assert (N % n_tiles) == 0, 'N is not an integer multiple of tile size'
#     assert (K % k_tiles) == 0, 'K is not an integer multiple of tile size'
#     assert (frac_m % 8) == 0, 'frac_m is not an integer multiple of the number of cores per' \
#                               ' cluster'
#     assert not (parallelize_m and parallelize_k), 'Cannot parallelize K and M simultaneously'
#     assert not ta, 'SIMD kernels don\'t support transposed A matrix'
#     assert not ((prec != "FP64") and not baseline and not tb), 'Optimized SIMD kernels only' \
#                                                                ' transposed B matrix support'
#     assert not tb or n_tiles == 1, 'Tiling in the N dimension supported only if B is' \
#                                    ' not transposed'
#     assert not tb or k_tiles == 1, 'Tiling in the K dimension supported only if B is' \
#                                    ' not transposed'
#     assert baseline or frac_n >= 8, 'N dimension of tile size must be greater or equal to' \
#                                     ' the unrolling factor (8) when using optimized kernels'
#     assert prec == "FP64" or beta == 0, 'beta != 0 supported only in FP64'

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        M, N, prec = kwargs['M'], kwargs['N'], kwargs['prec']
        #assert (M % 8) == 0, "M must be an integer multiple of the number of cores"

        ff_desc = ff_desc_from_precision_t(prec)
        ctype = ctype_from_precision_t(prec)

        inp = ff.array(np.random.rand(M, N), ff_desc)
        output = self.golden_model(inp)

        input_uid = 'input'
        output_uid = 'output'

        header += [format_array_declaration(ctype, input_uid, inp.shape,
                                            alignment=BURST_ALIGNMENT)]
        header += [format_array_declaration(ctype, output_uid, output.shape,
                                            alignment=BURST_ALIGNMENT)]
        header += [format_scalar_definition('uint32_t', 'M', M)]
        header += [format_scalar_definition('uint32_t', 'N', N)]
        header += [format_scalar_definition('uint32_t', 'dtype', prec)]
        header += [format_scalar_definition('uint32_t', 'baseline', int(kwargs['baseline']))]
        header += [format_scalar_definition('uint32_t', 'opt_ssr', int(kwargs['opt_ssr']))]
        header += [format_array_definition(ctype, input_uid, inp, alignment=BURST_ALIGNMENT)]
        result_def = format_array_definition(ctype, 'golden', output, alignment=BURST_ALIGNMENT)
        header += [format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == '__main__':
    sys.exit(TransposeDataGen().main())
