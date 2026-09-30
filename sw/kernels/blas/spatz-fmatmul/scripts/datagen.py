#!/usr/bin/env python3
# Copyright 2025 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import sys

import numpy as np

import snitch.util.sim.data_utils as du

# BF16 isn't a `precision_t` known to snitch.util.sim.data_utils (shared
# across all kernels, keyed purely by byte size, which would collide with
# FP16). Spatz instead reinterprets raw 16-bit e16 values as bf16 at
# runtime, via a CSR (see main.c) -- so BF16 support is kept local to this
# kernel: data is generated in FP32, then manually truncated (no rounding)
# to the bf16 bit pattern, which is just the top 16 bits of an IEEE-754
# single-precision value.


def fp32_to_bf16_bits(arr):
    """Truncate an FP32 array to its bf16 bit pattern, stored as uint16."""
    bits = np.asarray(arr, dtype=np.float32).view(np.uint32)
    return (bits >> np.uint32(16)).astype(np.uint16)


def bf16_bits_to_fp32(bits):
    """Widen bf16-encoded uint16 bits back to their exact FP32 value."""
    widened = np.asarray(bits, dtype=np.uint16).astype(np.uint32) << np.uint32(16)
    return widened.view(np.float32)


class FmatmulDataGen(du.DataGen):

    def golden_model(self, a, b):
        return a @ b

    def validate(self, **kwargs):
        prec_bytes = 2 if kwargs['prec'] == 'BF16' else du.size_from_precision_t(kwargs['prec'])
        total_size = (kwargs['m'] * kwargs['k'] + kwargs['k'] * kwargs['n']
                      + kwargs['m'] * kwargs['n']) * prec_bytes
        du.validate_tcdm_footprint(total_size)

    def emit_header(self, **kwargs):
        header = [super().emit_header()]

        self.validate(**kwargs)

        m, n, k = kwargs['m'], kwargs['n'], kwargs['k']
        prec = kwargs['prec']
        is_bf16 = prec == 'BF16'

        if is_bf16:
            ctype = 'uint16_t'
            prec_bytes = 2
            a = fp32_to_bf16_bits(du.generate_random_array((m, k), prec='FP32', seed=42))
            b = fp32_to_bf16_bits(du.generate_random_array((k, n), prec='FP32', seed=42))
            c = fp32_to_bf16_bits(du.generate_random_array((m, n), prec='FP32', seed=42))
            # No BF16 value in the shared `precision_t` enum (layer.h); FP16
            # is only used here as a placeholder of the right byte size --
            # gemm_l.dtype isn't read by this kernel's C or Python code.
            dtype_token = 'FP16'
        else:
            ctype = du.ctype_from_precision_t(prec)
            prec_bytes = du.size_from_precision_t(prec)
            a = du.generate_random_array((m, k), prec=prec, seed=42)
            b = du.generate_random_array((k, n), prec=prec, seed=42)
            c = du.generate_random_array((m, n), prec=prec, seed=42)
            dtype_token = prec

        cfg = {
            'M': m,
            'N': n,
            'K': k,
            'TA': 0,
            'TB': 0,
            'ALPHA': 0,
            'dtype': dtype_token,
            'expand': 0,
        }

        # gemm_layer is defined in the shared layer.h, not generated here.
        # PREC (a preprocessor macro) drives main.c's choice of T and of
        # which precision-specific kernel source it #includes; BF16 defines
        # the additional BF16 macro to pick the alternate-format CSR path
        # within the PREC==16 branch. The plain m/n/k/prec/is_bf16 scalars
        # below are for verify.py, which can't easily unpack fields out of
        # the gemm_l struct directly.
        header += ['#include "layer.h"', f'#define PREC {prec_bytes * 8}']
        if is_bf16:
            header += ['#define BF16']
        header += [du.format_scalar_definition('extern const uint32_t', 'm', m)]
        header += [du.format_scalar_definition('extern const uint32_t', 'n', n)]
        header += [du.format_scalar_definition('extern const uint32_t', 'k', k)]
        header += [du.format_scalar_definition('extern const uint32_t', 'prec', prec_bytes)]
        header += [du.format_scalar_definition('extern const uint32_t', 'is_bf16', int(is_bf16))]
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
