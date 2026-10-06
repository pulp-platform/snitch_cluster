#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

import argparse
import pathlib
import numpy as np
import sys
try:
    import torch
except ModuleNotFoundError:
    torch = None

_REPO_ROOT = pathlib.Path(__file__).resolve().parents[4]
_PACE_SCRIPTS_DIR = pathlib.Path(__file__).resolve().parent
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

try:
    from snitch.util.sim import data_utils
    from snitch.util.sim.data_utils import (
        _integer_precision_t,
        emit_license,
        format_array_definition,
    )
except ModuleNotFoundError:
    from util.sim import data_utils
    from util.sim.data_utils import (
        _integer_precision_t,
        emit_license,
        format_array_definition,
    )

if torch is not None:
    torch.manual_seed(42)
try:
    from snitch.pace.scripts.config import PaceConfig
    from snitch.pace.scripts.config_loader import PaceJsonConfigLoader
    from snitch.pace.scripts.datatype import PacePrecisionCodec
    from snitch.pace.scripts.debug import (
        PaceDebugFormatter,
        PacePWPADebugListBuilder,
        PacePWPADebugWriter,
        PaceSoftmaxTraceBuilder,
        PaceSoftmaxDebugWriter,
    )
    from snitch.pace.scripts.execution import PacePWPAExecutionFactory
    from snitch.pace.scripts.fit import PacePWPACoefficientFitter, PacePWPAFit
    from snitch.pace.scripts.golden import PaceActivationRegistry
    from snitch.pace.scripts.header_defines import PaceBreakpointModeDefines
    from snitch.pace.scripts.instruction import PaceInstructionSet
    from snitch.pace.scripts.parameter_packing import PaceParameterPacker
    from snitch.pace.scripts.partition import PacePartitionGenerator
    from snitch.pace.scripts.softmax import PaceSoftmaxGoldenReference, PaceSoftmaxOffsetStage
except ModuleNotFoundError:
    from config import PaceConfig
    from config_loader import PaceJsonConfigLoader
    from datatype import PacePrecisionCodec
    from debug import (
        PaceDebugFormatter,
        PacePWPADebugListBuilder,
        PacePWPADebugWriter,
        PaceSoftmaxTraceBuilder,
        PaceSoftmaxDebugWriter,
    )
    from execution import PacePWPAExecutionFactory
    from fit import PacePWPACoefficientFitter, PacePWPAFit
    from golden import PaceActivationRegistry
    from header_defines import PaceBreakpointModeDefines
    from instruction import PaceInstructionSet
    from parameter_packing import PaceParameterPacker
    from partition import PacePartitionGenerator
    from softmax import PaceSoftmaxGoldenReference, PaceSoftmaxOffsetStage


class PaceSoftmaxSupport:
    @staticmethod
    def load_config(path):
        return PaceJsonConfigLoader.load(path)

    XMAX_UNROLL_REGS = 4
    SUPPORTED_SOFTMAX_UNROLLS = (3, 4, 8)
    SUPPORTED_LAYOUTS = ("row-major", "column-major")

    @staticmethod
    def dtype_bits(dtype):
        return PacePrecisionCodec.dtype_bits(dtype)

    @staticmethod
    def pace_lane_count(dtype, fpu_data_width):
        bits = PaceSoftmaxSupport.dtype_bits(dtype)
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

    @staticmethod
    def pace_chunk_size(dtype, fpu_data_width):
        return (
            PaceSoftmaxSupport.XMAX_UNROLL_REGS
            * PaceSoftmaxSupport.pace_lane_count(dtype, fpu_data_width)
        )

    @staticmethod
    def deno_chunk_size(dtype, fpu_data_width, softmax_unroll=8, row_interleaved=False):
        if row_interleaved:
            return softmax_unroll
        return softmax_unroll * PaceSoftmaxSupport.pace_lane_count(dtype, fpu_data_width)

    @staticmethod
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
                f"Unsupported layout '{layout}'. Expected one of "
                f"{PaceSoftmaxSupport.SUPPORTED_LAYOUTS}"
            )
        return aliases[normalized]

    @staticmethod
    def pack_rows_across_lanes(arr, lanes):
        arr = np.asarray(arr)
        q, k = arr.shape
        if q % lanes != 0:
            raise ValueError(
                f"Q={q} must be divisible by lanes={lanes} for row-interleaved packing"
            )
        return (
            arr.reshape(q // lanes, lanes, k)
            .transpose(0, 2, 1)
            .reshape(q // lanes, k * lanes)
        )

    @staticmethod
    def unpack_rows_across_lanes(arr, lanes):
        arr = np.asarray(arr)
        groups, packed_k = arr.shape
        if packed_k % lanes != 0:
            raise ValueError(f"Packed width {packed_k} must be divisible by lanes={lanes}")
        k = packed_k // lanes
        return arr.reshape(groups, k, lanes).transpose(0, 2, 1).reshape(groups * lanes, k)

    @staticmethod
    def grouped_rows_view(arr, lanes):
        arr = np.asarray(arr)
        q, k = arr.shape
        if q % lanes != 0:
            raise ValueError(f"Q={q} must be divisible by lanes={lanes} for row grouping")
        return arr.reshape(q // lanes, lanes, k).transpose(0, 2, 1)

    @staticmethod
    def pace_dtype_key(prec, super_fmt="FP32"):
        return PacePrecisionCodec(prec, super_fmt).dtype_key()

    @staticmethod
    def generate_pace_mode_defines(prefix, fn_name, extend=False):
        mode_name = PaceInstructionSet.mode_for_function(fn_name)
        codec = PacePrecisionCodec("FP32")
        return PaceInstructionSet(
            mode_name, codec, extend=extend
        ).prefixed_mode_defines(prefix)

    @staticmethod
    def generate_pace_scalar_defines(prefix, fn_name, prec, super_fmt="FP32", extend=False):
        mode_name = PaceInstructionSet.mode_for_function(fn_name)
        codec = PacePrecisionCodec(prec, super_fmt)
        return PaceInstructionSet(
            mode_name, codec, extend=extend
        ).prefixed_scalar_defines(prefix)

    @staticmethod
    def generate_bp_mode_defines(bp_mode):
        return PaceBreakpointModeDefines(bp_mode).defines()

    @staticmethod
    def generate_data(Q, K, np_type, xmin, xmax, seed=None):
        rng = np.random.default_rng(seed)
        attn = rng.uniform(xmin, xmax, size=(Q, K))
        return attn.astype(np_type)

    @staticmethod
    def resolve_output_path(output_dir, filename):
        if output_dir is None:
            return pathlib.Path(filename)
        output_dir.mkdir(parents=True, exist_ok=True)
        return output_dir / filename

    @staticmethod
    def debug_xmax_parallel(attn, dtype=np.float64, fpu_data_width=64):
        Q, K = attn.shape
        attn = np.asarray(attn, dtype=dtype)
        lanes = PaceSoftmaxSupport.pace_lane_count(dtype, fpu_data_width)
        chunk_size = PaceSoftmaxSupport.pace_chunk_size(dtype, fpu_data_width)
        if K % chunk_size != 0:
            raise ValueError(
                "debug_xmax_parallel expects K to be divisible by "
                f"{chunk_size} for dtype={np.dtype(dtype).name} and "
                f"fpu_data_width={fpu_data_width}"
            )

        traces = []
        for q in range(Q):
            regs = np.full(
                (PaceSoftmaxSupport.XMAX_UNROLL_REGS, lanes), -np.inf, dtype=dtype
            )
            traces.append(f"=== q = {q} ===\n")

            for reg_idx in range(PaceSoftmaxSupport.XMAX_UNROLL_REGS):
                lane_init = []
                for lane in range(lanes):
                    regs[reg_idx, lane] = attn[q, reg_idx * lanes + lane]
                    lane_init.append(
                        f"lane{lane}(k={reg_idx * lanes + lane})="
                        f"{PaceDebugFormatter.float_to_hex(regs[reg_idx, lane], dtype)}"
                    )
                traces.append(f"init_reg{reg_idx}: {' '.join(lane_init)}\n")

            for blk in range(1, K // chunk_size):
                base = blk * chunk_size
                traces.append(f"[q={q},blk={blk}]\n")
                for reg_idx in range(PaceSoftmaxSupport.XMAX_UNROLL_REGS):
                    lane_msgs = []
                    for lane in range(lanes):
                        idx = base + reg_idx * lanes + lane
                        inp = attn[q, idx]
                        prev_max = regs[reg_idx, lane]
                        take = int(inp > prev_max)
                        if take:
                            regs[reg_idx, lane] = inp
                        inp_hex = PaceDebugFormatter.float_to_hex(inp, dtype)
                        prev_hex = PaceDebugFormatter.float_to_hex(prev_max, dtype)
                        after_hex = PaceDebugFormatter.float_to_hex(
                            regs[reg_idx, lane], dtype
                        )
                        lane_msgs.append(
                            f"lane{lane}(k={idx}) inp={inp_hex} "
                            f"max_before={prev_hex} "
                            f"take={take} "
                            f"max_after={after_hex}"
                        )
                    traces.append(f"reg{reg_idx}: {' | '.join(lane_msgs)}\n")

            reg01 = np.maximum(regs[0], regs[1], dtype=dtype)
            reg23 = np.maximum(regs[2], regs[3], dtype=dtype)
            regf = np.maximum(reg01, reg23, dtype=dtype)
            final_lane = int(np.argmax(regf))
            final_max = regf[final_lane]
            traces.append(
                f"[q={q},reduction]\n"
                f"reg0={[PaceDebugFormatter.float_to_hex(v, dtype) for v in regs[0]]}\n"
                f"reg1={[PaceDebugFormatter.float_to_hex(v, dtype) for v in regs[1]]}\n"
                f"reg2={[PaceDebugFormatter.float_to_hex(v, dtype) for v in regs[2]]}\n"
                f"reg3={[PaceDebugFormatter.float_to_hex(v, dtype) for v in regs[3]]}\n"
                f"reg01={[PaceDebugFormatter.float_to_hex(v, dtype) for v in reg01]}\n"
                f"reg23={[PaceDebugFormatter.float_to_hex(v, dtype) for v in reg23]}\n"
                f"regf={[PaceDebugFormatter.float_to_hex(v, dtype) for v in regf]}\n"
                f"final_lane={final_lane}\n"
                f"final_max={PaceDebugFormatter.float_to_hex(final_max, dtype)}\n"
            )
        return traces

    @staticmethod
    def fadd_hw(a, b, dtype):
        a_dt = np.asarray(a, dtype=dtype)
        b_dt = np.asarray(b, dtype=dtype)
        return np.add(a_dt, b_dt, dtype=dtype)

    @staticmethod
    def log_reg_hw(trace, name, v, dtype):
        trace.append(
            f"{name}: "
            f"{[PaceDebugFormatter.float_to_hex(el, dtype) for el in np.asarray(v, dtype=dtype)]}\n"
        )

    @staticmethod
    def log_reg_op(trace, dst, src_a, src_b, out, dtype):
        trace.append(
            f"{dst} = {src_a} + {src_b}: "
            f"{[PaceDebugFormatter.float_to_hex(el, dtype) for el in out]}\n"
        )

    @staticmethod
    def reduce_accumulators_hw(acc_regs, dtype, trace=None, names=None):
        acc_regs = [np.asarray(reg, dtype=dtype).copy() for reg in acc_regs]
        if names is None:
            names = [f"acc{idx}" for idx in range(len(acc_regs))]

        if len(acc_regs) == 4:
            sum01 = np.add(acc_regs[0], acc_regs[1], dtype=dtype)
            sum23 = np.add(acc_regs[2], acc_regs[3], dtype=dtype)
            total = np.add(sum01, sum23, dtype=dtype)
            if trace is not None:
                PaceSoftmaxSupport.log_reg_op(
                    trace, names[0], names[1], names[0], sum01, dtype
                )
                PaceSoftmaxSupport.log_reg_op(
                    trace, names[2], names[2], names[3], sum23, dtype
                )
                PaceSoftmaxSupport.log_reg_op(
                    trace, names[0], names[2], names[0], total, dtype
                )
            return total

        if len(acc_regs) == 3:
            sum01 = np.add(acc_regs[0], acc_regs[1], dtype=dtype)
            total = np.add(sum01, acc_regs[2], dtype=dtype)
            if trace is not None:
                PaceSoftmaxSupport.log_reg_op(
                    trace, names[0], names[1], names[0], sum01, dtype
                )
                PaceSoftmaxSupport.log_reg_op(
                    trace, names[0], names[2], names[0], total, dtype
                )
            return total

        if len(acc_regs) == 2:
            total = np.add(acc_regs[0], acc_regs[1], dtype=dtype)
            if trace is not None:
                PaceSoftmaxSupport.log_reg_op(
                    trace, names[0], names[0], names[1], total, dtype
                )
            return total

        if len(acc_regs) == 1:
            return acc_regs[0]

        total = acc_regs[0]
        for idx in range(1, len(acc_regs)):
            total = np.add(total, acc_regs[idx], dtype=dtype)
            if trace is not None:
                PaceSoftmaxSupport.log_reg_op(
                    trace, names[0], names[0], names[idx], total, dtype
                )
        return total

    @staticmethod
    def reduce_lanes_hw(vec, dtype):
        vec = np.asarray(vec, dtype=dtype)
        lanes = vec.shape[0]

        if lanes == 1:
            return vec[0], [
                f"lane0 = {PaceDebugFormatter.float_to_hex(vec[0], dtype)}\n",
            ]

        if lanes == 2:
            sum01 = np.add(vec[0], vec[1], dtype=dtype)
            return sum01, [
                f"flw0 = {PaceDebugFormatter.float_to_hex(vec[0], dtype)}\n",
                f"flw1 = {PaceDebugFormatter.float_to_hex(vec[1], dtype)}\n",
                f"sum01 = flw0 + flw1 = {PaceDebugFormatter.float_to_hex(sum01, dtype)}\n",
            ]

        if lanes == 4:
            sum01 = np.add(vec[0], vec[1], dtype=dtype)
            sum23 = np.add(vec[2], vec[3], dtype=dtype)
            sum0123 = np.add(sum01, sum23, dtype=dtype)
            return sum0123, [
                f"flh0 = {PaceDebugFormatter.float_to_hex(vec[0], dtype)}\n",
                f"flh1 = {PaceDebugFormatter.float_to_hex(vec[1], dtype)}\n",
                f"flh2 = {PaceDebugFormatter.float_to_hex(vec[2], dtype)}\n",
                f"flh3 = {PaceDebugFormatter.float_to_hex(vec[3], dtype)}\n",
                f"sum01 = flh0 + flh1 = {PaceDebugFormatter.float_to_hex(sum01, dtype)}\n",
                f"sum23 = flh2 + flh3 = {PaceDebugFormatter.float_to_hex(sum23, dtype)}\n",
                f"sum0123 = sum01 + sum23 = {PaceDebugFormatter.float_to_hex(sum0123, dtype)}\n",
            ]

        acc = np.asarray(0.0, dtype=dtype)
        trace = []
        for lane, value in enumerate(vec):
            trace.append(f"lane{lane} = {PaceDebugFormatter.float_to_hex(value, dtype)}\n")
            acc = np.add(acc, value, dtype=dtype)
            trace.append(f"acc_after_lane{lane} = {PaceDebugFormatter.float_to_hex(acc, dtype)}\n")
        return acc, trace

    @staticmethod
    def debug_deno_parallel(attn_exp, dtype, fpu_data_width=64):
        return PaceSoftmaxSupport.debug_deno_parallel_configurable(
            attn_exp, dtype, fpu_data_width=fpu_data_width
        )

    @staticmethod
    def debug_deno_parallel_configurable(
        attn_exp, dtype, fpu_data_width=64, softmax_unroll=8, row_interleaved=False
    ):
        Q, K = attn_exp.shape
        attn = np.asarray(attn_exp, dtype=dtype)
        lanes = PaceSoftmaxSupport.pace_lane_count(dtype, fpu_data_width)
        if softmax_unroll not in PaceSoftmaxSupport.SUPPORTED_SOFTMAX_UNROLLS:
            raise ValueError(f"Unsupported softmax unroll {softmax_unroll}")
        chunk_size = PaceSoftmaxSupport.deno_chunk_size(
            dtype, fpu_data_width, softmax_unroll=softmax_unroll,
            row_interleaved=row_interleaved
        )
        if K % chunk_size != 0:
            raise ValueError(
                "debug_deno_parallel expects K to be divisible by "
                f"{chunk_size} for dtype={np.dtype(dtype).name} and "
                f"fpu_data_width={fpu_data_width}"
            )

        trace = []
        independent_accum = (softmax_unroll in (3, 4))

        if row_interleaved:
            grouped = PaceSoftmaxSupport.grouped_rows_view(attn, lanes)
            reg_names = ["ft4", "ft5", "ft6", "ft7", "fs0", "fs1", "fa0", "fa1"][
                :softmax_unroll
            ]
            acc_count = softmax_unroll if independent_accum else max(1, softmax_unroll // 2)
            for qg in range(grouped.shape[0]):
                acc_regs = np.zeros((acc_count, lanes), dtype=dtype)
                trace.append(f"\n=== q_group = {qg} ===\n")
                for reg_idx in range(acc_count):
                    PaceSoftmaxSupport.log_reg_hw(
                        trace, f"init acc{reg_idx}", acc_regs[reg_idx], dtype
                    )

                for blk in range(K // chunk_size):
                    base = blk * chunk_size
                    trace.append(f"-- blk {blk} (k={base}..{base + chunk_size - 1})\n")
                    exp_regs = []
                    for reg_idx in range(softmax_unroll):
                        vec = np.asarray(grouped[qg, base + reg_idx, :], dtype=dtype)
                        exp_regs.append(vec)
                        PaceSoftmaxSupport.log_reg_hw(trace, reg_names[reg_idx], vec, dtype)
                    if independent_accum:
                        for acc_idx in range(acc_count):
                            acc_regs[acc_idx] = np.add(
                                acc_regs[acc_idx], exp_regs[acc_idx], dtype=dtype
                            )
                            PaceSoftmaxSupport.log_reg_op(
                                trace, f"acc{acc_idx}", f"acc{acc_idx}",
                                reg_names[acc_idx], acc_regs[acc_idx], dtype
                            )
                    else:
                        for acc_idx in range(acc_count):
                            pair = np.add(
                                exp_regs[2 * acc_idx + 1], exp_regs[2 * acc_idx], dtype=dtype
                            )
                            acc_regs[acc_idx] = np.add(acc_regs[acc_idx], pair, dtype=dtype)
                            PaceSoftmaxSupport.log_reg_op(
                                trace, f"acc{acc_idx}", f"acc{acc_idx}",
                                f"pair{acc_idx}", acc_regs[acc_idx], dtype
                            )

                trace.append("-- register reduction across unrolled accumulators\n")
                acc = PaceSoftmaxSupport.reduce_accumulators_hw(
                    acc_regs, dtype, trace=trace,
                    names=[f"acc{idx}" for idx in range(acc_count)]
                )
                acc_hex = [PaceDebugFormatter.float_to_hex(el, dtype) for el in acc]
                trace.append(f"out[{qg}] = {acc_hex}\n")
            return trace

        for q in range(Q):
            acc_count = softmax_unroll if independent_accum else max(1, softmax_unroll // 2)
            acc_regs = np.zeros((acc_count, lanes), dtype=dtype)
            trace.append(f"\n=== q = {q} ===\n")
            trace.append(
                f"Denominator accumulation with {softmax_unroll} exp registers "
                f"and {lanes} lane(s)\n"
            )
            for reg_idx in range(acc_regs.shape[0]):
                PaceSoftmaxSupport.log_reg_hw(
                    trace, f"init fs{8 + reg_idx}", acc_regs[reg_idx], dtype
                )

            for blk in range(K // chunk_size):
                base = blk * chunk_size
                trace.append(f"-- blk {blk} (k={base}..{base + chunk_size - 1})\n")

                exp_regs = []
                reg_names = ["ft4", "ft5", "ft6", "ft7", "fs0", "fs1", "fa0", "fa1"][
                    :softmax_unroll
                ]
                for reg_idx in range(softmax_unroll):
                    vec = np.asarray(
                        [attn[q, base + reg_idx * lanes + lane] for lane in range(lanes)],
                        dtype=dtype,
                    )
                    exp_regs.append(vec)
                    PaceSoftmaxSupport.log_reg_hw(trace, reg_names[reg_idx], vec, dtype)

                if independent_accum:
                    for reg_idx in range(acc_regs.shape[0]):
                        acc_regs[reg_idx] = np.add(
                            acc_regs[reg_idx], exp_regs[reg_idx], dtype=dtype
                        )
                        PaceSoftmaxSupport.log_reg_op(
                            trace, f"acc{reg_idx}", f"acc{reg_idx}",
                            reg_names[reg_idx], acc_regs[reg_idx], dtype
                        )
                else:
                    pair_regs = []
                    for reg_idx in range(acc_regs.shape[0]):
                        pair = np.add(
                            exp_regs[2 * reg_idx + 1], exp_regs[2 * reg_idx],
                            dtype=dtype
                        )
                        pair_regs.append(pair)
                        PaceSoftmaxSupport.log_reg_op(
                            trace, f"pair{reg_idx}", reg_names[2 * reg_idx + 1],
                            reg_names[2 * reg_idx], pair, dtype
                        )

                    for reg_idx in range(acc_regs.shape[0]):
                        acc_regs[reg_idx] = np.add(
                            acc_regs[reg_idx], pair_regs[reg_idx], dtype=dtype
                        )
                        PaceSoftmaxSupport.log_reg_op(
                            trace, f"acc{reg_idx}", f"acc{reg_idx}",
                            f"pair{reg_idx}", acc_regs[reg_idx], dtype
                        )

            trace.append("-- register reduction across the unrolled accumulators\n")
            reduced = PaceSoftmaxSupport.reduce_accumulators_hw(
                acc_regs, dtype, trace=trace,
                names=[f"acc{idx}" for idx in range(acc_regs.shape[0])]
            )

            trace.append("-- final lane reduction\n")
            trace.append(f"acc0={[PaceDebugFormatter.float_to_hex(el, dtype) for el in reduced]}\n")
            out0, lane_trace = PaceSoftmaxSupport.reduce_lanes_hw(reduced, dtype)
            trace.extend(lane_trace)
            trace.append(f"out[{q}] = {PaceDebugFormatter.float_to_hex(out0, dtype)}\n")

        return trace

    @staticmethod
    def compute_deno_parallel_hw(attn_exp, dtype, fpu_data_width=64):
        return PaceSoftmaxSupport.compute_deno_parallel_hw_configurable(
            attn_exp, dtype, fpu_data_width=fpu_data_width
        )

    @staticmethod
    def compute_deno_parallel_hw_configurable(
        attn_exp, dtype, fpu_data_width=64, softmax_unroll=8, row_interleaved=False
    ):
        Q, K = attn_exp.shape
        attn = np.asarray(attn_exp, dtype=dtype)
        lanes = PaceSoftmaxSupport.pace_lane_count(dtype, fpu_data_width)
        if softmax_unroll not in PaceSoftmaxSupport.SUPPORTED_SOFTMAX_UNROLLS:
            raise ValueError(f"Unsupported softmax unroll {softmax_unroll}")
        chunk_size = PaceSoftmaxSupport.deno_chunk_size(
            dtype, fpu_data_width, softmax_unroll=softmax_unroll, row_interleaved=row_interleaved
        )
        if K % chunk_size != 0:
            raise ValueError(
                "compute_deno_parallel_hw expects K to be divisible by "
                f"{chunk_size} for dtype={np.dtype(dtype).name} and fpu_data_width={fpu_data_width}"
            )

        independent_accum = (softmax_unroll in (3, 4))

        if row_interleaved:
            grouped = PaceSoftmaxSupport.grouped_rows_view(attn, lanes)
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
                out[qg] = PaceSoftmaxSupport.reduce_accumulators_hw(acc_regs, dtype)
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
                        acc_regs[reg_idx] = np.add(
                            acc_regs[reg_idx], exp_regs[reg_idx], dtype=dtype
                        )
                else:
                    pair_regs = []
                    for reg_idx in range(acc_regs.shape[0]):
                        pair_regs.append(
                            np.add(
                                exp_regs[2 * reg_idx + 1], exp_regs[2 * reg_idx],
                                dtype=dtype
                            )
                        )
                    for reg_idx in range(acc_regs.shape[0]):
                        acc_regs[reg_idx] = np.add(
                            acc_regs[reg_idx], pair_regs[reg_idx], dtype=dtype
                        )

            reduced = PaceSoftmaxSupport.reduce_accumulators_hw(acc_regs, dtype)
            out[q], _ = PaceSoftmaxSupport.reduce_lanes_hw(reduced, dtype)

        return out.astype(dtype)

    @staticmethod
    def debug_mul(attn_exp, inv_deno, attn_oup, dtype=np.float64):
        Q, K = attn_exp.shape
        attn_exp = np.asarray(attn_exp, dtype=dtype)
        inv_deno = np.asarray(inv_deno, dtype=dtype)
        attn_oup = np.asarray(attn_oup, dtype=dtype)
        trace = []
        for q in range(Q):
            trace.append(f"=== q = {q} ===\n")
            trace.append(f"inv_deno={PaceDebugFormatter.float_to_hex(inv_deno[q], dtype)}\n")
            for k in range(K):
                trace.append(
                    f"[q={q},k={k}]\n"
                    f"exp={PaceDebugFormatter.float_to_hex(attn_exp[q, k], dtype)}\n"
                    f"inv={PaceDebugFormatter.float_to_hex(inv_deno[q], dtype)}\n"
                    f"oup={PaceDebugFormatter.float_to_hex(attn_oup[q, k], dtype)}\n"
                )
        return trace

    @staticmethod
    def compute_mul_hw(attn_exp, inv_deno, dtype):
        Q, K = attn_exp.shape
        attn_exp = np.asarray(attn_exp, dtype=dtype)
        inv_deno = np.asarray(inv_deno, dtype=dtype)
        attn_oup = np.zeros((Q, K), dtype=dtype)
        for q in range(Q):
            for k in range(K):
                attn_oup[q, k] = np.multiply(attn_exp[q, k], inv_deno[q], dtype=dtype)
        return attn_oup.astype(dtype)

    @staticmethod
    def widen_fp_for_compare(raw, fmt):
        return PacePrecisionCodec.widen_fp_for_compare(raw, fmt)

    @staticmethod
    def widen_fp_for_fma(raw, fmt):
        return PacePrecisionCodec.widen_fp_for_fma(raw, fmt)

    @staticmethod
    def arrange_params_32b(
        np_type, bst_bps, coeffs, eps=10**-6, eps_const=0, super_fmt="FP32"
    ):
        prec = "FP16" if np_type == np.float16 else "FP32"
        codec = PacePrecisionCodec(prec, super_fmt)
        return PaceParameterPacker(codec, numpy_type=np_type, super_fmt=super_fmt).pack(
            bst_bps, coeffs, eps=eps, eps_const=eps_const
        )


class PaceSoftmaxHardwareEmulator:
    def __init__(self, dtype, fpu_data_width, softmax_unroll=8):
        self.dtype = dtype
        self.fpu_data_width = fpu_data_width
        self.softmax_unroll = softmax_unroll
        self.lanes = PaceSoftmaxSupport.pace_lane_count(dtype, fpu_data_width)

    def validate_unroll(self):
        if self.softmax_unroll not in PaceSoftmaxSupport.SUPPORTED_SOFTMAX_UNROLLS:
            raise ValueError(
                "softmax_unroll must be one of "
                f"{PaceSoftmaxSupport.SUPPORTED_SOFTMAX_UNROLLS}"
            )

    def debug_xmax(self, attn):
        return PaceSoftmaxSupport.debug_xmax_parallel(
            attn, dtype=self.dtype, fpu_data_width=self.fpu_data_width
        )

    def compute_deno(self, attn_exp, row_interleaved=False):
        return PaceSoftmaxSupport.compute_deno_parallel_hw_configurable(
            attn_exp,
            dtype=self.dtype,
            fpu_data_width=self.fpu_data_width,
            softmax_unroll=self.softmax_unroll,
            row_interleaved=row_interleaved,
        )

    def debug_deno(self, attn_exp, row_interleaved=False):
        return PaceSoftmaxSupport.debug_deno_parallel_configurable(
            attn_exp,
            dtype=self.dtype,
            fpu_data_width=self.fpu_data_width,
            softmax_unroll=self.softmax_unroll,
            row_interleaved=row_interleaved,
        )

    def compute_mul(self, attn_exp, inv_deno):
        return PaceSoftmaxSupport.compute_mul_hw(attn_exp, inv_deno, self.dtype)

    def debug_mul(self, attn_exp, inv_deno, attn_oup):
        return PaceSoftmaxSupport.debug_mul(
            attn_exp, inv_deno, attn_oup, dtype=self.dtype
        )


class PaceSoftmaxMemoryLayout:
    name = None
    row_interleaved = False

    def __init__(self, kernel):
        self.kernel = kernel

    def validate(self):
        pass

    def row_major_define(self):
        return int(self.name == "row-major")

    def column_major_define(self):
        return int(self.name == "column-major")

    def deno_length(self, deno):
        return self.kernel.lane_count * len(deno)

    def compute_deno(self, attn_exp):
        return self.kernel.hardware.compute_deno(
            attn_exp, row_interleaved=self.row_interleaved
        )

    def debug_deno(self, attn_exp):
        return self.kernel.hardware.debug_deno(
            attn_exp, row_interleaved=self.row_interleaved
        )

    def ifmap_data(self, attn):
        return attn

    def golden_data(self, attn_oup):
        return attn_oup

    def inverse_input(self, deno):
        return deno

    def reshape_inverse(self, inv_deno_flat, deno):
        return inv_deno_flat

    def inverse_row_scalars(self, inv_deno):
        return inv_deno

    def compute_output(self, attn_exp, inv_deno, deno):
        return self.kernel.hardware.compute_mul(attn_exp, inv_deno)


class PaceRowMajorSoftmaxMemoryLayout(PaceSoftmaxMemoryLayout):
    name = "row-major"


class PaceColumnMajorSoftmaxMemoryLayout(PaceSoftmaxMemoryLayout):
    name = "column-major"
    row_interleaved = True

    def validate(self):
        k = self.kernel
        if not (
            k.numpy_type == np.float16
            and k.fpu_data_width == 64
            and k.lane_count == 4
        ):
            raise ValueError(
                "column-major layout currently requires FP16 with 64b FPU data "
                "width and 4 lanes"
            )
        if (k.q_size % k.lane_count) != 0:
            raise ValueError(
                f"column-major layout requires Q={k.q_size} to be divisible "
                f"by PACE_LANES={k.lane_count}"
            )

    def deno_length(self, deno):
        return deno.size

    def ifmap_data(self, attn):
        return PaceSoftmaxSupport.pack_rows_across_lanes(attn, self.kernel.lane_count)

    def golden_data(self, attn_oup):
        return PaceSoftmaxSupport.pack_rows_across_lanes(
            attn_oup, self.kernel.lane_count
        )

    def inverse_input(self, deno):
        return deno.reshape(-1)

    def reshape_inverse(self, inv_deno_flat, deno):
        return inv_deno_flat.reshape(deno.shape)

    def inverse_row_scalars(self, inv_deno):
        return inv_deno.reshape(-1)

    def compute_output(self, attn_exp, inv_deno, deno):
        k = self.kernel
        inv_rows = PaceSoftmaxSupport.unpack_rows_across_lanes(
            np.repeat(inv_deno[:, np.newaxis, :], k.k_size, axis=1)
            .reshape(deno.shape[0], k.k_size * k.lane_count),
            k.lane_count,
        )
        return np.multiply(attn_exp, inv_rows, dtype=k.numpy_type).astype(k.numpy_type)


class PaceSoftmaxLayoutRegistry:
    LAYOUTS = {
        "row-major": PaceRowMajorSoftmaxMemoryLayout,
        "column-major": PaceColumnMajorSoftmaxMemoryLayout,
    }

    @classmethod
    def create(cls, name, kernel):
        normalized = PaceSoftmaxSupport.normalize_layout(name)
        return cls.LAYOUTS[normalized](kernel)


SoftmaxHardware = PaceSoftmaxHardwareEmulator
SoftmaxLayout = PaceSoftmaxMemoryLayout
RowMajorSoftmaxLayout = PaceRowMajorSoftmaxMemoryLayout
ColumnMajorSoftmaxLayout = PaceColumnMajorSoftmaxMemoryLayout


class PaceSoftmaxExpStageResult:
    def __init__(self, output, raw_bps, bst_bps, coeffs, params, trace_row0, trace_row1):
        self.output = output
        self.raw_bps = raw_bps
        self.bst_bps = bst_bps
        self.coeffs = coeffs
        self.params = params
        self.trace_row0 = trace_row0
        self.trace_row1 = trace_row1


class PaceSoftmaxDenoStageResult:
    def __init__(self, output, trace):
        self.output = output
        self.trace = trace


class PaceSoftmaxInverseStageResult:
    def __init__(
        self,
        output,
        row_scalars,
        raw_bps,
        bst_bps,
        coeffs,
        traces,
        params,
    ):
        self.output = output
        self.row_scalars = row_scalars
        self.raw_bps = raw_bps
        self.bst_bps = bst_bps
        self.coeffs = coeffs
        self.traces = traces
        self.params = params


class PaceSoftmaxParameterPacker:
    def __init__(self, numpy_type, super_fmt="FP32"):
        self.numpy_type = numpy_type
        self.super_fmt = super_fmt

    def pack(self, bst_bps, coeffs, eps, eps_const):
        return np.asarray(
            PaceSoftmaxSupport.arrange_params_32b(
                self.numpy_type,
                bst_bps[2:],
                coeffs,
                eps,
                eps_const,
                super_fmt=self.super_fmt,
            ),
            dtype=np.uint32,
        )


class PaceSoftmaxHeaderDefines:
    def __init__(self, kernel):
        self.kernel = kernel

    def mode_defines(self):
        k = self.kernel
        return (
            PaceSoftmaxSupport.generate_pace_mode_defines("EXP", k.exp_approx)
            + PaceSoftmaxSupport.generate_pace_mode_defines("INV", "inv")
            + PaceSoftmaxSupport.generate_pace_scalar_defines("EXP", k.exp_approx, k.prec)
            + PaceSoftmaxSupport.generate_pace_scalar_defines("INV", "inv", k.prec)
            + PaceSoftmaxSupport.generate_bp_mode_defines(k.bp_mode)
        )

    def shape_defines(self, deno, exp_params, inv_params):
        k = self.kernel
        return [
            f'#define ENABLE_{k.prec} 1',
            f'#define Q_SIZE {k.q_size}',
            f'#define K_SIZE {k.k_size}',
            f'#define PACE_DEGREE {k.n_deg}',
            f'#define NUM_CORES {k.num_cores}',
            f'#define FPU_DATA_WIDTH {k.fpu_data_width}',
            f'#define PACE_LANES {k.lane_count}',
            f'#define PACE_LAYOUT_ROW_MAJOR {k.layout_strategy.row_major_define()}',
            f'#define PACE_LAYOUT_COLUMN_MAJOR {k.layout_strategy.column_major_define()}',
            f'#define EXP_PARAMS_LEN {len(exp_params)}',
            f'#define INV_PARAMS_LEN {len(inv_params)}',
            f'#define SOFTMAX_UNROLL {k.softmax_unroll}',
            f'#define DENO_LENGTH {k.layout_strategy.deno_length(deno)}',
        ]

    def type_defines(self):
        k = self.kernel
        return [
            f'typedef {k.ctype} data_t;',
            f'typedef {k.param_hex_ctype} param_t;',
        ]

    def all(self, deno, exp_params, inv_params):
        return (
            self.mode_defines()
            + self.shape_defines(deno, exp_params, inv_params)
            + self.type_defines()
        )


class PaceSoftmaxExecutionPlan:
    def __init__(self, kernel):
        self.kernel = kernel

    def stages(self):
        k = self.kernel
        return [
            (
                "xmax",
                "hardware max reduction over each row",
                f"{PaceSoftmaxSupport.XMAX_UNROLL_REGS} registers x {k.lane_count} lanes",
            ),
            (
                "offset",
                "hardware subtract row max from every input element",
                k.layout,
            ),
            (
                "exp_pwpa",
                "PACE evaluates exp approximation with breakpoint search and FMA",
                f"degree={k.n_deg}, parts={k.n_part}, bp_mode={k.bp_mode}",
            ),
            (
                "denominator",
                "hardware accumulates exp values with the configured softmax unroll",
                f"unroll={k.softmax_unroll}, lanes={k.lane_count}",
            ),
            (
                "inverse_pwpa",
                "PACE evaluates reciprocal denominator approximation",
                f"degree={k.n_deg}, parts={k.n_part}",
            ),
            (
                "multiply",
                "hardware multiplies exp(x - xmax) by reciprocal denominator",
                k.layout,
            ),
        ]

    def __str__(self):
        lines = [
            "Softmax hardware emulation:",
            (
                f"  precision={self.kernel.prec}, layout={self.kernel.layout}, "
                f"Q={self.kernel.q_size}, K={self.kernel.k_size}"
            ),
        ]
        for idx, (name, action, detail) in enumerate(self.stages()):
            lines.append(f"  {idx}: {name}: {action} ({detail})")
        return "\n".join(lines)


class PaceSoftmaxKernel:
    def __init__(self, **kwargs):
        self.kwargs = kwargs
        self.config = PaceConfig.from_mapping(kwargs)
        self.prec = self.config.prec
        self.ctype = self.config.c_type
        self.numpy_type = self.config.numpy_type
        self.fpu_data_width = self.config.fpu_data_width
        self.softmax_unroll = self.config.softmax_unroll
        self.num_cores = self.config.num_cores
        self.hardware = PaceSoftmaxHardwareEmulator(
            self.numpy_type, self.fpu_data_width, self.softmax_unroll
        )
        self.hardware.validate_unroll()
        if self.num_cores < 1:
            raise ValueError("num_cores must be at least 1")
        self.lane_count = self.hardware.lanes
        self.hex_ctype = self.config.hex_c_type
        self.param_hex_ctype = data_utils.hex_ctype_from_precision_t(
            _integer_precision_t("FP32")
        )
        self.xmin = self.config.x_min
        self.xmax = self.config.x_max
        self.n_deg = self.config.n_deg
        self.n_part = self.config.n_part
        self.q_size = self.config.q_size
        self.k_size = self.config.k_size
        self.layout = PaceSoftmaxSupport.normalize_layout(self.config.layout)
        self.layout_strategy = PaceSoftmaxLayoutRegistry.create(self.layout, self)
        self.layout_strategy.validate()
        self.exp_approx = self.config.exp_approx
        self.frac_approx = self.config.frac_approx
        self.eps = self.config.eps
        self.seed = self.config.seed
        self.bp_mode = self.config.bp_mode
        self.output_dir = self.config.output_dir
        self.param_packer = PaceSoftmaxParameterPacker(self.numpy_type)
        self.header_defines = PaceSoftmaxHeaderDefines(self)
        self.execution_plan = PaceSoftmaxExecutionPlan(self)

    def __str__(self):
        return str(self.execution_plan)

    def _dimension(self, preferred, legacy):
        if preferred in self.kwargs:
            return self.kwargs[preferred]
        if legacy in self.kwargs:
            return self.kwargs[legacy]
        raise KeyError(f"Missing required softmax dimension '{preferred}'")

    def generate_attention(self):
        return PaceSoftmaxSupport.generate_data(
            self.q_size,
            self.k_size,
            self.numpy_type,
            self.xmin,
            self.xmax,
            seed=self.seed,
        )

    def build_header(self, attn, attn_oup, deno, exp_params, inv_params):
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

        data_str += self.header_defines.all(deno, exp_params, inv_params)

        ifmap_data = self.layout_strategy.ifmap_data(attn)
        golden_data = self.layout_strategy.golden_data(attn_oup)
        ofmap_init = np.zeros_like(golden_data)
        data_str += [
            format_array_definition(
                self.param_hex_ctype, exp_params_uid, exp_params, alignment=64,
                hex_format=True
            )
        ]
        data_str += [
            format_array_definition(
                self.param_hex_ctype, inv_params_uid, inv_params, alignment=64,
                hex_format=True
            )
        ]
        data_str += [
            format_array_definition(
                self.ctype, ifmap_uid, ifmap_data, alignment=4096,
                hex_format=True
            )
        ]
        data_str += [
            format_array_definition(
                self.ctype, ofmap_uid, ofmap_init, alignment=4096,
                hex_format=True
            )
        ]
        data_str += [
            format_array_definition(
                self.ctype, golden_uid, golden_data, alignment=4096,
                hex_format=True
            )
        ]
        data_str += ["#endif"]
        return '\n\n'.join(data_str)

    def debug_path(self, filename):
        return PaceSoftmaxSupport.resolve_output_path(self.output_dir, filename)

    def write_softmax_debug(self, filename, traces):
        PaceSoftmaxDebugWriter(self.debug_path(filename)).write(traces)

    def write_pwpa_debug(self, filename, raw_bps, bst_bps, coeffs, traces):
        PacePWPADebugWriter(self.debug_path(filename), self.numpy_type).write(
            raw_bps, bst_bps, coeffs, traces
        )

    def write_debug_outputs(
        self,
        exp_stage,
        inverse_stage,
        attn_oup,
        deno_stage,
    ):
        self.write_softmax_debug("debug_deno.txt", deno_stage.trace)
        self.write_softmax_debug(
            "debug_mul.txt",
            self.hardware.debug_mul(
                exp_stage.output, inverse_stage.row_scalars, attn_oup
            ),
        )

        self.write_pwpa_debug(
            "debug_softmax_0.txt",
            exp_stage.raw_bps,
            exp_stage.bst_bps,
            exp_stage.coeffs,
            exp_stage.trace_row0,
        )
        self.write_pwpa_debug(
            "debug_softmax_1.txt",
            exp_stage.raw_bps,
            exp_stage.bst_bps,
            exp_stage.coeffs,
            exp_stage.trace_row1,
        )
        self.write_pwpa_debug(
            "debug_inv_deno.txt",
            inverse_stage.raw_bps,
            inverse_stage.bst_bps,
            inverse_stage.coeffs,
            inverse_stage.traces,
        )

    def compute_offset_stage(self, attn):
        xmax_oup = PaceSoftmaxOffsetStage.find_xmax(attn, dtype=self.numpy_type)
        self.write_softmax_debug(
            "debug_xmax.txt",
            self.hardware.debug_xmax(attn)
        )
        attn_offs = PaceSoftmaxOffsetStage.offset_xmax(
            attn, xmax_oup, dtype=self.numpy_type
        )
        traces = PaceSoftmaxTraceBuilder(dtype=self.numpy_type).offset_xmax(
            attn, xmax_oup
        )
        self.write_softmax_debug("debug_offs.txt", traces)
        return attn_offs

    def compute_exp_stage(self, attn_offs):
        exp_activation = PaceActivationRegistry.get("exp")
        partition = PacePartitionGenerator(
            self.n_part, self.bp_mode, precision=self.numpy_type
        ).generate(-11, 0)
        raw_bps = partition.breakpoints
        bst_bps = partition.bst_breakpoints
        coeffs = PacePWPACoefficientFitter(
            degree=self.n_deg, func=exp_activation
        ).fit(raw_bps)
        fit = PacePWPAFit(raw_bps=raw_bps, bst_bps=bst_bps, coeffs=coeffs)
        model = PacePWPAExecutionFactory.create(
            func=exp_activation,
            degree=self.n_deg,
            parts=self.n_part,
            bp_mode=self.bp_mode,
            precision=self.numpy_type,
        )
        eps_const = PaceActivationRegistry.evaluate("inv", self.eps)
        exp_params = self.param_packer.pack(bst_bps, coeffs, self.eps, eps_const)
        ofmap_golden = PaceActivationRegistry.evaluate("exp", attn_offs)
        attn_exp = np.asarray(attn_offs, dtype=self.numpy_type).copy()
        attn_exp[0], pwpa_traces_0 = PacePWPADebugListBuilder(
            degree=self.n_deg,
            prec=self.prec,
            np_prec=self.numpy_type,
            fn_name="exp",
            eps=self.eps,
            eps_const=eps_const,
        ).evaluate(
            attn_offs[0], ofmap_golden[0], coeffs, bst_bps
        )
        attn_exp[1], pwpa_traces_1 = PacePWPADebugListBuilder(
            degree=self.n_deg,
            prec=self.prec,
            np_prec=self.numpy_type,
            fn_name="exp",
            eps=self.eps,
            eps_const=eps_const,
        ).evaluate(
            attn_offs[1], ofmap_golden[1], coeffs, bst_bps
        )
        for q in range(2, attn_offs.shape[0]):
            attn_exp[q] = model.evaluate(attn_offs[q], fit).output
        return PaceSoftmaxExpStageResult(
            output=attn_exp,
            raw_bps=raw_bps,
            bst_bps=bst_bps,
            coeffs=coeffs,
            params=exp_params,
            trace_row0=pwpa_traces_0,
            trace_row1=pwpa_traces_1,
        )

    def compute_deno_stage(self, attn_exp):
        return PaceSoftmaxDenoStageResult(
            output=self.layout_strategy.compute_deno(attn_exp),
            trace=self.layout_strategy.debug_deno(attn_exp),
        )

    def compute_inverse_stage(self, deno):
        inv_activation = PaceActivationRegistry.get("inv")
        inv_input = self.layout_strategy.inverse_input(deno)
        inv_partition = PacePartitionGenerator(
            self.n_part, self.bp_mode, precision=self.numpy_type
        ).generate(1, 2)
        inv_raw_bps = inv_partition.breakpoints
        inv_bst_bps = inv_partition.bst_breakpoints
        inv_coeffs = PacePWPACoefficientFitter(
            degree=self.n_deg, func=inv_activation
        ).fit(inv_raw_bps)
        eps_const = PaceActivationRegistry.evaluate("inv", self.eps)
        eps_const = eps_const.astype(self.numpy_type)
        inv_deno_golden = PaceActivationRegistry.evaluate(
            "inv", inv_input
        ).astype(self.numpy_type)
        inv_deno_flat, inv_pwpa_traces = PacePWPADebugListBuilder(
            degree=self.n_deg,
            prec=self.prec,
            np_prec=self.numpy_type,
            fn_name="inv",
            eps=self.eps,
            eps_const=eps_const,
        ).evaluate(
            inv_input,
            inv_deno_golden,
            inv_coeffs,
            inv_bst_bps,
        )
        inv_deno = self.layout_strategy.reshape_inverse(inv_deno_flat, deno)
        inv_row_scalars = self.layout_strategy.inverse_row_scalars(inv_deno)
        inv_params = self.param_packer.pack(
            inv_bst_bps, inv_coeffs, self.eps, eps_const
        )
        return PaceSoftmaxInverseStageResult(
            output=inv_deno,
            row_scalars=inv_row_scalars,
            raw_bps=inv_raw_bps,
            bst_bps=inv_bst_bps,
            coeffs=inv_coeffs,
            traces=inv_pwpa_traces,
            params=inv_params,
        )

    def compute_output_stage(self, attn_exp, inv_deno, deno):
        return self.layout_strategy.compute_output(attn_exp, inv_deno, deno)

    def emit_header(self):
        attn = self.generate_attention()
        attn_offs = self.compute_offset_stage(attn)
        exp_stage = self.compute_exp_stage(attn_offs)
        deno_stage = self.compute_deno_stage(exp_stage.output)
        inverse_stage = self.compute_inverse_stage(deno_stage.output)
        attn_oup = self.compute_output_stage(
            exp_stage.output, inverse_stage.output, deno_stage.output
        )

        golden_attn = PaceSoftmaxGoldenReference.compute_softmax(attn, self.numpy_type)
        print(np.max(golden_attn), np.min(golden_attn))
        print(np.max(attn_oup), np.min(attn_oup))
        self.write_debug_outputs(exp_stage, inverse_stage, attn_oup, deno_stage)

        ofmap = attn_oup.astype(self.numpy_type)
        return self.build_header(
            attn, ofmap, deno_stage.output, exp_stage.params, inverse_stage.params
        )


class PaceSoftmaxDataGenerator:
    @staticmethod
    def emit_header(**kwargs):
        return PaceSoftmaxKernel(**kwargs).emit_header()


class PaceSoftmaxDatagenCLI:
    def parser(self):
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
        return parser

    def load_params(self, args):
        param = PaceSoftmaxSupport.load_config(args.cfg)
        param['debug_fname'] = args.output.parent / f"{param['debug_fname']}"
        param['debug_plot'] = args.output.parent / "debug.png"
        param['output_dir'] = args.output.parent
        param['section'] = args.section
        param["name"] = args.output.stem
        return param

    def run(self, argv=None):
        args = self.parser().parse_args(argv)
        param = self.load_params(args)
        with open(args.output, 'w') as f:
            f.write(PaceSoftmaxDataGenerator.emit_header(**param))


if __name__ == '__main__':
    PaceSoftmaxDatagenCLI().run()
