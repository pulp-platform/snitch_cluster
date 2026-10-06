#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

import numpy as np
import sys
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parents[4]
_PACE_SCRIPTS_DIR = Path(__file__).resolve().parent
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

try:
    from snitch.pace.scripts.datatype import PaceDataTypeHelper
    from snitch.pace.scripts.evaluation import PacePWPAPrecision
    from snitch.pace.scripts.execution import PacePWPAExecutionLog, PacePWPAModel
    from snitch.pace.scripts.fit import PacePWPAFit
    from snitch.pace.scripts.golden import PaceActivationRegistry
    from snitch.pace.scripts.partition import PacePartition
except ModuleNotFoundError:
    from datatype import PaceDataTypeHelper
    from evaluation import PacePWPAPrecision
    from execution import PacePWPAExecutionLog, PacePWPAModel
    from fit import PacePWPAFit
    from golden import PaceActivationRegistry
    from partition import PacePartition


class PaceInverseNormalFloatFormat:
    """Normal-number decomposition used by inverse/sqrt/rsqrt preprocessing."""

    def __init__(self, precision):
        self.datatype = PaceDataTypeHelper(precision)

    @property
    def exponent_bits(self):
        return self.datatype.exponent_bits

    @property
    def fraction_bits(self):
        return self.datatype.fraction_bits

    @property
    def exponent_bias(self):
        return self.datatype.exponent_bias

    @property
    def storage_type(self):
        return self.datatype.storage_type

    def decompose(self, values):
        raw = self.datatype.view_bits(values)
        exp_bits = self.exponent_bits
        frac_bits = self.fraction_bits
        sign = (raw >> (exp_bits + frac_bits)) & 0x1
        exp = (raw >> frac_bits) & ((1 << exp_bits) - 1)
        frac = raw & ((1 << frac_bits) - 1)

        if np.any(exp == 0) or np.any(exp == (1 << exp_bits) - 1):
            raise ValueError("Input must be normal & finite")

        exponent = exp.astype(np.int64) - self.exponent_bias
        mantissa = 1.0 + frac.astype(np.float64) / (1 << frac_bits)
        mantissa = np.asarray(mantissa, dtype=self.storage_type)
        return sign, exponent, mantissa

    def compose(self, values, exponent):
        values = np.asarray(values, dtype=np.float64)
        exponent = np.asarray(exponent, dtype=np.int64)
        return np.ldexp(values, exponent)


class PaceInversePreprocessor:
    def __init__(self, precision):
        self.precision = precision
        self.normal_format = PaceInverseNormalFloatFormat(precision)

    def preprocess(self, x):
        raise NotImplementedError


class PaceReciprocalPreprocessor(PaceInversePreprocessor):
    def preprocess(self, x):
        sign, exp, mant = self.normal_format.decompose(x)
        return sign, exp, mant


class PaceSqrtPreprocessor(PaceInversePreprocessor):
    def preprocess(self, x):
        sign, exp, mant = self.normal_format.decompose(x)
        mant = np.where(exp & 1, mant * 2, mant)
        exp = np.where(exp & 1, exp - 1, exp)
        return sign, -(exp // 2), mant


class PaceRsqrtPreprocessor(PaceInversePreprocessor):
    def preprocess(self, x):
        sign, exp, mant = self.normal_format.decompose(x)
        mant = np.where(exp & 1, mant * 2, mant)
        exp = np.where(exp & 1, exp - 1, exp)
        return sign, (exp // 2), mant


class PaceInversePreprocessRegistry:
    PREPROCESSORS = {
        "inv": PaceReciprocalPreprocessor,
        "sqrt": PaceSqrtPreprocessor,
        "rsqrt": PaceRsqrtPreprocessor,
    }

    @classmethod
    def create(cls, fn_name, precision):
        if fn_name not in cls.PREPROCESSORS:
            raise ValueError(f"Unsupported inverse/sqrt function: {fn_name}")
        return cls.PREPROCESSORS[fn_name](precision)


class PaceEpsilonBypass:
    def __init__(self, eps, precision):
        self.eps = eps
        self.precision = precision
        self.datatype = PaceDataTypeHelper(precision)

    def check(self, x):
        numpy_prec = self.datatype.storage_type
        x_prec = (
            PacePWPAPrecision.quantize(x, self.precision)
            if PacePWPAPrecision.is_bf16(self.precision)
            else x.astype(numpy_prec)
        )
        eps_prec = numpy_prec(self.eps)
        return np.abs(x_prec) < eps_prec


class PaceInverseSqrtPostprocessor:
    def __init__(self, precision, eps_const=None):
        self.precision = precision
        self.eps_const = eps_const
        self.normal_format = PaceInverseNormalFloatFormat(precision)

    def compose(self, y, sign, exp):
        y = self.normal_format.compose(y, -exp)
        return np.where(sign == 1, -y, y)

    def apply_epsilon(self, bypass, y):
        return np.where(
            bypass,
            np.where(y > 0, self.eps_const, -self.eps_const),
            y
        )

    def quantize_output(self, y):
        if PacePWPAPrecision.is_bf16(self.precision):
            return PacePWPAPrecision.quantize(y, self.precision)
        return y


class PaceInverseSqrtContext:
    def __init__(self, sign, exp, mant, bypass):
        self.sign = sign
        self.exp = exp
        self.mant = mant
        self.bypass = bypass


class PaceInverseSqrtModel(PacePWPAModel):
    def __init__(self, fn_name, coeffs, bps, degree, eps=1e-6, eps_const=0.0, prec=None):
        PacePWPAModel.__init__(
            self,
            func=PaceActivationRegistry.get(fn_name),
            degree=degree,
            parts=len(bps) - 1,
            precision=(
                prec if PacePWPAPrecision.is_bf16(prec)
                else PaceDataTypeHelper(prec).storage_type
            ),
        )
        self.name = fn_name
        self.fit_data = PacePWPAFit(
            raw_bps=bps,
            bst_bps=PacePartition.build_bst_breakpoints(bps),
            coeffs=coeffs,
        )
        self.eps = eps
        self.eps_const = eps_const
        self.prec = prec
        self.preprocessor = PaceInversePreprocessRegistry.create(fn_name, prec)
        self.epsilon = PaceEpsilonBypass(eps, prec)
        self.postprocessor = PaceInverseSqrtPostprocessor(prec, eps_const)

    def preprocess(self, x):
        x = np.asarray(x)
        bypass = self.epsilon.check(x)
        sign, exp, mant = self.preprocessor.preprocess(x)
        return mant, PaceInverseSqrtContext(sign, exp, mant, bypass), PacePWPAExecutionLog()

    def postprocess(self, y, context):
        y = self.postprocessor.compose(y, context.sign, context.exp)
        y = self.postprocessor.apply_epsilon(context.bypass, y)
        return self.postprocessor.quantize_output(y), PacePWPAExecutionLog()

    def evaluate_input(self, x):
        return self.evaluate(x, self.fit_data).output

    def __str__(self):
        return self.name


class PaceInverseSqrtEvaluator:
    def __init__(self, fn_name, coeffs, bps, degree, eps=1e-6, eps_const=0.0, prec=None):
        self.model = PaceInverseSqrtModel(
            fn_name=fn_name,
            coeffs=coeffs,
            bps=bps,
            degree=degree,
            eps=eps,
            eps_const=eps_const,
            prec=prec,
        )

    def evaluate(self, x):
        return self.model.evaluate_input(x)
