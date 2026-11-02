#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

import numpy as np

try:
    import torch
except ModuleNotFoundError:
    torch = None

def silu(x):
    x_np = np.asarray(x)
    if torch is None:
        return x_np / (1.0 + np.exp(-x_np))
    x_t = torch.from_numpy(x_np)
    y_t = torch.nn.functional.silu(x_t)
    return y_t.numpy()

def exp(x):
    x_np = np.asarray(x)
    if torch is None:
        return np.exp(x_np)
    x_t = torch.from_numpy(x_np)
    y_t = torch.exp(x_t)
    return y_t.numpy()

def inv(x):
    x_np = np.asarray(x)
    if torch is None:
        return 1.0 / x_np
    x_t = torch.from_numpy(x_np)
    y_t = 1 / x_t
    return y_t.numpy()

def sqrt(x):
    x_np = np.asarray(x)
    if torch is None:
        return np.sqrt(x_np)
    x_t = torch.from_numpy(x_np)
    y_t = torch.sqrt(x_t)
    return y_t.numpy()

def rsqrt(x):
    x_np = np.asarray(x)
    if torch is None:
        return 1.0 / np.sqrt(x_np)
    x_t = torch.from_numpy(x_np)
    y_t = torch.rsqrt(x_t)
    return y_t.numpy()

def gelu(x):
    x_np = np.asarray(x)
    if torch is None:
        return 0.5 * x_np * (1.0 + np.tanh(np.sqrt(2.0 / np.pi) * (x_np + 0.044715 * np.power(x_np, 3))))
    x_t = torch.from_numpy(x_np)
    y_t = torch.nn.functional.gelu(x_t)
    return y_t.numpy()    # back to numpy

ACTIVATIONS = {
    "silu": silu,
    "exp": exp,
    "inv": inv,
    "sqrt": sqrt,
    "rsqrt": rsqrt,
    "gelu": gelu
}

def golden_model(ifmap, fn_name):
    if fn_name not in ACTIVATIONS:
        raise ValueError(f"Unknown activation '{fn_name}'. "
                         f"Available: {list(ACTIVATIONS.keys())}")

    fn = ACTIVATIONS[fn_name]
    return fn(ifmap)
