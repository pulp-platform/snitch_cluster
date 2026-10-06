#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PWPA evaluation helpers."""

import numpy as np

try:
    from snitch.pace.scripts.datatype import PaceDataTypeHelper
except ModuleNotFoundError:
    from datatype import PaceDataTypeHelper


class PacePWPAPrecision:
    """Precision-specific quantization used during PWPA evaluation."""

    @staticmethod
    def is_bf16(precision):
        return PaceDataTypeHelper.is_bf16_precision(precision)

    @staticmethod
    def bf16_bits(values):
        return PaceDataTypeHelper.bf16_bits(values)

    @staticmethod
    def quantize(values, precision):
        return PaceDataTypeHelper.quantize_values(values, precision)


class PacePWPAEvaluator:
    """Evaluate a fitted PWPA polynomial for scalar or vector inputs."""

    def __init__(self, degree, precision):
        self.degree = degree
        self.precision = precision

    def evaluate_scalar(self, ifmap, coeffs, part_id, return_details=False):
        feat_prec = PacePWPAPrecision.quantize(ifmap, self.precision)
        feat = np.asarray(feat_prec, dtype=np.float64).item()
        coeffs_prec = PacePWPAPrecision.quantize(coeffs, self.precision)
        coeffs_fp64 = np.asarray(coeffs_prec, dtype=np.float64)
        coeffs_part = coeffs_fp64[int(part_id)]
        y = coeffs_part[self.degree]
        details = []

        for deg in range(self.degree - 1, -1, -1):
            y_before = PacePWPAPrecision.quantize(y, self.precision)
            coeff_val = PacePWPAPrecision.quantize(coeffs_part[deg], self.precision)
            y = y * feat + coeffs_part[deg]
            y = PacePWPAPrecision.quantize(y, self.precision).astype(np.float64)
            if return_details:
                details.append(
                    {
                        "step": self.degree - deg - 1,
                        "y_before": y_before.item(),
                        "x": (
                            feat_prec.item()
                            if np.asarray(feat_prec).shape == ()
                            else feat_prec
                        ),
                        "coeff": coeff_val.item(),
                        "y_after": PacePWPAPrecision.quantize(
                            y, self.precision
                        ).item(),
                    }
                )

        ofmap = PacePWPAPrecision.quantize(y, self.precision)
        if return_details:
            return ofmap, details
        return ofmap

    def evaluate(self, ifmap, coeffs, part_id):
        ifmap_prec = PacePWPAPrecision.quantize(ifmap, self.precision)
        ofmap = np.zeros_like(
            ifmap_prec,
            dtype=(
                np.float32
                if PacePWPAPrecision.is_bf16(self.precision)
                else self.precision
            ),
        )

        for idx, feat in enumerate(ifmap_prec):
            ofmap[idx] = self.evaluate_scalar(
                feat, coeffs, part_id[idx], return_details=False
            )
        return ofmap
