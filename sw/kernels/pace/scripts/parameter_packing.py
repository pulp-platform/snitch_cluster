#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE parameter packing for generated headers."""


class PaceParameterPacker:
    """Pack coefficients, breakpoints, and epsilon constants as PACE params."""

    def __init__(self, codec, numpy_type=None, super_fmt=None):
        self.codec = codec
        self.numpy_type = numpy_type if numpy_type is not None else codec.numpy_type()
        self.super_fmt = codec.super_fmt if super_fmt is None else super_fmt

    def _append_coeff(self, params, coeff):
        params.append(self.codec.encode_coeff(coeff))

    def _append_breakpoint(self, params, bp):
        params.append(self.codec.encode_breakpoint(bp))

    def _append_eps(self, params, eps, eps_const):
        params.extend(self.codec.encode_eps_values(eps, eps_const))

    def pack(self, bst_bps, coeffs, eps=10**-6, eps_const=0):
        params = []
        rows, cols = coeffs.shape
        for deg in range(cols):
            coeff_idx = cols - 1 - deg
            for bp_idx in range(rows):
                self._append_coeff(params, coeffs[bp_idx, coeff_idx])
        for bp in bst_bps:
            self._append_breakpoint(params, bp)
        self._append_eps(params, eps, eps_const)
        return params
