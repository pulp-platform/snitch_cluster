#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

import argparse
import pathlib
import json
try:
    import json5
    _HAS_JSON5 = True
except ModuleNotFoundError:
    json5 = None
    _HAS_JSON5 = False
import numpy as np
import sys
import copy
try:
    import torch
except ModuleNotFoundError:
    torch = None

_REPO_ROOT = pathlib.Path(__file__).resolve().parents[5]
_PACE_SCRIPTS_DIR = pathlib.Path(__file__).resolve().parents[2] / "scripts"
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

from util.sim import data_utils
from util.sim.data_utils import _integer_precision_t, format_struct_definition, \
    format_array_definition, format_array_declaration, format_ifdef_wrapper, \
    emit_license

if torch is not None:
    torch.manual_seed(42)
from golden import *
from debug import *
from pwpa import *
from invert import *
from softmax import *


def load_config(path):
    text = path.read_text()
    if _HAS_JSON5:
        return json5.loads(text)
    filtered = "\n".join(line for line in text.splitlines() if not line.lstrip().startswith("//"))
    return json.loads(filtered)


PACE_MODE_CODES = {
    "pwpa": 0b000,
    "inv": 0b001,
    "sqrt": 0b010,
    "rsqrt": 0b011,
}

PACE_SCALAR_FUNCT7 = {
    "FP32": 0x30,
    "FP16": 0x31,
    "AH": 0x31,
}
PACE_ASM_SUFFIX = {
    "FP32": "s",
    "FP16": "h",
    "AH": "h",
}
PACE_FMODE = {
    "FP32": 0,
    "FP16": 0,
    "AH": 3,
}

XMAX_UNROLL_REGS = 4
SUPPORTED_SOFTMAX_UNROLLS = (3, 4, 8)
SUPPORTED_LAYOUTS = ("row-major", "column-major")


def dtype_bits(dtype):
    return int(np.dtype(dtype).itemsize * 8)


def pace_lane_count(dtype, fpu_data_width):
    bits = dtype_bits(dtype)
    if fpu_data_width % bits != 0:
        raise ValueError(
            f"FPU data width {fpu_data_width} is not divisible by element width {bits}"
        )
    lanes = fpu_data_width // bits
    if lanes < 1:
        raise ValueError(
            f"Invalid lane count {lanes} for dtype={dtype} and fpu_data_width={fpu_data_width}"
        )
    return lanes


def pace_chunk_size(dtype, fpu_data_width):
    return XMAX_UNROLL_REGS * pace_lane_count(dtype, fpu_data_width)


def deno_chunk_size(dtype, fpu_data_width, softmax_unroll=8, row_interleaved=False):
    if row_interleaved:
        return softmax_unroll
    return softmax_unroll * pace_lane_count(dtype, fpu_data_width)


def normalize_layout(layout):
    normalized = str(layout).strip().lower()
    aliases = {
        "row-major": "row-major",
        "row_major": "row-major",
        "row": "row-major",
        "rm": "row-major",
        "column-major": "column-major",
        "column_major": "column-major",
        "col-major": "column-major",
        "col_major": "column-major",
        "column": "column-major",
        "col": "column-major",
        "cm": "column-major",
    }
    if normalized not in aliases:
        raise ValueError(
            f"Unsupported layout '{layout}'. Expected one of {SUPPORTED_LAYOUTS}"
        )
    return aliases[normalized]


def pack_rows_across_lanes(arr, lanes):
    arr = np.asarray(arr)
    q, k = arr.shape
    if q % lanes != 0:
        raise ValueError(f"Q={q} must be divisible by lanes={lanes} for row-interleaved packing")
    return arr.reshape(q // lanes, lanes, k).transpose(0, 2, 1).reshape(q // lanes, k * lanes)


def unpack_rows_across_lanes(arr, lanes):
    arr = np.asarray(arr)
    groups, packed_k = arr.shape
    if packed_k % lanes != 0:
        raise ValueError(f"Packed width {packed_k} must be divisible by lanes={lanes}")
    k = packed_k // lanes
    return arr.reshape(groups, k, lanes).transpose(0, 2, 1).reshape(groups * lanes, k)


def grouped_rows_view(arr, lanes):
    arr = np.asarray(arr)
    q, k = arr.shape
    if q % lanes != 0:
        raise ValueError(f"Q={q} must be divisible by lanes={lanes} for row grouping")
    return arr.reshape(q // lanes, lanes, k).transpose(0, 2, 1)


def pace_dtype_key(prec, super_fmt="FP32"):
    if prec == "FP32":
        return "FP32"
    if str(super_fmt).upper() in {"AH", "FP16ALT", "BF16"}:
        return "AH"
    if prec == "FP16":
        return "FP16"
    raise ValueError(f"Unsupported PACE dtype selection: prec={prec}, super_fmt={super_fmt}")


def generate_pace_mode_defines(prefix, fn_name, extend=False):
    mode_name = fn_name if fn_name in ("inv", "sqrt", "rsqrt") else "pwpa"
    mode_bits = PACE_MODE_CODES[mode_name] | (int(bool(extend)) << 2)
    return [f"#define {prefix}_PACE_MODE_BITS {mode_bits}"]


def generate_pace_scalar_defines(prefix, fn_name, prec, super_fmt="FP32", extend=False):
    mode_name = fn_name if fn_name in ("inv", "sqrt", "rsqrt") else "pwpa"
    mode_bits = PACE_MODE_CODES[mode_name] | (int(bool(extend)) << 2)
    dtype_key = pace_dtype_key(prec, super_fmt)
    asm_suffix = PACE_ASM_SUFFIX[dtype_key]
    scalar_funct7 = PACE_SCALAR_FUNCT7[dtype_key]
    scalar_word = (
        (scalar_funct7 << 25)
        | (0 << 20)
        | (0 << 15)
        | (mode_bits << 12)
        | (1 << 7)
        | 0x53
    )
    return [
        f"#define {prefix}_PACE_SCALAR_FUNCT7 0x{scalar_funct7:02x}",
        f"#define {prefix}_PACE_SCALAR_WORD 0x{scalar_word:08x}",
        f"#define {prefix}_PACE_SCALAR_ASM \"pace.{mode_name}.{asm_suffix} ft1, ft0\"",
        f"#define {prefix}_PACE_FMODE {PACE_FMODE[dtype_key]}",
    ]


def generate_bp_mode_defines(bp_mode):
    mode = str(bp_mode).lower()
    is_linear = mode in ("linear", "uniform")
    is_nonuniform = mode in ("nonuniform", "chebyshev")
    if not (is_linear or is_nonuniform):
        raise ValueError(f"Unsupported breakpoint generation mode: {bp_mode}")
    return [
        f"#define PACE_BP_MODE_NONUNIFORM {int(is_nonuniform)}",
        f"#define PACE_BP_MODE_LINEAR {int(is_linear)}",
    ]


def generate_data(Q, K, np_type, xmin, xmax, seed=None):
    rng = np.random.default_rng(seed)
    attn = rng.uniform(xmin, xmax, size=(Q, K))
    return attn.astype(np_type)

def resolve_output_path(output_dir, filename):
    if output_dir is None:
        return pathlib.Path(filename)
    output_dir.mkdir(parents=True, exist_ok=True)
    return output_dir / filename

def debug_xmax_parallel(attn, dtype=np.float64, fpu_data_width=64):
    Q, K = attn.shape
    attn = np.asarray(attn, dtype=dtype)
    lanes = pace_lane_count(dtype, fpu_data_width)
    chunk_size = pace_chunk_size(dtype, fpu_data_width)
    if K % chunk_size != 0:
        raise ValueError(
            "debug_xmax_parallel expects K to be divisible by "
            f"{chunk_size} for dtype={np.dtype(dtype).name} and fpu_data_width={fpu_data_width}"
        )

    traces = []
    for q in range(Q):
        regs = np.full((XMAX_UNROLL_REGS, lanes), -np.inf, dtype=dtype)
        traces.append(f"=== q = {q} ===\n")

        for reg_idx in range(XMAX_UNROLL_REGS):
            lane_init = []
            for lane in range(lanes):
                regs[reg_idx, lane] = attn[q, reg_idx * lanes + lane]
                lane_init.append(
                    f"lane{lane}(k={reg_idx * lanes + lane})="
                    f"{float_to_hex(regs[reg_idx, lane], dtype)}"
                )
            traces.append(f"init_reg{reg_idx}: {' '.join(lane_init)}\n")

        for blk in range(1, K // chunk_size):
            base = blk * chunk_size
            traces.append(f"[q={q},blk={blk}]\n")
            for reg_idx in range(XMAX_UNROLL_REGS):
                lane_msgs = []
                for lane in range(lanes):
                    idx = base + reg_idx * lanes + lane
                    inp = attn[q, idx]
                    prev_max = regs[reg_idx, lane]
                    take = int(inp > prev_max)
                    if take:
                        regs[reg_idx, lane] = inp
                    lane_msgs.append(
                        f"lane{lane}(k={idx}) inp={float_to_hex(inp, dtype)} "
                        f"max_before={float_to_hex(prev_max, dtype)} "
                        f"take={take} max_after={float_to_hex(regs[reg_idx, lane], dtype)}"
                    )
                traces.append(f"reg{reg_idx}: {' | '.join(lane_msgs)}\n")

        reg01 = np.maximum(regs[0], regs[1], dtype=dtype)
        reg23 = np.maximum(regs[2], regs[3], dtype=dtype)
        regf = np.maximum(reg01, reg23, dtype=dtype)
        final_lane = int(np.argmax(regf))
        final_max = regf[final_lane]
        traces.append(
            f"[q={q},reduction]\n"
            f"reg0={[float_to_hex(v, dtype) for v in regs[0]]}\n"
            f"reg1={[float_to_hex(v, dtype) for v in regs[1]]}\n"
            f"reg2={[float_to_hex(v, dtype) for v in regs[2]]}\n"
            f"reg3={[float_to_hex(v, dtype) for v in regs[3]]}\n"
            f"reg01={[float_to_hex(v, dtype) for v in reg01]}\n"
            f"reg23={[float_to_hex(v, dtype) for v in reg23]}\n"
            f"regf={[float_to_hex(v, dtype) for v in regf]}\n"
            f"final_lane={final_lane}\n"
            f"final_max={float_to_hex(final_max, dtype)}\n"
        )
    return traces

def fadd_hw(a, b, dtype):
    a_dt = np.asarray(a, dtype=dtype)
    b_dt = np.asarray(b, dtype=dtype)
    return np.add(a_dt, b_dt, dtype=dtype)

def log_reg_hw(trace, name, v, dtype):
    trace.append(f"{name}: {[float_to_hex(el, dtype) for el in np.asarray(v, dtype=dtype)]}\n")

def log_reg_op(trace, dst, src_a, src_b, out, dtype):
    trace.append(f"{dst} = {src_a} + {src_b}: {[float_to_hex(el, dtype) for el in out]}\n")


def reduce_accumulators_hw(acc_regs, dtype, trace=None, names=None):
    acc_regs = [np.asarray(reg, dtype=dtype).copy() for reg in acc_regs]
    if names is None:
        names = [f"acc{idx}" for idx in range(len(acc_regs))]

    if len(acc_regs) == 4:
        sum01 = np.add(acc_regs[0], acc_regs[1], dtype=dtype)
        sum23 = np.add(acc_regs[2], acc_regs[3], dtype=dtype)
        total = np.add(sum01, sum23, dtype=dtype)
        if trace is not None:
            log_reg_op(trace, names[0], names[1], names[0], sum01, dtype)
            log_reg_op(trace, names[2], names[2], names[3], sum23, dtype)
            log_reg_op(trace, names[0], names[2], names[0], total, dtype)
        return total

    if len(acc_regs) == 3:
        sum01 = np.add(acc_regs[0], acc_regs[1], dtype=dtype)
        total = np.add(sum01, acc_regs[2], dtype=dtype)
        if trace is not None:
            log_reg_op(trace, names[0], names[1], names[0], sum01, dtype)
            log_reg_op(trace, names[0], names[2], names[0], total, dtype)
        return total

    if len(acc_regs) == 2:
        total = np.add(acc_regs[0], acc_regs[1], dtype=dtype)
        if trace is not None:
            log_reg_op(trace, names[0], names[0], names[1], total, dtype)
        return total

    if len(acc_regs) == 1:
        return acc_regs[0]

    total = acc_regs[0]
    for idx in range(1, len(acc_regs)):
        total = np.add(total, acc_regs[idx], dtype=dtype)
        if trace is not None:
            log_reg_op(trace, names[0], names[0], names[idx], total, dtype)
    return total


def reduce_lanes_hw(vec, dtype):
    vec = np.asarray(vec, dtype=dtype)
    lanes = vec.shape[0]

    if lanes == 1:
        return vec[0], [
            f"lane0 = {float_to_hex(vec[0], dtype)}\n",
        ]

    if lanes == 2:
        sum01 = np.add(vec[0], vec[1], dtype=dtype)
        return sum01, [
            f"flw0 = {float_to_hex(vec[0], dtype)}\n",
            f"flw1 = {float_to_hex(vec[1], dtype)}\n",
            f"sum01 = flw0 + flw1 = {float_to_hex(sum01, dtype)}\n",
        ]

    if lanes == 4:
        sum01 = np.add(vec[0], vec[1], dtype=dtype)
        sum23 = np.add(vec[2], vec[3], dtype=dtype)
        sum0123 = np.add(sum01, sum23, dtype=dtype)
        return sum0123, [
            f"flh0 = {float_to_hex(vec[0], dtype)}\n",
            f"flh1 = {float_to_hex(vec[1], dtype)}\n",
            f"flh2 = {float_to_hex(vec[2], dtype)}\n",
            f"flh3 = {float_to_hex(vec[3], dtype)}\n",
            f"sum01 = flh0 + flh1 = {float_to_hex(sum01, dtype)}\n",
            f"sum23 = flh2 + flh3 = {float_to_hex(sum23, dtype)}\n",
            f"sum0123 = sum01 + sum23 = {float_to_hex(sum0123, dtype)}\n",
        ]

    acc = np.asarray(0.0, dtype=dtype)
    trace = []
    for lane, value in enumerate(vec):
        trace.append(f"lane{lane} = {float_to_hex(value, dtype)}\n")
        acc = np.add(acc, value, dtype=dtype)
        trace.append(f"acc_after_lane{lane} = {float_to_hex(acc, dtype)}\n")
    return acc, trace

def debug_deno_parallel(attn_exp, dtype, fpu_data_width=64):
    return debug_deno_parallel_configurable(attn_exp, dtype, fpu_data_width=fpu_data_width)


def debug_deno_parallel_configurable(
    attn_exp, dtype, fpu_data_width=64, softmax_unroll=8, row_interleaved=False
):
    Q, K = attn_exp.shape
    attn = np.asarray(attn_exp, dtype=dtype)
    lanes = pace_lane_count(dtype, fpu_data_width)
    if softmax_unroll not in SUPPORTED_SOFTMAX_UNROLLS:
        raise ValueError(f"Unsupported softmax unroll {softmax_unroll}")
    chunk_size = deno_chunk_size(
        dtype, fpu_data_width, softmax_unroll=softmax_unroll, row_interleaved=row_interleaved
    )
    if K % chunk_size != 0:
        raise ValueError(
            "debug_deno_parallel expects K to be divisible by "
            f"{chunk_size} for dtype={np.dtype(dtype).name} and fpu_data_width={fpu_data_width}"
        )

    trace = []
    independent_accum = (softmax_unroll in (3, 4))

    if row_interleaved:
        grouped = grouped_rows_view(attn, lanes)
        reg_names = ["ft4", "ft5", "ft6", "ft7", "fs0", "fs1", "fa0", "fa1"][:softmax_unroll]
        acc_count = softmax_unroll if independent_accum else max(1, softmax_unroll // 2)
        for qg in range(grouped.shape[0]):
            acc_regs = np.zeros((acc_count, lanes), dtype=dtype)
            trace.append(f"\n=== q_group = {qg} ===\n")
            for reg_idx in range(acc_count):
                log_reg_hw(trace, f"init acc{reg_idx}", acc_regs[reg_idx], dtype)

            for blk in range(K // chunk_size):
                base = blk * chunk_size
                trace.append(f"-- blk {blk} (k={base}..{base + chunk_size - 1})\n")
                exp_regs = []
                for reg_idx in range(softmax_unroll):
                    vec = np.asarray(grouped[qg, base + reg_idx, :], dtype=dtype)
                    exp_regs.append(vec)
                    log_reg_hw(trace, reg_names[reg_idx], vec, dtype)
                if independent_accum:
                    for acc_idx in range(acc_count):
                        acc_regs[acc_idx] = np.add(acc_regs[acc_idx], exp_regs[acc_idx], dtype=dtype)
                        log_reg_op(
                            trace, f"acc{acc_idx}", f"acc{acc_idx}", reg_names[acc_idx], acc_regs[acc_idx], dtype
                        )
                else:
                    for acc_idx in range(acc_count):
                        pair = np.add(
                            exp_regs[2 * acc_idx + 1], exp_regs[2 * acc_idx], dtype=dtype
                        )
                        acc_regs[acc_idx] = np.add(acc_regs[acc_idx], pair, dtype=dtype)
                        log_reg_op(
                            trace, f"acc{acc_idx}", f"acc{acc_idx}", f"pair{acc_idx}", acc_regs[acc_idx], dtype
                        )

            trace.append("-- register reduction across unrolled accumulators\n")
            acc = reduce_accumulators_hw(
                acc_regs, dtype, trace=trace, names=[f"acc{idx}" for idx in range(acc_count)]
            )
            trace.append(f"out[{qg}] = {[float_to_hex(el, dtype) for el in acc]}\n")
        return trace

    for q in range(Q):
        acc_count = softmax_unroll if independent_accum else max(1, softmax_unroll // 2)
        acc_regs = np.zeros((acc_count, lanes), dtype=dtype)
        trace.append(f"\n=== q = {q} ===\n")
        trace.append(
            f"Denominator accumulation with {softmax_unroll} exp registers and {lanes} lane(s)\n"
        )
        for reg_idx in range(acc_regs.shape[0]):
            log_reg_hw(trace, f"init fs{8 + reg_idx}", acc_regs[reg_idx], dtype)

        for blk in range(K // chunk_size):
            base = blk * chunk_size
            trace.append(f"-- blk {blk} (k={base}..{base + chunk_size - 1})\n")

            exp_regs = []
            reg_names = ["ft4", "ft5", "ft6", "ft7", "fs0", "fs1", "fa0", "fa1"][:softmax_unroll]
            for reg_idx in range(softmax_unroll):
                vec = np.asarray(
                    [attn[q, base + reg_idx * lanes + lane] for lane in range(lanes)],
                    dtype=dtype,
                )
                exp_regs.append(vec)
                log_reg_hw(trace, reg_names[reg_idx], vec, dtype)

            if independent_accum:
                for reg_idx in range(acc_regs.shape[0]):
                    acc_regs[reg_idx] = np.add(acc_regs[reg_idx], exp_regs[reg_idx], dtype=dtype)
                    log_reg_op(trace, f"acc{reg_idx}", f"acc{reg_idx}", reg_names[reg_idx], acc_regs[reg_idx], dtype)
            else:
                pair_regs = []
                for reg_idx in range(acc_regs.shape[0]):
                    pair = np.add(exp_regs[2 * reg_idx + 1], exp_regs[2 * reg_idx], dtype=dtype)
                    pair_regs.append(pair)
                    log_reg_op(trace, f"pair{reg_idx}", reg_names[2 * reg_idx + 1], reg_names[2 * reg_idx], pair, dtype)

                for reg_idx in range(acc_regs.shape[0]):
                    acc_regs[reg_idx] = np.add(acc_regs[reg_idx], pair_regs[reg_idx], dtype=dtype)
                    log_reg_op(trace, f"acc{reg_idx}", f"acc{reg_idx}", f"pair{reg_idx}", acc_regs[reg_idx], dtype)

        trace.append("-- register reduction across the unrolled accumulators\n")
        reduced = reduce_accumulators_hw(
            acc_regs, dtype, trace=trace, names=[f"acc{idx}" for idx in range(acc_regs.shape[0])]
        )

        trace.append("-- final lane reduction\n")
        trace.append(f"acc0={ [float_to_hex(el, dtype) for el in reduced] }\n")
        out0, lane_trace = reduce_lanes_hw(reduced, dtype)
        trace.extend(lane_trace)
        trace.append(f"out[{q}] = {float_to_hex(out0, dtype)}\n")

    return trace

def compute_deno_parallel_hw(attn_exp, dtype, fpu_data_width=64):
    return compute_deno_parallel_hw_configurable(attn_exp, dtype, fpu_data_width=fpu_data_width)


def compute_deno_parallel_hw_configurable(
    attn_exp, dtype, fpu_data_width=64, softmax_unroll=8, row_interleaved=False
):
    Q, K = attn_exp.shape
    attn = np.asarray(attn_exp, dtype=dtype)
    lanes = pace_lane_count(dtype, fpu_data_width)
    if softmax_unroll not in SUPPORTED_SOFTMAX_UNROLLS:
        raise ValueError(f"Unsupported softmax unroll {softmax_unroll}")
    chunk_size = deno_chunk_size(
        dtype, fpu_data_width, softmax_unroll=softmax_unroll, row_interleaved=row_interleaved
    )
    if K % chunk_size != 0:
        raise ValueError(
            "compute_deno_parallel_hw expects K to be divisible by "
            f"{chunk_size} for dtype={np.dtype(dtype).name} and fpu_data_width={fpu_data_width}"
        )

    independent_accum = (softmax_unroll in (3, 4))

    if row_interleaved:
        grouped = grouped_rows_view(attn, lanes)
        out = np.zeros((grouped.shape[0], lanes), dtype=dtype)
        acc_count = softmax_unroll if independent_accum else max(1, softmax_unroll // 2)
        for qg in range(grouped.shape[0]):
            acc_regs = np.zeros((acc_count, lanes), dtype=dtype)
            for blk in range(K // chunk_size):
                base = blk * chunk_size
                if independent_accum:
                    for reg_idx in range(acc_count):
                        acc_regs[reg_idx] = np.add(
                            acc_regs[reg_idx], grouped[qg, base + reg_idx, :], dtype=dtype
                        )
                else:
                    for reg_idx in range(acc_count):
                        pair = np.add(
                            grouped[qg, base + 2 * reg_idx + 1, :],
                            grouped[qg, base + 2 * reg_idx, :],
                            dtype=dtype,
                        )
                        acc_regs[reg_idx] = np.add(acc_regs[reg_idx], pair, dtype=dtype)
            out[qg] = reduce_accumulators_hw(acc_regs, dtype)
        return out.astype(dtype)

    out = np.zeros(Q, dtype=dtype)

    for q in range(Q):
        acc_count = softmax_unroll if independent_accum else max(1, softmax_unroll // 2)
        acc_regs = np.zeros((acc_count, lanes), dtype=dtype)

        for blk in range(K // chunk_size):
            base = blk * chunk_size
            exp_regs = []
            for reg_idx in range(softmax_unroll):
                vec = np.asarray(
                    [attn[q, base + reg_idx * lanes + lane] for lane in range(lanes)],
                    dtype=dtype,
                )
                exp_regs.append(vec)

            if independent_accum:
                for reg_idx in range(acc_regs.shape[0]):
                    acc_regs[reg_idx] = np.add(acc_regs[reg_idx], exp_regs[reg_idx], dtype=dtype)
            else:
                pair_regs = []
                for reg_idx in range(acc_regs.shape[0]):
                    pair_regs.append(np.add(exp_regs[2 * reg_idx + 1], exp_regs[2 * reg_idx], dtype=dtype))
                for reg_idx in range(acc_regs.shape[0]):
                    acc_regs[reg_idx] = np.add(acc_regs[reg_idx], pair_regs[reg_idx], dtype=dtype)

        reduced = reduce_accumulators_hw(acc_regs, dtype)
        out[q], _ = reduce_lanes_hw(reduced, dtype)

    return out.astype(dtype)

def debug_mul(attn_exp, inv_deno, attn_oup, dtype=np.float64):
    Q, K = attn_exp.shape
    attn_exp = np.asarray(attn_exp, dtype=dtype)
    inv_deno = np.asarray(inv_deno, dtype=dtype)
    attn_oup = np.asarray(attn_oup, dtype=dtype)
    trace = []
    for q in range(Q):
        trace.append(f"=== q = {q} ===\n")
        trace.append(f"inv_deno={float_to_hex(inv_deno[q], dtype)}\n")
        for k in range(K):
            trace.append(
                f"[q={q},k={k}]\n"
                f"exp={float_to_hex(attn_exp[q, k], dtype)}\n"
                f"inv={float_to_hex(inv_deno[q], dtype)}\n"
                f"oup={float_to_hex(attn_oup[q, k], dtype)}\n"
            )
    return trace

def compute_mul_hw(attn_exp, inv_deno, dtype):
    Q, K = attn_exp.shape
    attn_exp = np.asarray(attn_exp, dtype=dtype)
    inv_deno = np.asarray(inv_deno, dtype=dtype)
    attn_oup = np.zeros((Q, K), dtype=dtype)
    for q in range(Q):
        for k in range(K):
            attn_oup[q, k] = np.multiply(attn_exp[q, k], inv_deno[q], dtype=dtype)
    return attn_oup.astype(dtype)

def widen_fp_for_compare(raw, fmt):
    raw = np.asarray(raw, dtype=fmt).view(np.uint16).astype(np.uint32)
    sign = (raw & 0x8000) >> 15
    exponent = (raw & 0x7C00) >> 10
    mantissa = raw & 0x03FF
    widened = (sign << 31) + 0x70000000 + (exponent << 23) + mantissa
    return widened.astype(np.uint32)

def widen_fp_for_fma(raw, fmt):
    raw = np.asarray(raw, dtype=fmt).view(np.uint16).astype(np.uint32)
    return raw

def arrange_params_32b(np_type, bst_bps, coeffs, eps=10**-6, eps_const=0, super_fmt="FP32"):
    params = []
    rows, cols = coeffs.shape
    for deg in range(cols):
        coeff_idx = cols - 1 - deg
        for bp_idx in range(rows):
            coeff = coeffs[bp_idx, coeff_idx]
            if np_type == np.float16:
                if super_fmt == "FP32":
                    widened_coeff = widen_fp_for_fma(coeff, np_type)
                    params.append(int(clean_value(widened_coeff)))
                else:
                    encoded_coeff = np.asarray(coeff, dtype=np_type).view(np.uint16)
                    params.append(int(clean_value(encoded_coeff)))
            else:
                encoded_coeff = np.asarray(coeff, dtype=np_type).view(np.uint32)
                params.append(clean_value(encoded_coeff))

    for bp in bst_bps:
        if np_type == np.float16:
            if super_fmt == "FP32":
                params.append(int(clean_value(widen_fp_for_compare(bp, np_type))))
            else:
                encoded_bp = np.asarray(bp, dtype=np_type).view(np.uint16)
                params.append(int(clean_value(encoded_bp)))
        else:
            encoded_bp = np.asarray(bp, dtype=np_type).view(np.uint32)
            params.append(clean_value(encoded_bp))

    if np_type == np.float16:
        if super_fmt == "FP32":
            params.append(int(clean_value(widen_fp_for_compare(eps, np_type))))
            if eps_const is not None:
                val_eps_const = np_type(eps_const).view(np.uint16).astype(np.uint32)
                params.append(int(clean_value(val_eps_const)))
        else:
            params.append(int(clean_value(np_type(eps).view(np.uint16))))
            if eps_const is not None:
                val_eps_const = np_type(eps_const).view(np.uint16).astype(np.uint16)
                params.append(int(clean_value(val_eps_const)))
    else:
        if super_fmt == "FP32":
            eps_val = np_type(eps).view(np.uint32)
            params.append(clean_value(eps_val))
            if eps_const is not None:
                eps_const_val = np.asarray(eps_const, dtype=np_type).view(np.uint32)
                params.append(clean_value(eps_const_val))
        else:
            eps_val = np_type(eps).view(np.uint16)
            params.append(clean_value(eps_val))
            if eps_const is not None:
                eps_const_val = np_type(eps_const).view(np.uint16)
                params.append(clean_value(eps_const_val))

    return params

def emit_header(**kwargs):
    prec = kwargs['prec']
    ctype = data_utils.ctype_from_precision_t(prec)
    numpy_type   = data_utils.numpy_type_from_precision_t(prec)
    fpu_data_width = kwargs.get("fpu_data_width", 64)
    softmax_unroll = int(kwargs.get("softmax_unroll", 8))
    num_cores = int(kwargs.get("num_cores", 1))
    if softmax_unroll not in SUPPORTED_SOFTMAX_UNROLLS:
        raise ValueError(f"softmax_unroll must be one of {SUPPORTED_SOFTMAX_UNROLLS}")
    if num_cores < 1:
        raise ValueError("num_cores must be at least 1")
    lane_count = pace_lane_count(numpy_type, fpu_data_width)
    layout = normalize_layout(kwargs.get("layout", "row-major"))
    row_interleaved = layout == "column-major"
    if row_interleaved and not (numpy_type == np.float16 and fpu_data_width == 64 and lane_count == 4):
        raise ValueError(
            "column-major layout currently requires FP16 with 64b FPU data width and 4 lanes"
        )
    int_type = _integer_precision_t(prec)
    hex_ctype = data_utils.hex_ctype_from_precision_t(int_type)
    param_hex_ctype = data_utils.hex_ctype_from_precision_t(_integer_precision_t("FP32"))
    xmin  = kwargs["x_min"]
    xmax  = kwargs["x_max"]
    n_deg  = kwargs["n_deg"]
    n_part = kwargs["n_part"]
    if "rows" in kwargs:
        Q = kwargs["rows"]
    elif "Q" in kwargs:
        Q = kwargs["Q"]
    else:
        raise KeyError("Missing required softmax dimension 'rows'")
    if "seq_len" in kwargs:
        K = kwargs["seq_len"]
    elif "K" in kwargs:
        K = kwargs["K"]
    else:
        raise KeyError("Missing required softmax dimension 'seq_len'")
    if row_interleaved and (Q % lane_count) != 0:
        raise ValueError(
            f"column-major layout requires Q={Q} to be divisible by PACE_LANES={lane_count}"
        )
    exp_approx = kwargs["exp"]
    frac_approx = kwargs["frac"]
    eps = kwargs["eps"]
    seed = kwargs.get("seed")
    bp_mode = kwargs.get("bp_mode", "nonuniform")
    output_dir = kwargs.get("output_dir")
    attn = generate_data(Q, K, numpy_type, xmin, xmax, seed=seed)
    exp_kwargs = {
        "degree": n_deg,
        "parts": n_part
    }
    inv_kwargs = {
        "degree": n_deg,
        "parts": n_part,
        "eps": eps
    }

    exp_func = EXP_FUNC[exp_approx]
    frac_func = FRAC_FUNC[frac_approx]
    # softmax_oup =compute_softmax_custom(attn, exp_func, frac_func, numpy_type, exp_kwargs, inv_kwargs)
    xmax_oup = find_xmax(attn, dtype=numpy_type)
    write_softmax_debug_file(resolve_output_path(output_dir, "debug_xmax.txt"),
                             debug_xmax_parallel(attn, dtype=numpy_type, fpu_data_width=fpu_data_width))
    attn_offs = offset_xmax(attn, xmax_oup, dtype=numpy_type)
    traces = debug_offset_xmax(attn, xmax_oup, dtype=numpy_type)
    write_softmax_debug_file(resolve_output_path(output_dir, "debug_offs.txt"), traces)
    attn_exp, raw_bps, coeffs = compute_exp_pwpa(
        attn_offs,
        dtype=numpy_type,
        degree=n_deg,
        parts=n_part,
        bp_mode=bp_mode,
    )
    bst_bps = build_bst_bps(raw_bps)
    eps_const = inv(eps)
    exp_params = arrange_params_32b(numpy_type, bst_bps[2:], coeffs, eps, eps_const, super_fmt="FP32")
    exp_params = np.asarray(exp_params, dtype=np.uint32)
    ofmap = attn_exp.astype(numpy_type)
    ofmap_golden = exp(attn_offs)
    deno = compute_deno_parallel_hw_configurable(
        attn_exp,
        dtype=numpy_type,
        fpu_data_width=fpu_data_width,
        softmax_unroll=softmax_unroll,
        row_interleaved=row_interleaved,
    )
    deno_trace = debug_deno_parallel_configurable(
        attn_exp,
        dtype=numpy_type,
        fpu_data_width=fpu_data_width,
        softmax_unroll=softmax_unroll,
        row_interleaved=row_interleaved,
    )
    pwpa_traces_0  = debug_pwpa_list(attn_offs[0], ofmap_golden[0], coeffs, raw_bps, bst_bps, n_deg, prec=prec, np_prec=numpy_type, fn_name="exp", eps=eps, eps_const=eps_const)
    pwpa_traces_1  = debug_pwpa_list(attn_offs[1], ofmap_golden[1], coeffs, raw_bps, bst_bps, n_deg, prec=prec, np_prec=numpy_type, fn_name="exp", eps=eps, eps_const=eps_const)


    inv_input = deno.reshape(-1) if row_interleaved else deno
    inv_deno_flat, inv_raw_bps, inv_coeffs = compute_inv_pwpa(
        inv_input,
        degree=n_deg,
        parts=n_part,
        eps=eps,
        dtype=numpy_type,
        prec=prec,
        bp_mode=bp_mode,
    )
    inv_deno = inv_deno_flat.reshape(deno.shape) if row_interleaved else inv_deno_flat
    inv_row_scalars = inv_deno.reshape(-1) if row_interleaved else inv_deno
    if row_interleaved:
        inv_rows = unpack_rows_across_lanes(
            np.repeat(inv_deno[:, np.newaxis, :], K, axis=1).reshape(deno.shape[0], K * lane_count),
            lane_count,
        )
        attn_oup = np.multiply(attn_exp, inv_rows, dtype=numpy_type).astype(numpy_type)
    else:
        attn_oup = compute_mul_hw(attn_exp, inv_deno, numpy_type)

    inv_bst_bps = build_bst_bps(inv_raw_bps)
    eps_const = inv(eps)
    eps_const = eps_const.astype(numpy_type)
    inv_deno_golden = inv(inv_input).astype(numpy_type)
    inv_pwpa_traces = debug_pwpa_list(
        inv_input,
        inv_deno_golden,
        inv_coeffs,
        inv_raw_bps,
        inv_bst_bps,
        n_deg,
        prec=prec,
        np_prec=numpy_type,
        fn_name="inv",
        eps=eps,
        eps_const=eps_const,
    )
    inv_params = arrange_params_32b(numpy_type, inv_bst_bps[2:], inv_coeffs, eps, eps_const, super_fmt="FP32")
    inv_params = np.asarray(inv_params, dtype=np.uint32)

    golden_attn = compute_softmax_golden(attn, numpy_type)
    print(np.max(golden_attn), np.min(golden_attn))
    print(np.max(attn_oup), np.min(attn_oup))
    # print(attn_oup[:][0:32])



    write_softmax_debug_file(resolve_output_path(output_dir, "debug_deno.txt"), deno_trace)
    write_softmax_debug_file(
        resolve_output_path(output_dir, "debug_mul.txt"),
        debug_mul(attn_exp, inv_row_scalars, attn_oup, dtype=numpy_type),
    )

    # write_softmax_debug_file("debug_softmax.txt", pwpa_traces)
    write_pwpa_debug_file(resolve_output_path(output_dir, "debug_softmax_0.txt"), raw_bps, bst_bps, coeffs, pwpa_traces_0, prec=numpy_type)
    write_pwpa_debug_file(resolve_output_path(output_dir, "debug_softmax_1.txt"), raw_bps, bst_bps, coeffs, pwpa_traces_1, prec=numpy_type)
    write_pwpa_debug_file(resolve_output_path(output_dir, "debug_inv_deno.txt"), inv_raw_bps, inv_bst_bps, inv_coeffs, inv_pwpa_traces, prec=numpy_type)



    # if fn_name in ["inv", "sqrt", "rsqrt"]:
    #     fn = ACTIVATIONS[fn_name]
    #     eps_const = fn(eps)
    # ifmap, ofmap_golden, ofmap_pwpa, raw_bps, bst_bps, coeffs = execute_pwpa(
    #     x_min, x_max, n_part, n_deg, n_test, fn_name, prec=prec, np_prec=numpy_type, eps=eps, eps_const=eps_const
    # )
    # pwpa_traces  = debug_pwpa_list(ifmap, ofmap_golden, coeffs, bst_bps, n_deg, prec=prec, np_prec=numpy_type, fn_name=fn_name, eps=eps, eps_const=eps_const)
    # debug_plot_pwpa(ifmap, ofmap_golden, ofmap_pwpa, fplot)
    # write_debug_file(fname, raw_bps, bst_bps, coeffs, pwpa_traces, prec=numpy_type)

    # params = arrange_params(numpy_type, bst_bps[2:], coeffs, eps, eps_const)
    # params = np.asarray(params, dtype=numpy_type)
    # ofmap = ofmap_pwpa.astype(numpy_type)

    ofmap = attn_oup.astype(numpy_type)

    ifmap_uid = 'ifmap'
    ofmap_uid = 'ofmap'
    exp_params_uid = 'exp_params'
    inv_params_uid = 'inv_params'
    golden_uid = 'golden'

    data_str = [
        emit_license(),
        "#ifndef PACE_SOFTMAX_DATA_H",
        "#define PACE_SOFTMAX_DATA_H",
        "#include <stdint.h>",
        "",
    ]

    data_str += generate_pace_mode_defines("EXP", exp_approx)
    data_str += generate_pace_mode_defines("INV", "inv")
    data_str += generate_pace_scalar_defines("EXP", exp_approx, prec)
    data_str += generate_pace_scalar_defines("INV", "inv", prec)
    data_str += generate_bp_mode_defines(bp_mode)
    data_str += [f'#define ENABLE_{prec} 1']
    data_str += [f'#define Q_SIZE {Q}']
    data_str += [f'#define K_SIZE {K}']
    data_str += [f'#define PACE_DEGREE {n_deg}']
    data_str += [f'#define NUM_CORES {num_cores}']
    data_str += [f'#define FPU_DATA_WIDTH {fpu_data_width}']
    data_str += [f'#define PACE_LANES {lane_count}']
    data_str += [f'#define PACE_LAYOUT_ROW_MAJOR {1 if layout == "row-major" else 0}']
    data_str += [f'#define PACE_LAYOUT_COLUMN_MAJOR {1 if layout == "column-major" else 0}']
    data_str += [f'#define EXP_PARAMS_LEN {len(exp_params)}']
    data_str += [f'#define INV_PARAMS_LEN {len(inv_params)}']
    data_str += [f'#define SOFTMAX_UNROLL {softmax_unroll}']
    data_str += [f'#define DENO_LENGTH {deno.size if row_interleaved else lane_count * len(deno)}']
    data_str += [f'typedef {ctype} data_t;']
    data_str += [f'typedef {param_hex_ctype} param_t;']

    ifmap_data = pack_rows_across_lanes(attn, lane_count) if row_interleaved else attn
    golden_data = pack_rows_across_lanes(attn_oup, lane_count) if row_interleaved else attn_oup
    ofmap_init = np.zeros_like(golden_data)
    data_str += [format_array_definition(param_hex_ctype, exp_params_uid, exp_params, alignment=64, hex_format=True)]
    data_str += [format_array_definition(param_hex_ctype, inv_params_uid, inv_params, alignment=64, hex_format=True)]
    data_str += [format_array_definition(ctype, ifmap_uid, ifmap_data, alignment=4096, hex_format=True)]
    data_str += [format_array_definition(ctype, ofmap_uid, ofmap_init, alignment=4096, hex_format=True)]
    data_str += [format_array_definition(ctype, golden_uid, golden_data, alignment=4096, hex_format=True)]
    data_str += ["#endif"]
    data_str = '\n\n'.join(data_str)

    return data_str


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-c", "--cfg",
        type=pathlib.Path,
        required=True,
        help='Select param config file kernel'
    )
    parser.add_argument(
        '--section',
        type=str,
        help='Section to store matrices in')
    parser.add_argument(
        'output',
        type=pathlib.Path,
        help='Path of the output header file')
    args = parser.parse_args()

    # sys.path.append(args.output.parent/f"scripts")

    # Load param config file
    param = load_config(args.cfg)
    param['debug_fname']=args.output.parent / f"{param['debug_fname']}"
    param['debug_plot']=args.output.parent / f"debug.png"
    param['output_dir'] = args.output.parent
    param['section'] = args.section
    param["name"] = args.output.stem

    # # Emit header file
    with open(args.output, 'w') as f:
        f.write(emit_header(**param))


if __name__ == '__main__':
    main()
