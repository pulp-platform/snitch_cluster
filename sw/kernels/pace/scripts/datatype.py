#!/usr/bin/env python3
# Copyright 2026 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

"""PACE datatype and precision conversion helpers."""

from pathlib import Path
import sys

import numpy as np

_REPO_ROOT = Path(__file__).resolve().parents[4]
if str(_REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(_REPO_ROOT))

try:
    from snitch.util.sim import data_utils
    from snitch.util.sim.data_utils import _integer_precision_t
except ModuleNotFoundError:
    from util.sim import data_utils
    from util.sim.data_utils import _integer_precision_t


def _clean_value(value):
    if isinstance(value, (list, tuple)):
        return [_clean_value(v) for v in value]
    if isinstance(value, np.ndarray):
        return value.astype(float).tolist()
    try:
        return float(value)
    except Exception:
        return value


class PacePrecisionFormat:
    """Datatype-specific PACE storage and parameter encoding strategy."""

    BF16_PRECISIONS = {"BF16", "BFP16", "BFLOAT16"}
    ALT_HALF_FORMATS = {"AH", "FP16ALT", "BF16", "BFP16"}

    def __init__(self, prec, super_fmt="FP32"):
        self.prec = prec
        self.super_fmt = super_fmt

    @classmethod
    def is_bf16_precision(cls, prec):
        return isinstance(prec, str) and prec.upper() in cls.BF16_PRECISIONS

    @classmethod
    def is_alt_half_format(cls, fmt):
        return isinstance(fmt, str) and fmt.upper() in cls.ALT_HALF_FORMATS

    @staticmethod
    def dtype_bits(dtype):
        return int(np.dtype(dtype).itemsize * 8)

    @staticmethod
    def bf16_bits(values):
        raw = np.asarray(values, dtype=np.float32).view(np.uint32)
        lsb = (raw >> 16) & 1
        return (((raw + 0x7FFF + lsb) >> 16) & 0xFFFF).astype(np.uint16)

    @classmethod
    def bf16_bits_u32(cls, values):
        return cls.bf16_bits(values).astype(np.uint32)

    @classmethod
    def bf16_values(cls, values):
        raw = cls.bf16_bits_u32(values) << 16
        return raw.view(np.float32)

    @classmethod
    def widen_bf16_for_compare(cls, raw):
        raw = cls.bf16_bits_u32(raw)
        sign = (raw & 0x8000) >> 15
        exponent = (raw & 0x7F80) >> 7
        mantissa = raw & 0x007F
        return ((sign << 31) + (exponent << 23) + mantissa).astype(np.uint32)

    @staticmethod
    def widen_fp_for_compare(raw, fmt):
        raw = np.asarray(raw, dtype=fmt).view(np.uint16).astype(np.uint32)
        sign = (raw & 0x8000) >> 15
        exponent = (raw & 0x7C00) >> 10
        mantissa = raw & 0x03FF
        widened = (sign << 31) + 0x70000000 + (exponent << 23) + mantissa
        return widened.astype(np.uint32)

    @staticmethod
    def widen_fp_for_fma(raw, fmt):
        return np.asarray(raw, dtype=fmt).view(np.uint16).astype(np.uint32)

    def algo_precision(self):
        return self.prec

    def numpy_type(self):
        raise NotImplementedError

    def model_precision(self):
        return self.numpy_type()

    def c_type(self):
        raise NotImplementedError

    def hex_c_type(self):
        raise NotImplementedError

    def storage_bits(self):
        raise NotImplementedError

    def storage_values(self, values, numpy_type=None):
        if numpy_type is None:
            numpy_type = self.numpy_type()
        return np.asarray(values, dtype=numpy_type)

    def quantize_model_values(self, values):
        return values

    def dtype_key(self):
        raise NotImplementedError

    def encode_coeff(self, coeff):
        raise NotImplementedError

    def encode_breakpoint(self, bp):
        raise NotImplementedError

    def encode_eps_values(self, eps, eps_const):
        raise NotImplementedError


class PaceNativePrecisionFormat(PacePrecisionFormat):
    """Common helpers for natively represented floating point formats."""

    def numpy_type(self):
        return data_utils.numpy_type_from_precision_t(self.prec)

    def c_type(self):
        return data_utils.ctype_from_precision_t(self.prec)

    def hex_c_type(self):
        return data_utils.hex_ctype_from_precision_t(_integer_precision_t(self.prec))

    def storage_bits(self):
        return 8 * _integer_precision_t(self.prec)

    def _encode_native32(self, value):
        return _clean_value(np.asarray(value, dtype=self.numpy_type()).view(np.uint32))

    def _encode_native16(self, value):
        return int(_clean_value(np.asarray(value, dtype=self.numpy_type()).view(np.uint16)))


class PaceFP32PrecisionFormat(PaceNativePrecisionFormat):
    def dtype_key(self):
        return "FP32"

    def encode_coeff(self, coeff):
        return self._encode_native32(coeff)

    def encode_breakpoint(self, bp):
        return self._encode_native32(bp)

    def encode_eps_values(self, eps, eps_const):
        numpy_type = self.numpy_type()
        values = []
        if self.super_fmt == "FP32":
            values.append(_clean_value(numpy_type(eps).view(np.uint32)))
            if eps_const is not None:
                eps_const_val = np.asarray(eps_const, dtype=numpy_type).view(np.uint32)
                values.append(_clean_value(eps_const_val))
            return values

        values.append(_clean_value(numpy_type(eps).view(np.uint16)))
        if eps_const is not None:
            values.append(_clean_value(numpy_type(eps_const).view(np.uint16)))
        return values


class PaceFP16PrecisionFormat(PaceNativePrecisionFormat):
    def dtype_key(self):
        if self.is_alt_half_format(self.super_fmt):
            return "AH"
        return "FP16"

    def encode_coeff(self, coeff):
        if self.super_fmt == "FP32":
            return int(_clean_value(self.widen_fp_for_fma(coeff, self.numpy_type())))
        return self._encode_native16(coeff)

    def encode_breakpoint(self, bp):
        if self.super_fmt == "FP32":
            return int(_clean_value(self.widen_fp_for_compare(bp, self.numpy_type())))
        return self._encode_native16(bp)

    def encode_eps_values(self, eps, eps_const):
        numpy_type = self.numpy_type()
        values = []
        if self.super_fmt == "FP32":
            values.append(int(_clean_value(self.widen_fp_for_compare(eps, numpy_type))))
            if eps_const is not None:
                val_eps_const = numpy_type(eps_const).view(np.uint16).astype(np.uint32)
                values.append(int(_clean_value(val_eps_const)))
            return values

        values.append(int(_clean_value(numpy_type(eps).view(np.uint16))))
        if eps_const is not None:
            val_eps_const = numpy_type(eps_const).view(np.uint16).astype(np.uint16)
            values.append(int(_clean_value(val_eps_const)))
        return values


class PaceBF16PrecisionFormat(PacePrecisionFormat):
    """BF16/BFP16 values stored as uint16 and modeled through rounded FP32."""

    def algo_precision(self):
        return "BFP16"

    def numpy_type(self):
        return np.float32

    def model_precision(self):
        return self.algo_precision()

    def c_type(self):
        return "uint16_t"

    def hex_c_type(self):
        return "uint16_t"

    def storage_bits(self):
        return 16

    def storage_values(self, values, numpy_type=None):
        return self.bf16_bits(values)

    def quantize_model_values(self, values):
        return self.bf16_values(values)

    def dtype_key(self):
        return "AH"

    def encode_coeff(self, coeff):
        return int(_clean_value(self.bf16_bits_u32(coeff)))

    def encode_breakpoint(self, bp):
        if self.super_fmt == "FP32":
            return int(_clean_value(self.widen_bf16_for_compare(bp)))
        return int(_clean_value(self.bf16_bits_u32(bp)))

    def encode_eps_values(self, eps, eps_const):
        values = []
        if self.super_fmt == "FP32":
            values.append(int(_clean_value(self.widen_bf16_for_compare(eps))))
        else:
            values.append(int(_clean_value(self.bf16_bits_u32(eps))))
        if eps_const is not None:
            values.append(int(_clean_value(self.bf16_bits_u32(eps_const))))
        return values


class PacePrecisionRegistry:
    """Factory for PACE precision strategies."""

    NATIVE_FORMATS = {
        "FP32": PaceFP32PrecisionFormat,
        "FP16": PaceFP16PrecisionFormat,
    }

    @staticmethod
    def create(prec, super_fmt="FP32"):
        if PacePrecisionFormat.is_bf16_precision(prec):
            return PaceBF16PrecisionFormat(prec, super_fmt)
        key = str(prec).upper()
        if key not in PacePrecisionRegistry.NATIVE_FORMATS:
            raise ValueError(f"Unsupported PACE precision: {prec}")
        return PacePrecisionRegistry.NATIVE_FORMATS[key](prec, super_fmt)


class PacePrecisionCodec:
    """Compatibility facade around datatype-specific precision strategies."""

    BF16_PRECISIONS = PacePrecisionFormat.BF16_PRECISIONS
    ALT_HALF_FORMATS = PacePrecisionFormat.ALT_HALF_FORMATS

    def __init__(self, prec, super_fmt="FP32"):
        self.prec = prec
        self.super_fmt = super_fmt
        self.format = PacePrecisionRegistry.create(prec, super_fmt)

    @classmethod
    def is_bf16_precision(cls, prec):
        return PacePrecisionFormat.is_bf16_precision(prec)

    @classmethod
    def is_alt_half_format(cls, fmt):
        return PacePrecisionFormat.is_alt_half_format(fmt)

    @staticmethod
    def dtype_bits(dtype):
        return PacePrecisionFormat.dtype_bits(dtype)

    @classmethod
    def bf16_bits(cls, values):
        return PacePrecisionFormat.bf16_bits(values)

    @classmethod
    def bf16_bits_u32(cls, values):
        return PacePrecisionFormat.bf16_bits_u32(values)

    @classmethod
    def bf16_values(cls, values):
        return PacePrecisionFormat.bf16_values(values)

    @classmethod
    def widen_bf16_for_compare(cls, raw):
        return PacePrecisionFormat.widen_bf16_for_compare(raw)

    @staticmethod
    def widen_fp_for_compare(raw, fmt):
        return PacePrecisionFormat.widen_fp_for_compare(raw, fmt)

    @staticmethod
    def widen_fp_for_fma(raw, fmt):
        return PacePrecisionFormat.widen_fp_for_fma(raw, fmt)

    @staticmethod
    def clean_value(value):
        return _clean_value(value)

    def algo_precision(self):
        return self.format.algo_precision()

    def numpy_type(self):
        return self.format.numpy_type()

    def model_precision(self):
        return self.format.model_precision()

    def c_type(self):
        return self.format.c_type()

    def hex_c_type(self):
        return self.format.hex_c_type()

    def storage_bits(self):
        return self.format.storage_bits()

    def storage_values(self, values, numpy_type=None):
        return self.format.storage_values(values, numpy_type)

    def quantize_model_values(self, values):
        return self.format.quantize_model_values(values)

    def lane_count(self, fpu_data_width):
        bits = self.storage_bits()
        if fpu_data_width % bits != 0:
            raise ValueError(
                f"FPU data width {fpu_data_width} is not divisible by element width {bits}"
            )
        lanes = fpu_data_width // bits
        if lanes < 1:
            raise ValueError(
                f"Invalid lane count {lanes} for prec={self.prec} and "
                f"fpu_data_width={fpu_data_width}"
            )
        return lanes

    def dtype_key(self):
        return self.format.dtype_key()

    def encode_coeff(self, coeff):
        return self.format.encode_coeff(coeff)

    def encode_breakpoint(self, bp):
        return self.format.encode_breakpoint(bp)

    def encode_eps_values(self, eps, eps_const):
        return self.format.encode_eps_values(eps, eps_const)


class PaceDataTypeHelper:
    """Typed view of a PACE precision string and hardware storage format."""

    FLOAT_FIELDS = {
        "FP32": dict(
            exp_bits=8, frac_bits=23, bias=127, storage=np.float32, uint=np.uint32
        ),
        "FP16": dict(
            exp_bits=5, frac_bits=10, bias=15, storage=np.float16, uint=np.uint16
        ),
        "BFP16": dict(
            exp_bits=8, frac_bits=7, bias=127, storage=np.float32, uint=np.uint16
        ),
        "BF16": dict(
            exp_bits=8, frac_bits=7, bias=127, storage=np.float32, uint=np.uint16
        ),
        "BFLOAT16": dict(
            exp_bits=8, frac_bits=7, bias=127, storage=np.float32, uint=np.uint16
        ),
    }

    def __init__(self, precision, super_fmt="FP32", fpu_data_width=64):
        self.precision = precision
        self.super_fmt = super_fmt
        self.fpu_data_width = fpu_data_width
        self.codec = PacePrecisionCodec(precision, super_fmt)

    @classmethod
    def from_config(cls, config):
        return cls(config.prec, config.super_fmt, config.fpu_data_width)

    @classmethod
    def is_bf16_precision(cls, precision):
        return PacePrecisionFormat.is_bf16_precision(precision)

    @classmethod
    def bf16_bits(cls, values):
        return PacePrecisionFormat.bf16_bits(values)

    @classmethod
    def quantize_values(cls, values, precision):
        if cls.is_bf16_precision(precision):
            return PacePrecisionFormat.bf16_values(values)
        return np.asarray(values, dtype=precision)

    @property
    def numpy_type(self):
        return self.codec.numpy_type()

    @property
    def model_precision(self):
        return self.codec.model_precision()

    @property
    def c_type(self):
        return self.codec.c_type()

    @property
    def hex_c_type(self):
        return self.codec.hex_c_type()

    @property
    def lane_count(self):
        return self.codec.lane_count(self.fpu_data_width)

    @property
    def storage_bits(self):
        return self.codec.storage_bits()

    @property
    def dtype_key(self):
        return self.codec.dtype_key()

    def quantize_model_values(self, values):
        return self.codec.quantize_model_values(values)

    def storage_values(self, values, numpy_type=None):
        return self.codec.storage_values(values, numpy_type)

    @property
    def float_fields(self):
        key = str(self.precision).upper()
        if key not in self.FLOAT_FIELDS:
            raise ValueError(f"Unsupported floating-point precision: {self.precision}")
        return self.FLOAT_FIELDS[key]

    @property
    def exponent_bits(self):
        return self.float_fields["exp_bits"]

    @property
    def fraction_bits(self):
        return self.float_fields["frac_bits"]

    @property
    def exponent_bias(self):
        return self.float_fields["bias"]

    @property
    def storage_type(self):
        return self.float_fields["storage"]

    @property
    def unsigned_type(self):
        return self.float_fields["uint"]

    def view_bits(self, values):
        arr = np.asarray(values, dtype=self.storage_type)
        if self.storage_type == np.float32 and self.unsigned_type == np.uint16:
            return ((arr.view(np.uint32) >> 16) & 0xffff).astype(np.uint16)
        return arr.view(self.unsigned_type)
