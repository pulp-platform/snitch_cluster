#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE instruction encoding and C macro generation."""


class PaceInstructionSet:
    """PACE instruction encoding and C macro generation."""

    MODE_CODES = {
        "pwpa": 0b000,
        "inv": 0b001,
        "sqrt": 0b010,
        "rsqrt": 0b011,
    }
    SCALAR_FUNCT7 = {
        "FP32": 0x30,
        "FP16": 0x31,
        "AH": 0x31,
    }
    VECTOR_FUNCT3 = {
        "FP32": 0,
        "FP16": 1,
        "AH": 1,
    }
    ASM_SUFFIX = {
        "FP32": "s",
        "FP16": "h",
        "AH": "h",
    }
    FMODE = {
        "FP32": 0,
        "FP16": 0,
        "AH": 3,
    }
    DTYPE_MACRO = {
        "FP32": "FP32",
        "FP16": "FP16",
        "AH": "BFP16",
    }

    def __init__(self, mode_name, codec, extend=False):
        if mode_name not in self.MODE_CODES:
            raise ValueError(f"Unsupported PACE mode: {mode_name}")
        self.mode_name = mode_name
        self.codec = codec
        self.extend = bool(extend)

    @classmethod
    def mode_for_function(cls, fn_name, inverse_functions=("inv", "sqrt", "rsqrt")):
        return fn_name if fn_name in inverse_functions else "pwpa"

    @property
    def dtype_key(self):
        return self.codec.dtype_key()

    @property
    def mode_bits(self):
        return self.MODE_CODES[self.mode_name] | (int(self.extend) << 2)

    def scalar_word(self):
        return (
            (self.SCALAR_FUNCT7[self.dtype_key] << 25)
            | (0 << 20)
            | (0 << 15)
            | (self.mode_bits << 12)
            | (1 << 7)
            | 0x53
        )

    def vector_word(self):
        return (
            (0xE << 28)
            | (self.mode_bits << 25)
            | (0 << 20)
            | (0 << 15)
            | (self.VECTOR_FUNCT3[self.dtype_key] << 12)
            | (1 << 7)
            | 0x33
        )

    def elementwise_defines(self):
        dtype_macro = self.DTYPE_MACRO[self.dtype_key]
        defines = [
            f"#define PACE_MODE_BITS {self.mode_bits}",
            f"#define PACE_SCALAR_FUNCT7 0x{self.SCALAR_FUNCT7[self.dtype_key]:02x}",
            f"#define PACE_VECTOR_FUNCT3 {self.VECTOR_FUNCT3[self.dtype_key]}",
            f"#define PACE_SCALAR_WORD 0x{self.scalar_word():08x}",
            f"#define PACE_VECTOR_WORD 0x{self.vector_word():08x}",
            (
                f"#define PACE_SCALAR_ASM "
                f"\"pace.{self.mode_name}.{self.ASM_SUFFIX[self.dtype_key]} ft1, ft0\""
            ),
            (
                f"#define PACE_VECTOR_SSR_ASM "
                f"\"vpace.{self.mode_name}.{self.ASM_SUFFIX[self.dtype_key]} ft1, ft0, ft0\""
            ),
            f"#define PACE_FMODE {self.FMODE[self.dtype_key]}",
        ]
        for mode in self.MODE_CODES:
            defines.append(f"#define PACE_MODE_{mode.upper()} {int(mode == self.mode_name)}")
        for dtype in ("FP32", "FP16", "BFP16"):
            defines.append(f"#define PACE_DTYPE_{dtype} {int(dtype == dtype_macro)}")
        defines.append("#define PACE_DTYPE_BF16 PACE_DTYPE_BFP16")
        defines.append("#define PACE_DTYPE_FP16ALT PACE_DTYPE_BFP16")
        return defines

    def prefixed_mode_defines(self, prefix):
        return [f"#define {prefix}_PACE_MODE_BITS {self.mode_bits}"]

    def prefixed_scalar_defines(self, prefix):
        return [
            f"#define {prefix}_PACE_SCALAR_FUNCT7 0x{self.SCALAR_FUNCT7[self.dtype_key]:02x}",
            f"#define {prefix}_PACE_SCALAR_WORD 0x{self.scalar_word():08x}",
            (
                f"#define {prefix}_PACE_SCALAR_ASM "
                f"\"pace.{self.mode_name}.{self.ASM_SUFFIX[self.dtype_key]} ft1, ft0\""
            ),
            f"#define {prefix}_PACE_FMODE {self.FMODE[self.dtype_key]}",
        ]
