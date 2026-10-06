#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

import argparse
from pathlib import Path
import sys
import numpy as np

_REPO_ROOT = Path(__file__).resolve().parents[4]
_PACE_SCRIPTS_DIR = Path(__file__).resolve().parent
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

try:
    from snitch.pace.scripts.config import PaceConfig
    from snitch.pace.scripts.config_loader import PaceJsonConfigLoader
    from snitch.pace.scripts.datatype import PacePrecisionCodec
    from snitch.pace.scripts.debug import (
        PacePWPADebugListBuilder,
        PacePWPADebugWriter,
        PacePWPADebugPlotter,
    )
    from snitch.pace.scripts.execution import PacePWPAExecutionFactory
    from snitch.pace.scripts.fit import PacePWPACoefficientFitter, PacePWPAFit
    from snitch.pace.scripts.golden import PaceActivationRegistry, PaceGoldenReference
    from snitch.pace.scripts.header_defines import PaceBreakpointModeDefines
    from snitch.pace.scripts.instruction import PaceInstructionSet
    from snitch.pace.scripts.invert import PaceInverseSqrtModel
    from snitch.pace.scripts.parameter_packing import PaceParameterPacker
    from snitch.pace.scripts.partition import PacePartition, PacePartitionGenerator
except ModuleNotFoundError:
    from config import PaceConfig
    from config_loader import PaceJsonConfigLoader
    from datatype import PacePrecisionCodec
    from debug import (
        PacePWPADebugListBuilder,
        PacePWPADebugWriter,
        PacePWPADebugPlotter,
    )
    from execution import PacePWPAExecutionFactory
    from fit import PacePWPACoefficientFitter, PacePWPAFit
    from golden import PaceActivationRegistry, PaceGoldenReference
    from header_defines import PaceBreakpointModeDefines
    from instruction import PaceInstructionSet
    from invert import PaceInverseSqrtModel
    from parameter_packing import PaceParameterPacker
    from partition import PacePartition, PacePartitionGenerator

try:
    from snitch.util.sim.data_utils import (
        emit_license,
        format_array_declaration,
        format_array_definition,
    )
except ModuleNotFoundError:
    from util.sim.data_utils import (
        emit_license,
        format_array_declaration,
        format_array_definition,
    )

PACE_EXECUTION_ALIASES = {
    "vector": "VECTOR",
    "v": "VECTOR",
    "ssr": "VECTOR",
    "vector_ssr": "VECTOR",
    "scalar": "SCALAR",
    "s": "SCALAR",
}


class PaceElementwiseFunction:
    bounds = (None, None)
    mode_name = "pwpa"

    def __init__(self, name):
        self.name = name

    def bounded_range(self, x_min, x_max):
        min_bound, max_bound = self.bounds
        return (
            x_min if min_bound is None else min_bound,
            x_max if max_bound is None else max_bound,
        )

    def eps_const(self, eps):
        return None

    def evaluate(self, ifmap, coeffs, raw_bps, bst_bps, degree, model_prec, eps, eps_const, prec):
        model = PacePWPAExecutionFactory.create(
            func=PaceActivationRegistry.get(self.name),
            degree=degree,
            parts=len(raw_bps) - 1,
            precision=model_prec,
        )
        fit = PacePWPAFit(raw_bps=raw_bps, bst_bps=bst_bps, coeffs=coeffs)
        return model.evaluate(ifmap, fit).output


class PaceInverseElementwiseFunction(PaceElementwiseFunction):
    mode_name = None

    def __init__(self, name):
        PaceElementwiseFunction.__init__(self, name)
        self.mode_name = name

    def eps_const(self, eps):
        return PaceActivationRegistry.evaluate(self.name, eps)

    def evaluate(self, ifmap, coeffs, raw_bps, bst_bps, degree, model_prec, eps, eps_const, prec):
        return PaceInverseSqrtModel(
            fn_name=self.name,
            coeffs=coeffs,
            bps=raw_bps,
            degree=degree,
            eps=eps,
            eps_const=eps_const,
            prec=prec,
        ).evaluate_input(ifmap)


class PaceElementwiseFunctionRegistry:
    FUNCTIONS = {
        "silu": (PaceElementwiseFunction, (None, None)),
        "exp": (PaceElementwiseFunction, (None, None)),
        "gelu": (PaceElementwiseFunction, (None, None)),
        "inv": (PaceInverseElementwiseFunction, (1, 2)),
        "sqrt": (PaceInverseElementwiseFunction, (1, 4)),
        "rsqrt": (PaceInverseElementwiseFunction, (1, 4)),
    }

    @classmethod
    def create(cls, name):
        if name not in cls.FUNCTIONS:
            raise ValueError(f"Unsupported elementwise function: {name}")
        function_cls, bounds = cls.FUNCTIONS[name]
        function = function_cls(name)
        function.bounds = bounds
        return function


class PaceElementwiseApproximationConfig:
    def __init__(
        self,
        function,
        codec,
        numpy_type,
        model_prec,
        x_min,
        x_max,
        n_part,
        n_deg,
        n_test,
        eps,
        eps_const,
        seed=None,
        bp_mode="nonuniform",
    ):
        self.function = function
        self.codec = codec
        self.numpy_type = numpy_type
        self.model_prec = model_prec
        self.x_min = x_min
        self.x_max = x_max
        self.n_part = n_part
        self.n_deg = n_deg
        self.n_test = n_test
        self.eps = eps
        self.eps_const = eps_const
        self.seed = seed
        self.bp_mode = bp_mode


class PaceElementwiseApproximationResult:
    def __init__(self, ifmap, golden, pwpa, raw_bps, bst_bps, coeffs, traces=None):
        self.ifmap = ifmap
        self.golden = golden
        self.pwpa = pwpa
        self.raw_bps = raw_bps
        self.bst_bps = bst_bps
        self.coeffs = coeffs
        self.traces = traces


class PaceElementwiseApproximation:
    def __init__(self, config):
        self.config = config

    @property
    def codec(self):
        return self.config.codec

    @property
    def function(self):
        return self.config.function

    def breakpoints(self):
        min_bound, max_bound = self.function.bounded_range(
            self.config.x_min, self.config.x_max
        )
        raw_bps = PacePartitionGenerator(
            self.config.n_part, self.config.bp_mode,
            precision=self.config.model_prec,
        ).raw_breakpoints(min_bound, max_bound)
        raw_bps = self.codec.quantize_model_values(raw_bps)
        partition = PacePartition(raw_bps, precision=self.config.model_prec)
        return partition.breakpoints, partition.bst_breakpoints

    def coefficients(self, raw_bps):
        coeffs = PacePWPACoefficientFitter(
            degree=self.config.n_deg,
            func=PaceActivationRegistry.get(self.function.name),
        ).fit(raw_bps)
        return self.codec.quantize_model_values(coeffs)

    def inputs(self):
        ifmap = np.linspace(self.config.x_min, self.config.x_max, self.config.n_test)
        np.random.default_rng(self.config.seed).shuffle(ifmap)
        ifmap = np.asarray(ifmap, dtype=self.config.numpy_type)
        return self.codec.quantize_model_values(ifmap)

    def golden(self, ifmap):
        golden = PaceGoldenReference().evaluate(ifmap, self.function.name)
        return self.codec.quantize_model_values(golden)

    def approximation(self, ifmap, coeffs, raw_bps, bst_bps):
        return self.function.evaluate(
            ifmap,
            coeffs,
            raw_bps,
            bst_bps,
            self.config.n_deg,
            self.config.model_prec,
            self.config.eps,
            self.config.eps_const,
            self.codec.algo_precision(),
        )

    def traced_approximation(self, ifmap, golden, coeffs, bst_bps):
        return PacePWPADebugListBuilder(
            degree=self.config.n_deg,
            prec=self.codec.algo_precision(),
            np_prec=self.config.model_prec,
            fn_name=self.function.name,
            eps=self.config.eps,
            eps_const=self.config.eps_const,
        ).evaluate(ifmap, golden, coeffs, bst_bps)

    def evaluate(self):
        raw_bps, bst_bps = self.breakpoints()
        coeffs = self.coefficients(raw_bps)
        ifmap = self.inputs()
        golden = self.golden(ifmap)
        pwpa, traces = self.traced_approximation(ifmap, golden, coeffs, bst_bps)
        return PaceElementwiseApproximationResult(
            ifmap=ifmap,
            golden=golden,
            pwpa=pwpa,
            raw_bps=raw_bps,
            bst_bps=bst_bps,
            coeffs=coeffs,
            traces=traces,
        )


class PaceElementwiseHeaderDefines:
    def __init__(self, keys):
        self.keys = keys

    def mode_name(self):
        fn_name = self.keys.get("fn_name")
        mode_name = PaceElementwiseFunctionRegistry.create(fn_name).mode_name
        explicit_modes = [
            name for name in ("inv", "sqrt", "rsqrt") if self.keys.get(name, False)
        ]
        if len(explicit_modes) > 1:
            raise ValueError(
                "PACE config can enable only one of inv/sqrt/rsqrt at a time, "
                f"got {explicit_modes}"
            )
        if explicit_modes and explicit_modes[0] != mode_name:
            raise ValueError(
                f"fn_name selects '{mode_name}' but legacy mode flag selects "
                f"'{explicit_modes[0]}'. Please keep them consistent or remove "
                "the legacy flag."
            )
        return mode_name

    def instruction_defines(self):
        codec = PacePrecisionCodec(self.keys["prec"], self.keys["super_fmt"])
        return PaceInstructionSet(
            self.mode_name(), codec, extend=self.keys["extend"]
        ).elementwise_defines()

    def execution_mode(self):
        execution = str(
            self.keys.get("execution", self.keys.get("exec_mode", "vector"))
        ).strip().lower()
        if execution not in PACE_EXECUTION_ALIASES:
            raise ValueError(
                f"Unsupported elementwise execution mode '{execution}'. "
                "Expected 'vector' or 'scalar'."
            )
        return PACE_EXECUTION_ALIASES[execution]

    def execution_defines(self):
        execution = self.execution_mode()
        return [
            f"#define PACE_EXEC_VECTOR {int(execution == 'VECTOR')}",
            f"#define PACE_EXEC_SCALAR {int(execution == 'SCALAR')}",
        ]

    def breakpoint_defines(self, bp_mode):
        return PaceBreakpointModeDefines(bp_mode).defines()


class PaceElementwiseDebugConfig:
    def __init__(
        self,
        debug_fname,
        debug_plot,
        degree,
        precision,
        model_prec,
        fn_name,
        eps,
        eps_const,
    ):
        self.debug_fname = debug_fname
        self.debug_plot = debug_plot
        self.degree = degree
        self.precision = precision
        self.model_prec = model_prec
        self.fn_name = fn_name
        self.eps = eps
        self.eps_const = eps_const


class PaceElementwiseDebugWriter:
    def __init__(self, config):
        self.config = config

    def traces(self, result):
        if result.traces is not None:
            return result.traces
        c = self.config
        return PacePWPADebugListBuilder(
            degree=c.degree,
            prec=c.precision,
            np_prec=c.model_prec,
            fn_name=c.fn_name,
            eps=c.eps,
            eps_const=c.eps_const,
        ).build(result.ifmap, result.golden, result.coeffs, result.bst_bps)

    def plot(self, result):
        c = self.config
        PacePWPADebugPlotter(
            c.debug_plot,
            fn_name=c.fn_name,
            breakpoints=result.raw_bps,
        ).write(result.ifmap, result.golden, result.pwpa)

    def file(self, result, traces):
        c = self.config
        PacePWPADebugWriter(c.debug_fname, c.model_prec).write(
            result.raw_bps,
            result.bst_bps,
            result.coeffs,
            traces,
        )

    def write(self, result):
        traces = self.traces(result)
        self.plot(result)
        self.file(result, traces)


class PaceElementwiseKernel:
    def __init__(self, **kwargs):
        self.kwargs = kwargs
        self.config = PaceConfig.from_mapping(kwargs)
        self.prec = self.config.prec
        self.codec = self.config.codec
        self.ctype = self.config.c_type
        self.numpy_type = self.config.numpy_type
        self.fpu_data_width = self.config.fpu_data_width
        self.lane_count = self.config.lane_count
        self.hex_ctype = self.config.hex_c_type
        self.fn_name = self.config.function_type
        self.x_min = self.config.x_min
        self.x_max = self.config.x_max
        self.n_deg = self.config.n_deg
        self.n_part = self.config.n_part
        self.n_test = self.config.n_test
        self.debug_fname = self.config.debug_fname
        self.debug_plot = self.config.debug_plot
        self.super_fmt = self.config.super_fmt
        self.eps = self.config.eps
        self.seed = self.config.seed
        self.bp_mode = self.config.bp_mode
        self.function = PaceElementwiseFunctionRegistry.create(self.fn_name)
        self.param_hex_ctype = self.config.param_hex_c_type
        self.eps_const = self.function.eps_const(self.eps)
        self.model_prec = self.config.model_precision
        self.approximation = PaceElementwiseApproximation(
            PaceElementwiseApproximationConfig(
                function=self.function,
                codec=self.codec,
                numpy_type=self.numpy_type,
                model_prec=self.model_prec,
                x_min=self.x_min,
                x_max=self.x_max,
                n_part=self.n_part,
                n_deg=self.n_deg,
                n_test=self.n_test,
                eps=self.eps,
                eps_const=self.eps_const,
                seed=self.seed,
                bp_mode=self.bp_mode,
            )
        )
        self.defines = PaceElementwiseHeaderDefines(kwargs)
        self.debug_writer = PaceElementwiseDebugWriter(
            PaceElementwiseDebugConfig(
                debug_fname=self.debug_fname,
                debug_plot=self.debug_plot,
                degree=self.n_deg,
                precision=self.codec.algo_precision(),
                model_prec=self.model_prec,
                fn_name=self.fn_name,
                eps=self.eps,
                eps_const=self.eps_const,
            )
        )

    def run_model(self):
        return self.approximation.evaluate()

    def write_debug(self, result):
        self.debug_writer.write(result)

    def pack_params(self, bst_bps, coeffs):
        eps_const = self.eps_const
        if (
            not self.codec.is_bf16_precision(self.prec)
            and self.numpy_type != np.float16
            and eps_const is None
        ):
            eps_const = np.nan
        params = PaceParameterPacker(
            self.codec, numpy_type=self.numpy_type, super_fmt=self.super_fmt
        ).pack(bst_bps[2:], coeffs, eps=self.eps, eps_const=eps_const)
        return np.asarray(params, dtype=np.uint32)

    def storage_values(self, values):
        return self.codec.storage_values(values, self.numpy_type)

    def build_header(self, ifmap, ofmap, golden, ofmap_init, params):
        ifmap_uid = "ifmap"
        ofmap_uid = "ofmap"
        params_uid = "params"

        data_str = [
            emit_license(),
            "#ifndef PACE_ELEMENTWISE_DATA_H\n#define PACE_ELEMENTWISE_DATA_H",
        ]

        data_str += self.defines.instruction_defines()
        data_str += self.defines.execution_defines()
        data_str += self.defines.breakpoint_defines(self.bp_mode)
        data_str += [f"#define PACE_DEGREE {self.n_deg}"]
        data_str += [f"#define ENABLE_{str(self.prec).upper()} 1"]
        data_str += [f"#define FPU_DATA_WIDTH {self.fpu_data_width}"]
        data_str += [f"#define PACE_LANES {self.lane_count}"]
        data_str += [f"#define INPUTS_LEN {self.n_test}"]
        data_str += [f"#define PARAMS_LEN {len(params)}"]
        data_str += [f"typedef {self.hex_ctype} data_t;"]
        data_str += [f"typedef {self.param_hex_ctype} param_t;"]
        # Array forward declarations
        data_str += [
            format_array_declaration(
                f"extern {self.hex_ctype}", ifmap_uid, ifmap.shape, alignment=4096
            )
        ]
        data_str += [
            format_array_declaration(
                f"extern {self.hex_ctype}", ofmap_uid, ofmap.shape, alignment=4096
            )
        ]

        # Parameter definitions
        data_str += [
            format_array_definition(
                self.param_hex_ctype, params_uid, params, alignment=64,
                hex_format=True
            )
        ]
        # Input definitions
        data_str += [
            format_array_definition(
                self.ctype, ifmap_uid, ifmap, alignment=4096, hex_format=True
            )
        ]
        # Output storage populated by the kernel at runtime
        data_str += [
            format_array_definition(
                self.ctype, ofmap_uid, ofmap_init, alignment=4096,
                hex_format=True
            )
        ]
        # Golden results for BIST
        data_str += [
            format_array_definition(
                self.ctype, "golden", golden, alignment=4096, hex_format=True
            )
        ]
        data_str += ["#endif"]
        return "\n\n".join(data_str)

    def emit_header(self):
        result = self.run_model()
        self.write_debug(result)
        params = self.pack_params(result.bst_bps, result.coeffs)
        ifmap = self.storage_values(result.ifmap)
        ofmap = self.storage_values(result.pwpa)
        golden = self.storage_values(result.pwpa)
        ofmap_init = np.zeros_like(ofmap)

        return self.build_header(ifmap, ofmap, golden, ofmap_init, params)


class PaceElementwiseDataGenerator:
    @staticmethod
    def emit_header(**kwargs):
        return PaceElementwiseKernel(**kwargs).emit_header()


class PaceElementwiseDatagenCLI:
    def parser(self):
        parser = argparse.ArgumentParser()
        parser.add_argument(
            "-c",
            "--cfg",
            type=Path,
            required=True,
            help="Select param config file kernel",
        )
        parser.add_argument(
            "--section",
            type=str,
            help="Section to store matrices in",
        )
        parser.add_argument(
            "output",
            type=Path,
            help="Path of the output header file",
        )
        return parser

    def load_params(self, args):
        param = PaceJsonConfigLoader.load(args.cfg)
        param["debug_fname"] = args.output.parent / param["debug_fname"]
        param["debug_plot"] = args.output.parent / "debug.pdf"
        param["section"] = args.section
        param["name"] = args.output.stem
        return param

    def run(self, argv=None):
        args = self.parser().parse_args(argv)
        param = self.load_params(args)
        with args.output.open("w") as f:
            f.write(PaceElementwiseDataGenerator.emit_header(**param))


if __name__ == "__main__":
    PaceElementwiseDatagenCLI().run()
