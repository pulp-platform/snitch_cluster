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


np.random.seed(42)


class GemmDataGen(du.DataGen):

    # AXI splits bursts crossing 4KB address boundaries. To minimize
    # the occurrence of these splits the data should be aligned to 4KB
    BURST_ALIGNMENT = 4096
    NUM_CORES = 8

    def golden_model(self, alpha, a, b, beta, c):
        return alpha * np.matmul(a, b) + beta * c

    def exact_golden_model(self, alpha, a, b, beta, c):
        m, n, k = a.shape[0], b.shape[1], b.shape[0]

        result = beta * c
        for i in range(m):
            for j in range(n):
                for h in range(k):
                    result[i][j] += a[i][h] * b[h][j]
        return result

    def infer_implementation(self, gemm_fp):
        # gemm_fp: "gemm_fp64_opt"
        # create a regex with fp_<type>_<implementation>
        prec, impl = re.search(r'gemm_fp(\d+)_(\w+)', gemm_fp).group(1, 2)
        return int(prec) // 8, impl

    def validate(self, gemm_fp, parallelize_m,
                 parallelize_k, m_tiles, n_tiles, k_tiles, transa,
                 transb, m, n, k, beta, **kwargs):
        double_buffer = kwargs.get('double_buffer', False)
        partition_banks = kwargs.get('partition_banks', False)
        tile_m = m / m_tiles
        tile_n = n / n_tiles
        tile_k = k / k_tiles

        dtype, impl = self.infer_implementation(gemm_fp)

        # Calculate total TCDM occupation
        # Note: doesn't account for double buffering
        prec = du.size_from_precision_t(dtype)
        a_size = tile_m * tile_k * prec
        b_size = tile_k * tile_n * prec
        c_size = tile_m * tile_n * prec
        total_size = a_size
        total_size += b_size
        total_size += c_size
        du.validate_tcdm_footprint(total_size)

        assert (m % m_tiles) == 0, 'm is not an integer multiple of tile size'
        assert (n % n_tiles) == 0, 'n is not an integer multiple of tile size'
        assert (k % k_tiles) == 0, 'k is not an integer multiple of tile size'
        assert kwargs['load_a'] or (m_tiles == 1 and k_tiles == 1), 'A matrix can\'t be tiled if' \
            ' local tile buffer is externally managed (load_a == 0)'
        assert kwargs['load_b'] or (k_tiles == 1 and n_tiles == 1), 'B matrix can\'t be tiled if' \
            ' local tile buffer is externally managed (load_b == 0)'
        assert kwargs['load_c'] or (m_tiles == 1 and n_tiles == 1), 'C matrix can\'t be tiled if' \
            ' local tile buffer is externally managed (load_c == 0)'
        assert not (parallelize_m and parallelize_k), 'Cannot parallelize k and m simultaneously'
        assert not (double_buffer and parallelize_k), 'Cannot parallelize k when double buffering'
        assert not transa, 'SIMD kernels don\'t support transposed A matrix'
        assert (dtype == 8) or (impl == 'baseline') or (impl == 'naive') \
            or transb, 'Optimized SIMD kernels only support transposed B matrix'
        assert (impl == 'baseline') or (impl == 'naive') or tile_n >= 8, \
            'n dimension of tile size must be greater or equal to the unrolling factor (8) ' \
            'when using optimized kernels'
        assert beta == 0 or beta == 1, 'Only values of 0 or 1 supported for beta'
        assert not (dtype == 8 and impl == "baseline"), 'No baseline implemented' \
            ' for FP64 (switch to NAIVE)'
        assert not (((dtype == 8) or (dtype == 4)) and impl == "opt_ex"), \
            'Expanding GEMM kernels not supported for FP64 and FP32'
        assert not (dtype == 1 and impl == "opt"), 'FP8 not supported in' \
            ' optimized implementation (switch to opt_ex)'
        assert not (partition_banks and (transb or transa or k_tiles > 1 or n_tiles > 1)), \
            'Cannot allocate buffer in a subset of banks if the A, B and C matrix tiles are not ' \
            'a contiguous 1D block of data. This is guaranteed if A and B are not transposed and' \
            ' only M is tiled.'
        elements_per_tcdm_line = (8 * self.NUM_CORES) / dtype
        k_invalid = (k % elements_per_tcdm_line) != 0
        n_invalid = (n % elements_per_tcdm_line) != 0
        assert not (partition_banks and (k_invalid or n_invalid)), 'Cannot allocate buffer' \
            ' in a subset of banks if the number of elements in K and N is not an exact ' \
            'multiple of the number of elements that can be stored in a line of the TCDM. This ' \
            'constraint could potentially be loosened.'
        assert not (partition_banks and (dtype != 8)), 'Lower than double precision kernels do' \
            'not support partitioned banks, yet.'

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        # Validate parameters
        self.validate(**kwargs)

        m, n, k = kwargs['m'], kwargs['n'], kwargs['k']

        prec, _ = self.infer_implementation(kwargs['gemm_fp'])

        ctype = du.ctype_from_precision_t(prec)

        a = du.generate_random_array((m, k), prec, seed=42)
        b = du.generate_random_array((k, n), prec, seed=42)
        c = du.generate_random_array((m, n), prec, seed=42)
        result = self.exact_golden_model(1, a, b, kwargs['beta'], c)

        # Store matrices in transposed form if requested
        a = a.T if kwargs['transa'] else a
        b = b.T if kwargs['transb'] else b

        a_uid = 'a'
        b_uid = 'b'
        c_uid = 'c'
        m_uid = 'm'
        n_uid = 'n'
        k_uid = 'k'
        prec_uid = 'prec'
        beta_uid = 'beta'
        transb_uid = 'transb'

        cfg = {
            **kwargs,
            'a': a_uid,
            'b': b_uid,
            'c': c_uid,
            'prec': prec_uid,
            'lda': m if kwargs['transa'] else k,
            'ldb': k if kwargs['transb'] else n,
            'ldc': n,
        }
        cfg['m'] = m_uid
        cfg['n'] = n_uid
        cfg['k'] = k_uid
        cfg['beta'] = beta_uid
        cfg['transb'] = transb_uid

        a = a.flatten()
        b = b.flatten()
        c = c.flatten()

        # "extern" specifier is required on declarations preceding a definition
        header += [du.format_array_declaration(f'extern {ctype}', a_uid, a.shape)]
        header += [du.format_array_declaration(f'extern {ctype}', b_uid, b.shape)]
        header += [du.format_array_declaration(f'extern {ctype}', c_uid, c.shape)]
        # "extern" specifier ensures that the variable is emitted and not mangled
        header += [du.format_scalar_definition('extern const uint32_t', prec_uid, prec)]
        header += [du.format_scalar_definition('extern const uint32_t', m_uid, m)]
        header += [du.format_scalar_definition('extern const uint32_t', n_uid, n)]
        header += [du.format_scalar_definition('extern const uint32_t', k_uid, k)]
        header += [du.format_scalar_definition('extern const uint32_t', beta_uid, kwargs['beta'])]
        header += [du.format_scalar_definition('extern const uint32_t', transb_uid,
                                               kwargs['transb'])]
        header += [du.format_struct_definition('extern const gemm_args_t', 'args', cfg)]
        header += [du.format_array_definition(ctype, a_uid, a,
                                              section=kwargs['section'])]
        header += [du.format_array_definition(ctype, b_uid, b,
                                              section=kwargs['section'])]
        header += [du.format_array_definition(ctype, c_uid, c,
                                              section=kwargs['section'])]
        result_def = du.format_array_definition(ctype, 'result', result.flatten())
        header += [du.format_ifdef_wrapper('BIST', result_def)]
        header = '\n\n'.join(header)

        return header


if __name__ == "__main__":
    sys.exit(GemmDataGen().main())
