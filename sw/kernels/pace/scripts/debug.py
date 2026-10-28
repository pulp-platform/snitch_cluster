#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

import sys
from pathlib import Path

import numpy as np
try:
    import torch
except ModuleNotFoundError:
    torch = None
try:
    import matplotlib.pyplot as plt
except ModuleNotFoundError:
    plt = None

_REPO_ROOT = Path(__file__).resolve().parents[4]
_PACE_SCRIPTS_DIR = Path(__file__).resolve().parent
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

try:
    from snitch.pace.scripts.evaluation import PacePWPAPrecision, PacePWPAEvaluator
except ModuleNotFoundError:
    from evaluation import PacePWPAPrecision, PacePWPAEvaluator
try:
    from snitch.pace.scripts.invert import (
        PaceInversePreprocessRegistry,
        PaceInverseSqrtPostprocessor,
    )
except ModuleNotFoundError:
    from invert import PaceInversePreprocessRegistry, PaceInverseSqrtPostprocessor
try:
    from snitch.pace.scripts.partition import PacePartition
except ModuleNotFoundError:
    from partition import PacePartition


class PaceDebugFormatter:
    @staticmethod
    def float_to_hex(v, prec):
        if prec == np.float64:
            arr = np.asarray(v, dtype=np.float64)
            bits = arr.view(np.uint64).item()
            return f"0x{bits:016X}"
        if prec == np.float32:
            arr = np.asarray(v, dtype=np.float32)
            bits = arr.view(np.uint32).item()
            return f"0x{bits:08X}"
        if prec == np.float16:
            arr = np.asarray(v, dtype=np.float16)
            bits = arr.view(np.uint16).item()
            return f"0x{bits:04X}"
        if PacePWPAPrecision.is_bf16(prec):
            f32 = np.asarray(v, dtype=np.float32)
            bits32 = f32.view(np.uint32).item()
            bf16 = (bits32 >> 16) & 0xFFFF
            return f"0x{bf16:04X}"
        raise ValueError(f"Unsupported precision: {prec}")

    @staticmethod
    def precision_label(prec):
        if prec == np.float64:
            return "FP64"
        if prec == np.float32:
            return "FP32"
        if prec == np.float16:
            return "FP16"
        if PacePWPAPrecision.is_bf16(prec):
            return "BF16"
        return str(prec)

    @staticmethod
    def clean_value(v):
        if isinstance(v, (list, tuple)):
            return [PaceDebugFormatter.clean_value(x) for x in v]
        if isinstance(v, np.ndarray):
            return v.astype(float).tolist()
        try:
            return float(v)
        except Exception:
            return v


class PaceSoftmaxTraceBuilder:
    def __init__(self, dtype=np.float64):
        self.dtype = dtype

    def offset_xmax(self, attn, xmax):
        Q, K = attn.shape
        attn = np.asarray(attn, dtype=self.dtype)
        attn = np.asarray(attn, dtype=np.float64)
        attn = np.asarray(attn, dtype=self.dtype)
        xmax = np.asarray(xmax, dtype=np.float64)
        trace = []
        attn_oup = np.asarray(attn, dtype=np.float64)
        for q in range(Q):
            for k in range(K):
                attn_oup[q, k] = attn[q, k] - xmax[q]
                trace.append(
                    f"[{q},{k}]\n"
                    f"inp={PaceDebugFormatter.float_to_hex(attn[q, k], self.dtype)}\n"
                    f"max={PaceDebugFormatter.float_to_hex(xmax[q], self.dtype)}\n"
                    f"oup={PaceDebugFormatter.float_to_hex(attn_oup[q, k], self.dtype)}\n"
                )
        return trace


class PacePWPADebugPlotter:
    def __init__(self, filename, fn_name="function", breakpoints=None):
        self.filename = filename
        self.fn_name = fn_name
        self.breakpoints = breakpoints

    def write(self, ifmap, golden_ofmap, pwpa_ofmap):
        if plt is None:
            return
        label = str(self.fn_name).upper()
        fig, ax = plt.subplots(figsize=(10, 6))
        ax.scatter(
            ifmap, golden_ofmap, label=f"{label} (golden)", color="blue", s=0.5
        )
        ax.scatter(
            ifmap, pwpa_ofmap, label=f"{label} (PWPA)", color="red", s=0.5,
            marker="d"
        )

        x_min, x_max = ax.get_xlim()
        if self.breakpoints is not None:
            bp_arr = np.asarray(self.breakpoints, dtype=np.float64)
            bp_arr = bp_arr[np.isfinite(bp_arr)]
            visible_bps = bp_arr[(bp_arr >= x_min) & (bp_arr <= x_max)]
            if visible_bps.size:
                order = np.argsort(ifmap)
                marker_y = np.interp(
                    visible_bps,
                    np.asarray(ifmap, dtype=np.float64)[order],
                    np.asarray(pwpa_ofmap, dtype=np.float64)[order],
                )
                ax.scatter(
                    visible_bps,
                    marker_y,
                    label="Breakpoints",
                    color="black",
                    marker="^",
                    s=32,
                    linewidths=0.9,
                    alpha=0.9,
                    zorder=5,
                )
            ax.set_xlim(x_min, x_max)

        ax.set_title(f"Piecewise Polynomial Approximation of {label}")
        ax.set_xlabel("Input")
        ax.set_ylabel("Output")
        ax.legend()
        ax.grid()
        fig.tight_layout()
        fig.savefig(self.filename)
        plt.close(fig)


class PaceEpsilonTraceBuilder:
    def __init__(self, eps, numpy_prec):
        self.eps = eps
        self.numpy_prec = numpy_prec

    def check(self, x):
        traces = []
        if PacePWPAPrecision.is_bf16(self.numpy_prec):
            x_prec = PacePWPAPrecision.quantize(x, self.numpy_prec)
            eps_prec = PacePWPAPrecision.quantize(self.eps, self.numpy_prec)
        else:
            x_prec = x.astype(self.numpy_prec)
            eps_prec = self.numpy_prec(self.eps)
        bypass = np.abs(x_prec) < eps_prec
        traces.append(f"  {np.abs(x_prec)} < {eps_prec} ?: {bypass}\n")
        return traces, bypass


class PaceDebugErrorFormatter:
    @staticmethod
    def format(ofmap_golden, ofmap_approx):
        return [
            f"  y_true: {ofmap_golden}\n",
            f"  y_approx: {ofmap_approx}\n",
            f"  error: {float(ofmap_approx) - float(ofmap_golden)}\n",
        ]


class PacePWPATraceBuilder:
    def __init__(self, degree, prec):
        self.degree = degree
        self.prec = prec

    def part_id(self, ifmap, bst_bps):
        part_idx, part_details = PacePartition(
            bst_bps, bst_bps, precision=self.prec
        ).bst_part_id_with_details(ifmap)
        trace = []
        for detail in part_details[:-1]:
            feat = detail["x"]
            bp = detail["bp"]
            if detail["comparison"] == "gt":
                decision = "go_right"
            elif detail["comparison"] == "lt":
                decision = "go_left"
            else:
                direction = "go_left" if detail["bit"] == 0 else "go_right"
                decision = f"equal -> {direction}"
            trace.append(
                f"  Stage {detail['stage']}: x={feat:.6f} "
                f"({PaceDebugFormatter.float_to_hex(feat, self.prec)}) "
                f"vs bp[{detail['bp_index']}]={bp:.6f} "
                f"({PaceDebugFormatter.float_to_hex(bp, self.prec)}) -> {decision}\n"
            )
        trace.append(f"  Final part_idx = {part_idx}\n")
        return part_idx, trace

    def evaluate(self, ifmap, coeffs, part_id):
        ofmap, details = PacePWPAEvaluator(
            self.degree, self.prec
        ).evaluate_scalar(ifmap, coeffs, part_id, return_details=True)
        fma_trace = []
        for detail in details:
            y_copy = detail["y_before"]
            feat_copy = detail["x"]
            coeff_copy = detail["coeff"]
            y = detail["y_after"]
            fma_trace.append(
                f"  FMA step {detail['step']}: "
                f"y={float(y_copy):.6f}"
                f"({PaceDebugFormatter.float_to_hex(y_copy, self.prec)}) * "
                f"{float(feat_copy):.6f}"
                f"({PaceDebugFormatter.float_to_hex(feat_copy, self.prec)}) + "
                f"{float(coeff_copy):.6f}"
                f"({PaceDebugFormatter.float_to_hex(coeff_copy, self.prec)}) = "
                f"{float(y):.6f}"
                f"({PaceDebugFormatter.float_to_hex(float(y), self.prec)}) \n"
            )
        return ofmap, fma_trace

    def trace_pwpa(self, ifmap, coeffs, bst_bps):
        pwpa_traces = []
        part_id, part_trace = self.part_id(ifmap, bst_bps)
        ofmap_approx, fma_trace = self.evaluate(ifmap, coeffs, part_id)
        pwpa_traces.append(part_trace)
        pwpa_traces.append(fma_trace)
        return ofmap_approx, pwpa_traces

    def trace(self, ifmap, coeffs, bst_bps):
        return self.trace_pwpa(ifmap, coeffs, bst_bps)


class PaceInverseTraceBuilder(PacePWPATraceBuilder):
    def __init__(self, degree, prec, np_prec, eps, eps_const, fn_name):
        PacePWPATraceBuilder.__init__(self, degree, np_prec)
        self.input_prec = prec
        self.np_prec = np_prec
        self.eps = eps
        self.eps_const = eps_const
        self.fn_name = fn_name

    def trace(self, ifmap, coeffs, bst_bps):
        inv_traces = []
        eps_trace, bypass = PaceEpsilonTraceBuilder(self.eps, self.np_prec).check(ifmap)
        preprocessor = PaceInversePreprocessRegistry.create(
            self.fn_name, self.input_prec
        )
        postprocessor = PaceInverseSqrtPostprocessor(
            self.input_prec, self.eps_const
        )
        sign, exp, mant = preprocessor.preprocess(ifmap)
        ofmap_approx_mant, pwpa_trace = self.trace_pwpa(mant, coeffs, bst_bps)
        ofmap_approx = postprocessor.compose(ofmap_approx_mant, sign, exp)
        if PacePWPAPrecision.is_bf16(self.np_prec):
            ofmap_approx = PacePWPAPrecision.quantize(ofmap_approx, self.np_prec)
        input_hex = PaceDebugFormatter.float_to_hex(ifmap, self.np_prec)
        mant_hex = PaceDebugFormatter.float_to_hex(mant, self.np_prec)
        output_mant_hex = PaceDebugFormatter.float_to_hex(
            ofmap_approx_mant, self.np_prec
        )
        output_hex = PaceDebugFormatter.float_to_hex(ofmap_approx, self.np_prec)
        dtype_name = PaceDebugFormatter.precision_label(self.np_prec)
        inv_traces.append(f"  input ({dtype_name}): {ifmap} ({input_hex})\n")
        inv_traces.append(
            f"  {ifmap} ({input_hex}) decomposed to sign: {sign}, exp: {exp}, "
            f"mantissa: {mant} ({mant_hex})\n"
        )
        inv_traces.append(eps_trace)
        inv_traces.append(pwpa_trace[0])
        inv_traces.append(pwpa_trace[1])
        inv_traces.append(
            f"  sign: {sign}, exp: {exp}, mantissa: {ofmap_approx_mant} "
            f"({output_mant_hex}) composed to {ofmap_approx} ({output_hex})\n"
        )
        ofmap_approx = postprocessor.apply_epsilon(bypass, ofmap_approx)
        if PacePWPAPrecision.is_bf16(self.np_prec):
            ofmap_approx = PacePWPAPrecision.quantize(ofmap_approx, self.np_prec)
        inv_traces.append(
            f"  After eps adjustment {ofmap_approx} "
            f"{PaceDebugFormatter.float_to_hex(ofmap_approx, prec=self.np_prec)}\n"
        )
        return ofmap_approx, inv_traces


class PacePWPADebugListBuilder:
    INVERSE_FUNCTIONS = {"inv", "sqrt", "rsqrt"}

    def __init__(self, degree, prec, np_prec, fn_name=None, eps=None, eps_const=None):
        self.degree = degree
        self.prec = prec
        self.np_prec = np_prec
        self.fn_name = fn_name
        self.eps = eps
        self.eps_const = eps_const

    def trace_builder(self):
        if self.fn_name in self.INVERSE_FUNCTIONS:
            return PaceInverseTraceBuilder(
                self.degree,
                self.prec,
                self.np_prec,
                self.eps,
                self.eps_const,
                self.fn_name,
            )
        return PacePWPATraceBuilder(self.degree, self.np_prec)

    def evaluate(self, ifmap, ofmap_golden, coeffs, bst_bps):
        pwpa_traces = []
        outputs = []
        builder = self.trace_builder()
        for i, feat in enumerate(ifmap):
            pwpa_traces.append(
                [f"\n*********************** Iteration: {i} ************************* \n"]
            )
            ofmap_approx, pwpa_trace = builder.trace(feat, coeffs, bst_bps)
            outputs.append(ofmap_approx)
            pwpa_traces.append(pwpa_trace)
            pwpa_traces.append(PaceDebugErrorFormatter.format(
                ofmap_golden[i], ofmap_approx
            ))
        output_dtype = np.float32 if PacePWPAPrecision.is_bf16(self.np_prec) else self.np_prec
        output = np.asarray(outputs, dtype=output_dtype).reshape(
            np.asarray(ifmap).shape
        )
        return output, pwpa_traces

    def build(self, ifmap, ofmap_golden, coeffs, bst_bps):
        _, pwpa_traces = self.evaluate(ifmap, ofmap_golden, coeffs, bst_bps)
        return pwpa_traces


class PacePWPADebugWriter:
    def __init__(self, filename, prec):
        self.filename = filename
        self.prec = prec

    def write(self, raw_bps, bst_bps, coeffs, pwpa_traces):
        with open(self.filename, "w") as f:
            f.write("\n=== RAW_BREAKPOINTS ===\n")
            for idx, bp in enumerate(raw_bps):
                hex_bps_prec = PaceDebugFormatter.float_to_hex(bp, self.prec)
                f.write(f"bp{idx}: {bp} {hex_bps_prec}\n")
            f.write("\n=== BST_BREAKPOINTS ===\n")
            for idx, bp in enumerate(bst_bps[2:]):
                hex_bps_prec = PaceDebugFormatter.float_to_hex(bp, self.prec)
                f.write(f"bp{idx}: {bp} {hex_bps_prec}\n")

            f.write("\n=== COEFFS ===\n")
            for idx, row in enumerate(coeffs):
                for coeff in row:
                    hex_bps_prec = PaceDebugFormatter.float_to_hex(coeff, self.prec)
                    f.write(f"{coeff} {hex_bps_prec}, ")
                f.write("\n")

            f.write("=== PWPA_TRACES ===\n")
            for trace_list in pwpa_traces:
                for line in trace_list:
                    f.write("".join(line))


class PaceSoftmaxDebugWriter:
    def __init__(self, filename):
        self.filename = filename

    def write(self, traces):
        with open(self.filename, "w") as f:
            for trace in traces:
                f.write("".join(trace))
