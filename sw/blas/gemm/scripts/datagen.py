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
import pyflexfloat as ff
import sys

from snitch.util.sim import data_utils
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

    def load_params(self, params):
        self.M = params.get('M')
        self.N = params.get('N')
        self.K = params.get('K')
        self.m_tiles = params.get('m_tiles')
        self.n_tiles = params.get('n_tiles')
        self.k_tiles = params.get('k_tiles')
        self.load_a = params.get('load_a')
        self.load_b = params.get('load_b')
        self.load_c = params.get('load_c')
        self.setup_ssr = params.get('setup_ssr')
        self.parallelize_m = params.get('parallelize_m')
        self.parallelize_k = params.get('parallelize_k')
        self.gemm_fp = params.get('gemm_fp')
        self.transa = params.get('transa')
        self.transb = params.get('transb')
        self.alpha = params.get('alpha', 1)
        self.beta = params.get('beta')
        self.section = params.get('section')
        self.dtype, self.impl = self.infer_implementation(self.gemm_fp)
        self.prec = data_utils.size_from_precision_t(self.dtype)
        self.ff_desc = data_utils.ff_desc_from_precision_t(self.dtype)
        self.ctype = data_utils.ctype_from_precision_t(self.dtype)

    def validate(self):
        frac_m = self.M / self.m_tiles
        frac_n = self.N / self.n_tiles
        frac_k = self.K / self.k_tiles

        a_size = frac_m * frac_k * self.prec
        b_size = frac_k * frac_n * self.prec
        c_size = frac_m * frac_n * self.prec
        total_size = a_size
        total_size += b_size
        total_size += c_size
        data_utils.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]
        self.load_params(kwargs)

        # Validate parameters
        self.validate()

        M, N, K = kwargs['M'], kwargs['N'], kwargs['K']

        prec, _ = self.infer_implementation(kwargs['gemm_fp'])

        ff_desc = data_utils.ff_desc_from_precision_t(prec)
        ctype = data_utils.ctype_from_precision_t(prec)

        a = ff.array(np.random.rand(M, K), ff_desc)
        b = ff.array(np.random.rand(K, N), ff_desc)
        c = ff.array(np.random.rand(M, N), ff_desc)
        result = self.exact_golden_model(1, a, b, kwargs['beta'], c)

        # Store matrices in transposed form if requested
        a = a.T if kwargs['transa'] else a
        b = b.T if kwargs['transb'] else b

        a_uid = 'a'
        b_uid = 'b'
        c_uid = 'c'

        cfg = {
            'prec': prec,
            'setup_ssr': kwargs['setup_ssr'],
            'parallelize_m': kwargs['parallelize_m'],
            'parallelize_k': kwargs['parallelize_k'],
            'm_tiles': kwargs['m_tiles'],
            'n_tiles': kwargs['n_tiles'],
            'k_tiles': kwargs['k_tiles'],
            'load_a': kwargs['load_a'],
            'load_b': kwargs['load_b'],
            'load_c': kwargs['load_c'],
            'transa': kwargs['transa'],
            'transb': kwargs['transb'],
            'M': M,
            'N': N,
            'K': K,
            'alpha': kwargs['alpha'],
            'beta': kwargs['beta'],
            'gemm_fp': kwargs['gemm_fp'],
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
