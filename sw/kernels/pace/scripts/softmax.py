#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>
import sys
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parents[4]
_PACE_SCRIPTS_DIR = Path(__file__).resolve().parent
for _path in (str(_REPO_ROOT), str(_PACE_SCRIPTS_DIR)):
    if _path not in sys.path:
        sys.path.insert(0, _path)

try:
    from snitch.pace.scripts.golden import *
    from snitch.pace.scripts.debug import *
    from snitch.pace.scripts.pwpa import *
    from snitch.pace.scripts.invert import *
except ModuleNotFoundError:
    from golden import *
    from debug import *
    from pwpa import *
    from invert import *

import copy

if "torch" in globals() and torch is not None:
    torch.manual_seed(42)
np.random.seed(42)

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

def offset_xmax(attn, xmax, dtype=np.float64):
    Q, K = attn.shape
    attn = np.asarray(attn, dtype=dtype)
    attn = np.asarray(attn, dtype=np.float64)
    attn = np.asarray(attn, dtype=dtype)
    xmax = np.asarray(xmax, dtype=np.float64)
    attn_oup = np.asarray(attn, dtype=np.float64)
    for q in range(Q):
        for k in range(K):
            attn_oup[q,k] = attn[q,k] - xmax[q]
    return attn_oup.astype(dtype)



def compute_exp_pwpa(attn_offs, dtype=np.float32, degree=None, parts=None, bp_mode="nonuniform"):
    xmin, xmax = -11, 0
    raw_bps  = generate_bps(xmin, xmax, parts, mode=bp_mode)
    bst_bps  = build_bst_bps(raw_bps)
    coeffs   = fit_pwpa(raw_bps, degree=degree, func=ACTIVATIONS["exp"])
    part_id  = compute_part_id_bst(attn_offs, bst_bps, dtype)
    attn_exp = copy.deepcopy(attn_offs)
    Q, _ = attn_offs.shape
    for q in range(Q):
        attn_exp[q] = evaluate_pwpa(attn_offs[q], coeffs, part_id=part_id[q], degree=degree, np_prec=dtype)
    return attn_exp, raw_bps, coeffs

def compute_exp_golden(attn_offs, dtype):
    Q, _ = attn_offs.shape
    attn_exp = np.asarray(attn_offs, dtype=dtype)
    for q in range(Q):
        attn_exp[q] = exp(attn_offs[q])
    return attn_exp.astype(dtype)


def fadd(a, b, dtype):
    a64 = np.asarray(a, dtype=np.float64)
    b64 = np.asarray(b, dtype=np.float64)
    s64 = a64 + b64                    # high-precision add
    sdt = np.asarray(s64, dtype=dtype)  # hardware rounding
    return sdt

def log_reg2(trace, name, v, dtype):
    trace.append(
        f"{name}: [{float_to_hex(v[0], dtype)}, {float_to_hex(v[1], dtype)}]\n"
    )

def reduce_accumulators_exact(acc_regs, dtype):
    acc_regs = [np.asarray(reg, dtype=np.float64).copy() for reg in acc_regs]
    if len(acc_regs) == 4:
        sum01 = np.asarray(
            [fadd(acc_regs[1][0], acc_regs[0][0], dtype), fadd(acc_regs[1][1], acc_regs[0][1], dtype)],
            dtype=np.float64,
        )
        sum23 = np.asarray(
            [fadd(acc_regs[2][0], acc_regs[3][0], dtype), fadd(acc_regs[2][1], acc_regs[3][1], dtype)],
            dtype=np.float64,
        )
        total = np.asarray(
            [fadd(sum23[0], sum01[0], dtype), fadd(sum23[1], sum01[1], dtype)],
            dtype=np.float64,
        )
        return total, {"sum01": sum01, "sum23": sum23, "total": total}

    if len(acc_regs) == 3:
        sum01 = np.asarray(
            [fadd(acc_regs[1][0], acc_regs[0][0], dtype), fadd(acc_regs[1][1], acc_regs[0][1], dtype)],
            dtype=np.float64,
        )
        total = np.asarray(
            [fadd(sum01[0], acc_regs[2][0], dtype), fadd(sum01[1], acc_regs[2][1], dtype)],
            dtype=np.float64,
        )
        return total, {"sum01": sum01, "total": total}

    if len(acc_regs) == 2:
        total = np.asarray(
            [fadd(acc_regs[0][0], acc_regs[1][0], dtype), fadd(acc_regs[0][1], acc_regs[1][1], dtype)],
            dtype=np.float64,
        )
        return total, {"total": total}

    if len(acc_regs) == 1:
        return acc_regs[0], {"total": acc_regs[0]}

    total = acc_regs[0]
    for idx in range(1, len(acc_regs)):
        total = np.asarray(
            [fadd(total[0], acc_regs[idx][0], dtype), fadd(total[1], acc_regs[idx][1], dtype)],
            dtype=np.float64,
        )
    return total, {"total": total}

def compute_exp_deno(attn_exp, dtype, softmax_unroll=8):
    Q, K = attn_exp.shape
    attn = np.asarray(attn_exp, dtype=np.float64)
    out = np.zeros(Q, dtype=dtype)

    fs8  = np.zeros((Q, 2), dtype=np.float64)
    fs9  = np.zeros((Q, 2), dtype=np.float64)
    fs10 = np.zeros((Q, 2), dtype=np.float64)
    fs11 = np.zeros((Q, 2), dtype=np.float64)

    trace = []
    independent_accum = (softmax_unroll in (3, 4))
    chunk_size = 2 * softmax_unroll
    if K % chunk_size != 0:
        raise ValueError(f"K={K} must be divisible by chunk_size={chunk_size}")

    for q in range(Q):
        trace.append(f"\n=== q = {q} ===\n")
        trace.append(f"Two-lane denominator accumulation with unroll={softmax_unroll}\n")

        for blk in range(K // chunk_size):
            ki = blk * chunk_size
            trace.append(f"-- blk {blk} (k={ki}..{ki+chunk_size-1})\n")

            if softmax_unroll == 8:
                fs4_0 = fadd(attn[q, ki+0],  attn[q, ki+2],  dtype)
                fs4_1 = fadd(attn[q, ki+1],  attn[q, ki+3],  dtype)
                log_reg2(trace, "fs4", [fs4_0, fs4_1], dtype)

                fs5_0 = fadd(attn[q, ki+4],  attn[q, ki+6],  dtype)
                fs5_1 = fadd(attn[q, ki+5],  attn[q, ki+7],  dtype)
                log_reg2(trace, "fs5", [fs5_0, fs5_1], dtype)

                fs6_0 = fadd(attn[q, ki+8],  attn[q, ki+10], dtype)
                fs6_1 = fadd(attn[q, ki+9],  attn[q, ki+11], dtype)
                log_reg2(trace, "fs6", [fs6_0, fs6_1], dtype)

                fs7_0 = fadd(attn[q, ki+12], attn[q, ki+14], dtype)
                fs7_1 = fadd(attn[q, ki+13], attn[q, ki+15], dtype)
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
        regs = [fs8[q], fs9[q], fs10[q]] if softmax_unroll == 3 else [fs8[q], fs9[q], fs10[q], fs11[q]]
        reduced, reduction = reduce_accumulators_exact(regs, dtype)
        if "sum01" in reduction:
            log_reg2(trace, "reg01_lanes", reduction["sum01"], dtype)
        if "sum23" in reduction:
            log_reg2(trace, "reg23_lanes", reduction["sum23"], dtype)
        log_reg2(trace, "regf_lanes", reduction["total"], dtype)

        trace.append("-- final lane reduction\n")
        out[q] = fadd(reduced[0], reduced[1], dtype)
        trace.append(
            f"lane0={float_to_hex(reduced[0], dtype)} lane1={float_to_hex(reduced[1], dtype)}\n"
        )
        trace.append(f"out[{q}] = {float_to_hex(out[q], dtype)}\n")

    return out, trace

def compute_exp_fraction(attn_exp, sum_deno, dtype, **_):
    Q, K = attn_exp.shape
    attn_exp = np.asarray(attn_exp, dtype=dtype)
    attn_exp = np.asarray(attn_exp, dtype=np.float64)
    attn_oup = np.asarray(attn_exp, dtype=np.float64)
    sum_deno = np.asarray(sum_deno, dtype=np.float64)
    for q in range(Q):
        for k in range(K):
            attn_oup[q,k] = attn_exp[q,k] / sum_deno[q]
    return attn_oup.astype(dtype)

def compute_exp_fraction_inverse(attn_exp, sum_deno, dtype):
    Q, K = attn_exp.shape
    attn_exp = np.asarray(attn_exp, dtype=np.float64)
    attn_oup = np.asarray(attn_exp, dtype=np.float64)
    sum_deno = np.asarray(sum_deno, dtype=np.float64)
    for q in range(Q):
        inv = 1 / sum_deno[q]
        for k in range(K):
            attn_oup[q,k] = attn_exp[q,k] * inv
    return attn_oup.astype(dtype)

def compute_inv_pwpa(sum_deno, degree=2, parts=16, eps=1e-6, dtype=np.float32, prec="FP32", bp_mode="nonuniform"):
    xmin, xmax = 1, 2
    raw_bps  = generate_bps(xmin, xmax, parts, mode=bp_mode)
    coeffs   = fit_pwpa(raw_bps, degree=degree, func=ACTIVATIONS["inv"])
    inv_sum_deno = np.asarray(sum_deno, dtype=dtype)
    eps_const = inv(eps)
    eps_const = eps_const.astype(dtype)
    inv_sum_deno = invert_sqrt(sum_deno, coeffs, raw_bps, degree, eps=eps, eps_const=eps_const, fn_name="inv", prec=prec)
    return inv_sum_deno.astype(dtype), raw_bps, coeffs

def compute_softmax_mul(attn_exp, inv_deno, dtype):
    Q, K = attn_exp.shape
    attn_exp = np.asarray(attn_exp, dtype=np.float64)
    attn_oup = np.asarray(attn_exp, dtype=np.float64)
    inv_deno = inv_deno.astype(np.float64)
    for q in range(Q):
        for k in range(K):
            attn_oup[q,k] = attn_exp[q,k] * inv_deno[q]
    return attn_oup.astype(dtype)

def compute_exp_fraction_pwpa(attn_exp, sum_deno, dtype, degree, parts, eps, prec="FP32", bp_mode="nonuniform"):
    Q, K = attn_exp.shape
    attn_exp = np.asarray(attn_exp, dtype=np.float64)
    attn_oup = np.asarray(attn_exp, dtype=np.float64)
    sum_deno = np.asarray(sum_deno, dtype=np.float64)
    inv, _, _ = compute_inv_pwpa(sum_deno, degree, parts, eps, dtype=dtype, prec=prec, bp_mode=bp_mode)
    inv = inv.astype(dtype)
    inv = inv.astype(np.float64)
    for q in range(Q):
        for k in range(K):
            attn_oup[q,k] = attn_exp[q,k] * inv[q]
    return attn_oup.astype(dtype)

def compute_softmax_custom(attn, exp_func, frac_func, dtype, exp_kwargs=None, inv_kwargs=None):
    exp_kwargs = {} if exp_kwargs is None else dict(exp_kwargs)
    inv_kwargs = {} if inv_kwargs is None else dict(inv_kwargs)
    softmax_unroll = int(exp_kwargs.pop("softmax_unroll", inv_kwargs.pop("softmax_unroll", 8)))
    xmax = find_xmax(attn, dtype)
    attn_offs = offset_xmax(attn, xmax, dtype)
    attn_exp = exp_func(attn_offs=attn_offs, dtype=dtype, **exp_kwargs)
    sum_deno = compute_exp_deno(attn_exp, dtype, softmax_unroll=softmax_unroll)
    softmax_oup = frac_func(attn_exp=attn_exp, sum_deno=sum_deno, dtype=dtype, **inv_kwargs)
    return softmax_oup

def compute_softmax_golden(attn, out_dtype=np.float32):
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

FRAC_FUNC = {
    "golden": compute_exp_fraction,
    "inv": compute_exp_fraction_inverse,
    "pwpa": compute_exp_fraction_pwpa
}

EXP_FUNC = {
    "golden": compute_exp_golden,
    "pwpa": compute_exp_pwpa
}




if __name__ == '__main__':
    attn = np.random.uniform(-5.0, 0.0, size=(4,8))
    exp_func = EXP_FUNC["pwpa"]
    frac_func = FRAC_FUNC["pwpa"]
    softmax_actual = compute_softmax_custom(attn, exp_func, frac_func, np.float32, **exp_kwargs, **inv_kwargs)
    softmax_golden = compute_softmax_golden(attn, np.float32)
    print(softmax_actual)
    print(softmax_golden)
