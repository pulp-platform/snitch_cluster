#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE configuration objects."""

from pathlib import Path
import sys

_REPO_ROOT = Path(__file__).resolve().parents[4]
if str(_REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(_REPO_ROOT))

try:
    from snitch.util.sim import data_utils
    from snitch.util.sim.data_utils import _integer_precision_t
    from snitch.pace.scripts.datatype import PaceDataTypeHelper, PacePrecisionCodec
except ModuleNotFoundError:
    from util.sim import data_utils
    from util.sim.data_utils import _integer_precision_t
    from datatype import PaceDataTypeHelper, PacePrecisionCodec


class PaceConfig:
    """Canonical PACE configuration shared by generators and executors."""

    def __init__(
        self,
        prec,
        n_deg,
        n_part,
        eps,
        function_type=None,
        x_min=None,
        x_max=None,
        bp_mode="nonuniform",
        super_fmt="FP32",
        fpu_data_width=64,
        n_test=None,
        seed=None,
        execution="vector",
        layout="row-major",
        softmax_unroll=8,
        num_cores=1,
        rows=None,
        seq_len=None,
        exp_approx=None,
        frac_approx=None,
        output_dir=None,
        section=None,
        name=None,
        debug_fname=None,
        debug_plot=None,
        extend=False,
        extra=None,
    ):
        self.prec = prec
        self.n_deg = n_deg
        self.n_part = n_part
        self.eps = eps
        self.function_type = function_type
        self.fn_name = function_type
        self.x_min = x_min
        self.x_max = x_max
        self.bp_mode = bp_mode
        self.super_fmt = super_fmt
        self.fpu_data_width = fpu_data_width
        self.n_test = n_test
        self.seed = seed
        self.execution = execution
        self.layout = layout
        self.softmax_unroll = int(softmax_unroll)
        self.num_cores = int(num_cores)
        self.rows = rows
        self.seq_len = seq_len
        self.q_size = rows
        self.k_size = seq_len
        self.exp_approx = exp_approx
        self.frac_approx = frac_approx
        self.output_dir = output_dir
        self.section = section
        self.name = name
        self.debug_fname = debug_fname
        self.debug_plot = debug_plot
        self.extend = bool(extend)
        self.extra = dict(extra or {})
        self.datatype = PaceDataTypeHelper.from_config(self)
        self.codec = self.datatype.codec

    @classmethod
    def from_mapping(cls, values):
        rows = values.get("rows", values.get("Q"))
        seq_len = values.get("seq_len", values.get("K"))
        function_type = values.get("function_type", values.get("fn_name"))
        known = {
            "prec", "n_deg", "n_part", "eps", "function_type", "fn_name",
            "x_min", "x_max", "bp_mode", "super_fmt", "fpu_data_width",
            "n_test", "seed", "execution", "exec_mode", "layout",
            "softmax_unroll", "num_cores", "rows", "Q", "seq_len", "K",
            "exp", "frac", "output_dir", "section", "name", "debug_fname",
            "debug_plot", "extend",
        }
        extra = {key: val for key, val in values.items() if key not in known}
        return cls(
            prec=values["prec"],
            n_deg=values["n_deg"],
            n_part=values["n_part"],
            eps=values["eps"],
            function_type=function_type,
            x_min=values.get("x_min"),
            x_max=values.get("x_max"),
            bp_mode=values.get("bp_mode", "nonuniform"),
            super_fmt=values.get("super_fmt", "FP32"),
            fpu_data_width=values.get("fpu_data_width", 64),
            n_test=values.get("n_test"),
            seed=values.get("seed"),
            execution=values.get("execution", values.get("exec_mode", "vector")),
            layout=values.get("layout", "row-major"),
            softmax_unroll=values.get("softmax_unroll", 8),
            num_cores=values.get("num_cores", 1),
            rows=rows,
            seq_len=seq_len,
            exp_approx=values.get("exp"),
            frac_approx=values.get("frac"),
            output_dir=values.get("output_dir"),
            section=values.get("section"),
            name=values.get("name"),
            debug_fname=values.get("debug_fname"),
            debug_plot=values.get("debug_plot"),
            extend=values.get("extend", False),
            extra=extra,
        )

    @property
    def numpy_type(self):
        return self.datatype.numpy_type

    @property
    def model_precision(self):
        return self.datatype.model_precision

    @property
    def c_type(self):
        return self.datatype.c_type

    @property
    def hex_c_type(self):
        return self.datatype.hex_c_type

    @property
    def lane_count(self):
        return self.datatype.lane_count

    @property
    def param_precision(self):
        if PacePrecisionCodec.is_alt_half_format(self.super_fmt):
            return "FP16"
        return self.super_fmt

    @property
    def param_hex_c_type(self):
        return data_utils.hex_ctype_from_precision_t(
            _integer_precision_t(self.param_precision)
        )

    def require_range(self):
        if self.x_min is None or self.x_max is None:
            raise ValueError("PACE config requires x_min and x_max for this operation")
        return self.x_min, self.x_max
