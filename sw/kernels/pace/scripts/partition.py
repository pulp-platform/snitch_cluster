#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE partition, breakpoint generation, and partition search objects."""

import numpy as np

try:
    from snitch.pace.scripts.datatype import PaceDataTypeHelper
except ModuleNotFoundError:
    from datatype import PaceDataTypeHelper


class PaceBreakpointSet:
    """Ordered raw breakpoints and simple interval accessors."""

    def __init__(self, breakpoints):
        self.breakpoints = breakpoints

    @property
    def part_count(self):
        return len(self.breakpoints) - 1

    def bounds(self, part_id):
        part_id = int(part_id)
        return self.breakpoints[part_id], self.breakpoints[part_id + 1]

    def lower_bound(self, part_id):
        return self.bounds(part_id)[0]

    def upper_bound(self, part_id):
        return self.bounds(part_id)[1]

    def as_float64(self):
        return np.asarray(self.breakpoints, dtype=np.float64)


class PaceBSTBreakpointLayout:
    """Hardware BST breakpoint ordering for a breakpoint set."""

    def __init__(self, breakpoints):
        self.breakpoints = breakpoints
        self.layout = self.build()

    @property
    def part_count(self):
        return len(self.breakpoints) - 1

    @property
    def search_breakpoints(self):
        return self.layout[2:]

    def build(self):
        bps = self.breakpoints
        parts = self.part_count
        if parts == 1:
            return [0, 1]

        indices = list(range(1, parts + 2))
        max_stage = int(np.log2(parts))
        layout = [indices[0] - 1, indices[-1] - 1]

        for stage in range(max_stage + 1):
            layout.extend(self.stage_indices(indices, max_stage, stage))
        return [bps[idx] for idx in layout]

    def stage_indices(self, indices, max_stage, stage):
        segment_size = 1 << (max_stage - stage + 1)
        half = segment_size // 2
        stage_indices = []
        start = 0
        while start + segment_size <= len(indices):
            segment = indices[start:start + segment_size]
            stage_indices.append(segment[half] - 1)
            start += segment_size
        return stage_indices


class PaceLinearPartitionSearch:
    """Reference linear partition search."""

    def __init__(self, breakpoints):
        self.breakpoints = PaceBreakpointSet(breakpoints)

    def part_id(self, ifmap):
        ifmap_fp64 = np.asarray(ifmap, dtype=np.float64)
        bps_fp64 = self.breakpoints.as_float64()
        search_idx = np.searchsorted(bps_fp64, ifmap_fp64, side="right")
        part_id = search_idx - 1
        part_id = self.tie_break_left(ifmap_fp64, bps_fp64, part_id)
        return np.clip(part_id, 0, len(bps_fp64) - 2)

    def tie_break_left(self, ifmap_fp64, bps_fp64, part_id):
        interior_matches = np.isin(ifmap_fp64, bps_fp64[1:-1])
        return np.where(interior_matches, part_id - 1, part_id)


class PaceBSTSearchStep:
    """One comparison in the hardware BST search path."""

    def __init__(self, stage, bp_index, x, bp, comparison, bit):
        self.stage = stage
        self.bp_index = bp_index
        self.x = x
        self.bp = bp
        self.comparison = comparison
        self.bit = bit

    def as_dict(self):
        return {
            "stage": self.stage,
            "bp_index": self.bp_index,
            "x": self.x,
            "bp": self.bp,
            "comparison": self.comparison,
            "bit": self.bit,
        }

    def debug_line(self):
        return (
            "stage={stage} bp_index={bp_index} x={x} bp={bp} "
            "comparison={comparison} bit={bit}"
        ).format(**self.as_dict())


class PaceBSTSearchTrace:
    """Search result plus the comparison trace used for debug output."""

    def __init__(self, part_id, steps):
        self.part_id = part_id
        self.steps = steps

    def details(self):
        details = [step.as_dict() for step in self.steps]
        details.append({"part_id": self.part_id})
        return details

    def debug_string(self):
        lines = [step.debug_line() for step in self.steps]
        lines.append(f"part_id={self.part_id}")
        return "\n".join(lines)


class PaceBSTPartitionSearch:
    """Hardware-style BST partition search."""

    def __init__(self, bst_breakpoints, precision=np.float64):
        self.bst_breakpoints = bst_breakpoints
        self.precision = precision

    @property
    def part_count(self):
        return len(self.bst_breakpoints) - 1

    @property
    def stage_count(self):
        return int(np.log2(self.part_count))

    def part_id(self, ifmap):
        ifmap_prec = PaceDataTypeHelper.quantize_values(ifmap, self.precision)
        flat_ifmap = ifmap_prec.reshape(-1)
        flat_part_ids = np.zeros(flat_ifmap.shape[0], dtype=np.int64)
        for idx, feat in enumerate(flat_ifmap):
            flat_part_ids[idx] = self.trace(feat).part_id
        return flat_part_ids.reshape(ifmap_prec.shape)

    def trace(self, ifmap):
        feat_prec = PaceDataTypeHelper.quantize_values(ifmap, self.precision)
        feat = self.scalar_value(feat_prec)
        search_bps = PaceDataTypeHelper.quantize_values(
            self.bst_breakpoints[2:], self.precision
        )

        steps = []
        node_idx = 0
        path_bits = []
        for stage in range(self.stage_count):
            bp_value = self.scalar_value(search_bps[node_idx])
            comparison, bit = self.compare(feat, bp_value)
            steps.append(
                PaceBSTSearchStep(
                    stage=stage,
                    bp_index=node_idx,
                    x=self.detail_value(feat_prec),
                    bp=self.detail_value(
                        PaceDataTypeHelper.quantize_values(
                            search_bps[node_idx], self.precision
                        )
                    ),
                    comparison=comparison,
                    bit=bit,
                )
            )
            path_bits.append(bit)
            node_idx = 2 * node_idx + 1 + bit

        return PaceBSTSearchTrace(self.path_to_part_id(path_bits), steps)

    def compare(self, value, breakpoint):
        if value > breakpoint:
            return "gt", 1
        if value < breakpoint:
            return "lt", 0
        return "eq", 0

    def path_to_part_id(self, path_bits):
        return int("".join(str(bit) for bit in path_bits), 2)

    def scalar_value(self, value):
        return np.asarray(value, dtype=np.float64).item()

    def detail_value(self, value):
        value_arr = np.asarray(value)
        if value_arr.shape == ():
            return value_arr.item()
        return value


class PacePartition:
    """Breakpoints, BST layout, and partition lookup for a PWPA model."""

    def __init__(self, breakpoints, bst_breakpoints=None, precision=np.float64):
        self.breakpoint_set = PaceBreakpointSet(breakpoints)
        self.breakpoints = self.breakpoint_set.breakpoints
        self.precision = precision
        self.bst_breakpoints = (
            PaceBSTBreakpointLayout(breakpoints).layout
            if bst_breakpoints is None
            else bst_breakpoints
        )
        self.linear_search = PaceLinearPartitionSearch(self.breakpoints)
        self.bst_search = PaceBSTPartitionSearch(self.bst_breakpoints, precision)

    @classmethod
    def build_bst_breakpoints(cls, breakpoints):
        return PaceBSTBreakpointLayout(breakpoints).layout

    @property
    def part_count(self):
        return self.breakpoint_set.part_count

    def bounds(self, part_id):
        return self.breakpoint_set.bounds(part_id)

    def lower_bound(self, part_id):
        return self.breakpoint_set.lower_bound(part_id)

    def upper_bound(self, part_id):
        return self.breakpoint_set.upper_bound(part_id)

    def linear_part_id(self, ifmap):
        return self.linear_search.part_id(ifmap)

    def bst_part_id_with_details(self, ifmap):
        trace = self.bst_search.trace(ifmap)
        return trace.part_id, trace.details()

    def bst_part_id(self, ifmap):
        return self.bst_search.part_id(ifmap)

    def bst_debug_string(self, ifmap):
        return self.bst_search.trace(ifmap).debug_string()

    def __str__(self):
        return (
            f"partition(parts={self.part_count}, "
            f"precision={self.precision}, bst={len(self.bst_breakpoints)})"
        )


class PaceUniformBreakpointStrategy:
    """Uniform breakpoint placement."""

    MODES = {"linear", "uniform"}

    @classmethod
    def supports(cls, mode):
        return mode in cls.MODES

    def generate(self, xmin, xmax, parts):
        return np.linspace(xmin, xmax, parts + 1, dtype=np.float64)


class PaceChebyshevBreakpointStrategy:
    """Chebyshev-like nonuniform breakpoint placement."""

    MODES = {"nonuniform", "chebyshev"}

    @classmethod
    def supports(cls, mode):
        return mode in cls.MODES

    def generate(self, xmin, xmax, parts):
        idx = np.arange(parts + 1, dtype=np.float64)
        midpoint = (xmin + xmax) / 2
        half_range = (xmax - xmin) / 2
        return midpoint - half_range * np.cos(np.pi * idx / parts)


class PaceBreakpointStrategyRegistry:
    """Lookup for breakpoint generation strategies."""

    STRATEGIES = (
        PaceUniformBreakpointStrategy,
        PaceChebyshevBreakpointStrategy,
    )

    @classmethod
    def create(cls, mode):
        normalized = str(mode).lower()
        for strategy_cls in cls.STRATEGIES:
            if strategy_cls.supports(normalized):
                return strategy_cls()
        raise ValueError(f"Unsupported breakpoint generation mode: {mode}")


class PacePartitionGenerator:
    """Generate raw breakpoints and their BST partition layout."""

    def __init__(self, parts, mode="nonuniform", precision=np.float64, codec=None):
        self.parts = parts
        self.mode = str(mode).lower()
        self.precision = precision
        self.codec = codec
        self.strategy = PaceBreakpointStrategyRegistry.create(self.mode)

    @classmethod
    def from_config(cls, config):
        return cls(
            parts=config.n_part,
            mode=config.bp_mode,
            precision=config.model_precision,
            codec=config.codec,
        )

    def raw_breakpoints(self, xmin, xmax):
        if self.parts < 1:
            raise ValueError("parts must be at least 1")
        return self.strategy.generate(xmin, xmax, self.parts)

    def generate(self, xmin, xmax, quantize=False):
        breakpoints = self.raw_breakpoints(xmin, xmax)
        if quantize and self.codec is not None:
            breakpoints = self.codec.quantize_model_values(breakpoints)
        return PacePartition(breakpoints, precision=self.precision)

    def __str__(self):
        return f"partition_generator(parts={self.parts}, mode={self.mode})"
