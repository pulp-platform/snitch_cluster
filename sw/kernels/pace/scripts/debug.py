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
    from snitch.pace.scripts.invert import *
except ModuleNotFoundError:
    from invert import *
try:
    from snitch.pace.scripts.pwpa import (
        compute_part_id_with_details,
        evaluate_pwpa_scalar,
        is_bf16_precision,
        quantize_precision,
    )
except ModuleNotFoundError:
    from pwpa import compute_part_id_with_details, evaluate_pwpa_scalar, is_bf16_precision, quantize_precision
def arrange_params(np_type, bst_bps, coeffs, eps=10**-6, eps_const=0):
    params = []
    coeff_shape = coeffs.shape
    for deg in range(coeff_shape[1]):
        for bp in range(coeff_shape[0]):
            params.append(clean_value(np_type(coeffs[bp, coeff_shape[1]-1-deg])))
    for bp in bst_bps:
        params.append(clean_value(np_type(bp)))
    params.append(clean_value(np_type(eps)))
    params.append(clean_value(np_type(eps_const)))
    return params
def float_to_hex(v, prec):
    if prec == np.float64:
        arr = np.asarray(v, dtype=np.float64)
        bits = arr.view(np.uint64).item()
        return f"0x{bits:016X}"    # 16 hex chars = 64 bits

    # ---- float32 (32 bits) ----
    if prec == np.float32:
        arr = np.asarray(v, dtype=np.float32)
        bits = arr.view(np.uint32).item()
        return f"0x{bits:08X}"     # 8 hex chars = 32 bits

    # ---- float16 (IEEE-754 half, 16 bits) ----
    if prec == np.float16:
        arr = np.asarray(v, dtype=np.float16)
        bits = arr.view(np.uint16).item()
        return f"0x{bits:04X}"     # 4 hex chars = 16 bits

    # ---- bfloat16 (custom) ----
    # BF16 = top 16 bits of IEEE754 float32
    if is_bf16_precision(prec):
        f32 = np.asarray(v, dtype=np.float32)
        bits32 = f32.view(np.uint32).item()
        bf16 = (bits32 >> 16) & 0xFFFF
        return f"0x{bf16:04X}"     # 4 hex chars = 16 bits

    raise ValueError(f"Unsupported precision: {prec}")


def precision_label(prec):
    if prec == np.float64:
        return "FP64"
    if prec == np.float32:
        return "FP32"
    if prec == np.float16:
        return "FP16"
    if is_bf16_precision(prec):
        return "BF16"
    return str(prec)

def debug_offset_xmax(attn, xmax, dtype=np.float64):
    Q, K = attn.shape
    attn = np.asarray(attn, dtype=dtype)
    attn = np.asarray(attn, dtype=np.float64)
    attn = np.asarray(attn, dtype=dtype)
    xmax = np.asarray(xmax, dtype=np.float64)
    trace = []
    attn_oup = np.asarray(attn, dtype=np.float64)
    for q in range(Q):
        for k in range(K):
            attn_oup[q,k] = attn[q,k] - xmax[q]
            trace.append(f"[{q},{k}]\ninp={float_to_hex(attn[q,k], dtype)}\nmax={float_to_hex(xmax[q], dtype)}\noup={float_to_hex(attn_oup[q,k], dtype)}\n")
    return trace

def debug_find_xmax(attn, dtype=np.float64):
    Q, K = attn.shape
    if K % 2 != 0:
        raise ValueError("debug_find_xmax expects an even K for 2-lane tracing")

    attn = np.asarray(attn, dtype=dtype)
    traces = []
    for q in range(Q):
        lane0_max = attn[q, 0]
        lane1_max = attn[q, 1]
        traces.append(
            f"=== q = {q} ===\n"
            f"init_lane0: k=0 inp={float_to_hex(attn[q, 0], dtype)} max_after={float_to_hex(lane0_max, dtype)}\n"
            f"init_lane1: k=1 inp={float_to_hex(attn[q, 1], dtype)} max_after={float_to_hex(lane1_max, dtype)}\n"
        )

        for k in range(2, K, 2):
            lane0_inp = attn[q, k]
            lane1_inp = attn[q, k + 1]

            lane0_before = lane0_max
            lane1_before = lane1_max
            lane0_take = int(lane0_inp > lane0_max)
            lane1_take = int(lane1_inp > lane1_max)
            if lane0_take:
                lane0_max = lane0_inp
            if lane1_take:
                lane1_max = lane1_inp

            traces.append(
                f"[q={q},pair={k // 2}]\n"
                f"lane0: k={k} inp={float_to_hex(lane0_inp, dtype)} max_before={float_to_hex(lane0_before, dtype)} take={lane0_take} max_after={float_to_hex(lane0_max, dtype)}\n"
                f"lane1: k={k + 1} inp={float_to_hex(lane1_inp, dtype)} max_before={float_to_hex(lane1_before, dtype)} take={lane1_take} max_after={float_to_hex(lane1_max, dtype)}\n"
            )

        final_take = int(lane1_max > lane0_max)
        final_max = lane1_max if final_take else lane0_max
        traces.append(
            f"[q={q},reduction]\n"
            f"lane0_max={float_to_hex(lane0_max, dtype)}\n"
            f"lane1_max={float_to_hex(lane1_max, dtype)}\n"
            f"take_lane1={final_take}\n"
            f"final_max={float_to_hex(final_max, dtype)}\n"
        )
    return traces


def debug_compute_part_id(ifmap: np.ndarray, bst_bps: list, prec):
    part_idx, part_details = compute_part_id_with_details(ifmap, bst_bps, prec)
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
            f"  Stage {detail['stage']}: x={feat:.6f} ({float_to_hex(feat, prec)}) "
            f"vs bp[{detail['bp_index']}]={bp:.6f} ({float_to_hex(bp, prec)}) -> {decision}\n"
        )
    trace.append(f"  Final part_idx = {part_idx}\n")
    return part_idx, trace

def debug_evaluate_pwpa(ifmap: np.ndarray, coeffs: np.ndarray, part_id: int, degree, prec):
    ofmap, details = evaluate_pwpa_scalar(ifmap, coeffs, part_id, degree, prec, return_details=True)
    fma_trace = []
    for detail in details:
        y_copy = detail["y_before"]
        feat_copy = detail["x"]
        coeff_copy = detail["coeff"]
        y = detail["y_after"]
        fma_trace.append(
            f"  FMA step {detail['step']}: y={float(y_copy):.6f}({float_to_hex(y_copy, prec)}) * "
            f"{float(feat_copy):.6f}({float_to_hex(feat_copy, prec)}) + "
            f"{float(coeff_copy):.6f}({float_to_hex(coeff_copy, prec)}) = {float(y):.6f}({float_to_hex(float(y), prec)}) \n"
        )
    return ofmap, fma_trace

def debug_plot_pwpa(
    ifmap: np.ndarray,
    golden_ofmap: np.ndarray,
    pwpa_ofmap: np.ndarray,
    fname: "debug.pdf",
    fn_name="function",
    breakpoints=None,
):
    if plt is None:
        return
    label = str(fn_name).upper()
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.scatter(ifmap, golden_ofmap, label=f"{label} (golden)", color="blue", s=0.5)
    ax.scatter(ifmap, pwpa_ofmap, label=f"{label} (PWPA)", color="red", s=0.5, marker="d")

    x_min, x_max = ax.get_xlim()
    if breakpoints is not None:
        bp_arr = np.asarray(breakpoints, dtype=np.float64)
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
    fig.savefig(fname)
    plt.close(fig)

def debug_eps_check(x : np.ndarray, eps, numpy_prec):
    """When input becomes subnormal, return bypass."""
    traces =[]
    if is_bf16_precision(numpy_prec):
        x_prec = quantize_precision(x, numpy_prec)
        eps_prec = quantize_precision(eps, numpy_prec)
    else:
        x_prec = x.astype(numpy_prec)
        eps_prec = numpy_prec(eps)
    traces.append(f"  {np.abs(x_prec)} < {eps_prec} ?: {np.abs(x_prec) < eps_prec}\n")
    return traces, np.abs(x_prec) < eps_prec

def clean_value(v):
    """Convert NumPy scalar/array/list into plain Python floats recursively."""
    if isinstance(v, (list, tuple)):
        return [clean_value(x) for x in v]
    if isinstance(v, np.ndarray):
        return v.astype(float).tolist()
    try:
        return float(v)
    except Exception:
        return v

def debug_pwpa(ifmap, coeffs : np.ndarray, bst_bps : list, degree : int, prec):
    pwpa_traces = []
    part_id, part_trace = debug_compute_part_id(ifmap, bst_bps, prec=prec)
    ofmap_approx, fma_trace = debug_evaluate_pwpa(ifmap, coeffs, part_id, degree, prec=prec)
    pwpa_traces.append(part_trace)
    pwpa_traces.append(fma_trace)
    return ofmap_approx, pwpa_traces

def debug_error(ofmap_golden, ofmap_approx):
    error_traces = []
    error_traces.append(f"  y_true: {ofmap_golden}\n")
    error_traces.append(f"  y_approx: {ofmap_approx}\n")
    error_traces.append(f"  error: {(float(ofmap_approx))-(float(ofmap_golden))}\n")
    return error_traces

def debug_invsqrt(ifmap, ofmap_golden, coeffs : np.ndarray, bst_bps : list, degree : int, prec, np_prec, eps, eps_const, fn_name=None):
    inv_traces = []
    eps_trace, bypass = debug_eps_check(ifmap, eps, np_prec)
    func = PRE_PROCESS[fn_name]
    sign, exp, mant = func(ifmap, prec=prec)
    ofmap_approx_mant, pwpa_trace = debug_pwpa(mant, coeffs, bst_bps, degree, np_prec)
    ofmap_approx = invert_sqrt_postprocess(ofmap_approx_mant, sign, exp)
    if is_bf16_precision(np_prec):
        ofmap_approx = quantize_precision(ofmap_approx, np_prec)
    input_hex = float_to_hex(ifmap, np_prec)
    mant_hex = float_to_hex(mant, np_prec)
    output_mant_hex = float_to_hex(ofmap_approx_mant, np_prec)
    output_hex = float_to_hex(ofmap_approx, np_prec)
    dtype_name = precision_label(np_prec)
    inv_traces.append(f"  input ({dtype_name}): {ifmap} ({input_hex})\n")
    inv_traces.append(
        f"  {ifmap} ({input_hex}) decomposed to sign: {sign}, exp: {exp}, mantissa: {mant} ({mant_hex})\n"
    )
    inv_traces.append(eps_trace)
    inv_traces.append(pwpa_trace[0])
    inv_traces.append(pwpa_trace[1])
    # inv_traces.append(pwpa_trace[1])
    inv_traces.append(
        f"  sign: {sign}, exp: {exp}, mantissa: {ofmap_approx_mant} ({output_mant_hex}) "
        f"composed to {ofmap_approx} ({output_hex})\n"
    )
    ofmap_approx = eps_inv(bypass, ofmap_approx, eps_const)
    if is_bf16_precision(np_prec):
        ofmap_approx = quantize_precision(ofmap_approx, np_prec)
    inv_traces.append(f"  After eps adjustment {ofmap_approx} {float_to_hex(ofmap_approx, prec=np_prec)}\n")
    return ofmap_approx, inv_traces

def debug_pwpa_list(ifmap : np.ndarray, ofmap_golden : np.ndarray, coeffs : np.ndarray, raw_bps : list, bst_bps : list, degree : int, prec, np_prec, fn_name=None, eps=None, eps_const=None):
    pwpa_traces = []
    for i, feat in enumerate(ifmap):
        feat_process = feat
        pwpa_traces.append([f"\n*********************** Iteration: {i} ************************* \n"])
        if fn_name in ["inv", "sqrt", "rsqrt"]:
            ofmap_approx, pwpa_trace =  debug_invsqrt(feat_process, ofmap_golden[i], coeffs, bst_bps, degree, prec, np_prec, eps, eps_const, fn_name=fn_name)
        else:
            ofmap_approx, pwpa_trace =  debug_pwpa(feat_process, coeffs, bst_bps, degree, np_prec)

        error_traces = debug_error(ofmap_golden[i], ofmap_approx)
        pwpa_traces.append(pwpa_trace)
        pwpa_traces.append(error_traces)

    return pwpa_traces

def write_pwpa_debug_file(filename, raw_bps, bst_bps, coeffs, pwpa_traces, prec):
    with open(filename, "w") as f:
        f.write("\n=== RAW_BREAKPOINTS ===\n")
        for idx, bp in enumerate(raw_bps):
            hex_bps_prec = float_to_hex(bp, prec)
            f.write(f"bp{idx}: {bp} {hex_bps_prec}\n")
        f.write("\n=== BST_BREAKPOINTS ===\n")
        for idx, bp in enumerate(bst_bps[2:]):
            hex_bps_prec = float_to_hex(bp, prec)
            f.write(f"bp{idx}: {bp} {hex_bps_prec}\n")

        f.write("\n=== COEFFS ===\n")
        for idx, row in enumerate(coeffs):
            # print(idx, row)
            for coeff in row:
                hex_bps_prec = float_to_hex(coeff, prec)
                f.write(f"{coeff} {hex_bps_prec}, ")
            f.write("\n")

        f.write("=== PWPA_TRACES ===\n")
        for trace_list in pwpa_traces:
            for line in trace_list:
                f.write("".join(line))

def write_softmax_debug_file(filename, traces):
    with open(filename, "w") as f:
        for trace in traces:
            # for line in trace_list:
            f.write("".join(trace))
