#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PWPA execution objects."""

import numpy as np

try:
    from snitch.pace.scripts.evaluation import PacePWPAEvaluator
    from snitch.pace.scripts.fit import PacePWPAFitBuilder
    from snitch.pace.scripts.partition import PacePartition, PacePartitionGenerator
except ModuleNotFoundError:
    from evaluation import PacePWPAEvaluator
    from fit import PacePWPAFitBuilder
    from partition import PacePartition, PacePartitionGenerator


class PacePWPAExecutionLog:
    def __init__(self, entries=None):
        self.entries = [] if entries is None else list(entries)

    def add(self, stage, message):
        self.entries.append((stage, message))

    def extend(self, other):
        if other is not None:
            self.entries.extend(other.entries)

    def __str__(self):
        return "\n".join(f"[{stage}] {message}" for stage, message in self.entries)


class PacePWPAResult:
    def __init__(self, output, fit, part_id=None, log=None):
        self.output = output
        self.fit = fit
        self.part_id = part_id
        self.log = PacePWPAExecutionLog() if log is None else log

    def __str__(self):
        return str(self.log)


class PacePWPAModel:
    name = "pwpa"

    def __init__(self, func, degree, parts=None, bp_mode="nonuniform", precision=np.float64):
        self.func = func
        self.degree = degree
        self.parts = parts
        self.bp_mode = bp_mode
        self.precision = precision

    def preprocess(self, x):
        return x, None, PacePWPAExecutionLog()

    def postprocess(self, y, context):
        return y, PacePWPAExecutionLog()

    def breakpoints(self, xmin, xmax):
        return PacePartitionGenerator(self.parts, self.bp_mode).raw_breakpoints(xmin, xmax)

    def fit(self, bps):
        partition = PacePartition(bps, precision=self.precision)
        return PacePWPAFitBuilder(self.degree, self.func).fit(partition)

    def partition(self, ifmap, fit):
        return fit.partition_for_precision(self.precision).bst_part_id(ifmap)

    def evaluate_piecewise(self, ifmap, fit, part_id):
        return PacePWPAEvaluator(self.degree, self.precision).evaluate(
            ifmap, fit.coeffs, part_id
        )

    def evaluate(self, ifmap, fit):
        log = PacePWPAExecutionLog()
        model_input, context, pre_log = self.preprocess(ifmap)
        log.extend(pre_log)
        part_id = self.partition(model_input, fit)
        pwpa_output = self.evaluate_piecewise(model_input, fit, part_id)
        output, post_log = self.postprocess(pwpa_output, context)
        log.extend(post_log)
        return PacePWPAResult(output=output, fit=fit, part_id=part_id, log=log)

    def __str__(self):
        return self.name


class PacePWPAExecutionBase(PacePWPAModel):
    """Common PWPA execution skeleton shared by datatype-specialized executors."""

    datatype_name = "generic"

    def __str__(self):
        return f"{self.datatype_name}:{self.name}"


class PaceFP32PWPAExecution(PacePWPAExecutionBase):
    datatype_name = "FP32"


class PaceFP16PWPAExecution(PacePWPAExecutionBase):
    datatype_name = "FP16"


class PaceBF16PWPAExecution(PacePWPAExecutionBase):
    datatype_name = "BFP16"


class PacePWPAExecutionFactory:
    EXECUTORS = {
        "FP32": PaceFP32PWPAExecution,
        "FP16": PaceFP16PWPAExecution,
        "BF16": PaceBF16PWPAExecution,
        "BFP16": PaceBF16PWPAExecution,
        "BFLOAT16": PaceBF16PWPAExecution,
    }

    @classmethod
    def create(cls, func, degree, parts=None, bp_mode="nonuniform", precision=np.float64):
        if isinstance(precision, str):
            key = precision.upper()
        else:
            key = np.dtype(precision).name.upper()
        if key == "FLOAT32":
            key = "FP32"
        elif key == "FLOAT16":
            key = "FP16"
        elif key == "FLOAT64":
            key = "FP64"
        executor_cls = cls.EXECUTORS.get(key, PacePWPAExecutionBase)
        return executor_cls(
            func=func,
            degree=degree,
            parts=parts,
            bp_mode=bp_mode,
            precision=precision,
        )
