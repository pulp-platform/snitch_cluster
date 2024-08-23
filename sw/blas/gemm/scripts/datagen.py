#!/usr/bin/env python3
# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Authors: Tim Fischer     <fischeti@iis.ee.ethz.ch>
#          Luca Bertaccini <lbertaccini@iis.ee.ethz.ch>
#          Viviane Potocnik <vivianep@iis.ee.ethz.ch>
#          Luca Colagrande <colluca@iis.ee.ethz.ch>

import numpy as np
import re
import sys

import snitch.util.sim.data_utils as du
from snitch.util.sim.data_utils import DataGen, format_array_declaration, \
    format_struct_definition, format_array_definition, format_ifdef_wrapper


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

    def infer_implementation(self, gemm_fp):
        # gemm_fp: "gemm_fp64_opt"
        # create a regex with fp_<type>_<implementation>
        prec, impl = re.search(r'gemm_fp(\d+)_(\w+)', gemm_fp).group(1, 2)
        return (int(prec) / 8), impl

    def validate_config(self, gemm_fp, parallelize_m,
                        parallelize_k, m_tiles, n_tiles, k_tiles, transa,
                        transb, M, N, K, beta, **kwargs):
        frac_m = M / m_tiles
        frac_n = N / n_tiles
        frac_k = K / k_tiles

        dtype, impl = self.infer_implementation(gemm_fp)

        # Calculate total TCDM occupation
        # Note: doesn't account for double buffering
        prec = du.size_from_precision_t(dtype)
        a_size = frac_m * frac_k * prec
        b_size = frac_k * frac_n * prec
        c_size = frac_m * frac_n * prec
        total_size = a_size
        total_size += b_size
        total_size += c_size
        du.validate_tcdm_footprint(total_size)

        assert (M % m_tiles) == 0, 'M is not an integer multiple of tile size'
        assert (N % n_tiles) == 0, 'N is not an integer multiple of tile size'
        assert (K % k_tiles) == 0, 'K is not an integer multiple of tile size'
        assert not (parallelize_m and parallelize_k), 'Cannot parallelize K and M simultaneously'
        assert not transa, 'SIMD kernels don\'t support transposed A matrix'
        assert (dtype == 8) or (impl == 'baseline') or (impl == 'naive') \
            or transb, 'Optimized SIMD kernels only support transposed B matrix'
        assert not transb or n_tiles == 1, 'Tiling in the N dimension not supported' \
            ' if B is transposed'
        assert not transb or k_tiles == 1, 'Tiling in the K dimension not supported' \
            ' if B is transposed'
        assert (impl == 'baseline') or (impl == 'naive') or frac_n >= 8, \
            'N dimension of tile size must be greater or equal to the unrolling factor (8) ' \
            'when using optimized kernels'
        assert beta == 0 or beta == 1, 'Only values of 0 or 1 supported for beta'
        assert not (dtype == 8 and impl == "baseline"), 'No baseline implemented' \
            ' for FP64 (switch to NAIVE)'
        assert not (((dtype == 8) or (dtype == 4)) and impl == "opt_ex"), \
            'Expanding GEMM kernels' \
            ' not supported for FP64 and FP32'
        assert not (dtype == 1 and impl == "opt"), 'FP8 not supported in' \
            ' optimized implementation' \
            ' (switch to opt_ex)'

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        # Validate parameters
        self.validate_config(**kwargs)

        M, N, K = kwargs['M'], kwargs['N'], kwargs['K']

        prec, _ = self.infer_implementation(kwargs['gemm_fp'])

        ctype = du.ctype_from_precision_t(prec)

        a = du.generate_random_array((M, K), prec)
        b = du.generate_random_array((K, N), prec)
        c = du.generate_random_array((M, N), prec)
        result = self.exact_golden_model(1, a, b, kwargs['beta'], c)

        # Store matrices in transposed form if requested
        a = a.T if kwargs['transa'] else a
        b = b.T if kwargs['transb'] else b

        a_uid = 'a'
        b_uid = 'b'
        c_uid = 'c'

        cfg = {
            'prec': prec,
            **kwargs,
            'a': a_uid,
            'b': b_uid,
            'c': c_uid,
        }

        a = a.flatten()
        b = b.flatten()
        c = c.flatten()

        header += [format_array_declaration(ctype, a_uid, a.shape)]
        header += [format_array_declaration(ctype, b_uid, b.shape)]
        header += [format_array_declaration(ctype, c_uid, c.shape)]
        header += [format_struct_definition('gemm_args_t', 'args', cfg)]
        header += [format_array_definition(ctype, a_uid, a,
                                           section=kwargs['section'])]
        header += [format_array_definition(ctype, b_uid, b,
                                           section=kwargs['section'])]
        header += [format_array_definition(ctype, c_uid, c,
                                           section=kwargs['section'])]
        result_def = format_array_definition(ctype, 'result', result.flatten())
        header += [format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == "__main__":
    sys.exit(GemmDataGen().main())
