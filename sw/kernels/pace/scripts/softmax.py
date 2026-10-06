#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

import copy
import sys
from pathlib import Path

import numpy as np
try:
    import torch
except ModuleNotFoundError:
    torch = None

_REPO_ROOT = Path(__file__).resolve().parents[4]
_PACE_SCRIPTS_DIR = Path(__file__).resolve().parent
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

try:
    from snitch.pace.scripts.debug import PaceDebugFormatter
    from snitch.pace.scripts.evaluation import PacePWPAEvaluator
    from snitch.pace.scripts.fit import PacePWPACoefficientFitter
    from snitch.pace.scripts.golden import PaceActivationRegistry
    from snitch.pace.scripts.invert import PaceInverseSqrtEvaluator
    from snitch.pace.scripts.partition import PacePartitionGenerator
except ModuleNotFoundError:
    from debug import PaceDebugFormatter
    from evaluation import PacePWPAEvaluator
    from fit import PacePWPACoefficientFitter
    from golden import PaceActivationRegistry
    from invert import PaceInverseSqrtEvaluator
    from partition import PacePartitionGenerator

if torch is not None:
    torch.manual_seed(42)
np.random.seed(42)


class PaceSoftmaxOffsetStage:
    @staticmethod
    def find_xmax(attn, dtype=np.float64):
        Q, K = attn.shape
        attn = np.asarray(attn, dtype=np.float64)
        xmax = np.empty(Q, dtype=np.float64)

        for q in range(Q):
            m = attn[q, 0]
            for k in range(1, K):
                if attn[q, k] > m:
                    m = attn[q, k]
            xmax[q] = m

        return xmax.astype(dtype)

    @staticmethod
    def offset_xmax(attn, xmax, dtype=np.float64):
        Q, K = attn.shape
        attn = np.asarray(attn, dtype=dtype)
        attn = np.asarray(attn, dtype=np.float64)
        attn = np.asarray(attn, dtype=dtype)
        xmax = np.asarray(xmax, dtype=np.float64)
        attn_oup = np.asarray(attn, dtype=np.float64)
        for q in range(Q):
            for k in range(K):
                attn_oup[q, k] = attn[q, k] - xmax[q]
        return attn_oup.astype(dtype)


class PaceSoftmaxPWPAApproximation:
    @staticmethod
    def compute_exp(
        attn_offs, dtype=np.float32, degree=None, parts=None,
        bp_mode="nonuniform"
    ):
        xmin, xmax = -11, 0
        partition = PacePartitionGenerator(
            parts, bp_mode, precision=dtype
        ).generate(xmin, xmax)
        raw_bps = partition.breakpoints
        coeffs = PacePWPACoefficientFitter(
            degree=degree, func=PaceActivationRegistry.get("exp")
        ).fit(raw_bps)
        part_id = partition.bst_part_id(attn_offs)
        evaluator = PacePWPAEvaluator(degree, dtype)
        attn_exp = copy.deepcopy(attn_offs)
        Q, _ = attn_offs.shape
        for q in range(Q):
            attn_exp[q] = evaluator.evaluate(attn_offs[q], coeffs, part_id[q])
        return attn_exp, raw_bps, coeffs

    @staticmethod
    def compute_inverse(
        sum_deno, degree=2, parts=16, eps=1e-6, dtype=np.float32, prec="FP32",
        bp_mode="nonuniform"
    ):
        xmin, xmax = 1, 2
        partition = PacePartitionGenerator(
            parts, bp_mode, precision=dtype
        ).generate(xmin, xmax)
        raw_bps = partition.breakpoints
        coeffs = PacePWPACoefficientFitter(
            degree=degree, func=PaceActivationRegistry.get("inv")
        ).fit(raw_bps)
        eps_const = PaceActivationRegistry.evaluate("inv", eps)
        eps_const = eps_const.astype(dtype)
        inv_sum_deno = PaceInverseSqrtEvaluator(
            fn_name="inv",
            coeffs=coeffs,
            bps=raw_bps,
            degree=degree,
            eps=eps,
            eps_const=eps_const,
            prec=prec,
        ).evaluate(sum_deno)
        return inv_sum_deno.astype(dtype), raw_bps, coeffs


class PaceSoftmaxGoldenReference:
    @staticmethod
    def compute_exp(attn_offs, dtype):
        Q, _ = attn_offs.shape
        attn_exp = np.asarray(attn_offs, dtype=dtype)
        for q in range(Q):
            attn_exp[q] = PaceActivationRegistry.evaluate("exp", attn_offs[q])
        return attn_exp.astype(dtype)

    @staticmethod
    def compute_softmax(attn, out_dtype=np.float32):
        attn_np = np.asarray(attn, dtype=np.float32)
        if torch is None:
            row_max = np.max(attn_np, axis=1, keepdims=True)
            shifted = attn_np - row_max
            exp_shifted = np.exp(shifted)
            denom = np.sum(exp_shifted, axis=1, keepdims=True)
            return (exp_shifted / denom).astype(out_dtype)

        attn_t = torch.tensor(attn_np, dtype=torch.float32)
        softmax_t = torch.softmax(attn_t, dim=1)
        return softmax_t.cpu().numpy().astype(out_dtype)


class PaceSoftmaxArithmetic:
    @staticmethod
    def fadd(a, b, dtype):
        a64 = np.asarray(a, dtype=np.float64)
        b64 = np.asarray(b, dtype=np.float64)
        s64 = a64 + b64
        return np.asarray(s64, dtype=dtype)

    @staticmethod
    def log_reg2(trace, name, v, dtype):
        trace.append(
            f"{name}: [{PaceDebugFormatter.float_to_hex(v[0], dtype)}, "
            f"{PaceDebugFormatter.float_to_hex(v[1], dtype)}]\n"
        )

    @staticmethod
    def reduce_accumulators_exact(acc_regs, dtype):
        fadd = PaceSoftmaxArithmetic.fadd
        acc_regs = [np.asarray(reg, dtype=np.float64).copy() for reg in acc_regs]
        if len(acc_regs) == 4:
            sum01 = np.asarray(
                [
                    fadd(acc_regs[1][0], acc_regs[0][0], dtype),
                    fadd(acc_regs[1][1], acc_regs[0][1], dtype),
                ],
                dtype=np.float64,
            )
            sum23 = np.asarray(
                [
                    fadd(acc_regs[2][0], acc_regs[3][0], dtype),
                    fadd(acc_regs[2][1], acc_regs[3][1], dtype),
                ],
                dtype=np.float64,
            )
            total = np.asarray(
                [fadd(sum23[0], sum01[0], dtype), fadd(sum23[1], sum01[1], dtype)],
                dtype=np.float64,
            )
            return total, {"sum01": sum01, "sum23": sum23, "total": total}

        if len(acc_regs) == 3:
            sum01 = np.asarray(
                [
                    fadd(acc_regs[1][0], acc_regs[0][0], dtype),
                    fadd(acc_regs[1][1], acc_regs[0][1], dtype),
                ],
                dtype=np.float64,
            )
            total = np.asarray(
                [
                    fadd(sum01[0], acc_regs[2][0], dtype),
                    fadd(sum01[1], acc_regs[2][1], dtype),
                ],
                dtype=np.float64,
            )
            return total, {"sum01": sum01, "total": total}

        if len(acc_regs) == 2:
            total = np.asarray(
                [
                    fadd(acc_regs[0][0], acc_regs[1][0], dtype),
                    fadd(acc_regs[0][1], acc_regs[1][1], dtype),
                ],
                dtype=np.float64,
            )
            return total, {"total": total}

        if len(acc_regs) == 1:
            return acc_regs[0], {"total": acc_regs[0]}

        total = acc_regs[0]
        for idx in range(1, len(acc_regs)):
            total = np.asarray(
                [
                    fadd(total[0], acc_regs[idx][0], dtype),
                    fadd(total[1], acc_regs[idx][1], dtype),
                ],
                dtype=np.float64,
            )
        return total, {"total": total}


class PaceSoftmaxDenominatorStage:
    @staticmethod
    def compute(attn_exp, dtype, softmax_unroll=8):
        Q, K = attn_exp.shape
        attn = np.asarray(attn_exp, dtype=np.float64)
        out = np.zeros(Q, dtype=dtype)

        fs8 = np.zeros((Q, 2), dtype=np.float64)
        fs9 = np.zeros((Q, 2), dtype=np.float64)
        fs10 = np.zeros((Q, 2), dtype=np.float64)
        fs11 = np.zeros((Q, 2), dtype=np.float64)

        trace = []
        independent_accum = (softmax_unroll in (3, 4))
        chunk_size = 2 * softmax_unroll
        if K % chunk_size != 0:
            raise ValueError(f"K={K} must be divisible by chunk_size={chunk_size}")

        fadd = PaceSoftmaxArithmetic.fadd
        log_reg2 = PaceSoftmaxArithmetic.log_reg2
        for q in range(Q):
            trace.append(f"\n=== q = {q} ===\n")
            trace.append(
                f"Two-lane denominator accumulation with unroll={softmax_unroll}\n"
            )

            for blk in range(K // chunk_size):
                ki = blk * chunk_size
                trace.append(f"-- blk {blk} (k={ki}..{ki + chunk_size - 1})\n")

                if softmax_unroll == 8:
                    fs4_0 = fadd(attn[q, ki + 0], attn[q, ki + 2], dtype)
                    fs4_1 = fadd(attn[q, ki + 1], attn[q, ki + 3], dtype)
                    log_reg2(trace, "fs4", [fs4_0, fs4_1], dtype)

                    fs5_0 = fadd(attn[q, ki + 4], attn[q, ki + 6], dtype)
                    fs5_1 = fadd(attn[q, ki + 5], attn[q, ki + 7], dtype)
                    log_reg2(trace, "fs5", [fs5_0, fs5_1], dtype)

                    fs6_0 = fadd(attn[q, ki + 8], attn[q, ki + 10], dtype)
                    fs6_1 = fadd(attn[q, ki + 9], attn[q, ki + 11], dtype)
                    log_reg2(trace, "fs6", [fs6_0, fs6_1], dtype)

                    fs7_0 = fadd(attn[q, ki + 12], attn[q, ki + 14], dtype)
                    fs7_1 = fadd(attn[q, ki + 13], attn[q, ki + 15], dtype)
                    log_reg2(trace, "fs7", [fs7_0, fs7_1], dtype)

                    fs8[q, 0] = fadd(fs8[q, 0], fs4_0, dtype)
                    fs8[q, 1] = fadd(fs8[q, 1], fs4_1, dtype)
                    log_reg2(trace, "fs8_acc_lanes", fs8[q], dtype)

                    fs9[q, 0] = fadd(fs9[q, 0], fs5_0, dtype)
                    fs9[q, 1] = fadd(fs9[q, 1], fs5_1, dtype)
                    log_reg2(trace, "fs9_acc_lanes", fs9[q], dtype)

                    fs10[q, 0] = fadd(fs10[q, 0], fs6_0, dtype)
                    fs10[q, 1] = fadd(fs10[q, 1], fs6_1, dtype)
                    log_reg2(trace, "fs10_acc_lanes", fs10[q], dtype)

                    fs11[q, 0] = fadd(fs11[q, 0], fs7_0, dtype)
                    fs11[q, 1] = fadd(fs11[q, 1], fs7_1, dtype)
                    log_reg2(trace, "fs11_acc_lanes", fs11[q], dtype)
                elif independent_accum:
                    fs8[q, 0] = fadd(fs8[q, 0], attn[q, ki + 0], dtype)
                    fs8[q, 1] = fadd(fs8[q, 1], attn[q, ki + 1], dtype)
                    log_reg2(trace, "fs8_acc_lanes", fs8[q], dtype)

                    fs9[q, 0] = fadd(fs9[q, 0], attn[q, ki + 2], dtype)
                    fs9[q, 1] = fadd(fs9[q, 1], attn[q, ki + 3], dtype)
                    log_reg2(trace, "fs9_acc_lanes", fs9[q], dtype)

                    fs10[q, 0] = fadd(fs10[q, 0], attn[q, ki + 4], dtype)
                    fs10[q, 1] = fadd(fs10[q, 1], attn[q, ki + 5], dtype)
                    log_reg2(trace, "fs10_acc_lanes", fs10[q], dtype)

                    if softmax_unroll == 4:
                        fs11[q, 0] = fadd(fs11[q, 0], attn[q, ki + 6], dtype)
                        fs11[q, 1] = fadd(fs11[q, 1], attn[q, ki + 7], dtype)
                        log_reg2(trace, "fs11_acc_lanes", fs11[q], dtype)
                else:
                    raise ValueError(f"Unsupported softmax_unroll={softmax_unroll}")

            trace.append("-- register reduction across the unrolled accumulators\n")
            regs = (
                [fs8[q], fs9[q], fs10[q]]
                if softmax_unroll == 3
                else [fs8[q], fs9[q], fs10[q], fs11[q]]
            )
            reduced, reduction = PaceSoftmaxArithmetic.reduce_accumulators_exact(
                regs, dtype
            )
            if "sum01" in reduction:
                log_reg2(trace, "reg01_lanes", reduction["sum01"], dtype)
            if "sum23" in reduction:
                log_reg2(trace, "reg23_lanes", reduction["sum23"], dtype)
            log_reg2(trace, "regf_lanes", reduction["total"], dtype)

            trace.append("-- final lane reduction\n")
            out[q] = fadd(reduced[0], reduced[1], dtype)
            trace.append(
                f"lane0={PaceDebugFormatter.float_to_hex(reduced[0], dtype)} "
                f"lane1={PaceDebugFormatter.float_to_hex(reduced[1], dtype)}\n"
            )
            trace.append(
                f"out[{q}] = {PaceDebugFormatter.float_to_hex(out[q], dtype)}\n"
            )

        return out, trace


class PaceSoftmaxFractionStage:
    @staticmethod
    def golden_divide(attn_exp, sum_deno, dtype, **_):
        Q, K = attn_exp.shape
        attn_exp = np.asarray(attn_exp, dtype=dtype)
        attn_exp = np.asarray(attn_exp, dtype=np.float64)
        attn_oup = np.asarray(attn_exp, dtype=np.float64)
        sum_deno = np.asarray(sum_deno, dtype=np.float64)
        for q in range(Q):
            for k in range(K):
                attn_oup[q, k] = attn_exp[q, k] / sum_deno[q]
        return attn_oup.astype(dtype)

    @staticmethod
    def inverse_multiply(attn_exp, sum_deno, dtype):
        Q, K = attn_exp.shape
        attn_exp = np.asarray(attn_exp, dtype=np.float64)
        attn_oup = np.asarray(attn_exp, dtype=np.float64)
        sum_deno = np.asarray(sum_deno, dtype=np.float64)
        for q in range(Q):
            inv_val = 1 / sum_deno[q]
            for k in range(K):
                attn_oup[q, k] = attn_exp[q, k] * inv_val
        return attn_oup.astype(dtype)

    @staticmethod
    def multiply(attn_exp, inv_deno, dtype):
        Q, K = attn_exp.shape
        attn_exp = np.asarray(attn_exp, dtype=np.float64)
        attn_oup = np.asarray(attn_exp, dtype=np.float64)
        inv_deno = inv_deno.astype(np.float64)
        for q in range(Q):
            for k in range(K):
                attn_oup[q, k] = attn_exp[q, k] * inv_deno[q]
        return attn_oup.astype(dtype)

    @staticmethod
    def pwpa_multiply(
        attn_exp, sum_deno, dtype, degree, parts, eps, prec="FP32",
        bp_mode="nonuniform"
    ):
        Q, K = attn_exp.shape
        attn_exp = np.asarray(attn_exp, dtype=np.float64)
        attn_oup = np.asarray(attn_exp, dtype=np.float64)
        sum_deno = np.asarray(sum_deno, dtype=np.float64)
        inv_deno, _, _ = PaceSoftmaxPWPAApproximation.compute_inverse(
            sum_deno, degree, parts, eps, dtype=dtype, prec=prec, bp_mode=bp_mode
        )
        inv_deno = inv_deno.astype(dtype)
        inv_deno = inv_deno.astype(np.float64)
        for q in range(Q):
            for k in range(K):
                attn_oup[q, k] = attn_exp[q, k] * inv_deno[q]
        return attn_oup.astype(dtype)


class PaceSoftmaxPipeline:
    FRAC_FUNC = {
        "golden": PaceSoftmaxFractionStage.golden_divide,
        "inv": PaceSoftmaxFractionStage.inverse_multiply,
        "pwpa": PaceSoftmaxFractionStage.pwpa_multiply,
    }

    EXP_FUNC = {
        "golden": PaceSoftmaxGoldenReference.compute_exp,
        "pwpa": PaceSoftmaxPWPAApproximation.compute_exp,
    }

    @staticmethod
    def compute_custom(
        attn, exp_func, frac_func, dtype, exp_kwargs=None, inv_kwargs=None
    ):
        exp_kwargs = {} if exp_kwargs is None else dict(exp_kwargs)
        inv_kwargs = {} if inv_kwargs is None else dict(inv_kwargs)
        softmax_unroll = int(
            exp_kwargs.pop("softmax_unroll", inv_kwargs.pop("softmax_unroll", 8))
        )
        xmax = PaceSoftmaxOffsetStage.find_xmax(attn, dtype)
        attn_offs = PaceSoftmaxOffsetStage.offset_xmax(attn, xmax, dtype)
        attn_exp = exp_func(attn_offs=attn_offs, dtype=dtype, **exp_kwargs)
        sum_deno = PaceSoftmaxDenominatorStage.compute(
            attn_exp, dtype, softmax_unroll=softmax_unroll
        )
        return frac_func(
            attn_exp=attn_exp, sum_deno=sum_deno, dtype=dtype, **inv_kwargs
        )


if __name__ == "__main__":
    attn = np.random.uniform(-5.0, 0.0, size=(4, 8))
    exp_func = PaceSoftmaxPipeline.EXP_FUNC["pwpa"]
    frac_func = PaceSoftmaxPipeline.FRAC_FUNC["pwpa"]
    exp_kwargs = {}
    inv_kwargs = {}
    softmax_actual = PaceSoftmaxPipeline.compute_custom(
        attn, exp_func, frac_func, np.float32, **exp_kwargs, **inv_kwargs
    )
    softmax_golden = PaceSoftmaxGoldenReference.compute_softmax(attn, np.float32)
    print(softmax_actual)
    print(softmax_golden)
