#!/usr/bin/env python3
# Copyright 2023 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Arpan Suravi Prasad <prasadar@iis.ee.ethz.ch>

"""Golden activation models for PACE data generation."""

import numpy as np

try:
    import torch
except ModuleNotFoundError:
    torch = None


class PaceActivationFunction:
    """Callable golden activation function."""

    name = None

    def __call__(self, x):
        return self.evaluate(x)

    def evaluate(self, x):
        raise NotImplementedError

    def as_numpy(self, x):
        return np.asarray(x)

    def torch_tensor(self, x):
        if torch is None:
            return None
        return torch.from_numpy(self.as_numpy(x))

    def __str__(self):
        return self.name


class PaceSiluActivation(PaceActivationFunction):
    name = "silu"

    def evaluate(self, x):
        x_np = self.as_numpy(x)
        if torch is None:
            return x_np / (1.0 + np.exp(-x_np))
        return torch.nn.functional.silu(self.torch_tensor(x_np)).numpy()


class PaceExpActivation(PaceActivationFunction):
    name = "exp"

    def evaluate(self, x):
        x_np = self.as_numpy(x)
        if torch is None:
            return np.exp(x_np)
        return torch.exp(self.torch_tensor(x_np)).numpy()


class PaceInvActivation(PaceActivationFunction):
    name = "inv"

    def evaluate(self, x):
        x_np = self.as_numpy(x)
        if torch is None:
            return 1.0 / x_np
        return (1 / self.torch_tensor(x_np)).numpy()


class PaceSqrtActivation(PaceActivationFunction):
    name = "sqrt"

    def evaluate(self, x):
        x_np = self.as_numpy(x)
        if torch is None:
            return np.sqrt(x_np)
        return torch.sqrt(self.torch_tensor(x_np)).numpy()


class PaceRsqrtActivation(PaceActivationFunction):
    name = "rsqrt"

    def evaluate(self, x):
        x_np = self.as_numpy(x)
        if torch is None:
            return 1.0 / np.sqrt(x_np)
        return torch.rsqrt(self.torch_tensor(x_np)).numpy()


class PaceGeluActivation(PaceActivationFunction):
    name = "gelu"

    def evaluate(self, x):
        x_np = self.as_numpy(x)
        if torch is None:
            return 0.5 * x_np * (
                1.0 + np.tanh(
                    np.sqrt(2.0 / np.pi) * (x_np + 0.044715 * np.power(x_np, 3))
                )
            )
        return torch.nn.functional.gelu(self.torch_tensor(x_np)).numpy()


class PaceActivationRegistry:
    """Factory and lookup table for golden activation objects."""

    ACTIVATION_CLASSES = {
        "silu": PaceSiluActivation,
        "exp": PaceExpActivation,
        "inv": PaceInvActivation,
        "sqrt": PaceSqrtActivation,
        "rsqrt": PaceRsqrtActivation,
        "gelu": PaceGeluActivation,
    }

    _instances = {}

    @classmethod
    def names(cls):
        return list(cls.ACTIVATION_CLASSES.keys())

    @classmethod
    def get(cls, name):
        if name not in cls.ACTIVATION_CLASSES:
            raise ValueError(
                f"Unknown activation '{name}'. Available: {cls.names()}"
            )
        if name not in cls._instances:
            cls._instances[name] = cls.ACTIVATION_CLASSES[name]()
        return cls._instances[name]

    @classmethod
    def evaluate(cls, name, x):
        return cls.get(name).evaluate(x)


class PaceGoldenReference:
    """Golden model dispatcher backed by the activation registry."""

    def __init__(self, registry=None):
        self.registry = registry or PaceActivationRegistry

    def evaluate(self, ifmap, fn_name):
        return self.registry.evaluate(fn_name, ifmap)

    def function(self, fn_name):
        return self.registry.get(fn_name)
