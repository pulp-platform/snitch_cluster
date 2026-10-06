#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PWPA fitting objects."""

import numpy as np

try:
    from snitch.pace.scripts.partition import PacePartition
except ModuleNotFoundError:
    from partition import PacePartition


class PacePWPAFit:
    """Fitted PWPA model data: partition plus per-partition coefficients."""

    def __init__(self, raw_bps, bst_bps, coeffs, partition=None):
        self.raw_bps = raw_bps
        self.bst_bps = bst_bps
        self.coeffs = coeffs
        self.partition = partition

    @classmethod
    def from_partition(cls, partition, coeffs):
        return cls(
            raw_bps=partition.breakpoints,
            bst_bps=partition.bst_breakpoints,
            coeffs=coeffs,
            partition=partition,
        )

    def partition_for_precision(self, precision):
        if self.partition is not None and self.partition.precision == precision:
            return self.partition
        return PacePartition(self.raw_bps, self.bst_bps, precision=precision)

    def __str__(self):
        return (
            f"pwpa_fit(parts={len(self.raw_bps) - 1}, "
            f"degree={self.coeffs.shape[1] - 1})"
        )


class PacePWPACoefficientFitter:
    """Fit per-partition polynomial coefficients."""

    def __init__(self, degree, func, num_samples=1000):
        self.degree = degree
        self.func = func
        self.num_samples = num_samples

    def fit(self, partition_or_bps):
        if isinstance(partition_or_bps, PacePartition):
            bps = partition_or_bps.breakpoints
        else:
            bps = partition_or_bps
        num_parts = len(bps) - 1
        coeffs = np.zeros((num_parts, self.degree + 1))
        for part in range(num_parts):
            left = bps[part]
            right = bps[part + 1]
            xs = np.linspace(left, right, self.num_samples)
            ys = self.func(xs)
            p = np.polyfit(xs, ys, deg=self.degree)
            coeffs[part] = p[::-1]
        return coeffs

    def __str__(self):
        return f"coefficients(degree={self.degree}, samples={self.num_samples})"


class PacePWPAFitBuilder:
    """Build a full PacePWPAFit from an existing PacePartition."""

    def __init__(self, degree, func, num_samples=1000):
        self.fitter = PacePWPACoefficientFitter(degree, func, num_samples)

    def fit(self, partition):
        return PacePWPAFit.from_partition(partition, self.fitter.fit(partition))
